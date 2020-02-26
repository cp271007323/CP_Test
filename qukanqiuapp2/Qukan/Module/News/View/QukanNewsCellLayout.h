//
//  QukanNewsCellLayout.h
//  Qukan
//
//  Created by pfc on 2019/7/9.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYKit/YYTextLayout.h>

NS_ASSUME_NONNULL_BEGIN

@class QukanNewsModel;
@interface QukanNewsCellLayout : NSObject

@property(nonatomic, strong, readonly) QukanNewsModel  *newsModel;

- (instancetype)initWithNewsModel:(QukanNewsModel *)newsModel;

@property(nonatomic, assign, readonly) CGRect headViewRect;
@property(nonatomic, assign, readonly) CGRect contentRect;
@property(nonatomic, assign, readonly) CGRect imageViewRect;
@property(nonatomic, copy, readonly) NSArray* mutableImageViewRects;
@property(nonatomic, assign, readonly) CGRect infoViewRect;
@property(nonatomic, assign, readonly) CGRect filterBtnRect;

@property(nonatomic, assign, readonly) CGFloat height;

//@property(nonatomic, strong) YYTextLayout *contentLayout;

@property(nonatomic, assign, readonly) BOOL showRightImage;

@end

NS_ASSUME_NONNULL_END
