//
//  QukanMemberSubDataHeader.m
//  Qukan
//
//  Created by Charlie on 2020/1/1.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanMemberSubDataHeader.h"

@implementation QukanMemberSubDataHeader
- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = kTableViewCommonBackgroudColor;
        [self layoutView];
    }
    return self;
}

- (void) layoutView {
    [self addSubview:_label_1 = [UILabel new]];
    [self addSubview:_label_2 = [UILabel new]];
    [self addSubview:_label_3 = [UILabel new]];
    [self addSubview:_label_4 = [UILabel new]];
    
    CGFloat labelWidth = (kScreenWidth - 30 - 15)/4;
    
    [_label_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(labelWidth);
    }];
    
    [_label_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.label_1.mas_right).offset(5);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(labelWidth);
    }];
    
    [_label_3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.label_2.mas_right).offset(5);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(labelWidth);
    }];
    
    [_label_4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.label_3.mas_right).offset(5);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(labelWidth);
    }];
    
    _label_1.text = @"常规数据";
    _label_2.text = @"";
    _label_3.text = @"";
    _label_4.text = @"";
    
    _label_1.font = _label_2.font = _label_3.font = _label_4.font = [UIFont boldSystemFontOfSize:12];
    _label_1.textColor = _label_2.textColor = _label_3.textColor = _label_4.textColor = kCommonTextColor;
    

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
