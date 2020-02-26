//
//  QukanMatchMainController.m
//  Qukan
//
//  Created by leo on 2019/9/3.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanMatchMainController.h"

/**篮球主视图*/
#import "QukanBasketBallHomeController.h"
/**足球主视图*/
#import "QukanBoilingPointHome3Controller.h"

/**赛事设置*/
#import "QukanRootSetupViewController.h"

#import <UIViewController+HBD.h>

@interface QukanMatchMainController ()<JXCategoryViewDelegate, JXCategoryListContainerViewDelegate>

@property(nonatomic, strong) JXCategoryTitleView *categoryView;
@property(nonatomic, strong) JXCategoryListContainerView *listContainerView;


@property(nonatomic, strong) QukanBoilingPointHome3Controller   * vc_football;
@property(nonatomic, strong) QukanBasketBallHomeController   * vc_basketball;

@end

@implementation QukanMatchMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.hbd_barTintColor = kCommonTextColor;
    [self layoutCategoryView];
    [self Qukan_setNavBarButtonItem];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)reloadMainMatchVC {
    if (self.categoryView.selectedIndex == 0) {
        [self.vc_football reloadSelf];
    }
    
    if (self.categoryView.selectedIndex == 1) {
        [self.vc_basketball refreshListVC];
    }
}

- (void)changeMainMatchVc {
    [self.categoryView selectItemAtIndex:self.categoryView.selectedIndex == 0 ? 1 : 0];
    [self categoryViewDidSelectedItemAtIndex:self.categoryView.selectedIndex];
}

#pragma mark ===================== Layout ====================================
- (void)layoutCategoryView {

    
    self.categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0,0,120,30)];
    self.categoryView.backgroundColor = [UIColor clearColor];
    self.categoryView.delegate = self;
    self.categoryView.titles = @[@"足球",@"篮球"];
    self.categoryView.titleSelectedColor = kCommonWhiteColor;
    self.categoryView.titleColor = kCommonWhiteColor;
    self.categoryView.titleFont = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    self.categoryView.titleColorGradientEnabled = YES;
    self.categoryView.titleLabelZoomScrollGradientEnabled = NO;
    self.categoryView.contentScrollViewClickTransitionAnimationEnabled = NO;
    self.categoryView.cellBackgroundUnselectedColor = HEXColor(0x5E5E5E);
    self.categoryView.cellBackgroundSelectedColor = kThemeColor;
    
    self.categoryView.cellSpacing = 0;
    self.categoryView.cellWidth = self.categoryView.width / 2;
    self.categoryView.cellBackgroundColorGradientEnabled = YES;
    self.categoryView.titleColorGradientEnabled = YES;
    self.categoryView.titleLabelZoomScrollGradientEnabled = NO;
    
    self.categoryView.layer.cornerRadius = 6;
    self.categoryView.layer.masksToBounds = YES;
    
    
    self.navigationItem.titleView = self.categoryView;
    
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorColor = kCommonWhiteColor;
    lineView.verticalMargin = 4;
    lineView.indicatorHeight = 2;
    self.categoryView.indicators = @[lineView];
    
    
    self.listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
    [self.view addSubview:self.listContainerView];
    
    //关联到categoryView
    self.categoryView.listContainer = self.listContainerView;
    [self.listContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}



- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return 2;
}


- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            return self.vc_football;
        }
            break;
        case 1:
        {
            return self.vc_basketball;
        }
            break;
        default:
            break;
    }
    
    return  nil;
}


-(void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index{
    [self categoryViewDidSelectedItemAtIndex:index];
}

- (void)categoryViewDidSelectedItemAtIndex:(NSInteger)index {
    if (index == 0) {
       [self Qukan_setNavBarButtonItem];
    }else {
        self.navigationItem.leftBarButtonItem = nil;
    }
}

- (void)Qukan_setNavBarButtonItem{
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn addTarget:self
                 action:@selector(leftBtnClickEvent:)
       forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setTitleColor:HEXColor(0X1A88D9)
                   forState:UIControlStateNormal];
    [leftBtn setImage:kImageNamed(@"Qukan_set") forState:UIControlStateNormal];
    leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    leftBtn.frame = CGRectMake(0.0, 0.0, 50.0, 44.0);

    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
}

-(void)leftBtnClickEvent:(UIButton *)sender{
    QukanRootSetupViewController *vc = QukanRootSetupViewController.new;
    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:NULL];
}


- (QukanBoilingPointHome3Controller *)vc_football {
    if (!_vc_football) {
         _vc_football =[QukanBoilingPointHome3Controller new];
        _vc_football.navgationVC = self.navigationController;
        _vc_football.prentVC = self;
    }
    return _vc_football;
}

- (QukanBasketBallHomeController *)vc_basketball {
    if (!_vc_basketball) {
        _vc_basketball = [QukanBasketBallHomeController new];
        _vc_basketball.navgationVC = self.navigationController;
        _vc_basketball.prentVC = self;
    }
    return _vc_basketball;
}


@end
