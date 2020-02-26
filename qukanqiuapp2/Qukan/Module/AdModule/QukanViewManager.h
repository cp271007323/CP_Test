//
//  QukanViewManager.h
//  Qukan
//
//  Created by Jeff on 2019/11/27.
//  Copyright © 2019 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define kAdManager [QukanViewManager sharedInstance]

/// 广告管理
@interface QukanViewManager : NSObject

+ (instancetype)sharedInstance;
- (void)setup;
//- (void)takeWithType:(NSInteger)type;

@end

NS_ASSUME_NONNULL_END
