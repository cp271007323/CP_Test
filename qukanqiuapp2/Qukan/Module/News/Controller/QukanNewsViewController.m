//
//  QukanNewsViewController.m
//  Qukan
//
//  Created by Jxc on 2019/7/15.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanNewsViewController.h"
#import <JXCategoryView/JXCategoryListContainerView.h>
#import "QukanNewsListViewController.h"

#import "QukanXLChannelControl.h"
#import "QukanApiManager+News.h"
#import "QukanNewsChannelModel.h"

#import <ZFPlayer/ZFPlayer.h>

@interface QukanNewsViewController ()<JXCategoryViewDelegate, JXCategoryListContainerViewDelegate>

@property(nonatomic, strong) JXCategoryTitleView *categoryView;
@property(nonatomic, strong) JXCategoryListContainerView *listContainerView;
@property(nonatomic, strong) UIView *channelBarView;

@property(nonatomic, copy) NSArray<QukanNewsChannelModel *> *channelItems;
@property(nonatomic, copy) NSArray<QukanNewsChannelModel *> *enableChannelItems;
@property(nonatomic, copy) NSArray<QukanNewsChannelModel *> *disableChannelItems;

@property(nonatomic, assign) NSInteger preSelectedIndex;
@property(nonatomic, strong) NSMutableDictionary<NSString *, id <JXCategoryListContainerViewDelegate>> *channels;

//@property(nonatomic, assign) BOOL filstLaunch; // TODO: 待删除

@end

@implementation QukanNewsViewController

#pragma mark ===================== Life Cycle ==================================

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = @"资讯";
    
    self.view.backgroundColor = kCommentBackgroudColor;
    
    [self loadLoacalChannels];
    [self layoutViews];
    [self loadServerChannels];
    
    [self Qukan_setNavBarButtonItem];
}


- (void)Qukan_setNavBarButtonItem{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn addTarget:self action:@selector(editeClick) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setImage:kImageNamed(@"nav_Filter") forState:UIControlStateNormal];
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    rightBtn.frame = CGRectMake(0.0, 0.0, 50.0, 44.0);
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    //    self.categoryView.frame = CGRectMake(0, 0, self.view.width, 50);
//    self.listContainerView.frame = CGRectMake(0, 46, self.view.width, self.view.height - self.channelBarView.height);
    
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@(45));
    }];
    
    [self.listContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.categoryView.mas_bottom).offset(1);
        make.left.right.bottom.equalTo(self.view);
    }];
    
}

#pragma mark ===================== Public Methods =======================

- (void)stopVideoPlayIfneed {
    QukanNewsChannelModel *model = self.enableChannelItems[self.categoryView.selectedIndex];
    QukanNewsListViewController * vc = (QukanNewsListViewController *)_channels[model.channelName];
    [vc stopCurrentCellPlay];
}

- (void)refreshCurrentNewsList {
    QukanNewsChannelModel *model = self.enableChannelItems[self.categoryView.selectedIndex];
    QukanNewsListViewController * vc = (QukanNewsListViewController *)_channels[model.channelName];
    [vc refreshNewsList];
}

#pragma mark ===================== Private Methods =========================

- (void)loadLoacalChannels {
    //    NSArray *sortChannelItems = [kCacheManager getEnableChannelItems];
    //    self.enableChannelItems = sortChannelItems;
    //    if (self.enableChannelItems.count == 0) {
    //        self.enableChannelItems = [self getSortedChannelItemsFromChannels: [kCacheManager getChannelItems]];
    //    }
    //    self.disableChannelItems = [kCacheManager getDisableChannelItems];
    
    NSMutableDictionary *dic = @{}.mutableCopy;
    [self.enableChannelItems enumerateObjectsUsingBlock:^(QukanNewsChannelModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [dic setObject:QukanNewsListViewController.new forKey:obj.channelName];
    }];
    self.channels = dic;
    
    self.channelItems = [kCacheManager QukangetChannelItems];
}

- (void)loadServerChannels {
    @weakify(self)
    [[kApiManager QukanacquireNewsChannels] subscribeNext:^(NSArray *  _Nullable x) {
        @strongify(self)
        if (!x.count) {
            return;
        }
        
        [kCacheManager QukancacheChanelItems:x];
        
        if (self.channelItems.count != x.count || self.enableChannelItems == nil) {
            NSArray *channels = [self getEnableChannelsOrDisableChannels:YES];
            self.enableChannelItems = [self getSortedChannelItemsFromChannels: channels];
            [kCacheManager QukancacheEnableChanelItems:self.enableChannelItems];
            
            NSArray *disableChannels = [self getEnableChannelsOrDisableChannels:NO];
            self.disableChannelItems = [self getSortedChannelItemsFromChannels: disableChannels];
            [kCacheManager QukancacheDisableChanelItems:self.disableChannelItems];
            
            NSArray *enables = [self.enableChannelItems.rac_sequence map:^id _Nullable(QukanNewsChannelModel * _Nullable value) {
                return value.channelName;
            }].array;
            
            NSMutableDictionary *dic = @{}.mutableCopy;
            [self.enableChannelItems enumerateObjectsUsingBlock:^(QukanNewsChannelModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [dic setObject:QukanNewsListViewController.new forKey:obj.channelName];
            }];
            self.channels = dic;
            
            self.categoryView.titles = enables;
            [self.categoryView reloadData];
            [self.listContainerView reloadData];
        }
        
        self.channelItems = x;
    } error:^(NSError * _Nullable error) {
        @weakify(self);
        [QukanFailureView Qukan_showWithView:self.view Y:kTopBarHeight top:-kTopBarHeight block:^{
            @strongify(self);
            [QukanFailureView Qukan_hideWithView:self.view];
            [self loadServerChannels];
        }];
    }];
}

- (NSArray *)getSortedChannelItemsFromChannels:(NSArray<QukanNewsChannelModel *> *)channels {
    NSMutableArray *temp = [NSMutableArray array];
    
    NSArray *fixItems = [channels.rac_sequence filter:^BOOL(QukanNewsChannelModel *  _Nullable value) {
        return (value.channelId == -2 || value.channelId == -1);
    }].array;
    
    NSArray *otherItems = [[channels.rac_sequence filter:^BOOL(QukanNewsChannelModel *  _Nullable value) {
        return !(value.channelId == -2 || value.channelId == -1);
    }].array sortedArrayUsingComparator:^NSComparisonResult(QukanNewsChannelModel *  _Nonnull obj1, QukanNewsChannelModel *  _Nonnull obj2) {
        return obj1.sort > obj2.sort;
    }];
    
    if (fixItems.count == 2) {
        QukanNewsChannelModel *model = fixItems.firstObject;
        if (model.channelId == -2) {
            [temp addObjectsFromArray:fixItems];
        }else {
            [temp addObject:fixItems.lastObject];
            [temp addObject:model];
        }
    }else if (fixItems.count == 1) {
        [temp addObjectsFromArray:fixItems];
    }
    
    [temp addObjectsFromArray:otherItems];
    
    return [NSArray arrayWithArray:temp];
}

- (QukanNewsListViewController *)currentViewController {
    if (self.enableChannelItems.count <= 0) { return  nil;};
    
    QukanNewsChannelModel *model = self.enableChannelItems[self.categoryView.selectedIndex];
    QukanNewsListViewController * vc = (QukanNewsListViewController *)_channels[model.channelName];
    
    return vc;
}

#pragma mark ===================== Layout ====================================

- (void)layoutViews {
    [self layoutCategoryView];
    [self.view addSubview:self.channelBarView];
    [self.channelBarView addSubview:self.categoryView];
}

- (void)layoutCategoryView {
    self.categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 46)];
    self.categoryView.delegate = self;
    self.categoryView.backgroundColor = kCommonWhiteColor;
    self.categoryView.titles = [self.enableChannelItems.rac_sequence map:^id _Nullable(QukanNewsChannelModel * _Nullable value) {
        return value.channelName;
    }].array;
    self.categoryView.titleColor = kCommonBlackColor;
    self.categoryView.titleSelectedColor = kThemeColor;
    self.categoryView.titleColorGradientEnabled = YES;
    self.categoryView.titleFont = [UIFont systemFontOfSize:14];
    self.categoryView.titleSelectedFont = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.categoryView];
    
//    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
//    lineView.indicatorColor = [UIColor whiteColor];
//    lineView.indicatorWidth = JXCategoryViewAutomaticDimension;
//    lineView.verticalMargin = 5;
//    self.categoryView.indicators = @[lineView];
    
    self.categoryView.contentScrollViewClickTransitionAnimationEnabled = NO;
    self.listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
    [self.view addSubview:self.listContainerView];
    //关联到categoryView
    self.categoryView.listContainer = self.listContainerView;
    
    self.preSelectedIndex = 0;
}

#pragma mark ===================== Actions ============================

- (void)editeClick {
    NSArray *enables = [self.enableChannelItems.rac_sequence map:^id _Nullable(QukanNewsChannelModel * _Nullable value) {
        return value.channelName;
    }].array;
    
    NSArray *disables = [self.disableChannelItems.rac_sequence map:^id _Nullable(QukanNewsChannelModel * _Nullable value) {
        return value.channelName;
    }].array;
    
    @weakify(self)
    [[QukanXLChannelControl shareControl] showChannelViewWithEnabledTitles:enables disabledTitles:disables finish:^(NSArray *enabledTitles, NSArray *disabledTitles) {
        @strongify(self)
        
        NSMutableArray *temp = [NSMutableArray array];
        [self.channelItems enumerateObjectsUsingBlock:^(QukanNewsChannelModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSInteger index = [enabledTitles indexOfObject:obj.channelName];
            if (index != NSNotFound) {
                obj.sort = index;
                [temp addObject:obj];
            }
        }];
        
        self.enableChannelItems = [self getSortedChannelItemsFromChannels:temp];
        [kCacheManager QukancacheEnableChanelItems:self.enableChannelItems];
        
        if (!disabledTitles.count) {
            self.disableChannelItems = @[];
            [kCacheManager QukancacheDisableChanelItems:nil];
        }else {
            self.disableChannelItems = [self.channelItems.rac_sequence filter:^BOOL(QukanNewsChannelModel *  _Nullable value) {
                return [disabledTitles containsObject:value.channelName];
            }].array;
            [kCacheManager QukancacheDisableChanelItems:self.disableChannelItems];
        }
        // TODO: 添加频道黑屏
        NSMutableArray *vcArray = @[].mutableCopy;
        [self.enableChannelItems enumerateObjectsUsingBlock:^(QukanNewsChannelModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            id vc = self.channels[obj.channelName];
            if (vc) {
                [vcArray addObject:vc];
            }else {
                [vcArray addObject:[QukanNewsListViewController new]];
            }
        }];
        
        [self.enableChannelItems enumerateObjectsUsingBlock:^(QukanNewsChannelModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            id vc = vcArray[idx];
            [self.channels setObject:vc forKey:obj.channelName];
        }];
        
        NSArray *removeControllers = [[[self.channels rac_keySequence] filter:^BOOL(NSString *  _Nullable value) {
            return ![enabledTitles containsObject:value];
        }] array];
        [removeControllers enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.channels removeObjectForKey:obj];
        }];
        
        self.categoryView.titles = enabledTitles;
        
        [self.categoryView reloadData];
//        [self.listContainerView reloadData];
        

    }];
}

#pragma mark ===================== JXCategoryViewDelegate ==================================

//点击选中或者滚动选中都会调用该方法。适用于只关心选中事件，不关心具体是点击还是滚动选中的。
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    if (self.preSelectedIndex < 0 || self.preSelectedIndex >= self.enableChannelItems.count) {
        return;
    }
    
    QukanNewsChannelModel *model = self.enableChannelItems[self.preSelectedIndex];
    QukanNewsListViewController * vc = (QukanNewsListViewController *)_channels[model.channelName];
    [vc stopCurrentCellPlay];
    
    self.preSelectedIndex = index;
}

//点击选中的情况才会调用该方法
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    
}

//滚动选中的情况才会调用该方法
- (void)categoryView:(JXCategoryBaseView *)categoryView didScrollSelectedItemAtIndex:(NSInteger)index {
    
}

- (void)categoryView:(JXCategoryBaseView *)categoryView scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio {
    
}

#pragma mark ===================== JXCategoryListContainerViewDelegate ==================================

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.enableChannelItems.count;
}

- (id<JXCategoryListContainerViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    QukanNewsChannelModel *model = self.enableChannelItems[index];
    QukanNewsListViewController * vc = (QukanNewsListViewController *)_channels[model.channelName];
    vc.navController = self.navigationController;
    vc.channel = self.enableChannelItems[index];
    return vc;
}

#pragma mark ===================== 旋转 ==================================

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    QukanNewsListViewController *vc = [self currentViewController];
    if (vc.player.isFullScreen && vc.player.orientationObserver.fullScreenMode == ZFFullScreenModeLandscape) {
        return UIInterfaceOrientationMaskLandscape;
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    /// 如果只是支持iOS9+ 那直接return NO即可，这里为了适配iOS8
    return [self currentViewController].player.shouldAutorotate;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if ([self currentViewController].player.isFullScreen) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return [self currentViewController].player.isStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

#pragma mark ===================== Getters =================================

//- (UIView *)channelBarView {
//    if (!_channelBarView) {
//        _channelBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50+kStatusBarHeight)];
//        CALayer *layer = [UIManager createGradientLayerForForSize:_channelBarView.size];
//        [_channelBarView.layer addSublayer:layer];
//
//        UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth-42, kStatusBarHeight+25-8, 1, 16)];
//        sep.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6];
//        [_channelBarView addSubview:sep];
//
//        UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        menuBtn.frame = CGRectMake(kScreenWidth-44-4, 3+kStatusBarHeight, 44, 44);
//        [menuBtn setImage:[kImageNamed(@"Qukan_news_swich") imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
//        [_channelBarView addSubview:menuBtn];
//        @weakify(self)
//        [[menuBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
//            @strongify(self)
//            [self editeClick];
//        }];
//    }
//    return _channelBarView;
//}

- (NSArray<QukanNewsChannelModel *> *)enableChannelItems {
    BOOL first = [kUserDefaults boolForKey:@"firstloadAble"];
    if (!_enableChannelItems || _enableChannelItems.count == 0) {
        NSArray *sortChannelItems = [kCacheManager QukangetEnableChannelItems];
        _enableChannelItems = sortChannelItems;
        if (_enableChannelItems.count == 0 && !first) {
            [kUserDefaults setBool:YES forKey:@"firstloadAble"];
            //            NSArray *fixDisables = @[@12, @28, @61, @2];
            //            NSArray *channels = [[kCacheManager getChannelItems].rac_sequence filter:^BOOL(QukanNewsChannelModel *  _Nullable value) {
            //                return ![fixDisables containsObject:@(value.channelId)];
            //            }].array;
            NSArray *channels = [self getEnableChannelsOrDisableChannels:YES];
            _enableChannelItems = [self getSortedChannelItemsFromChannels: channels];
            [kCacheManager QukancacheEnableChanelItems:self.enableChannelItems];
        }
    }
    
    return _enableChannelItems;
}

- (NSArray<QukanNewsChannelModel *> *)disableChannelItems {
    BOOL first = [kUserDefaults boolForKey:@"firstloadDisable"];
    if (!_disableChannelItems) {
        NSArray *sortChannelItems = [kCacheManager QukangetDisableChannelItems];
        _disableChannelItems = sortChannelItems;
        if (_disableChannelItems.count == 0 && !first) {
            [kUserDefaults setBool:YES forKey:@"firstloadDisable"];
            //            NSArray *fixDisables = @[@12, @28, @61, @2];
            //            NSArray *channels = [[kCacheManager getChannelItems].rac_sequence filter:^BOOL(QukanNewsChannelModel *  _Nullable value) {
            //                return [fixDisables containsObject:@(value.channelId)];
            //            }].array;
            NSArray *channels = [self getEnableChannelsOrDisableChannels:NO];
            _disableChannelItems = [self getSortedChannelItemsFromChannels: channels];
            [kCacheManager QukancacheDisableChanelItems:self.disableChannelItems];
        }
    }
    
    return _disableChannelItems;
}

- (NSArray *)getEnableChannelsOrDisableChannels:(BOOL)isEnableChannels {
    NSArray *fixDisables = @[@12, @28, @61, @2];
    NSArray *channels = [[kCacheManager QukangetChannelItems].rac_sequence filter:^BOOL(QukanNewsChannelModel *  _Nullable value) {
        BOOL containDisable = [fixDisables containsObject:@(value.channelId)];
        return isEnableChannels ? !containDisable : containDisable;
    }].array;
    
    return channels;
}

@end
