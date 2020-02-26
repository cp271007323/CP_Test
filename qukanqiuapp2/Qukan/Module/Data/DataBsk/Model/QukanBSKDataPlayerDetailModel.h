//
//  QukanBSKDataPlayerDetailModel.h
//  Qukan
//
//  Created by blank on 2020/1/1.
//  Copyright © 2020 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
@class QukanChangeModel;
@class SeasonAvgData;
@class CareerTechnicData;
NS_ASSUME_NONNULL_BEGIN

@interface QukanBSKDataPlayerDetailModel : NSObject
@property (nonatomic, copy)NSString *playerId;
@property (nonatomic, copy)NSString *photo;
@property (nonatomic, copy)NSString *nameJ;
@property (nonatomic, copy)NSString *number;
@property (nonatomic, copy)NSString *birthday;
@property (nonatomic, copy)NSString *tallness;
@property (nonatomic, copy)NSString *nameE;
@property (nonatomic, copy)NSString *weight;
@property (nonatomic, copy)NSString *nbaAge;
@property (nonatomic, copy)NSString *teamId;
@property (nonatomic, copy)NSString *place;
@property (nonatomic, copy)NSString *salary;
@property (nonatomic, copy)NSString *college;
@property (nonatomic, copy)NSArray <QukanChangeModel *> *change;
@property (nonatomic, copy)NSArray <SeasonAvgData *> *seasonAvgData;
@property (nonatomic, copy)NSArray <CareerTechnicData *> *careerTechnicData;
@end
@interface QukanChangeModel :NSObject
@property (nonatomic, copy)NSString *playerId;
@property (nonatomic, copy)NSString *player;
@property (nonatomic, copy)NSString *tTime;
@property (nonatomic, copy)NSString *team;
@property (nonatomic, copy)NSString *teamNow;
@property (nonatomic, copy)NSString *teamId;
@property (nonatomic, copy)NSString *teamNowId;
@property (nonatomic, copy)NSString *zhSeason;
@property (nonatomic, copy)NSString *type;
@end

@interface SeasonAvgData :NSObject
@property (nonatomic, copy)NSString *matchKind;
@property (nonatomic, copy)NSString *matchKindName;
@property (nonatomic, copy)NSString *helpAttack;
@property (nonatomic, copy)NSString *score;
@property (nonatomic, copy)NSString *playCount;
@property (nonatomic, copy)NSString *rebound;
@property (nonatomic, copy)NSString *rob;
@property (nonatomic, copy)NSString *cover;
@property (nonatomic, copy)NSString *playTime;
@end

@interface CareerTechnicData :NSObject
@property (nonatomic, copy)NSString *season;
@property (nonatomic, copy)NSString *matchKind;
@property (nonatomic, copy)NSString *joinTime;
@property (nonatomic, copy)NSString *helpAttack;
@property (nonatomic, copy)NSString *score;
@property (nonatomic, copy)NSString *rebound;//篮板
@property (nonatomic, copy)NSString *rob;
@property (nonatomic, copy)NSString *cover;
@property (nonatomic, copy)NSString *teamName;
@property (nonatomic, copy)NSString *playTime;
@end
NS_ASSUME_NONNULL_END
