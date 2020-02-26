//
//  QukanBSKDataScheduleModel.h
//  Qukan
//
//  Created by blank on 2019/12/29.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanBSKDataScheduleModel : UIView
@property (nonatomic, copy)NSString *matchId;
@property (nonatomic, copy)NSString *sclassId;
@property (nonatomic, copy)NSString *startTime;

@property (nonatomic, copy)NSString *matchTime;
@property (nonatomic, copy)NSString *status;
@property (nonatomic, copy)NSString *homeId;

@property (nonatomic, copy)NSString *homeName;
@property (nonatomic, copy)NSString *awayId;
@property (nonatomic, copy)NSString *awayName;

@property (nonatomic, copy)NSString *homeLogo;
@property (nonatomic, copy)NSString *awayLogo;
@property (nonatomic, copy)NSString *homeScore;

@property (nonatomic, copy)NSString *awayScore;
@property (nonatomic, copy)NSString *cificat;
@property (nonatomic, copy)NSString *chiCificat;
@property (nonatomic, copy)NSString *dayOfWeek;

@property(nonatomic, copy) NSString *remainTime;

- (NSString*)weekDayStr:(NSString*)format;

- (NSString *)getMatchNode;
@end

NS_ASSUME_NONNULL_END
