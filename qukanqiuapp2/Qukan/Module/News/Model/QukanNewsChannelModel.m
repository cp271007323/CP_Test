//
//  QukanNewsChannelModel.m
//  Qukan
//
//  Created by pfc on 2019/7/17.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanNewsChannelModel.h"

@implementation QukanNewsChannelModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"cid" : @"id"};
}
- (void)encodeWithCoder:(NSCoder *)aCoder { [self modelEncodeWithCoder:aCoder]; }
- (id)initWithCoder:(NSCoder *)aDecoder { self = [super init]; return [self modelInitWithCoder:aDecoder]; }

@end
