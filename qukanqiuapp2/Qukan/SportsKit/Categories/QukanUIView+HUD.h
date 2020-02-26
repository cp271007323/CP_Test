//
//  QukanUIView+HUD.h
//  UUCityManager
//
//  Created by huanghe on 11/29/16.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface UIView (HUD)

@property (nonatomic, strong) MBProgressHUD *tipHud;
@property (nonatomic, strong) MBProgressHUD *hud;

@property(nonatomic, strong) UIImageView *Qukan_loadingImageView;

- (void)showHUD;
- (void)showHUDWithText:(NSString *)text;
- (void)dismissHUD;

- (void)showTip:(NSString *)text;
- (void)showTip:(NSString *)text bgColor:(UIColor *)color;
- (void)showTip:(NSString *)text delay:(float)delay yOffset: (CGFloat)offset;

- (void)showGif:(NSString *)gifName;
- (void)hideGif;


+ (instancetype)Qukan_initWithXib;
@end
