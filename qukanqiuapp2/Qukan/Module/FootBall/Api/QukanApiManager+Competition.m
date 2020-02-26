//
//  QukanApiManager+Competition.m
//  Qukan
//
//  Created by Kody on 2019/6/22.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanApiManager+Competition.h"

@implementation QukanApiManager (Competition)
- (RACSignal *)QukanStStatus {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"/parm/getMul" params:@{@"code":@"pconfig"} successBlock:^(id  _Nonnull result) {
            [subscriber sendNext:result];
            [subscriber sendCompleted];
        } failBlock:^(NSError * _Nonnull error) {
            [subscriber sendError:error];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            //[task cancel];
        }];
    }];
}
- (RACSignal *)QukanXuan {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"/v4/my/searchObj" params:@{} successBlock:^(id  _Nonnull result) {
            [subscriber sendNext:result];
            [subscriber sendCompleted];
        } failBlock:^(NSError * _Nonnull error) {
            [subscriber sendError:error];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
}


- (RACSignal *)QukanfindBfZqMatchAdWithType:(NSString *)type {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"bfZqMatchAd/findBfZqMatchAd" params:@{@"sendType":type?:@""} successBlock:^(id  _Nonnull result) {
            [subscriber sendNext:result];
            [subscriber sendCompleted];
        } failBlock:^(NSError * _Nonnull error) {
            [subscriber sendError:error];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
}


- (RACSignal *)QukanmatchInfosWithType:(NSString *)type andLeague_ids:(NSString *)league_ids addOffset_day:(NSString *)offset_day andAll:(NSNumber *)all addIshot:(NSString *)ishot{
    NSDictionary *parameters = @{@"type":type,
                                 @"league_ids":league_ids,
                                 @"all":all};
    if (offset_day != nil || [offset_day isEqualToString:@""]) {
        parameters = @{@"type":type,
                       @"league_ids":league_ids,
                       @"offset_day":offset_day,
                       @"all":all};
    }
    if ([ishot integerValue] == 1) {
        parameters = @{@"type":type,
                       @"all":all,
                       @"ishot":ishot};
    }
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"v3/bf-zq-match/infos" params:parameters successBlock:^(id  _Nonnull result) {
            [subscriber sendNext:result];
            [subscriber sendCompleted];
        } failBlock:^(NSError * _Nonnull error) {
            [subscriber sendError:error];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
}



- (RACSignal *)QukanmatchFindLeagueLabelWithLabelFlag:(NSString *)labelFlag andSendType:(NSString *)sendType addOffset_day:(NSString *)offset_day andLeague_ids:(NSString *)league_ids {
    NSDictionary *parameters = @{@"labelFlag":labelFlag,
                                 @"sendType":sendType,
                                 @"fixDays":offset_day,
                                 @"league_ids":league_ids};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"v3/bf-zq-match/find-league-label" params:parameters successBlock:^(id  _Nonnull result) {
            [subscriber sendNext:result];
            [subscriber sendCompleted];
        } failBlock:^(NSError * _Nonnull error) {
            [subscriber sendError:error];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
}


- (RACSignal *)QukanMatchFindAllByMatchIdWithMatchId:(NSString *)matchId  {
    NSDictionary *parameters = @{@"matchId":matchId};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"bfZqMatch/findAllByMatchId" params:parameters successBlock:^(id  _Nonnull result) {
            [subscriber sendNext:result];
            [subscriber sendCompleted];
        } failBlock:^(NSError * _Nonnull error) {
            [subscriber sendError:error];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
}

- (RACSignal *)QukanMatchFindLineupByMatchIdWithMatchId:(NSString *)matchId  {
    NSDictionary *parameters = @{@"matchId":matchId};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"bfZqMatch/findLineupByMatchId" params:parameters successBlock:^(id  _Nonnull result) {
            [subscriber sendNext:result];
            [subscriber sendCompleted];
        } failBlock:^(NSError * _Nonnull error) {
            [subscriber sendError:error];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
}

- (RACSignal *)QukanMatchFindTextLiveWithMatchId:(NSString *)matchId addTextLiveId:(NSString *)textliveid {
    NSDictionary *parameters = @{@"matchId":matchId,
                                 @"textliveId":textliveid};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"bfZqMatch/find-textlive" params:parameters successBlock:^(id  _Nonnull result) {
            [subscriber sendNext:result];
            [subscriber sendCompleted];
        } failBlock:^(NSError * _Nonnull error) {
            [subscriber sendError:error];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
}
- (RACSignal *)QukanFetchMachId:(NSString *)matchId {
    NSDictionary *parameters = @{@"matchId":matchId};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"/v3/bf-zq-match/php_ad" params:parameters successBlock:^(id  _Nonnull result) {
            [subscriber sendNext:result];
            [subscriber sendCompleted];
        } failBlock:^(NSError * _Nonnull error) {
            [subscriber sendError:error];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
}
- (RACSignal *)QukanmatchTeam_flagWithMatchId:(NSString *)matchId {
    NSDictionary *parameters = @{@"matchId":matchId};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"v3/bf-zq-match/team_flag" params:parameters successBlock:^(id  _Nonnull result) {
            [subscriber sendNext:result];
            [subscriber sendCompleted];
        } failBlock:^(NSError * _Nonnull error) {
            [subscriber sendError:error];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
}


- (RACSignal *)QukanAttention_Find_attention {
    NSDictionary *parameters = @{};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"BfZqAttention/find-attention" params:parameters successBlock:^(id  _Nonnull result) {
            [subscriber sendNext:result];
            [subscriber sendCompleted];
        } failBlock:^(NSError * _Nonnull error) {
            [subscriber sendError:error];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
}

- (RACSignal *)QukanAttention_AddWithMatchId:(NSString *)matchId {
    NSDictionary *parameters = @{@"matchId":matchId};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"BfZqAttention/add" params:parameters successBlock:^(id  _Nonnull result) {
            [subscriber sendNext:result];
            [subscriber sendCompleted];
        } failBlock:^(NSError * _Nonnull error) {
            [subscriber sendError:error];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
}

- (RACSignal *)QukanAttention_DelWithMatchId:(NSString *)matchId {
    NSDictionary *parameters = @{@"matchId":matchId};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"BfZqAttention/del" params:parameters successBlock:^(id  _Nonnull result) {
            [subscriber sendNext:result];
            [subscriber sendCompleted];
        } failBlock:^(NSError * _Nonnull error) {
            [subscriber sendError:error];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
}

- (RACSignal *)QukanWithMatchId:(NSString *)matchId {
    NSDictionary *parameters = @{@"matchId":matchId};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"v3/bf-zq-match/live_match" params:parameters successBlock:^(id  _Nonnull result) {
            [subscriber sendNext:result];
            [subscriber sendCompleted];
        } failBlock:^(NSError * _Nonnull error) {
            [subscriber sendError:error];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
}


#pragma mark ===================== 聊天室相关 ==================================

- (RACSignal *)Qukan_getTokenForType:(NSInteger)matchType matchId:(NSInteger)matchId {
    NSDictionary *parameters = @{@"sourceId":@(matchId), @"type": @(matchType)};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"v4/id/chatroom-token" params:parameters successBlock:^(id  _Nonnull result) {
            [subscriber sendNext:result];
            [subscriber sendCompleted];
        } failBlock:^(NSError * _Nonnull error) {
            [subscriber sendError:error];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
}

- (RACSignal *)Qukan_getListAddre:(NSString *)roomId andType:(NSInteger)type{
    NSDictionary *parameters = @{@"roomid": roomId?roomId:@"", @"type":@(type)};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"v4/chatroom/request-addr" params:parameters successBlock:^(id  _Nonnull result) {
            [subscriber sendNext:result];
            [subscriber sendCompleted];
        } failBlock:^(NSError * _Nonnull error) {
            [subscriber sendError:error];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
}


- (RACSignal *)Qukan_getDateTime {
    NSDictionary *parameters = @{};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"/v3/bf-zq-match/get-date-time" params:parameters successBlock:^(id  _Nonnull result) {
            [subscriber sendNext:result];
            [subscriber sendCompleted];
        } failBlock:^(NSError * _Nonnull error) {
            [subscriber sendError:error];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
}

/** 获取技术统计数据 */
- (RACSignal *)QukanGetMatchDetailJSTJDataWith:(NSInteger)leagueId season:(NSString *)season teamId:(NSInteger)teamId{
    NSDictionary *parameters = @{@"leagueId":@(leagueId),@"season":season,@"teamId":@(teamId)};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"/v5/zq/league/search-jifen-team" params:parameters successBlock:^(id  _Nonnull result) {
            [subscriber sendNext:result];
            [subscriber sendCompleted];
        } failBlock:^(NSError * _Nonnull error) {
            [subscriber sendError:error];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
}

/** 获取历史比赛记录 */
- (RACSignal *)QukanGetMatchDetailLSZJDataWithType:(NSInteger)type homeId:(NSInteger)homeId awayId:(NSInteger)awayId leagueId:(NSInteger)leagueId flagLeague:(NSInteger)flagLeague flagHA:(NSInteger)flagHA{
    NSDictionary *parameters = @{@"type":@(type),@"homeId":@(homeId),@"awayId":@(awayId),@"leagueId":@(leagueId),@"flagLeague":@(flagLeague),@"flagHA":@(flagHA)};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"/v5/zq/battle/selectBattleRecord" params:parameters successBlock:^(id  _Nonnull result) {
            [subscriber sendNext:result];
            [subscriber sendCompleted];
        } failBlock:^(NSError * _Nonnull error) {
            [subscriber sendError:error];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
}





@end
