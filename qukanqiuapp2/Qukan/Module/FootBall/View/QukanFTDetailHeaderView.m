//
//  QukanFTDetailHeaderView.m
//  Qukan
//
//  Created by leo on 2019/10/17.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanFTDetailHeaderView.h"
// 主模型
#import "QukanMatchInfoModel.h"
// 显示wkwebview
#import <WebKit/WebKit.h>

// 视频播放按钮
#import "QukanMatchAniAndVideoView.h"

#import "QukanSharpBgView.h"

@interface QukanFTDetailHeaderView ()

/**背景图片*/
@property(nonatomic, strong) UIImageView   * img_bg;

/**二层背景图*/
@property(nonatomic, strong) UIImageView   * img_secendBg;

/**主队图标*/
@property(nonatomic, strong) UIImageView   * img_homeItemIcon;
/**客队图标*/
@property(nonatomic, strong) UIImageView   * img_awayItemIcon;

/**主队队名*/
@property(nonatomic, strong) UILabel       * lab_homeItemName;
/**客队队名*/
@property(nonatomic, strong) UILabel       * lab_awayItemName;

/**比分lab*/
@property(nonatomic, strong) UILabel       * lab_machScore;

/**VSlab*/
@property(nonatomic, strong) UILabel       * lab_vs;

/**中间显示时间的lab*/
@property(nonatomic, strong) UILabel       * lab_showTime;
/**时间lab的底部背景蒙层*/
@property(nonatomic, strong) QukanSharpBgView    * view_showTime;


/**主队底部小图标*/
@property(nonatomic, strong) UILabel   * lab_homeIcon;
/**客队底部小图标*/
@property(nonatomic, strong) UILabel   * lab_awayIcon;

/**动画和视频view*/
@property(nonatomic, strong) QukanMatchAniAndVideoView   * view_aniAndVideo;
/**主数据模型*/
@property(nonatomic, strong) QukanMatchInfoContentModel  * model_main;

#pragma mark ===================== webView ==================================

// webView进度条
@property (nonatomic, strong) UIProgressView *progress_animationWeb;

// 管理webView相关
@property (nonatomic, strong) UIView *view_animationContent;

// 动画webView
@property (nonatomic, strong) WKWebView *webV_animation;

// webview点击按钮  用于控制状态栏显示隐藏
@property (nonatomic, strong) UIButton *btn_animationCover;

@end

@implementation QukanFTDetailHeaderView


#pragma mark ===================== 生命周期 ==================================
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)dealloc {  // QukanFTDetailHeaderView 释放
    NSLog(@"QukanFTDetailHeaderView 释放");
}

#pragma mark ===================== UI布局 ==================================
- (void)initUI {
    [self addSubview:self.img_bg];   //背景图片
    [self.img_bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self addSubview:self.img_secendBg];  // 二层背景图
    [self.img_secendBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-50);
    }];
    
    [self addSubview:self.img_homeItemIcon];   // 主队图标
    [self.img_homeItemIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.img_secendBg.mas_top);
        make.right.equalTo(self.mas_centerX).offset(-85);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    [self addSubview:self.lab_homeItemName];  // 主队队名
    [self.lab_homeItemName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.img_homeItemIcon);
        make.top.equalTo(self.img_homeItemIcon.mas_bottom).offset(5);
//        make.left.equalTo(self).offset(40 * screenScales);
        make.width.equalTo(@(65));
    }];
    
    [self addSubview:self.lab_homeIcon];
    [self.lab_homeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.img_homeItemIcon);
        make.left.equalTo(self.img_homeItemIcon.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(12, 12));
    }];
    
    
    [self addSubview:self.img_awayItemIcon];  // 客队图标
    [self.img_awayItemIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_centerX).offset(85);
        make.centerY.equalTo(self.img_homeItemIcon);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    [self addSubview:self.lab_awayItemName];  // 客队队名
    [self.lab_awayItemName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.img_awayItemIcon);
        make.top.equalTo(self.img_awayItemIcon.mas_bottom).offset(5);
        make.width.equalTo(@(65));
    }];
    
    
    [self addSubview:self.lab_awayIcon];
    [self.lab_awayIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.img_awayItemIcon);
        make.right.equalTo(self.img_awayItemIcon.mas_left).offset(-5);
        make.size.mas_equalTo(CGSizeMake(12, 12));
    }];
    
    
    [self addSubview:self.lab_machScore];   // 比分lab
    [self.lab_machScore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.img_secendBg);
        make.centerX.equalTo(self);
    }];
    
    [self addSubview:self.lab_vs];
    [self.lab_vs mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.img_secendBg);
        make.centerX.equalTo(self);
    }];
    
    
    [self addSubview:self.view_showTime];  // 时间lab的底部背景蒙层
    [self.view_showTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.img_secendBg.mas_top).offset(2);
        make.size.mas_equalTo(CGSizeMake(120, 33));
    }];
    
    
    [self.view_showTime addSubview:self.lab_showTime];  // 中间显示时间的lab
    [self.lab_showTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view_showTime);
    }];
 
    
    [self addSubview:self.view_aniAndVideo];
    [self.view_aniAndVideo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-20);
        make.size.mas_equalTo(CGSizeMake(150, 27));
    }];
}


- (void)showAnimationView {  // 展示动画直播视图
    if (self.url_animation.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"获取直播地址错误"];
        return;
    }

    self.view_animationContent.hidden = NO;
    [self addSubview:self.view_animationContent];   // 动画直播的主视图
    [self.view_animationContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.view_animationContent addSubview:self.webV_animation];   // 动画直播的网页
    [self.webV_animation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view_animationContent);
        make.top.equalTo(self.view_animationContent).offset(kStatusBarHeight);
    }];
    
    [self.view_animationContent addSubview:self.progress_animationWeb];  // 进度条
    [self.progress_animationWeb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view_animationContent);
    }];
    
    [self.view_animationContent addSubview:self.btn_animationCover];  // webview点击按钮  用于控制状态栏显示隐藏
    [self.btn_animationCover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view_animationContent);
        make.top.equalTo(self.view_animationContent).offset(kStatusBarHeight);
    }];
}

// 开始加载动画直播网页
- (void)startAnimationPlay {
    //sw--h5页面宽度,sh--h5页面高度
    NSString *urlString = [NSString stringWithFormat:@"%@&sw=%f&sh=%f",self.url_animation, self.webV_animation.width,self.webV_animation.height];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [self.webV_animation loadRequest:request];
}

// 隐藏动画直播
- (void)removeAnimationView {
    [self HidenAnimation];
    [self.view_animationContent removeAllSubviews];
    [self.view_animationContent removeFromSuperview];
}

- (void)HidenAnimation {}

#pragma mark ===================== function ==================================
// 赋值
- (void)fullViewWithModel:(QukanMatchInfoContentModel *)model {
    self.model_main = model;
    
    // 添加比分数据和时间的监控
    [self setRACObsever];
    
    // 设置主队名队标
    [self.img_homeItemIcon sd_setImageWithURL:[NSURL URLWithString:model.flag1] placeholderImage:kImageNamed(@"Qukan_Hot_Default0")];
    self.lab_homeItemName.text = model.home_name;
    
    // 设置客队队名队标
    [self.img_awayItemIcon sd_setImageWithURL:[NSURL URLWithString:model.flag2] placeholderImage:kImageNamed(@"Qukan_Hot_Default1")];
    self.lab_awayItemName.text = model.away_name;
    
    // 设置和状态相关的布局
    [self setDataAboutMatchStata];
}


- (void)setSubviewAlaphWithProgress:(CGFloat)progress {
    self.img_homeItemIcon.alpha = progress;
    self.img_awayItemIcon.alpha = progress;
    self.lab_homeItemName.alpha = progress;
    self.lab_awayItemName.alpha = progress;
    self.lab_machScore.alpha = progress;
    self.lab_showTime.alpha = progress;
    self.view_showTime.alpha = progress;
    self.img_secendBg.alpha = progress;
    self.view_aniAndVideo.alpha = progress;
    self.lab_homeIcon.alpha = progress;
    self.lab_awayIcon.alpha = progress;
}

// 设置和状态相关的布局
- (void)setDataAboutMatchStata {
    // 设置比赛状态和经历时间
    if ([self selfMatchStateWhenPlaying]) { // 若是正在打的比赛  设置时间为比赛经历时间
        self.view_showTime.color_fullC = kThemeColor;
        [self setLab_dataWhenIsMatching];
    }else {  // 若不是正在打的比赛  设置时间为match_time
        self.view_showTime.color_fullC = HEXColor(0x7E7E7E);
//        self.lab_showTime.text = self.model_main.match_time.length > 11 ? [self.model_main.match_time substringFromIndex:11] : self.model_main.match_time;
        self.lab_showTime.text = (self.model_main.start_time.length && self.model_main.start_time.length >= 16) ? [self.model_main.start_time substringWithRange:NSMakeRange(5, 11)] : self.model_main.start_time;

    }
    
    // 设置比分
    self.lab_machScore.text = [NSString stringWithFormat:@"%zd - %zd", self.model_main.home_score, self.model_main.away_score];
    
    // 设置vs图片和比分信息的显示和隐藏  正在打或者已结束的比赛显示
    BOOL isMatchNoStart = [self selfMatchStateWhenPlaying] || self.model_main.state == -1;
    self.lab_machScore.hidden = !isMatchNoStart;
    self.lab_vs.hidden = isMatchNoStart;
    
    [self.view_aniAndVideo setDetailDataWithObj:self.model_main];
}

// 正在打的比赛  设置时间lab
- (void)setLab_dataWhenIsMatching {
    // 获取比赛时间和状态组合字符串
    NSString *str_dataBegin = [NSString stringWithFormat:@" %@ %@'",[self selfMatchStateWhenPlaying],self.model_main.pass_time.length> 0?self.model_main.pass_time:@""];
    // 获取比赛时间和状态组合可变字符串
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str_dataBegin];
    // 获取到时间的范围
//    NSRange range = [str_dataBegin rangeOfString:[NSString stringWithFormat:@"%@'",self.model_main.pass_time]];
    // 改变文字颜色
//    [attributedString addAttribute:NSForegroundColorAttributeName value:HEXColor(0xf6c884) range:range];
    
    
    // 设置时间显示
    self.lab_showTime.attributedText = attributedString;
}

// 添加比赛状态监听
- (void)setRACObsever {
    if ([self selfMatchStateWhenPlaying]) {
        @weakify(self);
        [[RACObserve(self.model_main, away_score) takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
           self.lab_machScore.text = [NSString stringWithFormat:@"%zd - %zd", self.model_main.home_score, self.model_main.away_score];
        }];
        
        [[RACObserve(self.model_main, home_score) takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            self.lab_machScore.text = [NSString stringWithFormat:@"%zd - %zd", self.model_main.home_score, self.model_main.away_score];
        }];
        
        
        [[RACObserve(self.model_main, pass_time) takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self setLab_dataWhenIsMatching];
        }];
        
        [[RACObserve(self.model_main, state) takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self setDataAboutMatchStata];
        }];
    }
}


#pragma mark ===================== privet fuction ==================================
// 正在比赛 时的状态
//比赛状态 0:未开 1:上半场 2:中场 3:下半场 4 加时，-11:待定 -12:腰斩 -13:中断 -14:推迟 -1:完场，-10取消”
- (NSString *)selfMatchStateWhenPlaying {
    if (self.model_main) {
        switch (self.model_main.state) {
            case 1:
                return @"上半场";
                break;
            case 2:
                return @"";
                break;
            case 3:
                return @"下半场";
                break;
            case 4:
                return @"加时";
                break;
            default:
                return nil;
                break;
        }
    }
    return nil;
}


// 动画直播监听进度条的进度
- (void)setProgressVWithProgress:(CGFloat)progress {
    self.progress_animationWeb.progress = progress;
    self.progress_animationWeb.hidden = (progress == 1);
}

#pragma mark ===================== action ==================================
// 视频按钮点击
- (void)btn_videoPlayClick:(UIButton *)btn {
}
// 动画直播按钮点击
- (void)btn_animationPlayClick:(UIButton *)btn {
    [self showAnimationView];
    [self startAnimationPlay];
}
// 分享按钮点击
- (void)btn_shareClick:(UIButton *)btn {
}

// 返回按钮点击
- (void)btn_backAndLSNameClick:(UIButton *)btn {
    if (self.view_animationContent.superview) {
        [self removeAnimationView];
    }else {
        [self backAction];
    }
}

- (void)btn_animationCoverClick:(UIButton *)btn {
    self.bool_isHideState = !self.bool_isHideState;
}

// 导航栏返回事件
- (void)backAction {
}

- (void)homeLogoClick {}
- (void)awayLogoClick {}

#pragma mark ===================== lazy懒加载 ==================================
- (UIImageView *)img_bg {  //背景图片
    if (!_img_bg) {
        _img_bg = [[UIImageView alloc] initWithFrame:CGRectZero];
        _img_bg.image = [UIImage imageNamed:@"Qukan_play_background"];
    }
    return _img_bg;
}


- (UIImageView *)img_secendBg {  //二层背景图
    if (!_img_secendBg) {
        _img_secendBg = [[UIImageView alloc] initWithFrame:CGRectZero];
        _img_secendBg.image = [UIImage imageNamed:@"footerHeader_Bg"];
    }
    return _img_secendBg;
}


- (UIImageView *)img_homeItemIcon { // 主队图标
    if (!_img_homeItemIcon) {
        _img_homeItemIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        _img_homeItemIcon.image = kImageNamed(@"Qukan_Hot_Default0");
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(homeLogoClick)];
        _img_homeItemIcon.userInteractionEnabled = YES;
        [_img_homeItemIcon addGestureRecognizer:tap];
        _img_homeItemIcon.contentMode = UIViewContentModeScaleAspectFit;
        
    }
    return _img_homeItemIcon;
}

- (UILabel *)lab_homeItemName {  // 主队队名
    if (!_lab_homeItemName) {
        _lab_homeItemName = [[UILabel alloc] initWithFrame:CGRectZero];
        _lab_homeItemName.text = @"主队队名";
        _lab_homeItemName.textColor = kCommonBlackColor;
        _lab_homeItemName.numberOfLines = 2;
        _lab_homeItemName.font = [UIFont systemFontOfSize:12];
        _lab_homeItemName.textAlignment = NSTextAlignmentCenter;
    }
    return _lab_homeItemName;
}


- (UIImageView *)img_awayItemIcon { // 客队图标
    if (!_img_awayItemIcon) {
        _img_awayItemIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        _img_awayItemIcon.image = kImageNamed(@"Qukan_Hot_Default1");
        _img_awayItemIcon.contentMode = UIViewContentModeScaleAspectFit;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(awayLogoClick)];
        _img_awayItemIcon.userInteractionEnabled = YES;
        [_img_awayItemIcon addGestureRecognizer:tap];
    }
    return _img_awayItemIcon;
}

- (UILabel *)lab_awayItemName {  // 客队队名
    if (!_lab_awayItemName) {
        _lab_awayItemName = [[UILabel alloc] initWithFrame:CGRectZero];
        _lab_awayItemName.text = @"客队队名";
        _lab_awayItemName.font = [UIFont systemFontOfSize:12];
        _lab_awayItemName.numberOfLines = 2;
        _lab_awayItemName.textColor = kCommonBlackColor;
        _lab_awayItemName.textAlignment = NSTextAlignmentCenter;
    }
    return _lab_awayItemName;
}


- (UILabel *)lab_machScore {  // 比分lab
    if (!_lab_machScore) {
        _lab_machScore = [[UILabel alloc] initWithFrame:CGRectZero];
        _lab_machScore.hidden = YES;
        _lab_machScore.font = [UIFont boldSystemFontOfSize:30];
        _lab_machScore.textColor = kCommonWhiteColor;
        _lab_machScore.text = @"- - -";
    }
    return _lab_machScore;
}

- (UILabel *)lab_vs {
    if (!_lab_vs) {
        _lab_vs = [[UILabel alloc] initWithFrame:CGRectZero];
        _lab_vs.hidden = YES;
        _lab_vs.font = [UIFont boldSystemFontOfSize:30];
        _lab_vs.textColor = kCommonWhiteColor;
        _lab_vs.text = @"VS";
    }
    return _lab_vs;
}

- (UILabel *)lab_showTime { // 中间显示时间的lab
    if (!_lab_showTime) {
        _lab_showTime = [[UILabel alloc] initWithFrame:CGRectZero];
        _lab_showTime.font = kFont14;
        _lab_showTime.textColor = kCommonWhiteColor;
        _lab_showTime.text = @"------";
    }
    return _lab_showTime;
}

- (QukanSharpBgView *)view_showTime { // 时间lab的底部背景蒙层
    if (!_view_showTime) {
        _view_showTime = [[QukanSharpBgView alloc] initWithFrame:CGRectMake(0, 0, 30, 20) type:QukanSharpBgViewTypeLeftBottomAndRightBottom AndOffset:15 andFullColor:HEXColor(0x7E7E7E)];
        
        [_view_showTime setLayerShadow:COLOR_HEX(0x000000,0.8) offset:CGSizeMake(0, 0) radius:0.5];
    }
    return _view_showTime;
}

- (UIView *)view_animationContent {  // 管理webView相关
    if (!_view_animationContent) {
        _view_animationContent = [UIView new];
        _view_animationContent.backgroundColor = kCommonBlackColor;
        _view_animationContent.hidden = YES;
    }
    return _view_animationContent;
}

- (WKWebView *)webV_animation {  // 动画webView
    if (!_webV_animation) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        _webV_animation = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
        
        if (@available(iOS 11.0, *)) {
            _webV_animation.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        
        _webV_animation.scrollView.scrollEnabled = NO;
        @weakify(self);
        [[[_webV_animation rac_valuesForKeyPath:@"estimatedProgress" observer:self] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            NSNumber *p = x;
            [self setProgressVWithProgress:p.floatValue];
        }];
    }
    return _webV_animation;
}

- (UIProgressView *)progress_animationWeb {  // webView进度条
    if (!_progress_animationWeb) {
        _progress_animationWeb = [UIProgressView new];
        _progress_animationWeb.tintColor = kThemeColor;
    }
    return _progress_animationWeb;
}

- (UIButton *)btn_animationCover {  // webview点击按钮  用于控制状态栏显示隐藏
    if (!_btn_animationCover) {
        _btn_animationCover = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn_animationCover.backgroundColor = UIColor.clearColor;
        
        [_btn_animationCover addTarget:self action:@selector(btn_animationCoverClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn_animationCover;
}

- (QukanMatchAniAndVideoView *)view_aniAndVideo {
    if (!_view_aniAndVideo) {
        _view_aniAndVideo = [[QukanMatchAniAndVideoView alloc] initWithFrame:CGRectMake(0, 0, 130, 27)];
        _view_aniAndVideo.layer.masksToBounds = YES;
        _view_aniAndVideo.layer.cornerRadius = 27 / 2;
        @weakify(self)
        _view_aniAndVideo.videoBtnCilckBolck = ^{
            @strongify(self)
            [self btn_videoPlayClick:UIButton.new];
        };
        
        _view_aniAndVideo.animationBtnCilckBolck = ^{
            @strongify(self)
            [self btn_animationPlayClick:UIButton.new];
        };
    };
    return _view_aniAndVideo;
}

- (UILabel *)lab_homeIcon {
    if (!_lab_homeIcon) {
        _lab_homeIcon = [UILabel new];
        _lab_homeIcon.text = @"主";
        _lab_homeIcon.textColor = kCommonWhiteColor;
        _lab_homeIcon.font = [UIFont systemFontOfSize:8];
        _lab_homeIcon.backgroundColor = kThemeColor;
        _lab_homeIcon.layer.masksToBounds = YES;
        _lab_homeIcon.layer.cornerRadius = 6;
        _lab_homeIcon.layer.borderColor = kCommonBlackColor.CGColor;
        _lab_homeIcon.layer.borderWidth = 1;
        _lab_homeIcon.textAlignment = NSTextAlignmentCenter;
    }
    return _lab_homeIcon;
}

- (UILabel *)lab_awayIcon {
    if (!_lab_awayIcon) {
        _lab_awayIcon = [UILabel new];
        _lab_awayIcon.text = @"客";
        _lab_awayIcon.textColor = kCommonWhiteColor;
        _lab_awayIcon.font = [UIFont systemFontOfSize:8];
        _lab_awayIcon.backgroundColor = HEXColor(0x00B24E);
        _lab_awayIcon.layer.masksToBounds = YES;
        _lab_awayIcon.layer.cornerRadius = 6;
        _lab_awayIcon.layer.borderColor = kCommonBlackColor.CGColor;
        _lab_awayIcon.layer.borderWidth = 1;
        _lab_awayIcon.textAlignment = NSTextAlignmentCenter;
    }
    return _lab_awayIcon;
}

@end
