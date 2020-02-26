//
//  QukanBasketHeaderView.h
//  Qukan
//
//  Created by leo on 2019/9/24.
//  Copyright © 2019 mac. All rights reserved.
//
#define Tag_awayTeam 0X123
#define Tag_homeTeam 0X122
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "QukanBasketBallMatchDetailModel.h"
@class QukanBasketBallMatchModel;
NS_ASSUME_NONNULL_BEGIN

@interface QukanBasketDetailHeaderView : UIView
@property (nonatomic, weak) UIViewController *viewController;

/**动画直播的地址*/
@property (nonatomic, copy) NSString *url_animation;

/**标记是否显示状态栏*/
@property(nonatomic, assign) BOOL   bool_isHideState;

/**设置控件透明度*/
- (void)setSubviewAlaphWithProgress:(CGFloat)progress;

@property (weak, nonatomic) IBOutlet UILabel *lab_ke;
@property (weak, nonatomic) IBOutlet UILabel *lab_zhu;


@property (nonatomic,copy)void (^clickAnimate)(void);
@property (nonatomic,copy)void (^backBtnBlock)(void);



//- (void)backAction;
- (void)coverButtonClick;
- (void)setData:(QukanBasketBallMatchDetailModel *)model animationUrl:(NSString *)animationUrl;


//新增
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
//球队点击事件
- (void)btn_teamClick:(NSString *)teamId;
@end

NS_ASSUME_NONNULL_END
