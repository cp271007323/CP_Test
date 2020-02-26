//
//  QukanUserManager.h
//  Qukan
//
//  Created by pfc on 2019/6/19.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QukanUserModel.h"

NS_ASSUME_NONNULL_BEGIN

#define kUserDidLoginNotification @"kUserDidLoginNotification"
#define kUserDidLogoutNotification @"kUserDidLogoutNotification"
#define kUserNoLoginNotification @"kUserNoLoginNotification"

#define kUserLoginUnvalidNotification @"kUserLoginUnvalidNotification"

#define kUserManager [QukanUserManager sharedInstance]

@interface QukanUserManager : NSObject

+ (instancetype)sharedInstance;

@property(nonatomic, strong, readonly) QukanUserModel *user;
@property(nonatomic, readonly, getter=isLogin) BOOL login;

@property(nonatomic, assign) NSInteger followQukanCount; // 关注话题数量


- (void)setUserData:(QukanUserModel *)userModel;

- (void)logOut;


@end

NS_ASSUME_NONNULL_END
