//
//  LBLelinkService+Extension.h
//  dxMovie-ios
//
//  Created by james on 2019/6/4.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import <LBLelinkKit/LBLelinkKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    isNormal,
    isConnecting,
    isConnected,
    isDisConnected,
    connectFail,
} ConnectStatus;

@interface LBLelinkService (Extension)
@property (nonatomic,assign) ConnectStatus status;
@end

NS_ASSUME_NONNULL_END
