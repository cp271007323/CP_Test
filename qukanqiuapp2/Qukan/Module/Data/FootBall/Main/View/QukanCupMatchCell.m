//
//  QukanCupMatchCell.m
//  Qukan
//
//  Created by Charlie on 2020/1/6.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanCupMatchCell.h"
#import "QukanApiManager+Competition.h"

@interface QukanCupMatchCell()
@property (strong, nonatomic) UILabel *starTimeLabel;
@property (strong, nonatomic) UILabel *cupNameLabel;
@property (strong, nonatomic) UILabel *hostNameLabel;
@property (strong, nonatomic) UIImageView *hostFlagImgV;
@property (strong, nonatomic) UILabel *scoreLabel;
@property (strong, nonatomic) UIImageView *guestFlagImgV;
@property (strong, nonatomic) UILabel *guestNameLabel;

@property (strong, nonatomic) UILabel *hostRedLabel;
@property (strong, nonatomic) UILabel *hostYellowLabel;
@property (strong, nonatomic) UILabel *guestRedLabel;
@property (strong, nonatomic) UILabel *guestYellowLabel;

@property (strong, nonatomic) UILabel *statusLabel;


@property (strong, nonatomic) UIImageView *half_imageView;
@property (strong, nonatomic) UILabel *half_back_label;
@property (strong, nonatomic) UILabel *halfAngle_label;

@property(nonatomic, strong) UIImageView *attention_imageView;

@property(nonatomic,strong) QukanCupMatchModel* model;
@end

@implementation QukanCupMatchCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self layoutViews];
        self.contentView.backgroundColor = HEXColor(0x31373C);
    }
    return self;
}

- (void)layoutViews{
    
    [self.contentView addSubview:_starTimeLabel = [UILabel new]];
    [self.contentView addSubview:_cupNameLabel = [UILabel new]];
    [self.contentView addSubview:_hostNameLabel = [UILabel new]];
    [self.contentView addSubview:_hostFlagImgV = [UIImageView new]];
    [self.contentView addSubview:_guestFlagImgV = [UIImageView new]];
    [self.contentView addSubview:_guestNameLabel = [UILabel new]];
    [self.contentView addSubview:_scoreLabel = [UILabel new]];
    
    [self.contentView addSubview:_hostRedLabel = [UILabel new]];
    [self.contentView addSubview:_hostYellowLabel = [UILabel new]];
    [self.contentView addSubview:_guestRedLabel = [UILabel new]];
    [self.contentView addSubview:_guestYellowLabel = [UILabel new]];
    
    [self.contentView addSubview:_statusLabel = [UILabel new]];
    
    
    [self.contentView addSubview:_half_imageView = [UIImageView new]];
    [self.contentView addSubview:_half_back_label = [UILabel new]];
    [self.contentView addSubview:_halfAngle_label = [UILabel new]];
    
    [self.contentView addSubview:self.attention_imageView];
    [self.attention_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.offset(10);
       make.centerY.equalTo(self.contentView.mas_centerY).offset(10);
       make.width.height.equalTo(@(50));
    }];
    
    [_cupNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(14);
    }];
    _cupNameLabel.text = @"世界杯";
    _cupNameLabel.font = kFont12;
    _cupNameLabel.textColor = kCommonWhiteColor;
    _cupNameLabel.textAlignment = NSTextAlignmentCenter;
    
    [_starTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.centerY.mas_equalTo(self.cupNameLabel);
    }];
    _starTimeLabel.text = @"05-23 13:00";
    _starTimeLabel.font = kFont10;
    _starTimeLabel.textColor = kCommonWhiteColor;
    _starTimeLabel.textAlignment = NSTextAlignmentLeft;
    
    [_scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(70);
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.cupNameLabel.mas_bottom).offset(6);
    }];
    _scoreLabel.text = @"3-1";
    _scoreLabel.font = [UIFont boldSystemFontOfSize:26];
    _scoreLabel.textColor = kCommonWhiteColor;
    _scoreLabel.textAlignment = NSTextAlignmentCenter;

    [_hostFlagImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.scoreLabel.mas_left).offset(-8);
        make.centerY.mas_equalTo(self.scoreLabel);
        make.width.mas_equalTo(38);
        make.height.mas_equalTo(38);
    }];
    _hostFlagImgV.backgroundColor = RGBSAMECOLOR(247);

    [_hostNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.hostFlagImgV.mas_left).offset(-10);
        make.centerY.mas_equalTo(self.scoreLabel);
        make.left.mas_equalTo(3);

    }];
    _hostNameLabel.text = @"中国";
    _hostNameLabel.font = [UIFont boldSystemFontOfSize:12];
    _hostNameLabel.textColor = kCommonWhiteColor;
    _hostNameLabel.textAlignment = NSTextAlignmentRight;

    
    [_guestFlagImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scoreLabel.mas_right).offset(8);
        make.centerY.mas_equalTo(self.scoreLabel);
        make.width.mas_equalTo(38);
        make.height.mas_equalTo(38);
    }];
    _guestFlagImgV.backgroundColor = RGBSAMECOLOR(245);
    
    [_guestNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.guestFlagImgV.mas_right).offset(10);
        make.centerY.mas_equalTo(self.scoreLabel);
        make.right.mas_equalTo(-3);
    }];
    _guestNameLabel.text = @"法国";
    _guestNameLabel.font = [UIFont boldSystemFontOfSize:12];
    _guestNameLabel.textColor = kCommonWhiteColor;
    _guestNameLabel.textAlignment = NSTextAlignmentLeft;

    [_hostRedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(self.hostNameLabel.mas_centerX).offset(-2);
        make.right.mas_equalTo(self.hostYellowLabel.mas_left).offset(-5);

        make.top.mas_equalTo(self.hostNameLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(12);
        make.width.mas_equalTo(10);
    }];
    _hostRedLabel.text = @"1";
    _hostRedLabel.font = kFont10;
    _hostRedLabel.textColor = kCommonWhiteColor;
    _hostRedLabel.textAlignment = NSTextAlignmentCenter;
    _hostRedLabel.backgroundColor = HEXColor(0xD0021B);
    _hostRedLabel.layer.masksToBounds = YES;
    _hostRedLabel.layer.cornerRadius = 2;
    
    [_hostYellowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.hostNameLabel.mas_centerX).offset(2);
        make.right.mas_equalTo(self.hostNameLabel.mas_right).offset(-5);
        make.centerY.mas_equalTo(self.hostRedLabel);
        make.height.mas_equalTo(14);
        make.width.mas_equalTo(10);
    }];
    _hostYellowLabel.text = @"2";
    _hostYellowLabel.font = kFont10;
    _hostYellowLabel.textColor = kCommonWhiteColor;
    _hostYellowLabel.textAlignment = NSTextAlignmentCenter;
    _hostYellowLabel.backgroundColor = HEXColor(0xF5A623);
    _hostYellowLabel.layer.masksToBounds = YES;
    _hostYellowLabel.layer.cornerRadius = 2;
    
    
    [_guestYellowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(self.guestNameLabel.mas_centerX).offset(-2);
        make.left.mas_equalTo(self.guestNameLabel.mas_left).offset(5);

        make.centerY.mas_equalTo(self.hostRedLabel);
        make.height.mas_equalTo(14);
        make.width.mas_equalTo(10);
    }];
    _guestYellowLabel.text = @"3";
    _guestYellowLabel.font = kFont10;
    _guestYellowLabel.textColor = kCommonWhiteColor;
    _guestYellowLabel.textAlignment = NSTextAlignmentCenter;
    _guestYellowLabel.backgroundColor = HEXColor(0xF5A623);
    _guestYellowLabel.layer.masksToBounds = YES;
    _guestYellowLabel.layer.cornerRadius = 2;
    
    [_guestRedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.guestNameLabel.mas_centerX).offset(2);
        make.left.mas_equalTo(self.guestYellowLabel.mas_right).offset(5);

        make.centerY.mas_equalTo(self.hostRedLabel);
        make.height.mas_equalTo(14);
        make.width.mas_equalTo(10);
    }];
    _guestRedLabel.text = @"4";
    _guestRedLabel.font = kFont10;
    _guestRedLabel.textColor = kCommonWhiteColor;
    _guestRedLabel.textAlignment = NSTextAlignmentCenter;
    _guestRedLabel.backgroundColor = HEXColor(0xD0021B);
    _guestRedLabel.layer.masksToBounds = YES;
    _guestRedLabel.layer.cornerRadius = 2;
    
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(-15);
        make.height.mas_equalTo(16);
        make.width.mas_equalTo(70);
    }];
    _statusLabel.text = @"已结束";
    _statusLabel.font = kSystemFont(9);
    _statusLabel.textColor = kCommonWhiteColor;
    _statusLabel.textAlignment = NSTextAlignmentCenter;
    _statusLabel.backgroundColor = kTextGrayColor;
    _statusLabel.layer.masksToBounds = YES;
    _statusLabel.layer.cornerRadius = 8;
    
    
    [_halfAngle_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-8);
        make.width.mas_equalTo(75);
        make.height.mas_equalTo(22);
        make.right.mas_equalTo(0);
    }];
    _halfAngle_label.font = kSystemFont(9);
    _halfAngle_label.textColor = kTextGrayColor;
    _halfAngle_label.textAlignment = NSTextAlignmentRight;
    _halfAngle_label.backgroundColor = UIColor.clearColor;
    _halfAngle_label.text = @"半:2-2 角:4-5 ";
    
    [_half_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.bottom.mas_equalTo(self.halfAngle_label);
        make.width.mas_equalTo(30);
        make.left.mas_equalTo(self.halfAngle_label);
    }];
    
    _half_imageView.image =  [kImageNamed(@"Qukan_half") imageWithColor:HEXColor(0x494b4e)];
    _half_imageView.contentMode = 0;
    
    [_half_back_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.half_imageView.mas_right);
        make.top.right.height.mas_equalTo(self.halfAngle_label);
    }];
    _half_back_label.backgroundColor = HEXColor(0x494b4e);

    UIView*cutLine = [UIView new];
    cutLine.backgroundColor = HEXColor(0x222222);
    [self.contentView addSubview:cutLine];
    [cutLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
}
//|state|Int|否|”比赛状态 0:未开 1:上半场 2:中场 3:下半场 4 加时，-11:待定 -12:腰斩 -13:中断 -14:推迟 -1:完场，-10取消”
-(NSString *)stateForIndex:(NSInteger)index{
    switch (index) {
        case 0: return @"未开赛"; break;
        case 1: return @"上半场"; break;
        case 2: return @"中场"; break;
        case 3: return @"下半场"; break;
        case 4: return @"加时"; break;
        case -11: return @"待定"; break;
        case -12: return @"腰斩"; break;
        case -13: return @"中断"; break;
        case -14: return @"推迟"; break;
        case -1: return @"完场"; break;
        case -10: return @"取消"; break;
        default: return @"未知"; break;
    }
}

- (void)setModel:(QukanCupMatchModel*)model{
    _model = model;
    _starTimeLabel.text = [model.start_time length] > 0?  [model.start_time substringWithRange:NSMakeRange(5,11)]:@"";
    _cupNameLabel.text = model.league_name;
    _hostNameLabel.text = model.home_name;
    [_hostFlagImgV sd_setImageWithURL:[NSURL URLWithString:model.flag1] placeholderImage:kImageNamed(@"ft_default_flag")];;
    if([model.state intValue] == 0){
        _scoreLabel.text = @"VS";
    }else{
        _scoreLabel.text = FormatString(@"%@:%@",model.home_score,model.away_score);
    }
    [_guestFlagImgV sd_setImageWithURL:[NSURL URLWithString:model.flag2] placeholderImage:kImageNamed(@"ft_default_flag")];;
    _guestNameLabel.text = model.away_name;
    
    _hostRedLabel.text = model.red1;
    _hostYellowLabel.text = model.yellow1;
    _guestRedLabel.text = model.red2;
    _guestYellowLabel.text = model.yellow2;
    
    _statusLabel.text = [self stateForIndex: model.state.intValue];

    _halfAngle_label.text = FormatString(@"半:%@-%@ 角:%@-%@",model.bc1,model.bc2,model.corner1,model.corner2);

    if ([model.isAttention integerValue] == 1) {
        self.attention_imageView.image = [UIImage imageNamed:@"Qukan_star_selected"];
    } else {
        self.attention_imageView.image = [UIImage imageNamed:@"Qukan_star"];
    }
    
}

-(UIImageView *)attention_imageView {
    if (!_attention_imageView) {
        _attention_imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _attention_imageView.contentMode = UIViewContentModeCenter;
        _attention_imageView.image = kImageNamed(@"Qukan_star");
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(attention_imageViewTap:)];
        [_attention_imageView addGestureRecognizer:ges];
        _attention_imageView.userInteractionEnabled = YES;
        [self.contentView addSubview:_attention_imageView];
    }
    return _attention_imageView;
}

- (void)attention_imageViewTap:(UITapGestureRecognizer *)tap {
    kGuardLogin
    if ([self.model.isAttention integerValue] == 1) {//已经关注
        [self Qukan_del:self.model.match_id];
    } else {
        [self Qukan_add:self.model.match_id];
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
        self.attention_imageView.image = [[UIImage imageNamed:@"Qukan_star_selected"] imageWithColor:kThemeColor];
        self.model.isAttention = @"1";
//        if (self.sign == 1) {
//            if (self.QukanHot_didBlock) {
//                self.QukanHot_didBlock();
//            }
//        }
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
         self.model.isAttention = @"2";
//        if (self.sign == 1) {
//            if (self.QukanHot_didBlock) {
//                self.QukanHot_didBlock();
//            }
//        }
    } error:^(NSError * _Nullable error) {
        self.attention_imageView.userInteractionEnabled = YES;
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}


@end
