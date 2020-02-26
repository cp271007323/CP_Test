//
//  QukanActionModel.m
//  Qukan
//
//  Created by Jeff on 2019/11/17.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanActionModel.h"

@implementation QukanActionModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"descr" : @"description",
             @"type1":FormatString(@"%@Type", kGetImageType(20)),
             @"pageNumber":FormatString(@"%@Number", kGetImageType(19)),
             @"type2":FormatString(@"%@Type", kGetImageType(19)),
             @"tRecordId":FormatString(@"%@RecordId", kGetImageType(20))
             };
    
}

@end
