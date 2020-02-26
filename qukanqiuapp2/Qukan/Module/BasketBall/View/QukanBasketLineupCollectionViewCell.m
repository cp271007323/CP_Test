//
//  QukanBasketLineupCollectionViewCell.m
//  Qukan
//
//  Created by Kody on 2020/1/2.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanBasketLineupCollectionViewCell.h"

@interface QukanBasketLineupCollectionViewCell ()

@property(nonatomic, strong) UIImageView *logo_imageView;
@property(nonatomic, strong) UILabel *number_label;
@property(nonatomic, strong) UILabel *name_label;
@property(nonatomic, strong) UILabel *location_label;

@end

@implementation QukanBasketLineupCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.contentView.backgroundColor = kCommonWhiteColor;
    
    [self.contentView addSubview:self.logo_imageView];
    [self.logo_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(16);
        make.width.height.offset(25);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    [self.logo_imageView addSubview:self.number_label];
    [self.number_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.logo_imageView);
    }];
    
    [self.contentView addSubview:self.name_label];
    [self.name_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.logo_imageView.mas_right).offset(4);
        make.top.mas_equalTo(self.logo_imageView);
    }];
    
    [self.contentView addSubview:self.location_label];
    [self.location_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.name_label);
        make.top.mas_equalTo(self.name_label.mas_bottom).offset(2);
    }];
}

- (void)setDataWithModel:(QukanBasketBallMatchDetailModel *)model withIndex:(NSInteger)index {
    [self.logo_imageView sd_setImageWithURL:[NSURL URLWithString:index != 0 ? model.homeLogo : model.awayLogo] placeholderImage:kImageNamed(@"")];
    self.name_label.text = index == 0 ? model.guestTeam : model.homeTeam;
    
    self.name_label.font = kFont12;
    self.location_label.hidden = YES;
    self.number_label.hidden = YES;
    [self.name_label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.logo_imageView.mas_right).offset(4);
        make.centerY.mas_equalTo(self.contentView);
    }];
}

- (void)setDataWithModel:(QukanHomeAndGuestPlayerListModel *)model withSection:(NSInteger)section withIndex:(NSInteger)index {
    self.name_label.text = model.player;
    self.location_label.text = model.location;
    self.number_label.text = model.number;
    
    self.name_label.font = kFont10;
    self.location_label.hidden = NO;
    self.number_label.hidden = NO;
    self.number_label.backgroundColor = (section == 0 && index % 2 == 0) ? kThemeColor : section == 0 ? HEXColor(0x00B24E) : HEXColor(0x878787);
    [self.name_label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.logo_imageView.mas_right).offset(4);
        make.top.mas_equalTo(self.logo_imageView);
    }];
}

#pragma mark ===================== Getters =================================

- (UIImageView *)logo_imageView {
    if (!_logo_imageView) {
        _logo_imageView = UIImageView.new;
        _logo_imageView.contentMode = 2;
        _logo_imageView.clipsToBounds = YES;
        _logo_imageView.layer.cornerRadius = 12.5;
        _logo_imageView.layer.masksToBounds = YES;
    }
    return _logo_imageView;
}

- (UILabel *)number_label {
    if (!_number_label) {
        _number_label = UILabel.new;
        _number_label.textColor = kCommonWhiteColor;
        _number_label.font = kFont14;
        _number_label.textAlignment = NSTextAlignmentCenter;
        _number_label.layer.cornerRadius = 12.5;
        _number_label.layer.masksToBounds = YES;
    }
    return _number_label;
}

- (UILabel *)name_label {
    if (!_name_label) {
        _name_label = UILabel.new;
        _name_label.textColor = kCommonDarkGrayColor;
        _name_label.font = kFont10;
        
    }
    return _name_label;
}

- (UILabel *)location_label {
    if (!_location_label) {
        _location_label = UILabel.new;
        _location_label.textColor = HEXColor(0x666666);
        _location_label.font = kFont10;
    }
    return _location_label;
}

@end
