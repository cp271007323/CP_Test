//
//  UIView+ShowLoading.m
//  jfsdl
//
//  Created by River on 14-11-21.
//  Copyright (c) 2014年 appabc. All rights reserved.
//

static NSString * const kXHloadingViewKey = @"kXHloadingViewKey";
static NSString * const kXHloadingBGViewKey = @"kXHloadingBGViewKey";

@interface UIView ()

@property (nonatomic, strong) QukanctivityIndicatorView *indicatorView;
@property(nonatomic, strong) UIView *backgroundView;

@end

@implementation UIView (ShowLoading)

- (void)setIndicatorView:(QukanctivityIndicatorView *)indicatorView {
    objc_setAssociatedObject(self, &kXHloadingViewKey, indicatorView, OBJC_ASSOCIATION_RETAIN);
}

- (QukanctivityIndicatorView *)indicatorView {
    return objc_getAssociatedObject(self, &kXHloadingViewKey);
}

- (void)setBackgroundView:(UIView *)backgroundView {
    objc_setAssociatedObject(self, &kXHloadingBGViewKey, backgroundView, OBJC_ASSOCIATION_RETAIN);
}

- (UIView *)backgroundView {
    return objc_getAssociatedObject(self, &kXHloadingBGViewKey);
}

- (void)showLoadingWithInteraction:(BOOL)interaction{
    if (!self.backgroundView) {
        self.backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        self.backgroundView.backgroundColor = UIColor.clearColor;
        self.backgroundView.userInteractionEnabled = interaction;
        [self addSubview:self.backgroundView];
        
        [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    if (!self.indicatorView) {
        self.indicatorView = [[QukanctivityIndicatorView alloc] initWithType:QukanctivityIndicatorAnimationTypeDoubleBounce tintColor:kThemeColor];
        [self.backgroundView addSubview:self.indicatorView];
        self.indicatorView.backgroundColor = UIColor.clearColor;// HEXColor(0xeeeeee);
        self.indicatorView.layer.masksToBounds = YES;
        self.indicatorView.layer.cornerRadius = 5;
        [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(90);
            make.center.equalTo(self.backgroundView);
        }];
    }
    [self.indicatorView startAnimating];
}

- (void)showLoading {
    [self showLoadingWithInteraction:YES];
}
- (void)showLoadingWithTouchable{
    [self showLoadingWithInteraction:NO];

}


- (void)showLoadingWithYoffset:(CGFloat)yOffset {
    if (!self.backgroundView) {
        self.backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        self.backgroundView.backgroundColor = UIColor.clearColor;
        [self addSubview:self.backgroundView];
        
        [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
    }
    if (!self.indicatorView) {
        self.indicatorView = [[QukanctivityIndicatorView alloc] initWithType:QukanctivityIndicatorAnimationTypeDoubleBounce tintColor:kThemeColor];
        [self.backgroundView addSubview:self.indicatorView];
        [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(60);
            make.centerX.equalTo(self.backgroundView);
            make.centerY.equalTo(self.backgroundView).offset(yOffset);
        }];
    }
    [self.indicatorView startAnimating];
}


- (void)showClearLoadingWithYoffset:(CGFloat)yOffset {
    if (!self.backgroundView) {
        self.backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        self.backgroundView.backgroundColor = UIColor.clearColor;
        [self addSubview:self.backgroundView];
        
        [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
    }
    if (!self.indicatorView) {
        self.indicatorView = [[QukanctivityIndicatorView alloc] initWithType:QukanctivityIndicatorAnimationTypeDoubleBounce tintColor:kThemeColor];
        [self.backgroundView addSubview:self.indicatorView];
        [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(60);
            make.centerX.equalTo(self.backgroundView);
            make.centerY.equalTo(self.backgroundView).offset(yOffset);
        }];
    }
    [self.indicatorView startAnimating];
}

- (BOOL)isShowLoading {
    if (self.indicatorView.superview) {
        return YES;
    }else {
        return NO;
    }
}

- (void)hideLoading {
    [self.backgroundView removeFromSuperview];
    [self.indicatorView stopAnimating];
    [self.indicatorView removeFromSuperview];
    self.indicatorView = nil;
    self.backgroundView = nil;
}

@end
