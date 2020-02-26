//
//  UIManager.h
//  Qukan
//
//  Created by pfc on 2019/6/17.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define kUIManager [UIManager sharedInstance]
#define kGetImageType(type) [UIManager getComonImageNameType:type]
@interface UIManager : NSObject

+ (instancetype)sharedInstance;

//@property(nonatomic, strong, readonly) UIImage *newsPlacehoderImage;

@property(nonatomic, copy) UIView *mask;
@property(nonatomic, strong) UIColor *badgeColor;

- (void)setupUI;

+ (UIImage *)createThemeGradientImageForSize:(CGSize)imageSize;

+ (CALayer *)createGradientLayerForForSize:(CGSize)size;

- (UIImage *)newsPlacehoderImage;

+ (CALayer *)createGradientLayerForForSize:(CGSize)size andFromColor:(UIColor *)formColor toColor:(UIColor *)toColor;

+ (NSString *)getComonImageNameType:(NSInteger)type;

@end

NS_ASSUME_NONNULL_END
