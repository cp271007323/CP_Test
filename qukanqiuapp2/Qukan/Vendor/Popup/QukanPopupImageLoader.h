//
//  QukanPopupImageLoaderManager.h
//  QukanPopupExample
//
//  Created by zhuxiaohui on 16/12/1.
//  Copyright © 2016年 it7090.com. All rights reserved.
//  代码地址:https://github.com/CoderZhuXH/QukanPopup

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark - QukanPopupImgDownload

typedef void(^QukanPopupImgDownloadProgressBlock)(unsigned long long total, unsigned long long current);

typedef void(^QukanPopupImgDownloadImageCompletedBlock)(UIImage *_Nullable image, NSData * _Nullable data, NSError * _Nullable error);

typedef void(^QukanPopupBatchDownLoadAndCacheCompletedBlock) (NSArray * _Nonnull completedArray);

@protocol QukanPopupImgDownloadDelegate <NSObject>

- (void)downloadImageFinishWithURL:(nonnull NSURL *)url;

@end

@interface QukanPopupImgDownload : NSObject
@property (assign, nonatomic ,nonnull)id<QukanPopupImgDownloadDelegate> delegate;
@end

@interface QukanPopupImageDownload : QukanPopupImgDownload

@end


#pragma mark - QukanPopupImageLoader
@interface QukanPopupImageLoader : NSObject

+(nonnull instancetype )sharedDownloader;

- (void)downloadImageWithURL:(nonnull NSURL *)url progress:(nullable QukanPopupImgDownloadProgressBlock)progressBlock completed:(nullable QukanPopupImgDownloadImageCompletedBlock)completedBlock;

- (void)downLoadImageAndCacheWithURLArray:(nonnull NSArray <NSURL *> * )urlArray;
- (void)downLoadImageAndCacheWithURLArray:(nonnull NSArray <NSURL *> * )urlArray completed:(nullable QukanPopupBatchDownLoadAndCacheCompletedBlock)completedBlock;


@end

