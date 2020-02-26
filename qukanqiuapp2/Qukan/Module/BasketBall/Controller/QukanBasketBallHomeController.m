//
//  QukanBasketBallHomeController.m
//  Qukan
//
//  Created by hello on 2019/9/3.
//  Copyright © 2019 mac. All rights reserved.


#import "QukanBasketBallHomeController.h"

// 筛选界面
#import "QukanBasketScreeningViewController.h"

/**篮球热门界面*/
#import "QukanBasketballPopularVC.h"
/**篮球关注界面*/
#import "QukanGuanZhuViewController.h"
/**篮球即时界面*/
#import "QukanJiShiViewController.h"
/**篮球赛果界面*/
#import "QukanSaiGuoViewController.h"
/**篮球赛程界面*/
#import "QukanSaiChenViewController.h"

@interface QukanBasketBallHomeController ()<JXCategoryViewDelegate, JXCategoryListContainerViewDelegate>

@property(nonatomic, strong) JXCategoryTitleView *categoryView;
@property(nonatomic, strong) JXCategoryListContainerView *listContainerView;

@property(nonatomic,assign)  NSInteger Qukan_selectedIndex;

@property(nonatomic,strong)QukanBasketballPopularVC       *vc0;//热门
@property(nonatomic,strong)QukanJiShiViewController       *vc1;//即时
@property(nonatomic,strong)QukanSaiGuoViewController      *vc2;//赛果
@property(nonatomic,strong)QukanSaiChenViewController     *vc3;//赛程
@property(nonatomic,strong)QukanGuanZhuViewController     *vc4;//关注

@end

@implementation QukanBasketBallHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // 初始化下标
    self.Qukan_selectedIndex = 0;
    // 初始化布局
    [self layoutCategoryView];
    
    @weakify(self);
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationDidBecomeActiveNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * notification) {

        @strongify(self);
        switch (self.Qukan_selectedIndex) {
            case 0:
                [self.vc0 listDidAppear];
                break;
            case 1:
                [self.vc1 listDidAppear];
                break;
            case 2:
                [self.vc2 listDidAppear];
                break;
            case 3:
                [self.vc3 listDidAppear];
                break;
            case 4:
                [self.vc4 listDidAppear];
                break;
            default:
                break;
        }
    }];
}


- (void)refreshListVC {
    switch (self.Qukan_selectedIndex) {
        case 0:
            self.vc0.shouldRelocation = YES;
            [self.vc0 listDidAppear];
            break;
        case 1:
            [self.vc1 listDidAppear];
            break;
        case 2:
            [self.vc2 listDidAppear];
            break;
        case 3:
            [self.vc3 listDidAppear];
            break;
        case 4:
            [self.vc4 listDidAppear];
            break;
        default:
            break;
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
//    self.listContainerView.frame = CGRectMake(0, 44, self.view.width, self.view.height - 44);
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark ===================== function ==================================
- (void)layoutCategoryView {
    
    // titleview
    self.categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    self.categoryView.backgroundColor = [UIColor whiteColor];
    self.categoryView.delegate = self;
    self.categoryView.titles = @[@"热门",@"即时",@"赛果",@"赛程",@"关注"];
    self.categoryView.titleSelectedColor = kThemeColor;
    self.categoryView.titleColor = kCommonBlackColor;
    self.categoryView.titleFont = [UIFont systemFontOfSize:14];
    self.categoryView.titleColorGradientEnabled = YES;
    [self.view addSubview:self.categoryView];
    
    // 底部的线
    JXCategoryIndicatorTriangleView *lineView = [[JXCategoryIndicatorTriangleView alloc] init];
    lineView.indicatorColor = kThemeColor;
    lineView.verticalMargin = 4;
    lineView.indicatorWidth = 14;
    lineView.indicatorHeight = 5;
    self.categoryView.indicators = @[lineView];
    
    // 控制器
    self.categoryView.contentScrollViewClickTransitionAnimationEnabled = NO;
    self.listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
    [self.view addSubview:self.listContainerView];
    //关联到categoryView
    self.categoryView.listContainer = self.listContainerView;
    
    [self.listContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(44);
    }];
}


- (void)Qukan_leftBarButtonItemClickBS {
    QukanBasketScreeningViewController *vc = [[QukanBasketScreeningViewController alloc] init];
    
    NSInteger selectedIndex = self.Qukan_selectedIndex;
    vc.hidesBottomBarWhenPushed = YES;
    
    @weakify(self);
    vc.selectCompletBlock = ^(NSString * _Nonnull ids, NSInteger type, NSInteger chooseType) {
        @strongify(self);
        [self refreshSubVCWithIds:ids andType:type andChooseTupe:chooseType];
    };
    
    switch (selectedIndex) {
        case 1:{
            vc.title = @"即时列表筛选";
            vc.Qukan_leagueIds = self.vc1.Qukan_leagueIds;
            vc.Qukan_type = 1;
        }break;
        case 2:{
            vc.title = @"赛果列表筛选";
            vc.Qukan_type = 3;
            vc.Qukan_leagueIds = self.vc2.Qukan_leagueIds;
            vc.Qukan_fixDays = self.vc2.int_fixDays;
        }break;
        case 3:{
            vc.title = @"赛程列表筛选";
            vc.Qukan_type = 2;
            vc.Qukan_leagueIds = self.vc3.Qukan_leagueIds;
            vc.Qukan_fixDays = self.vc3.int_fixDays;
        }break;
        default: break;
    }
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)refreshSubVCWithIds:(NSString *)ids andType:(NSInteger)type andChooseTupe:(NSInteger)chooseType{
    switch (chooseType) {
        case 0:
            break;
        case 1:
        {
            [self.vc1 resetLegueidsWithLegueids:ids];
            self.vc1.int_xType = type;
        }
            break;
        case 2:
        {
            [self.vc3 resetLegueidsWithLegueids: ids];
            self.vc3.int_xType = type;
        }
            break;
        case 3:
        {
            [self.vc2 resetLegueidsWithLegueids:ids];
            self.vc2.int_xType = type;
            
        }
            
            break;
        case 4:
            
            break;
        default:
            break;
    }
}

#pragma mark ===================== JXCategoryViewDelegate ==================================

//点击选中或者滚动选中都会调用该方法。适用于只关心选中事件，不关心具体是点击还是滚动选中的。
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    self.Qukan_selectedIndex = index;
    self.vc0.shouldRelocation = YES;
    [self selectIndex:index];
}

- (void)selectIndex:(NSInteger)index {
    if (index == 0 || index == 4) {
        self.prentVC.navigationItem.rightBarButtonItem = nil;
    }else{
        [self setRightNavItem];
    }
    
    //关注页面做未登录处理
    if (index == 4) {
        kGuardLogin;
    }
}

- (void)setRightNavItem {
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn addTarget:self action:@selector(Qukan_leftBarButtonItemClickBS) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitleColor:kCommonWhiteColor
                  forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(0.0, 0.0, 50.0, 44.0);
    
    [rightBtn setTitle:@"筛选" forState:UIControlStateNormal];
    [rightBtn setImage:kImageNamed(@"nav_Filter") forState:UIControlStateNormal];
    rightBtn.titleLabel.font = kFont13;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.prentVC.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark ===================== JXCategoryListContainerViewDelegate ==================================

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return 5;
}

-(id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    switch (index) {
        case 0:
            return self.vc0;
            break;
        case 1:
            return self.vc1;
            break;
        case 2:
            return self.vc2;
            break;
        case 3:
            return self.vc3;
            break;
        case 4:
            return self.vc4;
            break;
        default:
            break;
    }
    return nil;
}

#pragma mark ===================== JXCategoryListContentViewDelegate ==================================

- (UIView *)listView {
    return self.view;
    
}

- (void)listDidAppear {
    if (self.Qukan_selectedIndex == 0 || self.Qukan_selectedIndex == 4) {
        self.prentVC.navigationItem.rightBarButtonItem = nil;
    }else{
        [self setRightNavItem];
    }
}

#pragma mark lazyLoad
-(QukanBasketballPopularVC *)vc0{
    
    if (!_vc0) {
        _vc0 = QukanBasketballPopularVC.new;
        _vc0.navController = self.navgationVC;
    }
    
    return _vc0;
}

-(QukanJiShiViewController *)vc1{
    
    if (!_vc1) {
        _vc1 = QukanJiShiViewController.new;
         _vc1.navController = self.navgationVC;
    }
    
    return _vc1;
}

-(QukanSaiGuoViewController *)vc2{
    
    if (!_vc2) {
        _vc2 = QukanSaiGuoViewController.new;
        
         _vc2.navController = self.navgationVC;
    }
    
    return _vc2;
}

-(QukanSaiChenViewController *)vc3{
    
    if (!_vc3) {
        _vc3 = QukanSaiChenViewController.new;
        
         _vc3.navController = self.navgationVC;
    }
    
    return _vc3;
}

-(QukanGuanZhuViewController *)vc4{
    
    if (!_vc4) {
        _vc4 = QukanGuanZhuViewController.new;
         _vc4.navController = self.navgationVC;
    }
    
    return _vc4;
}

@end
