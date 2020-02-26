

// 足球比赛详情
#import "QukanDetailsViewController.h"
// 聊天vc
#import "QukanLiveChatViewController.h"
// 赛况vc
#import "QukanMatchSituationViewController.h"

// 阵容
#import "QukanLineupViewController.h"
//战报
//#import "QukanBattlefieldReportViewController.h"
// 详情数据
#import "QukanFTMatchDetailDataVC.h"

// 详情头部视图
#import "QukanFTDetailHeaderView.h"

// 投屏设备列表view （竖屏）
#import "QukanAirPlayDeviceListView.h"
// 投屏设备列表view （横屏）
#import "QukanAirPlayLandScapeDeviceListView.h"
// 投屏中显示的vc
#import "QukanPersonDetailViewController.h"
//新闻详情Vc
#import "QukanNewsDetailsViewController.h"

// 获取直播路径的api
#import "QukanApiManager+Competition.h"
// 获取视频广告
#import "ZFPlayerControlView+Data.h"
// 获取详情广告
#import "QukanApiManager+info.h"

// 获取个人
#import "QukanApiManager+PersonCenter.h"
// 广告ad模型
// 点击广告跳转的vc
#import "QukanGViewController.h"
// 直播线路模型
#import "QukanLiveLineModel.h"
// 导航栏设置
#import <UIViewController+HBD.h>

// 主模型
// 用于请求直播路径
#import "QukanApiManager+BasketBall.h"

// 视频播放相关

// 直播相关
#import "ZFIJKPlayerManager.h"
#import "ZFPlayerController.h"


// 竖屏状态的更新路线view
#import "QukanLiveLinePopUpView.h"
// 横屏状态的更新路线view
#import "QukanScreenLiveLineView.h"

// 分享view

#import "QukanMatchDetailCustomNav.h"


#import "QukanTeamDetailVC.h"

//刷新按钮
#import "QukanRefreshControl.h"

// 播放器高度
#define kPlayerViewHeight kScreenWidth*(212/375.0)

#define kQukanLiveType_PlayerHdLive    1
#define kQukanLiveType_ThirdHdLive     2
#define kQukanLiveType_AnimationLive   3
#define kQukanLiveType_Ad              7
#define QukanLiveType_Other

#define kQukanLivePort                 1
#define kQukanLiveLand                 2


#define QukanLiveTimeUpdate            60

@interface QukanDetailsViewController ()<ZFPlayerMediaPlayback, QukanLiveLinePopUpViewDelegate,JXCategoryViewDelegate,JXPagerViewDelegate,JXPagerMainTableViewGestureDelegate>

// 头部视图
@property (nonatomic, strong) QukanFTDetailHeaderView *Qukan_headerView;

// 直播线路模型数组
@property (nonatomic, strong) NSMutableArray <QukanLiveLineModel *> *datas;
// 播放类型
@property (nonatomic, assign) NSInteger               liveType;
// 广告数组
@property(nonatomic, strong) NSMutableArray          *Qukan_aDataArray;
// 线路广告数组
@property(nonatomic, strong) NSMutableArray          *Qukan_liveLineDatas;
// 当前广告模型
@property(nonatomic, strong) QukanHomeModels        *adCurrentModel;
// 当前线路广告模型
@property(nonatomic, strong) QukanLiveLineModel      *lineCurrenModel;

// 是否正在投屏播放
@property (nonatomic ,assign) BOOL                   isAirPlaying;
// 是否能投屏播放
@property (nonatomic, assign) BOOL                   isCanAir;
// 投屏时间
@property (nonatomic, assign) NSInteger              airPlayTimes;
// 投屏总共的时间
@property (nonatomic, assign) NSInteger              allAirPlayTimes;

// 投屏时间计时器
@property (nonatomic, strong) RACSignal              *timeSignal;
// 观看视频的时间计时器
@property (nonatomic, strong) RACSignal              *updateTimeSignal;

// 直播线路刷新按钮
@property (nonatomic, strong) UIButton               *refreshButton;

// ZFPlayer 相关变量
@property(nonatomic, strong, readwrite) ZFPlayerController *player;
// 播放管理类
@property(nonatomic, strong) ZFIJKPlayerManager *playerManager;
// zf主视图
@property(nonatomic, strong) ZFPlayerControlView *controlView;
// 用于显示播放的主view
@property(nonatomic, strong) UIView                  *containerView;
// 竖屏播放视频时状态栏遮罩
@property(nonatomic, strong) UIView                    *statusMaskView;

// jx组件
@property(nonatomic, strong) JXCategoryTitleView *categoryView;
@property(nonatomic, strong) JXPagerView *pagerView;


/**jx选中的下标*/
@property(nonatomic, assign) NSInteger   int_pagerSelectIdex;

// 显示直播线路的view (竖屏)
@property(nonatomic, strong) QukanLiveLinePopUpView  * popUpView;
// 显示直播线路的view (横屏)
@property(nonatomic, strong) QukanScreenLiveLineView  *liveLineView;

/**虚拟导航栏  用于方便控制显示隐藏*/
@property(nonatomic, strong)  QukanMatchDetailCustomNav  * view_customNav;
/**是否正在动画直播*/
@property(nonatomic, assign) BOOL  bool_isAni;
/**记录滑动的比例*/
@property(nonatomic, assign) CGFloat   gradientProgress;

// 用于展示输入框
@property(nonatomic, strong) QukanNewsComentView *Qukan_FooterView;

@property(nonatomic, copy) NSDictionary<NSString *, UIViewController *> *controllersDic;

//刷新按钮
@property(nonatomic, strong) QukanRefreshControl *refreshBtn;

@end

@implementation QukanDetailsViewController

#pragma mark ===================== Life Cycle ==================================


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kCommentBackgroudColor;
    self.hbd_barHidden = YES;
    
    _isAirPlaying = NO;
    _isCanAir = NO;
    _airPlayTimes = 0;
    _allAirPlayTimes = 0;
    
    
    [self initSubViewControllers];
    // 布局主视图
    [self layoutCategoryView];
    
    [self addNotification];
    
    // 获取所有直播线路
    [self Qukan_getUrlWithFlag:0];
    // 获取动画直播的路径
    [self getHaveAnimation];
    
    @weakify(self)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self)
        // 获取主页广告
        [self Qukan_newsPage];
        // 获取直播线路广告
        [self Qukan_liveLineData];
        // 获取用户投屏时间
        [self Qukan_selectScoreRed];
    });
    
    // 初始化头部视图
    if (self.Qukan_model) [self.Qukan_headerView fullViewWithModel:self.Qukan_model];
    // 设置顶部模拟nav
    if (self.Qukan_model) [self.view_customNav fullViewWithModel:self.Qukan_model];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    // 若播放器为暂停状态  则开始播放
    if (self.player.currentPlayerManager.playState == ZFPlayerPlayStatePaused) {
        [self.player.currentPlayerManager play];
    }
    
    // 获取用户投屏时间
    [self Qukan_selectScoreRed];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 打开播放器的横竖屏锁
    [self openOrCloseVideoLandscapeLock:YES];
    _player.forceDeviceOrientation = YES;
    _player.allowOrentitaionRotation = YES;
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    _player.forceDeviceOrientation = NO;
    _player.allowOrentitaionRotation = NO;
    // 关闭播放器的横竖屏锁
    [self openOrCloseVideoLandscapeLock:NO];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    // 若播放器为播放状态  则暂停播放
    if (self.player.currentPlayerManager.playState == ZFPlayerPlayStatePlaying) {
        [self.player.currentPlayerManager pause];
    }
}

- (void)dealloc {
    DEBUGLog(@"QukanDetailsViewController ====  dealloc");
    
    // 每次出去时重新连接IM
    [[QukanIMChatManager sharedInstance] resetChatInfo];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.pagerView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - kSafeAreaBottomHeight);
    self.view_customNav.frame = CGRectMake(0, 0, kScreenWidth, kStatusBarHeight + 44);
    [self.view bringSubviewToFront:self.view_customNav];
}

- (void)initSubViewControllers {
    QukanLiveChatViewController *vc1 = [QukanLiveChatViewController new];
    vc1.Qukan_FooterView = self.Qukan_FooterView;
    vc1.matchId = self.Qukan_model.match_id;
    @weakify(self)
    vc1.liveChatVc_didBolck = ^(QukanHomeModels * _Nonnull model) {
        @strongify(self)
        [self.playerManager pause];
        [self adPushWay:model];
    };
    
    QukanMatchSituationViewController *vc2 = [QukanMatchSituationViewController new];
    vc2 = [[QukanMatchSituationViewController alloc] init];
    vc2.Qukan_matchId = self.Qukan_model.match_id;
    vc2.Qukan_model = self.Qukan_model;
    vc2.matchSituationVcBolck = ^(QukanHomeModels *model) {
        @strongify(self)
        [self.playerManager pause];
        [self adPushWay:model];
    };
    
    vc2.refreshEndBolck = ^{
        @strongify(self)
        [self.refreshBtn endAnimation];
    };

    QukanLineupViewController * vc3 = [[QukanLineupViewController alloc] init];
    vc3.Qukan_matchId = self.Qukan_model.match_id;
    vc3.Qukan_model = self.Qukan_model;
    vc3.lineUpVcBolck = ^(QukanHomeModels *model) {
        @strongify(self)
        [self.playerManager pause];
        [self adPushWay:model];
    };

    QukanFTMatchDetailDataVC * vc5 = [QukanFTMatchDetailDataVC new];
    vc5.model_main = self.Qukan_model;
    
    self.controllersDic = @{@"聊天":vc1,@"赛况":vc2,@"阵容":vc3,@"数据":vc5};
}

#pragma mark ===================== Notification ==================================
- (void)addNotification {
    @weakify(self)
    
    [[[kNotificationCenter rac_addObserverForName:UIApplicationWillEnterForegroundNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        if (![self.popUpView superview]) {
            [self openOrCloseVideoLandscapeLock:YES];
            self.player.forceDeviceOrientation = YES;
            self.player.allowOrentitaionRotation = YES;
        }
    }];
    
    [[[kNotificationCenter rac_addObserverForName:UIApplicationDidBecomeActiveNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        if (![self.popUpView superview]) {
            [self openOrCloseVideoLandscapeLock:YES];
            self.player.forceDeviceOrientation = YES;
            self.player.allowOrentitaionRotation = YES;
        }
    }];
    
    // 需要转屏通知
    [[[kNotificationCenter rac_addObserverForName:Qukan_needRotatScreen_notificationName object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        [self.player enterFullScreen:NO animated:YES];
        
        [self.player.currentPlayerManager pause];
    }];
    
    // 设备转屏通知
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:Qukan_DeviceShouldRotate object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        [self ratatingPlayerScreen];
    }];
    
    // 投屏连接成功通知
    [[[kNotificationCenter rac_addObserverForName:Qukan_AirPlayConnectSucceed object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        [self.playerManager pause];
        self.isAirPlaying = YES;
        [self addAirPlayTime];
    }];
    // 取消投屏播放
    [[[kNotificationCenter rac_addObserverForName:Qukan_AirPlayCancle object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        [self.playerManager play];
        self.isAirPlaying = NO;
        [self Qukan_AddTodayTimeWithTime:(self.airPlayTimes / 2)];
        self.allAirPlayTimes = self.allAirPlayTimes + self.airPlayTimes;
        self.airPlayTimes = 0;
    }];
    // 投屏点击
    [[[kNotificationCenter rac_addObserverForName:Qukan_airPlayTips object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        if (self.isAirPlaying) {
            [self.playerManager pause];
        }
    }];
}

#pragma mark ===================== Layout ====================================
// 布局底部分页视图
- (void)layoutCategoryView {

     NSArray *titles =  @[@"赛况",@"聊天",@"数据",@"阵容"];
    
    
    
    self.categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(50, kPlayerViewHeight+kStatusBarHeight, kScreenWidth - 100, 40)];
    self.categoryView.backgroundColor = kCommonBlackColor;
    self.categoryView.delegate = self;
    self.categoryView.titles = titles;
    self.categoryView.titleSelectedColor = kThemeColor;
    
    self.categoryView.titleColor = HEXColor(0xA2A2A2);
    self.categoryView.titleColorGradientEnabled = YES;
    self.categoryView.contentScrollViewClickTransitionAnimationEnabled = NO;
    
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorColor = kThemeColor;
    self.categoryView.indicators = @[lineView];
    
    self.pagerView = [[JXPagerListRefreshView alloc] initWithDelegate:self];
    self.pagerView.pinSectionHeaderVerticalOffset = kStatusBarHeight + kPlayerViewHeight;
    self.pagerView.mainTableView.gestureDelegate = self;
    
    [self.view addSubview:self.pagerView];
    
    self.categoryView.listContainer = (id<JXCategoryViewListContainer>)self.pagerView.listContainerView;
    
    //  下面这个很关键  如果去掉的话  侧滑返回会错乱
    self.navigationController.interactivePopGestureRecognizer.enabled = (self.categoryView.selectedIndex == 0);
    [self.pagerView.listContainerView.scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
    [self.pagerView.mainTableView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
    
    [self.view addSubview:self.view_customNav];
    
    [self.view addSubview:self.Qukan_FooterView];
    self.Qukan_FooterView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kBottomBarHeight);

  
}

//- (void)updataCategoryView {
//
//    self.categoryView.titles = self.titles;
//    [self.categoryView reloadData];
//}

- (void)showInputView {
    [UIView animateWithDuration:0.3f animations:^{
        [self.pagerView.mainTableView setContentOffset:CGPointZero];
        self.Qukan_FooterView.frame = CGRectMake(0, kScreenHeight - kBottomBarHeight, kScreenWidth, kBottomBarHeight);
        [self.Qukan_FooterView layoutIfNeeded];
    }];
}

- (void)hiddenInputView {

    [UIView animateWithDuration:0.5f animations:^{
        self.Qukan_FooterView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kBottomBarHeight);
        [self.Qukan_FooterView layoutIfNeeded];
    }];
}

#pragma mark ============================== JXPagerViewDelegate  ==============================

- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.Qukan_headerView;
}

- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    return (NSUInteger)(kPlayerViewHeight + kStatusBarHeight);
}

- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return 40;
}

- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.categoryView;
}

- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    return self.categoryView.titles.count;
}

- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index{
    return (id<JXPagerViewListViewDelegate>)self.controllersDic[self.categoryView.titles[index]];
}

// 主滑动视图滑动代理  用于处理导航栏颜色改变
- (void)mainTableViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"%.2f",scrollView.contentOffset.y);
    
    CGFloat progress = scrollView.contentOffset.y;
    CGFloat gradientProgress = MIN(1, MAX(0, progress  / (kPlayerViewHeight - 44)));
    if (gradientProgress != self.gradientProgress) {
        self.gradientProgress = gradientProgress;
        if (self.gradientProgress < 1) {  // 设置透明度渐变
            [self.view_customNav setAlphaWithProgress:gradientProgress];
            [self.Qukan_headerView setSubviewAlaphWithProgress:1 - gradientProgress];
        }
    }
}

#pragma mark - JXPagerMainTableViewGestureDelegate

- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    //禁止categoryView左右滑动的时候，上下和左右都可以滚动
    if (otherGestureRecognizer == self.categoryView.collectionView.panGestureRecognizer) {
        return NO;
    }
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}

#pragma mark - JXCategoryViewDelegate
//点击选中或者滚动选中都会调用该方法。适用于只关心选中事件，不关心具体是点击还是滚动选中的。
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    [self.view endEditing:YES];
    
    // 设置选中下标  为了旋转回来之后还可以选中
    self.int_pagerSelectIdex = index;
    
//    [self resetPinSectionHeaderVerticalOffset];
    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);

    if ([self.categoryView.titles[index] isEqualToString:@"聊天"]) {
        [self showInputView];
    }else {
        [self hiddenInputView];
    }
    
     self.refreshBtn.hidden = ![self.categoryView.titles[index] isEqualToString:@"赛况"];
}


#pragma mark ===================== Private Methods =========================
// 弹出竖屏的直播路线选中view
- (void)addSelfActionAlert {
    if (self.popUpView) {  // 防治内存泄漏
        [self.popUpView removeFromSuperview];
        self.popUpView = nil;
    }
    
    self.popUpView =  [[QukanLiveLinePopUpView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.popUpView.delegate = self;
    [self.popUpView showWithBeginData:self.datas andAds:self.Qukan_liveLineDatas];
    [self openOrCloseVideoLandscapeLock:NO];
}

// 在播放器横屏时旋转播放器
- (void)ratatingPlayerScreen {
    NSString *currentOrientation  = [QukanAirPlayManager.sharedManager getCurrentOrientation];
    if ([currentOrientation isEqualToString:KDeviceIsPortrait]) {
        [self.player enterFullScreen:YES animated:YES];
    }else{
        [self.player enterFullScreen:NO animated:YES];
    }
}

//// 重新设置分页视图距离顶部的位置 --- 在播放视频或者播放动画直播的时候使其不能上滑
//- (void)resetPinSectionHeaderVerticalOffset {
////    if (self.bool_isAni || self.containerView.superview || self.int_pagerSelectIdex == self.int_chatIndex) {
////        self.pagerView.pinSectionHeaderVerticalOffset = kPlayerViewHeight + kStatusBarHeight;
////    }else {
////        self.pagerView.pinSectionHeaderVerticalOffset = kTopBarHeight;
////    }
////    [self.pagerView reloadData];
//}

#pragma mark ===================== QukanLiveLinePopUpViewcDelegate ==================================
// 竖屏状态直播路线选择代理
- (void)QukanLiveLinePopUpViewchooseCompletWithModel:(id)mainModel {   // 选中广告或者线路
    if ([mainModel isKindOfClass:[QukanHomeModels class]]) {  // 广告模型
        [self adPushWay:(QukanHomeModels *)mainModel];
    }
    
    if ([mainModel isKindOfClass:[QukanLiveLineModel class]]) {  // 直播路线模型
        [self setPlayerDataSourceWithModel:(QukanLiveLineModel *)mainModel];
    }
}

- (void)QukanLiveLinePopUpViewRereaseView {  // 选择路线的view被释放
    [self openOrCloseVideoLandscapeLock:YES];
    self.popUpView = nil;
}

- (void)QukanLiveLinePopUpViewBtn_refreshClick {  // 刷新直播线路
    [self Qukan_getNewestLiveLineWithType:kQukanLivePort];
}


///  广告路线选中跳转
- (void)appInterPushWithModel:(QukanLiveLineModel *)lineModel {
    if (_liveType == kQukanLiveType_ThirdHdLive || _liveType == kQukanLiveType_Ad) {//第三方 ad
        if (lineModel.isOutBrowser == 0) {
            QukanGViewController *vc = [[QukanGViewController alloc] init];
            vc.url = lineModel.liveType ? lineModel.liveUrl : @"";
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (lineModel.isOutBrowser == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:lineModel.liveUrl]];
        } else {//内部
            
        }
    }
}

// 广告点击
- (void)adPushWay:(QukanHomeModels *)model {
    if ([model.jump_type intValue] == QukanViewJumpType_In) {//内部
        [self.player.currentPlayerManager pause];
        QukanGViewController *vc = [[QukanGViewController alloc] init];
        vc.url = model.v_url;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([model.jump_type intValue] == QukanViewJumpType_Out) {//外部
        [self.player.currentPlayerManager pause];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.v_url]];
    } else if ([model.jump_type intValue] == QukanViewJumpType_AppIn) {
        
    } else if ([model.jump_type intValue] == QukanViewJumpType_Other) {
        [self.player.currentPlayerManager pause];
        QukanGViewController *vc = [[QukanGViewController alloc] init];
        NSString *url = [NSString stringWithFormat:@"%@?adType=%@&bunleId=%@&appKey=%@",model.v_url,model.type,Qukan_AppBundleId,Qukan_OpeninstallKey];
        vc.url = url;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

// 添加分享视图
- (void)addShareView {
    [kUMShareManager Qukan_showShareViewWithMainModel:self.Qukan_model Type:shareScreenTypePort superView:kwindowLast];
}

// 全屏的时候添加分享视图
- (void)addFullSreenShareView {
    [kUMShareManager Qukan_showShareViewWithMainModel:self.Qukan_model Type:shareScreenTypeLand superView:self.player.controlView];
}

// 全屏的时候展示选择路线的视图
- (void)addScreenView {
    for (UIView *view  in self.controlView.subviews) {
        if ([view isKindOfClass:[QukanScreenLiveLineView class]]) {
            [view removeFromSuperview];
        }
    }
    self.liveLineView = [[QukanScreenLiveLineView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) WithDatas:self.datas withAds:self.Qukan_liveLineDatas];
    [self.player.controlView addSubview:self.liveLineView];
    
    @weakify(self)
    self.liveLineView.cellDidSeleLiveBolck = ^(QukanLiveLineModel * _Nonnull liveLineModel) {
        @strongify(self)
        [self playerSetAgain:liveLineModel];
    };
    
    self.liveLineView.cellDidSeleAdBolck = ^(QukanHomeModels * _Nonnull adModel) {
        @strongify(self)
        [self ratatingPlayerScreen];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self adPushWay:adModel];
        });
    };
    
    self.liveLineView.refreshBolck = ^{
        @strongify(self)
        [self Qukan_getNewestLiveLineWithType:kQukanLiveLand];
    };
}

// 根据线路模型获取得到线路模型中的URL
- (NSString *)playerGetUrlWithModel:(QukanLiveLineModel *)lineModel {
    if (lineModel.aliFlvUrl && ![NSString isEmptyStr:lineModel.aliFlvUrl]) {
        return lineModel.aliFlvUrl;
    } else if (lineModel.aliM3u8Url && ![NSString isEmptyStr:lineModel.aliM3u8Url]) {
        return lineModel.aliM3u8Url;
    } else if (lineModel.aliRtmpUrl && ![NSString isEmptyStr:lineModel.aliRtmpUrl]) {
        return lineModel.aliRtmpUrl;
    } else {
        return (lineModel.liveUrl && ![NSString isEmptyStr:lineModel.liveUrl]) ? lineModel.liveUrl : @"";
    }
}

#pragma mark ===================== NetWork ==================================
// 获取到动画直播路径
- (void)getHaveAnimation {
    @weakify(self)
    [[[kApiManager QukanFetchAnimationLiveWithMatchId:[NSString stringWithFormat:@"%ld",self.Qukan_model.match_id]] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.Qukan_headerView.url_animation = x;
    } error:^(NSError * _Nullable error) {
    }];
}

// 添加用户看比赛时间统计
- (void)Qukan_AddTodayTimeWithTime:(NSInteger)time {
    if (![kUserManager isLogin]) {
        return;
    }
    NSString *timeStr = [NSString stringWithFormat:@"%ld",time];
    @weakify(self)
    [[[kApiManager QukanAddTodayTime:timeStr WithMatchId:self.Qukan_model.match_id] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        KHideHUD
        DEBUGLog(@"%@",x);
        DEBUGLog(@"看了多少呢%@",timeStr);
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        KHideHUD
    }];
}

// 获取用户可用的投屏时间
- (void)Qukan_selectScoreRed {
    @weakify(self)
    [[[kApiManager QukanSelectDate] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        NSString *times = [x stringValueForKey:@"tpTime" default:nil];
        self.isCanAir = !([times isEqualToString:@"0天"] || [times isEqualToString:@"0秒"]);
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        self.isCanAir = NO;
    }];
}

// 获取到直播线路
- (void)Qukan_getUrlWithFlag:(NSInteger)flag {
    @weakify(self);
    NSString *mathId = [NSString stringWithFormat:@"%ld",self.Qukan_model.match_id];;
    [[[kApiManager QukanWithMatchId:mathId] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self dataSourceDealWith:x];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.refreshButton.imageView.layer removeAnimationForKey:@"circles"];
        });
        flag == 1 ? [self dataSourceRefreshGetCurrenModel] : nil;
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        [self.refreshButton.imageView.layer removeAnimationForKey:@"circles"];
        flag == 1 ? [self playerSetAgain:self.lineCurrenModel] : nil;
    }];
}

//刷新直播线路
- (void)Qukan_getNewestLiveLineWithType:(NSInteger)type {
    @weakify(self);
    NSString *mathId = [NSString stringWithFormat:@"%ld",self.Qukan_model.match_id];;
    [[[kApiManager QukanWithMatchId:mathId] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self dataSourceDealWith:x];
        if (type == kQukanLivePort) {
            if (self.popUpView) {
                [self.popUpView refreshWithDatas:self.datas];
            } else {
                [self addSelfActionAlert];
            }
        } else if (type == kQukanLiveLand) {
            self.liveLineView.datas = self.datas;
            [self.liveLineView.tableView reloadData];
        }
        
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        //        [self.refreshButton.imageView.layer removeAnimationForKey:@"circles"];
        if (self.popUpView) {
            [self.popUpView refreshWithDatas:nil];
        }
    }];
}

- (void)dataSourceDealWith:(id)response {
    NSArray *responseArray = (NSArray *)response;
    if (responseArray.count == 0) {return;}
    [self.datas removeAllObjects];
    for (NSDictionary *dict in responseArray) {
        QukanLiveLineModel *lineModel = [QukanLiveLineModel modelWithDictionary:dict];
        [self.datas addObject:lineModel];
    }
}

- (void)dataSourceRefreshGetCurrenModel {
    @weakify(self)
    [self.datas enumerateObjectsUsingBlock:^(QukanLiveLineModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self)
        if (obj.liveType == self.liveType) {
            self.lineCurrenModel = obj;
            [self playerSetAgain:self.lineCurrenModel];
        }
    }];
}

// 给播放器添加视频路径
- (void)setPlayerDataSourceWithModel:(QukanLiveLineModel *)liveLineModel {
    if (liveLineModel == nil) {return;}
    self.liveType = liveLineModel.liveType;
    _lineCurrenModel = liveLineModel;
    [self setupPlayerWithUrl:[self playerGetUrlWithModel:liveLineModel]];
}

- (void)Qukan_newsPage {
    @weakify(self)
    [[[kApiManager QukanInfoWithType:17] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self dataSourceWith:x];
    } error:^(NSError * _Nullable error) {
    }];
    
}

- (void)Qukan_liveLineData {
    @weakify(self)
    [[[kApiManager QukanInfoWithType:42] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self dataSourceWithLineAd:x];
    } error:^(NSError * _Nullable error) {
    }];
}

- (void)dataSourceWith:(id)response {
    NSArray *array = (NSArray *)response;
    if (!array.count) {return;}
    for (NSDictionary *dict in array) {
        QukanHomeModels *model = [QukanHomeModels modelWithDictionary:dict];
        [self.Qukan_aDataArray addObject:model];
    }
}

- (void)dataSourceWithLineAd:(id)response {
    NSArray *array = (NSArray *)response;
    if (!array.count) {return;}
    for (NSDictionary *dict in array) {
        QukanHomeModels *model = [QukanHomeModels modelWithDictionary:dict];
        [self.Qukan_liveLineDatas addObject:model];
    }
}


#pragma mark ===================== 视频播放 =========================
//香港卫视：http://live.hkstv.hk.lxdns.com/live/hks/playlist.m3u8
//
//CCTV1高清：http://ivi.bupt.edu.cn/hls/cctv1hd.m3u8
//
//CCTV3高清：http://ivi.bupt.edu.cn/hls/cctv3hd.m3u8
//
//CCTV5高清：http://ivi.bupt.edu.cn/hls/cctv5hd.m3u8
//
//CCTV5+高清：http://ivi.bupt.edu.cn/hls/cctv5phd.m3u8
//
//CCTV6高清：http://ivi.bupt.edu.cn/hls/cctv6hd.m3u8
//    _playerManager.assetURL = [NSURL URLWithString:@"https://media.w3.org/2010/05/sintel/trailer.mp4"];
//    _playerManager.assetURL = [NSURL URLWithString:@"rtmp://live.hkstv.hk.lxdns.com/live/hks1"];
//    _playerManager.assetURL = [NSURL URLWithString:@"http://ivi.bupt.edu.cn/hls/cctv1hd.m3u8"];
//    _playerManager.assetURL = [NSURL URLWithString:@"rtmp://6666.cdn.gunqiu.com/live/stream2458334"];
//    _playerManager.assetURL = [NSURL URLWithString:@"http://6666.cdn.gunqiu.com/live/stream2456199/playlist.m3u8"];
//    _playerManager.assetURL = [NSURL URLWithString:@"async:http://dl.queltj.com/8dbe91c9e1d7423dae395e7b4539d68b/4034b4c3701b4fb99386e961733ee619-bfac11cd7896ef40b9d2212d02bd724a-fd.mp4"];

- (void)setupPlayerWithUrl:(NSString *)urlStr{
    QukanAirPlayManager.sharedManager.urlString = urlStr;
    
    if (self.containerView.superview) {
        [self playerSetAgain:self.lineCurrenModel];
        return;
    }
    
    [ZFPlayerLogManager setLogEnable:NO];
    
    [self.view addSubview:self.statusMaskView];
    [self.view addSubview:self.containerView];
    self.player.controlView = self.controlView;
    
//    [self resetPinSectionHeaderVerticalOffset];
    _playerManager.assetURL = [NSURL URLWithString:urlStr];
    [self.controlView showTitle:@"" coverImage:[[UIImage imageNamed:@"Qukan_player_loading_bg"] imageWithColor:[UIColor clearColor]] fullScreenMode:ZFFullScreenModeAutomatic];
    self.view_customNav.hidden = YES;
    [self.controlView showGif:@"Qukan_Video_Loading"];
    
    @weakify(self)
    self.playerManager.playerDidToEnd = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset) {
        @strongify(self)
        [self.controlView.portraitControlView resetControlView];
    };
    
    self.player.playerReadyToPlay = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, NSURL * _Nonnull assetURL) {
        @strongify(self)
        [self.controlView hideGif];
    };
    
    self.player.playerPlayFailed = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, id  _Nonnull error) {
        @strongify(self)
        [self.controlView hideGif];
    };
    
    self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
        @strongify(self)
        for (UIView *view  in self.controlView.subviews) {
            if ([view isKindOfClass:[QukanShareView class]]) {
                [view removeFromSuperview];
            }
        }
        
        for (UIView *view in self.controlView.subviews) {
            if ([view isKindOfClass:[QukanScreenLiveLineView class]]) {
                [view removeFromSuperview];
            }
        }
        
        //键盘消失呢
        [self.view endEditing:YES];
    };
    
    self.controlView.dataImageView_didBlock = ^{
        @strongify(self)
        [self.controlView hideDataView];
        [self adPushWay:self.adCurrentModel];
    };
    
    self.controlView.LandImageView_didBlock = ^{  // 广告视图点击
        @strongify(self)
        // 强制横屏  延迟跳转
        [self ratatingPlayerScreen];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.controlView hideDataView];
            [self adPushWay:self.adCurrentModel];
        });
        
    };
    
    self.controlView.portraitControlView.changeLineBtnClickCallback = ^{  // 竖屏更换线路按钮点击
        @strongify(self)
        [self.view endEditing:YES];
        [self addSelfActionAlert];
    };
    
    self.controlView.landScapeControlView.changeLineBtnClickCallback = ^{   // 横屏更换线路按钮点击
        @strongify(self)
        [self addScreenView];
    };
    
    self.controlView.portraitControlView.shareBtnClickCallback = ^{  // 竖屏分享点击
        @strongify(self)
        [self.view endEditing:YES];
        [self addShareView];
    };
    
    self.controlView.landScapeControlView.shareBtnClickCallback = ^{  // 横屏分享点击
        @strongify(self)
        
        [self addFullSreenShareView];
        
    };
    
    // 播放器竖屏刷新按钮点击
    self.controlView.portraitControlView.refreshBtnClickCallback = ^{
        @strongify(self)
        [self Qukan_getUrlWithFlag:1];
    };
    // 播放器横屏刷新按钮点击
    self.controlView.landScapeControlView.refreshBtnClickCallback = ^{
        @strongify(self)
        [self Qukan_getUrlWithFlag:1];
    };
    
    //添加定时器
    [self addTimeMonitoring];
    [self addLookMatchUpdateTime];
}

// 重新设置播放线路
- (void)playerSetAgain:(QukanLiveLineModel *)lineModel {
    QukanAirPlayManager.sharedManager.urlString = [self playerGetUrlWithModel:lineModel];
    [self.controlView showGif:@"Qukan_Video_Loading"];
    [self.playerManager setAssetURL:[NSURL URLWithString:[self playerGetUrlWithModel:lineModel]]];
    [self.player playerReadyToPlay];
}


// 给视频添加广告
- (void)addTimeMonitoring {
    if (self.Qukan_aDataArray.count == 0) {return;}
    RACSignal *siganl = [[RACSignal interval:600 onScheduler:[RACScheduler mainThreadScheduler]] takeUntil:self.rac_willDeallocSignal];
    NSArray *times = @[@"600",@"2400",@"4200"];
    __block int Number = 0;
    __block long timePass = 0;
    @weakify(self)
    [siganl subscribeNext:^(id x) {
        @strongify(self)
        Number ++;
        timePass = Number * 600;
        for (int i = 0 ; i < times.count; i ++) {
            int rac = arc4random() % self.Qukan_aDataArray.count;
            QukanHomeModels *model = self.Qukan_aDataArray[rac];
            [times enumerateObjectsUsingBlock:^(NSString *  _Nonnull time, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([time longValue] == timePass) {
                    self.adCurrentModel = model;
                    [self.controlView showDataViewWithModel:model];
                }
            }];
        }
    }];
}

// 添加投屏定时器
- (void)addAirPlayTime {
    if (_timeSignal) {_timeSignal = nil;}
    _timeSignal = [[RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]] takeUntil:self.rac_willDeallocSignal];
    @weakify(self)
    [self.timeSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if(self.isAirPlaying) {
            self.airPlayTimes ++;
        }
    }];
}

// 观看比赛时间定时器
- (void)addLookMatchUpdateTime {
    if (_updateTimeSignal) {_updateTimeSignal = nil;}
    _updateTimeSignal = [[RACSignal interval:QukanLiveTimeUpdate onScheduler:[RACScheduler mainThreadScheduler]] takeUntil:self.rac_willDeallocSignal];
    @weakify(self)
    [_updateTimeSignal subscribeNext:^(id x) {
        @strongify(self)
        if (self.player && self.player.currentPlayerManager && !self.isAirPlaying) {
            if (self.player.currentPlayerManager.playState == ZFPlayerPlayStatePaused || self.player.currentPlayerManager.playState == ZFPlayerPlayStatePlaying) {
                [self Qukan_AddTodayTimeWithTime:QukanLiveTimeUpdate];
            }
        }
    }];
}

//  设置播放器是否支持旋转
- (void)openOrCloseVideoLandscapeLock:(BOOL)isOpen {
    if (isOpen) {
        if (self.containerView.superview) {
            [self.player.orientationObserver setLockedScreen:NO]; // 打开横屏
        }
    }else {
        [self.player.orientationObserver setLockedScreen:YES]; // 锁住屏幕，防止再次横屏遮挡广告
    }
}

#pragma mark ===================== StatusBar ==================================

- (UIStatusBarStyle)preferredStatusBarStyle {  // 设置状态栏为白色
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {  // 设置状态栏的显示隐藏
    return self.Qukan_headerView.bool_isHideState || self.player.isStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

#pragma mark ===================== Rotation ==================================
- (BOOL)shouldAutorotate {  // 控制转屏
    return self.player.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if (self.player.orientationObserver.lockedScreen || !self.containerView.superview)  {
        return UIInterfaceOrientationMaskPortrait;
    }
    return UIInterfaceOrientationMaskAllButUpsideDown;
}


#pragma mark ===================== Getters =================================
- (NSMutableArray *)Qukan_aDataArray {  // 广告数组
    if (!_Qukan_aDataArray) {
        _Qukan_aDataArray = [NSMutableArray array];
    }
    return _Qukan_aDataArray;
}

- (NSMutableArray<QukanLiveLineModel *> *)datas {  // 直播线路数组
    if (!_datas) {
        _datas = [NSMutableArray new];
    }
    return _datas;
}

-(NSMutableArray *)Qukan_liveLineDatas {   // 视频播放时广告数组
    if (!_Qukan_liveLineDatas) {
        _Qukan_liveLineDatas = [NSMutableArray new];
    }
    return _Qukan_liveLineDatas;
}

- (ZFPlayerControlView *)controlView {  // 播放器的主视图
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
        _controlView.stytleForLive = YES;
        _controlView.isCanAir = self.isCanAir;
        [_controlView hideProgressForLive];
        
        @weakify(self)
        _controlView.portraitControlView.backBtnClickCallback = ^{
            @strongify(self)
            if (QukanAirPlayManager.sharedManager.isAirPlaying) {
                [QukanAirPlayManager.sharedManager stopPlay];
            }
            
            self.view_customNav.hidden = NO;
            
            //处理时间更新的问题
            NSTimeInterval interval = self.player.currentTime;
            NSInteger time = ceilf(interval);
            if (self.airPlayTimes > 1) { time = time - self.allAirPlayTimes;}
            [self Qukan_AddTodayTimeWithTime:time % QukanLiveTimeUpdate];
            [self.player stop];
            [self.containerView removeFromSuperview];
            [self.statusMaskView removeFromSuperview];
            self.updateTimeSignal = nil;
//            [self resetPinSectionHeaderVerticalOffset];
        };
        
        _controlView.portraitControlView.airPlayBtnClickCallback = ^{
            @strongify(self)
            [self.view endEditing:YES];
            if (!kUserManager.isLogin) {kGuardLogin}
            if (self.isCanAir) {
                //                [[QukanAirPlayManager sharedManager] Qukan_asyncRegister];
                [QukanAirPlayDeviceListView show];
            } else {
                [self.playerManager pause];
                QukanPersonDetailViewController *vc = [[QukanPersonDetailViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        };
        
        _controlView.landScapeControlView.airPlayBtnClickCallback = ^{
            @strongify(self)
            UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
            if (!kUserManager.isLogin) {
                if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight) {
                    [self.player enterFullScreen:NO animated:NO];
                }
                kGuardLogin
            }
            if (self.isCanAir) {
                [QukanAirPlayLandScapeDeviceListView showInView:self.controlView];
            }else {
                if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight) {
                    [self.player enterFullScreen:NO animated:NO];
                }
                [self.playerManager pause];
                QukanPersonDetailViewController *vc = [[QukanPersonDetailViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        };
        
        
        _controlView.retryBtnClickCallback = ^{
            @strongify(self)
            [self Qukan_getUrlWithFlag:1];
        };
    }
    return _controlView;
}

- (UIView *)containerView {  // 播放器的主容器
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, kScreenWidth, kPlayerViewHeight)];
        _containerView.backgroundColor = kCommonBlackColor;
    }
    return _containerView;
}

// https://www.jianshu.com/p/80c56f47a870     ijkplayer 参数说明文档
- (ZFIJKPlayerManager *)playerManager {  // 直播的管理器
    if (!_playerManager) {
        _playerManager = [[ZFIJKPlayerManager alloc] init];        
    }
    return _playerManager;
}

- (ZFPlayerController *)player {  // 视频的管理器
    if (!_player) {
        _player = [ZFPlayerController playerWithPlayerManager:self.playerManager containerView:self.containerView];
        _player.forceDeviceOrientation = YES;
        _player.allowOrentitaionRotation = YES;
    }
    return _player;
}

- (UIView *)statusMaskView {  // 遮住状态栏的view
    if (!_statusMaskView) {
        _statusMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kTopBarHeight)];
        _statusMaskView.backgroundColor = kCommonBlackColor;
    }
    return _statusMaskView;
}

- (QukanFTDetailHeaderView *)Qukan_headerView {  // 初始显示头部视图
    if (!_Qukan_headerView) {
        _Qukan_headerView = [[QukanFTDetailHeaderView alloc] initWithFrame:CGRectZero];
        
        @weakify(self);
        // 视频播放按钮点击   弹出线路
        [[_Qukan_headerView rac_signalForSelector:@selector(btn_videoPlayClick:)] subscribeNext:^(RACTuple * _Nullable x) {
            @strongify(self)
            [self.view endEditing:YES];
            [self addSelfActionAlert];
            
        }];
        
        // 动画直播显示隐藏状态栏通知
        [[_Qukan_headerView rac_signalForSelector:@selector(btn_animationCoverClick:)] subscribeNext:^(RACTuple * _Nullable x) {
            @strongify(self);
            [self.view endEditing:YES];
            self.view_customNav.hidden = !self.view_customNav.hidden;
//            [self setNeedsStatusBarAppearanceUpdate];
        }];
        // 动画直播按钮点击
        [[_Qukan_headerView rac_signalForSelector:@selector(btn_animationPlayClick:)] subscribeNext:^(RACTuple * _Nullable x) {
            @strongify(self);
            self.bool_isAni = YES;
            self.view_customNav.view_bg.hidden = YES;
//            [self resetPinSectionHeaderVerticalOffset];
            [self.view endEditing:YES];
        }];
        
        // 动画直播按钮点击
        [[_Qukan_headerView rac_signalForSelector:@selector(HidenAnimation)] subscribeNext:^(RACTuple * _Nullable x) {
            @strongify(self);
            self.view_customNav.view_bg.hidden = NO;
        }];
        
        // 返回动作
        [[_Qukan_headerView rac_signalForSelector:@selector(backAction)] subscribeNext:^(RACTuple * _Nullable x) {
            @strongify(self);
            [self.view endEditing:YES];
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        
        
        [[_Qukan_headerView rac_signalForSelector:@selector(homeLogoClick)] subscribeNext:^(RACTuple * _Nullable x) {
            @strongify(self);
            
            QukanTeamScoreModel *model = [QukanTeamScoreModel new];
            model.teamId = self.Qukan_model.home_id;
            model.flag = self.Qukan_model.flag1;
            model.g = self.Qukan_model.home_name;
            model.leagueId = self.Qukan_model.league_id;
            model.season = self.Qukan_model.season;

            QukanTeamDetailVC *vc = [[QukanTeamDetailVC alloc] initWithModel:model];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        
        [[_Qukan_headerView rac_signalForSelector:@selector(awayLogoClick)] subscribeNext:^(RACTuple * _Nullable x) {
            @strongify(self);
            
            QukanTeamScoreModel *model = [QukanTeamScoreModel new];
            model.teamId = self.Qukan_model.away_id;
            model.flag = self.Qukan_model.flag2;
            model.g = self.Qukan_model.away_name;
            model.leagueId = self.Qukan_model.league_id;
            model.season = self.Qukan_model.season;
            QukanTeamDetailVC *vc = [[QukanTeamDetailVC alloc] initWithModel:model];
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _Qukan_headerView;
}

- (QukanMatchDetailCustomNav *)view_customNav {   // 模拟导航栏  方便布局
    if (!_view_customNav) {
        _view_customNav = [[QukanMatchDetailCustomNav alloc] initWithFrame:CGRectZero];
        
        // 返回动作
        @weakify(self);
        [[_view_customNav rac_signalForSelector:@selector(btn_backClick)] subscribeNext:^(RACTuple * _Nullable x) {
            @strongify(self);
            self.bool_isAni = NO;
//            [self resetPinSectionHeaderVerticalOffset];
            [self.Qukan_headerView btn_backAndLSNameClick:[UIButton new]];
        }];
        
        // 分享按钮点击
        [[_view_customNav rac_signalForSelector:@selector(btn_shareClick)] subscribeNext:^(RACTuple * _Nullable x) {
            @strongify(self)
            [self.view endEditing:YES];
            [self addShareView];
        }];
    }
    return _view_customNav;
}

- (QukanNewsComentView *)Qukan_FooterView {  // 输入框弹出， 放在主控制器中
    if (!_Qukan_FooterView) {
        _Qukan_FooterView = [[QukanNewsComentView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) withType:3];
        _Qukan_FooterView.titleLabel.text = kUserManager.isLogin ? @"我也聊聊~" : @"请先登录";
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = kFont10;
        [btn setTitle:@"只看主持人" forState:UIControlStateNormal];
        [btn setTitle:@"只看群聊" forState:UIControlStateSelected];
        btn.backgroundColor = kCommonTextColor;

        btn.layer.cornerRadius = 12.5;
        [btn setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
        [_Qukan_FooterView addSubview:btn];


        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(-15);
            make.width.mas_equalTo(71);
            make.height.mas_equalTo(25);
            make.top.mas_equalTo(12);
        }];
        
        
        @weakify(self)
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            QukanLiveChatViewController *vc = (QukanLiveChatViewController *)self.controllersDic[@"聊天"];
            btn.selected = !btn.selected;
            [vc onlyCompClick:btn];
        }];
        
        self.Qukan_FooterView.putBlock = ^(NSInteger type) {
            @strongify(self)
            kGuardLogin
            QukanLiveChatViewController *vc = (QukanLiveChatViewController *)self.controllersDic[@"聊天"];
            [vc showInputView];
        };
    }
    return _Qukan_FooterView;
}

- (QukanRefreshControl *)refreshBtn {
    if (!_refreshBtn) {
        _refreshBtn = [[QukanRefreshControl alloc] initWithFrame:CGRectMake(kScreenWidth - SCALING_RATIO(70),
                                                                            kScreenHeight - SCALING_RATIO(90),SCALING_RATIO(80), SCALING_RATIO(80)) relevanceScrollView:[UIScrollView new]];
        
        @weakify(self)
        _refreshBtn.beginRefreshBlock = ^{
            @strongify(self)
            //事件
            QukanMatchSituationViewController *vc = (QukanMatchSituationViewController *)self.controllersDic[@"赛况"];
            [vc Qukan_refreshData];
        };
        
        _refreshBtn.hidden = NO;
        
        [self.view addSubview:_refreshBtn];
        [self.view bringSubviewToFront:_refreshBtn];
    }
    return _refreshBtn;
}



@end
