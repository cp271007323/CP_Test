//
//  QukanNewsDetailsViewController.h
//  Qukan
//
//  Created by Kody on 2019/7/17.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZFPlayer/ZFPlayer.h>
@class QukanNewsModel,ZFPlayerController;
NS_ASSUME_NONNULL_BEGIN

@interface QukanNewsDetailsViewController : UIViewController

@property(nonatomic, strong) QukanNewsModel *videoNews;
@property(nonatomic, assign) BOOL         isBaner;


@property (nonatomic, strong) ZFPlayerController *player;

@property (nonatomic, copy) void(^videoVCPopCallback)(void);

@property (nonatomic, copy) void(^videoVCPlayCallback)(void);

@property (nonatomic, copy) void(^detailsVcGoBack)(void);

@end

NS_ASSUME_NONNULL_END
