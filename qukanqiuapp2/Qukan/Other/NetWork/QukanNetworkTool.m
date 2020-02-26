
#import <CommonCrypto/CommonDigest.h>

#import <AdSupport/AdSupport.h>
#import <FCUUID/FCUUID.h>

#import <CommonCrypto/CommonCryptor.h>


size_t const kKeySize = kCCKeySizeAES128;
NSString *const kInitVector = @"wQcvnvIjd7tN3xj*";

@interface NSString (QukanMD5)
+ (NSString *)md5:(NSString *) str;
@end
@implementation NSString (QukanMD5)
+ (NSString *)md5:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (int)strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
@end


@implementation QukanNetworkTool

static AFHTTPSessionManager *_Qukan_sessionManager;
+ (AFHTTPSessionManager *)Qukan_sharedSessionManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _Qukan_sessionManager = [AFHTTPSessionManager manager];
        _Qukan_sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        _Qukan_sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _Qukan_sessionManager.requestSerializer.timeoutInterval = 25;
        _Qukan_sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", @"image/jpeg", @"image/png", @"multipart/form-data", nil];
    });
    return _Qukan_sessionManager;
}


+ (void)Qukan_GET:(NSString *)url
 parameters:(NSDictionary *)parameters
    success:(void(^)(NSDictionary *response))success
    failure:(void(^)(NSError *error))failure {
    NSString *requestUrl = [NSString stringWithFormat:@"%@/%@", Qukan_BaseURL, url];
    [[QukanNetworkTool Qukan_sharedSessionManager] GET:requestUrl parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
//            NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}


+ (NSMutableURLRequest *)buildRequestWithParams:(NSDictionary *)parameters WithUrl:(NSString *)url {
    NSString *requestUrl = [NSString stringWithFormat:@"%@/%@", Qukan_BaseURL, url];
    return [QukanNetworkTool buildWithParams:parameters WithUrl:requestUrl];
}

+ (NSMutableURLRequest *)buildRequestWithParams1:(NSDictionary *)parameters WithUrl:(NSString *)url {
    NSString *requestUrl = [NSString stringWithFormat:@"%@", url];
    return [QukanNetworkTool buildWithParams:parameters WithUrl:requestUrl];
}

+ (NSMutableURLRequest *)buildWithParams:(NSDictionary *)parameters WithUrl:(NSString *)url {
    if (!parameters) {parameters = @{};}
    NSString *authorizationToken = kUserManager.user.token ? kUserManager.user.token : @"";
    NSData *encodData = [[parameters jsonStringEncoded] dataUsingEncoding:NSUTF8StringEncoding];
    NSString *paramersBase64 = [encodData base64EncodedStringWithOptions:0];
    
    NSString *secretKey = @"LfP2A0XgAzc4Epxf6pbTAoHNMnEu3Ix0";
    NSString *toKen = authorizationToken;
    if (authorizationToken.length!=0) {
        secretKey = kUserManager.user.key?:@"";
        toKen = [NSString stringWithFormat:@"Bearer_%@", authorizationToken];
    }
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *bundleIdentifier = [infoDictionary objectForKey:@"CFBundleIdentifier"];
    
    NSMutableDictionary *common = @{}.mutableCopy;
    [common setObject:bundleIdentifier forKey:@"appPac"];
    [common setObject:@2 forKey:@"deviceType"];
    [common setObject:app_Version forKey:@"versionCode"];
    NSString *deviceId = [FCUUID uuidForDevice];
    [common setObject:deviceId forKey:@"devicenId"];    [common setObject:Qukan_UMWeChatAppKey forKey:@"wechatOpenId"];
    [common setObject:kAppManager.umName forKey:@"channelId"];
    
    NSDate* date = [NSDate date];
    NSTimeInterval time=[date timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    [common setObject:timeString forKey:@"timeStamp"];
    
    NSString *aid = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    if (aid) {
        [common setObject:aid forKey:@"iosIdfa"];
    }
    
    NSString *commonParamJson = [common jsonStringEncoded];
    
    NSString *commonBase64String = [commonParamJson base64EncodedString];
    NSString *md5EncodedString = [NSString stringWithFormat:@"%@%@%@", paramersBase64, secretKey, commonBase64String];
    
    NSString *signString = [md5EncodedString md5String];
    
    NSDictionary *bodyDataDict = @{@"object":paramersBase64, @"sign":signString, @"common" : commonBase64String};
    

//    NSData *httpBody = [bodyDataDict modelToJSONData];
    
    NSString *str_httpBody = [bodyDataDict jsonStringEncoded];
    
    NSString *secrStr_httpBody = [QukanNetworkTool  encryptAES:str_httpBody key:@"Ky9zJa&&T1!RGzvn"];
    NSData *httpBodySectr = [secrStr_httpBody dataUsingEncoding:NSUTF8StringEncoding];
    
    
//    NSString *str1 = [QukanNetworkTool decryptAES:secrStr_httpBody key:@"Ky9zJa&&T1!RGzvn"];
    
//    NSData *httpBodySectr = [QukanNetworkTool encryptDataWithData:httpBody Key:@"Ky9zJa&&T1!RGzvn"];
    
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    NSMutableURLRequest *request = [serializer requestWithMethod:@"POST" URLString:url parameters:nil error:nil];
    request.timeoutInterval= 25;
    
    NSString *systemName = [[UIDevice currentDevice] systemName];
    NSString *versionInfo = [NSString stringWithFormat:@"platformInfo=2&appPac=%@&appVersion=%@&os=%@", bundleIdentifier, app_Version, systemName];
    [request setValue:versionInfo forHTTPHeaderField:@"version-info"];
    if (authorizationToken.length) {
        [request setValue:toKen forHTTPHeaderField:@"Authorization"];
    } else {
        [request setValue:@"" forHTTPHeaderField:@"Authorization"];
    }
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody:httpBodySectr];
    
    return request;
}


// 加密
+ (NSString *)encryptAES:(NSString *)content key:(NSString *)key {
    NSData *contentData = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = contentData.length;
    // 为结束符'\\0' +1
    char keyPtr[kKeySize + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    // 密文长度 <= 明文长度 + BlockSize
    size_t encryptSize = dataLength + kCCBlockSizeAES128;
    void *encryptedBytes = malloc(encryptSize);
    size_t actualOutSize = 0;
    NSData *initVector = [kInitVector dataUsingEncoding:NSUTF8StringEncoding];
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES,
                                          kCCOptionPKCS7Padding,  // 系统默认使用 CBC，然后指明使用 PKCS7Padding
                                          keyPtr,
                                          kKeySize,
                                          initVector.bytes,
                                          contentData.bytes,
                                          dataLength,
                                          encryptedBytes,
                                          encryptSize,
                                          &actualOutSize);
    if (cryptStatus == kCCSuccess) {
        // 对加密后的数据进行 base64 编码
        return [[NSData dataWithBytesNoCopy:encryptedBytes length:actualOutSize] base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    }
    free(encryptedBytes);
    return nil;
}


// 解密
+ (NSString *)decryptAES:(NSString *)content key:(NSString *)key {
    // 把 base64 String 转换成 Data
    NSData *contentData = [[NSData alloc] initWithBase64EncodedString:content options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSUInteger dataLength = contentData.length;
    char keyPtr[kKeySize + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    size_t decryptSize = dataLength + kCCBlockSizeAES128;
    void *decryptedBytes = malloc(decryptSize);
    size_t actualOutSize = 0;
    NSData *initVector = [kInitVector dataUsingEncoding:NSUTF8StringEncoding];
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES,
                                          kCCOptionPKCS7Padding,
                                          keyPtr,
                                          kKeySize,
                                          initVector.bytes,
                                          contentData.bytes,
                                          dataLength,
                                          decryptedBytes,
                                          decryptSize,
                                          &actualOutSize);
    if (cryptStatus == kCCSuccess) {
        return [[NSString alloc] initWithData:[NSData dataWithBytesNoCopy:decryptedBytes length:actualOutSize] encoding:NSUTF8StringEncoding];
    }
    free(decryptedBytes);
    return nil;
}

+ (NSMutableURLRequest *)adBuildRequestWithParams:(NSDictionary *)parameters {
    NSString *requestUrl = [NSString stringWithFormat:@"%@", Qukan_AdBaseURL];
    if (!parameters) {parameters = @{};}
    NSString *secretKey = @"tiyu";
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *bundleIdentifier = [infoDictionary objectForKey:@"CFBundleIdentifier"];
    NSString *flagStr = Qukan_AdChannel;
    NSString *appVersion = [NSString stringWithFormat:@"%@@%@",flagStr,app_Version];
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time = [date timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f",time];
    
    NSString *md5EncodedString = [NSString stringWithFormat:@"%@%@%@%@%@%@",appVersion, @"19",secretKey,parameters[@"ad_type"],@"ios" ,timeString];
    NSString *signString = [md5EncodedString md5String];
    NSDictionary *bodyDataDict = [NSDictionary dictionary];
    if (parameters[@"img_id"] != nil) {
        bodyDataDict = @{@"app_flag":appVersion,@"ad_type":parameters[@"ad_type"],@"phone_type":@"ios",@"project":@"19", @"sign":signString, @"timestamp" : timeString,@"appkey":secretKey,@"img_id":parameters[@"img_id"]};
    } else {
        bodyDataDict = @{@"app_flag":appVersion,@"ad_type":parameters[@"ad_type"],@"phone_type":@"ios",@"project":@"19", @"sign":signString, @"timestamp" : timeString,@"appkey":secretKey};
    }
    NSData *httpBody = [bodyDataDict modelToJSONData];
    
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    NSMutableURLRequest *request = [serializer requestWithMethod:@"POST" URLString:requestUrl parameters:nil error:nil];
    request.timeoutInterval= 25;
    
    NSString *systemName = [[UIDevice currentDevice] systemName];
    NSString *versionInfo = [NSString stringWithFormat:@"platformInfo=2&appPac=%@&appVersion=%@&os=%@", bundleIdentifier, app_Version, systemName];
    [request setValue:versionInfo forHTTPHeaderField:@"version-info"];
    [request setValue:@"" forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:httpBody];
    
    return request;
}


+ (void)Qukan_POST:(NSString *)url
  parameters:(id)parameters
     success:(void(^)(NSDictionary *response))success
     failure:(void(^)(NSError *error))failure {
    DEBUGLog(@"http request with url: %@  request params: %@", url, parameters);
    NSMutableURLRequest *request = [QukanNetworkTool buildRequestWithParams:parameters WithUrl:url];
    [[[QukanNetworkTool Qukan_sharedSessionManager] dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            DEBUGLog(@"http response success for url: %@  response data: %@", url, [responseObject jsonStringEncoded]);
            if (success) {
//                NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                success(responseObject);
            }
        } else {
            DEBUGLog(@"http response failure for url: %@  response error: %@", url, error);
            if (failure) {
                failure(error);
            }
        }
    }] resume];
}

+ (void)Qukan_uploadImageWithUrl:(NSString *)url
                parameters:(NSDictionary *)parameters
              imageNameStr:(NSString *)imageNameStr
                   success:(void(^)(NSDictionary *response))success
                   failure:(void(^)(NSError *error))failure {
    NSString *requestUrl = [NSString stringWithFormat:@"%@/%@", Qukan_BaseURL, url];
//    NSString *authorization = [[NSUserDefaults standardUserDefaults] objectForKey:Qukan_Token_Key];
    NSString *authorization = kUserManager.user.token;
    NSString *toKen = [NSString stringWithFormat:@"Bearer_%@", authorization?:@""];
    
    AFHTTPSessionManager * httpManager = [AFHTTPSessionManager manager];
    httpManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    httpManager.requestSerializer.timeoutInterval = 15;
    httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/html",@"text/plain", @"image/jpeg", @"image/png", @"multipart/form-data", nil];
    
    [httpManager.requestSerializer setValue:toKen forHTTPHeaderField:@"Authorization"];
    [httpManager POST:requestUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *imageData = UIImageJPEGRepresentation(parameters[parameters.allKeys.firstObject], 0.1);
        NSString *imageName = parameters.allKeys.firstObject;
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat =@"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@%@.jpg", str, imageNameStr];
        [formData appendPartWithFileData:imageData
                                    name:imageName
                                fileName:fileName
                                mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            success(dataDict);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)Qukan_POST2:(NSString *)url parameters:(id)parameters date:(NSInteger)date success:(void (^)(NSDictionary *, NSInteger))success failure:(void (^)(NSError *))failure {
    [QukanNetworkTool Qukan_POST:url parameters:parameters success:^(NSDictionary *response) {
        success(response, date);
    } failure:failure];
}

+ (void)Qukan_uploadImageWithUrl:(NSString *)url
                          images:(NSArray *)images
                         success:(void(^)(NSDictionary *response))success
                         failure:(void(^)(NSError *error))failure {
    NSString *requestUrl = [NSString stringWithFormat:@"%@/%@", Qukan_BaseURL, url];
    NSString *authorization = kUserManager.user.token;
    NSString *toKen = [NSString stringWithFormat:@"Bearer_%@", authorization?:@""];
    [[QukanNetworkTool Qukan_sharedSessionManager].requestSerializer setValue:toKen forHTTPHeaderField:@"Authorization"];
    [[QukanNetworkTool Qukan_sharedSessionManager] POST:requestUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i=0; i<images.count; i++) {
            NSData *imageData = UIImageJPEGRepresentation(images[i], 0.5);
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            formatter.dateFormat =@"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
            [formData appendPartWithFileData:imageData
                                        name:@"files"
                                    fileName:fileName
                                    mimeType:@"image/jpeg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}



@end
