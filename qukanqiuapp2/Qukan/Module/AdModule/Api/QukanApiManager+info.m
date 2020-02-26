//
//  QukanApiManager+Ad.m
//  Qukan
//
//  Created by Kody on 2019/8/9.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanApiManager+info.h"

@implementation QukanApiManager (info)

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

- (RACSignal *)QukanInfoWithType:(NSInteger )type withid:(NSInteger)Id {
    NSDictionary *parameters = @{@"ad_type":@(type),
                                 @"img_id":@(Id)};
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



- (RACSignal *)QukansearchInfoWithType:(NSString *)type {
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


@end
