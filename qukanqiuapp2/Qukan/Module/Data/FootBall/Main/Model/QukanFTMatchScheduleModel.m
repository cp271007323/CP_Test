//
//  QukanFTMatchScheduleModel.m
//  Qukan
//
//  Created by Charlie on 2020/1/2.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanFTMatchScheduleModel.h"

@implementation QukanFTMatchScheduleModel

-(NSString *)acquireMatchState {
    switch (self.state.integerValue) {
        case 0: return @"未开赛"; break;
        case 1: return @"上半场"; break;
        case 2: return @"中场"; break;
        case 3: return @"下半场"; break;
        case 4: return @"加时"; break;
        case -11: return @"待定"; break;
        case -12: return @"腰斩"; break;
        case -13: return @"中断"; break;
        case -14: return @"推迟"; break;
        case -1: return @"完场"; break;
        case -10: return @"取消"; break;
        default: return @"未知"; break;
    }
}

//|state|Int|否|”比赛状态 0:未开 1:上半场 2:中场 3:下半场 4 加时，-11:待定 -12:腰斩 -13:中断 -14:推迟 -1:完场，-10取消”

- (BOOL)isInmatch {
    switch (self.state.integerValue) {
        case 1:
        case 2:
        case 3:
        case 4:
            return YES;
            break;
            
        default:
            return NO;
            break;
    }
}

@end
