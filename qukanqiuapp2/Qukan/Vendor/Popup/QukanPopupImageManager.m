//
//  QukanPopupImageManager.m
//  QukanPopupExample
//
//  Created by zhuxiaohui on 16/12/2.
//  Copyright © 2016年 it7090.com. All rights reserved.
//  代码地址:https://github.com/CoderZhuXH/QukanPopup

#import "QukanPopupImageManager.h"
#import "QukanPopupCache.h"

@interface QukanPopupImageManager()

@property(nonatomic,strong) QukanPopupImageLoader *downloader;
@end

@implementation QukanPopupImageManager

+(nonnull instancetype )sharedManager{
    static QukanPopupImageManager *instance = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken,^{
        instance = [[QukanPopupImageManager alloc] init];
        
    });
    return instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _downloader = [QukanPopupImageLoader sharedDownloader];
    }
    return self;
}

- (void)loadImageWithURL:(nullable NSURL *)url options:(QukanPopupImageOptions)options progress:(nullable QukanPopupImgDownloadProgressBlock)progressBlock completed:(nullable XHExternalCompletionBlock)completedBlock{
    if(!options) options = QukanPopupImageDefault;
    if(options & QukanPopupImageOnlyLoad){
        [_downloader downloadImageWithURL:url progress:progressBlock completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error) {
            if(completedBlock) completedBlock(image,data,error,url);
        }];
    }else if (options & QukanPopupImageRefreshCached){
        NSData *imageData = [QukanPopupCache getCacheImageDataWithURL:url];
        UIImage *image =  [UIImage imageWithData:imageData];
        if(image && completedBlock) completedBlock(image,imageData,nil,url);
        [_downloader downloadImageWithURL:url progress:progressBlock completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error) {
            if(completedBlock) completedBlock(image,data,error,url);
            [QukanPopupCache async_saveImageData:data imageURL:url completed:nil];
        }];
    }else if (options & QukanPopupImageCacheInBackground){
        NSData *imageData = [QukanPopupCache getCacheImageDataWithURL:url];
        UIImage *image =  [UIImage imageWithData:imageData];
        if(image && completedBlock){
            completedBlock(image,imageData,nil,url);
        }else{
            [_downloader downloadImageWithURL:url progress:progressBlock completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error) {
                [QukanPopupCache async_saveImageData:data imageURL:url completed:nil];
            }];
        }
    }else{//default
        NSData *imageData = [QukanPopupCache getCacheImageDataWithURL:url];
        UIImage *image =  [UIImage imageWithData:imageData];
        if(image && completedBlock){
            completedBlock(image,imageData,nil,url);
        }else{
            [_downloader downloadImageWithURL:url progress:progressBlock completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error) {
                if(completedBlock) completedBlock(image,data,error,url);
                [QukanPopupCache async_saveImageData:data imageURL:url completed:nil];
            }];
        }
    }
}

@end
