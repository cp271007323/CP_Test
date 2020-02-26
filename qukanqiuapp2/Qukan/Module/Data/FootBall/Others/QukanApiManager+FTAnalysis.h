//
//  QukanApiManager+FTAnalysis.h
//  Qukan
//
//  Created by Charlie on 2019/12/26.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanApiManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface QukanApiManager (FTAnalysis)

/* 区域联赛 */
- (RACSignal *)QukanFetchLeagueInfoByAreaId:(NSNumber*)areaId;

/**查询联赛积分*/
- (RACSignal *)QukanFetchTeamLeagueRankInfoWithParams:(NSDictionary *)params;

/**查询杯赛积分*/
- (RACSignal *)QukanFetchTeamCupRankInfoWithParams:(NSDictionary *)params;

/**查询射手排行榜*/
- (RACSignal *)QukanFetchPlayerRankInfoWithParams:(NSDictionary *)params;

/**查询赛程列表*/
- (RACSignal *)QukanFetchScheduleInfoWithParams:(NSDictionary *)params;

/**查询赛程轮次*/
- (RACSignal *)QukanFetchMatchRoundListWithParams:(NSDictionary *)params;

/**关注球队*/
- (RACSignal *)QukanFollowFTTeamWithParams:(NSDictionary *)params;


/**取消关注*/
- (RACSignal *)QukanUnFollowFTTeamWithParams:(NSDictionary *)params;


//====================球队详情==========================
//球队详情---最近战绩
- (RACSignal *)QukanFetchTeamRecentRecordWithParams:(NSDictionary *)params;

//球队详情---球队新闻
- (RACSignal *)QukanFetchTeamNewsWithParams:(NSDictionary *)params;

//球队详情---球员列表
- (RACSignal *)QukanFetchPlayerListInTeamWithParams:(NSDictionary *)params;

//球队详情---球队基本资料
- (RACSignal *)QukanFetchTeamBasicInfoWithParams:(NSDictionary *)params;

//球队详情---赛程
- (RACSignal *)QukanFetchTeamScheduleWithParams:(NSDictionary *)params;


//====================球员详情==========================
//球员详情---数据分项
- (RACSignal *)QukanFetchPlayerAnalysisSubDataWithParams:(NSDictionary *)params;

//球员详情---球员介绍——资料分项
- (RACSignal *)requestPlayerIntroduceInfoWithParams:(NSDictionary *)params;

//球员详情---转会记录
- (RACSignal *)requestPtrWithParams:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
