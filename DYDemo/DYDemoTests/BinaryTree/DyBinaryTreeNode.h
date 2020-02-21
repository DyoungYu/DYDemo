//
//  DyBinaryTreeNode.h
//  DYDemoTests
//
//  Created by company_2 on 2019/4/18.
//  Copyright © 2019 dyoung. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DyBinaryTreeNode : NSObject

@property (nonatomic, assign) NSInteger value;
@property (nonatomic, strong) DyBinaryTreeNode *leftNode;
@property (nonatomic, strong) DyBinaryTreeNode *rightNode;

#pragma mark 创建二叉树
//创建二叉树
+ (DyBinaryTreeNode *)createTreeWithValues:(NSArray *)values;
//二叉树中某个位置的节点（按层次遍历）
+ (DyBinaryTreeNode *)treeNodeAtIndex:(NSInteger)index inTree:(DyBinaryTreeNode *)rootNode;
//向二叉排序树节点添加一个节点
+ (DyBinaryTreeNode *)addTreeNode:(DyBinaryTreeNode *)treeNode value:(NSInteger)value;

#pragma mark 翻转二叉树
//翻转二叉树
+ (DyBinaryTreeNode *)invertBinaryTree:(DyBinaryTreeNode *)rootNode;
// 非递归方式翻转
+ (DyBinaryTreeNode *)invertBinaryTreeNot:(DyBinaryTreeNode *)rootNode;

#pragma mark 遍历二叉树
//先序遍历：先访问根，再遍历左子树，再遍历右子树。典型的递归思想。
+ (void)preOrderTraverseTree:(DyBinaryTreeNode *)rootNode handler:(void(^)(DyBinaryTreeNode *treeNode))handler;
//中序遍历:先遍历左子树，再访问根，再遍历右子树
+ (void)inOrderTraverseTree:(DyBinaryTreeNode *)rootNode handler:(void(^)(DyBinaryTreeNode *treeNode))handler;
//后序遍历:先遍历左子树，再遍历右子树，再访问根
+ (void)postOrderTraverseTree:(DyBinaryTreeNode *)rootNode handler:(void(^)(DyBinaryTreeNode *treeNode))handler;
//层次遍历（广度优先)
+ (void)levelTraverseTree:(DyBinaryTreeNode *)rootNode handler:(void(^)(DyBinaryTreeNode *treeNode))handler;

#pragma mark 二叉树的属性
//二叉树的宽度
+ (NSInteger)widthOfTree:(DyBinaryTreeNode *)rootNode;
//获取二叉树的深度
+ (NSInteger)depthOfTree:(DyBinaryTreeNode *)rootNode;
//二叉树的所有节点数
+ (NSInteger)numberOfNodesInTree:(DyBinaryTreeNode *)rootNode;
//二叉树某层中的节点数
+ (NSInteger)numberOfNodesOnLevel:(NSInteger)level inTree:(DyBinaryTreeNode *)rootNode;
//二叉树叶子节点数
+ (NSInteger)numberOfLeafsInTree:(DyBinaryTreeNode *)rootNode;
//二叉树最大距离（直径）
+ (NSInteger)maxDistanceOfTree:(DyBinaryTreeNode *)rootNode;


@end

NS_ASSUME_NONNULL_END
