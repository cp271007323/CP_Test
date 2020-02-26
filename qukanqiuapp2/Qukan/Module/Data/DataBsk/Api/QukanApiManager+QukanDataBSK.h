//
//  QukanApiManager+QukanDataBSK.h
//  Qukan
//
//  Created by blank on 2019/12/27.
//  Copyright © 2019 mac. All rights reserved.
//


#import "QukanApiManager.h"
NS_ASSUME_NONNULL_BEGIN
@interface QukanApiManager (QukanDataBSK)
//查询联赛名
- (RACSignal *)QukanSelectBtSclassHot;
//查询赛程赛事类型
- (RACSignal *)QukanSelectKindWith:(NSString *)sclassId season:(NSString *)season;
//查询国家,球队
- (RACSignal *)QukanSelectSclassList;
//查询赛程月份
- (RACSignal *)QukanSelectMonthsWith:(NSString *)sclassId season:(NSString *)season matchKind:(NSString *)matchKind;
//查询赛程
- (RACSignal *)QukanSelectScheduleWith:(NSString *)sclassId season:(NSString *)season matchKind:(NSString *)matchKind month:(NSString *)month;
//查询联盟信息
- (RACSignal *)QukanSelectAllianceWith:(NSString *)sclassId;
//查询排名
- (RACSignal *)QukanSelectBtRankWith:(NSString *)sclassId season:(NSString *)season allianceId:(NSString *)allianceId;
//查询球队详情
- (RACSignal *)QukanSelectTeamDetailWith:(NSString *)teamId;
//查询球员详情
- (RACSignal *)QukanSelectPlayerDetailWith:(NSString *)playerId;
//根据球队查赛程
- (RACSignal *)QukanSelectScheduleTeamWith:(NSString *)teamId;
//查询赛事赛季列表
- (RACSignal *)QukanSelectSclassSeasonWith:(NSString *)sclassId;
//关注球队
- (RACSignal *)QukanAttentionTeamMatchWith:(NSArray *)matchIds teamId:(NSString *)teamId;
//取消关注球队
- (RACSignal *)QukanCancleAttentionTeamMatchWith:(NSArray *)matchIds teamId:(NSString *)teamId;
//取消关注球队
- (RACSignal *)QukanSelectAttentionTeamStatusWithTeamId:(NSString *)teamId;
@end

NS_ASSUME_NONNULL_END
