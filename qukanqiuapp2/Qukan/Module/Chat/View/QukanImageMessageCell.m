//
//  QukanImageMessageCell.m
//  Cell
//
//  Created by pfc on 2019/8/15.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "QukanImageMessageCell.h"
#import <UIImageView+YYWebImage.h>
#import "QukanUIImage+Crop.h"

@implementation QukanImageMessageCell

- (void)buildView {
    [super buildView];
    
    _imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _imgView.userInteractionEnabled = YES;
    _imgView.contentMode = UIViewContentModeScaleAspectFit;
    _imgView.layer.cornerRadius = 6;
    _imgView.layer.masksToBounds = YES;
    [self.bubbleView addSubview:_imgView];
}

- (void)configWithMessage:(NIMMessage *)message {
    [super configWithMessage:message];
    
    NIMImageObject *imageObj = (NIMImageObject *)message.messageObject;
    message.messageContentSize = [UIImage getAspectImageSizeForImageSize:imageObj.size];
    
    if (imageObj.thumbPath && [UIImage imageWithContentsOfFile:imageObj.thumbPath]) {
        self.imgView.image = [UIImage imageWithContentsOfFile:imageObj.thumbPath];
    }else {
        @weakify(self)
        [self.imgView setImageWithURL:[NSURL URLWithString:imageObj.url]
                          placeholder:kImageNamed(@"Qukan_placeholder")
                              options:YYWebImageOptionProgressiveBlur | YYWebImageOptionAvoidSetImage progress:nil
                            transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
                                UIImage *img = [image cropImageByScalingAspectFill];
                                return [img imageByRoundCornerRadius:18 corners:UIRectCornerBottomRight borderWidth:0 borderColor:nil borderLineJoin:kCGLineJoinRound];
                            } completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                                @strongify(self)
                                if (image) {
                                    self.imgView.image = image;
                                }
                            }];
    }
    
    [self adjustViewFrame];
}

- (void)adjustViewFrame {
    [super adjustViewFrame];
    
    //    NIMImageObject *imageObj = (NIMImageObject *)self.message.messageObject;
    
    CGFloat indicatX = self.message.isReceivedMsg ? CGRectGetMaxX(self.bubbleView.frame)+5 : CGRectGetMinX(self.bubbleView.frame) - 15;
    self.indicatorView.frame = CGRectMake(indicatX+5,
                                          CGRectGetMidY(self.bubbleView.frame)-10, 20, 20);
    self.resendButton.frame = CGRectMake(indicatX+5, CGRectGetMidY(self.bubbleView.frame)-25/2.0, 25, 25);
    
    CGFloat w = self.contentViewSize.width;
    CGFloat h = self.contentViewSize.height;
    
    if (!self.message.isReceivedMsg) {
        self.imgView.frame = CGRectMake(CGRectGetWidth(self.bubbleView.bounds)-w, 0, w, h);
    }else {
        self.imgView.frame = CGRectMake(5, 0, w, h);
    }
    
    //    CGRect rect = self.imgView.bounds;
    //    self.progressView.frame = CGRectMake(CGRectGetWidth(rect)/2-15, CGRectGetHeight(rect)/2-15, 30, 30);
}

- (CGSize)contentViewSize {
    NIMImageObject *imageObj = (NIMImageObject *)self.message.messageObject;
    if (!CGSizeEqualToSize(CGSizeZero, imageObj.size)) {
        return [UIImage getAspectImageSizeForImageSize:imageObj.size];
    }
    
    return CGSizeMake(80, 100);
}

- (void)tapBubbleAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapImageCellOnMessage:atCell:)]) {
        [self.delegate didTapImageCellOnMessage:self.message atCell:self];
    }
}

- (BOOL)showBubbleImage {
    return NO;
}

- (void)dealloc {
    
}



@end
