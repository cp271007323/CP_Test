//
//  QukanNewsSearchViewController.m
//  Qukan
//
//  Created by blank on 2020/1/5.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanNewsSearchViewController.h"
#import <UIViewController+HBD.h>
#import "QukanNewsSearchDetailFiledView.h"
#import "QukanNewsSearchDetailHistoryView.h"
#import "QukanNewsSearchDetailHotView.h"
#import "QukanNewsTableViewCell.h"
#import "ZFTableViewCell.h"
#import <ZFPlayer/ZFPlayerController.h>
#import <ZFPlayer/ZFAVPlayerManager.h>
#import "ZFPlayerControlView.h"
#import "QukanShareView.h"
#import "QukanScreenLiveLineView.h"
#import "QukanApiManager+PersonCenter.h"
#import "QukanNewsDetailsViewController.h"
#import "UITableView+YYAdd.h"
#import "QukanApiManager+News.h"

@interface QukanNewsSearchViewController ()<UITableViewDataSource, UITableViewDelegate,ZFTableViewCellDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong)QukanNewsSearchDetailFiledView *fieldView;
@property (nonatomic, strong)QukanNewsSearchDetailHistoryView *historyView;
@property (nonatomic, strong)QukanNewsSearchDetailHotView *hotView;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property(nonatomic, assign) NSInteger page;
@property(nonatomic, assign) BOOL show_emptyView; // 是否在加载列表数据中
@property (nonatomic, strong) NSMutableArray<QukanNewsModel *> *datas;

@property(nonatomic, assign) BOOL      isFullScreen;
@property (nonatomic, strong, readwrite) ZFPlayerController *player;
@property (nonatomic, strong)NSString *keyword;
@property (nonatomic, strong)NSMutableArray *hots;
@property (nonatomic, strong)NSString *placeholder;
@property (nonatomic, strong)NSMutableArray *historyArray;
@end

@implementation QukanNewsSearchViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.hbd_barHidden = 1;
    self.page = 1;
    self.view.backgroundColor = kCommonWhiteColor;
    [self QukanInitMainView];
    [self createTableView];
    [self QukanCreatePlayer];
    [self QukanAddNotification];
    [self QukanLoadHistoryAndHot];

}
- (void)QukanLoadHistoryAndHot {
    NSArray *array = [kCacheManager QukanFetechSearchHistory];
    [self.historyView setData:array];
    [self.historyView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset([self.historyView heightOfHistoryView]);
    }];
    [self.historyView reloadMcollectionData];
    [self.hots removeAllObjects];
    KShowHUD
    @weakify(self)
    [[[kApiManager QukanSearchHot] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        for (NSDictionary *dic in x) {
            [self.hots addObject:[QukanSearchHotModel modelWithDictionary:dic]];
        }
        self.hotView.dataArray = [self.hots mutableCopy];
        [self.hotView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset([self.hotView heightOfHotView]);
        }];
        if (self.hots.count) {
            QukanSearchHotModel *hModel = self.hots.firstObject;
            self.placeholder = hModel.title;
            [self.fieldView setPlaceholder:hModel.title];
        }
        KHideHUD
    } error:^(NSError * _Nullable error) {
        KHideHUD
    }];
}
- (void)QukanAddNotification {
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
- (void)QukanRequestData {
    KShowHUD
    [[[kApiManager QukanSearchWithKeyword:self.keyword.length ? self.keyword : self.placeholder current:self.page] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSArray *  _Nullable array) {
        NSArray *x = [array.rac_sequence filter:^BOOL(QukanNewsModel *  _Nullable value) {
            //            NSNumber *num = [NSNumber numberWithInteger:[value.newsId integerValue]];
            return ![[QukanFilterManager sharedInstance] isFilteredNews:value.nid];
        }].array;
        if (self.page == 1 || self.datas.count == 0) {
            self.datas = [NSMutableArray arrayWithArray:x];
            [self.tableView.mj_header endRefreshing];
        } else {
            [self.datas addObjectsFromArray:x];
        }
        self.page +=1;
        self.tableView.mj_footer.hidden = self.datas.count == 0;
        if (array.count < 10) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else {
            [self.tableView.mj_footer endRefreshing];
        }
        self.show_emptyView = 1;
        [self.tableView reloadData];
        KHideHUD
    } error:^(NSError * _Nullable error) {
        KHideHUD
        self.show_emptyView = 1;
    }];
}
- (void)QukanCacheHistory:(NSString *)keyword {
    self.historyArray = [[kCacheManager QukanFetechSearchHistory] mutableCopy];
    [self.historyArray addObject:keyword];
    NSOrderedSet *orderSet = [NSOrderedSet orderedSetWithArray:self.historyArray];
    NSMutableArray *orderSetedArray = [[orderSet array] mutableCopy];
    if (orderSetedArray.count > 6) {
        [orderSetedArray removeObjectAtIndex:0];
    }
    NSArray *array = [[orderSetedArray reverseObjectEnumerator] allObjects];
    [kCacheManager QukanCacheSearchHistory:array];
}
- (void)QukanInitMainView {

    @weakify(self)
    self.fieldView = [[QukanNewsSearchDetailFiledView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kStatusBarHeight + 44) cancelBlock:^{
        @strongify(self)
        [self.navigationController popViewControllerAnimated:YES];
    } fieldBlock:^(NSString * _Nonnull text) {
        @strongify(self)
        self.keyword = text.length == 0 ? self.placeholder : text;
        self.tableView.hidden = 0;
        self.hotView.hidden = self.historyView.hidden = 1;
        [self.datas removeAllObjects];
        self.page = 1;
        if (![self.keyword isEqualToString:self.placeholder]) {
            [self QukanCacheHistory:self.keyword];
        }
        [self QukanRequestData];
    } clearBlock:^{
        self.keyword = @"";
        self.tableView.hidden = 1;
        self.hotView.hidden = self.historyView.hidden = NO;
    } clickFieldBlock:^{
        self.keyword = @"";
        self.tableView.hidden = 1;
        self.hotView.hidden = self.historyView.hidden = 0;
        
    }];
    self.historyView = [[QukanNewsSearchDetailHistoryView alloc]initWithFrame:CGRectZero itemSelectBlock:^(NSString * _Nonnull selectString) {
        @strongify(self)
        self.keyword = selectString;
        self.tableView.hidden = 0;
        self.hotView.hidden = self.historyView.hidden = 1;
        [self.datas removeAllObjects];
        self.page = 1;
        [self QukanRequestData];
    } deleteBlock:^{
        @strongify(self)
        [kCacheManager QukanClearSearchHistory];
        [self.historyView setData:@[]];
        self.historyView.hidden = 1;
        [self.hotView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.fieldView.mas_bottom).offset(0);
        }];
    }];
    self.hotView = [[QukanNewsSearchDetailHotView alloc]initWithFrame:CGRectZero itemBlock:^(NSString * _Nonnull selectString) {
        if (![selectString isEqualToString:self.placeholder]) {
            [self QukanCacheHistory:selectString];
        }
        self.keyword = selectString;
        self.tableView.hidden = 0;
        self.hotView.hidden = self.historyView.hidden = 1;
        [self.datas removeAllObjects];
        self.page = 1;

        [self QukanRequestData];
    }];
    [self.view addSubview:self.fieldView];
    [self.view addSubview:self.historyView];
    [self.view addSubview:self.hotView];
    [self.historyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.fieldView.mas_bottom).offset(0);
        make.left.right.offset(0);
        make.height.offset(0);
    }];

    [self.hotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.historyView.mas_bottom).offset(0);
        make.left.right.offset(0);
        make.height.offset(47);
    }];
    
}

- (void)QukanCreatePlayer {
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
                QukanNewsModel *model = self.datas[indexPath.row];
                model.currentTime = 0;
        }
    };
}

/// play the video
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
    [self Qukan_userReadAddWithModel:indexModel];
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

- (NSMutableAttributedString *)setupAttributeString:(NSString *)text rangeText:(NSString *)rangeText textColor:(UIColor *)color{
    NSRange hightlightTextRange = [text rangeOfString:rangeText];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:text];
    if (hightlightTextRange.length > 0) {
        [attributeStr addAttribute:NSForegroundColorAttributeName value:color range:hightlightTextRange];
        [attributeStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14.0f] range:hightlightTextRange];
        return attributeStr;
    }else {
        return [rangeText copy];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QukanNewsModel *indexModel = self.datas[indexPath.row];
    if (indexModel.newType == QukanNewsType_video) {
        ZFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZFTableViewCell class])];
        [cell setDelegate:self withIndexPath:indexPath];
        
//        [cell setAttribute:[self setupAttributeString:indexModel.title rangeText:self.keyword textColor:UIColor.redColor]];
       
        [cell setDataWithModel:indexModel];
        [cell setNormalMode];
         [cell highLightKeyword:self.keyword];
        return cell;
    }else if (indexModel.newType == QukanNewsType_web) {
        QukanNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QukanNewsTableViewCell class])];
        [cell setDataWithModel:indexModel];
        [cell highLightKeyword:self.keyword];
        return cell;
    } return UITableViewCell.new;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        QukanNewsModel *indexModel = self.datas[indexPath.row];
        if (indexModel.newType == QukanNewsType_video) {
            return 240;
        } else if (indexModel.newType == QukanNewsType_web) {
            return 118;
        } else {
            return 68;
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
            [self.navigationController pushViewController:vc animated:YES];
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
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }
    
}
- (void)stopCurrentCellPlay {
    NSIndexPath *currentPlayIndexPath = self.tableView.zf_playingIndexPath;
    if (currentPlayIndexPath && self.datas.count > currentPlayIndexPath.row) {
        QukanNewsModel *model = self.datas[currentPlayIndexPath.row];
        model.currentTime = self.player.currentTime;
        [self.player stopCurrentPlayingCell];
        [self Qukan_userReadAddWithModel:model];
    }
}
#pragma mark ===================== ZFTableViewCellDelegate ==================================

- (void)zf_playTheVideoAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
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
            [self.navigationController popViewControllerAnimated:YES];
        };
        
        _controlView.landScapeControlView.shareBtnClickCallback = ^{
            @strongify(self)
            [self Qukan_addShareView];
        };
    }
    return _controlView;
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
    [self QukanRequestData];
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return self.show_emptyView;
}
#pragma mark - DZNEmptyDataSetDelegate

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (void)Qukan_addShareView {
    
    QukanNewsModel *currentModel = [QukanNewsModel new];
    NSIndexPath *currentPlayIndexPath = self.tableView.zf_playingIndexPath;
    if (currentPlayIndexPath) {
        QukanNewsModel *model;
            model = self.datas[currentPlayIndexPath.row];
        model.currentTime = self.player.currentTime;
        currentModel = model;
    }
    
    [kUMShareManager Qukan_showShareViewWithMainModel:currentModel Type:shareScreenTypeLand superView:self.player.controlView];
    
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
    
    @weakify(self)
    self.tableView.mj_header = [QukanHomeRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self)
        self.page = 1;
        [self QukanRequestData];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self)
        [self QukanRequestData];
    }];
    self.tableView.mj_footer.hidden = YES;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.top.mas_equalTo(self.fieldView.mas_bottom).offset(10);
    }];
    self.tableView.hidden = 1;
}
- (NSMutableArray *)hots {
    if (!_hots) {
        _hots = [NSMutableArray new];
    }
    return _hots;
}
- (NSMutableArray *)historyArray {
    if (!_historyArray) {
        _historyArray = [NSMutableArray new];
    }
    return _historyArray;
}
@end
