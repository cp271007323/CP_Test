//
//  QukanApiManager+QukanChatApi.m
//  Qukan
//
//  Created by pfc on 2019/8/15.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanApiManager+QukanChatApi.h"


@implementation QukanApiManager (QukanChatApi)

- (RACSignal *)QukanacquireIMAccount {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"/v4/cust/dialog/create_new"
                                                               params:nil
                                                         successBlock:^(NSDictionary *  _Nonnull result) {
                                                             QukanIMAcount *imAccount = [QukanIMAcount modelWithJSON:result];
                                                             [subscriber sendNext:imAccount];
                                                             [subscriber sendCompleted];
                                                         } failBlock:^(NSError * _Nonnull error) {
                                                             [subscriber sendError:error];
                                                         }];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
}




- (RACSignal *)QukanacquireUserIMAccount:(NSInteger)userId {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSMutableDictionary* params = [NSMutableDictionary dictionary];
        [params setObject:@(userId) forKey:@"userId"];
        
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"v4/send/selectUser"
                                                               params:params
                                                         successBlock:^(NSDictionary *  _Nonnull result) {
                                                             QukanIMAcount *imAccount = [QukanIMAcount modelWithJSON:result];
                                                             [subscriber sendNext:imAccount];
                                                             [subscriber sendCompleted];
                                                         } failBlock:^(NSError * _Nonnull error) {
                                                             [subscriber sendError:error];
                                                         }];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
}
- (RACSignal *)hasSendMessageToCustomerServiceSuccess{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"v4/cust/dialog/dialog_send"
                                                               params:nil
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

- (RACSignal *)QukanChatFriends {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"/chat/friend/query" params:nil successBlock:^(id  _Nonnull result) {
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
