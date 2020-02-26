
// 赛程界面
#import "QukanRaceCourseViewController.h"
// 足球比赛详情界面
#import "QukanDetailsViewController.h"
// 主模型
#import "QukanMatchInfoModel.h"
// 选择时间的view
#import "QukanDateView.h"
// 刷新按钮
#import "QukanRefreshControl.h"
// 比赛接口
#import "QukanApiManager+Competition.h"
// 列表cell
#import "QukanHotTableViewCell.h"
// 显示空白时的占位图

@interface QukanRaceCourseViewController ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

// 主列表
@property (nonatomic, strong) UITableView *Qukan_myTableView;
// 时间view
@property (nonatomic, strong) QukanDateView *Qukan_dateView;
// 刷新按钮
@property(nonatomic, strong) QukanRefreshControl *refreshBtn;
// 所有时间比赛的数据源
@property(nonatomic, strong) NSMutableDictionary<NSNumber *, NSArray *> *sevenDayDatas;
// 是否正在加载
@property (nonatomic, assign) BOOL Qukan_isLoading;

/**是否需要显示占位图*/
@property(nonatomic, assign) BOOL   bool_shouldShowEmpty;

/**刷新是否需要下拉动画*/
@property(nonatomic, assign) BOOL  bool_refreshShouldAnimation ;

//@property(nonatomic, assign) BOOL clickDate;
@end

@implementation QukanRaceCourseViewController

#pragma mark ===================== lifeCycle ==================================
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.clickDate = NO;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = kCommonWhiteColor;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.Qukan_leagueIds = @"";
    self.bool_refreshShouldAnimation = YES;
    
    // 默认选中的时间为今天 0
    self.Qukan_fixDays = 0;
    
    self.sevenDayDatas = @{}.mutableCopy;
    
    @weakify(self);
    self.Qukan_dateView.Qukan_didSelectItemBlock = ^(NSInteger dateType) {
        @strongify(self)
        if (dateType - 1 == self.Qukan_fixDays) {
            return;
        }
        self.Qukan_fixDays = dateType - 1;
        self.bool_shouldShowEmpty = NO;
//        self.clickDate = YES;
        [self.Qukan_myTableView reloadData];

        // 重置他的筛选的id
        self.Qukan_leagueIds = @"";
        KShowHUD
        [self Qukan_requestData];
//        if (self.Qukan_myTableView.mj_header.isRefreshing) {
//            [self.Qukan_myTableView.mj_header endRefreshing];
//            [self Qukan_requestData];
//        }else {
//            [self.Qukan_myTableView.mj_header beginRefreshing];
//        }
    };
    
    [self initUI];
}

- (void)refreshData {
    if ([self bool_refreshShouldAnimation]) {
        self.bool_refreshShouldAnimation = NO;
        [self.Qukan_myTableView.mj_header beginRefreshing];
    }else {
        [self Qukan_requestData];
    }
}


#pragma mark ===================== initUI ==================================

- (void)initUI {
    [self.view addSubview:self.Qukan_dateView];
    [self.Qukan_dateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@(70));
    }];
    
    [self.view addSubview:self.Qukan_myTableView];
    [self.Qukan_myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.Qukan_dateView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    // 添加刷新按钮
    [self addRefreshButton];
}

- (void)addRefreshButton {
    
    self.refreshBtn = [[QukanRefreshControl alloc] initWithFrame:CGRectMake(kScreenWidth - SCALING_RATIO(70),
    isIPhoneXSeries() ? kScreenHeight - (150 + 69) - SCALING_RATIO(70) : kScreenHeight - (160) - SCALING_RATIO(70), SCALING_RATIO(60),SCALING_RATIO(60)) relevanceScrollView:self.Qukan_myTableView];
    
    @weakify(self)
    self.refreshBtn.beginRefreshBlock = ^{
        @strongify(self)
        if ([self.Qukan_myTableView.mj_header isRefreshing]) {
            return;
        }
        self.bool_refreshShouldAnimation = YES;
        [self refreshData];
    };
    
    [self.view addSubview:self.refreshBtn];
    [self.view bringSubviewToFront:self.refreshBtn];
}


#pragma mark ===================== function ==================================

- (void)Qukan_dateDidSelectRowAtDateType:(NSInteger)dateType {
    // 重置他的筛选的id
    self.Qukan_leagueIds = @"";
    // 把选中的天数变为该天数
    self.Qukan_fixDays = dateType-1;

    [self.Qukan_myTableView.mj_header beginRefreshing];
}


// 重新设置筛选的id
- (void)resetLegueidsWithLegueids:(NSString *)legueids{
    if (legueids.length == 0) {
        self.Qukan_leagueIds = @"这是绝对不可能的id";
        return;
    }
    
    self.bool_refreshShouldAnimation = YES;
    self.Qukan_leagueIds = legueids;
}


#pragma mark ===================== network ==================================

- (void)Qukan_requestData {
    
    // 筛选空列表  则直接显示空数据
    if ([self.Qukan_leagueIds isEqualToString: @"这是绝对不可能的id"]) {
        
        [self.sevenDayDatas removeObjectForKey:@(self.Qukan_fixDays)];
        [self.refreshBtn endAnimation];
        [self.Qukan_myTableView.mj_header endRefreshing];
        [self.Qukan_myTableView reloadData];
        return;
    }
    
    self.Qukan_isLoading = YES;
    
    NSInteger day = self.Qukan_fixDays;
    @weakify(self)
    [[[kApiManager QukanmatchInfosWithType:@"3" andLeague_ids:self.Qukan_leagueIds addOffset_day:[NSString stringWithFormat:@"%ld", self.Qukan_fixDays] andAll:[NSNumber numberWithBool:YES] addIshot:@""] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        KHideHUD
        [self.refreshBtn endAnimation];
        self.bool_shouldShowEmpty = YES;
        [self.Qukan_myTableView.mj_header endRefreshing];
        
        [self dataSourceDealWith:x dateDay:day];
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        KHideHUD
        [self.refreshBtn endAnimation];
        [self.Qukan_myTableView.mj_header endRefreshing];
        self.bool_shouldShowEmpty = YES;
        [self.Qukan_myTableView reloadData];
    }];
}

- (void)dataSourceDealWith:(id)response dateDay:(NSInteger)day {
    NSMutableArray *contentArray = [NSMutableArray array];
    if ([response[@"now_match"] isKindOfClass:[NSArray class]]) {
        NSArray *schedulerMatch = response[@"now_match"];
        for (NSDictionary *d in schedulerMatch) {
            @autoreleasepool {
                QukanMatchInfoContentModel *QukanContentModel = [[QukanMatchInfoContentModel alloc] initQukan_WithDict:d];
                QukanContentModel.contentType = 1;
                [contentArray addObject:QukanContentModel];
            }
        }
    }
    
    if ([response[@"scheduler_match"] isKindOfClass:[NSArray class]]) {
        NSArray *schedulerMatch = response[@"scheduler_match"];
        for (NSDictionary *d in schedulerMatch) {
            @autoreleasepool {
                QukanMatchInfoContentModel *QukanContentModel = [[QukanMatchInfoContentModel alloc] initQukan_WithDict:d];
                QukanContentModel.contentType = 2;
                [contentArray addObject:QukanContentModel];
            }
        }
    }
    
    if (contentArray.count>0) {
        [QukanFailureView Qukan_hideWithView:self.view];
    }
    [self.sevenDayDatas setObject:contentArray forKey:@(day)];
    [self.Qukan_myTableView reloadData];
//    if (self.clickDate) {
//        [self.Qukan_myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
//    }
}

#pragma mark ============== UITableViewDelegate, UITableViewDataSource ========================
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *matchs = self.sevenDayDatas[@(self.Qukan_fixDays)];
    return matchs.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *v = [UIView new]; v.backgroundColor = [UIColor clearColor]; return v;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QukanHotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QukanHotTableViewCell"];
    
    cell.Qukan_controller = self;
    
    NSArray *matchs = self.sevenDayDatas[@(self.Qukan_fixDays)];
    QukanMatchInfoContentModel *model = matchs[indexPath.row];
    
    [cell setDataWithModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self selectAtIndexPath:indexPath];
}

//点击跳转事件
-(void)selectAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *matchs = self.sevenDayDatas[@(self.Qukan_fixDays)];
    QukanMatchInfoContentModel *model = matchs[indexPath.row];
    QukanDetailsViewController *vc = [[QukanDetailsViewController alloc] init];
    vc.Qukan_model = model;
    vc.hidesBottomBarWhenPushed = YES;
//    [self.navController pushViewController:vc animated:YES];
    // 每次进入详情界面时断开连接
    [[QukanIMChatManager sharedInstance] logOutChat:^(NSError * _Nullable error) {
    }];
    [self.navController pushViewController:vc animated:YES];
}

#pragma mark ===================== scorll delegate ==================================
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (scrollView == self.Qukan_myTableView) {
        
        if (!decelerate) {
            BOOL dragToDragStop = scrollView.tracking &&
            !scrollView.dragging &&
            !scrollView.decelerating;
            if (dragToDragStop) {
                // 停止后要执行的代码
                self.refreshBtn.hidden = NO;
                [self.view bringSubviewToFront:self.refreshBtn];
            }
        }
    }
}


#pragma mark ===================== DZNEmptyDataSetSource ==================================
// 占位图提示文本
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *description = @"暂无数据";
    return [[NSAttributedString alloc] initWithString:description attributes:@{NSFontAttributeName : kFont16,NSForegroundColorAttributeName : [UIColor grayColor]}];
}
// 占位图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *imageName = @"nodate_footBall";
    return [UIImage imageNamed:imageName];
}
// 占位图点击效果
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    //    [self Qukan_requestData];
    [self.Qukan_myTableView.mj_header beginRefreshing];
}
// 占位图背景颜色
- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return self.view.backgroundColor;
}

#pragma mark ===================== DZNEmptyDataSetDelegate ==================================
// 占位图是否能滑动
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}
// 占位图是否能点击
- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    return YES;
}
// 占位图是否需要展示
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return self.bool_shouldShowEmpty;
}


#pragma mark ===================== JXCategoryListContentViewDelegate ==================================

- (UIView *)listView {
    return self.view;
}

- (void)listDidAppear {
    [self refreshData];
}

#pragma mark ===================== lazy ==================================

- (QukanDateView *)Qukan_dateView {
    if (!_Qukan_dateView) {
        _Qukan_dateView = [[QukanDateView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth([[UIScreen mainScreen] bounds]), 40.0)];
        [_Qukan_dateView Qukan_setNextSevenDaysData];
    }
    return _Qukan_dateView;
}

- (UITableView *)Qukan_myTableView {
    
    if (!_Qukan_myTableView) {
        _Qukan_myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _Qukan_myTableView.backgroundColor = [UIColor clearColor];
        _Qukan_myTableView.delegate = self;
        _Qukan_myTableView.dataSource = self;
        
        _Qukan_myTableView.emptyDataSetSource = self;
        _Qukan_myTableView.emptyDataSetDelegate = self;
        
        
        _Qukan_myTableView.separatorInset = UIEdgeInsetsMake(0,10, 0, 10);
        
        _Qukan_myTableView.estimatedRowHeight = 75.0;
        _Qukan_myTableView.rowHeight = 120;
        
        _Qukan_myTableView.showsVerticalScrollIndicator = NO;
        _Qukan_myTableView.separatorStyle = 0;
        
        [_Qukan_myTableView registerClass:[QukanHotTableViewCell class]
                   forCellReuseIdentifier:@"QukanHotTableViewCell"];
        
        _Qukan_myTableView.mj_header = [QukanHomeRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(Qukan_requestData)];
        
    }
    return _Qukan_myTableView;
}

@end

