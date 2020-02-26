//
//  QukanMessageModel.h
//  Qukan
//
//  Created by Kody on 2019/8/14.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanMessageModel : NSObject

@property(nonatomic, copy) NSString   *createTime;
@property(nonatomic, copy) NSString   *content;
@property(nonatomic, copy) NSString   *xtype;


@end

NS_ASSUME_NONNULL_END
