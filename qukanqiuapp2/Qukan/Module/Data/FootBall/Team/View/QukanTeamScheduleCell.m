//
//  QukanTeamScheduleCell.m
//  Qukan
//
//  Created by Charlie on 2020/1/5.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanTeamScheduleCell.h"
#import "QukanNSDate+Extensions.h"
#import "QukanNSDate+Time.h"
#import "QukanApiManager+Competition.h"
#import "QukanLocalNotification.h"


@interface QukanTeamScheduleCell()


@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *leagueNameLabel;
@property (strong, nonatomic) UILabel *hostNameLabel;
@property (strong, nonatomic) UIImageView *hostFlagImgV;
@property (strong, nonatomic) UILabel *scoreLabel;
@property (strong, nonatomic) UIImageView *guestFlagImgV;
@property (strong, nonatomic) UILabel *guestNameLabel;

@property (strong, nonatomic) UIButton *followButton;

@property (assign, nonatomic) BOOL isFollow;


@property(nonatomic,strong) QukanFTMatchScheduleModel* model;
@end

@implementation QukanTeamScheduleCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self layoutViews];
    }
    return self;
}

- (void)layoutViews{
    [self.contentView addSubview:_timeLabel = [UILabel new]];
    [self.contentView addSubview:_leagueNameLabel = [UILabel new]];
    [self.contentView addSubview:_hostFlagImgV = [UIImageView new]];
    [self.contentView addSubview:_guestFlagImgV = [UIImageView new]];
    [self.contentView addSubview:_hostNameLabel = [UILabel new]];
    [self.contentView addSubview:_guestNameLabel = [UILabel new]];
    [self.contentView addSubview:_scoreLabel = [UILabel new]];
    [self.contentView addSubview:_followButton = [UIButton new]];
    
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(self.hostNameLabel.mas_left).offset(-1);
        make.top.mas_equalTo(8);
    }];
    _timeLabel.text = @"------";
    _timeLabel.font = kFont11;
    _timeLabel.textColor = kCommonBlackColor;

    [_leagueNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.timeLabel);
        make.right.mas_equalTo(self.hostNameLabel.mas_left).offset(-5);
        make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(6);
    }];
    _leagueNameLabel.text = @"周五 英超";
    _leagueNameLabel.font = kFont10;
    _leagueNameLabel.textColor = kTextGrayColor;
    
    [_guestNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScaleScreen(88));
        make.right.mas_equalTo(-30);
        make.centerY.mas_equalTo(0);
    }];
    _guestNameLabel.text = @"北京人和";
    _guestNameLabel.font = kFont12;
    _guestNameLabel.textColor = kCommonBlackColor;
//    _guestNameLabel.numberOfLines = 2;

    [_guestFlagImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.guestNameLabel.mas_left).offset(-5);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(20);
        
    }];
    _guestFlagImgV.backgroundColor = RGBSAMECOLOR(245);
    
    [_scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.guestFlagImgV.mas_left).offset(-5);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(28);
        
    }];
    _scoreLabel.text = @"2:3";
    _scoreLabel.font = kFont12;
    _scoreLabel.textColor = kCommonBlackColor;
    _scoreLabel.textAlignment = NSTextAlignmentCenter;
    _scoreLabel.layer.masksToBounds = YES;
    _scoreLabel.layer.cornerRadius = 4;

    [_hostFlagImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.scoreLabel.mas_left).offset(-5);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(20);
        
    }];
    _hostFlagImgV.backgroundColor = RGBSAMECOLOR(245);
    
    [_hostNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.hostFlagImgV.mas_left).offset(-5);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(kScaleScreen(88));
        
    }];
//    _hostNameLabel.numberOfLines = 2;
    _hostNameLabel.text = @"大连一方";
    _hostNameLabel.font = kFont12;
    _hostNameLabel.textColor = kCommonBlackColor;
    _hostNameLabel.textAlignment = NSTextAlignmentRight;
    
    
    [_followButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(20);
    }];
    [_followButton setImage:kImageNamed(@"follow_n") forState:UIControlStateNormal];
    
    [[_followButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        kGuardLogin
        if ([self.model.isAttention integerValue] == 1) {//已经关注
            [self Qukan_del:self.model.match_id];
        } else {
            [self Qukan_add:self.model.match_id];
        }
    }];
    
    UIView*cutLine = [UIView new];
    cutLine.backgroundColor = HEXColor(0xe3e2e2);
    [self.contentView addSubview:cutLine];
    [cutLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
//    for(UIView*view in self.contentView.subviews){
//        view.backgroundColor = kRandomColor;
//    }
}

- (void)setIsFollow:(BOOL)isFollow{
    _isFollow = isFollow;
    self.model.isAttention = isFollow? @"1" : @"0";

    [self.followButton setImage:kImageNamed(isFollow? @"follow_s":@"follow_n") forState:UIControlStateNormal];

    
}

- (void)Qukan_add:(NSString *)match_id {
    @weakify(self)
    self.followButton.userInteractionEnabled = NO;
    [[[kApiManager QukanAttention_AddWithMatchId:match_id] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.followButton.userInteractionEnabled = YES;
        self.isFollow = YES;
        
        [QukanLocalNotification noticeWithType:FootballTeam model:self.model];
    } error:^(NSError * _Nullable error) {
        self.followButton.userInteractionEnabled = YES;
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)Qukan_del:(NSString *)match_id {
    @weakify(self)
    self.followButton.userInteractionEnabled = NO;
    [[[kApiManager QukanAttention_DelWithMatchId:match_id] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.followButton.userInteractionEnabled = YES;
        self.isFollow = NO;
        [QukanLocalNotification cancleLocationIdentifier:FormatString(@"%@%@",FootballTeam,self.model.match_id)];
    } error:^(NSError * _Nullable error) {
        self.followButton.userInteractionEnabled = YES;
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)setModel:(QukanFTMatchScheduleModel*)model{
    _model = model;
    self.timeLabel.text = [model.start_time substringWithRange:NSMakeRange(5, 11)];
    self.timeLabel.textColor = kCommonBlackColor;
    if (model.isInmatch) {
        self.timeLabel.text = FormatString(@"%@ %@", model.acquireMatchState, model.pass_time);
        self.timeLabel.textColor = kThemeColor;
    }
    NSDate* date = [NSDate dateFromFomate:model.start_time formate:kTimeDetail_Format];
    NSInteger index = date.weekday;
    NSString* weekStr = @[@"", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", @"周天"][index];
    NSString* leagueName = FormatString(@"%@ %@", weekStr,model.league_name);
    self.leagueNameLabel.text = leagueName;
    
    self.hostNameLabel.text = model.home_name;
    [self.hostFlagImgV sd_setImageWithURL:[NSURL URLWithString:model.flag1] placeholderImage:kImageNamed(@"ft_default_flag")];
    
    [self.guestFlagImgV sd_setImageWithURL:[NSURL URLWithString:model.flag2] placeholderImage:kImageNamed(@"ft_default_flag")];
    self.guestNameLabel.text = model.away_name;
    self.isFollow = model.isAttention.intValue == 1;
    
    
    NSString* scoreStr = FormatString(@"%@:%@",model.home_score, model.away_score);
    UIColor* scoreBkColor = UIColor.clearColor;
    UIColor* scoretextColor = kCommonWhiteColor;
    
    if(model.state.intValue == 0){//未开赛
        scoreStr = @"VS";
        scoretextColor = kCommonBlackColor;

    }else if(model.state.intValue == -1){//完成
        if(model.home_score.intValue == model.away_score.intValue){
            scoreBkColor = HEXColor(0x00B24E);
        }else{
            BOOL isHome = [model.currentTeamName isEqualToString:model.home_name];
            if(isHome){
                if(model.home_score.intValue > model.away_score.intValue){
                    scoreBkColor = HEXColor(0xF12B2B);
                }else if(model.home_score.intValue < model.away_score.intValue){
                    scoreBkColor = HEXColor(0x1D9FF9);

                }
            }else{
                if(model.home_score.intValue > model.away_score.intValue){
                    scoreBkColor = HEXColor(0x1D9FF9);
                }else if(model.home_score.intValue < model.away_score.intValue){
                    scoreBkColor = HEXColor(0xF12B2B);
                }
            }
        }
    }else {
        scoretextColor = kThemeColor;
    }
    
    self.scoreLabel.text = scoreStr;
    self.scoreLabel.textColor = scoretextColor;
    self.scoreLabel.backgroundColor = scoreBkColor;


}

@end

