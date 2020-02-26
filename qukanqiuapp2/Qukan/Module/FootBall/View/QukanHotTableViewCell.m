//
//  QukanHotTableViewCell.m
//  Qukan
//
//  Created by Kody on 2019/6/26.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanHotTableViewCell.h"
#import "QukanMatchInfoModel.h"
#import "QukanLocalNotification.h"
//#import "UIButton+SGAppKit.h"
#import "QukanMatchAniAndVideoView.h"

@interface QukanHotTableViewCell()

@property (nonatomic, strong) QukanMatchInfoContentModel *Qukan_model;
@property (nonatomic, copy) ActionBlock block;
@property(nonatomic, strong) UIView *back_view;//四边行View
@property(nonatomic, strong) QukanMatchAniAndVideoView *aniAndVideo_view;


//@property(nonatomic, strong) UILabel *half_back_label;

/**<#注释#>*/
@property(nonatomic, strong) UIView   * view_btnSuper;

@end

@implementation QukanHotTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self) {
        self.contentView.backgroundColor = kSecondTableViewBackgroudColor;
        
        [self.contentView addSubview:self.back_view];
        [self.back_view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(3);
            make.bottom.offset(-3);
            make.right.offset(-10);
            make.left.offset(10);
        }];
        
        [self.contentView addSubview:self.attention_imageView];
        [self.attention_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.top.offset(0);
            make.width.height.equalTo(@(50));
        }];
        
        [self.contentView addSubview:self.matchTime_label];
        [self.matchTime_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView).offset(15);
            make.right.mas_equalTo(self.contentView.mas_centerX).offset(-5);
            make.height.offset(12);
        }];
        
        [self.contentView addSubview:self.matchName_label];
        [self.matchName_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.matchTime_label);
            make.left.mas_equalTo(self.matchTime_label.mas_right).offset(10);
            make.height.mas_equalTo(self.matchTime_label);
        }];
        
        [self.contentView addSubview:self.matchMinutes_label];
        [self.matchMinutes_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.matchTime_label);
        }];
        
        [self.contentView addSubview:self.vs_label];
        [self.vs_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(100);
            make.height.offset(30);
            make.centerX.mas_equalTo(self.contentView);
            make.top.mas_equalTo(self.matchMinutes_label.mas_bottom).offset(10);
        }];
        
        [self.contentView addSubview:self.score_label];
        [self.score_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(100);
            make.height.offset(30);
            make.top.mas_equalTo(self.vs_label);
            make.centerX.mas_equalTo(self.contentView);
        }];
        
        [self.contentView addSubview:self.homeTeam_imageView];
        [self.homeTeam_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.vs_label.mas_left).offset(-5);
            make.width.height.offset(38);
            make.centerY.mas_equalTo(self.score_label);
        }];
        
        [self.contentView addSubview:self.homeTeamName_label];
        [self.homeTeamName_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.homeTeam_imageView.mas_left).offset(-10);
            make.centerY.mas_equalTo(self.homeTeam_imageView);
            make.left.offset(10);
        }];
        
        [self.contentView addSubview:self.homeTeamYellow_label];
        [self.homeTeamYellow_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.homeTeamName_label);
            make.top.mas_equalTo(self.homeTeamName_label.mas_bottom).offset(5);
            make.width.offset(8);
            make.height.offset(11);
        }];
        
        [self.contentView addSubview:self.homeTeamRed_label];
        [self.homeTeamRed_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.homeTeamYellow_label.mas_left).offset(-5);
            make.top.height.width.mas_equalTo(self.homeTeamYellow_label);
        }];
        
        [self.contentView addSubview:self.guestTeam_imageView];
        [self.guestTeam_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.score_label.mas_right).offset(5);
            make.width.height.centerY.mas_equalTo(self.homeTeam_imageView);
        }];
       
        [self.contentView addSubview:self.guestTeamName_label];
        [self.guestTeamName_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.centerY.mas_equalTo(self.homeTeamName_label);
            make.left.mas_equalTo(self.guestTeam_imageView.mas_right).offset(10);
            make.right.offset(-10);
        }];
        
        [self.contentView addSubview:self.guestTeamYellow_label];
        [self.guestTeamYellow_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.guestTeamName_label);
            make.width.height.centerY.mas_equalTo(self.homeTeamYellow_label);
        }];
       
        [self.contentView addSubview:self.guestTeamRed_label];
        [self.guestTeamRed_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.guestTeamYellow_label.mas_right).offset(5);
            make.width.height.centerY.mas_equalTo(self.homeTeamRed_label);
        }];
        
//        [self.contentView addSubview:self.half_imageView];
//        [self.half_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.height.offset(22);
//            make.width.offset(30);
//            make.top.mas_equalTo(self.guestTeamYellow_label.mas_bottom).offset(5);
//            make.left.mas_equalTo(self.guestTeamName_label);
//        }];
        
//        [self.contentView addSubview:self.half_back_label];
//        [self.half_back_label mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(self.half_imageView.mas_right);
//            make.top.height.mas_equalTo(self.half_imageView);
//            make.right.offset(-10);
//        }];
        
        [self.contentView addSubview:self.halfAngle_label];
        [self.halfAngle_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.guestTeamYellow_label.mas_bottom).offset(5);
            make.width.offset(88);
            make.height.offset(18);
            make.centerX.equalTo(self.contentView);
        }];
        
        [self.contentView addSubview:self.view_btnSuper];
        [self.view_btnSuper addSubview:self.aniAndVideo_view];
        
        [self.back_view addSubview:self.view_btnSuper];
        [self.view_btnSuper mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.back_view).offset(8);
            make.top.equalTo(self.back_view).offset(-8);
            make.width.offset(98);
            make.height.offset(28);
        }];
        
        [self.aniAndVideo_view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(self.view_btnSuper);
            make.width.equalTo(@(90));
            make.height.equalTo(@(20));
        }];
    }
    return self;
}

#pragma mark ===================== Public Methods =======================

- (void)setDataWithModel:(QukanMatchInfoContentModel *)model {
    self.Qukan_model = model;
    
    [self addObcWithModel:model];
    
    // 正在打
    BOOL bool_isPlayIng = model.state == 1 || model.state == 2 || model.state == 3 || model.state == 4;
    // 推迟
    BOOL bool_isLatePaly= model.state == -14 || model.state == -13 || model.state == -12 || model.state == -11 || model.state == -10;
    // 打完了
    BOOL bool_isOver = model.state == -1;
    // 未开始
    BOOL bool_noStart = model.state == 0;
    
    self.attention_imageView.image = [UIImage imageNamed:@"Qukan_star_selected"];
    
    [self.homeTeam_imageView sd_setImageWithURL:[NSURL URLWithString:model.flag1]
                            placeholderImage:[UIImage imageNamed:@"Qukan_Hot_Default0"]];
    self.homeTeamName_label.text = model.home_name;
    [self.guestTeam_imageView sd_setImageWithURL:[NSURL URLWithString:model.flag2]
                            placeholderImage:[UIImage imageNamed:@"Qukan_Hot_Default1"]];
    self.guestTeamName_label.text = model.away_name;
    self.matchName_label.text = model.league_name;
    self.matchTime_label.hidden = bool_isPlayIng;
    self.matchTime_label.text = [model.match_time componentsSeparatedByString:@" "].lastObject;
    
    if ([model.isAttention integerValue] == 1) {
        self.attention_imageView.image = [UIImage imageNamed:@"Qukan_star_selected"];
    } else {
        self.attention_imageView.image = [UIImage imageNamed:@"Qukan_star"];
    }
    
    BOOL yellowRedOpen = ![[[NSUserDefaults standardUserDefaults] objectForKey:Qukan_IsShow_RedAndYellowka_Key] isEqualToString:@"2"];
    
    BOOL show_red1 = (bool_isOver || bool_isPlayIng) && (model.red1 > 0) && yellowRedOpen;
    BOOL show_red2 = (bool_isOver || bool_isPlayIng) && (model.red2 > 0) && yellowRedOpen;
    
    BOOL show_yellow1 = (bool_isOver || bool_isPlayIng) && (model.yellow1 > 0) && yellowRedOpen;
    BOOL show_yellow2 = (bool_isOver || bool_isPlayIng) && (model.yellow2 > 0) && yellowRedOpen;
    
    self.homeTeamRed_label.hidden = !show_red1;
    if (!self.homeTeamRed_label.hidden)self.homeTeamRed_label.text = [NSString stringWithFormat:@"%ld",model.red1];
    
    self.guestTeamRed_label.hidden = !show_red2;
    if (!self.guestTeamRed_label.hidden)self.guestTeamRed_label.text = [NSString stringWithFormat:@"%ld",model.red2];
    
    self.homeTeamYellow_label.hidden = !show_yellow1;
    if (!self.homeTeamYellow_label.hidden)self.homeTeamYellow_label.text = [NSString stringWithFormat:@"%ld",model.yellow1];

    self.guestTeamYellow_label.hidden = !show_yellow2;
    if (!self.guestTeamYellow_label.hidden) self.guestTeamYellow_label.text = [NSString stringWithFormat:@"%ld",model.yellow2];
    
    self.vs_label.hidden = bool_isPlayIng || bool_isOver;
    self.matchMinutes_label.hidden = !bool_isPlayIng;
    self.halfAngle_label.hidden = !(bool_isPlayIng || bool_isOver);
    self.score_label.hidden = !(bool_isPlayIng || bool_isOver);
    
    if (!self.score_label.hidden) self.score_label.text = [NSString stringWithFormat:@"%ld : %ld",model.home_score,model.away_score];
    if (!self.matchMinutes_label.hidden) [self setPassTime];
    
    if (!self.halfAngle_label.hidden) self.halfAngle_label.text = [NSString stringWithFormat:@"半:%ld-%ld 角:%ld-%ld",model.bc1,model.bc2,model.corner1,model.corner2];

    //颜色判断
    [self.aniAndVideo_view setDataWithObj:model];
    self.aniAndVideo_view.state_label_color = bool_noStart || bool_isLatePaly || bool_isOver ? kTextGrayColor : kThemeColor;
    self.aniAndVideo_view.video_btn_color = kThemeColor;
    self.aniAndVideo_view.animation_btn_color = kCommonTextColor;
    
    self.aniAndVideo_view.state_label_font = kFont10;
    self.aniAndVideo_view.cornerRadius_float = 9;
    
//    self.half_imageView.hidden = self.half_back_label.hidden = self.halfAngle_label.hidden;
}

- (void)addObcWithModel:(QukanMatchInfoContentModel *)model {
    @weakify(self);
    if (model.state == 1 || model.state == 2 || model.state == 3 || model.state == 4) {
        [[RACObserve(self.Qukan_model, away_score) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            self.score_label.text = [NSString stringWithFormat:@"%zd : %zd",self.Qukan_model.home_score,self.Qukan_model.away_score];
        }];
        
        [[RACObserve(self.Qukan_model, home_score) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            self.score_label.text = [NSString stringWithFormat:@"%zd : %zd",self.Qukan_model.home_score,self.Qukan_model.away_score];
        }];
        
        [[RACObserve(self.Qukan_model, red1) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            self.homeTeamRed_label.text = [NSString stringWithFormat:@"%zd",self.Qukan_model.red1];
        }];
        
        [[RACObserve(self.Qukan_model, red2) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            self.guestTeamRed_label.text = [NSString stringWithFormat:@"%zd", self.Qukan_model.red2];
        }];
        
        [[RACObserve(self.Qukan_model, pass_time) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self setPassTime];
        }];
    }
}

- (void)setPassTime {
    NSString *stateStr = @"";
    switch (self.Qukan_model.state) {
        case 1:
            stateStr = @"上半场";
            break;
        case 2:
            stateStr = @"";
            break;
        case 3:
            stateStr = @"下半场";
            break;
        case 4:
            stateStr = @"加时";
            break;
        default:
            break;
    }
    
    self.matchMinutes_label.text = [NSString stringWithFormat:@"%@%@'",stateStr, [NSString isEmptyStr:self.Qukan_model.pass_time]?@"":self.Qukan_model.pass_time];
    
    if (self.Qukan_model.state == 2) {
        self.matchMinutes_label.text = @"中场'";
    }
}

#pragma mark ===================== Actions ============================

-(void)actionBlock:(ActionBlock)block{
    self.block = block;
}

-(void)clickmachStateButtonEvent:(UIButton *)senders{
    if (self.block) {
        self.block(@1);
    }
}

- (void)MatchRedAndYellShow {
    NSString *obj = [[NSUserDefaults standardUserDefaults] objectForKey:Qukan_IsShow_RedAndYellowka_Key];
    if ([obj integerValue] == 2) {
        self.homeTeamRed_label.hidden = YES;
        self.homeTeamYellow_label.hidden = YES;
        self.guestTeamRed_label.hidden = YES;
        self.guestTeamYellow_label.hidden = YES;
    } else {//不作处理
        return;
    }
}

- (void)logoImageViewTap:(UITapGestureRecognizer *)gesture {
    if ([self.Qukan_model.isAttention integerValue] == 1) {//已经关注
        [self Qukan_del:[NSString stringWithFormat:@"%ld",self.Qukan_model.match_id]];
    } else {
        [self Qukan_add:[NSString stringWithFormat:@"%ld",self.Qukan_model.match_id]];
    }
}

- (void)Qukan_add:(NSString *)match_id {
    @weakify(self)
    //    KShowHUD
    kGuardLogin;
    self.attention_imageView.userInteractionEnabled = NO;
    [[[kApiManager QukanAttention_AddWithMatchId:match_id] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.attention_imageView.userInteractionEnabled = YES;
        self.attention_imageView.image = [UIImage imageNamed:@"Qukan_star_selected"];
        self.Qukan_model.isAttention = @"1";
        if (self.sign == 1) {
            if (self.QukanHot_didBlock) {
                self.QukanHot_didBlock();
            }
        }
        [QukanLocalNotification noticeWithType:MatchTypeFootball model:self.Qukan_model];
    } error:^(NSError * _Nullable error) {
        self.attention_imageView.userInteractionEnabled = YES;
         [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)Qukan_del:(NSString *)match_id {
    kGuardLogin;
    @weakify(self)
    self.attention_imageView.userInteractionEnabled = NO;
    [[[kApiManager QukanAttention_DelWithMatchId:match_id] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.attention_imageView.userInteractionEnabled = YES;
        self.attention_imageView.image = [UIImage imageNamed:@"Qukan_star"];
        //刷新
//        [kNotificationCenter postNotificationName:@"Qukan_didFocus_notificaton" object:nil];
         self.Qukan_model.isAttention = @"2";
        if (self.sign == 1) {
            if (self.QukanHot_didBlock) {
                self.QukanHot_didBlock();
            }
        }

        [QukanLocalNotification cancleLocationIdentifier:FormatString(@"%@%ld",MatchTypeFootball,self.Qukan_model.match_id)];
    } error:^(NSError * _Nullable error) {
        self.attention_imageView.userInteractionEnabled = YES;
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)attention_imageViewTap:(UITapGestureRecognizer *)tap {
    kGuardLogin
    if ([self.Qukan_model.isAttention integerValue] == 1) {//已经关注
        [self Qukan_del:[NSString stringWithFormat:@"%ld",self.Qukan_model.match_id]];
    } else {
        [self Qukan_add:[NSString stringWithFormat:@"%ld",self.Qukan_model.match_id]];
    }
}

#pragma mark ===================== Getters =================================

- (UIView *)back_view {
    if (!_back_view) {
        _back_view = UIView.new;
        _back_view.layer.cornerRadius = 12;
        _back_view.layer.masksToBounds = YES;
        _back_view.backgroundColor = kCommonWhiteColor;
        _back_view.transform = affineTransformMakeShear(-0.1,0);
        _back_view.userInteractionEnabled = YES;
    }
    return _back_view;
}

static CGAffineTransform affineTransformMakeShear(CGFloat xShear, CGFloat yShear) {
    return CGAffineTransformMake(1, yShear, xShear, 1, 0, 0);
}

-(UIImageView *)attention_imageView {
    if (!_attention_imageView) {
        _attention_imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _attention_imageView.contentMode = UIViewContentModeCenter;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(attention_imageViewTap:)];
        [_attention_imageView addGestureRecognizer:ges];
        _attention_imageView.userInteractionEnabled = YES;
        [self.contentView addSubview:_attention_imageView];
    }
    return _attention_imageView;
}

- (UILabel *)homeTeamRed_label {
    if (!_homeTeamRed_label) {
        _homeTeamRed_label = [[UILabel alloc] initWithFrame:CGRectZero];
        _homeTeamRed_label.backgroundColor = HEXColor(0xD0021B);
        _homeTeamRed_label.text = @"2";
        _homeTeamRed_label.font = kSystemFont(10);
        _homeTeamRed_label.textAlignment = NSTextAlignmentCenter;
        _homeTeamRed_label.textColor = [UIColor whiteColor];
    }
    return _homeTeamRed_label;
}

- (UILabel *)homeTeamYellow_label {
    if (!_homeTeamYellow_label) {
        _homeTeamYellow_label = [[UILabel alloc] initWithFrame:CGRectZero];
        _homeTeamYellow_label.backgroundColor = HEXColor(0xF5A623);
        _homeTeamYellow_label.text = @"2";
        _homeTeamYellow_label.font = kSystemFont(10);
        _homeTeamYellow_label.textAlignment = NSTextAlignmentCenter;
        _homeTeamYellow_label.textColor = [UIColor whiteColor];
    }
    return _homeTeamYellow_label;
}

- (UIImageView *)homeTeam_imageView {
    if (!_homeTeam_imageView) {
        _homeTeam_imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _homeTeam_imageView.contentMode = UIViewContentModeScaleAspectFit;
        _homeTeam_imageView.image = [UIImage imageNamed:@"Qukan_Hot_Default0"];
    }
    return _homeTeam_imageView;
}

-(UILabel *)homeTeamName_label {
    if (!_homeTeamName_label) {
        _homeTeamName_label = [[UILabel alloc] initWithFrame:CGRectZero];
        _homeTeamName_label.textAlignment = NSTextAlignmentRight;
        _homeTeamName_label.textColor = kCommonTextColor;
        _homeTeamName_label.font = [UIFont boldSystemFontOfSize:14];
    }
    return _homeTeamName_label;
}

- (UILabel *)matchName_label {
    if (!_matchName_label) {
        _matchName_label = [[UILabel alloc] initWithFrame:CGRectZero];
        _matchName_label.textAlignment = NSTextAlignmentLeft;
        _matchName_label.textColor = kCommonTextColor;
        _matchName_label.font = kSystemFont(12);
    }
    return _matchName_label;
}

- (UILabel *)matchTime_label {
    if (!_matchTime_label) {
        _matchTime_label = [[UILabel alloc] initWithFrame:CGRectZero];
        _matchTime_label.textAlignment = NSTextAlignmentRight;
        _matchTime_label.textColor = kCommonTextColor;
        _matchTime_label.font = kSystemFont(12);
    }
    return _matchTime_label;
}

- (UILabel *)vs_label {
    if (!_vs_label) {
        _vs_label = [[UILabel alloc] initWithFrame:CGRectZero];
        _vs_label.text = @"-";
        _vs_label.font = [UIFont boldSystemFontOfSize:26];
        _vs_label.textAlignment = NSTextAlignmentCenter;
        _vs_label.textColor = kCommonTextColor;
    }
    return _vs_label;
}

- (UILabel *)matchMinutes_label {
    if (!_matchMinutes_label) {
        _matchMinutes_label = [[UILabel alloc] initWithFrame:CGRectZero];
        _matchMinutes_label.font = kSystemFont(12);
        _matchMinutes_label.textColor = kThemeColor;
        _matchMinutes_label.textAlignment = NSTextAlignmentCenter;
        _matchMinutes_label.text = @"10‘";
    }
    return _matchMinutes_label;
}

- (UILabel *)score_label {
    if (!_score_label) {
        _score_label = [[UILabel alloc] initWithFrame:CGRectZero];
        _score_label.textAlignment = NSTextAlignmentCenter;
        _score_label.font = [UIFont boldSystemFontOfSize:26];
        _score_label.textColor = kCommonTextColor;
    }
    return _score_label;
}


//- (UILabel *)half_back_label {
//    if (!_half_back_label) {
//        _half_back_label = UILabel.new;
//        _half_back_label.backgroundColor = kSecondTableViewBackgroudColor;
//    }
//    return _half_back_label;
//}

-(UILabel *)halfAngle_label {
    if (!_halfAngle_label) {
        _halfAngle_label = [[UILabel alloc] initWithFrame:CGRectZero];
        _halfAngle_label.layer.masksToBounds = YES;
        _halfAngle_label.layer.cornerRadius = 9;
        _halfAngle_label.font = kSystemFont(10);
        _halfAngle_label.textColor = kCommonWhiteColor;
        _halfAngle_label.textAlignment = NSTextAlignmentCenter;
        _halfAngle_label.backgroundColor = HEXColor(0xD6D6D6);
    }
    return _halfAngle_label;
}

- (UIImageView *)guestTeam_imageView {
    if (!_guestTeam_imageView) {
        _guestTeam_imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _guestTeam_imageView.contentMode = UIViewContentModeScaleAspectFit;
        _guestTeam_imageView.image = [UIImage imageNamed:@"Qukan_Hot_Default1"];
    }
    return _guestTeam_imageView;
}

- (UILabel *)guestTeamRed_label {
    if (!_guestTeamRed_label) {
        _guestTeamRed_label = [[UILabel alloc] initWithFrame:CGRectZero];
        _guestTeamRed_label.backgroundColor = HEXColor(0xD0021B);
        _guestTeamRed_label.text = @"2";
        _guestTeamRed_label.font = kSystemFont(10);
        _guestTeamRed_label.textAlignment = NSTextAlignmentCenter;
        _guestTeamRed_label.textColor = [UIColor whiteColor];
    }
    return _guestTeamRed_label;
}

- (UILabel *)guestTeamYellow_label {
    if (!_guestTeamYellow_label) {
        _guestTeamYellow_label = [[UILabel alloc] initWithFrame:CGRectZero];
        _guestTeamYellow_label.backgroundColor = HEXColor(0xF5A623);
        _guestTeamYellow_label.text = @"2";
        _guestTeamYellow_label.font = kSystemFont(10);
        _guestTeamYellow_label.textAlignment = NSTextAlignmentCenter;
        _guestTeamYellow_label.textColor = [UIColor whiteColor];
    }
    return _guestTeamYellow_label;
}

- (UILabel *)guestTeamName_label {
    if (!_guestTeamName_label) {
         _guestTeamName_label = [[UILabel alloc] initWithFrame:CGRectZero];
        _guestTeamName_label.textAlignment = NSTextAlignmentLeft;
        _guestTeamName_label.textColor = kCommonTextColor;
        _guestTeamName_label.font = [UIFont boldSystemFontOfSize:14];
    }
    return _guestTeamName_label;
}

- (QukanMatchAniAndVideoView *)aniAndVideo_view {
    if (!_aniAndVideo_view) {
        _aniAndVideo_view = [[QukanMatchAniAndVideoView alloc] initWithFrame:CGRectMake(0, 0, 130, 20)];
        _aniAndVideo_view.layer.cornerRadius = 0;
    }
    return _aniAndVideo_view;
}

- (UIView *)view_btnSuper {
    if (!_view_btnSuper) {
        _view_btnSuper = [UIView new];
        _view_btnSuper.transform = affineTransformMakeShear(0.1,0);
        _view_btnSuper.layer.masksToBounds = YES;
        _view_btnSuper.layer.cornerRadius = 8;
    }
    return _view_btnSuper;
}


@end
