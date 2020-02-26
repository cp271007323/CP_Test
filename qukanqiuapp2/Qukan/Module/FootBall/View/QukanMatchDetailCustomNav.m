//
//  QukanMatchDetailCustomNav.m
//  Qukan
//
//  Created by leo on 2019/12/22.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanMatchDetailCustomNav.h"
#import "QukanMatchInfoModel.h"
#import "QukanBasketBallMatchDetailModel.h"

@implementation QukanMatchDetailCustomNav

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initUI {
    [self addSubview:self.view_bg];
    [self.view_bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    
    [self.view_bg addSubview:self.lab_title];
    [self.lab_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self);
        make.height.equalTo(@(44));
    }];
    
    [self addSubview:self.btn_back];
    [self.btn_back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.width.height.equalTo(@(44));
        make.left.equalTo(self);
    }];
    
    [self addSubview:self.lab_LSname];
    [self.lab_LSname mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.btn_back);
        make.left.equalTo(self.btn_back.mas_centerX).offset(10);
    }];
    
    [self addSubview:self.btn_share];
    [self.btn_share mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.width.height.equalTo(@(44));
        make.centerY.equalTo(self.btn_back);
    }];
    
    [self addSubview:self.view_timeBg];
    [self addSubview:self.lab_matchTime];
    
    [self.lab_matchTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self.btn_back);
    }];
    
    [self.view_timeBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lab_matchTime).offset(-4);
        make.top.equalTo(self.lab_matchTime).offset(-1);
        make.right.equalTo(self.lab_matchTime).offset(4);
        make.bottom.equalTo(self.lab_matchTime).offset(1);
    }];
    
    [self addSubview:self.lab_leftTeamDF];
    [self.lab_leftTeamDF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.btn_back);
        make.centerX.equalTo(self).offset(-kScreenWidth / 8);
    }];
    
    [self addSubview:self.lab_rightTeamDF];
    [self.lab_rightTeamDF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.btn_back);
        make.centerX.equalTo(self).offset(kScreenWidth / 8);
    }];
    
   
    
    [self addSubview:self.img_leftTeamIcon];
    [self.img_leftTeamIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.btn_back);
        make.centerX.equalTo(self).offset(-kScreenWidth / 4);
        make.width.height.equalTo(@(30));
    }];
    
    [self addSubview:self.img_rightTeamIcon];
    [self.img_rightTeamIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.btn_back);
        make.centerX.equalTo(self).offset(kScreenWidth / 4);
        make.width.height.equalTo(@(30));
    }];
    
}

#pragma mark ===================== function ==================================
- (void)setAlphaWithProgress:(CGFloat)progress {
    self.lab_LSname.alpha = 1 - progress;
    
    self.lab_leftTeamDF.alpha =  progress;
    self.lab_rightTeamDF.alpha =  progress;
    
    self.img_leftTeamIcon.alpha = progress;
    self.img_rightTeamIcon.alpha = progress;
    self.lab_matchTime.alpha = progress;
    self.view_timeBg.alpha = progress;
    
    
    self.view_bg.alpha = 1 - progress;
    self.lab_title.alpha = 1 - progress;
   
}

- (void)fullViewWithModel:(QukanMatchInfoContentModel *)model {
    
    self.lab_LSname.text = model.league_name;
    self.lab_rightTeamDF.text = [NSString stringWithFormat:@"%zd",model.away_score];
    self.lab_leftTeamDF.text = [NSString stringWithFormat:@"%zd",model.home_score];
    
    [self.img_leftTeamIcon sd_setImageWithURL:[NSURL URLWithString:model.flag1] placeholderImage:kImageNamed(@"Qukan_Hot_Default0")];
    [self.img_rightTeamIcon sd_setImageWithURL:[NSURL URLWithString:model.flag2] placeholderImage:kImageNamed(@"Qukan_Hot_Default1")];
    
    self.lab_matchTime.text = [NSString stringWithFormat:@"%@'",model.pass_time];
    self.lab_matchTime.text = (model.state == -1 || model.state == 0) ? (model.state == -1 ? @"已结束" : @"未开赛") : [NSString stringWithFormat:@"%@ %@'",[self selfMatchStateWhenPlayingWithModel:model],model.pass_time];
    
    @weakify(self)
    [RACObserve(model, pass_time) subscribeNext:^(id x) {
        @strongify(self)
        self.lab_matchTime.text = (model.state == -1 || model.state == 0) ? (model.state == -1 ? @"已结束" : @"未开赛") : [NSString stringWithFormat:@"%@ %@'",[self selfMatchStateWhenPlayingWithModel:model],model.pass_time];
    }];
}


- (void)fullViewWithBasketModel:(QukanBasketBallMatchDetailModel *)model {
    
    self.lab_LSname.text = model.leagueName;
    self.lab_rightTeamDF.text = model.status.integerValue == 0 ? @"0" : [NSString stringWithFormat:@"%@",model.homeScore];
    self.lab_leftTeamDF.text = model.status.integerValue == 0 ? @"0" : [NSString stringWithFormat:@"%@",model.guestScore];
    
    [self.img_leftTeamIcon sd_setImageWithURL:[NSURL URLWithString:model.awayLogo] placeholderImage:kImageNamed(@"Qukan_ke")];
    [self.img_rightTeamIcon sd_setImageWithURL:[NSURL URLWithString:model.homeLogo] placeholderImage:kImageNamed(@"Qukan_BSK")];

    self.lab_matchTime.text = (model.status.integerValue == -1 || model.status.integerValue == 0) ? (model.status.integerValue == -1 ? @"已结束" : @"未开赛") : [NSString stringWithFormat:@"%@'",model.remainTime];
}

- (void)btn_backClick{}
- (void)btn_shareClick{}

#pragma mark ===================== Public Methods =======================

- (NSString *)selfMatchStateWhenPlayingWithModel:(QukanMatchInfoContentModel *)model {
    if ([model isKindOfClass:[QukanMatchInfoContentModel class]]) {
        switch (model.state) {
            case 1:
                return @"上半场";
                break;
            case 2:
                return @"";
                break;
            case 3:
                return @"下半场";
                break;
            case 4:
                return @"加时";
                break;
            default:
                return nil;
                break;
        }
    }
    return nil;
}


#pragma mark ===================== lazy ==================================

- (UIView *)view_bg {
    if (!_view_bg) {
        _view_bg = [UIView new];
        _view_bg.backgroundColor = kCommonTextColor;
    }
    return _view_bg;
}


- (UILabel *)lab_title {
    if (!_lab_title) {
        _lab_title = [UILabel new];
        _lab_title.text = @"比赛详情";
        _lab_title.textColor = [UIColor whiteColor];
        _lab_title.font = [UIFont systemFontOfSize:17];
    }
    return _lab_title;
}

- (UIButton *)btn_back {
    if (!_btn_back) {
        _btn_back = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn_back setImage:kImageNamed(@"Qukan_Play_Back") forState:UIControlStateNormal];
        [_btn_back addTarget:self action:@selector(btn_backClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn_back;
}

- (UILabel *)lab_LSname {
    if (!_lab_LSname) {
        _lab_LSname = [UILabel new];
        _lab_LSname.textAlignment = NSTextAlignmentCenter;
        _lab_LSname.textColor = [UIColor whiteColor];
        _lab_LSname.font = [UIFont boldSystemFontOfSize:16];
        _lab_LSname.text = @"--";
        _lab_LSname.alpha = 1;
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btn_backClick)];
        _lab_LSname.userInteractionEnabled = YES;
        [_lab_LSname addGestureRecognizer:tap];
    }
    return _lab_LSname;
}

- (UIButton *)btn_share {
    if (!_btn_share) {
        _btn_share = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn_share setImage:kImageNamed(@"Qukan_competition_share") forState:UIControlStateNormal];
        [_btn_share addTarget:self action:@selector(btn_shareClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn_share;
}

- (UILabel *)lab_leftTeamDF {
    if (!_lab_leftTeamDF) {
        _lab_leftTeamDF = [UILabel new];
        _lab_leftTeamDF.textAlignment = NSTextAlignmentCenter;
        _lab_leftTeamDF.textColor = [UIColor whiteColor];
        _lab_leftTeamDF.font = [UIFont boldSystemFontOfSize:16];
        _lab_leftTeamDF.text = @"--";
        _lab_leftTeamDF.alpha = 0;
    }
    return _lab_leftTeamDF;
}

- (UILabel *)lab_rightTeamDF {
    if (!_lab_rightTeamDF) {
        _lab_rightTeamDF = [UILabel new];
        _lab_rightTeamDF.textAlignment = NSTextAlignmentCenter;
        _lab_rightTeamDF.textColor = [UIColor whiteColor];
        _lab_rightTeamDF.font = [UIFont boldSystemFontOfSize:16];
        _lab_rightTeamDF.text = @"--";
        _lab_rightTeamDF.alpha = 0;
    }
    return _lab_rightTeamDF;
}

- (UIImageView *)img_leftTeamIcon {
    if (!_img_leftTeamIcon) {
        _img_leftTeamIcon = [UIImageView new];
        _img_leftTeamIcon.image = kImageNamed(@"Qukan_mineHeadIcon");
        _img_leftTeamIcon.alpha = 0;
        _img_leftTeamIcon.layer.masksToBounds = YES;
        _img_leftTeamIcon.layer.cornerRadius = 15;
        
    }
    return _img_leftTeamIcon;
}

- (UIImageView *)img_rightTeamIcon {
    if (!_img_rightTeamIcon) {
        _img_rightTeamIcon = [UIImageView new];
        _img_rightTeamIcon.image = kImageNamed(@"Qukan_mineHeadIcon");
        _img_rightTeamIcon.alpha = 0;
        _img_rightTeamIcon.layer.masksToBounds = YES;
        _img_rightTeamIcon.layer.cornerRadius = 15;
    }
    return _img_rightTeamIcon;
}


- (UILabel *)lab_matchTime {
    if (!_lab_matchTime) {
        _lab_matchTime = [UILabel new];
        _lab_matchTime.textAlignment = NSTextAlignmentCenter;
        _lab_matchTime.textColor = [UIColor whiteColor];
        _lab_matchTime.font = kFont11;
        _lab_matchTime.text = @"--";
        _lab_matchTime.alpha = 0;
    }
    return _lab_matchTime;
}

- (UIView *)view_timeBg {
    if (!_view_timeBg) {
        _view_timeBg = [UIView new];
        _view_timeBg.backgroundColor = COLOR_HEX((0x000000), 0.2);
        _view_timeBg.alpha = 0;
    }
    return _view_timeBg;
}
@end
