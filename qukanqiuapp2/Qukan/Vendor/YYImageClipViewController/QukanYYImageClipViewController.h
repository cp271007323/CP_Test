//
//  QukanYYImageClipViewController.h
//  QukanYYImageClipViewController
//
//  Created by 杨健 on 16/7/8.
//  Copyright © 2016年 杨健. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QukanYYImageClipViewController;

@protocol YYImageClipDelegate <NSObject>

- (void)imageCropper:(QukanYYImageClipViewController *)clipViewController
         didFinished:(UIImage *)editedImage;
- (void)imageCropperDidCancel:(QukanYYImageClipViewController *)clipViewController;

@end

@interface QukanYYImageClipViewController : UIViewController

@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, weak) id<YYImageClipDelegate> delegate;
@property (nonatomic, assign) CGRect cropFrame;

- (instancetype)initWithImage:(UIImage *)originalImage
                    cropFrame:(CGRect)cropFrame
              limitScaleRatio:(NSInteger)limitRatio;

@end
