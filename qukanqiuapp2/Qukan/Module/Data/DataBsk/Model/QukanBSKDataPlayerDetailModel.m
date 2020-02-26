//
//  QukanBSKDataPlayerDetailModel.m
//  Qukan
//
//  Created by blank on 2020/1/1.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanBSKDataPlayerDetailModel.h"

@implementation QukanBSKDataPlayerDetailModel
+(NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"transfer":[QukanChangeModel class],@"seasonAvgData":[SeasonAvgData class],@"careerTechnicData":[CareerTechnicData class]};
}
@end
@implementation QukanChangeModel

+(NSDictionary *)modelCustomPropertyMapper {
    return @{@"tTime" : @"transferTime"};
}


@end
@implementation SeasonAvgData

@end
@implementation CareerTechnicData

@end
