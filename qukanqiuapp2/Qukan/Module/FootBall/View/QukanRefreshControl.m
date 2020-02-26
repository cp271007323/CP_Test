//
//  QukanRefreshControl.m
//  Qukan
//
//  Created by pfc on 2019/7/9.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanRefreshControl.h"

@interface QukanRefreshControl ()

@property (nonatomic, strong)UIButton *button;

@property (nonatomic, assign)BOOL refreshing;
@property (nonatomic, strong)UIImageView *circleImageV;
@property (nonatomic, strong)UIView *backView;

@end

@implementation QukanRefreshControl

- (instancetype)initWithFrame:(CGRect)frame relevanceScrollView:(UIScrollView *)scrollView
{
    self = [super initWithFrame:frame];
    if (self) {
        _refreshing = NO;
        [self addSubview:self.button];
        [self.button addSubview:self.backView];
        [self.backView addSubview:self.circleImageV];
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.offset(0);
        }];
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.offset(0);
            make.height.width.offset(40);
        }];
        [self.circleImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.centerX.offset(0);
            make.width.height.offset(20);
        }];
        @weakify(self)
        [RACObserve(scrollView, contentOffset)  subscribeNext:^(NSValue *  _Nullable x) {
            @strongify(self)
            self.hidden = (scrollView.isDragging || scrollView.isTracking);
        }];
    }
    return self;
}

#pragma mark ===================== Public Methods =======================

- (void)endRefresh {
    _refreshing = NO;
    
    [self endAnimation];
}

#pragma mark ===================== Actions ============================

- (void)btnClick:(UIButton *)btn {
    
    if (_refreshing) {
        return;
    }
    
    [self beginAnimation];
    
    if (self.beginRefreshBlock) {
        self.beginRefreshBlock();
    }
}

#pragma mark ===================== Private Methods =========================

- (void)beginAnimation {
    CABasicAnimation *animation = [CABasicAnimation new];
    animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.toValue = [NSNumber numberWithFloat:M_PI*2.0];
    animation.duration = 1.0;
    animation.repeatCount = HUGE_VALF;
    
    [self.circleImageV.layer addAnimation:animation forKey:@"rotationAnimation"];
}

- (void)endAnimation {
    [self performSelector:@selector(endAnimationafter) withObject:nil afterDelay:1];
}

- (void)endAnimationafter {
    _refreshing = NO;
    [self.circleImageV.layer removeAnimationForKey:@"rotationAnimation"];
}

- (UIView *)backView {
    if (!_backView) {
        _backView = UIView.new;
        _backView.userInteractionEnabled = NO;
        _backView.backgroundColor = kCommonWhiteColor;
        _backView.layer.cornerRadius = 20;
        _backView.layer.shadowColor = HEXColor(0xC1C1C1).CGColor;//shadowColor阴影颜色
        _backView.layer.shadowOffset = CGSizeMake(0,4);//shadowOffset阴影偏移,x向右偏移0，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        _backView.layer.shadowOpacity = 0.4;//阴影透明度，默认0
        _backView.layer.shadowRadius = 10;//阴影半径，默认3
    }
    return _backView;
}
- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setAdjustsImageWhenHighlighted:NO];
         [_button addTarget:self action:@selector(btnClick:)
        forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}
- (UIImageView *)circleImageV {
    if (!_circleImageV) {
        _circleImageV = UIImageView.new;
        _circleImageV = UIImageView.new;
        _circleImageV.image = [[UIImage imageNamed:@"refresh_icon"] imageWithColor:kThemeColor];
        _circleImageV.userInteractionEnabled = NO;

    }
    return _circleImageV;
}

@end
