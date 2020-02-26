//
//  QukanBoilingPointHome3Controller.m
//  Qukan
//
//  Created by mac on 2018/11/29.
//  Copyright © 2018 Ningbo Suda. All rights reserved.
//  赛事页面

#import "QukanBoilingPointHome3Controller.h"
// 即时界面
#import "QukanImmediateViewController.h"
// 赛果界面
#import "QukanCompletionViewController.h"
// 赛程界面
#import "QukanRaceCourseViewController.h"
// 筛选界面
#import "QukanScreenViewController.h"
// 热门界面
#import "QukanHotViewController.h"
// 关注界面
#import "QukanFocusOnViewController.h"
// jx组件
// 设置界面
// 请求
#import "QukanApiManager+Competition.h"

@interface QukanBoilingPointHome3Controller ()<JXCategoryViewDelegate, JXCategoryListContainerViewDelegate>

// JX头 jx主体
@property(nonatomic, strong) JXCategoryTitleView *categoryView;
@property(nonatomic, strong) JXCategoryListContainerView *listContainerView;

// 当前下标
@property(nonatomic,assign)NSInteger Qukan_selectedIndex;

@property(nonatomic,strong)QukanHotViewController       *vc0;//热门
@property(nonatomic,strong)QukanImmediateViewController *vc1;//即时
@property(nonatomic,strong)QukanCompletionViewController *vc2;//赛果
@property(nonatomic,strong)QukanRaceCourseViewController *vc3;//赛程
@property(nonatomic,strong)QukanFocusOnViewController    *vc4;//关注

// 子视图控制器数组
@property(nonatomic,strong)NSArray *childArray;

@end

@implementation QukanBoilingPointHome3Controller


#pragma mark ===================== 生命周期 ==================================
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"足球";
    
    [self layoutCategoryView];
    self.Qukan_selectedIndex = 0;
    
//    [self qukan_setNavRightBarItem];
    
    @weakify(self);
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationDidBecomeActiveNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * notification) {
        
        @strongify(self);
        [self reloadSelf];
    }];
}

- (void)reloadSelf {
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

#pragma mark ===================== function ==================================
- (void)layoutCategoryView {
    self.categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    self.categoryView.backgroundColor = [UIColor whiteColor];
    self.categoryView.delegate = self;
    self.categoryView.titles = @[@"热门",@"即时",@"赛果",@"赛程",@"关注"];
    self.categoryView.titleSelectedColor = kThemeColor;
    self.categoryView.titleColor = kCommonBlackColor;
    self.categoryView.titleFont = [UIFont systemFontOfSize:14];
    self.categoryView.titleColorGradientEnabled = YES;
    [self.view addSubview:self.categoryView];
    
    JXCategoryIndicatorTriangleView *lineView = [[JXCategoryIndicatorTriangleView alloc] init];
    lineView.indicatorColor = kThemeColor;
    lineView.verticalMargin = 4;
    lineView.indicatorWidth = 14;
    lineView.indicatorHeight = 5;
    self.categoryView.indicators = @[lineView];
    
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

#pragma mark ===================== 导航栏设置 ==================================
// 设置导航栏右边按钮
- (void)qukan_setNavRightBarItem {
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn addTarget:self action:@selector(Qukan_rightBarButtonItemClick) forControlEvents:UIControlEventTouchUpInside];
    
    [rightBtn setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(0.0, 0.0, 50.0, 44.0);
    [rightBtn setTitle:@"筛选" forState:UIControlStateNormal];
    [rightBtn setImage:kImageNamed(@"nav_Filter") forState:UIControlStateNormal];
    rightBtn.titleLabel.font = kFont13;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.prentVC.navigationItem.rightBarButtonItem = rightItem;
}
//
//// 设置导航栏右边按钮
//- (void)qukan_setNavRightBarItem {
//    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [rightBtn addTarget:self
//                 action:@selector(rightBtnClickEvent:)
//       forControlEvents:UIControlEventTouchUpInside];
//    [rightBtn setTitleColor:HEXColor(0X1A88D9)
//                   forState:UIControlStateNormal];
//    [rightBtn setImage:kImageNamed(@"Qukan_set") forState:UIControlStateNormal];
//    rightBtn.frame = CGRectMake(0.0, 0.0, 50.0, 44.0);
//
//      rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
//    self.navigationItem.rightBarButtonItem = rightItem;
//}
//
//// 右边按钮点击
//-(void)rightBtnClickEvent:(UIButton *)sender{
//    QukanRootSetupViewController *vc = QukanRootSetupViewController.new;
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
//}

// 左边按钮点击
- (void)Qukan_rightBarButtonItemClick {
    QukanScreenViewController *vc = [[QukanScreenViewController alloc] init];
    
    @weakify(self);
    vc.chooseFinishblock = ^(NSString *selectId, NSInteger type) {
        @strongify(self);
        if (type == 1) {
            [self.vc1 resetLegueidsWithLegueids:selectId];
        }
        
        if (type == 2) {
            [self.vc2 resetLegueidsWithLegueids:selectId];
        }
        
        if (type == 3) {
            [self.vc3 resetLegueidsWithLegueids:selectId];
        }
    };
    
    NSInteger selectedIndex = self.Qukan_selectedIndex;
    vc.hidesBottomBarWhenPushed = YES;
    switch (selectedIndex) {
        case 1:{
            vc.title = @"即时列表筛选";
            vc.Qukan_type = 1;
            vc.Qukan_leagueIds = self.vc1.Qukan_leagueIds;
        }break;
        case 3:{
            vc.title = @"赛程列表筛选";
            vc.Qukan_type = 3;
            vc.Qukan_leagueIds = self.vc3.Qukan_leagueIds;
            vc.Qukan_fixDays = self.vc3.Qukan_fixDays;
        }break;
        case 2:{
            vc.title = @"赛果列表筛选";
            vc.Qukan_type = 2;
            vc.Qukan_leagueIds = self.vc2.Qukan_leagueIds;
            vc.Qukan_fixDays = self.vc2.Qukan_fixDays;
        }break;
        default: break;
    }
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
//    [self.navgationVC pushViewController:vc animated:YES];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:NULL];
}


#pragma mark ===================== NetWork ==================================
// 获取到所有的id  对比看是否需要选中
- (void)Qukan_GetHotAllID:(NSString *)Qukan_labelFlag addQukanType:(NSInteger)topic_type addSetDay:(NSInteger)topic_fixDays addQukanScreenViewController:(QukanScreenViewController *)vc {
    @weakify(self);
    [[[kApiManager QukanmatchFindLeagueLabelWithLabelFlag:Qukan_labelFlag andSendType:[NSString stringWithFormat:@"%ld",topic_type] addOffset_day:[NSString stringWithFormat:@"%ld", topic_fixDays] andLeague_ids:@""] takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        DEBUGLog(@"%@",x);
        [self Qukan_GetAndLeague_ids:(NSArray *)x withQukanScreenViewController:vc];
    } error:^(NSError * _Nullable error) {
        @strongify(self);
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

#pragma mark ===================== DataSourceDeal ==================================
- (void)Qukan_GetAndLeague_ids:(NSArray *)response withQukanScreenViewController:(QukanScreenViewController *)vc {
    if (response.count == 0) {
        vc.Qukan_leagueIds = @"";
    }
    NSMutableArray *idSArray = [NSMutableArray array];
    for (int i = 0 ; i < response.count; i ++) {
        NSString *ID = response[i][@"leagueId"];
        [idSArray addObject:ID];
    }
    for (int i = 0 ; i < idSArray.count ; i ++) {
        if (i == 0) {
            vc.Qukan_leagueIds = idSArray[0];
        } else {
            vc.Qukan_leagueIds = [NSString stringWithFormat:@"%@,%@",vc.Qukan_leagueIds,idSArray[i]];
        }
    }
    
    [self.navigationController pushViewController:vc animated:YES];
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
        [self qukan_setNavRightBarItem];
    }
    
    //关注页面做未登录处理
    if (index == 4) {
        kGuardLogin;
    }
}

// 此列表正在展示
- (void)listDidAppear {
    if (self.Qukan_selectedIndex == 0 || self.Qukan_selectedIndex == 4) {
        self.prentVC.navigationItem.rightBarButtonItem = nil;
    }else{
        [self qukan_setNavRightBarItem];
    }
}


#pragma mark ===================== JXCategoryListContainerViewDelegate ==================================

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return 5;
}

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
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


#pragma mark ===================== lazy ==================================
-(QukanHotViewController *)vc0{
    
    if (!_vc0) {
        _vc0 = QukanHotViewController.new;
        _vc0.navController = self.navgationVC;
    }
    
    return _vc0;
}

-(QukanImmediateViewController *)vc1{
    
    if (!_vc1) {
        _vc1 = QukanImmediateViewController.new;
        _vc1.navController = self.navgationVC;
    }
    
    return _vc1;
}

-(QukanCompletionViewController *)vc2{
    
    if (!_vc2) {
        _vc2 = QukanCompletionViewController.new;
        _vc2.navController = self.navgationVC;
    }
    
    return _vc2;
}

-(QukanRaceCourseViewController *)vc3{
    
    if (!_vc3) {
        _vc3 = QukanRaceCourseViewController.new;
        _vc3.navController = self.navgationVC;
    }
    
    return _vc3;
}

-(QukanFocusOnViewController *)vc4{
    
    if (!_vc4) {
        _vc4 = QukanFocusOnViewController.new;
        _vc4.navController = self.navgationVC;
    }
    
    return _vc4;
}



@end
