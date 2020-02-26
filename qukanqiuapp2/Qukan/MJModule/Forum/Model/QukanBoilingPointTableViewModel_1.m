//
//  QukanBoilingPointTableViewModel_1.m
//  Qukan
//
//  Created by mac on 2018/11/12.
//  Copyright © 2018 Ningbo Suda. All rights reserved.
//

#import "QukanBoilingPointTableViewModel_1.h"

@implementation QukanBoilingPointTableViewModel_1

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self=[super init]) {
        _create_time = dict[@"create_time"]?:@"";
        _image_url = dict[@"image_url"]?:@"";
        _turn_url = dict[@"turn_url"]?:@"";
        _title = dict[@"title"]?:@"";
        _summary = dict[@"summary"]?:@"";
        _fansCount = [dict[@"fansCount"] integerValue];
        _postCount = [dict[@"postCount"] integerValue];
        _infoId = [dict[@"id"] integerValue];
        _user_id = [dict[@"user_id"] integerValue];
        _is_follow = [dict[@"is_follow"] integerValue];
        _on_off = [dict[@"on_off"] integerValue];
    }
    return self;
}

@end
