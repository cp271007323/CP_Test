//
//  QukanApiManager+Mine.m
//  Qukan
//
//  Created by pfc on 2019/6/20.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanApiManager+Mine.h"

@implementation QukanApiManager (Mine)

- (RACSignal *)QukanloginWithAccount:(NSString *)account andPassword:(NSString *)password {
    NSDictionary *parameters = @{@"mark":@"2",
                                 @"tel":account,
                                 @"password":password};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"gcuser/login" params:parameters successBlock:^(id  _Nonnull result) {
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

/** 根据id查看个人信息 */
- (RACSignal *)QukangcuserFindUserById:(NSString *)userId {
    //    NSDictionary *parameters = @{@"id":userId};
    NSDictionary *parameters = @{};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"gcuser/findUserById" params:parameters successBlock:^(id  _Nonnull result) {
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

- (RACSignal *)QukansearchFocusInfo {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"BfZqAttention/get-attention-count" params:nil successBlock:^(id  _Nonnull result) {
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



- (RACSignal *)QukangcUserFeedbackAddWithContent:(NSString *)content addcontact:(NSString *)contact addImageUrl:(NSString *)imageurl {
    NSDictionary *parameters = @{@"content":content,
                                 @"contact":contact,
                                 @"imgurl":imageurl};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"gcUserFeedback/add" params:parameters successBlock:^(id  _Nonnull result) {
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


- (RACSignal *)QukangcuserRegisterWithTel:(NSString *)tel addCode:(NSString *)code addPassword:(NSString *)password addInvitationCode:(NSString *)invitationCode{
    NSDictionary *parameters;
    if (invitationCode.length == 0) {
        parameters = @{@"tel":tel,
                       @"code":code,
                       @"password":password};
    } else {
        parameters = @{@"tel":tel,
                       @"code":code,
                       @"password":password,
                       @"invitationCode":invitationCode};
    }
    
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"gcuser/register" params:parameters successBlock:^(id  _Nonnull result) {
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


- (RACSignal *)QukansmsSendCodeWithMobile:(NSString *)mobile addCode:(NSString *)code {
    
    NSDictionary *parameters = @{@"countryCallingCode":code,
                                 @"mobile":mobile};
    
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"sms/sendCode" params:parameters successBlock:^(id  _Nonnull result) {
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


- (RACSignal *)QukangcuserForgetPassWithTel:(NSString *)tel addCode:(NSString *)code  addPassword:(NSString *)password {
    NSDictionary *parameters = @{@"tel":tel,
                                 @"code":code,
                                 @"password":password};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"gcuser/forgetPass" params:parameters successBlock:^(id  _Nonnull result) {
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

- (RACSignal *)QukangcuserUpdateWithNickname:(NSString *)nickname {
    NSDictionary *parameters = @{@"nickname":nickname};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"gcuser/update" params:parameters successBlock:^(id  _Nonnull result) {
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

- (RACSignal *)QukangcuserEditPassWithPassword:(NSString *)password addOpassword:(NSString *)opassword {
    NSDictionary *parameters = @{@"password":password,
                                 @"opassword":opassword};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"gcuser/editPass" params:parameters successBlock:^(id  _Nonnull result) {
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


- (RACSignal *)QukangcuserBindWithTel:(NSString *)tel addCode:(NSString *)code addThirdId:(NSString *)thirdId {
    NSDictionary *parameters = @{@"tel":tel,
                                 @"code":code,
                                 @"thirdId":thirdId?:@""};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"gcuser/bind" params:parameters successBlock:^(id  _Nonnull result) {
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

- (RACSignal *)QukanMyFollow {
    NSDictionary *parameters = @{};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"v4/my/follow" params:parameters successBlock:^(id  _Nonnull result) {
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


- (RACSignal *)QukanUserWithId:(NSString *)thirdFlag addOpenId:(NSString *)openId addUnionid:(NSString *)unionid addNickname:(NSString *)nickname addHeadimgUrl:(NSString *)headimgUrl addAccessToken:(NSString *)accessToken addInvitationCode:(NSString *)invitationCode {
    NSDictionary *parameters;
    if (invitationCode == nil) {
        parameters = @{@"thirdFlag":thirdFlag,
                       @"openId":openId,
                       @"nickname":nickname?:@"",
                       @"headimgUrl":headimgUrl,
                       @"accessToken":accessToken,
                       @"unionid":unionid};
    } else {
        parameters = @{@"thirdFlag":thirdFlag,
                       @"openId":openId,
                       @"nickname":nickname?:@"",
                       @"headimgUrl":headimgUrl,
                       @"accessToken":accessToken,
                       @"unionid":unionid,
                       @"invitationCode":invitationCode};
    }
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSString *path = FormatString(@"gcuser/%@", kGetImageType(17));
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

- (RACSignal *)QukanNoReadMessageWithUserId:(NSString *)userId {
    NSDictionary *parameters = @{@"id":userId};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"/gcUserNotice/selectCount" params:parameters successBlock:^(id  _Nonnull result) {
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



- (RACSignal *)QukanUserWithId:(NSString *)thirdFlag addOpenId:(NSString *)openId addUnionid:(NSString *)unionid addNickname:(NSString *)nickname addHeadimgUrl:(NSString *)headimgUrl addAccessToken:(NSString *)accessToken
                                           umengToken:(NSString *)umengToken
                                           invitationCode:(NSString *)invitationCode
                                           type:(NSString *)type
                                           tel:(NSString *)tel
                                           code:(NSString *)code
                                           pass:(NSString *)pass
{
    NSDictionary *parameters = @{@"thirdFlag":thirdFlag,
                                 @"openId":openId,
                                 @"nickname":nickname?:@"",
                                 @"headimgUrl":headimgUrl,
                                 @"accessToken":accessToken,
                                 @"unionid":unionid,
                                 @"umengToken":umengToken,
                                 @"invitationCode":invitationCode,
                                 @"type":type,
                                 @"tel":tel,
                                 @"code":code,
                                 @"pass":pass
                                 };
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSString *path = FormatString(@"gcuser/%@", kGetImageType(17));
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

- (RACSignal *)TopicBindEmailSendCodeWithEmail:(NSString *)email type:(NSString *)type {
    NSDictionary *parameters = @{@"email":email,
                                 @"type":type};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"v4/email/sendCode" params:parameters successBlock:^(id  _Nonnull result) {
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


- (RACSignal *)TopicBindEmailWithEmail:(NSString *)email yzCode:(NSString *)yzCode {
    NSDictionary *parameters = @{@"email":email,
                                 @"code":yzCode};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"v4/email/bing-email" params:parameters successBlock:^(id  _Nonnull result) {
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


- (RACSignal *)QukangcuserBindWithTel:(NSString *)tel addCode:(NSString *)code addThirdId:(NSString *)thirdId thirdFlag:(NSString *)thirdFlag unionId:(NSString *)unionId{
    NSDictionary *parameters = @{@"tel":tel,
                                 @"code":code,
                                 @"thirdId":thirdId?:@"",
                                 @"thirdFlag":thirdFlag,
                                 @"unionId":unionId
                                 };
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"gcuser/bind" params:parameters successBlock:^(id  _Nonnull result) {
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

- (RACSignal *)QukanUserJoinAdd:(NSString *)invitationCode {
    NSDictionary *parameters = @{@"invitationCode":invitationCode};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"/v4/user/join/add" params:parameters successBlock:^(id  _Nonnull result) {
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



-(RACSignal *)QukanUmengToken:(NSString *)umengToken{
    NSDictionary *parameters =  @{@"umengToken":umengToken};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"v4/umeng/add" params:parameters successBlock:^(id  _Nonnull result) {
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


- (RACSignal *)QukanNewUserList {
    NSDictionary *parameters = @{};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"/task/queryNovice" params:parameters successBlock:^(id  _Nonnull result) {
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


- (RACSignal *)TopicgcuserForgetPassWithTel:(NSString *)tel addCode:(NSString *)code  addPassword:(NSString *)password {
    NSDictionary *parameters = @{@"tel":tel,
                                 @"code":code,
                                 @"password":password};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"gcuser/forgetPass" params:parameters successBlock:^(id  _Nonnull result) {
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

-(RACSignal *)QukangGetId:(NSString *)matchId{
    NSString *urlStr = [NSString stringWithFormat:@"/v3/bf-zq-match/match-share?matchId=%@",matchId];
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:urlStr params:nil successBlock:^(id  _Nonnull result) {
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

-(RACSignal *)QukangGetNewId:(NSString *)newId{
    NSString *urlStr = [NSString stringWithFormat:@"/v4/news/news-share?newId=%@",newId];
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:urlStr params:nil successBlock:^(id  _Nonnull result) {
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


- (RACSignal *)QukancheckAppStoreUpdate {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *task =  [kApiManager postRequestWithUrl:@"app/check-update" params:nil successBlock:^(id  _Nonnull result) {
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
