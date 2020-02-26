//
//  QukanPopupImageView+QukanPopupCache.m
//  QukanPopupExample
//
//  Created by zhuxiaohui on 2017/9/18.
//  Copyright © 2017年 it7090.com. All rights reserved.
//  代码地址:https://github.com/CoderZhuXH/QukanPopup

#import "QukanPopupImageView+QukanPopupCache.h"
#import "FLAnimatedImage.h"
#import "QukanPopupConst.h"

@implementation QukanPopupImageView (QukanPopupCache)
- (void)xh_setImageWithURL:(nonnull NSURL *)url{
    [self xh_setImageWithURL:url placeholderImage:nil];
}

- (void)xh_setImageWithURL:(nonnull NSURL *)url placeholderImage:(nullable UIImage *)placeholder{
    [self xh_setImageWithURL:url placeholderImage:placeholder options:QukanPopupImageDefault];
}

-(void)xh_setImageWithURL:(nonnull NSURL *)url placeholderImage:(nullable UIImage *)placeholder options:(QukanPopupImageOptions)options{
    [self xh_setImageWithURL:url placeholderImage:placeholder options:options completed:nil];
}

- (void)xh_setImageWithURL:(nonnull NSURL *)url completed:(nullable XHExternalCompletionBlock)completedBlock {
    
    [self xh_setImageWithURL:url placeholderImage:nil completed:completedBlock];
}

- (void)xh_setImageWithURL:(nonnull NSURL *)url placeholderImage:(nullable UIImage *)placeholder completed:(nullable XHExternalCompletionBlock)completedBlock{
    [self xh_setImageWithURL:url placeholderImage:placeholder options:QukanPopupImageDefault completed:completedBlock];
}

-(void)xh_setImageWithURL:(nonnull NSURL *)url placeholderImage:(nullable UIImage *)placeholder options:(QukanPopupImageOptions)options completed:(nullable XHExternalCompletionBlock)completedBlock{
    [self xh_setImageWithURL:url placeholderImage:placeholder GIFImageCycleOnce:NO options:options GIFImageCycleOnceFinish:nil completed:completedBlock ];
}

- (void)xh_setImageWithURL:(nonnull NSURL *)url placeholderImage:(nullable UIImage *)placeholder GIFImageCycleOnce:(BOOL)GIFImageCycleOnce options:(QukanPopupImageOptions)options GIFImageCycleOnceFinish:(void(^_Nullable)(void))cycleOnceFinishBlock completed:(nullable XHExternalCompletionBlock)completedBlock {
    if(placeholder) self.image = placeholder;
    if(!url) return;
    XHWeakSelf
    [[QukanPopupImageManager sharedManager] loadImageWithURL:url options:options progress:nil completed:^(UIImage * _Nullable image,  NSData *_Nullable imageData, NSError * _Nullable error, NSURL * _Nullable imageURL) {
        if(!error){
            if(XHISGIFTypeWithData(imageData)){
                weakSelf.image = nil;
                weakSelf.animatedImage = [FLAnimatedImage animatedImageWithGIFData:imageData];
                weakSelf.loopCompletionBlock = ^(NSUInteger loopCountRemaining) {
                    if(GIFImageCycleOnce){
                       [weakSelf stopAnimating];
                        QukanPopupLog(@"GIF不循环,播放完成");
                        if(cycleOnceFinishBlock) cycleOnceFinishBlock();
                    }
                };
            }else{
                weakSelf.image = image;
                weakSelf.animatedImage = nil;
            }
        }
        if(completedBlock) completedBlock(image,imageData,error,imageURL);
    }];
}

@end
