//
//  QukanPopupImageManager.h
//  QukanPopupExample
//
//  Created by zhuxiaohui on 16/12/2.
//  Copyright © 2016年 it7090.com. All rights reserved.
//  代码地址:https://github.com/CoderZhuXH/QukanPopup

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "QukanPopupImageLoader.h"

typedef NS_OPTIONS(NSUInteger, QukanPopupImageOptions) {
    /** 有缓存,读取缓存,不重新下载,没缓存先下载,并缓存 */
    QukanPopupImageDefault = 1 << 0,
    /** 只下载,不缓存 */
    QukanPopupImageOnlyLoad = 1 << 1,
    /** 先读缓存,再下载刷新图片和缓存 */
    QukanPopupImageRefreshCached = 1 << 2 ,
    /** 后台缓存本次不显示,缓存OK后下次再显示(建议使用这种方式)*/
    QukanPopupImageCacheInBackground = 1 << 3
};

typedef void(^XHExternalCompletionBlock)(UIImage * _Nullable image,NSData * _Nullable imageData, NSError * _Nullable error, NSURL * _Nullable imageURL);

@interface QukanPopupImageManager : NSObject

+(nonnull instancetype )sharedManager;
- (void)loadImageWithURL:(nullable NSURL *)url options:(QukanPopupImageOptions)options progress:(nullable QukanPopupImgDownloadProgressBlock)progressBlock completed:(nullable XHExternalCompletionBlock)completedBlock;

@end
