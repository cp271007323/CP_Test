//
//  QukanGetHostTool.m
//  Qukan
//
//  Created by leo on 2019/9/18.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//


// 规则
//    ssfd.basi88.com          --直接返回完整域名
//    dfggd.baxing5a.com       --直接返回完成域名
//https://gitee.com/oneduke/assdfcvb982/raw/master/abc  --直接返回完整域名
//https://blog.csdn.net/weixin_44900314/article/details/100000010  --返回文章，文章中隐藏了域名。解析规则，截取两个QWE9999ABC之间的字符串，解析成域名
//
//
//    1、默认入口两个狗爹域名+1个csdn+1个码云域名
//    2、app默认轮询2个狗爹域名，如果3次轮询都是网络加载失败，则启动码云返回域名。
//    3、如果码云返回的域名也是失败，则启动csdn返回的域名。
//    4、依次轮回。


//先直接使用轮询3.api2.jinribifenjiekou.com     4.api.tyQukanqiu.com
//
//阿乐 Miller, [17.09.19 18:19]


#import "QukanGetHostTool.h"

@interface QukanGetHostTool ()
// 所有的链接地址
@property(nonatomic, strong) NSArray     *arr_docm;
// 当前查找的地址的下标
@property(nonatomic, assign) NSInteger   curIndex;

// 结束轮询的下标
@property(nonatomic, assign) NSInteger   endIndex;
// 开始轮询的下标
@property(nonatomic, assign) NSInteger   startIndex;
// 当前正在测试的地址
@property(nonatomic, copy)   NSString      *str_currentHost;



@end


@implementation QukanGetHostTool

+ (instancetype)sharedQukanGetHostTool{
    static dispatch_once_t onceToken;
    static QukanGetHostTool *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
        instance.curIndex = 0;
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.curIndex = 0;
    }
    return self;
}


- (BOOL)hasValidHost {
    NSString *hostUrl = Qukan_BaseURL;
    return hostUrl.length > 0;
}

- (NSString *)locationHost {
    
    return Qukan_BaseURL;
}

/// 轮询查找有效IP地址
- (void)getValideAddressCompleteBlock:(void (^)(NSString * validHost))block {
    
    if (self.curIndex == self.endIndex) {
        NSLog(@"ymlx轮询结束获取,有效地址失败,此时存储地址为%@",[kUserDefaults objectForKey:Qukan_locationHostUrl]);
        self.isQueryData = NO;  // 设置为并非正在请求域名
        block(nil);
        return;
    }
    
    self.endIndex = self.startIndex;  // 只要进行了轮询  就把结束下标设置为开始的下标
    
    if (self.curIndex == 0 || self.curIndex == 1) {
        NSLog(@"ymlx直接查看第一个和第二个域名%@",self.arr_docm[self.curIndex]);
        // 请求得到了有效的地址
        self.str_currentHost = self.arr_docm[self.curIndex];
        [self testHostCanUse:^(BOOL canUse) {
            if (canUse) {  // 如果域名能用 则直接返回
                [kUserDefaults setObject:self.str_currentHost forKey:Qukan_locationHostUrl];
                self.isQueryData = NO;  // 设置为并非正在请求域名
                NSLog(@"ymlx轮询结束此时域名为%@",self.str_currentHost);
                block(self.str_currentHost);
                return;
            }else {
                [self getValideAddressCompleteBlock:block];
            }
        }];
    }else {
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        AFHTTPSessionManager * sessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config];
        sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        sessionManager.requestSerializer.timeoutInterval = 10;
        
        [sessionManager GET:self.arr_docm[self.curIndex] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if ([responseObject isKindOfClass:[NSData class]]) {
                NSString *url = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
                if (self.curIndex == 4) { // --返回文章，文章中隐藏了域名。解析规则，截取两个QWE9999ABC之间的字符串，解析成域名
                    if ([url containsString:@"QWE9999ABC"]) {
                        NSArray *arr = [url componentsSeparatedByString:@"QWE9999ABC"];
                        if (arr.count > 2) {
                            NSString *str = arr[1];
                            NSArray *arr1 = [str componentsSeparatedByString:@"&amp;"];
                            if (arr1.count == 2) {
                                url = [NSString stringWithFormat:@"%@://%@",arr1[1],arr1[0]];
                            }
                        }else {
                            NSLog(@"ymlx接口获取域名失败,失败原因：无法解析获取地址,开始重新获取");
                            [self getValideAddressCompleteBlock:block];
                            return;
                        }
                    }
                }
                
                if (!url || ![url hasPrefix:@"http"]) {
                    NSLog(@"ymlx接口获取域名失败，失败原因获取得到地址错误,开始重新获取");
                    [self getValideAddressCompleteBlock:block];
                    return;
                }
                
                NSLog(@"ymlx接口获取地址成功");
                
                // 请求得到了有效的地址
                self.str_currentHost = url;
                [self testHostCanUse:^(BOOL canUse) {
                    if (canUse) {  // 如果域名能用 则直接返回
                        self.isQueryData = NO;  // 设置为并非正在请求域名
                        [kUserDefaults setObject:self.str_currentHost forKey:Qukan_locationHostUrl];
                        NSLog(@"ymlx轮询结束此时域名为%@",[kUserDefaults objectForKey:Qukan_locationHostUrl]);
                        block(self.str_currentHost);
                        return;
                    }else {
                        NSLog(@"ymlx接口获取域名失败,失败原因：获取地址不可用,开始重新获取");
                        [self getValideAddressCompleteBlock:block];
                    }
                }];
            }else {
                
                NSLog(@"ymlx接口获取域名失败,失败原因：地址解析错误,开始重新获取");
                [self getValideAddressCompleteBlock:block];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"ymlx接口获取域名失败,失败原因：无法获取到地址,开始重新获取");
            [self getValideAddressCompleteBlock:block];
        }];
    }
    
    
    if (self.curIndex == self.arr_docm.count - 1) {
        self.curIndex = 0;
    }else {
        self.curIndex += 1;
    }
}

- (void)getValideApiWithCompletBlock:(void (^)(NSString * validHost))completBlock {
    if (self.isQueryData) {   // 若正在请求域名 直接ruturn掉
        return;
    }
    self.endIndex = 10086;  // 把结束的下标设置为一个不可能的下标
    self.startIndex = self.curIndex;   // 把开始的下标设置为当前轮询的下标
    self.isQueryData = YES;   // 把轮询开关打开
    
    [self getValideAddressCompleteBlock:completBlock];
}

// 检测域名是否可用
- (void)testHostCanUse:(void(^)(BOOL canUse))block {
    NSString *s3 = @"v4/comment/search";
    NSLog(@"ymlx开始测试%@域名是否可用",self.str_currentHost);
    NSURLRequest *request = [QukanNetworkTool buildRequestWithParams1:@{} WithUrl:[NSString stringWithFormat:@"%@/%@",self.str_currentHost,s3]];
    AFHTTPSessionManager * httpManager = [AFHTTPSessionManager manager];
    httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
    httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    httpManager.requestSerializer.timeoutInterval = 10;
    httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/html",@"text/plain", @"image/jpeg", @"image/png", @"multipart/form-data", nil];
    NSURLSessionDataTask *task =   [httpManager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response,id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"ymlx 此次测试域名可用 data == %@", responseObject);
            block(YES);
        }else {
            NSLog(@"ymlx 此次测试域名不可用 %@", error);
            block(NO);
        }
    }];
    [task resume];
}



#pragma mark - lazy
- (NSArray *)arr_docm {
    if (!_arr_docm) {
        _arr_docm = @[@"http://api2.jinribifenjiekou.com",
                      [NSString stringWithFormat:@"%@%@",@"http://api.tyquka",@"nqiu.com"],
                      [NSString stringWithFormat:@"%@%@",@"https://gitee.com/pianhai_787794/quka",@"nqiu/raw/master/src/com/abc"],
                      @"https://blog.csdn.net/weixin_45556952/article/details/100022066"];
    }
    return _arr_docm;
}

- (NSMutableArray *)arr_failPostList {
    if (!_arr_failPostList) {
        _arr_failPostList = [NSMutableArray new];
    }
    return _arr_failPostList;
}


@end
