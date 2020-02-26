//
//  QukanHotDateHeaderView.m
//  Qukan
//
//  Created by Kody on 2019/6/26.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanHotDateHeaderView.h"
#import <YYKit/YYKit.h>


@interface QukanHotDateHeaderView ()

@property (nonatomic, strong)NSString  *type;
@property(nonatomic, strong) UIView *back_view;

@end
@implementation QukanHotDateHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.backgroundColor = kSecondTableViewBackgroudColor;
    
    [self addSubview:self.back_view];
    [self.back_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(5);
        make.bottom.offset(-5);
        make.left.offset(-20);
        make.width.offset(180);
    }];
    
    [self addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(5);
        make.bottom.offset(-5);
        make.width.offset(130);
    }];
}

- (void)setDataWithData:(QukanHotDateModel *)model {
    self.timeLabel.text = @"";
}

- (void)setDataWithTime:(NSString *)timeStr {
    NSDate *date = [NSDate dateWithString:timeStr format:@"yyyy-MM-dd"];
    NSString *whichWeekStr = [QukanTool Qukan_getWeekDay:timeStr];
    
    if (date.isToday) {
         self.timeLabel.text = [NSString stringWithFormat:@"%@ 星期%@ (今天)",timeStr,whichWeekStr];
    } else if (date.isYesterday) {
        self.timeLabel.text = [NSString stringWithFormat:@"%@ 星期%@ (昨天)",timeStr,whichWeekStr];
    } else {
        self.timeLabel.text = [NSString stringWithFormat:@"%@ 星期%@",timeStr,whichWeekStr];
    }
}

- (void)timerLabelTap:(UITapGestureRecognizer *)gesture {
    if ([self.type integerValue] == 1) {//热门
//        self.QukanHot_didBlock();
    } else if ([self.type integerValue] == 2) {//关注
//        self.QukanFocus_didBlock();
    }
}

#pragma mark ===================== Getters =================================

- (UIView *)back_view {
    if (!_back_view) {
        _back_view = UIView.new;
        _back_view.backgroundColor = kCommonWhiteColor;
        _back_view.layer.cornerRadius = 15;
    }
    return _back_view;
}

-(UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.backgroundColor = kCommonWhiteColor;
        _timeLabel.textColor = kCommonTextColor;
        _timeLabel.font = kSystemFont(10);
    }
    return _timeLabel;
}



@end
