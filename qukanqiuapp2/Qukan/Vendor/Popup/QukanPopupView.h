//
//  QukanPopupView.h
//  QukanPopupExample
//
//  Created by zhuxiaohui on 16/12/3.
//  Copyright © 2016年 it7090.com. All rights reserved.
//  代码地址:https://github.com/CoderZhuXH/QukanPopup

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>

#if __has_include(<FLAnimatedImage/FLAnimatedImage.h>)
#import <FLAnimatedImage/FLAnimatedImage.h>
#else
#import "FLAnimatedImage.h"
#endif

#if __has_include(<FLAnimatedImage/FLAnimatedImageView.h>)
#import <FLAnimatedImage/FLAnimatedImageView.h>
#else
#import "FLAnimatedImageView.h"
#endif


#pragma mark - image
@interface QukanPopupImageView : FLAnimatedImageView

@property (nonatomic, copy) void(^click)(CGPoint point);

@end


