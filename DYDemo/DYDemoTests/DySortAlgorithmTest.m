//
//  DySortAlgorithmTest.m
//  DYDemoTests
//
//  Created by company_2 on 2019/4/17.
//  Copyright © 2019 dyoung. All rights reserved.
//

#import <XCTest/XCTest.h>
#define EXCHANGE(num1, num2)  { num1 = num1 ^ num2;\
num2 = num1 ^ num2;\
num1 = num1 ^ num2;}

@interface DySortAlgorithmTest : XCTestCase

@end

@implementation DySortAlgorithmTest

#pragma mark ========================
#pragma mark ==排序算法
#pragma mark ========================
- (void)testAlgorithm {
    int num[] = {0,3,8,2,4,0,39,4,9,8,9,0,2,33};
    int count = sizeof(num)/4;
    
    //    buddleSort(num,count);
    //    selectSort(num,count);
    //    insertSort2(num,count);
    //    insertSortBinary(num, count);
    //    shellSort(num,count);
    //     heapSort(num,count);
    
    quickSort(num,count,0,count-1);
    printArr(num,count);
    
    
}


/**
 打印数组
 */
void printArr(int num[],int count) {
    printf("\n\n========================================\n\n");
    for (int i = 0; i < count; i++) {
        printf("%d,",num[i]);
    }
    printf("\n\n========================================\n\n");
}

#pragma mark 冒泡排序:n*n，最好是n  稳定
//找最大，放到最后面。一个一个冒。
void buddleSort(int num[],int count)
{
    //    {0,3,8,2,4,0,39,4,9,8,9,0,2,33};
    for (int i = 0; i < count - 1; i++) {//i的值只是为了更改j的右边临界值。
        for (int j = 0; j < count - i - 1; j++) {
            if (num[j] > num[j + 1]) EXCHANGE(num[j], num[j + 1]);
        }
    }
    printArr(num,count);
}

#pragma mark 快排 最差为O(logn2)，平均最好为O(nlogn)
//冒泡的改进{0,3,8,2,4,0,39,4,9,8,9,0,2,33};
//步骤：
//1、给定起始位置left和right。
//2、从右至左遍历，与left的值比较，如果小放left的位置，left后面的位置依次加一，lp+1。
//3、再分别计算左边和右边。
void quickSort(int num[],int count,int left,int right)
{
    if (left >= right){
        return ;
    }
    int key = num[left];//以left位置的数为基准。
    int lp = left;           //左指针
    int rp = right;          //右指针
    while (lp < rp) {
        if (num[rp] < key) {
            int temp = num[rp];
            for (int i = rp - 1; i >= lp; i--) {
                num[i + 1] = num[i];
            }
            num[lp] = temp;
            lp ++;
            rp ++;
        }
        rp --;
    }
    quickSort(num,count,left,lp - 1);//左边。
    quickSort(num,count,rp + 1,right);//右边。
}

#pragma mark 选择排序:都是n*n 不稳定
//找最小、放到最前面。比最小的小，直接交换。
//步骤：
//1、顺序遍历数组。定义当前i的元素最小。
//2、遍历i后面的元素，将最小的元素放到i的位置。
void selectSort(int num[],int count)
{
    for (int i = 0; i < count; i++) {
        int min = i;
        for (int j = i; j < count; j++) {
            if (num[j] < num[min])  min = j;
        }
        if (i != min)   EXCHANGE(num[i], num[min]);//可以看出，最多交换count - 1次
    }
    //打印
    printArr(num,count);
}


#pragma mark 直接插入排序 时间复杂度同冒泡 稳定
//适用于少量数据的排序
//左边始终是有序的。
//步骤：
//1、遍历数组，找到比上一个元素小的元素A。
//2、遍历A元素之前的数组，如果大于A就后移一位。小于就停止遍历。
//3、将A放到合适的位置。
void insertSort2(int num[],int count)
{
    int i,j;
    for (i = 1; i < count; i++) {
        if (num[i] < num[i - 1]) {
            int temp = num[i];
            for (j = i; j > 0; j--) {
                if (num[j - 1] > temp) num[j] = num[j - 1];
                else break;
            }
            num[j] = temp;
        }
    }
    //打印
    printArr(num,count);
}

#pragma mark 二分插入排序 o(nlogn) o(n²) 稳定
//适用于数据量比较大的情况。
//左边始终是有序的。
//步骤：
//1、遍历数组，找到比上一个元素小的元素A。
//2、用A循环比较（0-A）/2中间元素，找到A合适的位置。
//3、将A放到合适的位置，将合适位置到A位置的所有元素后移。
void insertSortBinary(int num[],int count)
{
    //    {0,3,8,2,4,0,39,4,9,8,9,0,2,33};
    int i,j;
    for (i = 1; i < count; i++) {
        if (num[i] < num[i - 1]) {//如果小于前面的数。坐标前面的数都是有序的。
            int temp = num[i];//i=3,temp=2,
            int left = 0,right = i - 1;//定义开始到i之前的位置。
            while (left <= right) {
                int mid = (left + right)/2;//找到前面中间坐标。
                if (num[mid] < temp) left = mid + 1;//如果中间的数小于temp-3，接着遍历中间数+1后的值
                else right = mid - 1;//如果中间数大于temp-3，遍历中间数-1前面的值。
            }
            //只是比较次数变少了，交换次数还是一样的
            for (j = i; j > left; j--) {
                num[j] = num[j - 1];//temp之前到left的位置都依次后移。
            }
            num[left] = temp;//将temp放到合适的位置
        }
    }
    //==============打印
    printArr(num,count);
}

#pragma mark 希尔插入排序。 非稳定 O(n^（1.3—2）)
/**
 希尔排序(Shell's Sort)是插入排序的一种又称“缩小增量排序”（Diminishing Increment Sort），是直接插入排序算法的一种更高效的改进版本
 */
//直接插入排序算法的改进
//步骤：
//1、设置希尔值（2）,将数组以节点gap平分两份
//2、从节点遍历至数组结尾，如果（i）元素的值小于(节点+i)的值，替换两个位置。
//3、重设节点值 >> gap = round(gap/shellNum);
void shellSort(int num[],int count)
{
    int shellNum = 2;
    int gap = round(count/shellNum);
    //     {0,0,0,2,3,8,33,4,9,8,9,4,2,39};
    while (gap > 0) {
        for (int i = gap; i < count; i++) {
            int temp = num[i];//2
            int j = i;
            while (j >= gap && num[j - gap] > temp) {
                num[j] = num[j - gap];
                j = j - gap;
                num[j] = temp;
            }
        }
        gap = round(gap/shellNum);
    }
    //==============打印
    printArr(num,count);
}

#pragma mark 堆排序 O(nlogn) 非稳定
//是指利用堆这种数据结构所设计的一种排序算法。堆是一个近似完全二叉树的结构，并同时满足堆积的性质：即子结点的键值或索引总是小于（或者大于）它的父节点
void heapSort(int num[], int count) {
    int i;
    //初始化，i从最後一个父节点开始调整
    for (i = count / 2 - 1; i >= 0; i--)
        maxHeapify(num, i, count - 1);
    //先将第一个元素和已排好元素前一位做交换，再重新调整，直到排序完毕
    for (i = count - 1; i > 0; i--) {
        EXCHANGE(num[0], num[i])
        maxHeapify(num, 0, i - 1);
    }
    
    //打印
    printArr(num,count);
}
void maxHeapify(int num[], int start, int end) {
    //建立父节点指标和子节点指标
    int dad = start;
    int son = dad * 2 + 1;
    while (son <= end) { //若子节点指标在范围内才做比较
        if (son + 1 <= end && num[son] < num[son + 1]) //先比较两个子节点大小，选择最大的
            son++;
        if (num[dad] > num[son]) //如果父节点大於子节点代表调整完毕，直接跳出函数
            return;
        else { //否则交换父子内容再继续子节点和孙节点比较
            EXCHANGE(num[dad], num[son])
            dad = son;
            son = dad * 2 + 1;
        }
    }
}




@end
