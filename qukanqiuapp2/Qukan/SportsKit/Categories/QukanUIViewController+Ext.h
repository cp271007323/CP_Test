//
//  QukanUIViewController+Ext.h
//  HYIM
//
//  Created by haunghe-pc on 2017/8/3.
//  Copyright © 2017年 HCFDATA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Ext)

+ (nullable UIViewController *)visibleViewController;

/**
 *@brief 查找导航控制器堆栈中，指定的视图控制器
 */
- (id _Nullable )findDesignatedViewController:(Class _Nonnull )aClass;

/**
 是否是从导航控制器弹出

 @return YES: 是Pop操作
 */
- (BOOL)isPopAction;

@end
