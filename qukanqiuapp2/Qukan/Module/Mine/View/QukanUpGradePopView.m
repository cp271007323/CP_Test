#import "QukanUpGradePopView.h"
#import "UIImage+ImageEffects.h"

@interface QukanUpGradePopView()

@property(nonatomic, copy) NSString   * appstoreNewVersionUrl;
@property(nonatomic, copy) NSString *info;
@property(nonatomic, assign) BOOL   isForce;

@property (strong, nonatomic) UIImageView *backgroundView;
@property (strong, nonatomic) UIView *whiteContentView;
@property(nonatomic, strong) UIImageView   * rokectImageV;
@property(nonatomic, strong) UIImageView   * winBgImageV;
@property(nonatomic, strong) UIButton   * closeButton;
@property(nonatomic, strong) UIButton   * upgradeButton;

@property(nonatomic, strong) UILabel   * titleLabel;
@property(nonatomic, strong) UILabel   * secondTitleLabel;
@property(nonatomic, strong) UILabel *infoLabel;

//@property(nonatomic, strong) UILabel   * tipLabel;
@end

@implementation QukanUpGradePopView

- (instancetype)initWithFrame:(CGRect)frame upgradeUrl:(NSString*)appstoreUrl isForce:(BOOL)force info:(NSString *)upInfo{
    self = [super initWithFrame:frame];
    self.appstoreNewVersionUrl = appstoreUrl;
    self.isForce = force;
    self.info = upInfo;
    [self addSubviews];
    return self;
}

- (void)addSubviews {
    [kKeyWindow addSubview:self];
    self.userInteractionEnabled = YES;
    
    [self addSubview:self.backgroundView = [UIImageView new]];
    [self addSubview:self.whiteContentView = [UIView new]];
    [self addSubview:self.winBgImageV = [UIImageView new]];
    [self addSubview:self.rokectImageV = [UIImageView new]];
    [self addSubview:self.closeButton = [UIButton new]];
    [self addSubview:self.upgradeButton = [UIButton new]];
    [self addSubview:self.titleLabel = [UILabel new]];
    [self addSubview:self.secondTitleLabel = [UILabel new]];
    [self addSubview:self.infoLabel = [UILabel new]];

    [_backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self makeBlurBackground];
    
    [_whiteContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(kScaleScreen(454));
    }];
    
    _whiteContentView.backgroundColor = kCommonWhiteColor;
    _whiteContentView.layer.masksToBounds = YES;
    _whiteContentView.layer.cornerRadius = 18;
    [_winBgImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(self.whiteContentView);
        make.height.mas_equalTo(kScaleScreen(277));
    }];
    
    _winBgImageV.image = kImageNamed(@"up_bk");
    _winBgImageV.contentMode = UIViewContentModeScaleAspectFill;
    _winBgImageV.layer.masksToBounds = YES;
    _winBgImageV.layer.cornerRadius = 18;
    [_rokectImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(68);
        make.height.mas_equalTo(131);
        make.top.mas_equalTo(self.whiteContentView).offset(-40);
    }];
    
    _rokectImageV.image = kImageNamed(@"up_rocket");
    UIView* lineView = [UIView new];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.whiteContentView).offset(-25);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(1);
        make.bottom.mas_equalTo(self.whiteContentView.mas_top);
    }];
    
    lineView.backgroundColor = kCommonWhiteColor;
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(lineView);
        make.width.height.mas_equalTo(30);
        make.bottom.mas_equalTo(lineView.mas_top).offset(3);
    }];
    
    [_closeButton setImage:kImageNamed(@"up_close") forState:UIControlStateNormal];
    lineView.hidden = self.isForce;
    _closeButton.hidden = self.isForce;
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.rokectImageV.mas_bottom).offset(10);
    }];
    
    _titleLabel.text = @"发现新版本";
    _titleLabel.textColor = kCommonWhiteColor;
    _titleLabel.font = [UIFont boldSystemFontOfSize:22];
    [_secondTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.top.mas_equalTo(self.winBgImageV.mas_bottom).offset(-120);
    }];
    
    _secondTitleLabel.text = @"更新内容";
    _secondTitleLabel.textColor = kCommonBlackColor;
    _secondTitleLabel.font = [UIFont boldSystemFontOfSize:18];
    
    _infoLabel.text = _info;
    _infoLabel.numberOfLines = 0;
//    _infoLabel.backgroundColor = RGBSAMECOLOR(240);
    _infoLabel.textColor = UIColor.grayColor;
    _infoLabel.font = kFont14;
    [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.top.mas_equalTo(self.secondTitleLabel.mas_bottom).offset(5);
        make.right.mas_equalTo(self.whiteContentView).offset(-15);
        make.bottom.mas_equalTo(self.whiteContentView).offset(-85);
    }];
    

    [_upgradeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(45);
        make.right.mas_equalTo(-45);
        make.height.mas_equalTo(50);
        make.bottom.mas_equalTo(self.whiteContentView).offset(-15);
    }];
    
    [_upgradeButton setTitle:@"立即更新" forState:UIControlStateNormal];
    _upgradeButton.titleLabel.textColor = kCommonWhiteColor;
    _upgradeButton.titleLabel.font =  [UIFont boldSystemFontOfSize:20];
    _upgradeButton.backgroundColor = kThemeColor;
    _upgradeButton.layer.masksToBounds = YES;
    _upgradeButton.layer.cornerRadius = 18;

    [[_closeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        self.hidden = YES;
    }];
    [[_upgradeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.appstoreNewVersionUrl]];
        self.hidden = YES;
    }];
}

-(UIImage *)screenImageWithSize:(CGSize )imgSize{
    UIGraphicsBeginImageContext(imgSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [kKeyWindow.layer renderInContext:context];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (void)makeBlurBackground
{
    UIImage *image = [self screenImageWithSize:kKeyWindow.bounds.size];
    UIImage *blurSnapshotImage = [image applyBlurWithRadius:5.0f
                                                  tintColor:[UIColor colorWithWhite:0.2f
                                                                              alpha:0.7f]
                                      saturationDeltaFactor:1.8f
                                                  maskImage:nil];
    _backgroundView.image = blurSnapshotImage;
    _backgroundView.alpha = 1.0f;
}

@end
