//
//  QukanChatContactsListViewController.m
//  Qukan
//
//  Created by Mac on 2020/2/22.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanChatContactsListViewController.h"
#import "QukanMyGroupViewController.h"
#import "QukanMyFriendsViewController.h"
#import "QukanMyNewFriendsViewController.h"

@interface QukanChatContactsListViewController ()

@property(nonatomic, strong) JXCategoryTitleView *categoryView;
@property(nonatomic, strong) JXCategoryListContainerView *listContainerView;

@property (nonatomic , strong) QukanMyGroupViewController *myGroupVC;
@property (nonatomic , strong) QukanMyFriendsViewController *myFriendsVC;
@property (nonatomic , strong) QukanMyNewFriendsViewController *myNewFriendsVC;

@end

@implementation QukanChatContactsListViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self layoutCategoryView];
}

  

#pragma mark ===================== Layout ====================================
- (void)layoutCategoryView {

    self.categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0,0,300,30)];
    self.categoryView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.2];
//    self.categoryView.delegate = self;
    self.categoryView.titles = @[@"我的好友",@"我的群组",@"新的朋友"];
    self.categoryView.titleSelectedColor = HEXColor(0xE9474F);
    self.categoryView.titleColor = kCommonWhiteColor;
    self.categoryView.titleFont = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    self.categoryView.titleColorGradientEnabled = YES;
    self.categoryView.titleLabelZoomScrollGradientEnabled = NO;
    self.categoryView.contentScrollViewClickTransitionAnimationEnabled = NO;
    self.categoryView.cellBackgroundUnselectedColor = UIColor.clearColor;
    self.categoryView.cellBackgroundSelectedColor = UIColor.clearColor;
    
    self.categoryView.cellSpacing = 0;
    self.categoryView.cellWidth = self.categoryView.width / 3;
    self.categoryView.cellBackgroundColorGradientEnabled = YES;
    self.categoryView.titleColorGradientEnabled = YES;
    self.categoryView.titleLabelZoomScrollGradientEnabled = YES;
    
    self.categoryView.layer.cornerRadius = 15;
    self.categoryView.layer.masksToBounds = YES;
    
    
    self.navigationItem.titleView = self.categoryView;
    
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorColor = UIColor.whiteColor;
    lineView.indicatorHeight = 30;
    lineView.indicatorCornerRadius = 15;
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
    return 3;
}


- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    if (index == 0)
    {
        return self.myFriendsVC;
    }
    else if (index == 1)
    {
        return self.myGroupVC;
    }
    else if (index == 2)
    {
        return self.myNewFriendsVC;
    }
    return  nil;
}


//-(void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index{
//    [self categoryViewDidSelectedItemAtIndex:index];
//}

//- (void)categoryViewDidSelectedItemAtIndex:(NSInteger)index {
//    if (index == 0) {
//       [self Qukan_setNavBarButtonItem];
//    }else {
//        self.navigationItem.leftBarButtonItem = nil;
//    }
//}

//- (void)Qukan_setNavBarButtonItem{
//    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [leftBtn addTarget:self
//                 action:@selector(leftBtnClickEvent:)
//       forControlEvents:UIControlEventTouchUpInside];
//    [leftBtn setTitleColor:HEXColor(0X1A88D9)
//                   forState:UIControlStateNormal];
//    [leftBtn setImage:kImageNamed(@"Qukan_set") forState:UIControlStateNormal];
//    leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    leftBtn.frame = CGRectMake(0.0, 0.0, 50.0, 44.0);
//
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
//    self.navigationItem.leftBarButtonItem = leftItem;
//}


#pragma mark - get
- (QukanMyGroupViewController *)myGroupVC
{
    if (_myGroupVC == nil) {
        _myGroupVC = [QukanMyGroupViewController new];
    }
    return _myGroupVC;
}
- (QukanMyFriendsViewController *)myFriendsVC
{
    if (_myFriendsVC == nil) {
        _myFriendsVC = [QukanMyFriendsViewController new];
    }
    return _myFriendsVC;
}

- (QukanMyNewFriendsViewController *)myNewFriendsVC
{
    if (_myNewFriendsVC == nil) {
        _myNewFriendsVC = [QukanMyNewFriendsViewController new];
    }
    return _myNewFriendsVC;
}
@end
