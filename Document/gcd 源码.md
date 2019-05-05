## 0x01 dispatch_queue_create

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

+ 核心方法2

拼接

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

+ 核心方法3

构造一个`dispatch_lane_t`对象并进行设置

```
#define DISPATCH_QUEUE_WIDTH_FULL			0x1000ull
#define DISPATCH_QUEUE_WIDTH_MAX  (DISPATCH_QUEUE_WIDTH_FULL - 2)
```

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

断点，po以下两个对象。

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

分析得知:

`OS_dispatch_queue_serial: com.doungser.cn`:为上面宏定义拼接出来的结果。

`width`的大小决定是同步还是并发，对应源码`dqai.dqai_concurrent ?DISPATCH_QUEUE_WIDTH_MAX : 1`。



## 0x02 dispatch_get_main_queue && dispatch_get_global_queue

在上述方法中,有如下代码实现：

```
//tq==DISPATCH_TARGET_QUEUE_DEFAULT target类型
if (!tq) {
		tq = _dispatch_get_root_queue(
		//DISPATCH_QOS_DEFAULT的值为4.
				qos == DISPATCH_QOS_UNSPECIFIED ? DISPATCH_QOS_DEFAULT : qos, // 4
				overcommit == _dispatch_queue_attr_overcommit_enabled)->_as_dq; // 0 1
		if (unlikely(!tq)) {
			DISPATCH_CLIENT_CRASH(qos, "Invalid queue attribute");
		}
	}
```

```
//_dispatch_root_queues在这个初始化的静态数组中根据下标取值。
//数组中装了target_queue 
_dispatch_get_root_queue(dispatch_qos_t qos, bool overcommit)
{
	if (unlikely(qos < DISPATCH_QOS_MIN || qos > DISPATCH_QOS_MAX)) {
		DISPATCH_CLIENT_CRASH(qos, "Corrupted priority");
	}
	// 4-1= 3
	// 2*3+0/1 = 6/7
	return &_dispatch_root_queues[2 * (qos - 1) + overcommit];
}
```

下图是数组的初始化。默认初始化了一个静态数组。

![image-20190504230511793](/Users/double/Library/Application Support/typora-user-images/image-20190504230511793.png)

通过打印主队列和全局队列对象：

```
dispatch_queue_t queueMain = dispatch_get_main_queue();
dispatch_queue_t queueglob = dispatch_get_global_queue(0, 0);
```

log:

```
(lldb) po queueMain
<OS_dispatch_queue_main: com.apple.main-thread[0x110358a80] = { xref = -2147483648, ref = -2147483648, sref = 1, target = com.apple.root.default-qos.overcommit[0x110358f00], width = 0x1, state = 0x001ffe9000000300, dirty, in-flight = 0, thread = 0x303 }>
(lldb) po queueglob
<OS_dispatch_queue_global: com.apple.root.default-qos[0x110358e80] = { xref = -2147483648, ref = -2147483648, sref = 1, target = [0x0], width = 0xfff, state = 0x0060000000000000, in-barrier}>
```

分析可知：

1、全局队列`width = 0xfff`:在上图中的宏中有定义width的宽度为下面的宏。

```
#define DISPATCH_QUEUE_WIDTH_POOL (DISPATCH_QUEUE_WIDTH_FULL - 1)
```

2、全局队列的target为`[0x0]`,其他queue的target为静态数组中取值出来的。

+ 获取全局队列的内部实现：

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

而其它的并发队列是通过`alloc`创建的。

```
dispatch_lane_t dq = _dispatch_object_alloc(vtable,
			sizeof(struct dispatch_lane_s));
```

+ 主队列的内部实现。

```
dispatch_get_main_queue(void)
{
	return DISPATCH_GLOBAL_OBJECT(dispatch_queue_main_t, _dispatch_main_q);
}
```

```
#define DISPATCH_GLOBAL_OBJECT(type, object) ((OS_OBJECT_BRIDGE type)&(object))
```

_dispatch_main_q： 通过结构体赋值。

```
struct dispatch_queue_static_s _dispatch_main_q = {
	DISPATCH_GLOBAL_OBJECT_HEADER(queue_main),
#if !DISPATCH_USE_RESOLVERS
	.do_targetq = _dispatch_get_default_queue(true),
#endif
	.dq_state = DISPATCH_QUEUE_STATE_INIT_VALUE(1) |
			DISPATCH_QUEUE_ROLE_BASE_ANON,
	.dq_label = "com.apple.main-thread",
	.dq_atomic_flags = DQF_THREAD_BOUND | DQF_WIDTH(1),
	.dq_serialnum = 1,
};
```



