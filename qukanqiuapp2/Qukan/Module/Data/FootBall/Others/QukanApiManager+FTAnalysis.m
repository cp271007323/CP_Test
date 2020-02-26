//
//  QukanApiManager+FTAnalysis.m
//  Qukan
//
//  Created by Charlie on 2019/12/26.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanApiManager+FTAnalysis.h"
#import "QukanLeagueInfoModel.h"
#import "QukanTeamScoreModel.h"


@implementation QukanApiManager (FTAnalysis)

- (RACSignal *)QukanFetchLeagueInfoByAreaId:(NSNumber*)areaId{
    NSDictionary* params = @{@"areaId":areaId};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"v5/zq/league/search"
                                                               params:params
                                                         successBlock:^(NSDictionary *  _Nonnull result) {
                                                             NSArray *datas = [NSArray modelArrayWithClass:[QukanLeagueInfoModel class] json:result];
                                                             [subscriber sendNext:datas];
                                                             [subscriber sendCompleted];
                                                         } failBlock:^(NSError * _Nonnull error) {
                                                             [subscriber sendError:error];
                                                         }];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
}

- (RACSignal *)QukanFetchTeamLeagueRankInfoWithParams:(NSDictionary *)params{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"v5/zq/league/search-jifen"
                                                               params:params
                                                         successBlock:^(NSDictionary *  _Nonnull result) {
                                                             NSArray *datas = [NSArray modelArrayWithClass:[QukanTeamScoreModel class] json:result];
                                                             [subscriber sendNext:datas];
                                                             [subscriber sendCompleted];
                                                         } failBlock:^(NSError * _Nonnull error) {
                                                             [subscriber sendError:error];
                                                         }];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
}

- (RACSignal *)QukanFetchTeamCupRankInfoWithParams:(NSDictionary *)params{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"v5/zq/league/search-jifen-cup"
                                                               params:params
                                                         successBlock:^(NSDictionary *  _Nonnull result) {
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



- (RACSignal *)QukanFetchPlayerRankInfoWithParams:(NSDictionary *)params{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"v5/zq/team/selectPlayerGoals"
                                                               params:params
                                                         successBlock:^(NSDictionary *  _Nonnull result) {
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


- (RACSignal *)QukanFetchMatchRoundListWithParams:(NSDictionary *)params{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"v5/zq/team/selectRoundNum"
                                                               params:params
                                                         successBlock:^(NSDictionary *  _Nonnull result) {
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

- (RACSignal *)QukanFetchScheduleInfoWithParams:(NSDictionary *)params{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"v5/zq/team/findAllMatchSc"
                                                               params:params
                                                         successBlock:^(NSDictionary *  _Nonnull result) {
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

//====================球队详情==========================
//球队详情---球员列表
- (RACSignal *)QukanFetchPlayerListInTeamWithParams:(NSDictionary *)params{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"v5/zq/team/selectTeamPlayer"
                                                               params:params
                                                         successBlock:^(NSDictionary *  _Nonnull result) {
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

//球队详情---球队新闻
- (RACSignal *)QukanFetchTeamNewsWithParams:(NSDictionary *)params{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"v5/zq/team/indexTeam"
                                                               params:params
                                                         successBlock:^(NSDictionary *  _Nonnull result) {
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

//球队详情---球队基本资料
- (RACSignal *)QukanFetchTeamBasicInfoWithParams:(NSDictionary *)params{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"v5/zq/team/selectTeamInfo"
                                                               params:params
                                                         successBlock:^(NSDictionary *  _Nonnull result) {
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



//球队详情---赛程
- (RACSignal *)QukanFetchTeamScheduleWithParams:(NSDictionary *)params{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"v5/zq/team/findAllMatchSc"
                                                               params:params
                                                         successBlock:^(NSDictionary *  _Nonnull result) {
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

/**关注球队*/
- (RACSignal *)QukanFollowFTTeamWithParams:(NSDictionary *)params{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"v5/attention/team/addAttentionTeam"
                                                               params:params
                                                         successBlock:^(NSDictionary *  _Nonnull result) {
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


/**取消关注*/
- (RACSignal *)QukanUnFollowFTTeamWithParams:(NSDictionary *)params{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"v5/attention/team/deleteAttentionTeam"
                                                               params:params
                                                         successBlock:^(NSDictionary *  _Nonnull result) {
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

//====================球员详情==========================

//球队详情---最近战绩
- (RACSignal *)QukanFetchTeamRecentRecordWithParams:(NSDictionary *)params{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"v5/zq/league/search-jifen-sort"
                                                               params:params
                                                         successBlock:^(NSDictionary *  _Nonnull result) {
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


//球员详情---数据分项
- (RACSignal *)QukanFetchPlayerAnalysisSubDataWithParams:(NSDictionary *)params{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"v5/zq/team/selectPlayerData"
                                                               params:params
                                                         successBlock:^(NSDictionary *  _Nonnull result) {
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

//球员详情---介绍-资料分项
- (RACSignal *)requestPlayerIntroduceInfoWithParams:(NSDictionary *)params{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"v5/zq/team/selectTeamPlayer"
                                                               params:params
                                                         successBlock:^(NSDictionary *  _Nonnull result) {
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

- (RACSignal *)requestPtrWithParams:(NSDictionary *)params{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"v5/zq/team/selectZqTransfer"
                                                               params:params
                                                         successBlock:^(NSDictionary *  _Nonnull result) {
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

- (RACSignal *)QukanInfoWithType:(NSInteger)type {
    NSDictionary *parameters = @{@"ad_type":@(type)};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager adPostRequestWithUrl:@"" params:parameters successBlock:^(id  _Nonnull result) {
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
