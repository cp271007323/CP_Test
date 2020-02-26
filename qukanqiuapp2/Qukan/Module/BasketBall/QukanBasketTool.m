//
//  QukanBasketTool.m
//  Qukan
//
//  Created by leo on 2019/9/27.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanBasketTool.h"

@interface QukanBasketTool ()

@property(nonatomic, strong) NSArray   * arr_source;

@end

@implementation QukanBasketTool

#pragma mark ===================== 初始化 ==================================
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static QukanBasketTool *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}


#pragma mark ===================== function ==================================
//0:未开赛，1:一节，2:二节，3:三节，4:四节，5:1’OT，6:2’OT，7:3’OT，-1:完场, -2:待定，-3:中断，-4:取消，-5:推迟，50:中场
- (NSString *)qukan_getStateStrFromState:(NSInteger)state {
    if (state < 0) {
        return self.arr_source[labs(state) + 7];
    }
    if (0 <= state && state < 8) {
        return self.arr_source[state];
    }
    return self.arr_source.lastObject;
}


#pragma mark ===================== lazy ==================================
- (NSArray *)arr_source {
    if (!_arr_source) {
        _arr_source = @[@"未开赛",@"第1节",@"第2节",@"第3节",@"第4节",@"1’OT",@"2’OT",@"3’OT",@"完场",@"待定",@"中断",@"取消",@"推迟",@"中场"];
    }
    return _arr_source;
}

+ (QukanBasketMatchState)getStateForMathStatus:(NSInteger)matchStatus {
    if (matchStatus == 0) {
        return QukanBasketMatchNoStart;
    } else if (matchStatus > 0) {
        return QukanBasketMatching;
    } else if (matchStatus < 0 && matchStatus != -1) {
        return QukanBasketMatchStateOther;
    } else {
        return QukanBasketMatchended;
    }
}

@end
