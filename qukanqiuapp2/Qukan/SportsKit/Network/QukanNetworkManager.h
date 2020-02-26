//
//  QukanNetworkManager.h
//  Qukan
//
//  Created by Kody on 2019/7/25.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define kNetworkManager [QukanNetworkManager sharedInstance]

@interface QukanNetworkManager : NSObject

+ (instancetype)sharedInstance;
- (void)addReachabilityMonitor;
//- (CGFloat)netWorkSpeed;

@end

NS_ASSUME_NONNULL_END
