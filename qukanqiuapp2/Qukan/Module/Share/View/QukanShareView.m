//
//  QukanShareView.m
//  Qukan
//
//  Created by Kody on 2019/7/19.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanShareView.h"

@interface QukanShareView ()

@property(nonatomic, strong) UIView    *shareView;

@end


@implementation QukanShareView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.userInteractionEnabled = YES;

    [self addSubviewsWhenFullScreen];
    
    return self;
}

- (void)addSubviewsWhenFullScreen {
    [kKeyWindow addSubview:self];
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disappearTap:)];
    [self addGestureRecognizer:ges];
    
    UIView *shareView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, 218, kScreenHeight)];
    shareView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    shareView.layer.cornerRadius = 5;
    shareView.layer.masksToBounds = YES;
    shareView.userInteractionEnabled = YES;
    [self addSubview:shareView];
    _shareView = shareView;
    
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 218, 36)];
    blackView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    [shareView addSubview:blackView];
    
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 6, 80, 23)];
    titleLabel.text = @"分享至";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = HEXColor(0xcccccc);
    titleLabel.font = [UIFont systemFontOfSize:13];
    [shareView addSubview:titleLabel];
    
    //添加分享的平台
    NSMutableArray *sharePlatformImageArray = [NSMutableArray array];
    NSMutableArray *sharePlatformTitleArray = [NSMutableArray array];
    
    //自己修改
    if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_QQ]) {
        [sharePlatformImageArray addObject:@"Qukan_share_qq"];//添加微信的图标
        [sharePlatformTitleArray addObject:@"QQ"];
    }
    if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession]) {
        [sharePlatformImageArray addObject:@"Qukan_share_wechat"];//添加微信的图标
        [sharePlatformTitleArray addObject:@"微信"];
    }
    if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatTimeLine]) {
        [sharePlatformImageArray addObject:@"Qukan_share_wechattimeline"];//添加微信的图标
        [sharePlatformTitleArray addObject:@"朋友圈"];
    }
    
    CGFloat shareButtonWidth = 44;
    CGFloat shareButtonHight = 44;
    
    CGFloat shareLabelWidth = 44;
    CGFloat shareLabelHight = 20;
    
    CGFloat space = (218 - shareButtonWidth * sharePlatformImageArray.count)  / (sharePlatformImageArray.count + 1);
    space = 18;
    for (int i = 0; i < sharePlatformImageArray.count ; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:kImageNamed(sharePlatformImageArray[i]) forState:UIControlStateNormal];
        button.frame = CGRectMake(space * (i + 1) + shareButtonWidth * i, 60, shareButtonWidth, shareButtonHight);
        [button addTarget:self action:@selector(shareButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        [shareView addSubview:button];
        button.tag = i;
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(space * (i + 1) + shareButtonWidth * i, CGRectGetMaxY(button.frame), shareLabelWidth, shareLabelHight)];
        title.text = sharePlatformTitleArray[i];
        title.textColor = HEXColor(0xcccccc);
        title.textAlignment =NSTextAlignmentCenter;
        title.font = [UIFont systemFontOfSize:14];
        [shareView addSubview:title];
        
        if (sharePlatformImageArray.count == 1) {
            button.frame = CGRectMake(shareView.size.width / 2 - shareButtonWidth / 2, 50, shareButtonWidth, shareButtonHight);
            title.frame = CGRectMake(shareView.size.width / 2 - shareButtonWidth / 2, CGRectGetMaxY(button.frame), shareLabelWidth, shareLabelHight);
        }
    }
    
    //添加取消按钮
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(15, shareView.size.height - 40 - 15,181 ,40);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:HEXColor(0x666666) forState:UIControlStateNormal];
    cancelButton.titleLabel.font = kFont15;
    cancelButton.layer.borderWidth = 0.5;
    cancelButton.layer.cornerRadius = 20;
    cancelButton.layer.masksToBounds = YES;
    cancelButton.layer.borderColor = HEXColor(0x666666).CGColor;
    cancelButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    [shareView addSubview:cancelButton];
    @weakify(self);
    [[cancelButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self disappearTap:nil];
    }];
    
    [UIView animateWithDuration:0.15 animations:^{
         shareView.frame = CGRectMake(kScreenWidth - 200, 0, 200, kScreenHeight);
    }];
}

#pragma mark ===================== Public Methods =======================

- (void)shareButtonCilck:(UIButton *)button {
    if (button.imageView.image == kImageNamed(@"Qukan_share_wechat")) {
        if (self.shareTypeblock)  self.shareTypeblock(1);
    }  else if (button.imageView.image == kImageNamed(@"Qukan_share_qq")) {
        if (self.shareTypeblock)  self.shareTypeblock(4);
    } else if (button.imageView.image == kImageNamed(@"Qukan_share_wechattimeline")) {
        if (self.shareTypeblock)  self.shareTypeblock(2);
    }
    [self disappearTap:nil];
}

- (void)disappearTap:(UITapGestureRecognizer *)gesture {
    [UIView animateWithDuration:0.15 animations:^{
        self.shareView.frame = CGRectMake(kScreenWidth, 0, 200, kScreenHeight);
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeAllSubviews];
        [self removeFromSuperview];
    });
}


@end
