//
//  QukanLeagueRightHeaderView.m
//  Qukan
//
//  Created by leo on 2019/10/30.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanLeagueRightHeaderView.h"

@interface QukanLeagueRightHeaderView ()


@end


@implementation QukanLeagueRightHeaderView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
         self.backgroundColor = HEXColor(0xFAF9F9);
    }
    return self;
}


- (void)initUI {
    [self addSubview:self.lab_title];
    [self.lab_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(15);
    }];
}


#pragma mark ===================== function ==================================
//- (void)fullHeaderWithMode:(QukanLeagueInfoModel *)model {
//    self.lab_title.text = model.bigShort;
//}


#pragma mark ===================== lazy ==================================
- (UILabel *)lab_title {
    if (!_lab_title) {
        _lab_title = [[UILabel alloc] initWithFrame:CGRectZero];
        _lab_title.textColor = HEXColor(0x343434);
        _lab_title.font = kFont12;
    }
    return _lab_title;
}

@end
