//
//  QukanApiManager.h
//  Qukan
//
//  Created by pfc on 2019/6/19.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QukanServerDataVertify.h"

NS_ASSUME_NONNULL_BEGIN

#define kApiManager [QukanApiManager sharedInstance]

@interface QukanApiManager : NSObject

+ (instancetype)sharedInstance;


/**发送post请求 项目只有post请求*/
- (NSURLSessionDataTask *)postRequestWithUrl:(NSString *)url
                                      params:(NSDictionary * _Nullable)params
                                successBlock:(void (^)(id result))successBlock
                                   failBlock:(void (^)(NSError *error))errorBlock;

/**广告相关的post请求*/
- (NSURLSessionDataTask *)adPostRequestWithUrl:(NSString *)url
                                        params:(NSDictionary * _Nullable)params
                                  successBlock:(void (^)(id result))successBlock
                                     failBlock:(void (^)(NSError *error))errorBlock;

@end

NS_ASSUME_NONNULL_END
