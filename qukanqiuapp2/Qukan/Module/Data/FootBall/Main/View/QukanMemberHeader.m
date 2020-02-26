//
//  QukanMemberHeader.m
//  Qukan
//
//  Created by Charlie on 2019/12/25.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanMemberHeader.h"
@interface QukanMemberHeader()

@property (strong, nonatomic) UILabel *label_1;
@property (strong, nonatomic) UILabel *label_2;
@property (strong, nonatomic) UILabel *label_3;

@end

@implementation QukanMemberHeader

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self layoutViews];
    }
    return self;
}

- (void)layoutViews{
    [self addSubview:_label_1 = [UILabel new]];
    [self addSubview:_label_2 = [UILabel new]];
    [self addSubview:_label_3 = [UILabel new]];
    
    [_label_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(0);
    }];
    _label_1.text = @"排名";
    _label_1.font = kFont12;
    _label_1.textColor = kCommonWhiteColor;
    
    
    [_label_3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-8);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(36);
        
    }];
    _label_3.text = @"数据";
    _label_3.font = kFont12;
    _label_3.textColor = kCommonWhiteColor;
    _label_3.textAlignment = NSTextAlignmentCenter;
    
    [_label_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self->_label_3.mas_right).offset(-50);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(100);
    }];
    _label_2.text = @"球队";
    _label_2.font = kFont12;
    _label_2.textColor = kCommonWhiteColor;
    _label_2.textAlignment = NSTextAlignmentCenter;
    
    
    
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


@end
