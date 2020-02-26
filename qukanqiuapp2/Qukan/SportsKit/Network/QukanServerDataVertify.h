//
//  QukanServerDataVertify.h
//  Qukan
//
//  Created by pfc on 2019/6/19.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static NSString* const DXHttpErrorDomain = @"DXHttpErrorDomain";
static int const kDXInvalidResponseJsonCode = -20000;

static int const kadJsonDataRightCode = 0;
static int const kJsonDataRightCode = 200;
static NSString * const kJsonDataField = @"data";
static NSString * const kJsonCodeField = @"status";
static NSString * const kJsonMsgField = @"msg";

@interface QukanServerDataVertify : NSObject

/**
 验证服务器返回数据是否正确，响应码0代表成功，否则代表错误 接口文档参考地址：http://192.168.9.145:8088/page/index.html#/blog/37
 @param json 从服务器获取的json数据
 @return NSError 返回nil代表数据校验正确
 */
+ (nullable NSError *)valideServerJsonData:(NSDictionary *)json;


/**
 验证服务器返回数据是否正确。注意：服务器不同接口的正确码可能不一样，所以这里根据传入的URI来做不同的验证
 
 @param json 从服务器获取的json数据
 @param urlPath 请求的路径
 @return NSError 返回nil代表数据校验正确
 */
+ (nullable NSError *)valideServerJsonData:(NSDictionary *)json withURI:(nullable NSString *)urlPath;


/**
 请求服务器的错误描述
 
 @param error 请求发生的错误
 @return 错误描述
 */
+ (NSString *)descriptionForError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
