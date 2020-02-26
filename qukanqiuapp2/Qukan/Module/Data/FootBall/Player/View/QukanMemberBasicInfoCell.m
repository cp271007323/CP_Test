//
//  QukanMemberBasicInfoCell.m
//  Qukan
//
//  Created by Charlie on 2020/1/2.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanMemberBasicInfoCell.h"


@implementation QukanMemberBasicInfoCell


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
    [self.contentView addSubview:_titleLabel = [UILabel new]];
    [self.contentView addSubview:_contentLabel = [UILabel new]];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(70);
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(120);
        make.centerY.mas_equalTo(0);
    }];
    
    _titleLabel.text = @"身高";
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.textColor = kTextGrayColor;
    
    _contentLabel.text = @"70kg";
    _contentLabel.font = [UIFont systemFontOfSize:14];
    _contentLabel.textColor = kCommonTextColor;
    
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
