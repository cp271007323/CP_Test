//
//  QukanBSKDetailScheduleCell.m
//  Qukan
//
//  Created by blank on 2019/12/26.
//  Copyright © 2019 mac. All rights reserved.
//
#import "QukanApiManager+BasketBall.h"
#import "QukanBSKDetailScheduleCell.h"
#import "QukanLocalNotification.h"
@interface QukanBSKDetailScheduleCell()
@property (nonatomic, strong)UILabel *league;
@property (nonatomic, strong)UILabel *date;
@property (nonatomic, strong)UILabel *guest;
@property (nonatomic, strong)UILabel *vs;
@property (nonatomic, strong)UILabel *home;
@property (nonatomic, strong)UIImageView *homeLogo;
@property (nonatomic, strong)UIImageView *guestLogo;
@property (nonatomic, strong)UIButton *collectBtn;
@property (nonatomic, strong)QukanSelectScheduleTeamModel *focusModel;
@end
@implementation QukanBSKDetailScheduleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.league];
        [self.contentView addSubview:self.date];
        [self.contentView addSubview:self.guestLogo];
        [self.contentView addSubview:self.homeLogo];
        [self.contentView addSubview:self.guest];
        [self.contentView addSubview:self.vs];
        [self.contentView addSubview:self.home];
        
        [self.contentView addSubview:self.collectBtn];
        [self.collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           make.centerY.offset(0);
           make.right.top.offset(0);
           make.width.offset(14*3);
        }];
        [self.collectBtn addTarget:self action:@selector(collectClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.date mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.top.offset(8);
            make.height.offset(17);
            make.width.offset(75);
        }];
        
        [self.league mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.bottom.offset(-7);
            make.height.offset(14);
        }];
        
        [self.vs mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(55);
            make.centerY.offset(0);
            make.height.offset(21);
            make.centerX.offset(40);
        }];
        
        [self.guestLogo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.vs.mas_left).offset(-6);
            make.centerY.offset(0);
            make.height.width.offset(23);
        }];
        [self.homeLogo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.vs.mas_right).offset(6);
            make.centerY.offset(0);
            make.height.width.offset(23);
        }];
        
        [self.guest mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.guestLogo.mas_left).offset(-2);
            make.height.offset(36);
            make.left.mas_equalTo(self.date.mas_right).offset(5);
            make.centerY.offset(0);
        }];
        
        [self.home mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.homeLogo.mas_right).offset(2);
            make.height.offset(36);
            make.right.equalTo(self.collectBtn.mas_left);
            make.centerY.offset(0);
        }];
        
        UIView *botLine = [UIView new];
        [self.contentView addSubview:botLine];
        [botLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.offset(0);
            make.height.offset(0.5);
        }];
        botLine.backgroundColor = HEXColor(0xE3E2E2);
        
       
        
    }
    return self;
}
- (void)collectClick:(UIButton *)sender {
    kGuardLogin
    [[self jsd_findVisibleViewController].view showLoading];
    @weakify(self)
    if (sender.selected == 0) {
        [[[kApiManager QukanGuanZhuPKWithMatchId:_model.matchId] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            self.collectBtn.selected = 1;
            [[self jsd_findVisibleViewController].view hideLoading];
            [QukanLocalNotification noticeWithType:BasketballTeam model:self.focusModel];
        } error:^(NSError * _Nullable error) {
            @strongify(self)
            [[self jsd_findVisibleViewController].view hideLoading];
        }];
    } else {
        [[[kApiManager QukanQuXiaoPKWithMatchId:_model.matchId] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            self.collectBtn.selected = 0;
            [[self jsd_findVisibleViewController].view hideLoading];
            [QukanLocalNotification cancleLocationIdentifier:FormatString(@"%@%@",BasketballTeam,self.focusModel.matchId)];
            
        } error:^(NSError * _Nullable error) {
            @strongify(self)
            [[self jsd_findVisibleViewController].view dismissHUD];
        }];
    }
}
- (void)setModel:(QukanSelectScheduleTeamModel *)model {
    _model = model;
    self.focusModel = model;
    self.collectBtn.selected = model.attention;
    NSString *month = [[model.matchTime substringFromIndex:4] substringToIndex:2];
    NSString *day = [model.matchTime substringFromIndex:6];
    self.league.text = model.leagueName;
    self.date.text = FormatString(@"%@-%@ %@",month,day,model.startTime);
    self.date.textColor = kCommonTextColor;
    self.guest.text = model.awayName;
    self.vs.text = @"vs";
    if (model.status.integerValue == 0) {
        //未开始
        self.vs.text = @"VS";
        self.vs.textColor = kCommonTextColor;
        self.vs.backgroundColor = UIColor.clearColor;
    } else if (model.status.integerValue == -1) {
        //完场
        self.vs.text = FormatString(@"%@-%@",model.awayScore,model.homeScore);
//        self.vs.backgroundColor = model.awayScore.integerValue > model.homeScore.integerValue ? HEXColor(0xF12B2B) : HEXColor(0x34A6F1);
        self.vs.textColor = kCommonWhiteColor;
        if (self.teamId.integerValue == model.awayId.integerValue) {
            self.vs.backgroundColor = model.awayScore.integerValue > model.homeScore.integerValue ? HEXColor(0xF12B2B) :HEXColor(0x34A6F1);
        } else {
            self.vs.backgroundColor = model.awayScore.integerValue > model.homeScore.integerValue ? HEXColor(0x34A6F1) :HEXColor(0xF12B2B);
        }
    } else if (model.status.integerValue > 0) {
        //进行中
        NSString *xiaojie;
        switch (model.status.integerValue) {
            case 1:
                xiaojie = @"第一节";
                break;
            case 2:
                xiaojie = @"第二节";
                break;
            case 3:
                xiaojie = @"第三节";
                break;
            case 4:
                xiaojie = @"第四节";
                break;
            case 5:
                xiaojie = @"加时赛";
                break;
            case 6:
                xiaojie = @"加时赛";
                break;
            case 7:
                xiaojie = @"加时赛";
                break;
            case 50:
                xiaojie = @"中场休息";
                break;
            default:
                break;
        }
        self.date.text = FormatString(@"%@ %@",xiaojie,model.remainTime.length ? model.remainTime : @"");
        self.date.textColor = kThemeColor;
        self.vs.text = FormatString(@"%@-%@",model.awayScore.length ? model.awayScore : @"-",model.homeScore.length ? model.homeScore : @"-");
        self.vs.textColor = kThemeColor;
        self.vs.backgroundColor = UIColor.clearColor;
    } else {
        NSString *xiaojie;
        switch (model.status.integerValue) {
            case -2:
                xiaojie = @"待定";
                break;
            case -3:
                xiaojie = @"中断";
                break;
            case -4:
                xiaojie = @"取消";
                break;
            case -5:
                xiaojie = @"推迟";
                break;
            default:
                break;
        }
        //异常
        self.vs.textColor = UIColor.redColor;
        self.vs.text = FormatString(@"%@-%@",model.awayScore.length ? model.awayScore : @"-",model.homeScore.length ? model.homeScore : @"-");
        self.date.text = FormatString(@"%@ %@",xiaojie,model.remainTime.length ? model.remainTime : @"");
        self.vs.backgroundColor = UIColor.clearColor;
    }
    self.home.text = model.homeName;
    [self.homeLogo sd_setImageWithURL:[NSURL URLWithString:model.homeLogo] placeholderImage:kImageNamed(@"Qukan_bsk_team")];
    [self.guestLogo sd_setImageWithURL:[NSURL URLWithString:model.awayLogo] placeholderImage:kImageNamed(@"Qukan_bsk_team")];
}
- (UILabel *)league {
    if (!_league) {
        _league = [UILabel new];
        _league.textColor = kTextGrayColor;
        _league.font = kFont10;
    }
    return _league;
}
- (UILabel *)date {
    if (!_date) {
        _date = [UILabel new];
        _date.font = kFont12;
        _date.textColor = kCommonTextColor;
    }
    return _date;
}
- (UILabel *)guest {
    if (!_guest) {
        _guest = [UILabel new];
        _guest.textAlignment = NSTextAlignmentRight;
        _guest.font = kFont12;
        _guest.numberOfLines = 0;
        _guest.textColor = kCommonTextColor;
    }
    return _guest;
}
- (UILabel *)vs {
    if (!_vs) {
        _vs = [UILabel new];
        _vs.layer.masksToBounds = 1;
        _vs.layer.cornerRadius = 4;
        _vs.font = kFont12;
        _vs.textAlignment = NSTextAlignmentCenter;
    }
    return _vs;
}
- (UILabel *)home {
    if (!_home) {
        _home = [UILabel new];
        _home.textAlignment = NSTextAlignmentLeft;
        _home.numberOfLines = 0;
        _home.textColor = kCommonTextColor;
        _home.font = kFont12;
    }
    return _home;
}
- (UIImageView *)homeLogo {
    if (!_homeLogo) {
        _homeLogo = [UIImageView new];
        _homeLogo.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _homeLogo;
}
- (UIImageView *)guestLogo {
    if (!_guestLogo) {
        _guestLogo = [UIImageView new];
        _guestLogo.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _guestLogo;
}
- (UIButton *)collectBtn {
    if (!_collectBtn) {
        _collectBtn = [UIButton new];
        [_collectBtn setImage:kImageNamed(@"Qukan_star_selected") forState:UIControlStateSelected];
        [_collectBtn setImage:kImageNamed(@"Qukan_star") forState:UIControlStateNormal];
    }
    return _collectBtn;
}
- (UIViewController *)jsd_getRootViewController{
    
    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    NSAssert(window, @"The window is empty");
    return window.rootViewController;
}
- (UIViewController *)jsd_findVisibleViewController {
    
    UIViewController* currentViewController = [self jsd_getRootViewController];
    
    BOOL runLoopFind = YES;
    while (runLoopFind) {
        if (currentViewController.presentedViewController) {
            currentViewController = currentViewController.presentedViewController;
        } else {
            if ([currentViewController isKindOfClass:[UINavigationController class]]) {
                currentViewController = ((UINavigationController *)currentViewController).visibleViewController;
            } else if ([currentViewController isKindOfClass:[UITabBarController class]]) {
                currentViewController = ((UITabBarController* )currentViewController).selectedViewController;
            } else {
                break;
            }
        }
    }
    
    return currentViewController;
}
@end
