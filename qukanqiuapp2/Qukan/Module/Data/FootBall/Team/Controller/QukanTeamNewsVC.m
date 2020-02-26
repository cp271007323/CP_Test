//
//  QukanTeamNewsVC.m
//  Qukan
//
//  Created by Charlie on 2019/12/31.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanTeamNewsVC.h"
#import "QukanBattleReportVideoTableViewCell.h"

#import <ZFPlayer/ZFAVPlayerManager.h>
#import "ZFPlayerControlView.h"
#import <UITableView+YYAdd.h>

#import "QukanShareView.h"
#import "QukanNewsCellLayout.h"

#import "QukanScreenLiveLineView.h"
#import "QukanNewsTableViewCell.h"
#import "ZFTableViewCell.h"

#import "QukanNewsDetailsViewController.h"
#import "QukanApiManager+FTAnalysis.h"
#import "QukanTeamScoreModel.h"

#import "QukanApiManager+Mine.h"

@interface QukanTeamNewsVC ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,ZFTableViewCellDelegate>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray <QukanNewsModel *> *datas;
//@property (nonatomic, strong) NSArray *layouts; // QukanNewsCellLayout & ZFTableViewCellLayout

@property (nonatomic, assign) NSInteger newsPageIndex;

@property (nonatomic, strong, readwrite) ZFPlayerController *player;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property(nonatomic, assign) BOOL isFullScreen;

@property(nonatomic,assign) NSInteger requestStatus; //-1 未请求 0请求报错  1请求成功
@property(nonatomic,copy) NSString* errorMsg; //-1 未请求 0请求报错  1请求成功


@end

@implementation QukanTeamNewsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.requestStatus = -1;
    self.newsPageIndex = 1;

    [self initUI];
     [self createPlayer];
     
     @weakify(self)
     [[[kNotificationCenter rac_addObserverForName:Qukan_needRotatScreen_notificationName object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
               @strongify(self)
               [self.player.currentPlayerManager pause];
               [self.player enterFullScreen:NO animated:YES];
    }];
    
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
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(!self.datas.count){
        [self loadData];
    }
}

- (void)initUI {
    self.view.backgroundColor = kCommonWhiteColor;
//    self.titles = @[@"战报",@"赛后报道"];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark ===================== NetWork ==================================

- (void)loadData {
    KShowHUD
    QukanTeamScoreModel* model = (QukanTeamScoreModel*) self.myModel;
    
    NSDictionary*params = @{@"current":@(_newsPageIndex),@"teamId":model.teamId, @"leagueId":model.leagueId,  @"size":@"20"};
    @weakify(self)
    [[kApiManager QukanFetchTeamNewsWithParams:params] subscribeNext:^(NSDictionary *  _Nullable x){
        @strongify(self)
        NSArray* array = [NSArray modelArrayWithClass:[QukanNewsModel class] json:x[@"records"]];
        NSMutableArray* filterArray = [NSMutableArray new];
        for(QukanNewsModel* model in array){
            if(![[QukanFilterManager sharedInstance] isFilteredNews:model.nid]){
                [filterArray addObject:model];
            }
        }
        
        if (self.newsPageIndex == 1 || self.datas.count == 0) {
            self.datas = filterArray;
            [self.tableView.mj_header endRefreshing];
        }else {
            [self.datas addObjectsFromArray: filterArray];
        }
        self.newsPageIndex += 1;
        
        self.tableView.mj_footer.hidden = self.datas.count == 0;
        if (array.count < 20) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            self.tableView.mj_footer.hidden = YES;
        }else {
            [self.tableView.mj_footer endRefreshing];
        }
        

        
//        self.layouts = [self.datas.rac_sequence map:^id _Nullable(id  _Nullable value) {
//                QukanNewsModel *valueModel = value;
//                if (valueModel.newType == QukanNewsType_web) {
//                    QukanNewsCellLayout *layout = [[QukanNewsCellLayout alloc] initWithNewsModel:valueModel];
//                    return layout;
//                }else {
//                    ZFTableViewCellLayout *layout = [[ZFTableViewCellLayout alloc] initWithData:valueModel];
//                    return layout;
//                }
//
//
//        }].array;
        self.requestStatus = 1;
        [self.tableView reloadData];
        KHideHUD
    } error:^(NSError * _Nullable error) {
        DEBUGLog(@"%@",error);
        @strongify(self)
        KHideHUD
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];

        self.requestStatus = 0;
        self.errorMsg = @"加载失败 请稍后再试";// error.localizedDescription;

        [self.tableView reloadData];

    }];
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

#pragma mark ===================== DZNEmptyDataSetSource ==================================
// 占位图提示文本
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString* showStr = self.requestStatus > 0?@"暂无数据" : self.errorMsg;
    return [[NSAttributedString alloc] initWithString:showStr attributes:@{NSFontAttributeName : kFont16,NSForegroundColorAttributeName : [UIColor grayColor]}];
}
// 占位图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
        NSString *imageName = @"Qukan_Null_Data";
//    NSString *imageName = @"";
    return [UIImage imageNamed:imageName];
}
// 占位图点击效果
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    //    [self Qukan_requestData];
        [self loadData];
//    self.type = self.type;
}
// 占位图背景颜色
- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return self.view.backgroundColor;
}

#pragma mark ===================== DZNEmptyDataSetDelegate ==================================
// 占位图是否能滑动
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}
// 占位图是否能点击
- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    return YES;
}
// 占位图是否需要展示
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return self.requestStatus > -1;
}

#pragma mark ===================== UITableViewDataSource ==================================

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return self.titles.count;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    QukanNewsModel *indexModel = self.datas[indexPath.row];
    if (indexModel.newType == QukanNewsType_video) {
        return 240;
    } else {
        return 118;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QukanNewsModel *indexModel = self.datas[indexPath.row];
    if (indexModel.newType == QukanNewsType_video) {
        ZFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZFTableViewCell class])];
        [cell setDelegate:self withIndexPath:indexPath];
        [cell setDataWithModel:indexModel];
        [cell setNormalMode];
        return cell;
    }else{
        QukanNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QukanNewsTableViewCell class])];
        [cell setDataWithModel:indexModel];
        [cell showComment];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id currentModel = self.datas[indexPath.row];

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
            [self.navigation_vc pushViewController:vc animated:YES];
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
            [self.navigation_vc pushViewController:detailVC animated:YES];
        }
    }
}

- (void)stopCurrentCellPlay {
    NSIndexPath *currentPlayIndexPath = self.tableView.zf_playingIndexPath;
    if (currentPlayIndexPath && self.datas.count > currentPlayIndexPath.row) {
        QukanNewsModel *model = self.datas[currentPlayIndexPath.row];
        model.currentTime = self.player.currentTime;
        [self.player stopCurrentPlayingCell];
    }
}

#pragma mark ===================== 旋转 ==================================

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.player.isFullScreen && self.player.orientationObserver.fullScreenMode == ZFFullScreenModeLandscape) {
        return UIInterfaceOrientationMaskLandscape;
    }
    return UIInterfaceOrientationMaskLandscape;
}

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

#pragma mark ===================== JXCategoryListContainerViewDelegate ==================================
- (UIView *)listView{
    return self.view;
}

#pragma mark ===================== Public Methods =======================

#pragma mark ===================== Getter ==================================

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 0.0f;
        _tableView.estimatedSectionFooterHeight = 0.0f;
        _tableView.estimatedSectionHeaderHeight = 0.;

        [_tableView registerClass:[ZFTableViewCell class] forCellReuseIdentifier:NSStringFromClass([ZFTableViewCell class])];
        [_tableView registerClass:[QukanNewsTableViewCell class] forCellReuseIdentifier:NSStringFromClass([QukanNewsTableViewCell class])];
        
        @weakify(self)
        _tableView.mj_header = [QukanHomeRefreshHeader headerWithRefreshingBlock:^{
            @strongify(self)
                self.newsPageIndex = 1;
                [self loadData];
        }];
        
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            @strongify(self)
                self.newsPageIndex ++;
                [self loadData];
        }];
        _tableView.mj_footer.hidden = YES;
    
    }
    return _tableView;
}

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
            [self.navigation_vc popViewControllerAnimated:YES];
        };
        
        _controlView.landScapeControlView.shareBtnClickCallback = ^{
            @strongify(self)
            QukanNewsModel *currentModel = [QukanNewsModel new];
            NSIndexPath *currentPlayIndexPath = self.tableView.zf_playingIndexPath;
            if (currentPlayIndexPath) {
                QukanNewsModel *model;
                model = self.datas[currentPlayIndexPath.row];
                model.currentTime = self.player.currentTime;
                currentModel = model;
            }
            
            [kUMShareManager Qukan_showShareViewWithMainModel:currentModel Type:shareScreenTypeLand superView:self.player.controlView];
        };
    }
    return _controlView;
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
                QukanNewsModel *model = self.datas[currentPlayIndexPath.row];
                model.currentTime = self.player.currentTime;
                
            }
        }
    };
    
    self.player.zf_playerDidDisappearInScrollView = ^(NSIndexPath * _Nonnull indexPath) {
        @strongify(self)
        if (self.player.currentTime > 1) {
            QukanNewsModel *model = self.datas[indexPath.row];
            model.currentTime = self.player.currentTime;
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
        
    };
    
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        @strongify(self)
        NSIndexPath *indexPath = self.tableView.zf_playingIndexPath;
        if (indexPath && indexPath.row < self.datas.count) {
            QukanNewsModel *model = self.datas[indexPath.row];
            model.currentTime = 0;
        }
        
        [self.player stopCurrentPlayingCell];
        
    };
}

- (void)zf_playTheVideoAtIndexPath:(NSIndexPath *)indexPath {
    [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
}

- (void)playTheVideoAtIndexPath:(NSIndexPath *)indexPath scrollToTop:(BOOL)scrollToTop {
    QukanNewsModel *indexModel;

    indexModel = self.datas[indexPath.row];
    
    if (indexPath == nil) {return ;}//layout.data.title
    [self.controlView showTitle:@""
                 coverURLString:indexModel.imageUrl
                 fullScreenMode:ZFFullScreenModeLandscape]; // 不让竖屏全屏播放
    [self.player playTheIndexPath:indexPath assetURL:[NSURL URLWithString:indexModel.videoUrl] scrollToTop:scrollToTop];
    if (indexModel.currentTime > 1) {
        [self.player.currentPlayerManager seekToTime:indexModel.currentTime-1 completionHandler:^(BOOL finished) {
            
        }];
    }
}

-(NSMutableArray<QukanNewsModel *> *)datas{
    if(!_datas){
        _datas = [NSMutableArray array];
    }
    return _datas;
}




@end
