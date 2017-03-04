//
//  ViewController.m
//  ZWFullScreenPanBackDemo
//
//  Created by 郑亚伟 on 2017/2/27.
//  Copyright © 2017年 zhengyawei. All rights reserved.
//

#import "ViewController.h"
#import "ViewController2.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    self.title = @"点击屏幕push";
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    ViewController2 *vc2 = [[ViewController2 alloc]init];
    [self.navigationController pushViewController:vc2 animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //设置为动画效果显示NavigationBar解决导航栏融合效果
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}





@end
