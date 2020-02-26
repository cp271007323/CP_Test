//
//  QukanApiManager+News.m
//  Qukan
//
//  Created by pfc on 2019/7/17.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanApiManager+News.h"
#import "QukanNewsModel.h"
#import "QukanNewsChannelModel.h"
#import "QukanBNewsModel.h"

@implementation QukanApiManager (News)

- (RACSignal *)QukanacquireNewsChannels {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"v4/news/channel-list"
                                                               params:nil
                                                         successBlock:^(NSDictionary *  _Nonnull result) {
                                                             
                                                             NSArray *datas = [NSArray modelArrayWithClass:[QukanNewsChannelModel class] json:result];
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

- (RACSignal *)QukanacquireNewsListWithLeagueId:(NSInteger)leagueId Page:(NSInteger)page pageSize:(NSInteger)pageSize {
    NSDictionary *params = @{@"leagueId": @(leagueId), @"size":@(pageSize), @"current": @(page)};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"v4/news/index"
                                                               params:params
                                                         successBlock:^(NSDictionary *  _Nonnull result) {
                                                             
            NSArray *datas = [NSArray modelArrayWithClass:[QukanNewsModel class] json:result[@"records"]];
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

- (RACSignal *)QukannewsReadNumWithNewsId:(NSString *)newsId {
    NSDictionary *parameters = @{@"newsId":newsId};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"v4/news/read-num" params:parameters successBlock:^(id  _Nonnull result) {
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


- (RACSignal *)QukancommentSearchWithsourceId:(NSInteger)sourceId addsourceType:(NSInteger)sourceType addSortType:(NSInteger)sortType addcurrent:(NSInteger)current addsize:(NSInteger)size {
    NSDictionary *parameters = @{@"sourceId":@(sourceId),
                                 @"sourceType":@(sourceType),
                                 @"sortType":@(sortType),
                                 @"current":@(current),
                                 @"size":@(size)};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"v4/comment/search" params:parameters successBlock:^(id  _Nonnull result) {
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
            
            
- (RACSignal *)QukannewsBannerData:(NSInteger)channelId {
    NSDictionary *parameters = @{@"advType": @(channelId)};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"v4/newsChannel/queryHomepageAdvertisement" params:parameters successBlock:^(id  _Nonnull result) {
            NSInteger flag = [result intValueForKey:@"flag" default:0];
            QukanBNewsModel *model = [QukanBNewsModel new];
            model.flag = flag;
            if (flag == 2) {
                model.news = [NSArray modelArrayWithClass:[QukanNewsModel class] json:result[@"datas"]];
            }else {
                model.bas = [NSArray modelArrayWithClass:[QukanNewInfoModel class] json:result[@"datas"]];
            }
            [subscriber sendNext:model];
            [subscriber sendCompleted];
        } failBlock:^(NSError * _Nonnull error) {
            [subscriber sendError:error];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
}

- (RACSignal *)QukancommentAddWithsourceId:(NSInteger)sourceId addsourceType:(NSInteger)sourceType addCommentContent:(NSString *)commentContent {
    NSDictionary *parameters = @{@"sourceId":@(sourceId),
                                 @"sourceType":@(sourceType),
                                 @"commentContent":commentContent};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"v4/comment/add" params:parameters successBlock:^(id  _Nonnull result) {
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

- (RACSignal *)QukancommentSwitchWithCommentId:(NSInteger)commentId addType:(NSInteger)type  {
    NSDictionary *parameters = @{@"commentId":@(commentId),
                                 @"type":@(type)};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"v4/comment/like/switch" params:parameters successBlock:^(id  _Nonnull result) {
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

- (RACSignal *)QukancommentSearchCountWithSourceId:(NSInteger)sourceId addSourceType:(NSInteger)sourceType  {
    NSDictionary *parameters = @{@"sourceId":@(sourceId),
                                 @"sourceType":@(sourceType)};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"v4/comment/search-count" params:parameters successBlock:^(id  _Nonnull result) {
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

- (RACSignal *)QukannewsSwitchLikeWithNewsId:(NSInteger)newsId addType:(NSInteger)type  {
    NSDictionary *parameters = @{@"newsId":@(newsId),
                                 @"type":@(type)};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"v4/news/switch-like" params:parameters successBlock:^(id  _Nonnull result) {
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


//- (RACSignal *)QukanParmGetSig {
//    NSDictionary *parameters = @{@"code":@"share_domain_name"};
//    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"/parm/getSig" params:parameters successBlock:^(id  _Nonnull result) {
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


- (RACSignal *)QukanSearchWithKeyword:(NSString *)keyword current:(NSInteger)current {
    NSDictionary *parameters = @{@"current":@(current),@"size":@(10),@"keyword":keyword};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"/v4/news/searchNews" params:parameters successBlock:^(id  _Nonnull result) {
            NSArray *datas = [NSArray modelArrayWithClass:[QukanNewsModel class] json:result[@"records"]];
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

- (RACSignal *)QukanSearchHot {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"/v4/news/selectHotNews" params:nil successBlock:^(id  _Nonnull result) {
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
