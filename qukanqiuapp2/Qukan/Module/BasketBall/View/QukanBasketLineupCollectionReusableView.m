//
//  QukanBasketLineupCollectionReusableView.m
//  Qukan
//
//  Created by Kody on 2020/1/2.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanBasketLineupCollectionReusableView.h"

@implementation QukanBasketLineupCollectionReusableView

- (void)setDataWithTitle:(NSString *)title {
    self.backgroundColor = kCommonWhiteColor;
    
    UIView *back_view = UIView.new;
    back_view.backgroundColor = HEXColor(0xE8E8E8);
    [self addSubview:back_view];
    [back_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.offset(0);
        make.width.offset(100);
    }];
    
    UILabel *title_label = UILabel.new;
    title_label.text = title;
    title_label.font = [UIFont boldSystemFontOfSize:12];
    title_label.textColor = kCommonTextColor;
    [back_view addSubview:title_label];
    
    [title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.mas_equalTo(self);
    }];
    
    UIView *layerView = UIView.new;
    layerView.layer.cornerRadius = 0;
    layerView.backgroundColor = kCommonWhiteColor;
    layerView.transform = affineTransformMakeShear(-0.3,0);
    [self addSubview:layerView];
    
    [layerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(back_view.mas_right).offset(-5);
        make.top.bottom.offset(0);
        make.width.offset(30);
    }];
}

static CGAffineTransform affineTransformMakeShear(CGFloat xShear, CGFloat yShear) {
    return CGAffineTransformMake(1, yShear, xShear, 1, 0, 0);
}

@end
