//
//  QukanUserManager.m
//  Qukan
//
//  Created by pfc on 2019/6/19.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import <YYKit/NSData+YYAdd.h>

#define kUserDataDefaultKey @"kUserDataDefaultKey"
#define kUserFilerCompetitionDataKey @"kUserFilerCompetitionDataKey"

@interface QukanUserManager ()

@property(nonatomic, strong, readwrite) QukanUserModel *user;

@end

@implementation QukanUserManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static QukanUserManager *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
        NSData *data = [kUserDefaults dataForKey:kUserDataDefaultKey];
        instance.user = [QukanUserModel modelWithJSON:[data jsonValueDecoded]];
        
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}

- (void)setUserData:(QukanUserModel *)userModel {
    @synchronized (self) {
        _user = userModel;
        NSData *data = [userModel modelToJSONData];
        [kUserDefaults setObject:data forKey:kUserDataDefaultKey];
    }
}

- (void)logOut {
    _user = nil;
    _followQukanCount = 0;
    [kUserDefaults removeObjectForKey:kUserDataDefaultKey];
}

//- (void)setUserHeaderImage:(UIImage *)image {
//    UIView *userHeaderImageView = [[UIView alloc] initWithFrame:CGRectMake(20, 10, 50, 20)];
//    userHeaderImageView.backgroundColor = [UIColor whiteColor];
//    userHeaderImageView.backgroundColor = (UIColor *)image;
//}

#pragma mark ===================== Getters =================================

- (BOOL)isLogin {
    return _user.token.length > 0;
}

#pragma mark ===================== Setters =====================================


@end
