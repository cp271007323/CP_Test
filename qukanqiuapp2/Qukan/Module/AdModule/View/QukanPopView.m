//
//  QukanPopView.m
//  Qukan
//
//  Created by Kody on 2019/8/8.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanPopView.h"
#import "QukanGViewController.h"
#import <HBDNavigationBar/HBDNavigationController.h>

@interface QukanPopView()

@property(nonatomic, strong) QukanHomeModels          *model;

@property(nonatomic, strong) UIImageView   * popupImageView1;
@end

@implementation QukanPopView

- (instancetype)initWithFrame:(CGRect)frame WithModel:(QukanHomeModels *)model {
    self = [super initWithFrame:frame];
    self.model = model;
    [self addSubviews];
    return self;
}

- (void)addSubviews {
    //添加全局灰色的
    [kKeyWindow addSubview:self];
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    self.userInteractionEnabled = YES;
    
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clearButton.frame = self.bounds;
    clearButton.backgroundColor = [UIColor clearColor];
    [self addSubview:clearButton];
    @weakify(self);
    [[clearButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self disappearTap:nil];
    }];
    
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disappearTap:)];
    [self addGestureRecognizer:ges];
    
    UIImageView *popupImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    popupImageView.center = self.center;
    popupImageView.backgroundColor = [UIColor clearColor];
    popupImageView.userInteractionEnabled = YES;
    popupImageView.layer.cornerRadius = 5;
    popupImageView.layer.masksToBounds = YES;
    popupImageView.contentMode = UIViewContentModeScaleAspectFit;
    popupImageView.tag = 1;
    [popupImageView addGestureRecognizer:ges];
    [self addSubview:popupImageView];
    
    
    //添加按钮
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleButton.frame = CGRectMake(popupImageView.right - 5, CGRectGetMinY(popupImageView.frame) - 10 - 3, 20, 20);
    [cancleButton setImage:kImageNamed(@"Qukan_ads_close") forState:UIControlStateNormal];
    [self addSubview:cancleButton];
    [[cancleButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self disappearTap:nil];
    }];

    [popupImageView sd_setImageWithURL:[NSURL URLWithString:self.model.image] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//        @strongify(self)
        CGFloat w = image.size.width;
        CGFloat h = image.size.height;
        if (w > kScreenWidth) {
            h = (kScreenWidth - 80) * h / w;
            w = kScreenWidth - 80;
        }
        if (h > kScreenHeight) {
            w = (kScreenHeight - 100) * w / h;
            h = kScreenHeight - 100;
        }
        
        [UIView animateWithDuration:1 animations:^{
            CGRect firstRect = popupImageView.frame;
            firstRect.size.width = w;
            firstRect.size.height = h;
          
            firstRect.origin.x = kScreenWidth / 2 - w / 2;
            firstRect.origin.y = kScreenHeight / 2 - h / 2;
            popupImageView.frame = firstRect;
        }];
        
        cancleButton.center = CGPointMake(kScreenWidth / 2 - w / 2 + w, kScreenHeight / 2 - h / 2);
    }];
    
    [[[kNotificationCenter rac_addObserverForName:Qukan_adDidCilck object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        self.hidden = YES;
    }];
    
    [[[kNotificationCenter rac_addObserverForName:Qukan_webDealloc object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        if (popupImageView.image) {
            self.hidden = NO;
        }
    }];
}

#pragma mark ===================== Actions ============================
- (void)disappearTap:(UIGestureRecognizer *)ges {
    [self removeAllSubviews];
    [self removeFromSuperview];
    if (ges.view.tag == 0) {
        
    } else if (ges.view.tag == 1) {
        if ([self.model.jump_type intValue] == QukanViewJumpType_In) {
            QukanGViewController *vc = [[QukanGViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.url = self.model.v_url;
            UITabBarController *tabBarController = (UITabBarController *)kKeyWindow.rootViewController;
            if (tabBarController.selectedIndex < tabBarController.viewControllers.count) {
                HBDNavigationController *pushNavVc = (HBDNavigationController *)tabBarController.viewControllers[tabBarController.selectedIndex];
                [pushNavVc pushViewController:vc animated:YES];
            } else {
                vc.isPresentPush = YES;
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
                [UIApplication.sharedApplication.delegate.window.rootViewController presentViewController:nav animated:YES completion:nil];
            }
        } else if ([self.model.jump_type intValue] == QukanViewJumpType_AppIn) {
            
        } else if ([self.model.jump_type intValue] == QukanViewJumpType_Out) {
             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.model.v_url]];
        } else if ([self.model.jump_type intValue] == QukanViewJumpType_Other) {
            QukanGViewController *vc = [[QukanGViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            NSString *url = [NSString stringWithFormat:@"%@?adType=%@&bunleId=%@&appKey=%@",self.model.v_url,self.model.type,Qukan_AppBundleId,Qukan_OpeninstallKey];
            vc.url = url;
            UITabBarController *tabBarController = (UITabBarController *)kKeyWindow.rootViewController;
            
            if (tabBarController.selectedIndex < tabBarController.viewControllers.count) {
                HBDNavigationController *pushNavVc = (HBDNavigationController *)tabBarController.viewControllers[tabBarController.selectedIndex];
                [pushNavVc pushViewController:vc animated:YES];
            } else {
                vc.isPresentPush = YES;
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
                [UIApplication.sharedApplication.delegate.window.rootViewController presentViewController:nav animated:YES completion:nil];
            }
        }
    }
}

@end
