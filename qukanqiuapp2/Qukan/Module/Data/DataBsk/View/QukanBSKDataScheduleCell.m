//
//  QukanDataScheduleCell.m
//  Qukan
//
//  Created by blank on 2019/12/26.
//  Copyright © 2019 mac. All rights reserved.
//
#import "QukanBSKDataScheduleCell.h"
#import "QukanBasketTool.h"

@interface QukanBSKDataScheduleCell()

@property (nonatomic, strong)UILabel *time;
@property (nonatomic, strong)UILabel *guestName;
@property (nonatomic, strong)UIImageView *guestIcon;
@property (nonatomic, strong)UILabel *vsLab;
@property (nonatomic, strong)UIImageView *homeIcon;
@property (nonatomic, strong)UILabel *homeName;

@end
@implementation QukanBSKDataScheduleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = HEXColor(0x31373C);
        [self.contentView addSubview:self.time];
        [self.contentView addSubview:self.guestName];
        [self.contentView addSubview:self.vsLab];
        [self.contentView addSubview:self.homeName];
        [self.contentView addSubview:self.guestIcon];
        [self.contentView addSubview:self.homeIcon];
        [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.width.offset(55);
            make.top.bottom.offset(0);
        }];
        [self.guestName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.time.mas_right).offset(5);
            make.width.offset(SCALING_RATIO(88));
            make.top.bottom.offset(0);
        }];
        [self.guestIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.guestName.mas_right).offset(4);
            make.height.width.offset(25);
            make.centerY.mas_offset(0);
        }];

        [self.vsLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.guestIcon.mas_right).offset(0);
            make.top.bottom.offset(0);
            make.width.offset(SCALING_RATIO(80));
        }];

        [self.homeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.vsLab.mas_right).offset(0);
            make.height.width.offset(25);
            make.centerY.mas_offset(0);
        }];
        [self.homeName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.homeIcon.mas_right).offset(4);
            make.right.offset(-15);
            make.top.bottom.offset(0);
        }];
        
        
    }
    return self;
}
- (void)setModel:(QukanBSKDataScheduleModel *)model {
    _model = model;
    self.time.text = model.startTime.length ? model.startTime : @"--";
    self.time.textColor = HEXColor(0x626D7E);
    [self.homeIcon sd_setImageWithURL:[NSURL URLWithString:model.homeLogo] placeholderImage:kImageNamed(@"Qukan_bsk_team")];
    [self.guestIcon sd_setImageWithURL:[NSURL URLWithString:model.awayLogo] placeholderImage:kImageNamed(@"Qukan_bsk_team")];
    self.guestName.text = model.awayName.length ? model.awayName : @"--";
    
    QukanBasketMatchState state = [QukanBasketTool getStateForMathStatus:model.status.integerValue];
    
    if (state == QukanBasketMatchNoStart) {
        //未开始
        self.vsLab.text = @"VS";
    } else if (state == QukanBasketMatching || state == QukanBasketMatchended) {
        self.vsLab.text = FormatString(@"%@ : %@",model.awayScore.length ? model.awayScore : @"--",model.homeScore.length ? model.homeScore : @"--");
    }else if (state == QukanBasketMatchStateOther) {
        self.vsLab.text = [QukanBasketTool.sharedInstance qukan_getStateStrFromState:model.status.integerValue];
    }
    
    if (self.model.status.integerValue > 0) {
        self.time.text = FormatString(@"%@\n%@", model.getMatchNode, model.remainTime);
        self.time.textColor = kThemeColor;
    }
    
    self.homeName.text = model.homeName.length ? model.homeName : @"--";
}
- (UILabel *)time {
    if (!_time) {
        _time = [UILabel new];
        _time.textColor = HEXColor(0x626D7E);
        _time.numberOfLines = 2;
        _time.textAlignment = NSTextAlignmentCenter;
        _time.font = kFont12;
    }
    return _time;
}
- (UILabel *)guestName {
    if (!_guestName) {
        _guestName = [UILabel new];
        _guestName.textAlignment = NSTextAlignmentRight;
        _guestName.textColor = kCommonWhiteColor;
        _guestName.font = kFont12;
        _guestName.numberOfLines = 0;
    }
    return _guestName;
}
- (UILabel *)vsLab {
    if (!_vsLab) {
        _vsLab = [UILabel new];
        _vsLab.textColor = kCommonWhiteColor;
        _vsLab.font = kFont12;
        _vsLab.textAlignment = NSTextAlignmentCenter;
    }
    return _vsLab;
}
- (UILabel *)homeName {
    if (!_homeName) {
        _homeName = [UILabel new];
        _homeName.numberOfLines = 0;
        _homeName.textColor = kCommonWhiteColor;
        _homeName.font = kFont12;
    }
    return _homeName;
}
- (UIImageView *)homeIcon {
    if (!_homeIcon) {
        _homeIcon = [UIImageView new];
        _homeIcon.contentMode = UIViewContentModeScaleAspectFit;
    } return _homeIcon;
}
- (UIImageView *)guestIcon {
    if (!_guestIcon) {
        _guestIcon = [UIImageView new];
        _guestIcon.contentMode = UIViewContentModeScaleAspectFit;
    } return _guestIcon;
}
@end
