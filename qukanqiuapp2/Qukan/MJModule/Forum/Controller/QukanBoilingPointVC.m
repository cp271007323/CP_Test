//
//  QukanBoilingPointVC.m
//  Qukan
//
//  Created by leo on 2019/10/3.
//  Copyright © 2019 mac. All rights reserved.
//  沸点

#import "QukanBoilingPointVC.h"

// jx 控件


// 沸点列表主视图
#import "QukanBoilingPointListVC.h"

#import "QukanPublishViewController.h"


@interface QukanBoilingPointVC ()<JXCategoryViewDelegate, JXCategoryListContainerViewDelegate>

@property(nonatomic, strong) JXCategoryTitleView *categoryView;
@property(nonatomic, strong) JXCategoryListContainerView *listContainerView;


@property(nonatomic, strong) QukanBoilingPointListVC   * vc_boilingPointLeft;
@property(nonatomic, strong) QukanBoilingPointListVC   * vc_BoilingPointRight;

@end

@implementation QukanBoilingPointVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self layoutCategoryView];
    [self Qukan_setNavBarButtonItem];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)vixzewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark ===================== privet modth ==================================
- (void)Qukan_setNavBarButtonItem{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn addTarget:self action:@selector(rightBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitleColor:HEXColor(0X1A88D9) forState:UIControlStateNormal];
    [rightBtn setImage:[kImageNamed(@"Qukan_Recommend") imageWithColor:kCommonWhiteColor] forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(0.0, 0.0, 44.0, 44.0);
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.navigationItem.leftBarButtonItem = nil;
}

-(void)rightBtnClickEvent {
    QukanPublishViewController *vc = [QukanPublishViewController new];
    
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ===================== Layout ====================================
- (void)layoutCategoryView {
    
    self.categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0,0,130,44)];
    self.categoryView.backgroundColor = [UIColor clearColor];
    self.categoryView.delegate = self;
    self.categoryView.titles = @[@"推荐",@"动态"];
    self.categoryView.titleSelectedColor = kCommonWhiteColor;
    self.categoryView.titleColor = COLOR_HEX(0xffffff, 0.6);
    self.categoryView.titleColorGradientEnabled = YES;
    self.categoryView.titleLabelZoomScrollGradientEnabled = NO;
    
    self.navigationItem.titleView = self.categoryView;
    
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorColor = kCommonWhiteColor;
    lineView.verticalMargin = 4;
    lineView.indicatorHeight = 2;
    self.categoryView.indicators = @[lineView];
    
    self.categoryView.contentScrollViewClickTransitionAnimationEnabled = YES;
    self.listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
    self.listContainerView.frame =  CGRectZero;
    [self.view addSubview:self.listContainerView];
    
    //关联cotentScrollView，关联之后才可以互相联动！！！
    self.categoryView.listContainer = self.listContainerView;
    
    [self.listContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return 2;
}

-(id<JXCategoryListContainerViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    switch (index) {
        case 0:{
            return self.vc_boilingPointLeft;
        }
            break;
        case 1:{
            return self.vc_BoilingPointRight;
        }
            break;
        default:
            break;
    }
    
    return  nil;
}

#pragma mark ===================== lazy ==================================

- (QukanBoilingPointListVC *)vc_boilingPointLeft {
    if (!_vc_boilingPointLeft) {
        _vc_boilingPointLeft =[QukanBoilingPointListVC new];
        _vc_boilingPointLeft.type_vcList = boilingPointListTypeRecommended;
        _vc_boilingPointLeft.nav_superVC = self.navigationController;
    }
    return _vc_boilingPointLeft;
}

- (QukanBoilingPointListVC *)vc_BoilingPointRight {
    if (!_vc_BoilingPointRight) {
        _vc_BoilingPointRight = [QukanBoilingPointListVC new];
        _vc_BoilingPointRight.type_vcList = boilingPointListTypeDynamic;
        _vc_BoilingPointRight.nav_superVC = self.navigationController;
    }
    return _vc_BoilingPointRight;
}


@end
