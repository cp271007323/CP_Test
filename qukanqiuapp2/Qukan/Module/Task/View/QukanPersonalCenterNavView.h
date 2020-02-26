//
//  QukanPersonalCenterNavView.h
//  Qukan
//
//  Created by leo on 2020/1/4.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanPersonalCenterNavView : UIView

#pragma mark ===================== function ==================================
- (void)freshSubView;

- (void)setBtnClick;

- (void)headerOrNickClickAction;


- (void)showContentView;
- (void)hideContentView;

@end

NS_ASSUME_NONNULL_END
