//
//  QukanGDataView.m
//  Qukan
//
//  Created by Kody on 2019/8/8.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanGDataView.h"

@interface QukanGDataView ()

@property(nonatomic, strong) UIImageView *gImageView;

@end

@implementation QukanGDataView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.userInteractionEnabled = YES;
    [self addSubviews];
    return self;
}

- (void)addSubviews {
    UIImageView *gImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    gImageView.userInteractionEnabled = YES;
    [self addSubview:gImageView];
    _gImageView = gImageView;
//    _gImageView.contentMode = UIViewContentModeScaleAspectFit;
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gImageViewTap:)];
    [gImageView addGestureRecognizer:ges];
    
    [gImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)Qukan_setAdvWithModel:(QukanHomeModels *)model {
    [_gImageView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:kImageNamed(@"Qukan_placeholder")];
}

#pragma mark ===================== Actions ============================
- (void)gImageViewTap:(UITapGestureRecognizer *)ges {
    if (self.dataImageView_didBlock) {
        self.dataImageView_didBlock();
    }
}

@end
