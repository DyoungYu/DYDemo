//
//  ViewController.m
//  DYDemo
//
//  Created by company_2 on 2019/4/3.
//  Copyright © 2019 dyoung. All rights reserved.
//

#import "ViewController.h"
#import "UITestVC.h"
#import "HashObj.h"
#import "DyOperationTest.h"
#import "DyGCDTest.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

//ui unit test
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITestVC *vc = [[UITestVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}



@end
