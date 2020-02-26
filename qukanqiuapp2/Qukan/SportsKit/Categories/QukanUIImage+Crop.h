//
//  QukanUIImage+Crop.h
//  Qukan
//
//  Created by pfc on 2019/9/4.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Crop)

- (UIImage *)cropImageByScalingAspectFill;

- (UIImage *)lcck_imageByScalingAspectFillWithOriginSize:(CGSize)originSize
                                               limitSize:(CGSize)limitSize;

- (UIImage *)lcck_scaledToSize:(CGSize)newSize;

+ (CGSize)getAspectImageSizeForImageSize:(CGSize)imgSize;


@end

NS_ASSUME_NONNULL_END
