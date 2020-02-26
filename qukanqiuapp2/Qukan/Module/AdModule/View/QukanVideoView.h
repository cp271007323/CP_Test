//
//  QukanVideoView.h
//  Qukan
//
//  Created by pfc on 2019/8/9.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QukanHomeModels.h"

NS_ASSUME_NONNULL_BEGIN
/// 视频显示的广告视图
@interface QukanVideoView : UIView

@property(nonatomic, copy) void(^dataImageView_didBlock)(void);
@property(nonatomic, copy) void(^cancelButton_didBlock)(void);
@property(nonatomic, strong) UIImageView       *gImageView;
@property(nonatomic, strong) UIButton          *cancelButton;

- (instancetype)initWithFrame:(CGRect)frame WithModel:(QukanHomeModels *)model;

- (void)setDataSource:(QukanHomeModels *)model;

@end

NS_ASSUME_NONNULL_END
