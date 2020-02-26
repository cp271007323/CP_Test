//
//  QukanCupMatchModel.h
//  Qukan
//
//  Created by Charlie on 2020/1/6.
//  Copyright © 2020 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*
 "away_name": "塞内加尔",
 "flag2": "http://zq.win007.com/Image/team/images/20140524121814.jpg",
 "flag1": "http://zq.win007.com/Image/team/images/2009614222535.gif",
 "away_id": "815",
 "bc2": "1",
 "corner1": 4,
 "bc1": "1",
 "corner2": 6,
 "home_name": "马达加斯加",
 "season": "2019-2020",
 "home_id": "5295",
 "state": "-1",
 "ishot": 0,
 "home_score": 2,
 "roundNum": "分组塞A",
 "away_score": 2,
 "pass_time": "完",
 "match_id": 1393531,
 "league_name": "非洲杯",
 "match_time": "19:30",
 "yellow1": 2,
 "yellow2": 6,
 "start_time": "2018-09-09 19:30:00",
 "red2": 0,
 "red1": 0,
 "order2": "27",
 "order1": "106",
 "league_id": 650
 */

@interface QukanCupMatchModel : NSObject

@property(nonatomic,strong) NSString* away_name;
@property(nonatomic,strong) NSString* away_score;
@property(nonatomic,strong) NSString* bc1;
@property(nonatomic,strong) NSString* bc2;
@property(nonatomic,strong) NSString* corner1;
@property(nonatomic,strong) NSString* corner2;

@property(nonatomic, copy) NSString *isAttention;

@property(nonatomic,strong) NSString* home_id;
@property(nonatomic,strong) NSString* away_id;
@property(nonatomic,strong) NSString* home_name;
@property(nonatomic,strong) NSString* home_score;
@property(nonatomic,strong) NSString* roundNum;

@property(nonatomic,strong) NSString* league_id;
@property(nonatomic,strong) NSString* league_name;
@property(nonatomic,strong) NSString* match_id;
@property(nonatomic,strong) NSString* match_time;
@property(nonatomic,strong) NSString* pass_time;
@property(nonatomic,strong) NSString* start_time;

@property(nonatomic,strong) NSString* red1;
@property(nonatomic,strong) NSString* red2;
@property(nonatomic,strong) NSString* state;
@property(nonatomic,strong) NSString* yellow1;
@property(nonatomic,strong) NSString* yellow2;
@property(nonatomic,strong) NSString* order1;
@property(nonatomic,strong) NSString* order2;

@property(nonatomic,strong) NSString* flag1;
@property(nonatomic,strong) NSString* flag2;
@property(nonatomic,strong) NSString* season;

@property(nonatomic,strong) NSString* ishot;

@end

NS_ASSUME_NONNULL_END
