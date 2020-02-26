//
//  QukanNewInfoModel.m
//  Qukan
//
//  Created by Jeff on 2019/11/27.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanNewInfoModel.h"

@implementation QukanNewInfoModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"nId" : @"advId",
             @"typeID" : @"advTypeID",
             @"skipId" : @"skipTypeId",
             @"newsLink" : @"linked"};
}

@end
