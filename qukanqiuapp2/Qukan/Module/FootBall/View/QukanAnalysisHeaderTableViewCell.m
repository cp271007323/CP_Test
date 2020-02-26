//
//  QukanAnalysisHeaderTableViewCell.m
//  Qukan
//
//  Created by Kody on 2019/12/28.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanAnalysisHeaderTableViewCell.h"

@interface QukanAnalysisHeaderTableViewCell ()

@property(nonatomic, strong) UIImageView *homeTeam_imageView;
@property(nonatomic, strong) UIImageView *guestTeam_imageView;
@property(nonatomic, strong) UILabel *homeTeam_label;
@property(nonatomic, strong) UILabel *guestTeam_label;
@property(nonatomic, strong) UILabel *homeTeamRecord_label;
@property(nonatomic, strong) UILabel *guestTeamRecord_label;

@end

@implementation QukanAnalysisHeaderTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    [self.contentView addSubview:self.homeTeam_imageView];
    [self.homeTeam_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.width.height.offset(25);
        make.right.mas_equalTo(self.contentView.mas_centerX).offset(-40);
    }];
    
    [self.contentView addSubview:self.homeTeam_label];
    [self.homeTeam_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.homeTeam_imageView);
        make.right.mas_equalTo(self.homeTeam_imageView.mas_left).offset(-6);
        make.left.offset(10);
    }];
    
    [self.contentView addSubview:self.homeTeamRecord_label];
    [self.homeTeamRecord_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.homeTeam_label.mas_bottom).offset(10);
        make.right.mas_equalTo(self.homeTeam_label);
    }];
    
    [self.contentView addSubview:self.guestTeam_imageView];
    [self.guestTeam_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.width.height.mas_equalTo(self.homeTeam_imageView);
        make.left.mas_equalTo(self.contentView.mas_centerX).offset(40);
    }];
    
    [self.contentView addSubview:self.guestTeam_label];
    [self.guestTeam_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.guestTeam_imageView);
        make.left.mas_equalTo(self.guestTeam_imageView.mas_right).offset(6);
        make.right.offset(-10);
    }];
    
    [self.contentView addSubview:self.guestTeamRecord_label];
    [self.guestTeamRecord_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.homeTeamRecord_label);
        make.left.mas_equalTo(self.guestTeam_label);
    }];
}

#pragma mark ===================== Public Methods =======================

//设置足球
- (void)setFootDataWithModel:(QukanMatchInfoContentModel *)model {
    [self.homeTeam_imageView sd_setImageWithURL:[NSURL URLWithString:model.flag1] placeholderImage:kImageNamed(@"Qukan_Hot_Default0")];
    [self.guestTeam_imageView sd_setImageWithURL:[NSURL URLWithString:model.flag2] placeholderImage:kImageNamed(@"Qukan_Hot_Default1")];
    self.homeTeam_label.text = model.home_name;
    self.guestTeam_label.text = model.away_name;
    
    self.homeTeamRecord_label.hidden = self.guestTeamRecord_label.hidden = YES;
}

//设置篮球
- (void)setBasketDataWithModel:(QukanBasketBallMatchDetailModel *)model {
    [self.homeTeam_imageView sd_setImageWithURL:[NSURL URLWithString:model.awayLogo] placeholderImage:kImageNamed(@"")];
    [self.guestTeam_imageView sd_setImageWithURL:[NSURL URLWithString:model.homeLogo] placeholderImage:kImageNamed(@"")];
    self.homeTeam_label.text = model.guestTeam;
    self.guestTeam_label.text = model.homeTeam;
    
    self.homeTeamRecord_label.hidden = self.guestTeamRecord_label.hidden = YES;
}

#pragma mark ===================== Getters =================================

- (UIImageView *)homeTeam_imageView {
    if (!_homeTeam_imageView) {
        _homeTeam_imageView = UIImageView.new;
//        _homeTeam_imageView.contentMode = 2;
//        _homeTeam_imageView.clipsToBounds = YES;
    }
    return _homeTeam_imageView;
}

- (UIImageView *)guestTeam_imageView {
    if (!_guestTeam_imageView) {
        _guestTeam_imageView = UIImageView.new;
//        _guestTeam_imageView.contentMode = 2;
//        _guestTeam_imageView.clipsToBounds = YES;
    }
    return _guestTeam_imageView;
}

- (UILabel *)homeTeam_label {
    if (!_homeTeam_label) {
        _homeTeam_label = UILabel.new;
        _homeTeam_label.font = kFont12;
        _homeTeam_label.textColor = kCommonDarkGrayColor;
        _homeTeam_label.numberOfLines = 0;
        _homeTeam_label.textAlignment = NSTextAlignmentRight;
    }
    return _homeTeam_label;
}

- (UILabel *)guestTeam_label {
    if (!_guestTeam_label) {
        _guestTeam_label = UILabel.new;
        _guestTeam_label.font = kFont12;
        _guestTeam_label.numberOfLines = 0;
        _guestTeam_label.textColor = kCommonDarkGrayColor;
    }
    return _guestTeam_label;
}

- (UILabel *)homeTeamRecord_label {
    if (!_homeTeamRecord_label) {
        _homeTeamRecord_label = UILabel.new;
        _homeTeamRecord_label.textColor = HEXColor(0xB5B5B5);
        _homeTeamRecord_label.font = kFont10;
        _homeTeamRecord_label.text = @"--";
    }
    return _homeTeamRecord_label;
}

- (UILabel *)guestTeamRecord_label {
    if (!_guestTeamRecord_label) {
        _guestTeamRecord_label = UILabel.new;
        _guestTeamRecord_label.textColor = HEXColor(0xB5B5B5);
        _guestTeamRecord_label.font = kFont10;
        _guestTeamRecord_label.text = @"--";
    }
    return _guestTeamRecord_label;
}

@end
