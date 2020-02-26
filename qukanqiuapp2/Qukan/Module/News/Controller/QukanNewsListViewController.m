//
//  QukanNewsListViewController.m
//  Qukan
//
//  Created by pfc on 2019/7/15.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanNewsListViewController.h"
#import "ZFTableViewCell.h"
#import <ZFPlayer/ZFPlayerController.h>
#import <ZFPlayer/ZFAVPlayerManager.h>
#import "ZFPlayerControlView.h"
#import <UITableView+YYAdd.h>

#import "QukanNewsTableViewCell.h"
#import "QukanGDataTableViewCell.h"
#import "QukanNewsCellLayout.h"
#import "QukanApiManager+News.h"
#import "QukanApiManager+info.h"
#import "QukanApiManager+PersonCenter.h"
#import "QukanShareView.h"
#import "QukanGViewController.h"

#import "QukanNewsChannelModel.h"

#import "QukanTYCyclePagerView.h"
#import "QukanTYPageControl.h"
#import "QukanNewCollectionViewCell.h"
#import "QukanNewsDetailsViewController.h"

#import "QukanScreenLiveLineView.h"
#import "QukanNewsSearchViewController.h"

#import "QukanHomeModels.h"

#define AdNumber 5
#define isPointAndAd self.channel.channelId == -2 && self.gDatas.count

@interface QukanNewsListViewController ()<UITableViewDataSource, UITableViewDelegate,ZFTableViewCellDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, QukanTYCyclePagerViewDelegate, QukanTYCyclePagerViewDataSource, UISearchBarDelegate>

@property(nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) QukanTYCyclePagerView *pagerView;
@property (nonatomic, strong) QukanTYPageControl *pageControl;
@property(nonatomic, strong) QukanHomeModels *bannerModel;
@property(nonatomic, strong) NSArray <QukanHomeModels *>    *gModels;
@property(nonatomic, strong) QukanShareView       *Qukan_ShareView;

@property (nonatomic, strong, readwrite) ZFPlayerController *player;
@property (nonatomic, strong) ZFPlayerControlView *controlView;

@property (nonatomic, strong) NSMutableArray<QukanNewsModel *> *datas;
@property (nonatomic, strong) NSMutableArray<QukanHomeModels *> *gDatas;
@property (nonatomic, strong) NSArray <QukanHomeModels *>       *originals;
//@property (nonatomic, strong) NSArray *layouts; // QukanNewsCellLayout & ZFTableViewCellLayout
@property (nonatomic, strong) NSArray *adLayouts;//ToicHomeAdCell
@property (nonatomic, strong) NSMutableArray *variableLayouts;

@property(nonatomic, assign) NSInteger page;
@property(nonatomic, assign) BOOL isRequesting; // 是否在加载列表数据中

@property(nonatomic, assign) BOOL      isFullScreen;
@property(nonatomic, assign) BOOL      isBannerPlayer;
@property(nonatomic, assign) BOOL      isUse;


/**<#注释#>*/
@property(nonatomic, strong) UISearchBar   * QukanSeachMain_searchBar;

@end

@implementation QukanNewsListViewController

#pragma mark ===================== Life Cycle ==================================

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = kViewControllerBackgroundColor;
    self.page = 1;
    self.datas = @[].mutableCopy;
    self.gDatas = @[].mutableCopy;
//    self.layouts = @[].mutableCopy;
    self.adLayouts = @[].mutableCopy;
    self.isFullScreen = NO;
    self.isBannerPlayer = NO;
    self.isUse = YES;
    
    [self layoutViews];
    
    [self createPlayer];
    
    [self loadCacheData];
    [self requestData];
    [self Qukan_newsPage];
    
    [self addNotification];
}

- (void)addNotification {
    @weakify(self)
    [[[kNotificationCenter rac_addObserverForName:kFilterNewsNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        if ([x.object isKindOfClass:[NSString class]]) {
            @synchronized (self.datas) {
                NSString*newsId = x.object;
                id remove = nil;
                for (id model in self.datas) {
                    if ([model isKindOfClass:[QukanNewsModel class]]) {
                        QukanNewsModel *indexModel = (QukanNewsModel *)model;
                        if (indexModel.nid == newsId.integerValue) {
                            remove = indexModel;
                            break;
                        }
                    }
                }
                if (!remove) {
                    return;
                }
                [self.datas removeObject:remove];
                [self.tableView reloadData];
            }
            [self.view showTip:@"将减少类似的内容推荐"];
        }
    }];
    
    // 需要转屏通知
       [[[kNotificationCenter rac_addObserverForName:Qukan_needRotatScreen_notificationName object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
           @strongify(self)
           [self.player.currentPlayerManager pause];
           [self.player enterFullScreen:NO animated:YES];
       }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

}

#pragma mark ===================== Notification ==================================
- (void)creatSeachBar {
   
}

#pragma mark ===================== NetWork ==================================

- (void)loadCacheData {
    NSArray *news = [kCacheManager QukangetCacheNewsWithChannelId:self.channel.channelId];
    if (news) {
        self.datas = [NSMutableArray arrayWithArray:news];
//        self.layouts = [self.datas.rac_sequence map:^id _Nullable(QukanNewsModel * _Nullable value) {
//            if (value.newType == QukanNewsType_web) {
//                QukanNewsCellLayout *layout = [[QukanNewsCellLayout alloc] initWithNewsModel:value];
//                return layout;
//            }else {
//                ZFTableViewCellLayout *layout = [[ZFTableViewCellLayout alloc] initWithData:value];
//                return layout;
//            }
//        }].array;
        
        [self.tableView reloadData];
    }
}

- (void)requestData {
    NSInteger channelId = self.channel.channelId;
    [self Qukan_newsChannelAdv:channelId];
    
    self.isRequesting = YES;
    if (!self.datas.count) {
        KShowHUD;
    }
    @weakify(self)
    [[kApiManager QukanacquireNewsListWithLeagueId:self.channel.channelId
                                         Page:self.page
                                     pageSize:10] subscribeNext:^(NSArray *  _Nullable array) {
        
        @strongify(self)
        KHideHUD
        self.isRequesting = NO;
        
        NSArray *x = [array.rac_sequence filter:^BOOL(QukanNewsModel *  _Nullable value) {
//            NSNumber *num = [NSNumber numberWithInteger:[value.newsId integerValue]];
            return ![[QukanFilterManager sharedInstance] isFilteredNews:value.nid];
        }].array;
        
        if (self.page == 1 || self.datas.count == 0) {
            self.datas = [NSMutableArray arrayWithArray:x];
            [self.tableView.mj_header endRefreshing];
            
            [kCacheManager QukancacheNewsListDataWithDatas:x ChannelId:self.channel.channelId];
        }else {
            [self.datas addObjectsFromArray:x];
        }
        self.page += 1;
        
        self.tableView.mj_footer.hidden = self.datas.count == 0;
        if (array.count < 10) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else {
            [self.tableView.mj_footer endRefreshing];
        }
        
        NSArray *uniqeDatas = self.datas.rac_sequence.distinctUntilChanged.array;
        self.datas = [NSMutableArray arrayWithArray:uniqeDatas];
        [self.tableView reloadData];
        
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        KHideHUD
        
        self.isRequesting = NO;
        [self.view showTip:error.localizedDescription];
    }];
}

- (void)Qukan_newsPage {
    @weakify(self)
    [[[kApiManager QukanInfoWithType:19] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
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
        [self.gDatas addObject:model];
    }
    [self.tableView reloadData];
}

- (void)Qukan_newsChannelAdv:(NSInteger)channelId {
    
    NSArray *channelIds = @[[self getChannelIdWithChannelCid:kNews35],[self getChannelIdWithChannelCid:kNews36],[self getChannelIdWithChannelCid:kNews37],[self getChannelIdWithChannelCid:kNews38],[self getChannelIdWithChannelCid:kNews39],[self getChannelIdWithChannelCid:kNews40],[self getChannelIdWithChannelCid:kNews41],[self getChannelIdWithChannelCid:kNews42],[self getChannelIdWithChannelCid:kNews43],[self getChannelIdWithChannelCid:kNews44],[self getChannelIdWithChannelCid:kNews45],[self getChannelIdWithChannelCid:kNews46],[self getChannelIdWithChannelCid:kNews47],[self getChannelIdWithChannelCid:kNews48],[self getChannelIdWithChannelCid:kNews49]];
    NSArray *adChanneIds = @[@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40"];
    __block NSInteger chanId = 0;
    chanId = channelId;
    @weakify(self)
    [channelIds enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        @strongify(self)
        if (channelId == [obj integerValue]) {
            chanId = [adChanneIds[idx] integerValue];
            *stop = YES;
        }
    }];
    
    [[[kApiManager QukanInfoWithType:chanId] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        NSArray *items = [NSArray modelArrayWithClass:[QukanHomeModels class] json:x];
        self.gModels = items;
        if (!items.count) {
            self.pageControl.numberOfPages = 0;
            [self.pagerView reloadData];
            self.tableView.tableHeaderView = nil;
            return;
        }
        self.pagerView.isInfiniteLoop = items.count > 1;
        self.pageControl.numberOfPages = items.count;
        [self.pagerView reloadData];
        self.tableView.tableHeaderView = self.pagerView;
    } error:^(NSError * _Nullable error) {
    }];
}

- (void)Qukan_userReadAddWithModel:(QukanNewsModel *)newsModel {
    if (newsModel.newType == QukanNewsType_video) {
        @weakify(self)
        [[[kApiManager QukanUserReadAddWithSourceId:newsModel.nid WithSourceType:newsModel.newType WithStopTime:0] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            DEBUGLog(@"成功啦");
            KHideHUD
        } error:^(NSError * _Nullable error) {
        }];
    }
}

#pragma mark ===================== Public Methods =======================

- (void)stopCurrentCellPlay {
    NSIndexPath *currentPlayIndexPath = self.tableView.zf_playingIndexPath;
    if (currentPlayIndexPath && self.datas.count > currentPlayIndexPath.row) {
        QukanNewsModel *model = self.datas[currentPlayIndexPath.row];
        model.currentTime = self.player.currentTime;
        [self.player stopCurrentPlayingCell];
        [self Qukan_userReadAddWithModel:model];
    }
}

- (void)refreshNewsList {
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark ===================== Private Methods =========================

- (void)layoutViews {
    [self createTableView];
    
    
    [self.view addSubview:self.tableView];
    if (self.channel.channelId == -10000) {
        [self.view addSubview:self.QukanSeachMain_searchBar];
        [self.QukanSeachMain_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.view);
            make.height.equalTo(@(50));
        }];
        
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.QukanSeachMain_searchBar.mas_bottom);
        }];
    }else {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
}


- (void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.emptyDataSetSource = self;
    _tableView.emptyDataSetDelegate = self;
    
    _tableView.estimatedRowHeight = 0.0f;
    _tableView.estimatedSectionFooterHeight = 0.0f;
    _tableView.estimatedSectionHeaderHeight = 0.;

    _tableView.tableFooterView = [UIView new];
    [_tableView registerClass:[ZFTableViewCell class] forCellReuseIdentifier:NSStringFromClass([ZFTableViewCell class])];
    [_tableView registerClass:[QukanNewsTableViewCell class] forCellReuseIdentifier:NSStringFromClass([QukanNewsTableViewCell class])];
    [_tableView registerClass:[QukanGDataTableViewCell class] forCellReuseIdentifier:NSStringFromClass([QukanGDataTableViewCell class])];
    
    @weakify(self)
    self.tableView.mj_header = [QukanHomeRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self)
        self.page = 1;
        [self requestData];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self)
        [self requestData];
    }];
    self.tableView.mj_footer.hidden = YES;
}

- (void)Qukan_addShareView {
 
    QukanNewsModel *currentModel = [QukanNewsModel new];
    NSIndexPath *currentPlayIndexPath = self.tableView.zf_playingIndexPath;
    if (currentPlayIndexPath) {
        QukanNewsModel *model;
        if (self.channel.channelId == -2 && self.gDatas.count) {
            model = self.datas[currentPlayIndexPath.row - currentPlayIndexPath.row / (AdNumber + 1)];
        } else {
            model = self.datas[currentPlayIndexPath.row];
        }
        model.currentTime = self.player.currentTime;
        currentModel = model;
    }
    
    [kUMShareManager Qukan_showShareViewWithMainModel:currentModel Type:shareScreenTypeLand superView:self.player.controlView];
    
}

- (void)createPlayer {
    /// playerManager
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
//    playerManager.scalingMode = ZFPlayerScalingModeAspectFill;

    /// player的tag值必须在cell里设置
    self.player = [ZFPlayerController playerWithScrollView:self.tableView playerManager:playerManager containerViewTag:kPlayerInCellContainerViewTag];
    self.player.controlView = self.controlView;
    self.player.shouldAutoPlay = YES;
    self.player.playerDisapperaPercent = 1.0;
    self.player.stopWhileNotVisible = NO;
    self.player.forceDeviceOrientation = YES;
    self.player.allowOrentitaionRotation = YES;
    
    
    @weakify(self)
    self.player.playerPlayStateChanged = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, ZFPlayerPlaybackState playState) {
        @strongify(self)
        if (playState == ZFPlayerPlayStatePlayStopped) {
            NSIndexPath *currentPlayIndexPath = self.tableView.zf_playingIndexPath;
            if (currentPlayIndexPath && self.player.currentTime > 1) {
                if (self.channel.channelId == -2 && self.gDatas.count) {
                    QukanNewsModel *model = self.datas[currentPlayIndexPath.row - currentPlayIndexPath.row / AdNumber];
                    model.currentTime = self.player.currentTime;
                } else {
                    QukanNewsModel *model = self.datas[currentPlayIndexPath.row];
                    model.currentTime = self.player.currentTime;
                }
            }
        }
    };
    
    self.player.zf_playerDidDisappearInScrollView = ^(NSIndexPath * _Nonnull indexPath) {
        @strongify(self)
        if (self.player.currentTime > 1) {
            if (self.channel.channelId == -2 && self.gDatas.count) {
                QukanNewsModel *model = self.datas[indexPath.row - indexPath.row / AdNumber];
                model.currentTime = self.player.currentTime;
            } else {
                QukanNewsModel *model = self.datas[indexPath.row];
                model.currentTime = self.player.currentTime;
            }
        }
        [self.player stopCurrentPlayingCell];
    };
    
    self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
        @strongify(self)
        [self setNeedsStatusBarAppearanceUpdate];
        [UIViewController attemptRotationToDeviceOrientation];
        self.tableView.scrollsToTop = !isFullScreen;
        self.isFullScreen = isFullScreen;
        
        for (UIView *view  in self.controlView.subviews) {
            if ([view isKindOfClass:[QukanShareView class]]) {
                [view removeFromSuperview];
            }
        }
        
        //键盘消失呢
        [self.view endEditing:YES];
    };
    
    self.player.orientationDidChanged = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) {
            DEBUGLog(@"por");
        }else {
            DEBUGLog(@"land");
        }
        
        @strongify(self);
        for (UIView *view  in self.player.controlView.subviews) {
            if ([view isKindOfClass:[QukanShareView class]]) {
                [view removeFromSuperview];
            }
        }
        
        for (UIView *view in self.player.controlView.subviews) {
            if ([view isKindOfClass:[QukanScreenLiveLineView class]]) {
                [view removeFromSuperview];
            }
        }
        
    };
    
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        @strongify(self)
        NSIndexPath *indexPath = self.tableView.zf_playingIndexPath;
        if (indexPath && indexPath.row < self.datas.count) {
            if (self.channel.channelId == -2 && self.gDatas.count) {
                QukanNewsModel *model = self.datas[indexPath.row - indexPath.row / AdNumber];
                model.currentTime = 0;
            } else {
                QukanNewsModel *model = self.datas[indexPath.row];
                model.currentTime = 0;
            }
        }

        if (self.isBannerPlayer) {
            [self.player stopCurrentPlayingView];
        } else {
            [self.player stopCurrentPlayingCell];
        }
    };
}

/// play the video
- (void)playTheVideoAtIndexPath:(NSIndexPath *)indexPath scrollToTop:(BOOL)scrollToTop {
    QukanNewsModel *indexModel;
    if (self.channel.channelId == -2 && self.gDatas.count) {
        indexModel = self.datas[indexPath.row - indexPath.row / (AdNumber + 1)];
    } else {
        indexModel = self.datas[indexPath.row];
    }
    if (indexPath == nil) {return ;}//layout.data.title
    [self.controlView showTitle:@""
                 coverURLString:indexModel.imageUrl
                 fullScreenMode:ZFFullScreenModeLandscape]; // 不让竖屏全屏播放
    [self.player playTheIndexPath:indexPath assetURL:[NSURL URLWithString:indexModel.videoUrl] scrollToTop:scrollToTop];
    if (indexModel.currentTime > 1) {
        [self.player.currentPlayerManager seekToTime:indexModel.currentTime-1 completionHandler:^(BOOL finished) {
            
        }];
    }
    self.isBannerPlayer = NO;
    [self Qukan_userReadAddWithModel:indexModel];
}

- (void)playTheVideoAtBanerWith:(QukanNewsModel *)model {
    [self.controlView showTitle:model.title
                 coverURLString:model.imageUrl
                 fullScreenMode:ZFFullScreenModeAutomatic];
    [self.player setAssetURL:[NSURL URLWithString:model.videoUrl]];
    self.isBannerPlayer = YES;
}

#pragma mark ===================== UISearchBarDelegate ==================================

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    QukanNewsSearchViewController *vc = [QukanNewsSearchViewController new];
    vc.hidesBottomBarWhenPushed = 1;
    [self.navigationController pushViewController:vc animated:YES];
    return NO;
}

#pragma mark ===================== TYCyclePagerViewDataSource ==================================

- (NSInteger)numberOfItemsInPagerView:(QukanTYCyclePagerView *)pageView {
    if (self.gModels.count) {
        return self.gModels.count;
    }
    return 0;
}

- (UICollectionViewCell *)pagerView:(QukanTYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    QukanNewCollectionViewCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndex:index];
    QukanHomeModels *model = self.gModels[index];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:kImageNamed(@"Qukan_placeholder")];
    return cell;
}

- (QukanTYCyclePagerViewLayout *)layoutForPagerView:(QukanTYCyclePagerView *)pageView {
    QukanTYCyclePagerViewLayout *layout = [[QukanTYCyclePagerViewLayout alloc]init];
    layout.itemSize = pageView.size;
    layout.itemSpacing = 15;
    //layout.minimumAlpha = 0.3;
    layout.itemHorizontalCenter = YES;
    return layout;
}

- (void)pagerView:(QukanTYCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    _pageControl.currentPage = toIndex;
    //[_pageControl setCurrentPage:newIndex animate:YES];
    
}

- (void)pagerView:(QukanTYCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index {
    if (self.player.currentPlayerManager.isPlaying) {
        [self.player stopCurrentPlayingCell];
    }
    
    QukanHomeModels *model = self.gModels.count > index ? self.gModels[index] : nil;
    if ([model.jump_type intValue] == QukanViewJumpType_In) {//内部
        [self.player.currentPlayerManager pause];
        QukanGViewController *vc = [[QukanGViewController alloc] init];
        vc.url = model.v_url;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navController pushViewController:vc animated:YES];
    } else if ([model.jump_type intValue] == QukanViewJumpType_Out) {//外部
        [self.player.currentPlayerManager pause];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.v_url]];
    } else if ([model.jump_type intValue] == QukanViewJumpType_AppIn) {
        
    } else if ([model.jump_type intValue] == QukanViewJumpType_Other) {
        [self.player.currentPlayerManager pause];
        QukanGViewController *vc = [[QukanGViewController alloc] init];
        NSString *url = [NSString stringWithFormat:@"%@?adType=%@&bunleId=%@&appKey=%@",model.v_url,model.type,Qukan_AppBundleId,Qukan_OpeninstallKey];
        vc.url = url;
        
        vc.hidesBottomBarWhenPushed = YES;
        [self.navController pushViewController:vc animated:YES];
    }
}

#pragma mark ===================== 旋转 & 状态栏 ==================================

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.player.isFullScreen && self.player.orientationObserver.fullScreenMode == ZFFullScreenModeLandscape) {
        return UIInterfaceOrientationMaskLandscape;
    }
    return UIInterfaceOrientationMaskPortrait;
}

//- (BOOL)shouldAutorotate {
//    /// 如果只是支持iOS9+ 那直接return NO即可，这里为了适配iOS8
//    return self.player.shouldAutorotate;
//}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.player.isFullScreen) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return self.player.isStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

#pragma mark - UIScrollViewDelegate 列表播放必须实现

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidEndDecelerating];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [scrollView zf_scrollViewDidEndDraggingWillDecelerate:decelerate];
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidScrollToTop];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidScroll];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewWillBeginDragging];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.channel.channelId == -2 && self.gDatas.count) {
        long count = self.datas.count + self.datas.count / AdNumber;
        return count;
    } else {
        return self.datas.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.channel.channelId == -2 && self.gDatas.count) {  // 有广告的情况
        if ((indexPath.row + 1) % (AdNumber + 1) == 0 && indexPath.row > AdNumber - 1) {
            QukanGDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QukanGDataTableViewCell class])];
            QukanHomeModels *adModel = self.gDatas[indexPath.row / (AdNumber + 1)  % self.gDatas.count];
            [cell Qukan_SetNewsGDataWith:adModel];
            return cell;
        } else {
            QukanNewsModel *indexModel = self.datas[indexPath.row - indexPath.row / (AdNumber + 1)];
            if (indexModel.newType == QukanNewsType_video) {
                ZFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZFTableViewCell class])];
                [cell setDelegate:self withIndexPath:indexPath];
                [cell setDataWithModel:indexModel];
                [cell setNormalMode];
                return cell;
            }else if (indexModel.newType == QukanNewsType_web) {
                QukanNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QukanNewsTableViewCell class])];
                [cell setDataWithModel:indexModel];
                return cell;
            }
        }
    } else {
        QukanNewsModel *indexModel = self.datas[indexPath.row];
        if (indexModel.newType == QukanNewsType_video) {
            ZFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZFTableViewCell class])];
            [cell setDelegate:self withIndexPath:indexPath];
            [cell setDataWithModel:indexModel];
            [cell setNormalMode];
            return cell;
        }else if (indexModel.newType == QukanNewsType_web) {
            QukanNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QukanNewsTableViewCell class])];
            [cell setDataWithModel:indexModel];
            return cell;
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.channel.channelId == -2 && self.gDatas.count) {
        if ( (indexPath.row + 1) % (AdNumber + 1) == 0 && indexPath.row > AdNumber - 1) {
            QukanHomeModels *model = self.gDatas[indexPath.row / 6  % self.gDatas.count];
            if ([model.jump_type intValue] == QukanViewJumpType_In) {//内部
                QukanGViewController *vc = [[QukanGViewController alloc] init];
                vc.url = model.v_url;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navController pushViewController:vc animated:YES];
            } else if ([model.jump_type intValue] == QukanViewJumpType_Out) {//外部
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.v_url]];
            } else if ([model.jump_type intValue] == QukanViewJumpType_AppIn) {
                
            } else if ([model.jump_type intValue] == QukanViewJumpType_Other) {
                QukanGViewController *vc = [[QukanGViewController alloc] init];
                NSString *url = [NSString stringWithFormat:@"%@?adType=%@&bunleId=%@&appKey=%@",model.v_url,model.type,Qukan_AppBundleId,Qukan_OpeninstallKey];
                vc.url = url;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navController pushViewController:vc animated:YES];
            }
            return;
        }
    }
    id currentModel;
    if (self.channel.channelId == -2 && self.gDatas.count) {
        currentModel = self.datas[indexPath.row - indexPath.row / (AdNumber + 1)];
    } else {
        currentModel = self.datas[indexPath.row];
    }
    if ([currentModel isKindOfClass:[QukanNewsModel class]]) {
        QukanNewsModel *model = currentModel;
        if (model.topicNewsType == QukanNewsType_web) {
            if (self.player.currentPlayerManager.isPlaying) {
                [self.player stopCurrentPlayingCell];
            }
            QukanNewsDetailsViewController *vc = [[QukanNewsDetailsViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.videoNews = model;
            @weakify(self)
            vc.detailsVcGoBack = ^{
                @strongify(self)
                [UIView performWithoutAnimation:^{
                    [self.tableView reloadRow:indexPath.row inSection:indexPath.section withRowAnimation:UITableViewRowAnimationNone];
                }];
            };
            [self.navController pushViewController:vc animated:YES];
        }else if (model.topicNewsType == QukanNewsType_video) {
            /// 如果正在播放的index和当前点击的index不同，则停止当前播放的index
            if (self.player.playingIndexPath != indexPath) {
                [self.player stopCurrentPlayingCell];
            }
            /// 如果没有播放，则点击进详情页会自动播放
            if (!self.player.currentPlayerManager.isPlaying) {
                [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
            }
            /// 到详情页
            QukanNewsDetailsViewController *detailVC = [QukanNewsDetailsViewController new];
            detailVC.player = self.player;
            detailVC.videoNews = model;
            @weakify(self)
            /// 详情页返回的回调
            detailVC.videoVCPopCallback = ^{
                @strongify(self)
                self.controlView.hideBackButton = YES;
                [self stopCurrentCellPlay];
                //            if (self.player.currentPlayerManager.playState == ZFPlayerPlayStatePlayStopped) {
                //                [self.player stopCurrentPlayingCell];
                //            } else {
                //                [self.player addPlayerViewToCell];
                //            }
            };
            /// 详情页点击播放的回调
            detailVC.videoVCPlayCallback = ^{
                @strongify(self)
                [self zf_playTheVideoAtIndexPath:indexPath];
            };
            detailVC.detailsVcGoBack = ^{
                @strongify(self)
                [self.tableView reloadRow:indexPath.row inSection:indexPath.section withRowAnimation:UITableViewRowAnimationNone];
            };
            self.controlView.hideBackButton = NO;
            detailVC.hidesBottomBarWhenPushed = YES;
            [self.navController pushViewController:detailVC animated:YES];
        }
    } 
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.channel.channelId == -2 && self.gDatas.count) {  // 有广告的情况
        if ((indexPath.row + 1) % (AdNumber + 1) == 0 && indexPath.row > AdNumber - 1) {
            return 68;
        } else {
            QukanNewsModel *indexModel = self.datas[indexPath.row - indexPath.row / (AdNumber + 1)];
            if (indexModel.newType == QukanNewsType_video) {
               return 240;
            }else if (indexModel.newType == QukanNewsType_web) {
                return 118;
            }
        }
    } else {
        QukanNewsModel *indexModel = self.datas[indexPath.row];
        if (indexModel.newType == QukanNewsType_video) {
             return 240;
        }else if (indexModel.newType == QukanNewsType_web) {
           return 118;
        }
    }
    return 0.001f;
}

#pragma mark - ZFTableViewCellDelegate

- (void)zf_playTheVideoAtIndexPath:(NSIndexPath *)indexPath {
    [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
}

#pragma mark ===================== Public Methods =======================

//得到渠道号
- (NSString *)getChannelIdWithChannelCid:(NSInteger)cid {
    NSArray *arrays = [kCacheManager QukangetChannelItems];
    for (QukanNewsChannelModel *channelModel in arrays) {
        if (channelModel.cid == cid) {
            return FormatString(@"%ld",channelModel.channelId);
        }
    }
    return NSString.new;
}

#pragma mark - getter

- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
        _controlView.hideBackButton = YES;
        _controlView.prepareShowLoading = YES;
        _controlView.portraitControlView.slider.minimumTrackTintColor = kThemeColor;
        _controlView.landScapeControlView.slider.minimumTrackTintColor = kThemeColor;
        _controlView.bottomPgrogress.minimumTrackTintColor = kThemeColor;
        
        @weakify(self)
        _controlView.retryBtnClickCallback = ^{
            @strongify(self)
            if (self.tableView.zf_playingIndexPath) {
                [self zf_playTheVideoAtIndexPath:self.tableView.zf_playingIndexPath];
            }
        };
        
        _controlView.portraitControlView.backBtnClickCallback = ^{
            @strongify(self)
            [self.navController popViewControllerAnimated:YES];
        };
        
        _controlView.landScapeControlView.shareBtnClickCallback = ^{
            @strongify(self)
            [self Qukan_addShareView];
        };
    }
    return _controlView;
}

- (QukanTYCyclePagerView *)pagerView {
    if (!_pagerView) {
        QukanTYCyclePagerView *pagerView = [[QukanTYCyclePagerView alloc]init];
        pagerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 180);
//        pagerView.layer.borderWidth = 1;
        pagerView.isInfiniteLoop = YES;
        pagerView.autoScrollInterval = 5.0;
        pagerView.dataSource = self;
        pagerView.delegate = self;
        [pagerView registerClass:[QukanNewCollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
        [pagerView addSubview:self.pageControl];
        _pagerView = pagerView;
    }
    
    return _pagerView;
}

- (QukanTYPageControl *)pageControl {
    if (!_pageControl) {
        QukanTYPageControl *pageControl = [[QukanTYPageControl alloc]init];
        pageControl.frame = CGRectMake(0, 180 - 26, kScreenWidth, 26);
        //pageControl.numberOfPages = _datas.count;
        pageControl.currentPageIndicatorSize = CGSizeMake(5, 5);
        pageControl.pageIndicatorSize = CGSizeMake(5, 5);
        pageControl.currentPageIndicatorTintColor = kThemeColor;
        pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:1 alpha:0.6];
        pageControl.pageIndicatorSpaing = 4;
        pageControl.hidesForSinglePage = YES;
        pageControl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        pageControl.contentInset = UIEdgeInsetsMake(0, 20, 0, 20);
        _pageControl = pageControl;
    }
    
    return _pageControl;
}


#pragma mark ===================== ZFTableViewCellDelegate ==================================

- (void)topic_playTheVideoAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
}

#pragma mark ===================== JXCategoryListContentViewDelegate ==================================

- (UIView *)listView {
    return self.view;
}

#pragma mark - DZNEmptyDataSetSource
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    UIFont *font = [UIFont boldSystemFontOfSize:14];
    NSString *description = @"暂无数据";
    return [[NSAttributedString alloc] initWithString:description attributes:@{NSFontAttributeName : font,NSForegroundColorAttributeName : [UIColor grayColor]}];
}
//
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *imageName = @"Qukan_Null_Data";
    return [UIImage imageNamed:imageName];
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    KShowHUD
    [self requestData];
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return !self.isRequesting;
}

#pragma mark - DZNEmptyDataSetDelegate

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}


- (UISearchBar *)QukanSeachMain_searchBar {
    if (!_QukanSeachMain_searchBar) {
        _QukanSeachMain_searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0,0, 0)];
        _QukanSeachMain_searchBar.searchBarStyle = UISearchBarStyleMinimal;
        [_QukanSeachMain_searchBar setImage:[UIImage imageNamed:@"Search_Icon"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        _QukanSeachMain_searchBar.autoresizingMask = NO;
        _QukanSeachMain_searchBar.layer.masksToBounds = YES;
        _QukanSeachMain_searchBar.barTintColor = [UIColor whiteColor];
        
//        UITextField *seachTextField  = [[[_QukanSeachMain_searchBar.subviews firstObject] subviews] lastObject];
//        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"搜索" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
//
//        seachTextField.attributedPlaceholder = attrString;

        _QukanSeachMain_searchBar.delegate = self;
        _QukanSeachMain_searchBar.backgroundColor = kCommonWhiteColor;
        _QukanSeachMain_searchBar.placeholder = @"搜索";
        _QukanSeachMain_searchBar.barStyle = UISearchBarStyleMinimal;
        _QukanSeachMain_searchBar.returnKeyType = UIReturnKeySearch;
//        _QukanSeachMain_searchBar.searchTextPositionAdjustment = UIOffsetMake(5, 0);x
        
        _QukanSeachMain_searchBar.keyboardType = UIKeyboardTypeDefault;
    
    }
    return _QukanSeachMain_searchBar;
}

@end
