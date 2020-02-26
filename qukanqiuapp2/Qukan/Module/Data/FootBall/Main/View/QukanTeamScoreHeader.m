//
//  QukanTeamScoreHeader.m
//  Qukan
//
//  Created by Charlie on 2019/12/31.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanTeamScoreHeader.h"

@interface QukanTeamScoreHeader()


@end

@implementation QukanTeamScoreHeader

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self layoutViews];
    }
    return self;
}

- (void)layoutViews{
    [self addSubview:_label_1 = [UILabel new]];
    [self addSubview:_label_3 = [UILabel new]];
    [self addSubview:_label_4 = [UILabel new]];
    [self addSubview:_label_5 = [UILabel new]];
    [self addSubview:_label_6 = [UILabel new]];
    [self addSubview:_label_7 = [UILabel new]];
    [self addSubview:_label_8 = [UILabel new]];
    
    _label_1.tag = 101;
    _label_3.tag = 103;
    _label_4.tag = 104;
    _label_5.tag = 105;
    _label_6.tag = 106;
    _label_7.tag = 107;
    _label_8.tag = 108;
    
    
    [_label_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
//        make.width.mas_equalTo(36);
        make.centerY.mas_equalTo(0);
    }];
    _label_1.text = @"排行榜";
    _label_1.font = kFont12;
    _label_1.textColor = kCommonWhiteColor;
    
//    [_label_2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(28);
//        make.right.mas_equalTo(self.label_3.mas_left).offset(-5);
//        make.centerY.mas_equalTo(0);
//    }];
//    _label_2.text = @"积分";
//    _label_2.font = kFont12;
//    _label_2.textColor = kCommonWhiteColor;
    
    [_label_8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(36);
    }];
    _label_8.text = @"进/失";
    _label_8.font = kFont12;
    _label_8.textColor = kCommonWhiteColor;
    _label_8.textAlignment = NSTextAlignmentCenter;
    
    [_label_7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.label_8.mas_left).offset(-5);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(18);
        
    }];
    _label_7.text = @"负";
    _label_7.font = kFont12;
    _label_7.textColor = kCommonWhiteColor;
    _label_7.textAlignment = NSTextAlignmentCenter;
    
    [_label_6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.label_7.mas_left).offset(-5);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(18);
        
    }];
    _label_6.text = @"平";
    _label_6.font = kFont12;
    _label_6.textColor = kCommonWhiteColor;
    _label_6.textAlignment = NSTextAlignmentCenter;
    
    [_label_5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.label_6.mas_left).offset(-5);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(18);
        
    }];
    _label_5.text = @"胜";
    _label_5.font = kFont12;
    _label_5.textColor = kCommonWhiteColor;
    _label_5.textAlignment = NSTextAlignmentCenter;
    
    [_label_4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.label_5.mas_left).offset(-5);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(28);
        
    }];
    _label_4.text = @"场次";
    _label_4.font = kFont12;
    _label_4.textColor = kCommonWhiteColor;
    _label_4.textAlignment = NSTextAlignmentCenter;
    
    
    [_label_3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.label_4.mas_left).offset(-5);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(28);
    }];
    _label_3.text = @"积分";
    _label_3.font = kFont12;
    _label_3.textColor = kCommonWhiteColor;
    _label_3.textAlignment = NSTextAlignmentCenter;
}


- (void)onlyShowTitle:(NSString*)title{
    self.label_1.text = title;
    for(int i = 103; i < 109; i++){
        [[self viewWithTag:i] setHidden:YES];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
