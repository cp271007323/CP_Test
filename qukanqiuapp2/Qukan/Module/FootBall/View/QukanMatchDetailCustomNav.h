//
//  QukanMatchDetailCustomNav.h
//  Qukan
//
//  Created by leo on 2019/12/22.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QukanMatchInfoContentModel;
@class QukanBasketBallMatchDetailModel;
NS_ASSUME_NONNULL_BEGIN

@interface QukanMatchDetailCustomNav : UIView

/**返回按钮*/
@property(nonatomic, strong) UIButton   * btn_back;
/**联赛名称lab*/
@property(nonatomic, strong) UILabel   * lab_LSname;

/**分享按钮*/
@property(nonatomic, strong) UIButton   * btn_share;

/**左边队标*/
@property(nonatomic, strong) UIImageView   * img_leftTeamIcon;
/**右边队标*/
@property(nonatomic, strong) UIImageView   * img_rightTeamIcon;

/**左边得分lab*/
@property(nonatomic, strong) UILabel   * lab_leftTeamDF;
/**右边得分lab*/
@property(nonatomic, strong) UILabel   * lab_rightTeamDF;

/**中间显示时间lab*/
@property(nonatomic, strong) UILabel   * lab_matchTime;

/**背景图*/
@property(nonatomic, strong) UIView   * view_bg;
/**比赛详情lab*/
@property(nonatomic, strong) UILabel   * lab_title;


/**比赛时间的背景*/
@property(nonatomic, strong) UIView   * view_timeBg;

// 控件赋值
- (void)fullViewWithModel:(QukanMatchInfoContentModel *)model;
- (void)fullViewWithBasketModel:(QukanBasketBallMatchDetailModel *)model;


// 设置控件透明度
- (void)setAlphaWithProgress:(CGFloat)progress;

#pragma mark ===================== 事件监听 ==================================
- (void)btn_backClick;
- (void)btn_shareClick;

@end

NS_ASSUME_NONNULL_END
