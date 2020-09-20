//
//  DyLinkedListTest.m
//  DYDemoTests
//
//  Created by mac on 2020/9/20.
//  Copyright © 2020 dyoung. All rights reserved.
//

#import <XCTest/XCTest.h>

typedef struct node {
    char *data;
    struct node *next;
} node_t;

@interface DyLinkedListTest : XCTestCase

@end

@implementation DyLinkedListTest

- (void)testLinkedList {
    // a > b > c > d > 0
//    node_t d = {"d", 0}, c = {"c", &d}, b = {"b", &c}, a = {"a", &b};
//    printf("linked list: length = %d\n", list_len(&a));
    //
//    list_display(&a);
//    reverse(&a);
//    list_display(&d);
    //
//    printf("linked list: reverse 2 value =  %s\n", _kth(&a, 2) -> data);
    // 逆序打印链表
//    r_display(&a);
    
    // 判断链表是否有环：
//    node_t e = {"e", 0}, d = {"d", &e}, c = {"c", &d}, b = {"b", &c}, a = {"a", &b};
//    e.next = &a;
//    printf("linked list: has ring =  %d\n", any_ring(&a));
    
    // 找出环的入口点
//    node_t e = {"e", 0}, d = {"d", &e}, c = {"c", &d}, b = {"b", &c}, a = {"a", &b};
//    e.next = &d;
//    printf("linked list: entry point = %s\n", find_entry(&a)->data);
    
    // 找出两个链表的相交点：
//    node_t e = {"e", 0}, d = {"d", &e}, c = {"c", &d}, b = {"b", &c}, a = {"a", &b};
//    node_t z = {"z", &b}, y = {"y", &z}, x = {"x", &y};
//    printf("linked list: intersect %s\n", intersect_point(&a, &x)->data);
    
    // 右对齐打印
    node_t e = {"e", 0}, d = {"d", &e}, c = {"c", &d}, b = {"b", &c}, a = {"a", &b};
    node_t z = {"z", &b}, y = {"y", &z}, x = {"x", &y};
    foo(&a, &x);
}


/// 打印链表
void list_display(node_t *head)
{
    for (; head; head = head->next)
        printf("linked list: value %s \n", head->data);
    printf("linked list: over ======== \n");
}


/// 计算链表长度
int list_len(node_t *head)
{
    int i;
    for (i = 0; head; head = head->next, i++);
    return i;
}


/// 反转链表
void reverse(node_t *head)
{
    // t: 遍历链表
    // p: 临时变量、缓存t
    // q: 记录t的上一个节点值
    node_t *p = 0, *q = 0, *t = 0;
    for (t = head; t; p = t, t = t->next, p->next = q, q = p);
}


/// 查找倒数第n个元素
/// 算法:2个指针p, q初始化指向头结点.p先跑到k结点处, 然后q再开始跑, 当p跑到最后跑到尾巴时, q正好到达倒数第k个.复杂度O(n)
node_t* _kth(node_t *head, int k)
{
    int i = 0;
    node_t *p = head, *q = head;
    for (; p && i < k; p = p->next, i++);
    if (i < k) return 0;
    for (; p->next; p = p->next, q = q->next);
    return q;
}


/// 找出中间的那个结点
/// 算法:设两个初始化指向头结点的指针p, q.p每次前进两个结点, q每次前进一个结点, 这样当p到达链表尾巴的时候, q到达了中间.复杂度O(n)
node_t *middle(node_t *head)
{
    node_t *p, *q;
    for (p = q = head; p->next; p = p->next, q = q->next){
        p = p->next;
        if (!(p->next)) break;
    }
    return q;
}


/// 逆序打印链表
/// 给你链表的头结点, 逆序打印这个链表.使用递归(即让系统使用栈), 时间复杂度O(n)
void r_display(node_t *t)
{
    if (t){
        r_display(t->next);
        printf("linked list: r_display value = %s\n", t->data);
    }
}


/// 判断链表是否有环
/// 算法:设两个指针p, q, 初始化指向头.p以步长2的速度向前跑, q的步长是1.这样, 如果链表不存在环, p和q肯定不会相遇.如果存在环, p和q一定会相遇.(就像两个速度不同的汽车在一个环上跑绝对会相遇).复杂度O(n)
int any_ring(node_t *head)
{
    node_t *p, *q;
    for (p = q = head; p; p = p->next, q = q->next){
        p = p->next;
        if (!p) break;
        if (p == q) return 1; //yes
    }
    return 0; //fail find
}

/// 找出链表中环的入口结点
/**
 参考：https://jlice.top/p/7qhfm/
 设p为快指针，迭代速度为2
 设q为慢指针，迭代速度为1
 
 我们先假设以下值：
 n = 链表起点到环入口点的长度
 f  = 环入口点到p、q相遇点的位置的长度
 l  = 环的长度
  
  成立公式(x > 0)： 2 (n + f) = n + f + xl
  => n = xl - f
  当x>=0时，n = xl + l - f
 公式告诉我们，pq相遇后：
 将p从head部分以1的迭代速度出发（符合等式左边）
 q从相遇点以1的迭代速度出发，（符合等式右边）
 两者会相遇到环的入口点。
 */
node_t *find_entry(node_t *head)
{
    node_t *p, *q;
    for (p = q = head; p; p = p->next, q = q->next){
        p = p->next;
        if (!p) return 0; //no ring in list
        if (p == q) break;
    }
    for (p = head, q = q->next; q != p; p = p->next, q = q->next);
    return p;
}


/// 算法:两个指针遍历这两个链表,如果他们的尾结点相同,则必定相交.复杂度O(m+n)
/**
 其它方法1：
 暴力法：遍历这两个链表，判断第一个链表的每个节点是否在第二个链表中，这种做法的时间复杂度为$O(n^2)$。
 其它方法2：
 遍历一下这两个单链表，得到它们的长度， 让长的单链表的指针先走长度之差步
 其它方法3：
 先遍历其中一个链表，遍历到尾节点时，将尾节点的next指针指向另一个链表的起点，然后，问题就转化为求单链表中第一个在环里的节点。
 
 */
int is_intersect(node_t *a, node_t *b)
{
    if (!a || !b) return -1; //a or b is NULL
    for (; a->next; a = a->next);
    for (; b->next; b = b->next);
    return a == b ? 1 : 0; //return 1 for yes, 0 for no
}



/// 找出相交节点
/// 本质同上，其它方法2
/// 假设两个链表a,b.a比b长k个结点(k>=0).
/// 那么当a_ptr,b_ptr两个指针同时分别遍历a,b的时候, 必然b_ptr先到达结尾(NULL),而此时a_ptr落后a的尾巴k个结点.
/// 如果此时再从a的头发出一个指针t,继续和a_ptr 一起走,当a_ptr达到结尾(NULL)时,t恰好走了k个结点. （先走了长度之差步）
/// 此时从b的头发一个指针s, s和t一起走,因为a比b长k个结点,所以,t和s会一起到达交点.
node_t *intersect_point(node_t *a, node_t *b)
{
    node_t *p, *q, *k, *t, *s;
    for (p = a, q = b; p && q; p = p->next, q = q->next);
    
    k = (p == 0) ? q:p; //k record the pointer not NULL
    t = (p == 0) ? b:a; //if p arrive at tail first, t = b ; else p = a
    s = (p == 0) ? a:b;
    for (; k; k = k->next, t = t->next);
    for (; t != s; t = t->next, s = s->next);
    return t;
}



/// 右对齐打印
/// 本质同上
/// 1、计算两链表的差值
/// 2、先打印长的链表
/// 3、打印差值空格 + 打印短的链表
void foo(node_t *a, node_t *b)
{
    node_t *p, *q, *k, *t, *s;
    for (p = a, q = b; p && q; p = p->next, q = q->next);

    k = p?p:q;
    t = p?a:b;
    s = p?b:a;
    
    for (; t; printf("%s ", t->data), t = t->next); // 打印较长链表
    printf("\n");
    for (; k; printf("  "), k = k->next); // 为第二排打印空格
    for (; s; printf("%s ", s->data), s = s->next); // 打印较短的链表
}

@end
