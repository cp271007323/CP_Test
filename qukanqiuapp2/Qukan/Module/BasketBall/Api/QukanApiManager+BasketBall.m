//
//  QukanApiManager+BasketBall.m
//  Qukan
//
//  Created by leo on 2019/9/3.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanApiManager+BasketBall.h"

@implementation QukanApiManager (BasketBall)

#pragma mark -查询热点比赛
- (RACSignal *)QukanHotList {
    NSDictionary *parameters = @{};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"btLqScore/selectPopular" params:parameters successBlock:^(id  _Nonnull result) {
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
#pragma mark -查询及时比赛
- (RACSignal *)QukanTimelyPKWithList:(NSString *)list xtype:(NSString *)xtype{
    NSDictionary *parameters = @{@"list":list,@"xtype":xtype};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"btLqScore/selectImmediate" params:parameters successBlock:^(id  _Nonnull result) {
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

#pragma mark -查询赛果表头
- (RACSignal *)QukanFormHeadPK {
    NSDictionary *parameters = @{};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"btLqScore/selectBtScore" params:parameters successBlock:^(id  _Nonnull result) {
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

#pragma mark -查询赛程表头
- (RACSignal *)QukanPKHead {
    NSDictionary *parameters = @{};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"btLqSchedule/selectBtSchedule" params:parameters successBlock:^(id  _Nonnull result) {
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

#pragma mark -查询赛果
- (RACSignal *)QukanFormPKWithTime:(NSString *)time xtype:(NSString *)xtype list:(NSString *)list{
    NSDictionary *parameters = @{@"time":time,@"xtype":xtype,@"list":list};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"btLqScore/selectScore" params:parameters successBlock:^(id  _Nonnull result) {
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


#pragma mark -查询赛程
- (RACSignal *)QukanPKWithTime:(NSString *)time xtype:(NSString *)xtype list:(NSString *)list{
    NSDictionary *parameters = @{@"time":time,@"xtype":xtype,@"list":list};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"btLqSchedule/selectScheduleData" params:parameters successBlock:^(id  _Nonnull result) {
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

#pragma mark -关注比赛
- (RACSignal *)QukanGuanZhuPKWithMatchId:(NSString *)matchId {
    NSDictionary *parameters = @{@"matchId":matchId};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"btAttention/attentionMatch" params:parameters successBlock:^(id  _Nonnull result) {
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

#pragma mark -取消关注比赛
- (RACSignal *)QukanQuXiaoPKWithMatchId:(NSString *)matchId {
    NSDictionary *parameters = @{@"matchId":matchId};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"btAttention/cancleAttention" params:parameters successBlock:^(id  _Nonnull result) {
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



#pragma mark -查询关注比赛
- (RACSignal *)QukanChaXunPKList {
    NSDictionary *parameters = @{};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"btAttention/selectAttention" params:parameters successBlock:^(id  _Nonnull result) {
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

#pragma mark -赛事全部筛选
- (RACSignal *)QukanAllShaiXuanWithTime:(NSString *)time ytype:(NSString *)ytype{
    NSDictionary *parameters = @{@"time":time,@"ytype":ytype};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"btLqScore/selectFilterAll" params:parameters successBlock:^(id  _Nonnull result) {
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

#pragma mark -赛事热门筛选
- (RACSignal *)QukanHotShaiXuanWithTime:(NSString *)time ytype:(NSString *)ytype{
    NSDictionary *parameters = @{@"time":time,@"ytype":ytype};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"btLqScore/selectFilterHot" params:parameters successBlock:^(id  _Nonnull result) {
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

#pragma mark -赛事全部筛选
//xtype：1-全部， 2-热门（NBA），3-
//ytype：1-即时， 2-赛程， 3-赛果
- (RACSignal *)QukanBaoCunShaiXuanWithTime:(NSString *)time ytype:(NSString *)ytype xtype:(NSString *)xtype list:(NSString *)list {
    NSDictionary *parameters = @{@"time":time,@"ytype":ytype,@"xtype":xtype,@"list":list};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"btLqScore/selectFilterHot" params:parameters successBlock:^(id  _Nonnull result) {
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

#pragma mark -查询App描述文案
- (RACSignal *)QukanGoodContent {
    NSDictionary *parameters = @{};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"v4/comment/comment-describe" params:parameters successBlock:^(id  _Nonnull result) {
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

#pragma mark -
- (RACSignal *)QukanGoodPhotoFile:(NSString *)photoFile{
    NSDictionary *parameters = @{@"photoFile":photoFile};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"v4/comment/uploadCommentImg" params:parameters successBlock:^(id  _Nonnull result) {
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

#pragma mark -查询赛事详情
- (RACSignal *)QukanQueryMatchInfoWithMatchId:(NSString *)matchId{
    NSDictionary *parameters = @{@"matchId":matchId};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"btTeahnicCount/selectDetails" params:parameters successBlock:^(id  _Nonnull result) {
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

- (RACSignal *)QukanFetchAnimationLiveWithMatchId:(NSString *)matchId {
    NSDictionary *parameters = @{@"matchId":matchId};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task = [kApiManager postRequestWithUrl:@"btAnimation/selectAnimation" params:parameters successBlock:^(id  _Nonnull result) {
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
- (RACSignal *)QukanSelectMatchLiveWithMatchId:(NSString *)matchId {
    NSDictionary *parameters = @{@"matchId":matchId};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task = [kApiManager postRequestWithUrl:@"btLqScore/selectMatchLive" params:parameters successBlock:^(id  _Nonnull result) {
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


//
- (RACSignal *)QukanGetMatchTeamHistoryData:(NSString *)matchId {
    NSDictionary *parameters = @{@"matchId":matchId};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task = [kApiManager postRequestWithUrl:@"/btLqRank/selectTeamEngagement" params:parameters successBlock:^(id  _Nonnull result) {
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

#pragma mark ===================== 文字zb ==================================
- (RACSignal *)QukanGetTextLiveWithMatchId:(NSString *)MatchId pageStart:(NSInteger )pageStart status:(NSString *)status pageSize:(NSInteger)pageSize {
    NSDictionary *parameters = @{@"matchId":MatchId,@"pageStart":@(pageStart),@"status":status,@"pageSize":@(pageSize)};
    
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"btLqText/selectBtText" params:parameters successBlock:^(id  _Nonnull result) {
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
