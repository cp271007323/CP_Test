//
//  QukanMemberIntroModel.m
//  Qukan
//
//  Created by Charlie on 2020/1/2.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanMemberIntroModel.h"

@implementation QukanPlayerTRecordModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"tTime" : @"transferTime"};
}


@end


@implementation QukanMemberIntroModel
+(NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"transRecords":[QukanPlayerTRecordModel class]};
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"tRecords" : @"transRecords"};
}

-(NSString *)feet{
    if(!_feet)
        return @"";
    return _feet;
}

-(NSString *)health{
    if(!_health)
        return @"";
    return _health;
}

-(NSString *)tallness{
    if(!_tallness)
        return @"";
    return _tallness;
}

-(NSString *)value{
    if(!_value)
        return @"";
    return _value;
}

-(NSString *)weight{
    if(!_weight)
        return @"";
    return _weight;
}

-(NSString *)number{
    if(!_number)
        return @"";
    if(_number.intValue <= 0){
        return @"";
    }
    return _number;
}

@end
