
/**筛选列表*/
#import "QukanScreenViewController.h"
//#import "QukanFilterMatchViewController.h"
/**提供选中的列表*/
#import "QukanFilterMatchViewController.h"
/**用户操作的view*/
#import "QukanScreenSelectedView.h"
/**提供筛选模型*/
#import "QukanScreenTableModel.h"

/**列表的接口*/
#import "QukanApiManager+Competition.h"

/**jx组件*/

@interface QukanScreenViewController ()<JXCategoryViewDelegate, JXCategoryListContainerViewDelegate>

/**底部的选择view*/
@property(nonatomic,strong) QukanScreenSelectedView *Qukan_selectedView;
/**全部筛选列表*/
@property(nonatomic, strong) QukanFilterMatchViewController *Qukan_allFilterVc;
/**热门筛选列表*/
@property(nonatomic, strong) QukanFilterMatchViewController *Qukan_filterHotVc;
/**北单筛选列表*/
@property(nonatomic, strong) QukanFilterMatchViewController *Qukan_filterBDVc;

/**jx组件*/
@property(nonatomic, strong) JXCategoryTitleView *categoryView;
@property(nonatomic, strong) JXCategoryListContainerView *listContainerView;

@end
@implementation QukanScreenViewController

#pragma mark ===================== 生命周期 ==================================
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = kViewControllerBackgroundColor;

    if (![self.Qukan_leagueIds isEqualToString:@""]) {
        [self initSubControllers];
        [self layoutCategoryView];
        [self addMoreView];
    } else {
        [self Qukan_GetHotAllID:@"1" addQukanType:self.Qukan_type addSetDay:self.Qukan_fixDays];
    }
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:kImageNamed(@"ZFPlayer_closeWatch") style:UIBarButtonItemStylePlain target:self action:@selector(Qukan_leftBarButtonItemClick)];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.listContainerView.frame = CGRectMake(0, 44, self.view.width, self.view.height - 44 - self.Qukan_selectedView.height);
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark ===================== function ==================================
- (void)initSubControllers {
    self.Qukan_allFilterVc = [[QukanFilterMatchViewController alloc] init];
    self.Qukan_allFilterVc.Qukan_type = self.Qukan_type;
    self.Qukan_allFilterVc.Qukan_labelFlag = @"";
    self.Qukan_allFilterVc.Qukan_leagueIds = self.Qukan_leagueIds?:@"";
    self.Qukan_allFilterVc.Qukan_fixDays = self.Qukan_fixDays;
    self.Qukan_allFilterVc.Qukan_all = self.Qukan_all;
    
    self.Qukan_filterHotVc = [[QukanFilterMatchViewController alloc] init];
    self.Qukan_filterHotVc.Qukan_type = self.Qukan_type;
    self.Qukan_filterHotVc.Qukan_labelFlag = @"1";
    self.Qukan_filterHotVc.Qukan_leagueIds = self.Qukan_leagueIds?:@"";
    self.Qukan_filterHotVc.Qukan_fixDays = self.Qukan_fixDays;
    self.Qukan_filterHotVc.Qukan_all = self.Qukan_all;
    
    self.Qukan_filterBDVc = [[QukanFilterMatchViewController alloc] init];
    self.Qukan_filterBDVc.Qukan_type = self.Qukan_type;
    self.Qukan_filterBDVc.Qukan_labelFlag = @"2";
    self.Qukan_filterBDVc.Qukan_leagueIds = self.Qukan_leagueIds?:@"";
    self.Qukan_filterBDVc.Qukan_fixDays = self.Qukan_fixDays;
    self.Qukan_filterBDVc.Qukan_all = self.Qukan_all;
}

- (void)addMoreView {
    [self Qukan_selectedView];
    
    @weakify(self)
    self.Qukan_allFilterVc.Qukan_selectedBlock = ^{
        @strongify(self)
        self.Qukan_selectedView.hidden = NO;
        [self Qukan_showSelectedTotalCount];
    };
    self.Qukan_filterHotVc.Qukan_selectedBlock = ^{
        @strongify(self)
        [self Qukan_showSelectedTotalCount];
    };
    self.Qukan_filterBDVc.Qukan_selectedBlock = ^{
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
    self.categoryView.titles = @[@"全部",@"热门"];
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
}

- (void)Qukan_leftBarButtonItemClick {
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (void)Qukan_showSelectedTotalCount {
    NSInteger type = self.categoryView.selectedIndex;
    NSInteger allCount = self.Qukan_allFilterVc.Qukan_allMatchCount;
    NSInteger hiddenCount = 0;
    switch (type) {
        case 0:{
            hiddenCount = allCount - self.Qukan_allFilterVc.Qukan_selectedMatchCount;
        }break;
        case 1:{
            hiddenCount = allCount - self.Qukan_filterHotVc.Qukan_selectedMatchCount;
        }break;
        case 2:{
            hiddenCount = allCount - self.Qukan_filterBDVc.Qukan_selectedMatchCount;
        }break;
        default: break;
    }
    self.Qukan_selectedView.matchCountLabel.text = [NSString stringWithFormat:@"隐藏了%ld场", hiddenCount];
}
- (void)Qukan_sure {
    NSString *leagueIds = @"";
    NSArray *dataArray = [NSArray array];
    NSInteger currenIndex = self.categoryView.selectedIndex;
    switch (currenIndex) {
        case 0: dataArray = self.Qukan_allFilterVc.matchArray; break;
        case 1: dataArray = self.Qukan_filterHotVc.matchArray; break;
        case 2: dataArray = self.Qukan_filterBDVc.matchArray; break;
        default: break;
    }
    
    for (NSArray *array in dataArray) {
        for (QukanScreenTableModel *model in array) {
            if (model.isSelected) {
                if (leagueIds.length==0) {
                    leagueIds = model.leagueId;
                } else {
                    leagueIds = [NSString stringWithFormat:@"%@,%@", leagueIds, model.leagueId];
                }
            }
        }
    }
    
    if (self.chooseFinishblock) {
        self.chooseFinishblock(leagueIds, self.Qukan_type);
    }
    
//    [self.navigationController popViewControllerAnimated:YES];
    [self Qukan_leftBarButtonItemClick];
}
- (void)Qukan_isAllSelected:(BOOL)isAll {
    NSInteger currenIndex = self.categoryView.selectedIndex;
    switch (currenIndex) {
        case 0:{
            [self.Qukan_allFilterVc Qukan_allAndReverseSelected:isAll];
        }break;
        case 1:{
            [self.Qukan_filterHotVc Qukan_allAndReverseSelected:isAll];
        }break;
        case 2:{
            [self.Qukan_filterBDVc Qukan_allAndReverseSelected:isAll];
        }break;
        default: break;
    }
    [self Qukan_showSelectedTotalCount];
}

- (void)setQukan_all:(BOOL)Qukan_all {
    _Qukan_all = Qukan_all;
}

#pragma mark ===================== NetWork ==================================

- (void)Qukan_GetHotAllID:(NSString *)Qukan_labelFlag addQukanType:(NSInteger)Qukan_type addSetDay:(NSInteger)Qukan_fixDays {
    @weakify(self);
    [[[kApiManager QukanmatchFindLeagueLabelWithLabelFlag:Qukan_labelFlag andSendType:[NSString stringWithFormat:@"%ld",Qukan_type] addOffset_day:[NSString stringWithFormat:@"%ld", Qukan_fixDays] andLeague_ids:@""] takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if ([x isKindOfClass:[NSArray class]]) {
            [self Qukan_GetAndLeague_ids:(NSArray *)x];
        } else {
        }
    } error:^(NSError * _Nullable error) {
        
    }];
}

#pragma mark ===================== DataSourceDeal ==================================

- (void)Qukan_GetAndLeague_ids:(NSArray *)response {
    if (response.count == 0) {
        self.Qukan_leagueIds = @"";
    }
    NSMutableArray *idSArray = [NSMutableArray array];
    for (int i = 0 ; i < response.count; i ++) {
        NSString *ID = response[i][@"leagueId"];
        [idSArray addObject:ID];
    }
    for (int i = 0 ; i < idSArray.count ; i ++) {
        if (i == 0) {
            self.Qukan_leagueIds = idSArray[0];
        } else {
            self.Qukan_leagueIds = [NSString stringWithFormat:@"%@,%@",self.Qukan_leagueIds,idSArray[i]];
        }
    }
    [self initSubControllers];
    [self layoutCategoryView];
    [self addMoreView];
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
        return self.Qukan_allFilterVc;
    }else if (index == 1) {
        return self.Qukan_filterHotVc;
    }else {
        return self.Qukan_filterBDVc;
    }
}


#pragma mark ===================== lazy ==================================
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

@end
