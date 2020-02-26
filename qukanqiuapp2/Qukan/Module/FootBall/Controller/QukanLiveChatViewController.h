//
//  QukanLiveChatViewController.h
//  Qukan
//
//  Created by pfc on 2019/7/20.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//  直播聊天

#import <UIKit/UIKit.h>

#import "QukanBasketBallMatchDetailModel.h"
#import "QukanNewsComentView.h"


@class QukanHomeModels;
NS_ASSUME_NONNULL_BEGIN


@interface QukanLiveChatViewController : UIViewController <JXPagerViewListViewDelegate>

@property(nonatomic, assign) NSInteger matchId;

// 用于展示输入框
@property(nonatomic, strong) QukanNewsComentView *Qukan_FooterView;

@property (nonatomic, copy) void(^liveChatVc_didBolck)(QukanHomeModels *model);
@property (nonatomic, assign) BOOL isBasketball;//yes-篮球 no-足球


- (void)setAD:(QukanBasketBallMatchDetailModel *)model;
- (void)getRoomAccessInfo;


- (void)showInputView;
- (void)onlyCompClick:(UIButton *)btn;
@end

NS_ASSUME_NONNULL_END
