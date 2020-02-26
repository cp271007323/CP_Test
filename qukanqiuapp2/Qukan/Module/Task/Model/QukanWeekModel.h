//
//  QukanWeekModel.h
//  Qukan
//
//  Created by Jeff on 2019/11/27.
//  Copyright © 2019 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanWeekModel : NSObject


@property (copy, nonatomic)  NSString *todayScore;

@property (copy, nonatomic)  NSString *theScore;

@property (copy, nonatomic)  NSString *totalScore;

@property (copy, nonatomic)  NSString *todayNum;

@property (copy, nonatomic)  NSString *changeNum;

@property (copy, nonatomic)  NSString *totalNum;
/**投屏特权剩余时间*/
@property (copy, nonatomic)  NSString *tpTime;
/**今日观看比赛时间（秒）*/
@property (copy, nonatomic)  NSString *todayTime;
/**累积观看比赛时间（秒)*/
@property (copy, nonatomic)  NSString *totalTime;

@end

NS_ASSUME_NONNULL_END
