//
//  UIView+extension.h
//  MeetCarefree
//
//  Created by 陈平 on 2017/11/10.
//  Copyright © 2017年 xxf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (extension)

#pragma mark - 提示框
+ (void)showAletViewWithTitle:(NSString *)title
                      message:(NSString *)message
                     btnTitle:(NSString *)btnTitle
                btnTitleColor:(UIColor *)btnTitleColor
                btnTitleBlock:(void (^)(void))btnTitleBlock;

+ (void)showAletViewWithTitle:(NSString *)title
                      message:(NSString *)message
                     btnTitle:(NSString *)btnTitle
                btnTitleColor:(UIColor *)btnTitleColor
                btnTitleBlock:(void (^)(void))btnTitleBlock
                  subBtnTitle:(NSString *)subBtnTitle
             subBtnTitleColor:(UIColor *)subBtnTitleColor
             subBtnTitleBlock:(void (^)(void))subBtnTitleBlock;

+ (void)showAletViewAndCancelWithTitle:(NSString *)title
                               message:(NSString *)message
                              btnTitle:(NSString *)btnTitle
                         btnTitleColor:(UIColor *)btnTitleColor
                         btnTitleBlock:(void (^)(void))btnTitleBlock
                           subBtnTitle:(NSString *)subBtnTitle
                      subBtnTitleColor:(UIColor *)subBtnTitleColor
                      subBtnTitleBlock:(void (^)(void))subBtnTitleBlock;

#pragma mark - 添加阴影
- (void)addShadow;

- (void)addShadowWithOffset:(CGSize)offset;

- (void)addShadowWithOffset:(CGSize)offset color:(UIColor *)color radius:(CGFloat)radius opacity:(CGFloat)opacity;

#pragma mark - 获取当前控制器
+ (UIViewController*)getViewController;

#pragma mark - 获取当前最顶层控制器
+ (UIViewController*)getTopViewController;

#pragma mark - 去除滚动视图安全区
+ (void)contentInsetAdjustmentBehaviorFor:(__kindof UIScrollView *)scrollView;

#pragma mark - 去除tableView刷新cell弹跳
+ (void)estimatedForTableView:(__kindof UITableView *)tableView;

#pragma mark - 修改状态栏的颜色
+ (void)statusBarBackgroundColor:(UIColor *)color;

@end

