//
//  QukanFTMatchScheduleModel.h
//  Qukan
//
//  Created by Charlie on 2020/1/2.
//  Copyright © 2020 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


/*
 away_name    String    否    客队名称
 away_score    Int    否    客队比分
 bc1    Int    否    主队上半场比分
 bc2    Int    否    客队上半场比分
 corner1    Int    否    主队角球
 corner2    Int    否    客队角球
 home_id    String    否    主队ID
 away_id    String    否    主队ID
 home_name    String    否    主队名称
 home_score    Int    否    主队比分
 roundNum    string    否    当前轮次/分组
 league_id    Int    否    联赛ID
 league_name    String    否    联赛名称
 match_time    String    否    比赛开始时间
 pass_time    String    否    比赛历经时间
 red1    Int    否    主队红牌
 red2    Int    否    客队红牌
 state    Int    否    “比赛状态 0:未开 1:上半场 2:中场 3:下半场 4 加时，-11:待定 -12:腰斩 -13:中断 -14:推迟 -1:完场，-10取消”
 yellow1    Int    否    主队黄牌
 yellow2    Int    否    客队黄牌
 order1    String    否    主队排名
 order2    String    否    客队排名
 flag1    String    否    主队队标URL
 flag2    String    否    客队队标URL
 isAttention    String    否    1表示关注 2表示没关注
 gqLive    String    否    0：高清无直播 1：高清有直播
 dLive    String    否    0：动画无直播 1：动画有直播
 roundNum    String    否    轮次/分组
 season    String    否    赛季
 */
@interface QukanFTMatchScheduleModel : NSObject

@property(nonatomic,strong) NSString* away_name;
@property(nonatomic,strong) NSString* away_score;
@property(nonatomic,strong) NSString* bc1;
@property(nonatomic,strong) NSString* bc2;
@property(nonatomic,strong) NSString* corner1;
@property(nonatomic,strong) NSString* corner2;

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
@property(nonatomic,assign) NSString* state;
@property(nonatomic,strong) NSString* yellow1;
@property(nonatomic,strong) NSString* yellow2;
@property(nonatomic,strong) NSString* order1;
@property(nonatomic,strong) NSString* order2;

@property(nonatomic,strong) NSString* flag1;
@property(nonatomic,strong) NSString* flag2;
@property(nonatomic,strong) NSString* isAttention;
@property(nonatomic,strong) NSString* gqLive;
@property(nonatomic,strong) NSString* dLive;
@property(nonatomic,strong) NSString* season;

@property(nonatomic,strong) NSString* currentTeamName;

-(NSString *)acquireMatchState;
- (BOOL)isInmatch;
//@property(nonatomic,strong) NSString* matchId;

@end

NS_ASSUME_NONNULL_END
