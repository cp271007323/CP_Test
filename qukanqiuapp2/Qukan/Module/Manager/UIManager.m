//
//  UIManager.m
//  Qukan
//
//  Created by pfc on 2019/6/17.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import <IQKeyboardManager/IQKeyboardManager.h>

@implementation UIManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static UIManager *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}

- (void)setupUI {
    
    
    [[UINavigationBar appearance] setTintColor:kCommonWhiteColor];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: kCommonWhiteColor, NSFontAttributeName: [UIFont boldSystemFontOfSize:17]}];
    UIImage *image = [UIManager createThemeGradientImageForSize:CGSizeMake(kScreenWidth, 64)];
    [[UINavigationBar appearance] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithPatternImage:image]];

//    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    
    [self setUpIQKeyboard];
    [self setupHUD];
//    [self setLaunchAd];
}

static UIImage *newsPlacehoderImage;
- (UIImage *)newsPlacehoderImage {
    if (!newsPlacehoderImage) {
        UIImage *image = [UIImage imageWithColor:HEXColor(0xDDDDDD) rect:CGRectMake(0, 0, 90, 74)];
        UIImage *img = [image imageByRoundCornerRadius:18 corners:UIRectCornerBottomRight borderWidth:0 borderColor:nil borderLineJoin:kCGLineJoinRound];
        
        newsPlacehoderImage = img;
    }
    
    return newsPlacehoderImage;
}

- (void)setUpIQKeyboard {
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    keyboardManager.enable = YES;
    keyboardManager.shouldResignOnTouchOutside = YES;
    keyboardManager.shouldShowToolbarPlaceholder = YES;
    keyboardManager.placeholderFont = [UIFont systemFontOfSize:12];
    keyboardManager.keyboardDistanceFromTextField = 10.0f;
    keyboardManager.toolbarDoneBarButtonItemText = @"完成";
}

- (void)setupHUD {
    [SVProgressHUD setBorderColor:[UIColor lightGrayColor]];
    [SVProgressHUD setBorderWidth:0.4];
    [SVProgressHUD setMaximumDismissTimeInterval:1.0];
}

- (void)setLaunchAd {
}

+ (NSInteger)imageWithIndex {
    UITabBarController *tabVc = [[UITabBarController alloc] init];
    NSInteger index = tabVc.selectedIndex;
    return index;
}

+ (UIImage *)createThemeGradientImageForSize:(CGSize)imageSize {
    CGRect rect = CGRectMake(0, 0, imageSize.width, imageSize.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = {0.0, 1.0};
    
    UIColor *fromColor = kCommonTextColor;
    UIColor *toColor = kCommonTextColor;
    
    NSArray *colors = @[(__bridge id)fromColor.CGColor, (__bridge id)toColor.CGColor];
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    CGPoint startPoint = CGPointMake(CGRectGetMinX(rect), CGRectGetMidY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMaxX(rect), CGRectGetMidY(rect));
    
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
//    CAGradientLayer *layer = [CAGradientLayer new];
//    layer.colors=@[(__bridge id)HEXColor(0xFF7700).CGColor, (__bridge id)HEXColor(0xFF5500).CGColor];
//    layer.startPoint = CGPointMake(0.0, 0.5);
//    layer.endPoint = CGPointMake(1.0, 0.5);
//    layer.frame = CGRectMake(0.0, 0.0, imageSize.width, imageSize.height);
    
//    return layer;
}


- (void)manageUpWithImage:(UIImage *)image {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    imageView.image = image;
    imageView.backgroundColor = [UIColor clearColor];
}

+ (CALayer *)createGradientLayerForForSize:(CGSize)size {
    CAGradientLayer *layer = [CAGradientLayer new];
    layer.colors=@[(__bridge id)kCommonTextColor.CGColor, (__bridge id)kCommonTextColor.CGColor];
    layer.startPoint = CGPointMake(0.0, 0.5);
    layer.endPoint = CGPointMake(1.0, 0.5);
    layer.frame = CGRectMake(0.0, 0.0, size.width, size.height);

        return layer;
}

+ (CALayer *)createGradientLayerForForSize:(CGSize)size andFromColor:(UIColor *)formColor toColor:(UIColor *)toColor{
    CAGradientLayer *layer = [CAGradientLayer new];
    layer.colors=@[(__bridge id)formColor.CGColor, (__bridge id)toColor.CGColor];
    layer.startPoint = CGPointMake(0.0, 0.5);
    layer.endPoint = CGPointMake(1.0, 0.5);
    layer.frame = CGRectMake(0.0, 0.0, size.width, size.height);
    
    return layer;
}

+ (NSString *)getComonImageNameType:(NSInteger)type {
    NSString *str = @"commonImage";
    if (type == 0) {
        str = @"ImageinviteImageDownImageload";
    }else if (type == 1) {
        str = @"appSImagewitch";
    }else if (type == 2) {
        str = @"gcUserExImagechange";
    }else if (type == 3) {
        str = @"weImagechat/Imagered";
    }else if (type == 4) {
        str = @"home_image";
    }else if (type == 15) {
        str = @"注册Image";
    }else if (type == 5) {
        str = @"taskImage/query";
    }else if (type == 6) {
        str = @"gcUserBadImagege";
    }else if (type == 7) {
        str = @"invite_Imagefriend";
    }else if (type == 8) {
        str = @"loginForTriparImagetite";
    }else if (type == 9) {
        str = @"user_data_image";
    }else if (type == 10) {
        str = @"user_logo_image";
    }else if (type == 11) {
        str = @"exImagechange";
    }else if (type == 12) {
        str = @"exImagechangeSImagecore";
    }else if (type == 13) {
        str = @"exImagechangeRed";
    }else if (type == 14) {
        str = @"loading_png";
    }else if (type == 16) {
        str = @"Image送Image7天";
    }else if (type == 17) {
        str = @"logImageinForTripartite";
    }else if (type == 18) {
        str = @"tranImagesferTime";
    }else if (type == 19) {
        str = @"reImageward";
    }else if (type == 20) {
        str = @"tImageask";
    }else if (type == 21) {
        str = @"weImagechat";
    }else if (type == 22) {
        str = @"static/img/Image";
    }
     
    NSInteger a = [QukanTool Qukan_xuan:kQukan7];
    
    return a == 1 ? [str stringByReplacingOccurrencesOfString:@"Image" withString:@""] : str;
}

@end
