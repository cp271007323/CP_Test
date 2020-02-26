//
//  QukanMemberDataItemCell.m
//  Qukan
//
//  Created by Charlie on 2020/1/1.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanMemberDataItemCell.h"

@implementation QukanMemberDataItemCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //创建子视图
        [self createSubViews];
//        self.backgroundColor = kTableViewCommonBackgroudColor;
    }
    return self;
}

- (void) createSubViews {
    [self.contentView addSubview:_titleLabel = [UILabel new]];
    [self.contentView addSubview:_dataLabel = [UILabel new]];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
        make.right.mas_equalTo(-10);
    }];
    
    [_dataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(5);
    }];
    
    _titleLabel.text = @"首发/进球";
    _titleLabel.font = [UIFont systemFontOfSize:12];
    _titleLabel.textColor = kTextGrayColor;
    
    _dataLabel.text = @"20/50";
    _dataLabel.font = [UIFont systemFontOfSize:18];
    _dataLabel.textColor = kCommonDarkGrayColor;
}

@end
