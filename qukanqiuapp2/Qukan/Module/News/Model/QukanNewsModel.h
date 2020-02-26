//
//  QukanNewsModel.h
//  Qukan
//
//  Created by pfc on 2019/7/6.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, QukanNewsType) {
    QukanNewsType_none,
    QukanNewsType_web,
    QukanNewsType_video,
};

@interface QukanNewsModel : NSObject<NSCoding>

@property(nonatomic, assign) QukanNewsType topicNewsType;

@property (nonatomic , assign) NSInteger              nid;
@property (nonatomic , copy) NSString              * leagueName;
@property (nonatomic , copy) NSString              * newsContent;
@property (nonatomic , copy) NSString              * videoUrl;
@property (nonatomic , assign) NSInteger              commentNum;

@property (nonatomic , copy) NSString              * createDate;
@property (nonatomic , copy) NSString              * newsId;
@property (nonatomic , copy) NSString              * imageUrl;
@property (nonatomic , copy) NSString              * isBurstPoint;
@property (nonatomic , copy) NSString              * pubTime;
@property(nonatomic  , copy) NSString              * pubTimeBefore;

@property (nonatomic , copy) NSString              * source;
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , assign) NSInteger              newType;
@property (nonatomic , copy) NSString              * updateDate;
@property (nonatomic , assign) NSInteger              readNum;
@property(nonatomic, assign) NSInteger                likeNum;
@property(nonatomic, assign) NSInteger                isLike;

@property (nonatomic , copy) NSString              * leagueId;


@property(nonatomic, assign) NSTimeInterval currentTime;

@property(nonatomic, assign) NSInteger filterId;

@end

NS_ASSUME_NONNULL_END
