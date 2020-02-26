//
//  QukanShowTaskHeaderView.h
//  Qukan
//
//  Created by leo on 2020/1/7.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QukanTModel;
@class QukanActionModel;

NS_ASSUME_NONNULL_BEGIN

@interface QukanDailyHeaderView : UIView

// 给中间的view赋值
- (void)fullCenterViewWithModel:(QukanTModel *)model;
// 给底部的view赋值
- (void)fullBottomViewWithModel:(QukanTModel *)model;


// 用于领取点击
- (void)linquActionWithActionModel:(QukanActionModel *)model;
- (void)YQBtnClick;

@end

NS_ASSUME_NONNULL_END
