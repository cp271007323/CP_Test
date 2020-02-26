//
//  QukanGDataView.h
//  Qukan
//
//  Created by Kody on 2019/8/8.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QukanHomeModels.h"

@class QukanHomeModels;
NS_ASSUME_NONNULL_BEGIN
/// 广告视图
@interface QukanGDataView : UIView

@property(nonatomic, copy) void(^dataImageView_didBlock)(void);

- (instancetype)initWithFrame:(CGRect)frame;
- (void)Qukan_setAdvWithModel:(QukanHomeModels *)model;

@end

NS_ASSUME_NONNULL_END
