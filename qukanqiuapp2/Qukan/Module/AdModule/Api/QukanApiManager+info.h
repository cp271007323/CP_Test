//
//  QukanApiManager+info.h
//  Qukan
//
//  Created by Kody on 2019/8/9.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanApiManager.h"

NS_ASSUME_NONNULL_BEGIN

/// 查询广告接口
@interface QukanApiManager (info)

/* 获取信息流 */
- (RACSignal *)QukanInfoWithType:(NSInteger )type;

/**查找广告*/
- (RACSignal *)QukansearchInfoWithType:(NSString *)type;

/**比赛*/
- (RACSignal *)QukanInfoWithType:(NSInteger )type withid:(NSInteger)Id;

@end

NS_ASSUME_NONNULL_END
