//
//  QukanApiManager+QukanDataBSK.m
//  Qukan
//
//  Created by blank on 2019/12/27.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanApiManager+QukanDataBSK.h"
//#import "QukanDataBSKApiUrl.h"
@implementation QukanApiManager (QukanDataBSK)
//- (RACSignal *)requestWithUrl:(NSString *)url params:(NSDictionary *)dic {
//    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:url params:dic successBlock:^(id  _Nonnull result) {
//            [subscriber sendNext:result];
//            [subscriber sendCompleted];
//        } failBlock:^(NSError * _Nonnull error) {
//            [subscriber sendError:error];
//        }];
//        
//        return [RACDisposable disposableWithBlock:^{
//            [task cancel];
//        }];
//    }];
//}

- (RACSignal *)QukanSelectBtSclassHot {
//    return [self requestWithUrl:DataBSK_leaguesUrl params:nil];
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"btLqSclass/selectBtSclassHot" params:nil successBlock:^(id  _Nonnull result) {
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
- (RACSignal *)QukanSelectKindWith:(NSString *)sclassId season:(NSString *)season {
//    return [self requestWithUrl:DataBSK_eventTypeUrl params:@{@"sclassId":sclassId,@"season":season}];
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"btLqSchedule/selectKind" params:@{@"sclassId":sclassId,@"season":season} successBlock:^(id  _Nonnull result) {
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
- (RACSignal *)QukanSelectMonthsWith:(NSString *)sclassId season:(NSString *)season matchKind:(NSString *)matchKind {
//    return [self requestWithUrl:DataBSK_selectMonthUrl params:@{@"sclassId":sclassId,@"season":season,@"matchKind":matchKind}];
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"btLqSchedule/selectMonth" params:@{@"sclassId":sclassId,@"season":season,@"matchKind":matchKind} successBlock:^(id  _Nonnull result) {
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
- (RACSignal *)QukanSelectSclassList {
//    return [self requestWithUrl:DataBSK_countriesAndLeaguesUrl params:nil];
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"btLqSclass/selectSclassList" params:nil successBlock:^(id  _Nonnull result) {
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
- (RACSignal *)QukanSelectScheduleWith:(NSString *)sclassId season:(NSString *)season matchKind:(NSString *)matchKind month:(NSString *)month{
//    return [self requestWithUrl:DataBSK_selectScheduleUrl params:@{@"sclassId":sclassId,@"season":season,@"matchKind":matchKind,@"month":month}];
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"btLqSchedule/selectBtScheduleData" params:@{@"sclassId":sclassId,@"season":season,@"matchKind":matchKind,@"month":month} successBlock:^(id  _Nonnull result) {
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
- (RACSignal *)QukanSelectAllianceWith:(NSString *)sclassId {
//    return [self requestWithUrl:DataBSK_allianceUrl params:@{@"sclassId":sclassId}];
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"btLqTeam/selectAlliance" params:@{@"sclassId":sclassId} successBlock:^(id  _Nonnull result) {
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
- (RACSignal *)QukanSelectBtRankWith:(NSString *)sclassId season:(NSString *)season allianceId:(NSString *)allianceId {
//    return [self requestWithUrl:DataBSK_selectBtRankUrl params:@{@"sclassId":sclassId,@"season":season,@"allianceId":allianceId}];
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"btLqRank/selectBtRank" params:@{@"sclassId":sclassId,@"season":season,@"allianceId":allianceId} successBlock:^(id  _Nonnull result) {
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
- (RACSignal *)QukanSelectTeamDetailWith:(NSString *)teamId {
//    return [self requestWithUrl:DataBSK_selectTeamDetailUrl params:@{@"teamId":teamId}];
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"btLqTeam/selectTeamDetail" params:@{@"teamId":teamId} successBlock:^(id  _Nonnull result) {
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
- (RACSignal *)QukanSelectPlayerDetailWith:(NSString *)playerId {
//    return [self requestWithUrl:DataBSK_selectPlayerDetailUrl params:@{@"playerId":playerId}];
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"btLqPlayer/selectPlayerDetail" params:@{@"playerId":playerId} successBlock:^(id  _Nonnull result) {
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
- (RACSignal *)QukanSelectScheduleTeamWith:(NSString *)teamId {
//    return [self requestWithUrl:DataBSK_selectScheduleTeamUrl params:@{@"teamId":teamId}];
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"btLqSchedule/selectScheduleTeam" params:@{@"teamId":teamId} successBlock:^(id  _Nonnull result) {
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
- (RACSignal *)QukanSelectSclassSeasonWith:(NSString *)sclassId {
//    return [self requestWithUrl:DataBSK_selectSclassSeasonUrl params:@{@"sclassId":sclassId}];
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"btLqSclass/selectSclassSeason" params:@{@"sclassId":sclassId} successBlock:^(id  _Nonnull result) {
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
- (RACSignal *)QukanAttentionTeamMatchWith:(NSArray *)matchIds teamId:(NSString *)teamId{
//    return [self requestWithUrl:DataBSK_attentionTeamMatchUrl params:@{@"matchIds":matchIds,@"teamId":teamId}];
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"btAttention/attentionTeamMatch" params:@{@"matchIds":matchIds,@"teamId":teamId} successBlock:^(id  _Nonnull result) {
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
- (RACSignal *)QukanCancleAttentionTeamMatchWith:(NSArray *)matchIds teamId:(NSString *)teamId{
//    return [self requestWithUrl:DataBSK_cancleAttentionTeamMatchUrl params:@{@"matchIds":matchIds,@"teamId":teamId}];
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"btAttention/cancleAttentionTeamMatch" params:@{@"matchIds":matchIds,@"teamId":teamId} successBlock:^(id  _Nonnull result) {
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
- (RACSignal *)QukanSelectAttentionTeamStatusWithTeamId:(NSString *)teamId {
//    return [self requestWithUrl:DataBSK_selectAttentionTeamStatusUrl params:@{@"teamId":teamId}];
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"btAttention/selectAttentionTeamStatus" params:@{@"teamId":teamId} successBlock:^(id  _Nonnull result) {
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
