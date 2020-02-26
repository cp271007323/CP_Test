//
//  QukanNewsCommentModel.h
//  Qukan
//
//  Created by Kody on 2019/7/18.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanNewsCommentModel : NSObject

@property (nonatomic , copy) NSString              *commentContent;
@property (nonatomic , copy) NSString              *createdDate;
@property(nonatomic  , copy) NSString              *userName;
@property(nonatomic  , copy) NSString              *userIcon;
@property(nonatomic  , copy) NSString              *createdDateBefore;

@property(nonatomic, assign) NSInteger             newsId;
@property(nonatomic, assign) NSInteger             likeCount;
@property(nonatomic, assign) NSInteger             replyCount;
@property(nonatomic, assign) NSInteger             sourceType;
@property(nonatomic, assign) NSInteger             sourceId;
@property(nonatomic, assign) NSInteger             userId;
@property(nonatomic, assign) NSInteger             isLike;


#pragma mark ===================== QukanFilterObjct ==================================

@property(nonatomic, assign) NSInteger filterId;
@property(nonatomic, assign) NSInteger filterUserId;
@property(nonatomic, copy) NSString *filterName;

@end

NS_ASSUME_NONNULL_END
