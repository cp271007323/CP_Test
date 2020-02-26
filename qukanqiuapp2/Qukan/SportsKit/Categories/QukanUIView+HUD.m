//
//  QukanUIView+HUD.m
//  UUCityManager
//
//  Created by huanghe on 11/29/16.
//
//

@implementation UIView (HUD)

static NSString * const kHudTipViewKey = @"kHudViewKey";
static NSString * const kHudViewKey = @"kHudViewKey";

static NSString * const kLoadingViewKey = @"kLoadingViewKey";

- (void)setTipHud:(MBProgressHUD *)tipHud
{
    [self.tipHud hideAnimated:YES afterDelay:2];
    if (tipHud != self.tipHud) {
        objc_setAssociatedObject(self, &kHudTipViewKey, tipHud, OBJC_ASSOCIATION_RETAIN);
    }
}

- (MBProgressHUD *)tipHud
{
    return objc_getAssociatedObject(self, &kHudTipViewKey);
}

- (MBProgressHUD *)hud {
    return objc_getAssociatedObject(self, &kHudViewKey);
}

- (void)setHud:(MBProgressHUD *)hud {
    [self.hud hideAnimated:NO];
    if (hud != self.hud) {
        objc_setAssociatedObject(self, &kHudViewKey, hud, OBJC_ASSOCIATION_RETAIN);
    }
}

- (void)showHUD {
    self.hud = [MBProgressHUD showHUDAddedTo:self animated:true];
    self.hud.bezelView.color = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    self.hud.contentColor = [UIColor whiteColor];
    self.hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
}

- (void)showHUDWithText:(NSString *)text {
    self.hud = [MBProgressHUD showHUDAddedTo:self animated:true];
    self.hud.bezelView.color = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    self.hud.contentColor = [UIColor whiteColor];
    self.hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    self.hud.label.text = text;
}

- (void)dismissHUD {
    [self.hud hideAnimated:YES];
}

- (void)showTip:(NSString *)text {
    [self showTip:text bgColor:nil delay:2.5 yOffset:0];
}

- (void)showTip:(NSString *)text bgColor:(UIColor *)color {
    [self showTip:text bgColor:color delay:2.5 yOffset:0];
}

- (void)showTip:(NSString *)text delay:(float)delay yOffset: (CGFloat)offset {
    [self showTip:text bgColor:nil delay:2.5 yOffset:offset];
}

- (void)showTip:(NSString *)text bgColor:(UIColor *)color delay:(float)delay yOffset: (CGFloat)offset {
    if (text.length <= 0) {
        return;
    }
    
    UIColor *finalColor = color ?: [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    
    self.tipHud = [MBProgressHUD showHUDAddedTo:self animated:true];
    self.tipHud.detailsLabel.text = text;
    self.tipHud.detailsLabel.font = [UIFont systemFontOfSize:14];
    self.tipHud.detailsLabel.textColor = [UIColor redColor];
    self.tipHud.userInteractionEnabled = NO;
    self.tipHud.offset = CGPointMake(self.tipHud.offset.x, self.tipHud.offset.y + delay);
    self.tipHud.mode = MBProgressHUDModeText;
    self.tipHud.bezelView.color = finalColor;
    self.tipHud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    self.tipHud.defaultMotionEffectsEnabled = NO;
    self.tipHud.contentColor = color == nil ? [UIColor whiteColor] : kCommonBlackColor;
    self.tipHud.margin = 10;
    self.tipHud.offset = CGPointMake(0, offset);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tipHud hideAnimated:YES];
    });
}

- (void)setQukan_loadingImageView:(UIImageView *)topic_loadingImageView {
    if (topic_loadingImageView != self.Qukan_loadingImageView) {
        objc_setAssociatedObject(self, &kLoadingViewKey, topic_loadingImageView, OBJC_ASSOCIATION_RETAIN);
    }
}

- (UIImageView *)Qukan_loadingImageView {
    return objc_getAssociatedObject(self, &kLoadingViewKey);
}

- (void)showGif:(NSString *)gifName {
    [self hideGif];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.Qukan_loadingImageView = imageView;
    [self addSubview:imageView];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:gifName ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    UIImage *gifImage = [UIImage imageWithSmallGIFData:data scale:2];
    
    imageView.image = gifImage;
    CGSize size = gifImage.size;
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(size.width);
        make.height.mas_equalTo(size.height);
    }];
}

- (void)hideGif {
    self.Qukan_loadingImageView.hidden = YES;
    [self.Qukan_loadingImageView removeFromSuperview];
    self.Qukan_loadingImageView = nil;
}


+ (instancetype)Qukan_initWithXib {
    UIView *v = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
    v.frame = CGRectMake(0.0, 0.0, CGRectGetWidth([[UIScreen mainScreen] bounds]), CGRectGetHeight(v.frame));
    v.autoresizingMask = UIViewAutoresizingNone;
    return v;
}
@end
