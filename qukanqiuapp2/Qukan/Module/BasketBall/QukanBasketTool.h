//
//  QukanBasketTool.h
//  Qukan
//
//  Created by leo on 2019/9/27.
//  Copyright © 2019 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, QukanBasketMatchState) {
    QukanBasketMatchNoStart,
    QukanBasketMatching,
    QukanBasketMatchended,
    QukanBasketMatchStateOther,
};

@interface QukanBasketTool : NSObject

+ (instancetype)sharedInstance;


// 根据比赛状态获取状态字符串
- (NSString *)qukan_getStateStrFromState:(NSInteger)state;

+ (QukanBasketMatchState)getStateForMathStatus:(NSInteger)matchStatus;

@end

NS_ASSUME_NONNULL_END
