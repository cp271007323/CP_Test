//
//  QukanBasketBallMatchDetailModel.m
//  Qukan
//
//  Created by blank on 2019/9/28.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanBasketBallMatchDetailModel.h"

@implementation QukanBasketBallMatchDetailModel
+(NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"guestPlayerList":[QukanHomeAndGuestPlayerListModel class],@"homePlayerList":[QukanHomeAndGuestPlayerListModel class]};
}
 //状态：0:未开赛，1:一节，2:二节，3:三节，4:四节，5:1’OT，6:2’OT，7:3’OT，-1:完场, -2:待定，-3:中断，-4:取消，-5:推迟，50:中场
- (MatchStatus)getMatchStatus {
    NSInteger status = self.status.integerValue;
    if (status == 0 || status == -5 || status == -2) {
        return NoOpenMatchStatus;
    } else if (status > 0) {
        return InMatchStatus;
    } else if (status < 0 && status != -1) {
        return UnusualMatchStatus;
    } else return EndMatchStatus;
    
}
@end

@implementation QukanHomeAndGuestPlayerListModel



@end

