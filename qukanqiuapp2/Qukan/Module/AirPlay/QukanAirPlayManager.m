//
//  QukanAirPlayManager.m
//  Qukan
//
//  Created by pfc on 2019/8/13.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanAirPlayManager.h"
#import "LBLelinkService+Extension.h"

@interface QukanAirPlayManager ()<LBLelinkBrowserDelegate,LBLelinkConnectionDelegate,LBLelinkPlayerDelegate>

@property (nonatomic,strong) LBLelinkBrowser *lelinkBrowser;
@property (nonatomic,strong) LBLelinkConnection *connecter;

@end

@implementation QukanAirPlayManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static QukanAirPlayManager *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedManager];
}

#pragma mark ===================== Public Methods =======================

- (void)Qukan_asyncRegister{
#if DEBUG
    [LBLelinkKit enableLog:YES];
#endif
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSError * error = nil;
        BOOL result = [LBLelinkKit authWithAppid:Qukan_AirPlayAppID secretKey:Qukan_AirPlayAppSecretKey error:&error];
        if (result) {
            DEBUGLog(@"授权成功");
            dispatch_async(dispatch_get_main_queue(), ^{
                self.lelinkBrowser = [[LBLelinkBrowser alloc] init];
                self.lelinkBrowser.delegate = self;
            });
            
        }else{
            DEBUGLog(@"授权失败：error = %@",error);
        }
    });
    
    _connectedStatusChangeSubject = [RACSubject subject];
    _disConnectSubject = [RACSubject subject];
    _showAirPlayControlViewSubject = [RACSubject subject];
    _deviceOrientationChangeSubject = [RACSubject subject];
    _termClickSubject = [RACSubject subject];
    _playStatusSubject = [RACSubject subject];
    _playTimeChangeSubject = [RACSubject subject];
    _playCommpletedSubject = [RACSubject subject];
//    _localWebServer = [[LBLocalWebServerTool alloc] init];
    [LBLelinkKit enableLocalNotification:NO alertTitle:nil alertBody:nil];
    
    _connecter = [[LBLelinkConnection alloc] init];
    _connecter.delegate = self;
    
    _player = [[LBLelinkPlayer alloc] init];
    _player.delegate = self;
    _player.lelinkConnection = _connecter;
    @weakify(self)
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationDidChangeStatusBarFrameNotification object:nil]  subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        if (orientation == UIInterfaceOrientationPortrait){
            [self.deviceOrientationChangeSubject sendNext:KDeviceIsPortrait];
        }else{
            [self.deviceOrientationChangeSubject sendNext:nil];
        }
    }];
    
}

- (void)startSearchDevice {
    if (!self.player.lelinkConnection.connected ) {
        [self.lelinkBrowser searchForLelinkService];        
    }
}

- (void)stopSearchDevice {
    [self.lelinkBrowser stop];
}

- (NSString *)getCurrentOrientation {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationPortrait) {
        return KDeviceIsPortrait;
    }else{
        return nil;
    }
    
}

- (LBLelinkService *)getCurrentConnectedDevice {
    LBLelinkService *current = nil;
    for (LBLelinkService *device in _devices) {
        if (device.status == isConnected) {
            current = device;
            break;
        }
    }
    return current;
}

- (BOOL)isAirPlaying {
    LBLelinkService *device = [self getCurrentConnectedDevice];
    if (device) {
        return YES;
    }else{
        return NO;
    }
    
}

- (void)playWithUrlString:(NSString *)urlString {
    NSAssert(urlString != nil, @"投屏播放地址不能为空");
    
    // 实例化媒体对象
    LBLelinkPlayerItem * item = [[LBLelinkPlayerItem alloc] init];
    // 设置媒体类型
    item.mediaType = LBLelinkMediaTypeVideoOnline;
    // 设置媒体的URL
    item.mediaURLString = urlString;
    // 设置开始播放位置
    item.startPosition = 0;
    // 推送
    [self.player playWithItem:item];
    
    [self.showAirPlayControlViewSubject sendNext:nil];
}

- (void)stopPlay {
    [self.player stop];
}

- (void)Qukan_reConnect {
    LBLelinkService *device = _connecter.lelinkService;
    device.status = isConnecting;
//    [_localWebServer stopGCDWebServer];
    [_connecter connect];
    [self.connectedStatusChangeSubject sendNext:nil];
    self.playStatus = QukanAirPlayStatusConnecting;
}

- (void)Qukan_connectWithDevice:(LBLelinkService *)device {
    _connecter.lelinkService = device;
    device.status = isConnecting;
//    [_localWebServer stopGCDWebServer];
    [_connecter connect];
    [self.connectedStatusChangeSubject sendNext:nil];
    self.playStatus = QukanAirPlayStatusConnecting;
}


//- (void)Qukan_disConnectButTVKeepPlaying {
//    [_connecter disConnect];
////    [_localWebServer stopGCDWebServer];
//    [_disConnectSubject sendNext:nil];
//}
- (void)Qukan_disConnect {
    [_player stop];
    [_connecter disConnect];
//    [_localWebServer stopGCDWebServer];
    [_disConnectSubject sendNext:nil];
}

- (void)Qukan_voicePlus {
    [_player addVolume];
}

- (void)Qukan_voiceDecrease {
    [_player reduceVolume];
}

- (void)Qukan_mute{
    [_player setVolume:0];
}

- (void)Qukan_playOrPause {
    if (self.currentPlayStatus == LBLelinkPlayStatusPlaying) {
        [_player pause];
    }else if(self.currentPlayStatus == LBLelinkPlayStatusPause){
        [_player resumePlay];
    }else if(self.currentPlayStatus == LBLelinkPlayStatusStopped||self.currentPlayStatus == LBLelinkPlayStatusUnkown||self.currentPlayStatus == LBLelinkPlayStatusError){
        [self Qukan_rePlay];
    }
}

- (void)Qukan_rePlay{
    [_player play];
}

- (void)Qukan_seekToTime:(NSInteger)time{
    [_player seekTo:time];
}

#pragma mark - LBLelinkBrowserDelegate

// 方便调试，错误信息会在此代理方法中回调出来
- (void)lelinkBrowser:(LBLelinkBrowser *)browser onError:(NSError *)error {
    DEBUGLog(@"lelinkBrowser onError error = %@",error);
    //    _currentConnectedDevice = nil;
}

// 搜索到服务时，会调用此代理方法，将设备列表在此方法中回调出来
// 注意：如果不调用stop，则当有服务信息和状态更新以及新服务加入网络或服务退出网络时，会调用此代理，将新的设备列表回调出来
- (void)lelinkBrowser:(LBLelinkBrowser *)browser didFindLelinkServices:(NSArray<LBLelinkService *> *)services {
    DEBUGLog(@"搜索到设备数 %zd", services.count);
    self.devices = services;
    
    DEBUGLog(@"%@",services);
}

#pragma mark - LBLelinkConnectionDelegate

- (void)lelinkConnection:(LBLelinkConnection *)connection onError:(NSError *)error {
    if (error) {
        DEBUGLog(@"%@",error);
        for (LBLelinkService *device in _devices) {
            device.status = isDisConnected;
        }
        
        [self.connectedStatusChangeSubject sendNext:nil];
        self.playStatus = QukanAirPlayStatusConnectError;
    }
}

- (void)lelinkConnection:(LBLelinkConnection *)connection didConnectToService:(LBLelinkService *)service {
    DEBUGLog(@"已连接到服务：%@",service.lelinkServiceName);
    for (LBLelinkService *device in _devices) {
        device.status = isDisConnected;
        if (device == service) {
            device.status = isConnected;
            self.currentConnectedDevice = device;
        }
    }
    
    [self.connectedStatusChangeSubject sendNext:nil];
    [self playWithUrlString:_urlString];
    //    self.lastTimeConnectedDevice = service;
    self.playStatus = QukanAirPlayStatusConnected;
    
    [kNotificationCenter postNotificationName:Qukan_AirPlayConnectSucceed object:nil];
}

- (void)lelinkConnection:(LBLelinkConnection *)connection disConnectToService:(LBLelinkService *)service {
    DEBUGLog(@"已断开服务连接：%@",service.lelinkServiceName);
    for (LBLelinkService *device in _devices) {
        device.status = isDisConnected;
    }
    
    [self.connectedStatusChangeSubject sendNext:nil];
    self.playStatus = QukanAirPlayStatusDisConnected;
    
}
#pragma mark - LBLelinkPlayerDelegate
// 播放错误代理回调，根据错误信息进行相关的处理
- (void)lelinkPlayer:(LBLelinkPlayer *)player onError:(NSError *)error {
    if (error) {
        DEBUGLog(@"%@",error);
        self.currentPlayStatus = LBLelinkPlayStatusError;
        [_playStatusSubject sendNext:@(LBLelinkPlayStatusError)];
        self.playStatus = QukanAirPlayStatusError;
        
    }
}

// 播放状态代理回调
- (void)lelinkPlayer:(LBLelinkPlayer *)player playStatus:(LBLelinkPlayStatus)playStatus {
    DEBUGLog(@"%ld",playStatus);
    
    if (playStatus == LBLelinkPlayStatusUnkown) {
        self.playStatus = QukanAirPlayStatusUnkown;
    }else if (playStatus == LBLelinkPlayStatusLoading){
        self.playStatus = QukanAirPlayStatusLoading;
    }else if (playStatus == LBLelinkPlayStatusPlaying){
        self.playStatus = QukanAirPlayStatusPlaying;
    }else if (playStatus == LBLelinkPlayStatusPause){
        self.playStatus = QukanAirPlayStatusPause;
    }else if (playStatus == LBLelinkPlayStatusStopped){
        self.playStatus = QukanAirPlayStatusStopped;
    }else if (playStatus == LBLelinkPlayStatusCommpleted){
        self.playStatus = QukanAirPlayStatusCommpleted;
        [self.playCommpletedSubject sendNext:nil];
    }else if (playStatus == LBLelinkPlayStatusError){
        self.playStatus = QukanAirPlayStatusError;
    }
    
    self.currentPlayStatus = playStatus;
    [_playStatusSubject sendNext:@(playStatus)];
}

// 播放进度信息回调
- (void)lelinkPlayer:(LBLelinkPlayer *)player progressInfo:(LBLelinkProgressInfo *)progressInfo {
    DEBUGLog(@"current time = %ld, duration = %ld",progressInfo.currentTime,progressInfo.duration);
    
    [_playTimeChangeSubject sendNext:progressInfo];
    self.currentPlayTime = progressInfo.currentTime;
}

@end
