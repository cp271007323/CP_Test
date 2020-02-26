#import "QukanBasketDetailVC.h"
#import "QukanBasketDetailHeaderView.h"
#import "QukanShareView.h"
#import "QukanScreenLiveLineView.h"

#import "QukanLiveChatViewController.h"
#import "QukanAirPlayDeviceListView.h"
#import "QukanAirPlayLandScapeDeviceListView.h"
#import "QukanPersonDetailViewController.h"
#import "QukanBasketIineupViewController.h"

#import "QukanApiManager+Competition.h"
#import "ZFPlayerControlView+Data.h"
#import "QukanApiManager+info.h"
#import "QukanApiManager+PersonCenter.h"
#import "QukanGViewController.h"

#import <UIViewController+HBD.h>
#import "ZFIJKPlayerManager.h"
#import "ZFPlayerController.h"

#import "QukanBasketBallMatchModel.h"

#import "QukanBasketAnalysisVC.h"

#import "QukanApiManager+BasketBall.h"

#import "YYTimer.h"

#import "QukanLiveLinePopUpView.h"
#import "QukanTextLiveVC.h"

#import "QukanMatchDetailCustomNav.h"

#import "QukanBasketDetailDataVC.h" // 篮球详情数据
#import "QukanBSKTeamDetialViewController.h"

//刷新按钮
#import "QukanRefreshControl.h"



#define kPlayerViewHeight kScreenWidth*(212/375.0)
#define QukanLiveTimeUpdate            60

#define kQukanLiveType_ThirdHdLive     2
#define kQukanLiveType_AnimationLive   3
#define kQukanLiveType_Ad              7


#define kQukanLivePort                 1
#define kQukanLiveLand                 2

@interface QukanBasketDetailVC ()<JXCategoryViewDelegate, JXPagerViewDelegate, JXPagerMainTableViewGestureDelegate,UIActionSheetDelegate,ZFPlayerMediaPlayback, QukanLiveLinePopUpViewDelegate>

@property (nonatomic, strong) QukanBasketDetailHeaderView *Qukan_headerView;
@property (nonatomic, strong) QukanShareView         *Qukan_ShareView;

@property (nonatomic, strong) NSMutableArray <QukanLiveLineModel *> *datas;

@property (nonatomic, assign) NSInteger               liveType;
@property(nonatomic, strong) NSMutableArray          *Qukan_aDataArray;
@property(nonatomic, strong) NSMutableArray          *Qukan_liveLineDatas;
@property(nonatomic, strong) QukanHomeModels        *adCurrentModel;
@property(nonatomic, strong) QukanLiveLineModel      *lineCurrenModel;

@property (nonatomic, assign) BOOL                   isCanAir;

@property(nonatomic, strong) ZFPlayerController *player;
@property(nonatomic, strong) ZFIJKPlayerManager *playerManager;
@property(nonatomic, strong) ZFPlayerControlView *controlView;
@property(nonatomic, strong) UIView *containerView;
@property(nonatomic, strong) UIView *statusMaskView; // 竖屏播放视频时状态栏遮罩

@property(nonatomic, strong) JXCategoryTitleView *categoryView;
@property(nonatomic, strong) JXPagerListRefreshView *pagerView;

/**当前选中的下标*/
@property(nonatomic, assign) NSInteger   int_selectIndex;

@property(nonatomic, strong, readwrite) QukanBasketBallMatchDetailModel *detailModel;
@property (nonatomic ,assign) BOOL                   isAirPlaying;
@property (nonatomic, assign) NSInteger              allAirPlayTimes;
@property (nonatomic, strong) RACSignal              *timeSignal;
@property (nonatomic, strong) RACSignal              *updateTimeSignal;
@property (nonatomic, assign) NSInteger              airPlayTimes;
@property(nonatomic, strong) NSString *animateUrlString;

@property (nonatomic, strong) QukanBasketAnalysisVC *analysisVC;
@property (nonatomic, strong) YYTimer *timer;

// 竖屏显示路线选择
@property(nonatomic, strong) QukanLiveLinePopUpView *popUpView;
// 横屏显示路线选择
@property(nonatomic, strong) QukanScreenLiveLineView  *liveLineView;


/**记录滑动的比例*/
@property(nonatomic, assign) CGFloat   gradientProgress;
/**虚拟导航栏  用于方便控制显示隐藏*/
@property(nonatomic, strong)  QukanMatchDetailCustomNav  * view_customNav;
// 用于展示输入框
@property(nonatomic, strong) QukanNewsComentView *Qukan_FooterView;

//刷新按钮
@property(nonatomic, strong) QukanRefreshControl *refreshBtn;

@property(nonatomic, copy) NSDictionary<NSString *, UIViewController *> *controllersDic;


@end

@implementation QukanBasketDetailVC

#pragma mark ===================== Life Cycle ==================================

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self openOrCloseVideoLandscapeLock:YES];
    _player.forceDeviceOrientation = YES;
    _player.allowOrentitaionRotation = YES;
    if (self.player.currentPlayerManager.playState == ZFPlayerPlayStatePaused) {
        [self.player.currentPlayerManager play];
    }
    [self Qukan_selectScoreRed];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _player.forceDeviceOrientation = NO;
    _player.allowOrentitaionRotation = NO;
    [self openOrCloseVideoLandscapeLock:NO];
    
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.player.currentPlayerManager.playState == ZFPlayerPlayStatePlaying) {
        [self.player.currentPlayerManager pause];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.pagerView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - kSafeAreaBottomHeight);
    self.view_customNav.frame = CGRectMake(0, 0, kScreenWidth, kStatusBarHeight + 44);
    [self.view bringSubviewToFront:self.view_customNav];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hbd_barHidden = YES;
    self.view.backgroundColor = kCommentBackgroudColor;
    
//    NSString *str = [[NIMSDK sharedSDK] currentLogFilepath];
    
    _isAirPlaying = NO;
    _isCanAir = NO;
    _airPlayTimes = 0;
    _allAirPlayTimes = 0;
    self.Qukan_liveLineDatas = @[].mutableCopy;
    
    [self initSubViewControllers];
    [self layoutCategoryView];
    
    [self addNotifications];

    [self loadBaskballDetailData];
    [self Qukan_getLiveUrlWithType:100];
}

#pragma mark ===================== Private Methods =========================

- (void)initSubViewControllers {
    QukanTextLiveVC *vc1 = [QukanTextLiveVC new];
    vc1.model_main = self.Qukan_model;
    vc1.matchId = self.matchId;
    
    QukanLiveChatViewController * vc2 = [[QukanLiveChatViewController alloc] init];
    [vc2 setAD:self.detailModel];
    vc2.Qukan_FooterView = self.Qukan_FooterView;
    vc2.matchId = self.matchId.integerValue;
    vc2.isBasketball = YES;
    @weakify(self);
    vc2.liveChatVc_didBolck = ^(QukanHomeModels *model) {
        @strongify(self)
        [self.playerManager pause];
        [self adPushWay:model];
    };
    
    QukanBasketDetailDataVC * vc3 = [[QukanBasketDetailDataVC alloc] init];
    vc3.QukanMainMatchId_str = self.matchId;

    QukanBasketAnalysisVC * vc4 = [QukanBasketAnalysisVC new];
    vc4.navgation_vc = self.navigationController;
    vc4.analysisVc_didBolck = ^(QukanHomeModels * _Nonnull model) {
        @strongify(self)
        [self.playerManager pause];
        [self adPushWay:model];
    };
    
    QukanBasketIineupViewController * vc5 = [[QukanBasketIineupViewController alloc] init];
    vc5.navgiation_vc = self.navigationController;
    vc5.matchId = self.Qukan_model.matchId;

    self.controllersDic = @{@"文字直播":vc1,@"聊天":vc2,@"数据":vc3,@"分析":vc4,@"阵容":vc5};
}

- (void)addNotifications {
    @weakify(self)
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:Qukan_DeviceShouldRotate object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        NSString *currentOrientation  = [QukanAirPlayManager.sharedManager getCurrentOrientation];
        if ([currentOrientation isEqualToString:KDeviceIsPortrait]) {
            [self.player enterFullScreen:YES animated:YES];
            
        }else{
            [self.player enterFullScreen:NO animated:YES];
        }
    }];
    
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
    
    [[[kNotificationCenter rac_addObserverForName:Qukan_AirPlayConnectSucceed object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
         @strongify(self)
         [self.playerManager pause];
         self.isAirPlaying = YES;
         [self addAirPlayTime];
     }];
    
    // 需要转屏通知
    [[[kNotificationCenter rac_addObserverForName:Qukan_needRotatScreen_notificationName object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        [self.playerManager pause];
        [self.player enterFullScreen:NO animated:YES];
    }];
     
     [[[kNotificationCenter rac_addObserverForName:Qukan_AirPlayCancle object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
         @strongify(self);
         [self.playerManager play];
         self.isAirPlaying = NO;
         [self Qukan_AddTodayTimeWithTime:(self.airPlayTimes / 2)];
         self.allAirPlayTimes = self.allAirPlayTimes + self.airPlayTimes;
         self.airPlayTimes = 0;
     }];
     
     [[[kNotificationCenter rac_addObserverForName:Qukan_airPlayTips object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
         @strongify(self)
         if (self.isAirPlaying) {
            [self.playerManager pause];
             
         }
     }];
}

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
- (void)Qukan_AddTodayTimeWithTime:(NSInteger)time {
    if (![kUserManager isLogin]) {
        return;
    }
    NSString *timeStr = [NSString stringWithFormat:@"%ld",time];
    @weakify(self)
    [[[kApiManager QukanAddTodayTime:timeStr WithMatchId:self.matchId.integerValue] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        KHideHUD
        DEBUGLog(@"%@",x);
        DEBUGLog(@"看了多少呢%@",timeStr);
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        KHideHUD
    }];
}

// 重新设置分页视图距离顶部的位置 --- 在播放视频或者播放动画直播的时候使其不能上滑
- (void)resetPinSectionHeaderVerticalOffset {
//    if (self.bool_isAni || self.containerView.superview || self.int_selectIndex == 1) {
//        self.pagerView.pinSectionHeaderVerticalOffset = kPlayerViewHeight + kStatusBarHeight;
//    }else {
//        self.pagerView.pinSectionHeaderVerticalOffset = kTopBarHeight;
//    }
//
//    [self.pagerView reloadData];
}


- (void)initTimer {
    _timer = [YYTimer timerWithTimeInterval:60 target:self selector:@selector(loadBaskballDetailData) repeats:YES];
    
}
- (void)stopTimer {
    [_timer invalidate];
}

- (RACSignal *)animateSignal {
    if (self.animateUrlString.length) {
        return [RACSignal return:self.animateUrlString];
    }
    
    return [kApiManager QukanFetchAnimationLiveWithMatchId:self.matchId];
}

- (void)loadBaskballDetailData {
    @weakify(self)
    RACSignal *detailSignal = [kApiManager QukanQueryMatchInfoWithMatchId:self.matchId];
    [[[RACSignal zip:@[detailSignal,[self animateSignal]]] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self)
        NSArray *array = x.first;
        self.detailModel = [QukanBasketBallMatchDetailModel modelWithDictionary:array.firstObject];
        self.detailModel.matchId = self.Qukan_model.matchId;
        if (self.detailModel.status.integerValue == -1) {
            [self stopTimer];
        }
        
        self.animateUrlString = x.second;
    
        [self.Qukan_headerView setData:self.detailModel animationUrl:self.animateUrlString];
        [self.view_customNav fullViewWithBasketModel:self.detailModel];
        
        //刷新按钮停止
        [self.refreshBtn endAnimation];
        
        [self Qukan_newsPage];
        [self Qukan_liveLineData];
        [self Qukan_selectScoreRed];
    }];
}


- (void)dealloc{
    DEBUGLog(@"dealloc");

    // 每次退出篮球详情界面时重新连接IM
    [[QukanIMChatManager sharedInstance] resetChatInfo];
}

#pragma mark ===================== NetWork ==================================

- (void)Qukan_getLiveUrlWithType:(NSInteger)type {
    [[[kApiManager QukanSelectMatchLiveWithMatchId:self.matchId] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
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
        
    }];
    
}

- (void)dataSourceDealWith:(id)response {
    [self.datas removeAllObjects];
    for (NSDictionary *dict in response) {
        QukanLiveLineModel *lineModel = [QukanLiveLineModel new];
        lineModel.aliM3u8Url = dict[@"cdnM3u8Url"];
        lineModel.aliFlvUrl = dict[@"cdnFlvUrl"];
        lineModel.aliRtmpUrl = dict[@"cdnRtmpUrl"];
        lineModel.liveName = dict[@"liveName"];
        lineModel.liveType = [dict[@"liveType"] integerValue];
         [self.datas addObject:lineModel];
    }
}

- (void)liveLineContrast {
    if (self.datas.count == self.datas.count) {
        [self dataSourceDealWith:self.datas];
    } else {//不一样的时s
        [self dataSourceDealWith:self.datas];
        [self openOrCloseVideoLandscapeLock:YES];
        
        [self addSelfActionAlert];
    }
}

- (void)setPlayerDataSourceWithModel:(QukanLiveLineModel *)liveLineModel {
    if (liveLineModel == nil) { return;}
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

- (void)dataSourceWith:(id)response {
    NSArray *array = (NSArray *)response;
    if (!array.count) {return;}
    for (NSDictionary *dict in array) {
        QukanHomeModels *model = [QukanHomeModels modelWithDictionary:dict];
        [self.Qukan_aDataArray addObject:model];
    }
    
}

- (void)Qukan_liveLineData {
    @weakify(self)
    [[[kApiManager QukanInfoWithType:42] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
       @strongify(self)
        [self dataSourceWithLineAd:x];
    } error:^(NSError * _Nullable error) {
    }];
}

- (void)dataSourceWithLineAd:(id)response {
    NSArray *array = (NSArray *)response;
    if (!array.count) {return;}
    for (NSDictionary *dict in array) {
        QukanHomeModels *model = [QukanHomeModels modelWithDictionary:dict];
        [self.Qukan_liveLineDatas addObject:model];
    }
}


//- (void)Qukan_gcUserExchangeAddTodayGTime {
//    if (![kUserManager isLogin]) {
//        return;
//    }
//    NSTimeInterval interval = self.player.currentTime;
//    NSInteger time = ceilf(interval);
//    NSString *timeStr = [NSString stringWithFormat:@"%ld",time];
//    @weakify(self)
//    [[[kApiManager QukanAddTodayTime:timeStr WithMatchId:self.Qukan_model.matchId.integerValue] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
//        @strongify(self)
//        KHideHUD
//        DEBUGLog(@"%@",x);
//        DEBUGLog(@"看了多少呢");
//    } error:^(NSError * _Nullable error) {
//        @strongify(self)
//        KHideHUD
//    }];
//}

- (void)Qukan_selectScoreRed {
    @weakify(self)
    [[[kApiManager QukanSelectDate] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        NSString *times = x[@"tpTime"];
        if ([times isEqualToString:@"0天"] || [times isEqualToString:@"0秒"]) {
            self.isCanAir = NO;
        } else {
            self.isCanAir = YES;
        }
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        self.isCanAir = NO;
    }];
}


#pragma mark ===================== Notification ==================================

//- (void)Qukan_changeLine:(NSNotification *)noti {
//    [self addActionAlert];
//}

- (void)Qukan_addLiveLineView:(NSNotification *)noti {
    [[NSNotificationCenter defaultCenter] postNotificationName:Qukan_GetLiveArray_NotificationName object:self.datas];
}

- (void)Qukan_leftBarButtonItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)Qukan_changeLineUrl:(NSNotification *)noti {
    NSInteger Tag = [noti.object integerValue];
    NSString *urlStr = nil;
    for (QukanLiveLineModel *lineModel in self.datas) {
        if (lineModel == nil) {return;}
        if (lineModel.liveType && lineModel.liveType == Tag) {
            urlStr = [self playerGetUrlWithModel:lineModel];
            _lineCurrenModel = lineModel;
        }
    }
    
    if (Tag == kQukanLiveType_Ad || Tag == kQukanLiveType_ThirdHdLive) {
        _liveType = Tag;
        [self appInterPushWithModel:_lineCurrenModel];
    } else {
        [self playerSetAgain:_lineCurrenModel];
    }
}

#pragma mark ===================== Layout ====================================
- (void)layoutCategoryView {

    self.categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(50, kPlayerViewHeight+kStatusBarHeight, kScreenWidth - 100, 40)];
    self.categoryView.backgroundColor = kCommonBlackColor;
    self.categoryView.delegate = self;
    NSMutableArray* titles = [NSMutableArray new];
//    if (self.Qukan_model.status == -1) {
//        [titles addObjectsFromArray: @[@"战况",@"聊天",@"数据",@"分析",@"阵容"]];
//    }else {
        [titles addObjectsFromArray: @[@"文字直播",@"聊天",@"数据",@"分析",@"阵容"]];
//    }

    self.categoryView.titles = titles;

    self.categoryView.titleSelectedColor = kThemeColor;
    
    self.categoryView.titleColor = HEXColor(0xA2A2A2);
    self.categoryView.titleColorGradientEnabled = YES;
    
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorColor = kThemeColor;
    self.categoryView.indicators = @[lineView];
    self.categoryView.contentScrollViewClickTransitionAnimationEnabled = NO;
    
    
    NSInteger selIndex = [titles indexOfObject:@"数据"];
    
    self.pagerView = [[JXPagerListRefreshView alloc] initWithDelegate:self];
    self.pagerView.defaultSelectedIndex = selIndex;
    self.categoryView.defaultSelectedIndex = selIndex;
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
    [self.view addSubview:self.Qukan_FooterView];
    self.Qukan_FooterView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kBottomBarHeight);
}


- (void)showInputView {
    [UIView animateWithDuration:0.3f animations:^{
        [self.pagerView.mainTableView setContentOffset:CGPointZero];
        self.Qukan_FooterView.frame = CGRectMake(0, kScreenHeight - kBottomBarHeight, kScreenWidth, kBottomBarHeight);
        [self.Qukan_FooterView layoutIfNeeded];
    }];
}

- (void)hiddenInputView {
    
    [UIView animateWithDuration:0.3f animations:^{
        self.Qukan_FooterView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kBottomBarHeight);
        [self.Qukan_FooterView layoutIfNeeded];
    }];
}


#pragma mark ===================== JXCategoryViewDelegate ==================================

//点击选中或者滚动选中都会调用该方法。适用于只关心选中事件，不关心具体是点击还是滚动选中的。
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    [self.view endEditing:YES];
    
    self.int_selectIndex = index;
    [self resetPinSectionHeaderVerticalOffset];
    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
    if ([self.categoryView.titles[index] isEqualToString:@"聊天"]) {
        [self showInputView];
    }else {
        [self hiddenInputView];
    }
    
    self.refreshBtn.hidden = ![self.categoryView.titles[index] isEqualToString:@"分析"];
}

#pragma mark ============================== JXPagerViewDelegate  ==============================

- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.Qukan_headerView;
}

- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    return kPlayerViewHeight + kStatusBarHeight;
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

- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    return (id<JXPagerViewListViewDelegate>)self.controllersDic[self.categoryView.titles[index]];
}

// 主滑动视图滑动代理  用于处理导航栏颜色改变
- (void)mainTableViewDidScroll:(UIScrollView *)scrollView {
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



#pragma mark ===================== Private Methods =========================
- (void)addSelfActionAlert {
    if (self.popUpView) {
        [self.popUpView removeFromSuperview];
        self.popUpView = nil;
    }
    
    self.popUpView =  [[QukanLiveLinePopUpView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.popUpView.delegate = self;
    [self.popUpView showWithBeginData:self.datas andAds:self.Qukan_liveLineDatas];
    [self openOrCloseVideoLandscapeLock:NO];
}


#pragma mark ===================== QukanLiveLinePopUpViewcDelegate ==================================

- (void)QukanLiveLinePopUpViewchooseCompletWithModel:(id)mainModel {
    if ([mainModel isKindOfClass:[QukanHomeModels class]]) {
        [self adPushWay:(QukanHomeModels *)mainModel];
    }
    
    if ([mainModel isKindOfClass:[QukanLiveLineModel class]]) {
        [self setPlayerDataSourceWithModel:(QukanLiveLineModel *)mainModel];
    }
}

- (void)QukanLiveLinePopUpViewRereaseView {
    [self openOrCloseVideoLandscapeLock:YES];
    self.popUpView = nil;
}

- (void)QukanLiveLinePopUpViewBtn_refreshClick {
    [self Qukan_getLiveUrlWithType:kQukanLivePort];
}


#pragma mark ===================== 广告处理 ==================================

- (void)appInterPushWithModel:(QukanLiveLineModel *)lineModel {
    if (_liveType == kQukanLiveType_ThirdHdLive || _liveType == kQukanLiveType_Ad) {//第三方 广告
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

- (void)addShareView {
    [kUMShareManager Qukan_showShareViewWithMainModel:self.detailModel Type:shareScreenTypePort superView:kwindowLast];
}


- (void)addFullSreenShareView {
    [kUMShareManager Qukan_showShareViewWithMainModel:self.detailModel Type:shareScreenTypeLand superView:self.player.controlView];
}

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
           [QukanTool Qukan_interfaceOrientation:UIInterfaceOrientationPortrait];
           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
               [self adPushWay:adModel];
           });
       };
       
       self.liveLineView.refreshBolck = ^{
           @strongify(self)
           [self Qukan_getLiveUrlWithType:kQukanLiveLand];
       };
}

- (NSString *)playerGetUrlWithModel:(QukanLiveLineModel *)lineModel {
    if (lineModel.aliM3u8Url && ![NSString isEmptyStr:lineModel.aliM3u8Url]) {
        return lineModel.aliM3u8Url;
    } else if (lineModel.aliFlvUrl && ![NSString isEmptyStr:lineModel.aliFlvUrl]) {
        return lineModel.aliFlvUrl;
    } else if (lineModel.aliRtmpUrl && ![NSString isEmptyStr:lineModel.aliRtmpUrl]) {
        return lineModel.aliRtmpUrl;
    } else {
        return (lineModel.liveUrl && ![NSString isEmptyStr:lineModel.liveUrl]) ? lineModel.liveUrl : @"";
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
    [self stopTimer];
    QukanAirPlayManager.sharedManager.urlString = urlStr;
    
    if (self.containerView.superview) {
        [self playerSetAgain:self.lineCurrenModel];
        return;
    }
    
    [self.view addSubview:self.statusMaskView];
    [self.view addSubview:self.containerView];
    self.player.controlView = self.controlView;
    
    [self resetPinSectionHeaderVerticalOffset];
    _playerManager.assetURL = [NSURL URLWithString:urlStr];
//    NSString *title = [NSString stringWithFormat:@"%@ VS %@",self.detailModel.homeTeam,self.detailModel.guestTeam];
    [self.controlView showTitle:@"" coverImage:[[UIImage imageNamed:@"Qukan_player_loading_bg"] imageWithColor:[UIColor clearColor]] fullScreenMode:ZFFullScreenModeAutomatic];
    
    self.view_customNav.hidden = YES;
    
    @weakify(self)
    self.playerManager.playerDidToEnd = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset) {
        @strongify(self)
        [self.controlView.portraitControlView resetControlView];
    };
    
    [self.controlView showGif:@"Qukan_Video_Loading"];
    //    self.animationImageView.hidden = NO;
    self.player.playerPrepareToPlay = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, NSURL * _Nonnull assetURL) {
        
    };
    
    self.player.playerReadyToPlay = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, NSURL * _Nonnull assetURL) {
        @strongify(self)
        [self.controlView hideGif];
    };
    
    self.player.playerLoadStateChanged = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, ZFPlayerLoadState loadState) {
        
    };
    
    self.player.playerPlayStateChanged = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, ZFPlayerPlaybackState playState) {
        
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
    self.controlView.LandImageView_didBlock = ^{
        @strongify(self)
        [self interfaceOrientation:UIInterfaceOrientationPortrait];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.controlView hideDataView];
            [self adPushWay:self.adCurrentModel];
        });

    };
    self.controlView.portraitControlView.changeLineBtnClickCallback = ^{
        @strongify(self)
        [self.view endEditing:YES];
        [self Qukan_getLiveUrlWithType:kQukanLivePort];
    };
    
    self.controlView.landScapeControlView.changeLineBtnClickCallback = ^{
        @strongify(self)
        [self addScreenView];
    };
    self.controlView.portraitControlView.shareBtnClickCallback = ^{
        @strongify(self)
        [self.view endEditing:YES];
        [self addShareView];
    };
    self.controlView.landScapeControlView.shareBtnClickCallback = ^{
        @strongify(self)
        [self addFullSreenShareView];
    };
    
    self.controlView.portraitControlView.refreshBtnClickCallback = ^{
        @strongify(self)
        //        [self setPlayerDataSource];
        [self playerSetAgain:self.lineCurrenModel];
    };
    
    self.controlView.landScapeControlView.refreshBtnClickCallback = ^{
        @strongify(self)
        [self playerSetAgain:self.lineCurrenModel];
    };
    
    //添加定时器
    [self addTimeMonitoring];
    [self addLookMatchUpdateTime];
}
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

//强制转屏
- (void)interfaceOrientation:(UIInterfaceOrientation)orientation
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector  = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = orientation;
        // 从2开始是因为0 1 两个参数已经被selector和target占用
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}
- (void)playerSetAgain:(QukanLiveLineModel *)lineModel {
    QukanAirPlayManager.sharedManager.urlString = [self playerGetUrlWithModel:lineModel];
    [self.controlView showGif:@"Qukan_Video_Loading"];
    [self.playerManager setAssetURL:[NSURL URLWithString:[self playerGetUrlWithModel:lineModel]]];
    [self.player playerReadyToPlay];
}

- (void)addTimeMonitoring {
    if (!self.Qukan_aDataArray.count) {return;}
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

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.player.isFullScreen) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return self.player.isStatusBarHidden || self.Qukan_headerView.bool_isHideState;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

#pragma mark ===================== Rotation ==================================
- (BOOL)shouldAutorotate {  // 控制转0
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

- (NSMutableArray<QukanLiveLineModel *> *)datas {
    if (!_datas) {
        _datas = [NSMutableArray new];
    }
    return _datas;
}

- (NSMutableArray *)Qukan_aDataArray {
    if (!_Qukan_aDataArray) {
        _Qukan_aDataArray = [NSMutableArray array];
    }
    return _Qukan_aDataArray;
}

- (ZFPlayerControlView *)controlView {
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
//            [self initTimer];
            //处理时间更新的问题
            NSTimeInterval interval = self.player.currentTime;
            NSInteger time = ceilf(interval);
            if (self.airPlayTimes > 1) { time = time - self.allAirPlayTimes;}
            [self Qukan_AddTodayTimeWithTime:time % QukanLiveTimeUpdate];
            [self.player stop];
            [self.containerView removeFromSuperview];
            [self.statusMaskView removeFromSuperview];
            
            self.view_customNav.hidden = NO;
            [self resetPinSectionHeaderVerticalOffset];
        };
        
        _controlView.portraitControlView.airPlayBtnClickCallback = ^{
            @strongify(self)
            [self.view endEditing:YES];
            if (!kUserManager.isLogin) {kGuardLogin}
            if (self.isCanAir) {
                [QukanAirPlayDeviceListView show];
            } else {
                [self.playerManager pause];
                QukanPersonDetailViewController *vc = [[QukanPersonDetailViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        };
        _controlView.landScapeControlView.backBtnClickCallback = ^{
//            @strongify(self)
//            [self initTimer];
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
            [self.controlView showGif:@"Qukan_Video_Loading"];
            [self.player.currentPlayerManager reloadPlayer];
        };
    }
    return _controlView;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, kScreenWidth, kPlayerViewHeight)];
        _containerView.backgroundColor = kCommonBlackColor;
    }
    return _containerView;
}

// https://www.jianshu.com/p/80c56f47a870     ijkplayer 参数说明文档
- (ZFIJKPlayerManager *)playerManager {
    if (!_playerManager) {
        _playerManager = [[ZFIJKPlayerManager alloc] init];
    }
    return _playerManager;
}

- (ZFPlayerController *)player {
    if (!_player) {
        _player = [ZFPlayerController playerWithPlayerManager:self.playerManager containerView:self.containerView];
        _player.forceDeviceOrientation = YES;
        _player.allowOrentitaionRotation = YES;
    }
    
    return _player;
}

- (UIView *)statusMaskView {
    if (!_statusMaskView) {
        _statusMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kTopBarHeight)];
        _statusMaskView.backgroundColor = kCommonBlackColor;
    }
    
    return _statusMaskView;
}

- (QukanBasketDetailHeaderView *)Qukan_headerView {
    if (!_Qukan_headerView) {
        _Qukan_headerView = [[QukanBasketDetailHeaderView alloc] init];
        @weakify(self);
        _Qukan_headerView.viewController = self;
        
        // 视频播放按钮点击   弹出线路
        [[_Qukan_headerView rac_signalForSelector:@selector(btn_videoPlayClick:)] subscribeNext:^(RACTuple * _Nullable x) {
            @strongify(self)
            [self.view endEditing:YES];
            [self addSelfActionAlert];
//            [self Qukan_getLiveUrlWithType:]
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
//            self.bool_isAni = YES;
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
        
        //球队点击
        [[_Qukan_headerView rac_signalForSelector:@selector(btn_teamClick:)] subscribeNext:^(RACTuple * _Nullable x) {
            @strongify(self);
            UIButton *btn = x.first;
            QukanBSKTeamDetialViewController *vc = [QukanBSKTeamDetialViewController new];
            if (btn.tag == Tag_awayTeam) {
                vc.teamId = self.detailModel.guestTeamId;
            } else {
                vc.teamId = self.detailModel.homeTeamId;
            }
            if (self.detailModel.xtype.integerValue == 1) {
                [self.navigationController pushViewController:vc animated:YES];
            }
        }];
    }
    return _Qukan_headerView;
}


- (QukanNewsComentView *)Qukan_FooterView {  // 输入框弹出， 放在主控制器中
    if (!_Qukan_FooterView) {
        _Qukan_FooterView = [[QukanNewsComentView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) withType:CommentView_basketBall];
        
        _Qukan_FooterView.titleLabel.text = kUserManager.isLogin ? @"我也聊聊~" : @"请先登录";
        


//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.titleLabel.font = kFont10;
//        [btn setTitle:@"只看主持人" forState:UIControlStateNormal];
//        [btn setTitle:@"只看群聊" forState:UIControlStateSelected];
//        btn.backgroundColor = kCommonTextColor;
//
//        btn.layer.cornerRadius = 12.5;
//        [btn setTitleColor:HEXColor(0xffffff) forState:UIControlStateNormal];
//        [_Qukan_FooterView addSubview:btn];
//
//
//        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.trailing.mas_equalTo(-15);
//            make.width.mas_equalTo(71);
//            make.height.mas_equalTo(25);
//            make.top.mas_equalTo(12);
//        }];

//
//        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
//            @strongify(self)
//            btn.selected = !btn.selected;
//            if (self.vc_chatVC) {
//                [self.vc_chatVC onlyCompClick:btn];
//            }
//        }];
        
        @weakify(self)

//        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
//            @strongify(self)
//            btn.selected = !btn.selected;
//            if (self.vc_chatVC) {
//                [self.vc_chatVC onlyCompClick:btn];
//            }
//        }];
        
        self.Qukan_FooterView.putBlock = ^(NSInteger type) {
            @strongify(self)
            kGuardLogin
            QukanLiveChatViewController *vc = (QukanLiveChatViewController *)self.controllersDic[@"聊天"];
            [vc showInputView];
        };
    }
    return _Qukan_FooterView;
}


- (QukanMatchDetailCustomNav *)view_customNav {   // 模拟导航栏  方便布局
    if (!_view_customNav) {
        _view_customNav = [[QukanMatchDetailCustomNav alloc] initWithFrame:CGRectZero];
        
        // 返回动作
        @weakify(self);
        [[_view_customNav rac_signalForSelector:@selector(btn_backClick)] subscribeNext:^(RACTuple * _Nullable x) {
            @strongify(self);
//            self.bool_isAni = NO;
            [self resetPinSectionHeaderVerticalOffset];
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



- (QukanRefreshControl *)refreshBtn {
    if (!_refreshBtn) {
        _refreshBtn = [[QukanRefreshControl alloc] initWithFrame:CGRectMake(kScreenWidth - SCALING_RATIO(70),
                                                                            kScreenHeight - SCALING_RATIO(90),SCALING_RATIO(80), SCALING_RATIO(80)) relevanceScrollView:[UIScrollView new]];
        
        @weakify(self)
        _refreshBtn.beginRefreshBlock = ^{
            @strongify(self)
            //事件
            [self loadBaskballDetailData];
        };
        
        _refreshBtn.hidden = YES;
        
        [self.view addSubview:_refreshBtn];
        [self.view bringSubviewToFront:_refreshBtn];
    }
    return _refreshBtn;
}

@end

