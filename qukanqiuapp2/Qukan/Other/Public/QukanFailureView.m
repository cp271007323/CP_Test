
@interface QukanFailureView()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *CenterY;
@end
@implementation QukanFailureView

- (void)awakeFromNib {
    [super awakeFromNib];
    UIView *v = [self viewWithTag:99];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Qukan_viewClick)];
    [v addGestureRecognizer:tapGestureRecognizer];
}

+ (void)Qukan_showWithView:(UIView *)view
                   centerY:(CGFloat)centerY
                     block:(void(^)(void))block {
    QukanFailureView *v = [QukanFailureView Qukan_initWithXib];
    v.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(v.frame), CGRectGetHeight([[UIScreen mainScreen] bounds]));
    [view addSubview:v];
    v.CenterY.constant = centerY;
    if (block) {
        v.Qukan_didBlock = ^{
            block();
        };
    }
}

+ (void)Qukan_showWithView:(UIView *)view
                         Y:(CGFloat)Y
                       top:(CGFloat)top
                     block:(void(^)(void))block {
    QukanFailureView *v = [QukanFailureView Qukan_initWithXib];
    [view addSubview:v];
    v.CenterY.constant = top;
    if (block) {
        v.Qukan_didBlock = ^{
            block();
        };
    }
    [v mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(view);
        make.top.mas_equalTo(Y);
    }];
}

+ (QukanFailureView *)topic_showWithView:(UIView *)view
                                 centerY:(CGFloat)centerY
                                   block:(void(^)(void))block {
    
    QukanFailureView *v = [QukanFailureView Qukan_initWithXib];
    v.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(v.frame), CGRectGetHeight([[UIScreen mainScreen] bounds]));
    [view addSubview:v];
    v.CenterY.constant = centerY;
    if (block) {
        v.Qukan_didBlock = ^{
            block();
        };
    }
    
    return v;
}

+ (QukanFailureView *)topic_showWithView:(UIView *)view
                                       Y:(CGFloat)Y
                                     top:(CGFloat)top
                                   block:(void(^)(void))block {
    
    QukanFailureView *v = [QukanFailureView Qukan_initWithXib];
    [view addSubview:v];
    v.CenterY.constant = top;
    if (block) {
        v.Qukan_didBlock = ^{
            block();
        };
    }
    
    [v mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(view);
        make.top.mas_equalTo(Y);
    }];
    
    return v;
}

+ (void)Qukan_hideWithView:(UIView *)view {
    for (UIView *v in view.subviews) {
        if ([v isKindOfClass:[QukanFailureView class]]) {
            [v removeFromSuperview];
        }
    }
}

- (void)Qukan_viewClick {
    if (self.Qukan_didBlock) {
        self.Qukan_didBlock();
    }
}

@end
