//
//  UINavigationController+ZWPanBack.m
//  顶部放大视图
//
//  Created by 郑亚伟 on 2017/2/27.
//  Copyright © 2017年 zhengyawei. All rights reserved.
//

#import "UINavigationController+ZWPanBack.h"
#import <objc/runtime.h>


@interface ZWFullScreenPopGestureRecognizerDelegate: NSObject <UIGestureRecognizerDelegate>
@property (nonatomic, weak) UINavigationController *navigationController;
@end

@implementation ZWFullScreenPopGestureRecognizerDelegate
//代理方法的实现
//在这里做手势识别判断
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    //判断是否是根控制器，如果是直接取消手势
    if (self.navigationController.viewControllers.count <= 1) {
        return NO;
    }
    //如果正在转场动画，取消手势
    if ([[self.navigationController valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }
    //判断手势方向，如果是从左往右拖动才开启手势
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    if (translation.x <= 0) {
        return NO;
    }
    
    return YES;
}
@end


@implementation UINavigationController (ZWPanBack)
//系统方法，加载时调用
+ (void)load {
    Method originalMethod = class_getInstanceMethod([self class], @selector(pushViewController:animated:));
    Method swizzledMethod = class_getInstanceMethod([self class], @selector(zw_pushViewController:animated:));
    //系统方法和自定义方法交换
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

//自定义方法和系统方法做交换
- (void)zw_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    //寻找交互手势，如果交互手势没有被添加就添加交互手势。
    if (![self.interactivePopGestureRecognizer.view.gestureRecognizers containsObject:self.zw_popGestureRecognizer]) {
        [self.interactivePopGestureRecognizer.view addGestureRecognizer:self.zw_popGestureRecognizer];
        
        NSArray *targets = [self.interactivePopGestureRecognizer valueForKey:@"targets"];
        id internalTarget = [targets.firstObject valueForKey:@"target"];
        SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");
        
        self.zw_popGestureRecognizer.delegate = [self zw_fullScreenPopGestureRecognizerDelegate];
        [self.zw_popGestureRecognizer addTarget:internalTarget action:internalAction];
        
        // 禁用系统的交互手势
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    if (![self.viewControllers containsObject:viewController]) {
        [self zw_pushViewController:viewController animated:animated];
    }
}

//自定义的交互手势
- (ZWFullScreenPopGestureRecognizerDelegate *)zw_fullScreenPopGestureRecognizerDelegate {
    //通过关联对象，直接将属性delegate添加到navigationController中
    ZWFullScreenPopGestureRecognizerDelegate *delegate = objc_getAssociatedObject(self, _cmd);
    if (!delegate) {
        delegate = [[ZWFullScreenPopGestureRecognizerDelegate alloc] init];
        delegate.navigationController = self;
        objc_setAssociatedObject(self, _cmd, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return delegate;
}


//通过关联对象添加属性 zw_popGestureRecognizer
- (UIPanGestureRecognizer *)zw_popGestureRecognizer {
    UIPanGestureRecognizer *panGestureRecognizer = objc_getAssociatedObject(self, _cmd);
    
    if (panGestureRecognizer == nil) {
        panGestureRecognizer = [[UIPanGestureRecognizer alloc] init];
        panGestureRecognizer.maximumNumberOfTouches = 1;
        
        objc_setAssociatedObject(self, _cmd, panGestureRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return panGestureRecognizer;
}

@end
