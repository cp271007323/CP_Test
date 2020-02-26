//
//  QukanXuanModel.h
//  Qukan
//
//  Created by Kody on 2019/9/9.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanXuanModel : NSObject<NSCoding>

@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *val;
@property(nonatomic, copy) NSString *content;

@property(nonatomic, assign) int textId;

@end

NS_ASSUME_NONNULL_END
