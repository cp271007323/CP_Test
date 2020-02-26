//
//  QukanApiManager+Boiling.m
//  Qukan
//
//  Created by Kody on 2019/6/24.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanApiManager+Boiling.h"

@implementation QukanApiManager (Boiling)

- (RACSignal *)QukanLabel {
    NSDictionary *parameters = @{};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"v3/posts/topic/label" params:parameters successBlock:^(id  _Nonnull result) {
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


- (RACSignal *)QukanusersLikeWithModuleId:(NSNumber *)moduleId addOperation:(NSString *)operation {
    NSDictionary *parameters = @{@"moduleId":moduleId,
                                 @"operation":operation};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"v3/posts/users/like" params:parameters successBlock:^(id  _Nonnull result) {
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


- (RACSignal *)QukanListWithModuleId:(NSNumber *)Id addType:(NSNumber *)type addPageNo:(NSNumber *)pageNo addCountPerPage:(NSString *)countPerPage{
    NSDictionary *parameters = @{@"id":Id,
                                 @"type":type,
                                 @"pageNo":pageNo,
                                 @"countPerPage":countPerPage};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"v3/posts/topic/list" params:parameters successBlock:^(id  _Nonnull result) {
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


- (RACSignal *)QukankanGetDynamicsListUserId:(NSInteger)userId pageIndex:(NSInteger)index {
    NSDictionary *parameters = @{
                                 @"userId":@(userId),
                                 @"current":@(index),
                                 @"size":@(10)};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"v3/posts/topic/getDynamicsList" params:parameters successBlock:^(id  _Nonnull result) {
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

- (RACSignal *)QukanDynamicsWithType:(NSString *)type addPage_no:(NSNumber *)page_no addPage_size:(NSString *)page_size {
    NSDictionary *parameters = @{@"type":type,
                                 @"page_no":page_no,
                                 @"page_size":page_size};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
    NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"v3/posts/topic/dynamics" params:parameters successBlock:^(id  _Nonnull result) {
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


//- (RACSignal *)QukanpostsDelPostWithId:(NSNumber *)Id {
//    NSDictionary *parameters = @{@"id":Id};
//    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"v3/posts/del-post" params:parameters successBlock:^(id  _Nonnull result) {
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

- (RACSignal *)QukancommentsWithId:(NSInteger)Id addType:(NSString *)type addComment_content:(NSString *)text addReplyId:(NSNumber *_Nullable)replyId {
    NSDictionary *parameters = @{@"type":type,
                                 @"comment_content":text,
                                 @"replyId":replyId};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSString *urlStr = [NSString stringWithFormat:@"v3/comments/%ld",Id];
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:urlStr params:parameters successBlock:^(id  _Nonnull result) {
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

- (RACSignal *)QukanpostsWithContent:(NSString *)content addModuleId:(NSString *)moduleId addImageUrl:(NSString *)imageUrl {
    NSDictionary *parameters = @{@"content":content,
                                 @"moduleId":moduleId,
                                 @"image_url":imageUrl?:@""};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"v3/posts" params:parameters successBlock:^(id  _Nonnull result) {
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

- (RACSignal *)QukanClickPraiseWithId:(NSNumber *)Id addFlag:(NSString *)flag {
    NSDictionary *parameters = @{@"id":Id,
                                 @"flag":flag};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"v3/posts/topic/clickPraise" params:parameters successBlock:^(id  _Nonnull result) {
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

- (RACSignal *)QukanusersFollowWithToUserId:(NSNumber *)Id addOperation:(NSString *)operation {
    NSDictionary *parameters = @{@"toUserId":Id,
                                 @"operation":operation};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"v3/posts/users/follow" params:parameters successBlock:^(id  _Nonnull result) {
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



- (RACSignal *)QukancommentsLikeWithMid:(NSInteger)mid addInfoId:(NSInteger)infoid addFlag:(NSString *)flag {
    NSDictionary *parameters = @{@"m_id":[NSNumber numberWithInteger:mid],
                                 @"id":[NSNumber numberWithInteger:infoid],
                                 @"flag":flag};
    
    NSString *urlStr = [NSString stringWithFormat:@"v3/comments/%ld/%ld/like", mid,infoid];
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:urlStr params:parameters successBlock:^(id  _Nonnull result) {
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
