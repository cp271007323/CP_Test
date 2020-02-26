//
//  QukanBSKDataTeamDetailModel.h
//  Qukan
//
//  Created by blank on 2020/1/1.
//  Copyright © 2020 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
@class QukanPlayerList;
NS_ASSUME_NONNULL_BEGIN

@interface QukanBSKDataTeamDetailModel : NSObject
@property (nonatomic, copy)NSString *teamId;
@property (nonatomic, copy)NSString *gb;
@property (nonatomic, copy)NSString *logo;
@property (nonatomic, copy)NSString *league;
@property (nonatomic, copy)NSString *totalOrder;
@property (nonatomic, copy)NSString *near10Win;

@property (nonatomic, copy)NSString *near10Loss;
@property (nonatomic, copy)NSString *city;
@property (nonatomic, copy)NSString *joinYear;
@property (nonatomic, copy)NSString *gymnasium;
@property (nonatomic, copy)NSString *drillMaster;
@property (nonatomic, copy)NSString *championNums;
@property (nonatomic, copy)NSString *introduce;
@property (nonatomic, copy)NSString *championship;
@property (nonatomic, assign)BOOL attention;
@property (nonatomic, copy)NSArray <QukanPlayerList *> *playerList;
- (CGFloat)caculateHeight;
@end

@interface QukanPlayerList : NSObject
@property (nonatomic, copy)NSString *playerId;
@property (nonatomic, copy)NSString *photo;
@property (nonatomic, copy)NSString *nameJ;
@property (nonatomic, copy)NSString *number;
@property (nonatomic, copy)NSString *place;
@property (nonatomic, copy)NSString *tallness;
@property (nonatomic, copy)NSString *weight;
@property (nonatomic, copy)NSString *salary;
@end
@interface QukanSelectScheduleTeamModel : NSObject
@property (nonatomic, copy)NSString *matchId;
@property (nonatomic, copy)NSString *sclassId;
@property (nonatomic, copy)NSString *startTime;
@property (nonatomic, copy)NSString *matchTime;
@property (nonatomic, copy)NSString *status;
@property (nonatomic, copy)NSString *homeId;
@property (nonatomic, copy)NSString *homeName;
@property (nonatomic, copy)NSString *awayId;
@property (nonatomic, copy)NSString *leagueName;
@property (nonatomic, copy)NSString *awayName;
@property (nonatomic, copy)NSString *homeLogo;
@property (nonatomic, copy)NSString *awayLogo;
@property (nonatomic, copy)NSString *homeScore;
@property (nonatomic, copy)NSString *awayScore;
@property (nonatomic, copy)NSString *remainTime;

@property (nonatomic, assign)BOOL attention;
@end
NS_ASSUME_NONNULL_END
