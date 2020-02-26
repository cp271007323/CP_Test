//
//  QukanNetworkManager.m
//  Qukan
//
//  Created by Kody on 2019/7/25.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

@interface QukanNetworkManager ()

@end

@implementation QukanNetworkManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static QukanNetworkManager *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}


- (BOOL)netWorkIsWorking {
    BOOL isWork = [AFNetworkReachabilityManager sharedManager].reachableViaWiFi;
    return isWork;
}

- (void)addReachabilityMonitor {
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (status == AFNetworkReachabilityStatusUnknown) {//未知
                
            } else if (status == AFNetworkReachabilityStatusNotReachable) {
                [kKeyWindow showTip:@"请检查您的网络连接"];
            } else if (status == AFNetworkReachabilityStatusReachableViaWWAN) {//手机
                [kKeyWindow showTip:@"当前网络为手机流量"];
            } else if (status == AFNetworkReachabilityStatusReachableViaWiFi) {// wifi
//                [kKeyWindow showTip:@"当前网络为手机流量"];
            }
        });
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

//- (CGFloat)netWorkSpeed {
//    CGFloat speed = 0;
//    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
//    return speed;
//}


@end
