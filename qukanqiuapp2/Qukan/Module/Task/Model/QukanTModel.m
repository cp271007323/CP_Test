//
//  QukanTModel.m
//  Qukan
//
//  Created by Jeff on 2019/11/27.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanTModel.h"
#import "QukanActionModel.h"

@implementation QukanTModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"tId" : @"id",@"descr" : @"description",
             @"pageNumber":FormatString(@"%@Number", kGetImageType(19)),
             @"configList":FormatString(@"%@ConfigList", kGetImageType(20)),
             @"tRecordId":FormatString(@"%@RecordId", kGetImageType(20))
             };
}


+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"configList" : [QukanActionModel class]};
}

@end
