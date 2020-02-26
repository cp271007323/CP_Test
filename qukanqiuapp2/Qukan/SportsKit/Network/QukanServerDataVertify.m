//
//  QukanServerDataVertify.m
//  Qukan
//
//  Created by wdk on 2019/6/19.
//  Copyright © 2019 Beijing Xinmengxiang. All rights reserved.
//

#import "QukanServerDataVertify.h"

@implementation QukanServerDataVertify

#pragma mark - Public Methods

+ (nullable NSError *)valideServerJsonData:(NSDictionary *)json {
    return [QukanServerDataVertify valideServerJsonData:json withURI:nil];
}

+ (nullable NSError *)valideServerJsonData:(NSDictionary *)json withURI:(nullable NSString *)urlPath {
    NSAssert([json isKindOfClass:[NSDictionary class]], @"无效的返回数据");
    
    if (!json || ![json isKindOfClass:[NSDictionary class]]) {
        NSError *error = [NSError errorWithDomain:DXHttpErrorDomain code:kDXInvalidResponseJsonCode userInfo:@{NSLocalizedDescriptionKey : @"响应数据错误"}];
        return error;
    }
    
    int code = [json intValueForKey:kJsonCodeField default:-1];
    
    // 以下错误码  全部返回成功  但是需要去掉个人登录信息 并弹框
    if (code == 700 || code == 701 || code == 702 || code == 703 || code == 800 || code == 801 || code == 810) {
        [kNotificationCenter postNotificationName:kUserLoginUnvalidNotification object:json];
    }
    
    if (code != kJsonDataRightCode) {
        NSString *message = [json objectForKey:kJsonMsgField];
        message = message == nil ? @"空数据" : message;
        if ([message isEqual:[NSNull null]]) {
            message = @"";
        }
        if ([message isEqual:[NSNull null]] == NO && [message isEqualToString:@"null"]) message = @"";
        
        NSError *error = [NSError errorWithDomain:DXHttpErrorDomain code:code userInfo:@{NSLocalizedDescriptionKey : message}];
        return error;
    }
    
    return nil;
}

+ (NSString *)descriptionForError:(NSError *)error {
    NSAssert(error != nil, @"请传入有效的NSError");
    
    NSString *description = @"";
    switch (error.code) {
        case -1:
        case -1000:
            description = @"无效的URL地址";
            break;
        case -1001:
            description = @"网络不给力，请稍后再试";
            break;
        case -1002:
            description = @"不支持的URL地址";
            break;
        case -1003:
            description = @"找不到服务器";
            break;
        case -1004:
            description = @"连接不上服务器";
            break;
        case -1005:
            description = @"网络连接异常";
            break;
        case -1009:
            description = @"无网络连接";
            break;
        case -1011:
            description = @"服务器响应异常";
            break;
            //            case 3840:
            //                description = @"服务器响应异常";
            //                break;
        case NSURLErrorInternationalRoamingOff:
            description = @"国际漫游关闭";
            break;
            
        default:
            description = error.localizedDescription;
            break;
    }
    
    return description;
}

@end
