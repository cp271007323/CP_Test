//
//  QukanDataPjCell.m
//  Qukan
//
//  Created by blank on 2019/12/26.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanBSKDataPjCell.h"
@interface QukanBSKDataPjCell()
@property (nonatomic, strong)UILabel *rank;
@property (nonatomic, strong)UIImageView *teamLogo;
@property (nonatomic, strong)UILabel *team;
@property (nonatomic, strong)UILabel *win;
@property (nonatomic, strong)UILabel *lose;
@property (nonatomic, strong)UILabel *winRate;
@end
@implementation QukanBSKDataPjCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = HEXColor(0x31373C);
        [self.contentView addSubview:self.rank];
        [self.contentView addSubview:self.team];
        [self.contentView addSubview:self.teamLogo];
        [self.contentView addSubview:self.win];
        [self.contentView addSubview:self.lose];
        [self.contentView addSubview:self.winRate];
        [self.rank mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(12);
            make.top.bottom.offset(0);
        }];
        [self.teamLogo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset(0);
            make.left.offset(65);
            make.width.height.offset(25);
        }];
        [self.team mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.offset(0);
            make.left.mas_equalTo(self.teamLogo.mas_right).offset(6);
        }];
        
        [self.winRate mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_right).offset(-48);
            make.top.bottom.offset(0);
        }];
        
        [self.lose mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_right).offset(-86);
            make.top.bottom.offset(0);
        }];
        
        [self.win mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_right).offset(-128);
            make.top.bottom.offset(0);
        }];


        
    }
    return self;
}
- (void)setModel:(QukanBSKDataPjModel *)model {
    self.rank.text = model.totalOrder.length ? model.totalOrder : @"--";
    self.team.text = model.name.length ? model.name : @"--";
    self.win.text = FormatString(@"%ld",model.homeWin.integerValue + model.awayWin.integerValue);
    self.lose.text = FormatString(@"%ld",model.homeLoss.integerValue + model.awayLoss.integerValue);
    self.winRate.text = FormatString(@"%@%%",model.winScale.length ? model.winScale : @"--");
    [self.teamLogo sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:kImageNamed(@"Qukan_bsk_team")];
}
- (UILabel *)rank {
    if (!_rank) {
        _rank = [UILabel new];
        _rank.textAlignment = NSTextAlignmentLeft;
        _rank.textColor = kCommonWhiteColor;
        _rank.font = kFont12;
    }
    return _rank;
}
- (UILabel *)team {
    if (!_team) {
        _team = [UILabel new];
        _team.textAlignment = NSTextAlignmentCenter;
        _team.textColor = kCommonWhiteColor;
        _team.font = kFont12;
    }
    return _team;
}
- (UILabel *)win {
    if (!_win) {
        _win = [UILabel new];
        _win.textAlignment = NSTextAlignmentLeft;
        _win.textColor = kCommonWhiteColor;
        _win.font = kFont12;
    }
    return _win;
}
- (UILabel *)lose {
    if (!_lose) {
        _lose = [UILabel new];
        _lose.textAlignment = NSTextAlignmentLeft;
        _lose.textColor = kCommonWhiteColor;
        _lose.font = kFont12;
    }
    return _lose;
}
- (UILabel *)winRate {
    if (!_winRate) {
        _winRate = [UILabel new];
        _winRate.textAlignment = NSTextAlignmentLeft;
        _winRate.textColor = kCommonWhiteColor;
        _winRate.font = kFont12;
    }
    return _winRate;
}
- (UIImageView *)teamLogo {
    if (!_teamLogo) {
        _teamLogo = [UIImageView new];
        _teamLogo.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _teamLogo;
}
@end
