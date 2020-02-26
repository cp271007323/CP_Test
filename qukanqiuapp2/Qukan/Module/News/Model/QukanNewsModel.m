//
//  QukanNewsModel.m
//  Qukan
//
//  Created by pfc on 2019/7/6.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanNewsModel.h"

@implementation QukanNewsModel


- (QukanNewsType)topicNewsType {
    if (self.newType == 1) {
        return QukanNewsType_web;
    }else if (self.newType == 2) {
        return QukanNewsType_video;
    }
    
    return QukanNewsType_none;
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"newsContent" : @"newContent",
             @"nid":@"id"};
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return [self modelInitWithCoder:aDecoder];
}


- (NSInteger)filterId {
    return self.nid;
}

- (BOOL)isEqual:(QukanNewsModel *)object {
    return self.nid == object.nid;
}

@end
