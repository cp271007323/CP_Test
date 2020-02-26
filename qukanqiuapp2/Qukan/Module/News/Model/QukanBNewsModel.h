//
//  QukanBNewsModel.h
//  Qukan
//
//  Created by pfc on 2019/7/19.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QukanNewInfoModel.h"
#import "QukanNewsModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 新闻广告model
@interface QukanBNewsModel : NSObject

@property(nonatomic, assign, readonly) BOOL isNews;

@property(nonatomic, assign) NSInteger flag;

@property(nonatomic, copy) NSArray<QukanNewsModel *> *news;
@property(nonatomic, copy) NSArray<QukanNewInfoModel *> *bas;

- (NSArray *)validDatas;

@end

NS_ASSUME_NONNULL_END
