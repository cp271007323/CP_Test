//
//  UIView+extension.m
//  MeetCarefree
//
//  Created by 陈平 on 2017/11/10.
//  Copyright © 2017年 xxf. All rights reserved.
//

#import "UIView+extension.h"

@implementation UIView (extension)

#pragma mark - 提示框
+ (void)showAletViewWithTitle:(NSString *)title
                      message:(NSString *)message
                     btnTitle:(NSString *)btnTitle
                btnTitleColor:(UIColor *)btnTitleColor
                btnTitleBlock:(void (^)(void))btnTitleBlock
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *takePAction = [UIAlertAction actionWithTitle:btnTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (btnTitleBlock) btnTitleBlock();
    }];
    [alertVC addAction:takePAction];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:cancleAction];
    if (([UIDevice currentDevice].systemVersion.floatValue >= 9.0f))
    {
        [takePAction setValue:btnTitleColor forKey:@"titleTextColor"];
    }
    [[self getViewController] presentViewController:alertVC animated:YES completion:nil];
}

+ (void)showAletViewWithTitle:(NSString *)title
                      message:(NSString *)message
                     btnTitle:(NSString *)btnTitle
                btnTitleColor:(UIColor *)btnTitleColor
                btnTitleBlock:(void (^)(void))btnTitleBlock
                  subBtnTitle:(NSString *)subBtnTitle
             subBtnTitleColor:(UIColor *)subBtnTitleColor
             subBtnTitleBlock:(void (^)(void))subBtnTitleBlock
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *takePAction = [UIAlertAction actionWithTitle:btnTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (btnTitleBlock) btnTitleBlock();
    }];
    UIAlertAction *choosePAction = [UIAlertAction actionWithTitle:subBtnTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (subBtnTitleBlock) subBtnTitleBlock();
    }];
    [alertVC addAction:takePAction];
    [alertVC addAction:choosePAction];
    
    if (([UIDevice currentDevice].systemVersion.floatValue >= 9.0f))
    {
        [takePAction setValue:btnTitleColor forKey:@"titleTextColor"];
        [choosePAction setValue:subBtnTitleColor forKey:@"titleTextColor"];
    }
    
    [[self getViewController] presentViewController:alertVC animated:YES completion:nil];
}

+ (void)showAletViewAndCancelWithTitle:(NSString *)title
                               message:(NSString *)message
                              btnTitle:(NSString *)btnTitle
                         btnTitleColor:(UIColor *)btnTitleColor
                         btnTitleBlock:(void (^)(void))btnTitleBlock
                           subBtnTitle:(NSString *)subBtnTitle
                      subBtnTitleColor:(UIColor *)subBtnTitleColor
                      subBtnTitleBlock:(void (^)(void))subBtnTitleBlock
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *takePAction = [UIAlertAction actionWithTitle:btnTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (btnTitleBlock) btnTitleBlock();
    }];
    UIAlertAction *choosePAction = [UIAlertAction actionWithTitle:subBtnTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (subBtnTitleBlock) subBtnTitleBlock();
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:takePAction];
    [alertVC addAction:choosePAction];
    [alertVC addAction:cancelAction];
    
    if (([UIDevice currentDevice].systemVersion.floatValue >= 9.0f))
    {
        [takePAction setValue:btnTitleColor forKey:@"titleTextColor"];
        [choosePAction setValue:subBtnTitleColor forKey:@"titleTextColor"];
        [cancelAction setValue:CPColor(@"333333") forKey:@"titleTextColor"];
    }
    
    [[self getViewController] presentViewController:alertVC animated:YES completion:nil];
}

 
#pragma mark - 获取当前控制器
+ (UIWindow *)getWindow
{
    UIWindow* window = nil;
    
    if (@available(iOS 13.0, *))
    {
        for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes)
        {
            if (windowScene.activationState == UISceneActivationStateForegroundActive)
            {
                window = windowScene.windows.firstObject;
                break;
            }
        }
    }else{
        window = [UIApplication sharedApplication].keyWindow;
    }
    return window;
}

+ (UIViewController*)getViewController
{
    UIViewController *currentVC = nil;
    UIViewController *topVC = nil;
    id appRootNav = [self getWindow].rootViewController;
    
    
    
    if([appRootNav isKindOfClass:[UINavigationController class]] ||
       [appRootNav isKindOfClass:[UITabBarController class]])
    {
        //获取当前页面显示所在的控制器
        while ([appRootNav isKindOfClass:[UINavigationController class]] ||
           [appRootNav isKindOfClass:[UITabBarController class]])
        {
            if ([appRootNav isKindOfClass:[UINavigationController class]])
            {
                UINavigationController *nav = (UINavigationController *)appRootNav;
                __kindof UIViewController *appRootVC = nav.viewControllers.lastObject;
                topVC = appRootVC;
            }
            else if ([appRootNav isKindOfClass:[UITabBarController class]])
            {
                UITabBarController *tabBarVC = (UITabBarController *)appRootNav;
                __kindof UIViewController *appRootVC = tabBarVC.viewControllers[tabBarVC.selectedIndex];
                topVC = appRootVC;
            }
            else
            {
                __kindof UIViewController *appRootVC = appRootNav;
                topVC = appRootVC;
            }
            appRootNav = topVC;
        }
    }
    else
    {
        topVC = appRootNav;
    }
    
    
    
    //有模态情况下的根视图
    if (topVC.presentedViewController && ![topVC isKindOfClass:[UIAlertController class]])
    {
        do {
            topVC = topVC.presentedViewController;
            if ([topVC isKindOfClass:[UINavigationController class]])
            {
                UINavigationController *nav = (UINavigationController *)topVC;
                topVC = nav.viewControllers.lastObject;
            }
        } while (topVC.presentedViewController);
        currentVC = topVC;
    }
    else
    {
        currentVC = topVC;
    }
    
    return currentVC;
}

+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    UIWindow * window = [self getWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
    {
        while ([nextResponder isKindOfClass:[UINavigationController class]] ||
               [nextResponder isKindOfClass:[UITabBarController class]])
        {
            if ([nextResponder isKindOfClass:[UINavigationController class]])
            {
                UINavigationController *nav = (UINavigationController *)nextResponder;
                __kindof UIViewController *appRootVC = nav.viewControllers.lastObject;
                result = appRootVC;
            }
            else if ([nextResponder isKindOfClass:[UITabBarController class]])
            {
                UITabBarController *tabBarVC = (UITabBarController *)nextResponder;
                __kindof UIViewController *appRootVC = tabBarVC.viewControllers[tabBarVC.selectedIndex];
                result = appRootVC;
            }
            else
            {
                __kindof UIViewController *appRootVC = nextResponder;
                result = appRootVC;
            }
            nextResponder = result;
        }
    }
    else
    {
        result = window.rootViewController;
    }
    return result;
}

/**
 获取当前顶层控制器
 */
+ (UIViewController*)getTopViewController
{
    UIViewController *currentVC = nil;
    UIViewController *topVC = [self getWindow].rootViewController;
    
    //有模态情况下的根视图
    if (topVC.presentedViewController &&
        ![topVC isKindOfClass:[UIAlertController class]])
    {
        do {
            topVC = topVC.presentedViewController;
            
        } while (topVC.presentedViewController);
        currentVC = topVC;
    }
    //获取非模态情况下的根视图
    else
    {
        currentVC = [self getTopCurrentVC];
    }
    return currentVC;
}

+ (UIViewController *)getTopCurrentVC
{
    return [self getWindow].rootViewController;
}

#pragma mark - 添加阴影
- (void)addShadow
{
    [self addShadowWithOffset:CGSizeMake(0, 0) color:[[UIColor blackColor] colorWithAlphaComponent:.3] radius:3 opacity:.7];
}

- (void)addShadowWithOffset:(CGSize)offset
{
    [self addShadowWithOffset:offset color:[[UIColor blackColor] colorWithAlphaComponent:.3] radius:3 opacity:.7];
}

- (void)addShadowWithOffset:(CGSize)offset color:(UIColor *)color radius:(CGFloat)radius opacity:(CGFloat)opacity
{
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowRadius = radius;
    self.layer.shadowOpacity = opacity;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

#pragma mark - 去除滚动视图安全区
+ (void)contentInsetAdjustmentBehaviorFor:(__kindof UIScrollView *)scrollView
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_11_0
    if (@available(iOS 11.0, *))
    {
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
#endif
}

#pragma mark - 去除tableView刷新cell弹跳
+ (void)estimatedForTableView:(__kindof UITableView *)tableView
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_11_0
    if (@available(ios 11.0, *))
    {
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
    }
#endif
}

#pragma mark - 修改状态栏的颜色
+ (void)statusBarBackgroundColor:(UIColor *)color
{
    
//    if (@available(iOS 13.0, *))
//    {
//        UIView *_localStatusBar = [[UIApplication sharedApplication].keyWindow.windowScene.statusBarManager performSelector:@selector(createLocalStatusBar)];
//        UIView * statusBar = [_localStatusBar performSelector:@selector(statusBar)];
//        statusBar.backgroundColor = color;
//    }
//    else
//    {
//        UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
//        if ([statusBar respondsToSelector:@selector(setBackgroundColor:)])
//        {
//            statusBar.backgroundColor = color;
//        }
//    }
    
    if (@available(ios 13.0, *))
    {
        UIStatusBarManager *statusBarManager = [UIApplication sharedApplication].keyWindow.windowScene.statusBarManager;

        if([statusBarManager respondsToSelector:@selector(createLocalStatusBar)])
        {

            UIView *localStatusBarView = [statusBarManager performSelector:@selector(createLocalStatusBar)];
            UIView *statusBarView = [localStatusBarView performSelector:@selector(statusBar)];
            
            UIColor *statusBarColor = color;
            [statusBarView performSelector:@selector(setForegroundColor:)withObject:statusBarColor];
        }
    }
    else
    {
        UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
        if ([statusBar respondsToSelector:@selector(setBackgroundColor:)])
        {
            statusBar.backgroundColor = color;
        }
    }
    
}

@end



