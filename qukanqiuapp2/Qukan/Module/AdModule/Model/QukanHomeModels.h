//
//  QukanHomeModels.h
//  Qukan
//
//  Created by Jeff on 2019/11/27.
//  Copyright © 2019 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, QukanAdJumpType) {
    QukanViewJumpType_In     = 1,
    QukanViewJumpType_Out      = 2,
    QukanViewJumpType_AppIn    = 3,
    QukanViewJumpType_Other    = 4,
};


/// 广告模型
@interface QukanHomeModels : NSObject<NSCoding>

@property(nonatomic, strong) NSString       *title;
@property(nonatomic, strong) NSString       *image;
@property(nonatomic, strong) NSString       *type;
@property(nonatomic, strong) NSString       *jump_type;
@property(nonatomic, strong) NSString       *v_url;
@property(nonatomic, strong) NSString       *desc;

@end

NS_ASSUME_NONNULL_END
