//
//  QukanUIViewController+Ext.m
//  HYIM
//
//  Created by haunghe-pc on 2017/8/3.
//  Copyright © 2017年 HCFDATA. All rights reserved.
//

#import "QukanUIViewController+Ext.h"

@implementation UIViewController (Ext)

- (UIViewController *)ui_visibleViewControllerIfExist {
    
    if (self.presentedViewController) {
        return [self.presentedViewController ui_visibleViewControllerIfExist];
    }
    
    if ([self isKindOfClass:[UINavigationController class]]) {
        return [((UINavigationController *)self).visibleViewController ui_visibleViewControllerIfExist];
    }
    
    if ([self isKindOfClass:[UITabBarController class]]) {
        return [((UITabBarController *)self).selectedViewController ui_visibleViewControllerIfExist];
    }
    
    if ([self isViewLoaded] && self.view.window) {
        return self;
    } else {
        NSLog(@"ui_visibleViewControllerIfExist:，找不到可见的viewController。self = %@, self.view.window = %@", self, self.view.window);
        return nil;
    }
}

+ (nullable UIViewController *)visibleViewController {
    UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    UIViewController *visibleViewController = [rootViewController ui_visibleViewControllerIfExist];
    return visibleViewController;
}

- (BOOL)isPopAction {
    NSArray *viewControllers = self.navigationController.viewControllers;//获取当前的视图控制其
    if (viewControllers.count > 1 && [viewControllers objectAtIndex:viewControllers.count-2] == self) {
        //当前视图控制器在栈中，故为push操作
        return NO;
    } else if ([viewControllers indexOfObject:self] == NSNotFound) {
        //当前视图控制器不在栈中，故为pop操作
        return YES;
    }
    
    return NO;
}

- (id _Nullable )findDesignatedViewController:(Class _Nonnull )aClass; {
//    NSAssert(self.navigationController, @"Not In Nav");
    UINavigationController *nav;
    if ([self isKindOfClass:[UINavigationController class]]) {
        nav = (UINavigationController *)self;
    }else {
        nav = self.navigationController;
    }
    for (UIViewController *vc in nav.viewControllers) {
        if ([vc isKindOfClass:aClass]) {
            return vc;
        }
    }
    return nil;
}

@end
