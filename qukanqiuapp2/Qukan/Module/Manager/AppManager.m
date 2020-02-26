//
//  AppManager.m
//  DaiXiongTV
//
//  Created by pfc on 2019/6/12.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanApiManager.h"
#import "QukanApiManager+PersonCenter.h"

#import "QukanApiManager+Mine.h"
#import "QukanUpGradePopView.h"

#if __has_include(<FLEX/FLEX.h>)
#import <FLEX/FLEX.h>
#endif


@interface AppManager ()

@property(nonatomic, copy) NSString *Qukan_channel;
@property(nonatomic, copy) NSString *umName;

@end

@implementation AppManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static AppManager *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
        instance.appstoreUpdate = NO;
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}

- (void)appSetup {
    [self setDebugTool];
    
    // fix: 篮球球队logo无法显示bug
    // https://www.jianshu.com/p/a1f9e6a41fad
    [SDWebImageDownloader.sharedDownloader setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    
    @weakify(self)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self)
        [self checkAppStoreUpdate];
    });

    [self Qukan_appGetConfig];
}

#pragma mark ===================== Debug ==================================
- (void)setDebugTool {
#ifdef DEBUG
    UILongPressGestureRecognizer *ges = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showDebugTool)];
    ges.minimumPressDuration = 3;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [kKeyWindow addGestureRecognizer:ges];        
    });
#endif
}

- (void)showDebugTool {
#ifdef DEBUG
#if __has_include(<FLEX/FLEX.h>)
    [[FLEXManager sharedManager] showExplorer];
#endif
    
#endif
}

#pragma mark ===================== 检查更新 ==================================

- (void)checkAppStoreUpdate {
    @weakify(self)
    [[kApiManager QukancheckAppStoreUpdate] subscribeNext:^(NSDictionary *  _Nullable x) {
        @strongify(self)
        [self showUpdateAlertWithInfo:x];
    } error:^(NSError * _Nullable error) {
        
    }];
}

- (void)showUpdateAlertWithInfo:(NSDictionary *)info {
    if (!info.allKeys.count) {return;}
    
    NSString *updateFlag = [info stringValueForKey:@"isUpdate" default:nil];
    if ([updateFlag isEqualToString:@"0"]) {
        return;
    }

    BOOL force = [updateFlag isEqualToString:@"2"];
    NSString *downloadUrl = [info stringValueForKey:@"downloadUrl" default:nil];
    NSString *notes = [info stringValueForKey:@"info" default:@""];
    
    if(notes.length){
        notes = [notes stringByReplacingOccurrencesOfString:@"\\n" withString:@"\r\n" ];
    }else {
        return;
    }
    
    QukanUpGradePopView* upgradeView = [[QukanUpGradePopView alloc]initWithFrame:kKeyWindow.bounds upgradeUrl:downloadUrl isForce:force info:notes];
    upgradeView.center = kKeyWindow.center;
    
}

- (void)gotoAppStoreWithUrl:(NSString *)url {
//    NSString * urlStr = [NSString stringWithFormat: @"itms-apps://itunes.apple.com/app/id%@?mt=8",@"1444605459"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

#pragma mark ===================== GetConfig ==================================

- (void)Qukan_appGetConfig {
    [[[kApiManager QukanAppGetConfig] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        
        DEBUGLog(@"---%@",x);
        NSDictionary *xDict = (NSDictionary *)x;
        if (!xDict.allKeys.count) {return ;}
        NSDictionary *news_config = [xDict[@"news_config"] isKindOfClass:[NSDictionary class]] ? xDict[@"news_config"] : nil;
        NSDictionary *news_share_url = [news_config[@"share_url"] isKindOfClass:[NSDictionary class]] ? news_config[@"share_url"] : nil;
        NSString *newsShareUrl = [news_share_url stringValueForKey:@"name" default:@""];
        if (newsShareUrl.length > 0 && newsShareUrl != nil) {
            [kUserDefaults setObject:newsShareUrl forKey:Qukan_newsShareHttp];
            kUMShareManager.str_newsShareHttp = newsShareUrl;
        }
        kUMShareManager.screenStr = xDict[@"screen_url"][@"name"];

        NSDictionary *zq_match = [xDict[@"zq_match"] isKindOfClass:[NSDictionary class]] ? xDict[@"zq_match"] : nil;
        NSDictionary *match_share_url = [zq_match[@"share_url"] isKindOfClass:[NSDictionary class]] ? zq_match[@"share_url"] : nil;
        NSString *matchShareUrl = [match_share_url stringValueForKey:@"name" default:@""];
        if (matchShareUrl.length > 0 && matchShareUrl != nil) {
            [kUserDefaults setObject:matchShareUrl forKey:Qukan_matchShareHttp];
            kUMShareManager.str_matchShareHttp = matchShareUrl;
        }
        
    } error:^(NSError * _Nullable error) {
    }];
}

#pragma mark ===================== Getters =================================

- (NSString *)Qukan_channel {
    if (!_Qukan_channel) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        _Qukan_channel = [NSString stringWithFormat:@"%@ AppStore@%@", AppName, infoDictionary[@"CFBundleShortVersionString"]];
    }
    
    return _Qukan_channel;
}

- (NSString *)umName {
    if (!_umName) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *channel = self.openInstallChannelCode ?: @"AppStore";
        _umName = [NSString stringWithFormat:@"%@_%@@%@",Qukan_AppEnName,channel, infoDictionary[@"CFBundleShortVersionString"]];
    }
    
    return _umName;
}

@end
