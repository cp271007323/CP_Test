//
//  QukanBPCommentsModel.m
//  Qukan
//
//  Created by leo on 2019/10/3.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanBPCommentsModel.h"

// 评论主内容模型
@implementation QukanBPCommentsContentModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"Id" : @"id"};
}


- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return [self modelInitWithCoder:aDecoder];
}

@end

// 点赞的用户模型
@implementation QukanBPCommentsGreatsModel

@end


// 评论模型
@implementation QukanBPCommentsModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"Id" : @"id"};
}

+(NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"greats":[QukanBPCommentsGreatsModel class]};
}

@end




