//
//  QukanVideoView.m
//  Qukan
//
//  Created by pfc on 2019/8/9.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanVideoView.h"

@interface QukanVideoView()
@property(nonatomic, strong) QukanHomeModels       *model;
@end

@implementation QukanVideoView

- (instancetype)initWithFrame:(CGRect)frame WithModel:(QukanHomeModels *)model {
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor redColor];
    self.model = model;
    [self addSubviews];
    return self;
}

- (void)addSubviews {
    //添加图像
    UIImageView *gImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 90, 60)];
//    gImageView.image = [UIImage imageNamed:@"Qukan_bj"];
    [gImageView sd_setImageWithURL:[NSURL URLWithString:self.model.image] placeholderImage:kImageNamed(@"Qukan_placeholder")];
    gImageView.backgroundColor = [UIColor whiteColor];
    [self addSubview:gImageView];
    gImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disappearTap:)];
    [gImageView addGestureRecognizer:ges];
    
    //添加按钮
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleButton.frame = CGRectMake(85, -5, 10, 10);
    [cancleButton setImage:kImageNamed(@"Qukan_ads_close") forState:UIControlStateNormal];
    [self addSubview:cancleButton];
    @weakify(self);
    [[cancleButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self cancleButtonCilck];
    }];
}

#pragma mark ===================== DataSource =======================
- (void)setDataSource:(QukanHomeModels *)model {
    
}

#pragma mark ===================== Public Methods =======================

- (void)disappearTap:(UITapGestureRecognizer *)ges {
    if (self.dataImageView_didBlock) {
        self.dataImageView_didBlock();
    }
}

- (void)cancleButtonCilck {
    [self removeFromSuperview];
    [self removeAllSubviews];
    if (self.cancelButton_didBlock) {
        self.cancelButton_didBlock();
    }
}

@end
