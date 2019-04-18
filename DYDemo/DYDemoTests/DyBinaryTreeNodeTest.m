//
//  DyBinaryTreeNodeTest.m
//  DYDemoTests
//
//  Created by company_2 on 2019/4/18.
//  Copyright © 2019 dyoung. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DyBinaryTreeNode.h"

@interface DyBinaryTreeNodeTest : XCTestCase

@end

@implementation DyBinaryTreeNodeTest


- (void)testBinaryTreeBasic {
    
    //1、创建排序二叉树
    //没有键值相等的节点。
    NSArray *arr = [NSArray arrayWithObjects:@(7),@(6),@(3),@(2),@(1),@(9),@(10),@(12),@(14),@(4),@(15),nil];
    DyBinaryTreeNode *tree = [DyBinaryTreeNode new];
    tree = [DyBinaryTreeNode createTreeWithValues:arr];
    
    //2、获取二叉树某个位置上的节点（根据层序）
    DyBinaryTreeNode *tree1 = [DyBinaryTreeNode treeNodeAtIndex:8 inTree:tree];
    NSLog(@"节点值为==%ld\n",tree1.value);

    //3.1 先序遍历
    NSMutableArray *orderArray = [NSMutableArray array];
    [DyBinaryTreeNode preOrderTraverseTree:tree handler:^(DyBinaryTreeNode *treeNode) {
        [orderArray addObject:@(treeNode.value)];
    }];
    NSLog(@"先序遍历结果：%@\n", [orderArray componentsJoinedByString:@","]);
    
    //3.2 中序遍历
    NSMutableArray *orderArray1 = [NSMutableArray array];
    [DyBinaryTreeNode inOrderTraverseTree:tree handler:^(DyBinaryTreeNode *treeNode) {
        [orderArray1 addObject:@(treeNode.value)];
    }];
    NSLog(@"中序遍历结果：%@\n", [orderArray1 componentsJoinedByString:@","]);

    //3.3 后续遍历
    NSMutableArray *orderArray2 = [NSMutableArray array];
    [DyBinaryTreeNode postOrderTraverseTree:tree handler:^(DyBinaryTreeNode *treeNode) {
        [orderArray2 addObject:@(treeNode.value)];
    }];
    NSLog(@"后序遍历结果：%@\n", [orderArray2 componentsJoinedByString:@","]);

    //3.4 层序遍历
    NSMutableArray *orderArray3 = [NSMutableArray array];
    [DyBinaryTreeNode levelTraverseTree:tree handler:^(DyBinaryTreeNode *treeNode) {
        [orderArray3 addObject:@(treeNode.value)];
    }];
    NSLog(@"层次遍历结果：%@\n", [orderArray3 componentsJoinedByString:@","]);
    
    //4.1 递归翻转二叉树
    //7,9,10,12,14,15,6,3,4,2,1
    [DyBinaryTreeNode invertBinaryTree:tree];
    
    //4.2 非递归翻转二叉树-层序遍历。
    [DyBinaryTreeNode invertBinaryTreeNot:tree];
    
    
    //5.1 递归获取二叉树深度
    NSInteger depthNum = [DyBinaryTreeNode depthOfTree:tree];
    NSLog(@"深度为 == %ld\n",depthNum);
    
    //5.2 获取二叉树的宽度
    NSInteger widthNum = [DyBinaryTreeNode widthOfTree:tree];
    NSLog(@"宽度为 == %ld\n",widthNum);
    
    //5.3 获取二叉树的节点数 左+右+根1
    NSInteger allNodeNum = [DyBinaryTreeNode numberOfNodesInTree:tree];
    NSLog(@"总共节点数 == %ld\n",allNodeNum);
    
    //5.4 获取某一层的节点数。递归 上一层的左节点数+上一层的右节点数
    NSInteger someLevelNodeNum = [DyBinaryTreeNode numberOfNodesOnLevel:3 inTree:tree];
    NSLog(@"某一层的节点数==%ld\n",someLevelNodeNum);
    
    //5.5 获取叶子节点数  叶子数 = 左子树叶子数 + 右子树叶子数
    //左右子节点为空，+1。
    NSInteger leafNodesNum = [DyBinaryTreeNode numberOfLeafsInTree:tree];
    NSLog(@"叶子节点数 == %ld\n",leafNodesNum);
    
    //5.6 获取二叉树的最大直径
    NSInteger maxDistanceNum = [DyBinaryTreeNode maxDistanceOfTree:tree];
    NSLog(@"最大直径 == %ld\n",maxDistanceNum);
    

}

@end
