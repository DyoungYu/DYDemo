//
//  DyBinaryTreeNode.m
//  DYDemoTests
//
//  Created by company_2 on 2019/4/18.
//  Copyright © 2019 dyoung. All rights reserved.
//

#import "DyBinaryTreeNode.h"

@implementation DyBinaryTreeNode


#pragma mark 创建二叉树
/**
 *  创建二叉排序树、二叉查找树、二叉搜索树
 //wiki  Binary Search Tree
 //https://zh.wikipedia.org/wiki/%E4%BA%8C%E5%85%83%E6%90%9C%E5%B0%8B%E6%A8%B9
 *  1、若任意节点的左子树不空，则左子树上所有节点的值均小于它的根节点的值；
    2、若任意节点的右子树不空，则右子树上所有节点的值均大于它的根节点的值；
    3、任意节点的左、右子树也分别为二叉查找树；
    4、没有键值相等的节点。
 *  @param values 数组
 *  @return 二叉树根节点
 */
+ (DyBinaryTreeNode *)createTreeWithValues:(NSArray *)values {
    DyBinaryTreeNode *root = nil;
    for (NSInteger i=0; i<values.count; i++) {
        NSInteger value = [(NSNumber *)[values objectAtIndex:i] integerValue];
        root = [DyBinaryTreeNode addTreeNode:root value:value];
    }
    return root;
}

/**
 *  向二叉排序树节点添加一个节点（递归）
 *
 *  @param treeNode 根节点
 *  @param value    值
 *
 *  @return 根节点
 */
//@(7),@(6),@(3),@(2),@(1),@(9),@(10),@(12),@(14),@(4),@(14), nil];
+ (DyBinaryTreeNode *)addTreeNode:(DyBinaryTreeNode *)treeNode value:(NSInteger)value {
    //根节点不存在，创建节点
    if (!treeNode) {
        NSLog(@"root node:%@\n", @(value));
        treeNode = [DyBinaryTreeNode new];
        treeNode.value = value;
    }
    //值小于根节点，则插入到左子树
    else if (value < treeNode.value) {
        NSLog(@"to left node:%@\n",@(value));
        treeNode.leftNode = [DyBinaryTreeNode addTreeNode:treeNode.leftNode value:value];
    }
    else if (value == treeNode.value){
        NSLog(@"排序二叉树没有键值相等的节点");
    }
    //值大于根节点，则插入到右子树
    else {
        NSLog(@"to right node:%@",@(value));
        treeNode.rightNode = [DyBinaryTreeNode addTreeNode:treeNode.rightNode value:value];
    }
    return treeNode;
}
/**
 *  二叉树中某个位置的节点（按层次遍历）
 整体排序：从上至下，从左至右。
 *  思路：
 1、将根节点加到队列中，当队列有元素时循环。
 2、循环一次将队列的第一个元素出队列，index-1
 3、当index=0时返回此时的根节点。
 4、遍历队列第一个元素(根节点)的左节点和右节点，加到队列中。
 *  @param index    按层次遍历树时的位置(从0开始算)
 *  @param rootNode 树根节点
 *
 *  @return 节点
 */
+ (DyBinaryTreeNode *)treeNodeAtIndex:(NSInteger)index inTree:(DyBinaryTreeNode *)rootNode {
    //按层次遍历
    if (!rootNode || index < 0) {
        return nil;
    }
    //数组当成队列
    NSMutableArray *queueArray = [NSMutableArray array];
    //压入根节点
    [queueArray addObject:rootNode];
    while (queueArray.count > 0) {
        DyBinaryTreeNode *node = [queueArray firstObject];
        if (index == 0) {//返回根节点。
            return node;
        }
        //弹出最前面的节点，仿照队列先进先出原则
        [queueArray removeObjectAtIndex:0];
        //移除节点，index减少
        index--;
        if (node.leftNode) {
            [queueArray addObject:node.leftNode]; //压入左节点
        }
        if (node.rightNode) {
            [queueArray addObject:node.rightNode]; //压入右节点
        }
    }
    //层次遍历完，仍然没有找到位置，返回nil
    return nil;
}


#pragma mark 翻转二叉树
/**
 * 翻转二叉树（又叫：二叉树的镜像）
 *
 * @param rootNode 根节点
 *
 * @return 翻转后的树根节点（其实就是原二叉树的根节点）
 */
+ (DyBinaryTreeNode *)invertBinaryTree:(DyBinaryTreeNode *)rootNode {
    if (!rootNode) {
        return nil;
    }
    if (!rootNode.leftNode && !rootNode.rightNode) {
        return rootNode;
    }
    //交换当前节点的左右节点。
    DyBinaryTreeNode *tempNode = rootNode.leftNode;
    rootNode.leftNode = rootNode.rightNode;
    rootNode.rightNode = tempNode;
    
    //递归交换左右子节点
    [DyBinaryTreeNode invertBinaryTree:rootNode.leftNode];
    [DyBinaryTreeNode invertBinaryTree:rootNode.rightNode];
    
    return rootNode;
}

/**
 方式雷同于层序遍历
 * 非递归方式翻转
 */
+ (DyBinaryTreeNode *)invertBinaryTreeNot:(DyBinaryTreeNode *)rootNode {
    if (!rootNode) {  return nil; }
    if (!rootNode.leftNode && !rootNode.rightNode) {  return rootNode; }
    
    NSMutableArray *queueArray = [NSMutableArray array]; //数组当成队列
    [queueArray addObject:rootNode]; //压入根节点
    while (queueArray.count > 0) {
        DyBinaryTreeNode *node = [queueArray firstObject];
        [queueArray removeObjectAtIndex:0]; //弹出最前面的节点，仿照队列先进先出原则
        
        DyBinaryTreeNode *pLeft = node.leftNode;
        node.leftNode = node.rightNode;
        node.rightNode = pLeft;
        
        if (node.leftNode) {
            [queueArray addObject:node.leftNode];
        }
        if (node.rightNode) {
            [queueArray addObject:node.rightNode];
        }
        
    }
    return rootNode;
}



#pragma mark 二叉树遍历
/**
 *  先序遍历：先访问根，再遍历左子树，再遍历右子树。典型的递归思想。
 根-左-右
 *  https://zh.wikipedia.org/wiki/%E6%A0%91%E7%9A%84%E9%81%8D%E5%8E%86
 *  @param rootNode 根节点
 *  @param handler  访问节点处理函数
 */
+ (void)preOrderTraverseTree:(DyBinaryTreeNode *)rootNode handler:(void(^)(DyBinaryTreeNode *treeNode))handler {
    if (rootNode) {
        if (handler) {
            handler(rootNode);//根
        }
        [DyBinaryTreeNode preOrderTraverseTree:rootNode.leftNode handler:handler];//左
        [DyBinaryTreeNode preOrderTraverseTree:rootNode.rightNode handler:handler];//右
    }
}

/**
 *  中序遍历
 *  先遍历左子树，再访问根，再遍历右子树
 *  左 根 右
 *  @param rootNode 根节点
 *  @param handler  访问节点处理函数
 */
+ (void)inOrderTraverseTree:(DyBinaryTreeNode *)rootNode handler:(void(^)  (DyBinaryTreeNode *treeNode))handler {
    if (rootNode) {
        [DyBinaryTreeNode inOrderTraverseTree:rootNode.leftNode handler:handler];//左
        if (handler) {
            handler(rootNode);//中
        }
        [DyBinaryTreeNode inOrderTraverseTree:rootNode.rightNode handler:handler];//右
    }
}

/**
 *  后序遍历
 *  先遍历左子树，再遍历右子树，再访问根
 *
 *  @param rootNode 根节点
 *  @param handler  访问节点处理函数
 */
+ (void)postOrderTraverseTree:(DyBinaryTreeNode *)rootNode handler:(void(^)(DyBinaryTreeNode *treeNode))handler {
    if (rootNode) {
        [DyBinaryTreeNode postOrderTraverseTree:rootNode.leftNode handler:handler];
        [DyBinaryTreeNode postOrderTraverseTree:rootNode.rightNode handler:handler];
        if (handler) {
            handler(rootNode);
        }
    }
}

/// 深度遍历
+ (void)deepFirstTraverseTree:(DyBinaryTreeNode *)rootNode handler:(void(^)(DyBinaryTreeNode *treeNode))handler {
    if (!rootNode) {
        return;
    }
    NSMutableArray *stackArr = [NSMutableArray array];
    [stackArr addObject:rootNode];
    while (stackArr.lastObject) {
        DyBinaryTreeNode *last = stackArr.lastObject;
        [stackArr removeLastObject];
        handler(last);
        if (last.rightNode) {
            [stackArr addObject:last.rightNode];
        }
        if (last.leftNode) {
            [stackArr addObject:last.leftNode];
        }
    }
}

/**
 *  层次遍历（广度优先）
 *
 *  @param rootNode 二叉树根节点
 *  @param handler  访问节点处理函数
 */
+ (void)levelTraverseTree:(DyBinaryTreeNode *)rootNode handler:(void(^)(DyBinaryTreeNode *treeNode))handler {
    if (!rootNode) {
        return;
    }
    NSMutableArray *queueArray = [NSMutableArray array]; //数组当成队列
    [queueArray addObject:rootNode]; //压入根节点
    while (queueArray.count > 0) {
        DyBinaryTreeNode *node = [queueArray firstObject];
        if (handler) {
            handler(node);
        }
        [queueArray removeObjectAtIndex:0]; //弹出最前面的节点，仿照队列先进先 出原则
        if (node.leftNode) {
            [queueArray addObject:node.leftNode]; //压入左节点
        }
        if (node.rightNode) {
            [queueArray addObject:node.rightNode]; //压入右节点
        }
    }
}


#pragma mark 获取二叉树的属性
/**
 *  二叉树的深度
    从根节点到叶子节点依次经过的节点（含根、叶节点）形成树的一条路径，最长路径的长度包含的节点数为为树的深度。
 *
 *  @param rootNode 二叉树根节点
 *
 *  @return 二叉树的深度
 */
+ (NSInteger)depthOfTree:(DyBinaryTreeNode *)rootNode {
    if (!rootNode) {
        return 0;
    }
    if (!rootNode.leftNode && !rootNode.rightNode) {
        return 1;
    }
    
    //左子树深度
    NSInteger leftDepth = [DyBinaryTreeNode depthOfTree:rootNode.leftNode];
    //右子树深度
    NSInteger rightDepth = [DyBinaryTreeNode depthOfTree:rootNode.rightNode];
    
    return MAX(leftDepth, rightDepth) + 1;
}

/**

 *  二叉树的宽度
 *  队列的最大长度，结点数最多的层的结点数。
 *  @param rootNode 二叉树根节点
 *
 *  @return 二叉树宽度
 */
+ (NSInteger)widthOfTree:(DyBinaryTreeNode *)rootNode {
    if (!rootNode) {
        return 0;
    }
    NSMutableArray *queueArray = [NSMutableArray array]; //数组当成队列
    [queueArray addObject:rootNode]; //压入根节点
    NSInteger maxWidth = 1; //最大的宽度，初始化为1（因为已经有根节点）
    NSInteger curWidth = 0; //当前层的宽度
    
    while (queueArray.count > 0) {
        
        curWidth = queueArray.count;
        //依次弹出当前层的节点
        for (NSInteger i=0; i<curWidth; i++) {
            DyBinaryTreeNode *node = [queueArray firstObject];
            [queueArray removeObjectAtIndex:0]; //弹出最前面的节点，仿照队列先进先出原则
            //压入子节点
            if (node.leftNode) {
                [queueArray addObject:node.leftNode];
            }
            if (node.rightNode) {
                [queueArray addObject:node.rightNode];
            }
        }
        //宽度 = 当前层节点数
        maxWidth = MAX(maxWidth, queueArray.count);
    }
    
    return maxWidth;
}

/**
 🍺
 *  二叉树的所有节点数
 *
 *  @param rootNode 根节点
 *
 *  @return 所有节点数
 */
+ (NSInteger)numberOfNodesInTree:(DyBinaryTreeNode *)rootNode {
    if (!rootNode) {
        return 0;
    }
    //节点数=左子树节点数+右子树节点数+1（根节点）
    return [DyBinaryTreeNode numberOfNodesInTree:rootNode.leftNode] + [DyBinaryTreeNode numberOfNodesInTree:rootNode.rightNode] + 1;
}

/**
 🍺
 *  二叉树某层中的节点数
 *
 *  @param level    层
 *  @param rootNode 根节点
 *
 *  @return 层中的节点数
 */
+ (NSInteger)numberOfNodesOnLevel:(NSInteger)level inTree:(DyBinaryTreeNode *)rootNode {
    if (!rootNode || level < 1) { //根节点不存在或者level<0
        return 0;
    }
    if (level == 1) { //level=1，返回1（根节点）
        return 1;
    }
    //递归：level层节点数 = 左子树level-1层节点数+右子树level-1层节点数
    return [DyBinaryTreeNode numberOfNodesOnLevel:level-1 inTree:rootNode.leftNode] + [DyBinaryTreeNode numberOfNodesOnLevel:level-1 inTree:rootNode.rightNode];
}

/**
 🍺
 *  二叉树叶子节点数
 *
 *  @param rootNode 根节点
 *
 *  @return 叶子节点数
 */
+ (NSInteger)numberOfLeafsInTree:(DyBinaryTreeNode *)rootNode {
    if (!rootNode) {
        return 0;
    }
    //左子树和右子树都是空，说明是叶子节点
    if (!rootNode.leftNode && !rootNode.rightNode) {
        return 1;
    }
    //递归：叶子数 = 左子树叶子数 + 右子树叶子数
    return [DyBinaryTreeNode numberOfLeafsInTree:rootNode.leftNode] + [DyBinaryTreeNode numberOfLeafsInTree:rootNode.rightNode];
}

/**
 🍺
 *  二叉树最大距离（直径）
 每个节点都可能成为最大距离根节点的潜质。
 Dis(x) = max(Dis(x->left), Dis(x->right), height(x->left)+height(x->right))
 https://www.cnblogs.com/kaituorensheng/p/3555151.html
 *  @param rootNode 根节点
 *
 *  @return 最大距离
 */
+ (NSInteger)maxDistanceOfTree:(DyBinaryTreeNode *)rootNode {
    if (!rootNode) {
        return 0;
    }
    //方案一：（递归次数较多，效率较低）
    //分3种情况：
    //1、最远距离经过根节点：距离 = 左子树深度 + 右子树深度
    NSInteger distance = [DyBinaryTreeNode depthOfTree:rootNode.leftNode] + [DyBinaryTreeNode depthOfTree:rootNode.rightNode];
    //2、最远距离在根节点左子树上，即计算左子树最远距离
    NSInteger disLeft = [DyBinaryTreeNode maxDistanceOfTree:rootNode.leftNode];
    //3、最远距离在根节点右子树上，即计算右子树最远距离
    NSInteger disRight = [DyBinaryTreeNode maxDistanceOfTree:rootNode.rightNode];
    
    return MAX(MAX(disLeft, disRight), distance);
}


@end
