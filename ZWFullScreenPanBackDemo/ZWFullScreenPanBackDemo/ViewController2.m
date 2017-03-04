//
//  ViewController2.m
//  ZWFullScreenPanBackDemo
//
//  Created by 郑亚伟 on 2017/2/27.
//  Copyright © 2017年 zhengyawei. All rights reserved.
//

#import "ViewController2.h"

@interface ViewController2 ()

@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}




@end
