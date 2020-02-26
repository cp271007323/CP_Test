//
//  QukanBoilingPointTableViewModel_1.h
//  Qukan
//
//  Created by mac on 2018/11/12.
//  Copyright © 2018 Ningbo Suda. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanBoilingPointTableViewModel_1 : NSObject
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *image_url;
@property (nonatomic, copy) NSString *turn_url;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, assign) NSInteger fansCount;
@property (nonatomic, assign) NSInteger postCount;
@property (nonatomic, assign) NSInteger infoId;
@property (nonatomic, assign) NSInteger user_id;
@property (nonatomic, assign) NSInteger is_follow;
@property (nonatomic, assign) NSInteger on_off;

- (instancetype)initWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
