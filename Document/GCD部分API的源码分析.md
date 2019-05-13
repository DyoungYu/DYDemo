# GCD部分API的源码分析

## 前言

之前已经尝试对GCD的各个API进行了简单的实践总结，并记录为[博客](https://yudongyang.win/2018/08/07/iOS%E5%A4%9A%E7%BA%BF%E7%A8%8B-GCD%E5%9F%BA%E7%A1%80%E5%AE%9E%E8%B7%B5/#more),为深入研究，决定硬着头皮读一读[GCD的源码-libdispatch-1008.220.2](https://github.com/DyoungYu/SourceCode/tree/master/libdispatch-1008.220.2)。
源码很难，嵌套很深，本文只是针对GCD常见API的底层实现作简单总结笔记，记录自己的一些理解。

## 前期了解

### 结构体
GCD的类都是struct定义的。但并不像runtime一样，直接使用:来继承定义。而是将所有的父类的数据成员，都平铺重复的写在一个个的struct中，这样做的好处应该是为了提高效率。

+ 基类dispatch_object_t的定义：

> 如下，是一个联合，可以表示其中的任意类型，同OC中的基类指针。

```
typedef union {
    struct _os_object_s *_os_obj;
    struct dispatch_object_s *_do;
    struct dispatch_continuation_s *_dc;
    struct dispatch_queue_s *_dq;
    struct dispatch_queue_attr_s *_dqa;
    struct dispatch_group_s *_dg;
    struct dispatch_source_s *_ds;
    struct dispatch_mach_s *_dm;
    struct dispatch_mach_msg_s *_dmsg;
    struct dispatch_source_attr_s *_dsa;
    struct dispatch_semaphore_s *_dsema;
    struct dispatch_data_s *_ddata;
    struct dispatch_io_s *_dchannel;
    struct dispatch_operation_s *_doperation;
    struct dispatch_disk_s *_ddisk;
} dispatch_object_t DISPATCH_TRANSPARENT_UNION;

```


+ dispatch_continuation_s

我们向queue提交的任务，无论block还是function形式，最终都会被封装为dispatch_continuation_s。

```
struct dispatch_continuation_s {
    DISPATCH_CONTINUATION_HEADER(dispatch_continuation_s);
    dispatch_group_t    dc_group;
    void *              dc_data[3];
};

#define DISPATCH_CONTINUATION_HEADER(x) \
    const void *        do_vtable;  \
    struct x *volatile  do_next;    \
    dispatch_function_t dc_func;    \
    void *          dc_ctxt
```

+ dispatch_object_s


dispatch_object_s结构体是整个GCD的基类，地位十分重要，

```
struct dispatch_object_s {
    DISPATCH_STRUCT_HEADER(dispatch_object_s, dispatch_object_vtable_s);
};

#define DISPATCH_STRUCT_HEADER(x, y)        \
    const struct y *do_vtable;      \   // 这个结构体内包含了这个 dispatch_object_s 的操作函数
    struct x *volatile do_next;     \   // 链表的 next
    unsigned int do_ref_cnt;        \   // 引用计数
    unsigned int do_xref_cnt;       \   // 外部引用计数
    unsigned int do_suspend_cnt;        \   // suspend计数，用作暂停标志，比如延时处理的任务，设置该引用计数之后；在任务到时后，计时器处理将会将该标志位修改，然后唤醒队列调度
    struct dispatch_queue_s *do_targetq;\   // 目标队列，就是当前这个struct x在哪个队列运行
    void *do_ctxt;                      \   // 上下文，我们要传递的参数
    void *do_finalizer
```

+ dispatch_queue_s

dispatch_queue_s 和 dispatch_object_s 差别在于 dispatch_queue_s 多了DISPATCH_QUEUE_HEADER 和 dq_label[DISPATCH_QUEUE_MIN_LABEL_SIZE]，我们从中也可以看出，我们队列起名要少于64个字符

```
#define DISPATCH_QUEUE_MIN_LABEL_SIZE   64

#define DISPATCH_QUEUE_HEADER \
    uint32_t dq_running; \
    uint32_t dq_width; \
    struct dispatch_object_s *dq_items_tail; \
    struct dispatch_object_s *volatile dq_items_head; \
    unsigned long dq_serialnum; \
    void *dq_finalizer_ctxt; \
    dispatch_queue_finalizer_function_t dq_finalizer_func

struct dispatch_queue_s {
    DISPATCH_STRUCT_HEADER(dispatch_queue_s, dispatch_queue_vtable_s);
    DISPATCH_QUEUE_HEADER;
    char dq_label[DISPATCH_QUEUE_MIN_LABEL_SIZE];   // must be last
};
```

### 一些宏定义
+ 对变量的定义一般遵循以下格式：

```
#define DISPATCH_DECL(name) typedef struct name##_s *name##_t
``` 
如：`DISPATCH_DECL(dispatch_queue)`，展开后为：

```
typedef struct dispatch_queue_s *dispatch_queue_t;  

```
这行代码定义了一个 dispatch_queue_t 类型的指针，指向一个 dispatch_queue_s 类型的结构体。

+ TSD

TSD(Thread-Specific Data) 表示线程私有数据。在 C++ 中，全局变量可以被所有线程访问，局部变量只有函数内部可以访问。而 TSD 的作用就是能够在同一个线程的不同函数中被访问。在不同线程中，虽然名字相同，但是获取到的数据随线程不同而不同。

通常，我们可以利用 POSIX 库提供的 API 来实现 TSD:

```
int pthread_key_create(pthread_key_t *key, void (*destr_function) (void *))  

```

这个函数用来创建一个 key，在线程退出时会将 key 对应的数据传入 destr_function 函数中进行清理。

我们分别使用 get/set 方法来访问/修改 key 对应的数据:

```
int  pthread_setspecific(pthread_key_t  key,  const   void  *pointer)  
void * pthread_getspecific(pthread_key_t key)  
```
在 GCD 中定义了六个 key，根据名字大概能猜出各自的含义:

```
pthread_key_t dispatch_queue_key;  
pthread_key_t dispatch_sema4_key;  
pthread_key_t dispatch_cache_key;  
pthread_key_t dispatch_io_key;  
pthread_key_t dispatch_apply_key;  
pthread_key_t dispatch_bcounter_key;  

```

+ fastpath && slowpath

这是定义在 `internal.h `中的两个宏:
>fastpath表示条件更可能成立，slowpath表示条件更不可能成立

```
#define fastpath(x) ((typeof(x))__builtin_expect((long)(x), ~0l))
#define slowpath(x) ((typeof(x))__builtin_expect((long)(x), 0l))
```

## API分析

### dispatch_queue_create

无论是自己创建还是获取系统定义的queue，只会在GCD启动时创建的root queue数组中，取得一个queue而已。

```
dispatch_queue_create(const char *label, dispatch_queue_attr_t attr)
{
	return _dispatch_lane_create_with_target(label, attr,
			DISPATCH_TARGET_QUEUE_DEFAULT, true);
}
```
核心方法：

```
_dispatch_lane_create_with_target(const char *label, dispatch_queue_attr_t dqa,
		dispatch_queue_t tq, bool legacy){}
```

以下方法都在核心方法中。

+ 核心方法1

```
dispatch_queue_attr_info_t dqai = _dispatch_queue_attr_to_info(dqa);
```
全局搜索`_dispatch_queue_attr_to_info`

```
_dispatch_queue_attr_to_info(dispatch_queue_attr_t dqa)
{
	//1、如果dqa为空，返回空的结构体。
	dispatch_queue_attr_info_t dqai = { };

	if (!dqa) return dqai;
	
		if (dqa < _dispatch_queue_attrs ||
			dqa >= &_dispatch_queue_attrs[DISPATCH_QUEUE_ATTR_COUNT]) {
		DISPATCH_CLIENT_CRASH(dqa->do_vtable, "Invalid queue attribute");
	}

	// 2、根据结构体位域的设置进行区分
	size_t idx = (size_t)(dqa - _dispatch_queue_attrs);

	dqai.dqai_inactive = (idx % DISPATCH_QUEUE_ATTR_INACTIVE_COUNT);
	idx /= DISPATCH_QUEUE_ATTR_INACTIVE_COUNT;
.
.
.
	return dqai;
```

+ 核心方法2 - 拼接

```
//根据核心方法1返回的结构体属性进行判断。
if (dqai.dqai_concurrent) {
		// 通过dqai.dqai_concurrent 来区分并发和串行
		// DISPATCH_VTABLE 这个宏在底层会生成如下类
		// OS_dispatch_queue_concurrent_class
		vtable = DISPATCH_VTABLE(queue_concurrent);
	} else {
		vtable = DISPATCH_VTABLE(queue_serial);
	}
	
```
宏`DISPATCH_VTABLE` ==> `DISPATCH_OBJC_CLASS` ==> `DISPATCH_CLASS_SYMBOL`

```
DISPATCH_CLASS_SYMBOL(name) OS_dispatch_##name##_class

```
+ 核心方法3 - 构造一个`dispatch_lane_t`对象并进行设置

```
//开辟内存 - 生成响应的对象 queue
//根据核心方法2中的vtable。
	dispatch_lane_t dq = _dispatch_object_alloc(vtable,
			sizeof(struct dispatch_lane_s));
	// 构造方法
	_dispatch_queue_init(dq, dqf, dqai.dqai_concurrent ?
			DISPATCH_QUEUE_WIDTH_MAX : 1, DISPATCH_QUEUE_ROLE_INNER |
			(dqai.dqai_inactive ? DISPATCH_QUEUE_INACTIVE : 0));
	// 标签
	dq->dq_label = label;
	// 优先级
	dq->dq_priority = _dispatch_priority_make((dispatch_qos_t)dqai.dqai_qos,
			dqai.dqai_relpri);
	//target类型
	dq->do_targetq = tq;
	
```
#### 打印队列

打印以下两个对象：

```
dispatch_queue_t queueSer = dispatch_queue_create("com.doungser.cn", NULL);
dispatch_queue_t queueCon = dispatch_queue_create("com.doungcon.cn", DISPATCH_QUEUE_CONCURRENT);
```
log如下：

```
(lldb) po queueSer
<OS_dispatch_queue_serial: com.doungser.cn[0x600002e17580] = { xref = 1, ref = 1, sref = 1, target = com.apple.root.default-qos.overcommit[0x1088a7f00], width = 0x1, state = 0x001ffe2000000000, in-flight = 0}>

(lldb) po queueCon
<OS_dispatch_queue_concurrent: com.doungcon.cn[0x600002e17500] = { xref = 1, ref = 1, sref = 1, target = com.apple.root.default-qos[0x1088a7e80], width = 0xffe, state = 0x0000041000000000, in-flight = 0}>

```
1、`OS_dispatch_queue_serial: com.doungser.cn:`为上面宏定义拼接出来的结果。
2、根据`width`的大小可看出是否是并发队列，当为并发时，width = 0xffe，根据下面的宏定义得来：

```
#define DISPATCH_QUEUE_WIDTH_FULL			0x1000ull
#define DISPATCH_QUEUE_WIDTH_MAX  (DISPATCH_QUEUE_WIDTH_FULL - 2)

```

### dispatch_get_main_queue
可以看到`dispatch_get_main_queue`实际上是一个宏，它返回的是结构体_dispatch_main_q的地址。

main queue设置了并发数为1，即串行队列,并且将targetq指向com.apple.root.default-overcommit-priority队列。

```
#define dispatch_get_main_queue() (&_dispatch_main_q)

```
```
struct dispatch_queue_s _dispatch_main_q = {
    .do_vtable = &_dispatch_queue_vtable,
    .do_ref_cnt = DISPATCH_OBJECT_GLOBAL_REFCNT,
    .do_xref_cnt = DISPATCH_OBJECT_GLOBAL_REFCNT,
    .do_suspend_cnt = DISPATCH_OBJECT_SUSPEND_LOCK,
    .do_targetq = &_dispatch_root_queues[DISPATCH_ROOT_QUEUE_COUNT / 2],

    .dq_label = "com.apple.main-thread",
    .dq_running = 1,
    .dq_width = 1,
    .dq_serialnum = 1,
};
```

### dispatch_get_global_queue

全局队列`width = 0xfff`。

```
dispatch_get_global_queue(long priority, unsigned long flags)
{
	dispatch_assert(countof(_dispatch_root_queues) ==
			DISPATCH_ROOT_QUEUE_COUNT);

	if (flags & ~(unsigned long)DISPATCH_QUEUE_OVERCOMMIT) {
		return DISPATCH_BAD_INPUT;
	}
	dispatch_qos_t qos = _dispatch_qos_from_queue_priority(priority);
#if !HAVE_PTHREAD_WORKQUEUE_QOS
	if (qos == QOS_CLASS_MAINTENANCE) {
		qos = DISPATCH_QOS_BACKGROUND;
	} else if (qos == QOS_CLASS_USER_INTERACTIVE) {
		qos = DISPATCH_QOS_USER_INITIATED;
	}
#endif
	if (qos == DISPATCH_QOS_UNSPECIFIED) {
		return DISPATCH_BAD_INPUT;
	}
	//直接去root_queue中获取。
	return _dispatch_get_root_queue(qos, flags & DISPATCH_QUEUE_OVERCOMMIT);
}
```
我们当前分析的libdispatch定义了8个全局队列

```
static struct dispatch_queue_s _dispatch_root_queues[] = {...}
```



##参考链接

[凌云-GCD源码分析](http://lingyuncxb.com/tags/GCD/)

[深入浅出GCD](http://cocoa-chen.github.io/2018/03/01/%E6%B7%B1%E5%85%A5%E6%B5%85%E5%87%BAGCD%E4%B9%8B%E5%9F%BA%E7%A1%80%E7%AF%87/)

[深入理解GCD](https://bestswifter.com/deep-gcd/)

[GCD源码吐血分析(1)——GCD Queue](https://blog.csdn.net/u013378438/article/details/81031938)

