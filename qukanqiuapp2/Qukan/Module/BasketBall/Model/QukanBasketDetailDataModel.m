//
//  QukanBasketDetailDataModel.m
//  Qukan
//
//  Created by leo on 2020/1/5.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanBasketDetailDataModel.h"


@implementation QukanBasketDetailChangjunData


@end
@implementation QukanBasketDetailSaijiData


@end
@implementation QukanBasketDetailHisFightData


@end


@implementation QukanBasketDetailDataModel


+(NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"teamHisFightData":[QukanBasketDetailHisFightData class],@"homeRecentFightData":[QukanBasketDetailHisFightData class],@"awayRecentFightData":[QukanBasketDetailHisFightData class]};
}

@end
