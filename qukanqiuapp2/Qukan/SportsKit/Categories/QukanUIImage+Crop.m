//
//  QukanUIImage+Crop.m
//  Qukan
//
//  Created by pfc on 2019/9/4.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanUIImage+Crop.h"

@implementation UIImage (Crop)

- (UIImage *)cropImageByScalingAspectFill {
    //    CGSize kMaxImageViewSize = {.width = 200, .height = 200};
    CGSize kMaxImageViewSize = {.width = 150, .height = 150};
    CGSize originSize = ({
        CGFloat width = self.size.width;
        CGFloat height = self.size.height;
        CGSize size = CGSizeMake(width, height);
        size;
    });
    UIImage *resizedImage = [self lcck_imageByScalingAspectFillWithOriginSize:originSize limitSize:kMaxImageViewSize];
    return resizedImage;
}

- (UIImage *)lcck_imageByScalingAspectFillWithOriginSize:(CGSize)originSize
                                               limitSize:(CGSize)limitSize {
    if (originSize.width == 0 || originSize.height == 0) {
        return self;
    }
    CGFloat aspectRatio = originSize.width / originSize.height;
    CGFloat width;
    CGFloat height;
    //胖照片
    if (limitSize.width / aspectRatio <= limitSize.height) {
        width = limitSize.width;
        height = limitSize.width / aspectRatio;
    } else {
        //瘦照片
        width = limitSize.height * aspectRatio;
        height = limitSize.height;
    }
    return [self lcck_scaledToSize:CGSizeMake(width, height)];
}

- (UIImage *)lcck_scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (CGSize)getAspectImageSizeForImageSize:(CGSize)imgSize {
    if (CGSizeEqualToSize(CGSizeZero, imgSize)) {
        return CGSizeZero;
    }
    
    CGSize limitSize = CGSizeMake(150, 150);
    
    CGFloat aspectRatio = imgSize.width / imgSize.height;
    CGFloat width;
    CGFloat height;
    //胖照片
    if (limitSize.width / aspectRatio <= limitSize.height) {
        width = limitSize.width;
        height = limitSize.width / aspectRatio;
    } else {
        //瘦照片
        width = limitSize.height * aspectRatio;
        height = limitSize.height;
    }
    
    return CGSizeMake(width, height);
}

@end
