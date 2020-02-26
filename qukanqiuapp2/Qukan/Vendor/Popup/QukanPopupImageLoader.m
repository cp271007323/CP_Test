//
//  QukanPopupImageLoaderManager.m
//  QukanPopupExample
//
//  Created by zhuxiaohui on 16/12/1.
//  Copyright © 2016年 it7090.com. All rights reserved.
//  代码地址:https://github.com/CoderZhuXH/QukanPopup

#import "QukanPopupImageLoader.h"
#import "QukanPopupCache.h"
#import "FLAnimatedImage.h"
#import "QukanPopupConst.h"

#pragma mark - QukanPopupImgDownload

@interface QukanPopupImgDownload()

@property (strong, nonatomic) NSURLSession *session;
@property(strong,nonatomic)NSURLSessionDownloadTask *imageTask;
@property (nonatomic, assign) unsigned long long totalLength;
@property (nonatomic, assign) unsigned long long currentLength;
@property (nonatomic, copy) QukanPopupImgDownloadProgressBlock progressBlock;
@property (strong, nonatomic) NSURL *url;

@end
@implementation QukanPopupImgDownload

@end

#pragma mark -  QukanPopupImageDownload
@interface QukanPopupImageDownload()<NSURLSessionDownloadDelegate,NSURLSessionTaskDelegate>

@property (nonatomic, copy ) QukanPopupImgDownloadImageCompletedBlock completedBlock;

@end
@implementation QukanPopupImageDownload

-(nonnull instancetype)initWithURL:(nonnull NSURL *)url delegateQueue:(nonnull NSOperationQueue *)queue progress:(nullable QukanPopupImgDownloadProgressBlock)progressBlock completed:(nullable QukanPopupImgDownloadImageCompletedBlock)completedBlock{
    self = [super init];
    if (self) {
        self.url = url;
        self.progressBlock = progressBlock;
        self.completedBlock = completedBlock;
        NSURLSessionConfiguration * sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionConfiguration.timeoutIntervalForRequest = 15.0;
        self.session = [NSURLSession sessionWithConfiguration:sessionConfiguration
                                                     delegate:self
                                                delegateQueue:queue];
        self.imageTask =  [self.session downloadTaskWithRequest:[NSURLRequest requestWithURL:url]];
        [self.imageTask resume];
    }
    return self;
}

#pragma mark - NSURLSessionDownloadDelegate
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {
    NSData *data = [NSData dataWithContentsOfURL:location];
    UIImage *image = [UIImage imageWithData:data];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.completedBlock) {
            self.completedBlock(image,data, nil);
            // 防止重复调用
            self.completedBlock = nil;
        }
        //下载完成回调
        if ([self.delegate respondsToSelector:@selector(downloadImageFinishWithURL:)]) {
            [self.delegate downloadImageFinishWithURL:self.url];
        }
    });
    //销毁
    [self.session invalidateAndCancel];
    self.session = nil;
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    self.currentLength = totalBytesWritten;
    self.totalLength = totalBytesExpectedToWrite;
    if (self.progressBlock) {
        self.progressBlock(self.totalLength, self.currentLength);
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error){
        QukanPopupLog(@"error = %@",error);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.completedBlock) {
                self.completedBlock(nil,nil, error);
            }
            self.completedBlock = nil;
        });
    }
}

//处理HTTPS请求的
- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler{
    NSURLProtectionSpace *protectionSpace = challenge.protectionSpace;
    if ([protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        SecTrustRef serverTrust = protectionSpace.serverTrust;
        completionHandler(NSURLSessionAuthChallengeUseCredential, [NSURLCredential credentialForTrust:serverTrust]);
    } else {
        completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
    }
}

@end

#pragma mark - QukanPopupImageLoader
@interface QukanPopupImageLoader()<QukanPopupImgDownloadDelegate>
@property (strong, nonatomic, nonnull) NSOperationQueue *downloadImageQueue;
@property (strong, nonatomic) NSMutableDictionary *allDownloadDict;
@end

@implementation QukanPopupImageLoader

+(nonnull instancetype )sharedDownloader{
    static QukanPopupImageLoader *instance = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken,^{
        instance = [[QukanPopupImageLoader alloc] init];
    });
    return instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _downloadImageQueue = [NSOperationQueue new];
        _downloadImageQueue.maxConcurrentOperationCount = 6;
        _downloadImageQueue.name = @"com.it7090.QukanPopupImgDownloadImageQueue";
        QukanPopupLog(@"QukanPopupCachePath:%@",[QukanPopupCache JiuAilaunchCachePath]);
    }
    return self;
}

- (void)downloadImageWithURL:(nonnull NSURL *)url progress:(nullable QukanPopupImgDownloadProgressBlock)progressBlock completed:(nullable QukanPopupImgDownloadImageCompletedBlock)completedBlock{
    NSString *key = [self keyWithURL:url];
    if(self.allDownloadDict[key]) return;
    QukanPopupImageDownload * download = [[QukanPopupImageDownload alloc] initWithURL:url delegateQueue:_downloadImageQueue progress:progressBlock completed:completedBlock];
    download.delegate = self;
    [self.allDownloadDict setObject:download forKey:key];
}

- (void)downloadImageAndCacheWithURL:(nonnull NSURL *)url completed:(void(^)(BOOL result))completedBlock{
    if(url == nil){
         if(completedBlock) completedBlock(NO);
         return;
    }
    [self downloadImageWithURL:url progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error) {
        if(error){
            if(completedBlock) completedBlock(NO);
        }else{
            [QukanPopupCache async_saveImageData:data imageURL:url completed:^(BOOL result, NSURL * _Nonnull URL) {
                if(completedBlock) completedBlock(result);
            }];
        }
    }];
}

-(void)downLoadImageAndCacheWithURLArray:(NSArray<NSURL *> *)urlArray{
    [self downLoadImageAndCacheWithURLArray:urlArray completed:nil];
}

- (void)downLoadImageAndCacheWithURLArray:(nonnull NSArray <NSURL *> * )urlArray completed:(nullable QukanPopupBatchDownLoadAndCacheCompletedBlock)completedBlock{
    if(urlArray.count==0) return;
    __block NSMutableArray * resultArray = [[NSMutableArray alloc] init];
    dispatch_group_t downLoadGroup = dispatch_group_create();
    [urlArray enumerateObjectsUsingBlock:^(NSURL *url, NSUInteger idx, BOOL *stop) {
        if(![QukanPopupCache checkImageInCacheWithURL:url]){
            dispatch_group_enter(downLoadGroup);
            [self downloadImageAndCacheWithURL:url completed:^(BOOL result) {
                dispatch_group_leave(downLoadGroup);
                [resultArray addObject:@{@"url":url.absoluteString,@"result":@(result)}];
            }];
        }else{
          [resultArray addObject:@{@"url":url.absoluteString,@"result":@(YES)}];
        }
    }];
    dispatch_group_notify(downLoadGroup, dispatch_get_main_queue(), ^{
        if(completedBlock) completedBlock(resultArray);
    });
}

- (NSMutableDictionary *)allDownloadDict {
    if (!_allDownloadDict) {
        _allDownloadDict = [[NSMutableDictionary alloc] init];
    }
    return _allDownloadDict;
}

- (void)downloadImageFinishWithURL:(NSURL *)url{
    [self.allDownloadDict removeObjectForKey:[self keyWithURL:url]];
}

-(NSString *)keyWithURL:(NSURL *)url{
    return [QukanPopupCache md5String:url.absoluteString];
}

@end

