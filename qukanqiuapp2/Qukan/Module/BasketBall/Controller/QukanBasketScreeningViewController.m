//
//  QukanBasketScreeningViewController.m
//  Qukan
//
//  Created by leo on 2019/9/12.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanBasketScreeningViewController.h"
#import "QukanBasketScreeningTableVC.h"
#import "QukanScreenSelectedView.h"
#import "QukanBasketScreenTableModel.h"


@interface QukanBasketScreeningViewController ()<JXCategoryViewDelegate, JXCategoryListContainerViewDelegate>

@property(nonatomic, strong) QukanScreenSelectedView    *Qukan_selectedView;
@property(nonatomic, strong) QukanBasketScreeningTableVC        *Qukan_scoreQukanVc;
@property(nonatomic, strong) QukanBasketScreeningTableVC        *Qukan_scoreImmediateVc;
@property(nonatomic, strong) QukanBasketScreeningTableVC        *Qukan_courseVc;


@property(nonatomic, strong) JXCategoryTitleView *categoryView;
@property(nonatomic, strong) JXCategoryListContainerView *listContainerView;

@end

@implementation QukanBasketScreeningViewController
- (QukanScreenSelectedView *)Qukan_selectedView {
    if (!_Qukan_selectedView) {
        _Qukan_selectedView = [QukanScreenSelectedView Qukan_initWithXib];
        [self.view addSubview:_Qukan_selectedView];
        _Qukan_selectedView.hidden = YES;
        [_Qukan_selectedView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.height.mas_offset(130.0+(isIPhoneXSeries()?35.0:0.0));
        }];
        [_Qukan_selectedView layoutIfNeeded];
    }
    return _Qukan_selectedView;
}

- (void)initSubControllers {
    self.Qukan_scoreQukanVc = [[QukanBasketScreeningTableVC alloc] init];
    // 设置赛事类型 1-即时， 2-赛程， 3-赛果
    self.Qukan_scoreQukanVc.Qukan_type = self.Qukan_type;
    // 设置标记 0-全部 1-热门 2-
    self.Qukan_scoreQukanVc.Qukan_labelFlag = @"0";
    // 初始化选中的id
    self.Qukan_scoreQukanVc.Qukan_leagueIds = self.Qukan_leagueIds?:@"";
    // 设置选中的日期
    self.Qukan_scoreQukanVc.Qukan_fixDays = self.Qukan_fixDays;
    // 看不懂
    self.Qukan_scoreQukanVc.Qukan_all = self.Qukan_all;
    
    self.Qukan_scoreImmediateVc = [[QukanBasketScreeningTableVC alloc] init];
    self.Qukan_scoreImmediateVc.Qukan_type = self.Qukan_type;
    self.Qukan_scoreImmediateVc.Qukan_labelFlag = @"1";
    self.Qukan_scoreImmediateVc.Qukan_leagueIds = self.Qukan_leagueIds?:@"";
    self.Qukan_scoreImmediateVc.Qukan_fixDays = self.Qukan_fixDays;
    self.Qukan_scoreImmediateVc.Qukan_all = self.Qukan_all;
    
    self.Qukan_courseVc = [[QukanBasketScreeningTableVC alloc] init];
    self.Qukan_courseVc.Qukan_type = self.Qukan_type;
    self.Qukan_courseVc.Qukan_labelFlag = @"2";
    self.Qukan_courseVc.Qukan_leagueIds = self.Qukan_leagueIds?:@"";
    self.Qukan_courseVc.Qukan_fixDays = self.Qukan_fixDays;
    self.Qukan_courseVc.Qukan_all = self.Qukan_all;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.listContainerView.frame = CGRectMake(0, 44, self.view.width, self.view.height - 44 - self.Qukan_selectedView.height);
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = kViewControllerBackgroundColor;
    
    [self initSubControllers];
    [self layoutCategoryView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(Qukan_leftBarButtonItemClick) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"Qukan_Play_Back"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0.0, 0.0, 50.0, 44.0);
    btn.imageEdgeInsets = UIEdgeInsetsMake(0.0, -15.0, 0.0, 15.0);
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    [self Qukan_selectedView];
    
    @weakify(self)
    self.Qukan_scoreQukanVc.Qukan_selectedBlock = ^{
        @strongify(self)
        self.Qukan_selectedView.hidden = NO;
        [self Qukan_showSelectedTotalCount];
    };
    self.Qukan_scoreImmediateVc.Qukan_selectedBlock = ^{
        @strongify(self)
        [self Qukan_showSelectedTotalCount];
    };
    self.Qukan_courseVc.Qukan_selectedBlock = ^{
        @strongify(self)
        [self Qukan_showSelectedTotalCount];
    };
    self.Qukan_selectedView.Qukan_selectedBlick = ^(NSInteger index) {
        @strongify(self)
        if (index==3) {
            [self Qukan_sure];
        } else {
            [self Qukan_isAllSelected:index==1?YES:NO];
        }
    };
}

- (void)layoutCategoryView {
    self.categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    self.categoryView.backgroundColor = [UIColor whiteColor];
    self.categoryView.delegate = self;
    self.categoryView.titles = @[@"全部",@"NBA"];
    self.categoryView.titleSelectedColor = kThemeColor;
    self.categoryView.titleColor = HEXColor(0xA2A2A2);
    self.categoryView.titleColorGradientEnabled = YES;
    [self.view addSubview:self.categoryView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 43, kScreenWidth, 1)];
    line.backgroundColor = RGBSAMECOLOR(245);
    [self.categoryView addSubview:line];
    
    JXCategoryIndicatorTriangleView *lineView = [[JXCategoryIndicatorTriangleView alloc] init];
    lineView.indicatorColor = kThemeColor;
    lineView.verticalMargin = 4;
    lineView.indicatorWidth = 8;
    lineView.indicatorHeight = 5;
    self.categoryView.indicators = @[lineView];
    
    self.categoryView.contentScrollViewClickTransitionAnimationEnabled = NO;
    self.listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
    [self.view addSubview:self.listContainerView];
    //关联到categoryView
    self.categoryView.listContainer = self.listContainerView;
    
    //    self.preSelectedIndex = 0;
}

- (void)Qukan_leftBarButtonItemClick {
    //    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)Qukan_showSelectedTotalCount {
    NSInteger type = self.categoryView.selectedIndex;
    NSInteger allCount = self.Qukan_scoreQukanVc.Qukan_allMatchCount;
    NSInteger hiddenCount = 0;
    switch (type) {
        case 0:{
            hiddenCount = allCount - self.Qukan_scoreQukanVc.Qukan_selectedMatchCount;
        }break;
        case 1:{
            hiddenCount = allCount - self.Qukan_scoreImmediateVc.Qukan_selectedMatchCount;
        }break;
        case 2:{
            hiddenCount = allCount - self.Qukan_courseVc.Qukan_selectedMatchCount;
        }break;
        default: break;
    }
    self.Qukan_selectedView.matchCountLabel.text = [NSString stringWithFormat:@"隐藏了%ld场", hiddenCount];
}
- (void)Qukan_sure {
    NSString *leagueIds = @"";
    NSMutableArray *dataArray = [NSMutableArray array];
    NSInteger currenIndex = self.categoryView.selectedIndex;
    switch (currenIndex) {
        case 0: dataArray = self.Qukan_scoreQukanVc.Qukan_dataArray; break;
        case 1: dataArray = self.Qukan_scoreImmediateVc.Qukan_dataArray; break;
        case 2: dataArray = self.Qukan_courseVc.Qukan_dataArray; break;
        default: break;
    }
    
    for (QukanBasketScreenTableModel *model in dataArray) {
        if (model.selected) {
            if (leagueIds.length==0) {
                leagueIds = [NSString stringWithFormat:@"%zd",model.sclassId];
            } else {
                leagueIds = [NSString stringWithFormat:@"%@,%zd", leagueIds, model.sclassId];
            }
        }
    }

    if (self.selectCompletBlock) {
        self.selectCompletBlock(leagueIds, self.categoryView.selectedIndex + 1, self.Qukan_type);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)Qukan_isAllSelected:(BOOL)isAll {
    NSInteger currenIndex = self.categoryView.selectedIndex;
    switch (currenIndex) {
        case 0:{
            [self.Qukan_scoreQukanVc Qukan_allAndReverseSelected:isAll];
        }break;
        case 1:{
            [self.Qukan_scoreImmediateVc Qukan_allAndReverseSelected:isAll];
        }break;
        case 2:{
            [self.Qukan_courseVc Qukan_allAndReverseSelected:isAll];
        }break;
        default: break;
    }
    [self Qukan_showSelectedTotalCount];
}

- (void)setQukan_all:(BOOL)Qukan_all {
    _Qukan_all = Qukan_all;
}

#pragma mark ===================== JXCategoryViewDelegate ==================================

//点击选中或者滚动选中都会调用该方法。适用于只关心选中事件，不关心具体是点击还是滚动选中的。
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    [self  Qukan_showSelectedTotalCount];
    
}


#pragma mark ===================== JXCategoryListContainerViewDelegate ==================================

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return 2;
}

- (id<JXCategoryListContainerViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    if (index == 0) {
        return self.Qukan_scoreQukanVc;
    }else if (index == 1) {
        return self.Qukan_scoreImmediateVc;
    }else {
        return self.Qukan_courseVc;
    }
}




@end
