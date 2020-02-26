//
//  QukanShareManager.h
//  Qukan
//
//  Created by Kody on 2019/7/16.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UMCommon/UMCommon.h>
#import <UMShare/UMShare.h>
#import <UShareUI/UShareUI.h>


/**弹出分享视图的类型  横屏，竖屏*/
typedef NS_ENUM(NSUInteger, shareScreenType) {
    shareScreenTypePort = 0,
    shareScreenTypeLand
};


NS_ASSUME_NONNULL_BEGIN

#define kUMShareManager [QukanUMShareManager sharedInstance]

@interface QukanUMShareManager : NSObject

/**新闻分享的请求host*/
@property(nonatomic, strong) NSString   *str_newsShareHttp;
/**比赛分享的请求host*/
@property(nonatomic, strong) NSString   *str_matchShareHttp;

@property(nonatomic, copy) NSString *screenStr;

/**单例*/
+ (instancetype)sharedInstance;

/**初始化 分享类  配置APPkey 等*/
- (void)Qukan_ShareSet;


/**
 分享弹出视图

 @param mainModel 分享的主模型类型  目前只有3种  （篮球比赛  足球比赛  新闻）
 @param screenType 分享的横竖屏  只有视频分享时需要用到
 @param superView  分享的父视图  只有视频全屏播放分享时需要用到
 */
- (void)Qukan_showShareViewWithMainModel:(id)mainModel Type:(shareScreenType)screenType superView:(nullable UIView *)superView;

/**分享图文*/
- (void)Qukan_ShareImageAndTextToPlatformType:(UMSocialPlatformType)platformType addTitle:(NSString *)title addThumImage:(id)shareImage addShareImageStr:(NSString * _Nullable)shareImageStr;

/**获取第三方登录信息*/
- (void)Qukan_UMGetShareInfoWithPlatform:(UMSocialPlatformType)platformType successBlock:(void (^)(UMSocialUserInfoResponse *result))successBlock failBlock:(void (^)(NSError *error))errorBlock;

@end

NS_ASSUME_NONNULL_END
