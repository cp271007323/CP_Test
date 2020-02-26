//
//  QukanDataMainViewController.m
//  Qukan
//
//  Created by blank on 2019/12/25.
//  Copyright © 2019 mac. All rights reserved.
//
#import "QukanDataMainViewController.h"
#import <UIViewController+HBD.h>
#import "QukanDataBSKViewController.h"
#import "QukanDataSegmentView.h"
#import "QukanFTAnalysisHomeVC.h"

#import "MMPickerView.h"

@interface QukanDataMainViewController ()<JXCategoryViewDelegate, JXCategoryListContainerViewDelegate>

@property(nonatomic, strong) JXCategoryTitleView *categoryView;
@property(nonatomic, strong) JXCategoryListContainerView *listContainerView;

@property(nonatomic, copy) NSArray *viewControllers;

@end

@implementation QukanDataMainViewController
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIImage *image = [UIManager createThemeGradientImageForSize:CGSizeMake(kScreenWidth, 64)];
    self.hbd_barImage = image;

    QukanDataBSKViewController *bskVC = [QukanDataBSKViewController new];
    QukanFTAnalysisHomeVC *footVC = [QukanFTAnalysisHomeVC new];
    self.viewControllers = @[footVC, bskVC] ;
    [self layoutCategoryView];

}

- (BOOL)shouldAutorotate {
    return NO;
}


#pragma mark ===================== Layout ====================================
- (void)layoutCategoryView {
    self.categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0,0,120,30)];
//    self.categoryView.imageNames = @[@"足球_未点亮",@"篮球_未点亮"];
//    self.categoryView.selectedImageNames = @[@"足球_点亮",@"篮球_点亮"];
    self.categoryView.backgroundColor = [UIColor clearColor];
    self.categoryView.delegate = self;
    self.categoryView.titles = @[@"足球",@"篮球"];
    self.categoryView.titleSelectedColor = kCommonWhiteColor;
    self.categoryView.titleColor = kCommonWhiteColor;
    self.categoryView.titleFont = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    self.categoryView.titleLabelZoomScrollGradientEnabled = NO;
    self.categoryView.contentScrollViewClickTransitionAnimationEnabled = NO;
    self.categoryView.cellBackgroundUnselectedColor = HEXColor(0x5E5E5E);
    self.categoryView.cellBackgroundSelectedColor = kThemeColor;
    self.navigationItem.titleView = self.categoryView;
    
    self.categoryView.cellSpacing = 0;
    self.categoryView.cellWidth = self.categoryView.width / 2;
    self.categoryView.cellBackgroundColorGradientEnabled = YES;
    self.categoryView.titleColorGradientEnabled = YES;
    self.categoryView.titleLabelZoomScrollGradientEnabled = NO;
    
    self.categoryView.layer.cornerRadius = 6;
    self.categoryView.layer.masksToBounds = YES;
    
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
    return self.viewControllers[index];
}


-(void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index{
    [self categoryViewDidSelectedItemAtIndex:index];
}

- (void)categoryViewDidSelectedItemAtIndex:(NSInteger)index {
    
}


@end
