//
//  QukanApiManager.m
//  Qukan
//
//  Created by wdk on 2019/6/19.
//  Copyright © 2019 wukang sports. All rights reserved.
//


#import "QukanApiManager.h"
#import "QukanGetHostTool.h"

#define kShowNetWorkLog 1

#define kMaxFailCount 5

typedef void(^netErrorBlock)(NSError *);

@interface QukanApiManager()


@end

@implementation QukanApiManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static QukanApiManager *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}


- (NSURLSessionDataTask *)postRequestWithUrl:(NSString *)url
                                      params:(NSDictionary * _Nullable)params
                                successBlock:(void (^)(id result))successBlock
                                   failBlock:(void (^)(NSError *error))errorBlock {
    NSURLRequest *request = [QukanNetworkTool buildRequestWithParams:params WithUrl:url];
    AFHTTPSessionManager * httpManager = [AFHTTPSessionManager manager];
    httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
    httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    httpManager.requestSerializer.timeoutInterval = 15;
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@/%@", Qukan_BaseURL, url];
    NSLog(@"ymlx开始请求%@", requestUrl);
    
    httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/html",@"text/plain", @"image/jpeg", @"image/png", @"multipart/form-data", nil];
    NSURLSessionDataTask *task =   [httpManager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response,id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            NSError *apiError = [QukanServerDataVertify valideServerJsonData:responseObject];
            if (!apiError ) {
                if (kShowNetWorkLog)
                    DEBUGLog(@"http response success for url: %@  response data: %@", request.URL.absoluteString, [responseObject jsonStringEncoded]);
                
                successBlock(responseObject[kJsonDataField]);
            }else {
                DEBUGLog(@"http response failure for url: %@  response error: %@", request.URL.absoluteString, apiError);
                errorBlock(apiError);
            }
        }else{
            DEBUGLog(@"http response failure for url: %@  response error: %@", request.URL.absoluteString, error);
            
            if ([Qukan_BaseURL isEqualToString:@"http://154.211.159.144:80"] || error.code == -999) {
                errorBlock(error);
            }else {
                
                NSString *urlString = [NSString stringWithFormat:@"%@%@", Qukan_BaseURL,url];
                if (error.code == NSURLErrorTimedOut && [[QukanGetHostTool sharedQukanGetHostTool].arr_failPostList containsObject:urlString]) {
                    NSLog(@"asdasasdsdaad%@",urlString);
                    // 如果是请求超时，则再尝试一次请求
                    [[QukanGetHostTool sharedQukanGetHostTool].arr_failPostList addObject:urlString];
                    [self postRequestWithUrl:url params:params successBlock:successBlock failBlock:errorBlock];
                }else {  // 若不是请求超时  则直接进行轮询查找  看看是否有其他有效地址
                    if ([[QukanGetHostTool sharedQukanGetHostTool] isQueryData]) {  // 如果正在轮询中  第二个失败的回调回来了
                        errorBlock(error);
                    }else {
                        [[QukanGetHostTool sharedQukanGetHostTool] getValideApiWithCompletBlock:^(NSString * _Nonnull validHost) {
                            errorBlock(error);
                        }];
                    }
                }
            }
        }
    }];
    
    // 发送请求
    [task resume];
    
    return task;
}


- (NSURLSessionDataTask *)adPostRequestWithUrl:(NSString *)url
                                        params:(NSDictionary * _Nullable)params
                                  successBlock:(void (^)(id result))successBlock
                                     failBlock:(void (^)(NSError *error))errorBlock {
    NSURLRequest *request = [QukanNetworkTool adBuildRequestWithParams:params];
    AFHTTPSessionManager * httpManager = [AFHTTPSessionManager manager];
    httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
    httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    httpManager.requestSerializer.timeoutInterval = 15;
    httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/html",@"text/plain", @"image/jpeg", @"image/png", @"multipart/form-data", nil];
    NSURLSessionDataTask *task =   [httpManager dataTaskWithRequest:request
                                                     uploadProgress:nil
                                                   downloadProgress:nil
                                                  completionHandler:^(NSURLResponse * _Nonnull response,
                                                                      id  _Nullable responseObject,
                                                                      NSError * _Nullable error) {
                                                      if (!error) {
                                                          NSError *apiError = [QukanServerDataVertify valideServerJsonData:responseObject];
                                                          if (!apiError) {
                                                              if (kShowNetWorkLog)
                                                                  DEBUGLog(@"http response success for url: %@  response data: %@", request.URL.absoluteString, [responseObject jsonStringEncoded]);
                                                              successBlock(responseObject[kJsonDataField]);
                                                          }else {
                                                              DEBUGLog(@"http response failure for url: %@  response error: %@", request.URL.absoluteString, apiError);
                                                              errorBlock(apiError);
                                                          }
                                                      }else {
                                                          DEBUGLog(@"http response failure for url: %@  response error: %@", request.URL.absoluteString, error);
                                                          errorBlock(error);
                                                      }
                                                  }];
    [task resume];
    
    return task;
}


///

@end
