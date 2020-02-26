//
//  QukanBattlefieldReportViewController.m
//  Qukan
//
//  Created by Kody on 2019/12/26.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanBattlefieldReportViewController.h"
#import "QukanBattleReportNewsTableViewCell.h"
#import "QukanBattleReportVideoTableViewCell.h"

#import <ZFPlayer/ZFPlayerController.h>
#import <ZFPlayer/ZFAVPlayerManager.h>
#import "ZFPlayerControlView.h"
#import "QukanShareView.h"
#import "QukanScreenLiveLineView.h"
#import "QukanMatchTabSectionHeaderView.h"
#import "QukanNewsDetailsViewController.h"

@interface QukanBattlefieldReportViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray <QukanNewsModel *> *datas;
@property(nonatomic, strong) NSArray <NSString *> *titles;

@property (nonatomic, strong, readwrite) ZFPlayerController *player;
@property (nonatomic, strong) ZFPlayerControlView *controlView;

// 用于滑动回调
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);

@end

@implementation QukanBattlefieldReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self createPlayer];
    [self loadData];
}

- (void)initUI {
    self.view.backgroundColor = kCommonWhiteColor;
    self.titles = @[@"战报",@"赛后报道"];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark ===================== Player ==================================

- (void)createPlayer {
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];

    /// player的tag值必须在cell里设置
    self.player = [ZFPlayerController playerWithScrollView:self.tableView playerManager:playerManager containerViewTag:10086];
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
//        self.isFullScreen = isFullScreen;
//
//        for (UIView *view  in self.controlView.subviews) {
//            if ([view isKindOfClass:[QukanShareView class]]) {
//                [view removeFromSuperview];
//            }
//        }
        
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
        [self.player stopCurrentPlayingCell];
    };
}

#pragma mark ===================== NetWork ==================================

- (void)loadData {
    
}

#pragma mark ===================== UITableViewDataSource ==================================

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? 230 : 118;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    QukanMatchTabSectionHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"QukanMatchTabSectionHeaderViewID"];
    if(!header){
        header = [[QukanMatchTabSectionHeaderView alloc] initWithReuseIdentifier:@"QukanMatchTabSectionHeaderViewID"];
    }
    [header fullHeaderWithTitle:[self.titles objectAtIndex:section]];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 56;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        QukanBattleReportVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QukanBattleReportVideoTableViewCell class])];
        [cell setDataWithModel:QukanNewsModel.new];
        @weakify(self)
        cell.playBtnCilckBlock = ^(QukanNewsModel * _Nonnull model) {
            @strongify(self)
            [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
        };
        return cell;
    } else {
        QukanBattleReportNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QukanBattleReportNewsTableViewCell class])];
        [cell setDataWithModel:QukanNewsModel.new];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    QukanNewsModel *indexModel = QukanNewsModel.new;
    indexModel.newType = 2;
    indexModel.videoUrl = @"";
    
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
       detailVC.videoNews = indexModel;
       @weakify(self)
       /// 详情页返回的回调
       detailVC.videoVCPopCallback = ^{
           @strongify(self)
           self.controlView.hideBackButton = YES;
       };
       /// 详情页点击播放的回调
       detailVC.videoVCPlayCallback = ^{
       };
       self.controlView.hideBackButton = NO;
       detailVC.hidesBottomBarWhenPushed = YES;
       [self.navigation_vc pushViewController:detailVC animated:YES];
}

#pragma mark ===================== JXCategoryListContainerViewDelegate ==================================
- (UIView *)listView{
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.tableView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback ?: self.scrollCallback(self.tableView);
}

#pragma mark ===================== Public Methods =======================
/// play the video
- (void)playTheVideoAtIndexPath:(NSIndexPath *)indexPath scrollToTop:(BOOL)scrollToTop {
    QukanNewsModel *indexModel = self.datas.count ? [self.datas objectAtIndex:0] : QukanNewsModel.new;
    indexModel.videoUrl = @""; 
    [self.controlView showTitle:indexModel.title
                 coverURLString:indexModel.imageUrl
                 fullScreenMode:ZFFullScreenModeLandscape]; // 不让竖屏全屏播放
    [self.player playTheIndexPath:indexPath assetURL:[NSURL URLWithString:indexModel.videoUrl] scrollToTop:scrollToTop];
    if (indexModel.currentTime > 1) {
        [self.player.currentPlayerManager seekToTime:indexModel.currentTime-1 completionHandler:^(BOOL finished) {
            
        }];
    }
}

- (void)stopVideoPlayIfneed {
//    NSIndexPath *currentPlayIndexPath = self.tableView.zf_playingIndexPath;
//    if (currentPlayIndexPath && self.datas.count > currentPlayIndexPath.row) {
//        QukanNewsModel *model = self.datas[currentPlayIndexPath.row];
//        model.currentTime = self.player.currentTime;
//        [self.player stopCurrentPlayingCell];
//    }
    
     [self.player stopCurrentPlayingCell];
}

#pragma mark ===================== Getter ==================================

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.estimatedRowHeight = 0.0f;
        _tableView.estimatedSectionFooterHeight = 0.0f;
        _tableView.estimatedSectionHeaderHeight = 0.;
        [_tableView registerClass:[QukanBattleReportNewsTableViewCell class] forCellReuseIdentifier:NSStringFromClass([QukanBattleReportNewsTableViewCell class])];
        [_tableView registerClass:[QukanBattleReportVideoTableViewCell class] forCellReuseIdentifier:NSStringFromClass([QukanBattleReportVideoTableViewCell class])];
        
        _tableView.mj_header = [QukanHomeRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
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
//                [self zf_playTheVideoAtIndexPath:self.tableView.zf_playingIndexPath];
            }
        };
        
        _controlView.portraitControlView.backBtnClickCallback = ^{
            @strongify(self)
            [self.navigation_vc popViewControllerAnimated:YES];
        };
        
        _controlView.landScapeControlView.shareBtnClickCallback = ^{
//            @strongify(self)
        };
    }
    return _controlView;
}


@end
