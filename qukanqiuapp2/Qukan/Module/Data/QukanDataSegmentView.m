//
//  QukanDataSegmentView.m
//  Qukan
//
//  Created by blank on 2019/12/27.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanDataSegmentView.h"

@implementation QukanDataSegmentView
- (instancetype)initWithFrame:(CGRect)frame segmentBlock:(void (^)(Tag_Btn tag))segBlock {
    if (self = [super initWithFrame:frame]) {
        UIView *backView = [UIView new];
        [self addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.offset(0);
        }];
        backView.backgroundColor = kCommonTextColor;
        
        UIImageView *setIgv = [UIImageView new];
        [backView addSubview:setIgv];
        [setIgv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.top.offset(kStatusBarHeight + 10);
            make.width.height.offset(15);
        }];
        setIgv.userInteractionEnabled = 1;
        setIgv.backgroundColor = kRandomColor;
    
        UIButton *setBtn = [UIButton new];
        [backView addSubview:setBtn];
        [setBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(setIgv.mas_centerX).offset(0);
            make.centerY.mas_equalTo(setIgv.mas_centerY).offset(0);
            make.height.width.offset(45);
        }];
        setBtn.tag = T_set;
        [[setBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            segBlock(setBtn.tag);
        }];
        
        
        UILabel *eventLab = [UILabel new];
        [backView addSubview:eventLab];
        [eventLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-15);
            make.top.offset(kStatusBarHeight + 10);
            make.width.offset(24);
            make.height.offset(17);
        }];
        eventLab.text = @"赛事";
        eventLab.font = kFont12;
        eventLab.textColor = kCommonWhiteColor;
        
        UIImageView *eventIgv = [UIImageView new];
        [backView addSubview:eventIgv];
        [eventIgv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(kStatusBarHeight + 12);
            make.width.height.offset(12);
            make.right.mas_equalTo(eventLab.mas_left).offset(-4);
        }];
        eventIgv.userInteractionEnabled = 1;
        eventIgv.backgroundColor = kRandomColor;
        
        UIButton *eventBtn = [UIButton new];
        [backView addSubview:eventBtn];
        [eventBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(eventIgv.mas_left).offset(15);
            make.right.offset(0);
            make.centerY.mas_equalTo(eventLab.mas_centerY).offset(0);
            make.height.offset(17+30);
        }];
        eventBtn.tag = T_sport_event;
        [[eventBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            segBlock(eventBtn.tag);
        }];
        
        NSArray *titles = @[@"足球",@"篮球"];
        __block NSInteger recordIndex = T_football;
        NSMutableArray *btns = [NSMutableArray new];
        for (int i = 0;i < titles.count;i++) {
            UIButton *btn = [UIButton new];
            [backView addSubview:btn];
            btn.frame = CGRectMake(self.centerX- (i == 0 ? 60 : 0), kStatusBarHeight + 7, 60, 30);
            btn.selected = i == 0 ? 1 : 0;
            btn.tag = i == 0 ? T_football : T_basketball;
            [btn setBackgroundImage:[UIImage imageWithColor:kThemeColor] forState:UIControlStateSelected];
            [btn setBackgroundImage:[UIImage imageWithColor:HEXColor(0x5E5E5E)] forState:UIControlStateNormal];
            [btn setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
            [btn setTitleColor:kCommonWhiteColor forState:UIControlStateSelected];
            [btn setTitle:titles[i] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
            [self setCornerRadius:6 addRectCorners:i == 0 ? UIRectCornerTopLeft|UIRectCornerBottomLeft : UIRectCornerTopRight|UIRectCornerBottomRight withView:btn];
            [btns addObject:btn];
            [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
                if (btn.tag == recordIndex) {
                    return;
                }
                recordIndex = btn.tag;
                for (UIButton *b in btns) {
                    if(b.selected && [b isEqual:btn])
                        return;
                    b.selected = 0;
                }
                btn.selected = 1;
                segBlock(btn.tag);
//                setBtn.hidden = setIgv.hidden = btn.tag == T_football ? 0 : 1;
//                eventIgv.hidden = eventLab.hidden = eventBtn.hidden = btn.tag == T_football ? 0 : 1;
            }];
            
            setBtn.hidden = setIgv.hidden = 1;
            eventIgv.hidden = eventLab.hidden = eventBtn.hidden = 1;
        }    
    }
    return self;
}

- (void)setCornerRadius:(CGFloat)value addRectCorners:(UIRectCorner)rectCorner withView:(UIView *)view{
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:rectCorner cornerRadii:CGSizeMake(value, value)];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = view.bounds;
    shapeLayer.path = path.CGPath;
    view.layer.mask = shapeLayer;
    
}
@end
