//
//  QukanAppDelegate+Push.h
//  Qukan
//
//  Created by mac on 2018/12/7.
//  Copyright © 2018 Ningbo Suda. All rights reserved.
//

#import "QukanAppDelegate.h"
#import <UserNotifications/UserNotifications.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanAppDelegate (Push)<UNUserNotificationCenterDelegate>


- (void)QukanregisterNotification:(NSDictionary *)launchOptions;


- (void)QukanJumpNotificationWith:(NSDictionary *)userInfo;

- (void)QukanLocalNotificationJump:(NSString *)matchType matchId:(NSString *)matchId;

@end

NS_ASSUME_NONNULL_END
