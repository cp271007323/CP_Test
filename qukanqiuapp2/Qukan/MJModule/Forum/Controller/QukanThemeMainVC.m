//
//  QukanThemeMainVC.m
//  Qukan
//
//  Created by leo on 2019/10/5.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanThemeMainVC.h"

// 用到的jx控件
// 用于显示控制器
// 用于控制导航栏透明度
#import <HBDNavigationBar/UIViewController+HBD.h>
// 主模型
#import "QukanBoilingPointTableViewModel_1.h"
// 列表子视图
#import "QukanThemChildListVC.h"
// 顶部头视图
#import "QukanBoilingPointDetailHeaderView.h"

#import "QukanFTMatchDetailDataVC.h"

#define kTableHeaderViewHeight 260
#define kTitleViewHeight 40

@interface QukanThemeMainVC ()<JXPagerViewDelegate, JXCategoryViewDelegate>

// 标题view
@property(nonatomic, strong) JXCategoryTitleView *categoryView;
// 分页view
@property(nonatomic, strong) JXPagerView *listContainerView;
// 子控制器数组
@property(nonatomic, strong) NSArray   * arr_childVC;
// 头视图
@property(nonatomic, strong) QukanBoilingPointDetailHeaderView   * view_header;

// 滑动进度
@property(nonatomic, assign) CGFloat   gradientProgress;

@end

@implementation QukanThemeMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.hbd_barAlpha = 0.01;
    [self hbd_setNeedsUpdateNavigationBar];
    
    self.hbd_barStyle = UIBarStyleDefault;
    self.hbd_tintColor = kCommonWhiteColor;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.hbd_titleTextAttributes = @{ NSForegroundColorAttributeName: [kCommonWhiteColor colorWithAlphaComponent:0.0] };
    
    self.title = self.model_main.title;
    
    [self layoutCategoryView];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark ===================== Layout ====================================
- (void)layoutCategoryView {
    
    QukanThemChildListVC *vc1 = [QukanThemChildListVC new];
    vc1.type_main = 1;
    vc1.id_main = self.model_main.infoId;
    vc1.nav_superVC = self.navigationController;
    QukanThemChildListVC *vc2 = [QukanThemChildListVC new];
    vc2.type_main = 2;
    vc2.id_main = self.model_main.infoId;
    vc2.nav_superVC = self.navigationController;
   QukanFTMatchDetailDataVC *vc_detailData = [QukanFTMatchDetailDataVC new];
    self.arr_childVC = @[vc1,vc2,vc_detailData];
    
    self.categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth, 100)];
    self.categoryView.backgroundColor = UIColor.clearColor;
    self.categoryView.delegate = self;
    self.categoryView.titles = @[@"热门", @"最新",@"333"];
    self.categoryView.titleFont = kFont17;
    self.categoryView.titleSelectedColor = kThemeColor;
    self.categoryView.titleColor = HEXColor(0x666666);
    self.categoryView.titleColorGradientEnabled = YES;
    self.categoryView.contentScrollViewClickTransitionAnimationEnabled = NO;
    
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorColor = kThemeColor;
    lineView.indicatorHeight = 2;
    
    self.categoryView.indicators = @[lineView];
    
    self.listContainerView = [[JXPagerListRefreshView alloc] initWithDelegate:self];
    self.listContainerView.pinSectionHeaderVerticalOffset = kTopBarHeight;
    [self.view addSubview:self.listContainerView];
    
    self.categoryView.listContainer = (id<JXCategoryViewListContainer>)self.listContainerView.listContainerView;
    
    //  下面这个很关键  如果去掉的话  侧滑返回会错乱
    self.navigationController.interactivePopGestureRecognizer.enabled = (self.categoryView.selectedIndex == 0);
    [self.listContainerView.listContainerView.scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
    [self.listContainerView.mainTableView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.listContainerView.frame = self.view.bounds;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


#pragma mark - JXPagingViewDelegate

- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.view_header;
}

- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    return kTableHeaderViewHeight;
}

- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return kTitleViewHeight;
}

- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.categoryView;
}

- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    return 3;
}

- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    return self.arr_childVC[index];
}


#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
}



#pragma mark ===================== lazy ==================================
- (QukanBoilingPointDetailHeaderView *)view_header {
    if (!_view_header) {
        _view_header = [QukanBoilingPointDetailHeaderView Qukan_initWithXib];
        [_view_header setData:self.model_main];
    }
    return _view_header;
}

// 主滑动视图滑动代理  用于处理导航栏颜色改变
- (void)mainTableViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat progress = scrollView.contentOffset.y + scrollView.contentInset.top;
    CGFloat gradientProgress = MIN(1, MAX(0, progress  / 150));
    gradientProgress = gradientProgress * gradientProgress * gradientProgress * gradientProgress;
    if (gradientProgress != self.gradientProgress) {
        self.gradientProgress = gradientProgress;
        if (self.gradientProgress < 0.1) {
            self.hbd_barStyle = UIBarStyleDefault;
            self.hbd_tintColor = kCommonWhiteColor;
            self.hbd_titleTextAttributes = @{ NSForegroundColorAttributeName: [kCommonWhiteColor colorWithAlphaComponent:0] };
        } else {
            self.hbd_barStyle = UIBarStyleDefault;
            self.hbd_tintColor = kCommonWhiteColor;
            self.hbd_titleTextAttributes = @{ NSForegroundColorAttributeName: [kCommonWhiteColor colorWithAlphaComponent:self.gradientProgress] };
        }
        
        self.hbd_barAlpha = self.gradientProgress;
        [self hbd_setNeedsUpdateNavigationBar];
    }
}


@end
