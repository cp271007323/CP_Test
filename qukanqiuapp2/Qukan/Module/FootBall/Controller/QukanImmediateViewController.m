
/**足球即时列表*/
#import "QukanImmediateViewController.h"
/**足球详情界面*/
#import "QukanDetailsViewController.h"
/**比赛数据模型*/
#import "QukanMatchInfoModel.h"
/**刷新按钮*/
#import "QukanRefreshControl.h"
/**比赛接口*/
#import "QukanApiManager+Competition.h"
/**列表cell*/
#import "QukanHotTableViewCell.h"
// 监听进球提示
#import "QukanMatchDataRefreshManager.h"
/**显示占位图*/

@interface QukanImmediateViewController ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

/**主列表*/
@property (nonatomic, strong) UITableView *Qukan_myTableView;
/**刷新按钮*/
@property(nonatomic, strong) QukanRefreshControl *refreshBtn;


/**数据源*/
@property (nonatomic, strong) NSMutableArray<QukanMatchInfoContentModel *> *Qukan_dataArray;
/**是否需要显示占位图*/
@property(nonatomic, assign) BOOL   bool_shouldShowEmpty;

/**刷新是否需要下拉动画*/
@property(nonatomic, assign) BOOL  bool_refreshShouldAnimation ;

@end

@implementation QukanImmediateViewController


#pragma mark ===================== lifeCycle ==================================
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.Qukan_leagueIds = @"";
    
    self.bool_refreshShouldAnimation = YES;
    
    self.Qukan_myTableView.mj_header = [QukanHomeRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(Qukan_requestData)];

    [self addRefreshButton];
}

- (void)refreshData {
//    if ([self bool_refreshShouldAnimation]) {
//        self.bool_refreshShouldAnimation = NO;
//        [self.Qukan_myTableView.mj_header beginRefreshing];
//    }else {
        [self Qukan_requestData];
//    }
}

#pragma mark ===================== function ==================================

- (void)addRefreshButton {
    _refreshBtn = [[QukanRefreshControl alloc] initWithFrame:CGRectMake(kScreenWidth - SCALING_RATIO(70),
    isIPhoneXSeries() ? kScreenHeight - (150 + 69) - SCALING_RATIO(70) : kScreenHeight - (160) - SCALING_RATIO(70),SCALING_RATIO(80), SCALING_RATIO(80)) relevanceScrollView:self.Qukan_myTableView];
    
    @weakify(self)
    _refreshBtn.beginRefreshBlock = ^{
        @strongify(self) 
        if ([self.Qukan_myTableView.mj_header isRefreshing]) {
            return;
        }
        [self.Qukan_myTableView.mj_header beginRefreshing];
    };
    
    [self.view addSubview:_refreshBtn];
    [self.view bringSubviewToFront:_refreshBtn];
}


#pragma mark ===================== network ==================================
// 重新设置
- (void)resetLegueidsWithLegueids:(NSString *)legueids{
    if (legueids.length == 0) {
        self.Qukan_leagueIds = @"这是绝对不可能的id";
        return;
    }
    self.bool_refreshShouldAnimation = YES;
    self.Qukan_leagueIds = legueids;
}

- (void)Qukan_requestData {
    // 筛选空列表  则直接显示空数据
    if ([self.Qukan_leagueIds isEqualToString: @"这是绝对不可能的id"]) {
        // 移除监听列表里面的所有监听数据
        [[QukanMatchDataRefreshManager sharedQukanMatchDataRefreshManager] listRemoveAllData:self.Qukan_dataArray andType:1];
        
        [self.Qukan_dataArray removeAllObjects];
        [self.refreshBtn endAnimation];
        [self.Qukan_myTableView.mj_header endRefreshing];
        [self.Qukan_myTableView reloadData];
        return;
    }
    
    @weakify(self)
    if (!self.Qukan_dataArray.count) {
        KShowHUD
    }
    [[[kApiManager QukanmatchInfosWithType:@"1" andLeague_ids:self.Qukan_leagueIds?self.Qukan_leagueIds:@"" addOffset_day:@"" andAll:[NSNumber numberWithBool:YES] addIshot:@""] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        KHideHUD
        self.bool_shouldShowEmpty = YES;
        //处理
        [self dataSourceDealWith:x];
        [self.refreshBtn endAnimation];
        [self.Qukan_myTableView.mj_header endRefreshing];
        
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        KHideHUD
        self.bool_shouldShowEmpty = YES;
        [self.refreshBtn endAnimation];
        [self.Qukan_myTableView.mj_header endRefreshing];
        [self.Qukan_myTableView reloadData];
        
    }];
}


- (void)dataSourceDealWith:(id)response {
    // 移除监听列表里面的所有监听数据
    [[QukanMatchDataRefreshManager sharedQukanMatchDataRefreshManager] listRemoveAllData:self.Qukan_dataArray andType:1];
    [self.Qukan_dataArray removeAllObjects];
    
    if ([response[@"now_match"] isKindOfClass:[NSArray class]]) {
        NSArray *nowMatch = response[@"now_match"];
        for (NSDictionary *d in nowMatch) {
            QukanMatchInfoContentModel *QukanContentModel = [[QukanMatchInfoContentModel alloc] initQukan_WithDict:d];
            [self.Qukan_dataArray addObject:QukanContentModel];
            
            // 加入正在打的比赛   type为1 标识即时
            [[QukanMatchDataRefreshManager sharedQukanMatchDataRefreshManager] addNeedRefreshData:QukanContentModel andType:1];
        }
    }
    
    [self.Qukan_myTableView reloadData];
}

- (void)Qukan_netWorkClickRetry {
    [self.Qukan_myTableView.mj_header beginRefreshing];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.Qukan_dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *v = [UIView new]; v.backgroundColor = [UIColor clearColor]; return v;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QukanHotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QukanHotTableViewCell"];
    @weakify(self)
    [cell actionBlock:^(id data) {
        @strongify(self)
        [self selectAtIndexPath:indexPath];
    }];
    cell.Qukan_controller = self;
   
    QukanMatchInfoContentModel *model = self.Qukan_dataArray[indexPath.row];
    
    [cell setDataWithModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self selectAtIndexPath:indexPath];
}

//点击跳转事件
-(void)selectAtIndexPath:(NSIndexPath *)indexPath{
    QukanMatchInfoContentModel *model = self.Qukan_dataArray[indexPath.row];
    
    QukanDetailsViewController *vc = [[QukanDetailsViewController alloc] init];
    vc.Qukan_model = model;
    vc.hidesBottomBarWhenPushed = YES;
//    [self.navController pushViewController:vc animated:YES];
    // 每次进入详情界面时断开连接
    [[QukanIMChatManager sharedInstance] logOutChat:^(NSError * _Nullable error) {
    }];
    [self.navController pushViewController:vc animated:YES];
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

#pragma mark ===================== scor delegate ==================================
// 滑动视图控制
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

#pragma mark ===================== JXCategoryListContentViewDelegate ==================================
- (UIView *)listView {  // 返回列表
    return self.view;
}

// 每次出现重新刷新数据
- (void)listDidAppear {
    [self refreshData];
}

#pragma mark ===================== lazy ==================================

- (UITableView *)Qukan_myTableView {
    if (!_Qukan_myTableView) {
        _Qukan_myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _Qukan_myTableView.backgroundColor = [UIColor clearColor];
        _Qukan_myTableView.delegate = self;
        _Qukan_myTableView.dataSource = self;
        
        _Qukan_myTableView.emptyDataSetSource = self;
        _Qukan_myTableView.emptyDataSetDelegate = self;
        
        [self.view addSubview:_Qukan_myTableView];
        
        _Qukan_myTableView.separatorInset = UIEdgeInsetsMake(0,10, 0, 10);
        
        _Qukan_myTableView.showsVerticalScrollIndicator = NO;
        _Qukan_myTableView.tableFooterView = [UIView new];
        
        _Qukan_myTableView.estimatedRowHeight = 0.0f;
        _Qukan_myTableView.estimatedSectionFooterHeight = 0.0f;
        _Qukan_myTableView.estimatedSectionHeaderHeight = 0.;
        _Qukan_myTableView.separatorStyle = 0;
        
        _Qukan_myTableView.separatorStyle = 0;
        
        [_Qukan_myTableView registerClass:[QukanHotTableViewCell class] forCellReuseIdentifier:@"QukanHotTableViewCell"];
        
        [_Qukan_myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
    }
    return _Qukan_myTableView;
}

- (NSMutableArray<QukanMatchInfoContentModel *> *)Qukan_dataArray {
    if (!_Qukan_dataArray) {
        _Qukan_dataArray = [[NSMutableArray alloc] init];
    }
    return _Qukan_dataArray;
}


@end
