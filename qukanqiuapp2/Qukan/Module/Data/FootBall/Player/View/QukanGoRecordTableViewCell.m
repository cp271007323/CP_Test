//
//  QukanGoRecordTableViewCell.m
//  Qukan
//
//  Created by Charlie on 2020/1/2.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanGoRecordTableViewCell.h"

@implementation QukanGoRecordTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //创建子视图
        [self createSubViews];
        //        self.backgroundColor = kTableViewCommonBackgroudColor;
    }
    return self;
}

- (void) createSubViews {
    [self.contentView addSubview:_seasonLab = [UILabel new]];
    [self.contentView addSubview:_timeLab = [UILabel new]];
    [self.contentView addSubview:_fromClubLab = [UILabel new]];
    [self.contentView addSubview:_toClubLab = [UILabel new]];
    
    CGFloat labelWidth = (kScreenWidth - 30 - 15)/4;
    
    [_seasonLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(labelWidth);
    }];
    
    [_timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.seasonLab.mas_right).offset(5);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(labelWidth);
    }];
    
    [_fromClubLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.timeLab.mas_right).offset(5);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(labelWidth);
    }];
    
    [_toClubLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.fromClubLab.mas_right).offset(5);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(labelWidth);
    }];
    
    _seasonLab.text = @"2013-2014";
    _timeLab.text = @"2013-2014";
    _fromClubLab.text = @"2013-2014";
    _toClubLab.text = @"广州恒大";
    
    _seasonLab.font = _timeLab.font = _fromClubLab.font = _toClubLab.font = [UIFont systemFontOfSize:12];
    _seasonLab.textColor = _timeLab.textColor = _fromClubLab.textColor = _toClubLab.textColor = kCommonTextColor;
    
    UIView* cutLine = [UIView new];
    cutLine.backgroundColor = HEXColor(0xE3E2E2);
    [self.contentView addSubview:cutLine];
    [cutLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.left.right.bottom.mas_equalTo(0);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
