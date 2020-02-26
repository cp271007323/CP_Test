//
//  QukanLiveLineModel.h
//  Qukan
//
//  Created by Kody on 2019/8/14.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, QukanLiveType) {
    QukanLiveType_PlayerHdLive     = 1,//高清
    QukanLiveType_ThirdHdLive      = 2,//第三方
    QukanLiveType_AnimationLive    = 3,//动画
    QukanLiveType_Ad               = 7,//ad
    QukanLiveType_Other,
};

@interface QukanLiveLineModel : NSObject

@property(nonatomic, strong) NSString      *createTime;
@property(nonatomic, strong) NSString      *liveName;
@property(nonatomic, strong) NSString      *liveUrl;
@property(nonatomic, strong) NSString      *aliFlvUrl;
@property(nonatomic, strong) NSString      *aliRtmpUrl;
@property(nonatomic, strong) NSString      *aliM3u8Url;

@property(nonatomic, assign) NSInteger     liveType;
@property(nonatomic, assign) NSInteger     matchId;
@property(nonatomic, assign) NSInteger     onOff;
@property(nonatomic, assign) NSInteger     isOutBrowser;
@property(nonatomic, assign) NSInteger     rank;


@end

NS_ASSUME_NONNULL_END
