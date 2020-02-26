//
//  QukanBoilingPointTableViewModel_3.h
//  Qukan
//
//  Created by mac on 2018/11/15.
//  Copyright © 2018 Ningbo Suda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QukanBoilingPointTableViewModel_1.h"

NS_ASSUME_NONNULL_BEGIN

@interface QukanBoilingPointTableViewModel_3 : NSObject<NSCoding>
@property (nonatomic, assign) NSInteger comment_count;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, assign) NSInteger infoId;
@property (nonatomic, assign) NSInteger module_id;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *user_icon;
@property (nonatomic, assign) NSInteger user_id;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *image_url;
@property (nonatomic, copy) NSArray *images;
@property (nonatomic, assign) NSInteger is_like;
@property (nonatomic, assign) NSInteger like_count;
@property (nonatomic, assign) NSInteger user_follow;
@property (nonatomic, strong) QukanBoilingPointTableViewModel_1 *model;
- (instancetype)initWithDict:(NSDictionary *)dict;


#pragma mark ===================== QukanFilterObjct ==================================

@property(nonatomic, assign) NSInteger filterUserId;
@property(nonatomic, assign) NSInteger filterId;
@property(nonatomic, copy) NSString *filterName;

@end

NS_ASSUME_NONNULL_END
