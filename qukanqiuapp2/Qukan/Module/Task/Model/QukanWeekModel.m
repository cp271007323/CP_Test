//
//  QukanWeekModel.m
//  Qukan
//
//  Created by Jeff on 2019/11/27.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanWeekModel.h"

@implementation QukanWeekModel


+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"theScore" : kGetImageType(12),
             @"todayNum":@"todayRed",
             @"changeNum":kGetImageType(13),
             @"totalNum":@"totalRed",
             @"todayTime":@"todayGTime",
             @"totalTime":@"totalGTime"
             };
}


@end
