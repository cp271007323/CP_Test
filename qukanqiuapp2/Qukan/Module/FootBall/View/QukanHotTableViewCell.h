//
//  QukanHotTableViewCell.h
//  Qukan
//
//  Created by Kody on 2019/6/26.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QukanHotModel.h"
#import "QukanApiManager+Competition.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^ActionBlock)(id data);

@class QukanMatchInfoContentModel;
@interface QukanHotTableViewCell : UITableViewCell

@property (nonatomic, strong)UIImageView   *attention_imageView;//logo
@property (nonatomic, strong)UIImageView   *homeTeam_imageView;//国旗
@property (nonatomic, strong)UIImageView   *guestTeam_imageView;//国旗
@property (nonatomic, strong)UILabel       *matchTime_label;//比赛时间
@property(nonatomic, strong) UILabel       *matchMinutes_label;//比赛分钟数
@property(nonatomic, strong) UILabel       *homeTeamRed_label;//红牌
@property(nonatomic, strong) UILabel       *homeTeamYellow_label;//黄牌
@property(nonatomic, strong) UILabel       *guestTeamRed_label;
@property(nonatomic, strong) UILabel       *guestTeamYellow_label;

@property (nonatomic, strong)UILabel       *homeTeamName_label;//国家名字
@property (nonatomic, strong)UILabel       *guestTeamName_label;
@property (nonatomic, strong)UILabel       *matchName_label;//比赛名字
@property (nonatomic, strong)UILabel       *score_label;//比分
@property (nonatomic, strong)UILabel       *halfAngle_label;//半角
@property (nonatomic, strong)UIButton      *matchState_button;//比赛状态
@property(nonatomic, strong) UILabel       *vs_label;
@property(nonatomic, strong) UILabel       *lab_playState;//比赛状态
@property(nonatomic, strong) UIButton      *btn_video;
@property(nonatomic, strong) UIButton      *btn_animation;


@property (nonatomic, weak) UIViewController *Qukan_controller;
@property(nonatomic, assign) NSInteger       sign;

@property (nonatomic, copy) void(^QukanHot_didBlock)(void);
@property (nonatomic, copy) void(^QukanFonson_didBlock)(void);
@property (nonatomic, copy) void(^QukanOhter_didBlock)(void);

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *_Nullable)reuseIdentifier;

- (void)setDataWithModel:(QukanMatchInfoContentModel *)model;
-(void)actionBlock:(ActionBlock)block;

@end

NS_ASSUME_NONNULL_END
