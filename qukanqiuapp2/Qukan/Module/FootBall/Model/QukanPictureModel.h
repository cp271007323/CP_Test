//
//  QukanPictureModel.h
//  Qukan
//
//  Created by hello on 2019/9/16.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanPictureModel : NSObject

@property (nonatomic, assign) BOOL isFollow;
@property (nonatomic ,copy)   NSString *awayId;
@property (nonatomic ,copy)   NSString *homeId;
@property (nonatomic ,copy)   NSString *isAttention;
@property (nonatomic, assign) NSInteger contentType;
@property (nonatomic, assign) NSInteger redTips;
@property (nonatomic, assign) NSInteger goalTips;
@property (nonatomic, assign) NSInteger matchId;
@property (nonatomic, copy) NSString *leagueName;
@property (nonatomic, copy) NSString *matchTime;
@property (nonatomic, copy) NSString *passTime;
@property (nonatomic, assign) NSInteger bc1;
@property (nonatomic, assign) NSInteger bc2;
@property (nonatomic, assign) NSInteger corner1;
@property (nonatomic, assign) NSInteger corner2;
@property (nonatomic, copy) NSString *homeName;
@property (nonatomic, copy) NSString *awayName;
@property (nonatomic, assign) NSInteger homeScore;
@property (nonatomic, assign) NSInteger awayScore;
@property (nonatomic, copy) NSString *order1;
@property (nonatomic, copy) NSString *order2;
@property (nonatomic, copy) NSString *ajilv;
@property (nonatomic, copy) NSString *dxjilv;
@property (nonatomic, assign) NSInteger red1;
@property (nonatomic, assign) NSInteger red2;
@property (nonatomic, assign) NSInteger yellow1;
@property (nonatomic, assign) NSInteger yellow2;
@property (nonatomic, copy) NSString *awayFlag;
@property (nonatomic, copy) NSString *homeFlag;
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *gqLive;
@property (nonatomic, copy) NSString *dhLive;
@end

@interface QukanApsModel : NSObject
@property (nonatomic, copy) NSString *alert;
@property (nonatomic, copy) NSString *badge;
@property (nonatomic, copy) NSString *sound;
@end

@interface QukanTuiSongModel : NSObject
@property (nonatomic, strong)QukanApsModel  *aps;
@property (nonatomic, copy) NSString *d;
@property (nonatomic, copy) NSString *ids;
@property (nonatomic, copy) NSString *jstime;
@property (nonatomic, copy) NSString *jumpCustomized;
@property (nonatomic, copy) NSString *jumpModel;
@property (nonatomic, copy) NSString *jumpType;
@property (nonatomic, copy) NSString *p;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *ticker;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *userIds;


@end

NS_ASSUME_NONNULL_END
