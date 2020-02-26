//
//  QukanApiManager+PersonCenter.m
//  Qukan
//
//  Created by Kody on 2019/8/17.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanApiManager+PersonCenter.h"

@implementation QukanApiManager (PersonCenter)

- (RACSignal *)QukanGetInfoList {
    NSDictionary *parameters = @{@"code":kGetImageType(13)};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"parm/getSig" params:parameters successBlock:^(id  _Nonnull result) {
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

- (RACSignal *)QukanCustDialogCreate {
    NSDictionary *parameters = @{};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"v4/cust/dialog/create" params:parameters successBlock:^(id  _Nonnull result) {
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

- (RACSignal *)QukanCodeCreateQR:(NSString *)openAppId {
    NSDictionary *parameters = @{};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"code/createQR" params:parameters successBlock:^(id  _Nonnull result) {
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

- (RACSignal *)QukanCodeCreateYRWithUserId:(NSString *)userId {
    NSDictionary *parameters = @{@"id":userId};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"code/createYQ" params:parameters successBlock:^(id  _Nonnull result) {
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


- (RACSignal *)QukanGcUserSelectTpList {
    NSDictionary *parameters = @{};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSString *path = FormatString(@"%@/selectTpList", kGetImageType(2));
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:path params:parameters successBlock:^(id  _Nonnull result) {
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


- (RACSignal *)QukanGcUserCollectionQuery {
    NSDictionary *parameters = @{};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSString *path = FormatString(@"%@/user/query", kGetImageType(21));
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:path params:parameters successBlock:^(id  _Nonnull result) {
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


- (RACSignal *)QukanGcUserbingWithOpenId:(NSString *)openId unionId:(NSString *)unionId nickName:(NSString *)nickName accessToken:(NSString *)accessToken{
    NSDictionary *parameters = @{@"openId":openId,@"accessToken":accessToken,@"unionId":unionId,@"nickName":nickName};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSString *path = FormatString(@"%@/user/bing", kGetImageType(21));
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:path params:parameters successBlock:^(id  _Nonnull result) {
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

- (RACSignal *)QukanSelectDate{
    NSDictionary *parameters = @{};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSString *path = FormatString(@"%@/selectScoreRed", kGetImageType(2));
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:path params:parameters successBlock:^(id  _Nonnull result) {
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


- (RACSignal *)QukanSelectTpTime {
    NSDictionary *parameters = @{};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSString *path = FormatString(@"%@/selectTpTime", kGetImageType(2));
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:path params:parameters successBlock:^(id  _Nonnull result) {
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

- (RACSignal *)QukanGcUserSelectParmList {
    NSDictionary *parameters = @{};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"gcUserBadge/selectParmList" params:parameters successBlock:^(id  _Nonnull result) {
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

- (RACSignal *)QukanGcUserDlWithCode:(NSString *)code {
    NSDictionary *parameters = @{@"code":code};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"gcUserBadge/badgeDl" params:parameters successBlock:^(id  _Nonnull result) {
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

- (RACSignal *)QukanGcUserDataWithCode:(NSString *)code {
    NSDictionary *parameters = @{@"code":code};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"gcUserBadge/badgePd" params:parameters successBlock:^(id  _Nonnull result) {
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

- (RACSignal *)QukanGetInfoWithCode:(NSString *)code{
    NSDictionary *parameters = @{@"code":code};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSString *path = FormatString(@"%@/%@TpScore", kGetImageType(2), kGetImageType(11));
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:path params:parameters successBlock:^(id  _Nonnull result) {
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



- (RACSignal *)QukanGcUserHeadImage {
    NSDictionary *parameters = @{};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"gcUserBadge/selectBadge" params:parameters successBlock:^(id  _Nonnull result) {
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

- (RACSignal *)QukanAddTodayTime:(NSString *)todayTimeStr WithMatchId:(long)matchId {
    NSDictionary *parameters = @{@"todayGTime":todayTimeStr,
                                 @"sourceId":@(matchId)};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSString *path = FormatString(@"%@/addTodayGTime", kGetImageType(2));
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:path params:parameters successBlock:^(id  _Nonnull result) {
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

- (RACSignal *)QukanSportQuery {
    NSDictionary *parameters = @{};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSString *path = kGetImageType(5);
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:path params:parameters successBlock:^(id  _Nonnull result) {
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

- (RACSignal *)QukanUserReadAddWithSourceId:(long)sourceId WithSourceType:(NSInteger)sourceType WithStopTime:(long)stopTime {
    NSDictionary *parameters = [NSDictionary dictionary];
    if (stopTime != 0) {
        parameters = @{@"sourceId":@(sourceId),
                       @"sourceType":@(sourceType),
                       @"stopTime":@(stopTime),};
    } else {
        parameters = @{@"sourceId":@(sourceId),
                       @"sourceType":@(sourceType)};
    }
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"user/read/add" params:parameters successBlock:^(id  _Nonnull result) {
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


- (RACSignal *)QukanUserShareAddWithSourceId:(long)sourceId WithSourceType:(NSInteger)sourceType {
    NSDictionary *parameters =  @{@"sourceId":@(sourceId),
                                  @"sourceType":@(sourceType)};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"user/share/add" params:parameters successBlock:^(id  _Nonnull result) {
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

- (RACSignal *)QukanGcUserReadList:(double)today WithRecordId:(long)recordId {
    NSDictionary *parameters =  @{@"todayRed":@(today),
                                  @"taskRecordId":@(recordId)};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSString *path = FormatString(@"%@/addTodayRed", kGetImageType(2));
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:path params:parameters successBlock:^(id  _Nonnull result) {
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


- (RACSignal *)QukanFocusNum:(NSString *)num WithRecordId:(long)recordId; {
    NSDictionary *parameters =  @{@"todayScore":num,
                                  @"taskRecordId":@(recordId)};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSString *path = FormatString(@"%@/addTodayScore", kGetImageType(2));
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:path params:parameters successBlock:^(id  _Nonnull result) {
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

-(RACSignal *)QukanUserReads:(NSString *)red{
    NSDictionary *parameters =  @{@"red":red};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSString *path = FormatString(@"%@/%@Red", kGetImageType(2), kGetImageType(11));
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:path params:parameters successBlock:^(id  _Nonnull result) {
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


- (RACSignal *)QukanGcUserNoticeSelectNoticeWithCursor:(NSString *)cursor WithPagingSize:(NSInteger)pagingSize {
    NSDictionary *parameters =  @{@"cursor":cursor,
                                  @"pagingSize":@(pagingSize)};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"gcUserNotice/selectAllNotice" params:parameters successBlock:^(id  _Nonnull result) {
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

- (RACSignal *)QukanGcUserNoticeSselectCount {
    NSDictionary *parameters =  @{};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"gcUserNotice/selectCount" params:parameters successBlock:^(id  _Nonnull result) {
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


- (RACSignal *)QukangcuserData:(NSString *)val {
    NSDictionary *parameters = @{@"Val":val};
    
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSString *path = FormatString(@"/v4/my/%@", kGetImageType(1));
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:path params:parameters successBlock:^(id  _Nonnull result) {
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

- (RACSignal *)QukanreadListWithCurrent:(NSInteger)current size:(NSInteger)size {
    NSDictionary *parameters = @{@"current":@(current),@"size":@(size)};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSString *path = FormatString(@"%@/record/query", kGetImageType(3));
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:path params:parameters successBlock:^(id  _Nonnull result) {
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

//- (RACSignal *)QukanShow {
//    NSDictionary *parameters = @{};
//    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"/v4/my/inviteDownload" params:parameters successBlock:^(id  _Nonnull result) {
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

- (RACSignal *)QukanAppGetConfig {
    NSDictionary *parameters = @{};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"/app/get-config" params:parameters successBlock:^(id  _Nonnull result) {
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

- (RACSignal *)QukanGetSig {
    NSDictionary *parameters = @{@"code":@"txgz"};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"/parm/getSig" params:parameters successBlock:^(id  _Nonnull result) {
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
