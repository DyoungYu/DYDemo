//
//  DyOtherAlgorithmTest.m
//  DYDemoTests
//
//  Created by company_2 on 2019/4/17.
//  Copyright © 2019 dyoung. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface DyOtherAlgorithmTest : XCTestCase

@property (nonatomic,strong) NSMutableArray *suc_proArr;
@property (nonatomic,strong) NSMutableArray *costArr;
@property (nonatomic,strong) NSArray *proArr;

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
/**
 有个一元抽奖的活动，每次抽奖只花费一元钱，用户等级初始为1，抽中则上升一个等级，没中就下降一个等级，每个等级抽中的概率分别为：
 1级：100%
 2级：50%
 3级：25%
 求用户平均得花费多少钱才能抽中3级？
 */
/**
 思路：
 暴利解法:
 把一个人去抽奖抽中三等奖的所有情况都计算一遍。
 每一种的情况出现的概率 * 所经历的步数(花费) 
 */
- (void)testPrizewinningProbability{
    
    _suc_proArr = @[].mutableCopy;//保存每次3级抽中的概率。
    _costArr = @[].mutableCopy;//保存每次3级抽中的花费。
    _proArr = @[@"1", @"0.5", @"0.25"];//每级抽中的概率。
    
    //开始抽奖。
    [self startDrawCurLevel:0 prob:1 totalStep:0];
    CGFloat averageCost = 0;
    for (int i=0; i<_suc_proArr.count; i++) {
        averageCost += [_suc_proArr[i] doubleValue] * [_costArr[i] doubleValue];
    }
    NSLog(@"🍺🍺🍺🍺🍺🍺平均消费 = %lf",averageCost);
}
/**
 每次的抽奖
 @param level 当前等级
 @param prob 但当前的概率。
 @param step 已进行的步骤数。
 */
- (void)startDrawCurLevel:(NSInteger)level prob:(CGFloat)prob totalStep:(NSInteger)step{
    
    CGFloat winPro = 0;
    CGFloat losePro = 0;
    
    if (level != 3) {
        winPro = [_proArr[level] floatValue];//当前级别的中奖概率
        losePro =  1 - winPro;//当期级别不中奖的概率
    }
    if (level == 3 || prob < 0.0000001) {
        [_suc_proArr addObject:@(prob)];
        [_costArr addObject:@(step)];
        return;
    }
    
    step += 1;
    [self startDrawCurLevel:level+1 prob:prob*winPro totalStep:step];
    if (level!=0)
        [self startDrawCurLevel:level-1 prob:prob*losePro totalStep:step];
}


@end
