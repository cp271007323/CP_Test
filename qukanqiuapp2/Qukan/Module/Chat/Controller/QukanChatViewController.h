//
//  QukanChatViewController.h
//  Qukan
//
//  Created by pfc on 2019/8/14.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NIMSDK/NIMMessage.h>

NS_ASSUME_NONNULL_BEGIN

#define CustomerServiceID -1

@interface QukanChatViewController : UIViewController

- (instancetype)initWithUserId:(NSInteger)userId headUrl:(NSString *)urlString;


- (void) setChatName:(NSString*)name;

- (void) setSession:(NIMSession *)session;

//- (void) setMyAvatar:(NSString *)myAvatarUrl;
//- (void) setOtherAvatar:(NSString *)myAvatarUrl;

@end

NS_ASSUME_NONNULL_END
