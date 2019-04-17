//
//  UITestVC.m
//  DYDemo
//
//  Created by company_2 on 2019/4/3.
//  Copyright © 2019 dyoung. All rights reserved.
//

#import "UITestVC.h"
#import <SVProgressHUD.h>

@interface UITestVC ()

@end

@implementation UITestVC
{
    UITextField *field1;
    UITextField *field2;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"login";
    self.view.backgroundColor = [UIColor whiteColor];
    
    field1 = [[UITextField alloc]initWithFrame:CGRectMake(10, 100, 300, 50)];
    field1.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:field1];
    
    field2 = [[UITextField alloc]initWithFrame:CGRectMake(10, 200, 300, 50)];
    [self.view addSubview:field2];
    field2.backgroundColor = [UIColor lightGrayColor];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10, 300, 50, 50)];
    [btn setTitle:@"login" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(btn) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)btn{
    if ([field1.text isEqualToString:@"123456"]
        &&
        [field2.text isEqualToString:@"123"]) {
        [SVProgressHUD showSuccessWithStatus:@"登录成功"];
    }else{
        [SVProgressHUD showInfoWithStatus:@"登录失败"];
    }
}







@end
