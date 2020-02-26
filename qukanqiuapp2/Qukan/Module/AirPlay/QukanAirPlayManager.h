//
//  QukanAirPlayManager.h
//  Qukan
//
//  Created by pfc on 2019/8/13.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LBLelinkKit/LBLelinkKit.h>

#define KDeviceIsPortrait @"KDeviceIsPortrait"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, QukanAirPlayStatus) {
    QukanAirPlayStatusUnkown,// 未知状态   //播放错误
    QukanAirPlayStatusLoading,// 视频正在加载状态      //投屏中
    QukanAirPlayStatusPlaying,// 正在播放状态   //投屏中
    QukanAirPlayStatusPause,// 暂停状态    //投屏中
    QukanAirPlayStatusStopped,// 退出播放状态  //
    
    QukanAirPlayStatusCommpleted,// 播放完成状态
    QukanAirPlayStatusError,// 播放错误
    QukanAirPlayStatusConnected,//已连接       //投屏中
    QukanAirPlayStatusDisConnected,//连接断开
    
    QukanAirPlayStatusConnecting,//连接中
    QukanAirPlayStatusConnectError //连接失败
};

@interface QukanAirPlayManager : NSObject

@property (nonatomic, copy) NSArray <LBLelinkService *>*devices;
@property (nonatomic, strong) RACSubject *connectedStatusChangeSubject;
@property (nonatomic, strong) RACSubject *disConnectSubject;
@property (nonatomic, strong) RACSubject *showAirPlayControlViewSubject;
@property (nonatomic, strong) RACSubject *deviceOrientationChangeSubject;
@property (nonatomic, strong) RACSubject *termClickSubject;

@property (nonatomic, strong) RACSubject *playStatusSubject;
@property (nonatomic, strong) RACSubject *playTimeChangeSubject;
@property (nonatomic, strong) RACSubject *playCommpletedSubject;

@property(nonatomic, copy) NSString *urlString; // 投屏地址

//@property (nonatomic, strong) LBLocalWebServerTool *localWebServer;
@property (nonatomic, weak) LBLelinkService *currentConnectedDevice;

@property (nonatomic,assign) QukanAirPlayStatus playStatus;
@property (nonatomic,assign) LBLelinkPlayStatus currentPlayStatus;//这个状态把播放状态和连接状态统一起来,主要用于播放器ui展示
@property (nonatomic,strong,readonly) LBLelinkPlayer *player;
@property (nonatomic,assign) NSInteger currentPlayTime;

+ (QukanAirPlayManager *)sharedManager;
- (void)Qukan_asyncRegister;

- (void)startSearchDevice;
- (void)stopSearchDevice;

- (void)Qukan_connectWithDevice:(LBLelinkService *)device;
- (LBLelinkService *)getCurrentConnectedDevice;
- (BOOL)isAirPlaying;

- (void)playWithUrlString:(NSString *)urlString;
- (void)stopPlay;

- (void)Qukan_disConnect;
//- (void)Qukan_disConnectButTVKeepPlaying;
- (NSString *)getCurrentOrientation;
- (void)Qukan_voicePlus;
- (void)Qukan_voiceDecrease;

- (void)Qukan_mute;
- (void)Qukan_playOrPause;
- (void)Qukan_seekToTime:(NSInteger)time;
- (void)Qukan_rePlay;
- (void)Qukan_reConnect;

@end

NS_ASSUME_NONNULL_END
