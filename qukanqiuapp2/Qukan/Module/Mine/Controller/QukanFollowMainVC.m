//
//  QukanFollowMainVC.m
//  Qukan
//
//  Created by leo on 2019/9/24.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanFollowMainVC.h"

#import "QukanFollowViewController.h"
#import "QukanBasketFollowVC.h"
#import <UIViewController+HBD.h>

@interface QukanFollowMainVC ()<JXCategoryViewDelegate,JXCategoryListContainerViewDelegate>

@property(nonatomic, strong) JXCategoryTitleView *categoryView;
@property(nonatomic, strong) JXCategoryListContainerView *listContainerView;


@property(nonatomic, strong) QukanFollowViewController   *vc_fllowFootBallVC;
@property(nonatomic, strong) QukanBasketFollowVC   * vc_fllowBasketBallVC;

@end

@implementation QukanFollowMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"关注球赛";
    self.view.backgroundColor = kSecondTableViewBackgroudColor;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.hbd_barShadowHidden = YES;
    [self layoutCategoryView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)layoutCategoryView {
    self.categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 44)];
    self.categoryView.backgroundColor = [UIColor whiteColor];
    self.categoryView.delegate = self;
    self.categoryView.titles = @[@"足球",@"篮球"];
    self.categoryView.titleSelectedColor = kThemeColor;
    self.categoryView.titleColor = kCommonTextColor;
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
        make.top.mas_equalTo(self.categoryView.mas_bottom).offset(0);
        make.right.bottom.left.offset(0);
    }];
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark ===================== JXCategoryViewDelegate, JXCategoryListContainerViewDelegate ==================================

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return 2;
}

-(id<JXCategoryListContainerViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    switch (index) {
        case 0:
            return self.vc_fllowFootBallVC;
            break;
        case 1:
            return self.vc_fllowBasketBallVC;
            break;

        default:
            break;
    }
    
    
    return nil;
}


- (QukanFollowViewController *)vc_fllowFootBallVC {
    if (!_vc_fllowFootBallVC) {
        _vc_fllowFootBallVC = [QukanFollowViewController new];
        
        _vc_fllowFootBallVC.vc_parentNav = self.navigationController;
    }
    return _vc_fllowFootBallVC;
}

- (QukanBasketFollowVC *)vc_fllowBasketBallVC {
    if (!_vc_fllowBasketBallVC) {
        _vc_fllowBasketBallVC = [QukanBasketFollowVC new];
        
        _vc_fllowBasketBallVC.navController = self.navigationController;
    }
    return _vc_fllowBasketBallVC;
}

@end
