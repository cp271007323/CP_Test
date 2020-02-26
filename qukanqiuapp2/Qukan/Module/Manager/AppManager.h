//
//  AppManager.h
//  DaiXiongTV
//
//  Created by pfc on 2019/6/12.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define kAppManager [AppManager sharedInstance]

@interface AppManager : NSObject

//@property(nonatomic, copy) NSString *QukanappName;
//@property(nonatomic, copy) NSString *QukanappVersion;
//@property(nonatomic, assign) BOOL QukanopenLog;

+ (instancetype)sharedInstance;

- (void)appSetup;

@property(nonatomic, copy, nullable) NSString *openInstallChannelCode;
@property(nonatomic, copy, readonly) NSString *umName;
@property(nonatomic, copy, readonly) NSString *Qukan_channel;

/// 是否安装WhatsApp 0 代表安装 1 代表未安装
@property(nonatomic, assign) BOOL appstoreUpdate;


@end

NS_ASSUME_NONNULL_END
