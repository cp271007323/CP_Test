//
//  QukanBasketHeaderView.m
//  Qukan
//
//  Created by leo on 2019/9/24.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanBasketDetailHeaderView.h"

#import "QukanBasketTool.h"

#import "QukanMatchInfoModel.h"
// 显示wkwebview

// 视频播放按钮
#import "QukanMatchAniAndVideoView.h"

#import "QukanSharpBgView.h"


// 播放按钮宽度
#define videoPlayBtnWidth  80
// 播放按钮高度
#define videoPlayBtnHeight  28

@interface QukanBasketDetailHeaderView ()<WKNavigationDelegate, WKUIDelegate>

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


/**动画和视频view*/
@property(nonatomic, strong) QukanMatchAniAndVideoView   * view_aniAndVideo;

/**主队底部小图标*/
@property(nonatomic, strong) UILabel   * lab_homeIcon;
/**客队底部小图标*/
@property(nonatomic, strong) UILabel   * lab_awayIcon;


/**主数据模型*/
@property(nonatomic, strong) QukanMatchInfoContentModel  * model_main;

@property(nonatomic, strong) NSString *animateUrl_str;

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



@implementation QukanBasketDetailHeaderView

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
    
    //球队点击
    UIButton *awayTeamBtn = [UIButton new];
    [self addSubview:awayTeamBtn];
    [awayTeamBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.img_awayItemIcon.mas_left).offset(0);
        make.top.mas_equalTo(self.img_awayItemIcon.mas_top).offset(0);
        make.right.mas_equalTo(self.img_awayItemIcon.mas_right).offset(0);
        make.bottom.mas_equalTo(self.lab_awayItemName.mas_bottom).offset(0);
    }];
    awayTeamBtn.tag = Tag_homeTeam;
    [awayTeamBtn addTarget:self action:@selector(btn_teamClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *homeTeamBtn = [UIButton new];
    [self addSubview:homeTeamBtn];
    [homeTeamBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.img_homeItemIcon.mas_left).offset(0);
        make.top.mas_equalTo(self.img_homeItemIcon.mas_top).offset(0);
        make.right.mas_equalTo(self.img_homeItemIcon.mas_right).offset(0);
        make.bottom.mas_equalTo(self.lab_homeItemName.mas_bottom).offset(0);
    }];
    homeTeamBtn.tag = Tag_awayTeam;
    [homeTeamBtn addTarget:self action:@selector(btn_teamClick:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)showAnimationView {  // 展示动画直播视图
    if (self.animateUrl_str.length == 0) {
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


//#pragma mark ===================== model数据处理 ==================================
// //状态：0:未开赛，1:一节，2:二节，3:三节，4:四节，5:1’OT，6:2’OT，7:3’OT，-1:完场, -2:待定，-3:中断，-4:取消，-5:推迟，50:中场
- (void)setData:(QukanBasketBallMatchDetailModel *)model animationUrl:(NSString *)animationUrl {
    if (model == nil) {
        return;
    }
    self.view_showTime.color_fullC = HEXColor(0x7E7E7E);
    
    [self addArcNotifiWithModel:model];
    ///设置队名对标等基本数据
    [self setBaseData:model animationUrl:animationUrl];
    MatchStatus matchStatus = [model getMatchStatus];
    if (matchStatus == NoOpenMatchStatus) { ///未开赛
        [self setNoOpenData:model];
    }
    else if (matchStatus == InMatchStatus ) { ///比赛中
        [self setInMatchData:model];
    } else if (matchStatus == EndMatchStatus) { ///已结束
        [self setEndData:model];
    } else if (matchStatus == UnusualMatchStatus) { ///异常比赛 待定 中断 取消 推迟
        [self setUnusualData:model];
    }
    
    model.animationUrl = animationUrl;
    [self.view_aniAndVideo setDetailDataWithObj:model];

}

- (void)addArcNotifiWithModel:(QukanBasketBallMatchDetailModel *)model{
    @weakify(self);
    [[RACObserve(model, status) takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        MatchStatus matchStatus = [model getMatchStatus];
        if (matchStatus == NoOpenMatchStatus) { ///未开赛
            [self setNoOpenData:model];
        }
        else if (matchStatus == InMatchStatus ) { ///比赛中
            [self setInMatchData:model];
        } else if (matchStatus == EndMatchStatus) { ///已结束
            [self setEndData:model];
        } else if (matchStatus == UnusualMatchStatus) { ///异常比赛 待定 中断 取消 推迟
            [self setUnusualData:model];
        }
    }];
    
    [[RACObserve(model, homeScore) takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
         self.lab_machScore.text = [NSString stringWithFormat:@"%@ - %@",model.guestScore,model.homeScore];
    }];
    
    [[RACObserve(model, guestScore) takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
         self.lab_machScore.text = [NSString stringWithFormat:@"%@ - %@",model.guestScore,model.homeScore];
    }];
}

/// 设置队名队标 联赛名等基本数据
/// @param model model
/// @param animationUrl animationUrl
- (void)setBaseData:(QukanBasketBallMatchDetailModel *)model animationUrl:(NSString *)animationUrl {

    self.animateUrl_str = animationUrl;
    self.lab_homeItemName.text = model.guestTeam;
    self.lab_awayItemName.text = model.homeTeam;
    [self.img_homeItemIcon sd_setImageWithURL:[NSURL URLWithString:model.awayLogo] placeholderImage:kImageNamed(@"Qukan_ke")];
    [self.img_awayItemIcon sd_setImageWithURL:[NSURL URLWithString:model.homeLogo] placeholderImage:kImageNamed(@"Qukan_BSK")];
//    [self. setTitle:model.leagueName forState:UIControlStateNormal];
    self.lab_showTime.text = [[QukanBasketTool sharedInstance] qukan_getStateStrFromState:model.status.integerValue];
}

///// 未开赛数据处理
///// @param model model
- (void)setNoOpenData:(QukanBasketBallMatchDetailModel *)model {
    self.lab_machScore.text = @"";
    self.lab_vs.hidden = NO;
    if (model.matchTime.length > 18){
        self.lab_showTime.text = [model.matchTime substringWithRange:NSMakeRange(5, 11)];
    }else {
        self.lab_showTime.text = model.matchTime;
    }
}

///// 设置比赛中数据
///// @param model model
- (void)setInMatchData:(QukanBasketBallMatchDetailModel *)model {
    self.view_showTime.color_fullC = kThemeColor;
    self.lab_machScore.hidden = NO;
    self.lab_machScore.text = [NSString stringWithFormat:@"%@ - %@",model.guestScore,model.homeScore];
//    self.sectionScoreLab.text = [self sectionScoreString:model];
    if (model.status.integerValue == 50) {
        //中场休息
        self.lab_showTime.text = [self statusString:model.status.integerValue];
    } else {
        self.lab_showTime.text = [NSString stringWithFormat:@"%@",model.remainTime];
    }
//    [self showInMatchButton];
}
//
///// 设置结束数据
///// @param model model
- (void)setEndData:(QukanBasketBallMatchDetailModel *)model {
    self.lab_machScore.hidden = NO;
    self.lab_machScore.text = [NSString stringWithFormat:@"%@-%@",model.guestScore,model.homeScore];
    if ([model.matchTime containsString:[self todayDateStr]] && [model getMatchStatus] != EndMatchStatus) {
        self.lab_showTime.text = model.startTime;
    } else if (model.matchTime.length > 18){
        self.lab_showTime.text = [model.matchTime substringWithRange:NSMakeRange(5, 11)];
    }
}
//
/// 异常比赛 -2:待定，-3:中断，-4:取消，-5:推迟
/// @param model model
- (void)setUnusualData:(QukanBasketBallMatchDetailModel *)model {
    self.lab_vs.text = @"";
    self.lab_showTime.text = [NSString stringWithFormat:@" %@ ",[self statusString:model.status.integerValue]];
}

 //状态：0:未开赛，1:一节，2:二节，3:三节，4:四节，5:1’OT，6:2’OT，7:3’OT，-1:完场, -2:待定，-3:中断，-4:取消，-5:推迟，50:中场
- (NSString *)statusString:(NSInteger)status {
    NSString *statusString;
    switch (status) {
        case 0:
            statusString = @"未开赛";
            break;
        case 1:
            statusString = @"第1节";
            break;
        case 2:
            statusString = @"第2节";
            break;
        case 3:
            statusString = @"第3节";
            break;
        case 4:
            statusString = @"第4节";
            break;
        case 5:
            statusString = @"加时第1节";
            break;
        case 6:
            statusString = @"加时第2节";
            break;
        case 7:
            statusString = @"加时第3节";
            break;
        case -1:
            statusString = @"已结束";
            break;
        case -2:
            statusString = @"比赛待定";
            break;
        case -3:
            statusString = @"比赛中断";
            break;
        case -4:
            statusString = @"比赛取消";
            break;
        case -5:
            statusString = @"比赛推迟";
            break;
        case 50:
            statusString = @"中场休息";
            break;
        default:
            break;
    }
    return statusString;
}
#pragma mark ===================== 点击返回按钮 ==================================
- (void)btn_animationCoverClick:(UIButton *)btn {
    self.bool_isHideState = !self.bool_isHideState;
}

- (void)btn_backAndLSNameClick:(UIButton *)btn {
    if (self.view_animationContent.superview) {
        [self removeAnimationView];
    }else {
        [self backAction];
    }
}

//新增
// 视频按钮点击
- (void)btn_videoPlayClick:(UIButton *)btn{}
// 动画直播按钮点击
- (void)btn_animationPlayClick:(UIButton *)btn{}
// 分享按钮点击
- (void)btn_shareClick:(UIButton *)btn{}

// 导航控制器返回
- (void)backAction{}

//球队点击事件
- (void)btn_teamClick:(NSString *)teamId{}

#pragma mark ===================== 获取今天日期 ==================================
/// 获取今天日期 如:2019-10-10
- (NSString *)todayDateStr {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *nowDate = [NSDate date];
    NSString *todayDateStr = [dateFormatter stringFromDate:nowDate];
    return todayDateStr;
}

#pragma mark ===================== 小节比分显示 ==================================
- (NSString *)sectionScoreString:(QukanBasketBallMatchDetailModel *)model {
    NSString *sectionScoreString;
    switch (model.status.integerValue) {
        case 1:
            sectionScoreString = [NSString stringWithFormat:@"%@ - %@",model.awayScore1,model.homeScore1];
            break;
        case 2:
            sectionScoreString = [NSString stringWithFormat:@"%@ - %@",model.awayScore2,model.homeScore2];
            break;
        case 3:
            sectionScoreString = [NSString stringWithFormat:@"%@ - %@",model.awayScore3,model.homeScore3];
            break;
        case 4:
            sectionScoreString = [NSString stringWithFormat:@"%@ - %@",model.awayScore4,model.homeScore4];
            break;
        case 50:
            sectionScoreString = @"";
            break;
        case 5:
            sectionScoreString = [NSString stringWithFormat:@"%@ - %@",model.awayOtScore,model.homeOtScore];
            break;
        case 6:
            sectionScoreString = [NSString stringWithFormat:@"%@ - %@",model.awayOtScore,model.homeOtScore];
            break;
        case 7:
            sectionScoreString = [NSString stringWithFormat:@"%@ - %@",model.awayOtScore,model.homeOtScore];
            break;
        default:
            break;
    }
    return sectionScoreString;
}

#pragma mark ===================== 点击webView ==================================
- (void)coverButtonClick {
    self.bool_isHideState = !self.bool_isHideState;
}


#pragma mark ===================== 点击动画直播 ==================================
- (void)animateLiveClick {
    [self btn_animationPlayClick:self.btn_animationCover];
    [self showAnimationView];
    if (self.clickAnimate) {
        self.clickAnimate();
    }
    self.webV_animation.hidden = NO;
    //sw--h5页面宽度,sh--h5页面高度
    NSString *urlString = [NSString stringWithFormat:@"%@&sw=%f&sh=%f",_animateUrl_str,self.webV_animation.width,self.webV_animation.height];
    [self.webV_animation loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
}
#pragma mark ===================== kvo代理监听 ==================================

// 动画直播监听进度条的进度
- (void)setProgressVWithProgress:(CGFloat)progress {
    self.progress_animationWeb.progress = progress;
    self.progress_animationWeb.hidden = (progress == 1);
}


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
        _img_homeItemIcon.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _img_homeItemIcon;
}

- (UILabel *)lab_homeItemName {  // 主队队名
    if (!_lab_homeItemName) {
        _lab_homeItemName = [[UILabel alloc] initWithFrame:CGRectZero];
        _lab_homeItemName.text = @"--";
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
        _img_awayItemIcon.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _img_awayItemIcon;
}

- (UILabel *)lab_awayItemName {  // 客队队名
    if (!_lab_awayItemName) {
        _lab_awayItemName = [[UILabel alloc] initWithFrame:CGRectZero];
        _lab_awayItemName.text = @"--";
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
        _lab_machScore.font = [UIFont fontWithName:@"DINAlternate-Bold" size:28];
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
        _webV_animation.hidden = YES;
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
            [self animateLiveClick];
        };
        _view_aniAndVideo.hidden = YES;
    };
    return _view_aniAndVideo;
}

- (UILabel *)lab_homeIcon {
    if (!_lab_homeIcon) {
        _lab_homeIcon = [UILabel new];
        _lab_homeIcon.text = @"客";
        _lab_homeIcon.textColor = kCommonWhiteColor;
        _lab_homeIcon.font = [UIFont systemFontOfSize:8];
        _lab_homeIcon.backgroundColor = HEXColor(0x00B24E);
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
        _lab_awayIcon.text = @"主";
        _lab_awayIcon.textColor = kCommonWhiteColor;
        _lab_awayIcon.font = [UIFont systemFontOfSize:8];
        _lab_awayIcon.backgroundColor = kThemeColor;
        _lab_awayIcon.layer.masksToBounds = YES;
        _lab_awayIcon.layer.cornerRadius = 6;
        _lab_awayIcon.layer.borderColor = kCommonBlackColor.CGColor;
        _lab_awayIcon.layer.borderWidth = 1;
        _lab_awayIcon.textAlignment = NSTextAlignmentCenter;
    }
    return _lab_awayIcon;
}

@end
