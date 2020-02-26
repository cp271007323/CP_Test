//
//  QukanNewsCommentModel.m
//  Qukan
//
//  Created by Kody on 2019/7/18.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanNewsCommentModel.h"

@implementation QukanNewsCommentModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"newsId" : @"id"};
}

- (NSInteger)filterId {
    return self.newsId;
}

- (NSString *)filterName {
    return self.userName;
}

- (NSInteger)filterUserId {
    return self.userId;
}

@end

