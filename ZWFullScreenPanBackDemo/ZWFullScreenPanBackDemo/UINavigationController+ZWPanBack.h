//
//  UINavigationController+ZWPanBack.h
//  顶部放大视图
//
//  Created by 郑亚伟 on 2017/2/27.
//  Copyright © 2017年 zhengyawei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (ZWPanBack)
// 自定义全屏拖拽返回手势
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *zw_popGestureRecognizer;

@end
