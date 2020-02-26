//
//  QukanBoilingPointTableViewModel_3.m
//  Qukan
//
//  Created by mac on 2018/11/15.
//  Copyright © 2018 Ningbo Suda. All rights reserved.
//

#import "QukanBoilingPointTableViewModel_3.h"

@implementation QukanBoilingPointTableViewModel_3

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self=[super init]) {
        _content = dict[@"content"]?:@"";
        _create_time = dict[@"time"]?:@"";
        _time = dict[@"time"]?:@"";
        _title = dict[@"title"]?:@"";
        _user_icon = dict[@"user_icon"]?:@"";
        _username = dict[@"username"]?:@"";
        _image_url = dict[@"image_url"]?:@"";
        
        _comment_count = [dict[@"comment_count"] integerValue];
        _infoId = [dict[@"id"] integerValue];
        _module_id = [dict[@"module_id"] integerValue];
        _status = [dict[@"status"] integerValue];
        _user_id = [dict[@"user_id"] integerValue];
        _images = [[NSArray alloc] initWithArray:dict[@"images"]];
        _is_like = [dict[@"is_like"] integerValue];
        _like_count = [dict[@"like_count"] integerValue];
        _user_follow = [dict[@"user_follow"] integerValue];

        NSArray *module = (NSArray *)dict[@"module"];
        if (module.count>0) {
            NSDictionary *d = module.firstObject;
            _model = [[QukanBoilingPointTableViewModel_1 alloc] initWithDict:d];
        } else {
            _model = nil;
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return [self modelInitWithCoder:aDecoder];
}

- (NSInteger)filterId {
    return self.infoId;
}

- (NSInteger)filterUserId {
    return self.user_id;
}

- (NSString *)filterName {
    return self.username;
}

@end
