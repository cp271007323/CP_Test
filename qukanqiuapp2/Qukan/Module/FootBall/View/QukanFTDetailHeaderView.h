//
//  QukanFTDetailHeaderView.h
//  Qukan
//
//  Created by leo on 2019/10/17.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>


@class QukanMatchInfoContentModel;

NS_ASSUME_NONNULL_BEGIN

@interface QukanFTDetailHeaderView : UIView

/**动画直播的地址*/
@property (nonatomic, copy) NSString *url_animation;

/**标记是否显示状态栏*/
@property(nonatomic, assign) BOOL   bool_isHideState;


/**统一赋值*/
- (void)fullViewWithModel:(QukanMatchInfoContentModel *)model;
/**设置控件透明度*/
- (void)setSubviewAlaphWithProgress:(CGFloat)progress;

#pragma mark ===================== rac监听 ==================================

// 视频按钮点击
- (void)btn_videoPlayClick:(UIButton *)btn;
// 动画直播按钮点击
- (void)btn_animationPlayClick:(UIButton *)btn;
// 分享按钮点击
- (void)btn_shareClick:(UIButton *)btn;
// 返回按钮点击
- (void)btn_backAndLSNameClick:(UIButton *)btn;
// 动画直播界面点击
- (void)btn_animationCoverClick:(UIButton *)btn;
// 导航控制器返回
- (void)backAction;

// 隐藏动画回调
- (void)HidenAnimation;

- (void)homeLogoClick;
- (void)awayLogoClick;

@end

NS_ASSUME_NONNULL_END
