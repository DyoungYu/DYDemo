//
//  DyOtherAlgorithmTest.m
//  DYDemoTests
//
//  Created by company_2 on 2019/4/17.
//  Copyright © 2019 dyoung. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface DyOtherAlgorithmTest : XCTestCase

@end

@implementation DyOtherAlgorithmTest

#pragma mark 求最大公约数
- (void)testCommonDivisor{
    printf("最大公约数===%d\n",maxCommonDivisor(234,24));
}

int maxCommonDivisor(int a, int b) {
    int r;
    while(a % b > 0) {
        r = a % b;//20、  16、4、
        a = b;    //a=36、20、16
        b = r;    //b=20、16、4
    }
    return b;
}


#pragma mark 二分查找
- (void)testFindNum{
    int num[] = {1,4,4,6,8,9,9,9,11,21,211,2222};//要针对是有序序列。
    int count = sizeof(num)/4;
//    printf("num == %d\n",findKey(num,count,4));//这种只能找到一个。
    printf("🍺🍺🍺🍺num == %d\n",find_first_elem(num, 0, count-1, 99));
}

/**
 找到某个元素第一次出现的位置。
 */
int find_first_elem(int arr[],int low,int high,int elem)
{
    if (low>high){
        return -1;
    }
    int mid = low + (high-low)/2;
    if (arr[mid] == elem){
        int index = find_first_elem(arr,low,mid-1,elem);//递归思想。看mid之前有木有
        return (index == -1?mid:index);
    }
    else//找不到。
        if (arr[mid]>elem)
        return find_first_elem(arr,low,mid-1,elem);
        return find_first_elem(arr,mid+1,high,elem);
}



int findKey(int *arr, int length, int key) {
    int min = 0, max = length - 1, mid;
    while (min <= max) {
        mid = (min + max) / 2; //计算中间值
        if (key > arr[mid]) {
            min = mid + 1;
        } else if (key < arr[mid]) {
            max = mid - 1;
        } else {
            return mid;
        }
    }
    return -1;
}

#pragma mark 模拟栈操作
- (void)testStack{
    push(5);
    push(11);
    push(12);
    push(134);
    push(144);
    
    printf("出栈===%d\n",pop());
    printf("栈顶元素===%d",top());
}

static int data[1024];
static int count = 0;
//1、入栈
void push(int x){
    //    assert(!full());//防止数组越界
    data[count++] = x;
}
//2、出栈
int pop(){
    //    assert(!empty());
    return data[--count];
}
//查看栈顶元素
int top(){
    //    assert(!empty());
    return data[count-1];
}



#pragma mark 中奖概率题



@end
