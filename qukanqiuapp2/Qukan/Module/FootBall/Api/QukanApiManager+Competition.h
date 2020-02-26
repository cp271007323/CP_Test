//
//  QukanApiManager+Competition.h
//  Qukan
//
//  Created by Kody on 2019/6/22.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanApiManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface QukanApiManager (Competition)

/**获取敏感关键词*/
- (RACSignal *)QukanStStatus;

/**获取开关配置*/
- (RACSignal *)QukanXuan;

//- (RACSignal *)QukanfindMatchAdWithType:(NSString *)type;

/** 话题分类 */
- (RACSignal *)QukanmatchInfosWithType:(NSString *)type andLeague_ids:(NSString *)league_ids addOffset_day:(NSString *)offset_day andAll:(NSNumber *)all addIshot:(NSString *)ishot;

/** 设置话题分类 */
//- (RACSignal *)QukanmatchFindLeagueLabelWithLabelFlag:(NSString *)labelFlag andSendType:(NSString *)sendType addOffset_day:(NSString *)offset_day;
- (RACSignal *)QukanmatchFindLeagueLabelWithLabelFlag:(NSString *)labelFlag andSendType:(NSString *)sendType addOffset_day:(NSString *)offset_day andLeague_ids:(NSString *)league_ids;


/** 赛事情况 */
- (RACSignal *)QukanMatchFindAllByMatchIdWithMatchId:(NSString *)matchId;

/** 阵容情况 */
- (RACSignal *)QukanMatchFindLineupByMatchIdWithMatchId:(NSString *)matchId;

/** 直播情况 */
- (RACSignal *)QukanMatchFindTextLiveWithMatchId:(NSString *)matchId addTextLiveId:(NSString *)textliveid;

/** 直播情况 */
- (RACSignal *)QukanmatchTeam_flagWithMatchId:(NSString *)matchId;

/** 赛事关注列表 */
- (RACSignal *)QukanAttention_Find_attention;

/** 关注赛事 */
- (RACSignal *)QukanAttention_AddWithMatchId:(NSString *)matchId;

/** 取消关注赛事 */
- (RACSignal *)QukanAttention_DelWithMatchId:(NSString *)matchId;

/** 获取赛事的直播路线 */
- (RACSignal *)QukanWithMatchId:(NSString *)matchId;
/** 查询比赛广告 */
- (RACSignal *)QukanFetchMachId:(NSString *)matchId;
#pragma mark ===================== 聊天室相关 ==================================

/* 获取聊天室token 和 ID */
- (RACSignal *)Qukan_getTokenForType:(NSInteger)matchType matchId:(NSInteger)matchId;

/** 获取聊天室地址 */
- (RACSignal *)Qukan_getListAddre:(NSString *)roomId andType:(NSInteger)type;

/** 获取服务器的时间 */
- (RACSignal *)Qukan_getDateTime;

/** 获取球队技术统计数据
 leagueId    是    int    联赛id
 season    是    string    赛季
 teamId    是    int    球队id
 */
- (RACSignal *)QukanGetMatchDetailJSTJDataWith:(NSInteger)leagueId season:(NSString *)season teamId:(NSInteger)teamId;



/**
 查询交战记录

 @param type 1主客队历史对战,2近期战绩
 @param homeId 主队id
 @param awayId     客队id
 @param leagueId 联赛id
 @param flagLeague 是否同赛事 1是 0否
 @param flagHA 是否同主客 1是 0否
 @return 请求信号
 */
- (RACSignal *)QukanGetMatchDetailLSZJDataWithType:(NSInteger)type homeId:(NSInteger)homeId awayId:(NSInteger)awayId leagueId:(NSInteger)leagueId flagLeague:(NSInteger)flagLeague flagHA:(NSInteger)flagHA;




@end

NS_ASSUME_NONNULL_END
