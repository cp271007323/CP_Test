//
//  QukanHomeModels.m
//  Qukan
//
//  Created by Jeff on 2019/11/27.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanHomeModels.h"

@implementation QukanHomeModels

//@property(nonatomic, strong) NSString       *title;
//@property(nonatomic, strong) NSString       *ad_image;
//@property(nonatomic, strong) NSString       *ad_type;
//@property(nonatomic, strong) NSString       *jump_type;
//@property(nonatomic, strong) NSString       *ad_url;
//@property(nonatomic, strong) NSString       *desc;

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"adId" : @"id",
             @"image" : @"ad_image",
             @"type" : @"ad_type",
             @"v_url" : @"ad_url"
             };
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return [self modelInitWithCoder:aDecoder];
}

@end
