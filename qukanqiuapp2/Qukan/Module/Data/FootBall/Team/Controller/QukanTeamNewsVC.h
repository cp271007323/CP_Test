//
//  QukanTeamNewsVC.h
//  Qukan
//
//  Created by Charlie on 2019/12/31.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QukanTeamSubBaseVC.h"
#import <ZFPlayer/ZFPlayerController.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanTeamNewsVC : QukanTeamSubBaseVC

@property(nonatomic, strong) UINavigationController *navigation_vc;

@property (nonatomic, strong, readonly) ZFPlayerController *player;

@property(nonatomic, strong) QukanNewsModel *videoNews;

@end

NS_ASSUME_NONNULL_END
