//
//  QukanFTSubPlayerSimpleHeader.m
//  Qukan
//
//  Created by Charlie on 2020/1/4.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanFTSubPlayerSimpleHeader.h"

@interface QukanFTSubPlayerSimpleHeader()

@end

@implementation QukanFTSubPlayerSimpleHeader

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self createViews];
        self.contentView.backgroundColor = kTableViewCommonBackgroudColor;
    }
    return self;
}


- (void) createViews{
    [self.contentView addSubview:_nameLabel = [UILabel new]];
    [self.contentView addSubview:_positionLabel = [UILabel new]];
    [self.contentView addSubview:_goalLabel = [UILabel new]];
    [self.contentView addSubview:_assistLabel = [UILabel new]];
    [self.contentView addSubview:_worthLabel = [UILabel new]];
    
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
    }];
    _nameLabel.font = [UIFont boldSystemFontOfSize:12];
    _nameLabel.text = @"球员";
    _nameLabel.textColor = kCommonBlackColor;
    
    
    [_worthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5);
        make.width.mas_equalTo(70);
        make.centerY.mas_equalTo(0);
    }];
    _worthLabel.textAlignment = NSTextAlignmentCenter;
    _worthLabel.font = kFont12;
    _worthLabel.text = @"身价(欧元)";
    _worthLabel.textColor = kTextGrayColor;
    
    
    [_assistLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.worthLabel.mas_left).offset(-8);
        make.width.mas_equalTo(24);
        make.centerY.mas_equalTo(0);
    }];
    _assistLabel.textAlignment = NSTextAlignmentCenter;
    _assistLabel.font = kFont12;
    _assistLabel.text = @"助攻";
    _assistLabel.textColor = kTextGrayColor;
    //
    
    [_goalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.assistLabel.mas_left).offset(-8);
        make.width.mas_equalTo(24);
        make.centerY.mas_equalTo(0);
    }];
    _goalLabel.textAlignment = NSTextAlignmentCenter;
    _goalLabel.font = kFont12;
    _goalLabel.text = @"进球";
    _goalLabel.textColor = kCommonBlackColor;
    _goalLabel.textColor = kTextGrayColor;

    //
    [_positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.goalLabel.mas_left).offset(-8);
        make.width.mas_equalTo(36);
        make.centerY.mas_equalTo(0);
    }];
    _positionLabel.textAlignment = NSTextAlignmentCenter;
    _positionLabel.font = kFont12;
    _positionLabel.text = @"位置";
    _positionLabel.textColor = kCommonBlackColor;
    _positionLabel.textColor = kTextGrayColor;

    //    [_goalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.mas_equalTo(_positionLabel.right).offset(5);
    //        make.width.mas_equalTo(28);
    //        make.centerY.mas_equalTo(0);
    //    }];
    //    _goalLabel.textAlignment = NSTextAlignmentCenter;
    //    _goalLabel.font = kFont12;
    //    _goalLabel.text = @"10";
    //    _goalLabel.textColor = kCommonBlackColor;
    //    _goalLabel.backgroundColor = UIColor.greenColor;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
