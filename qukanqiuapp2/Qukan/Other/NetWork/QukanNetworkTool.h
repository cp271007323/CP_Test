#import <AFNetworking/AFNetworking.h>


@interface QukanNetworkTool : NSObject


+ (void)Qukan_GET:(NSString *)url
 parameters:(NSDictionary *)parameters
    success:(void(^)(NSDictionary *response))success
    failure:(void(^)(NSError *error))failure;


+ (void)Qukan_POST:(NSString *)url
  parameters:(id)parameters
     success:(void(^)(NSDictionary *response))success
     failure:(void(^)(NSError *error))failure;

+ (void)Qukan_uploadImageWithUrl:(NSString *)url
                parameters:(NSDictionary *)parameters
              imageNameStr:(NSString *)imageNameStr
                   success:(void(^)(NSDictionary *response))success
                   failure:(void(^)(NSError *error))failure;

+ (void)Qukan_POST2:(NSString *)url
   parameters:(id)parameters
         date:(NSInteger)date
      success:(void(^)(NSDictionary *response, NSInteger date))success
      failure:(void(^)(NSError *error))failure;

+ (void)Qukan_uploadImageWithUrl:(NSString *)url
                          images:(NSArray *)images
                         success:(void(^)(NSDictionary *response))success
                         failure:(void(^)(NSError *error))failure;

+ (AFHTTPSessionManager *)Qukan_sharedSessionManager;

+ (NSMutableURLRequest *)buildRequestWithParams:(NSDictionary *)parameters WithUrl:(NSString *)url;
+ (NSMutableURLRequest *)adBuildRequestWithParams:(NSDictionary *)parameters;

+ (NSMutableURLRequest *)buildRequestWithParams1:(NSDictionary *)parameters WithUrl:(NSString *)url;

@end
