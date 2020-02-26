//
//  QukanXLChannelControl.m
//  QukanXLChannelControlDemo
//
//  Created by MengXianLiang on 2017/3/3.
//  Copyright © 2017年 MengXianLiang. All rights reserved.
//

#import "QukanXLChannelControl.h"
#import "QukanXLChannelView.h"

@interface QukanXLChannelControl ()

@property (nonatomic, strong) UINavigationController *nav;

@property (nonatomic, strong) QukanXLChannelView *channelView;



@end

@implementation QukanXLChannelControl

+(QukanXLChannelControl*)shareControl{
    static QukanXLChannelControl *control = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        control = [[QukanXLChannelControl alloc] init];
    });
    return control;
}

- (instancetype)init {
    if (self = [super init]) {
        [kNotificationCenter addObserver:self selector:@selector(fineshEdit) name:@"channel_change_notification" object:nil];
        [self buildChannelView];
    }
    return self;
}

- (void)buildChannelView {
    
    self.channelView = [[QukanXLChannelView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.nav = [[UINavigationController alloc] initWithRootViewController:[UIViewController new]];
    self.nav.navigationBar.tintColor = kCommonBlackColor;
    self.nav.topViewController.title = @"自定义频道";
    self.nav.topViewController.view = self.channelView;
//    self.nav.topViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(backMethod)];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 50, 50);
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 25);
    [backButton setImage:kImageNamed(@"Qukan_Play_Back") forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backMethod) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *lefttItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.nav.topViewController.navigationItem.leftBarButtonItem = lefttItem;
    
    UIButton *completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    completeButton.frame = CGRectMake(kScreenWidth - 60, 0, 50, 50);
    [completeButton setTitle:@"完成" forState:UIControlStateNormal];
    completeButton.titleLabel.font = kFont14;
    [completeButton setTitleColor:kThemeColor forState:UIControlStateNormal];
    [[completeButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        [kNotificationCenter postNotificationName:@"channel_change_notification" object:nil];

    }];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:completeButton];
    self.nav.topViewController.navigationItem.rightBarButtonItem = rightItem;
}

- (void)backMethod {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.nav.view.frame;
        frame.origin.y = - self.nav.view.bounds.size.height;
        self.nav.view.frame = frame;
    }completion:^(BOOL finished) {
        [self.nav.view removeFromSuperview];
    }];
//    self.block(self.channelView.enabledTitles,self.channelView.disabledTitles);
}

- (void)fineshEdit {
    [self backMethod];
    self.block(self.channelView.enabledTitles,self.channelView.disabledTitles);
}

- (void)showChannelViewWithEnabledTitles:(NSArray*)enabledTitles disabledTitles:(NSArray*)disabledTitles finish:(XLChannelBlock)block {
    self.block = block;
    self.channelView.enabledTitles = [NSMutableArray arrayWithArray:enabledTitles];
    self.channelView.disabledTitles = [NSMutableArray arrayWithArray:disabledTitles];
    [self.channelView reloadData];

    CGRect frame = self.nav.view.frame;
    frame.origin.y = - self.nav.view.bounds.size.height;
    self.nav.view.frame = frame;
    self.nav.view.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:self.nav.view];
    [UIView animateWithDuration:0.3 animations:^{
        self.nav.view.alpha = 1;
        self.nav.view.frame = [UIScreen mainScreen].bounds;
    }];
}

@end
