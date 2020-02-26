//
//  UIView+ShowLoading.h
//  jfsdl
//
//  Created by River on 14-11-21.
//  Copyright (c) 2014年 appabc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QukanctivityIndicatorView.h"

@interface UIView (ShowLoading)

- (void)showLoading;
- (void)showLoadingWithYoffset:(CGFloat)yOffset;
- (void)showLoadingWithTouchable;
- (void)hideLoading;
- (BOOL)isShowLoading;


- (void)showClearLoadingWithYoffset:(CGFloat)yOffset;
@end
