//
//  QukanNewsListViewController.h
//  Qukan
//
//  Created by pfc on 2019/7/15.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JXCategoryView/JXCategoryListContainerView.h>

@class QukanNewsChannelModel, ZFPlayerController;
NS_ASSUME_NONNULL_BEGIN

@interface QukanNewsListViewController : UIViewController<JXCategoryListContainerViewDelegate>

@property(nonatomic, weak) UINavigationController *navController;
@property(nonatomic, weak) QukanNewsChannelModel *channel;

@property (nonatomic, strong, readonly) ZFPlayerController *player;

@property (nonatomic, copy) void(^playEndBolck)(void);

- (void)stopCurrentCellPlay;

- (void)refreshNewsList;

@end

NS_ASSUME_NONNULL_END
