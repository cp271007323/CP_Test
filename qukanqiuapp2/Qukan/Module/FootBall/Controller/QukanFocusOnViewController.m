
#import "QukanFocusOnViewController.h"

// 比赛详情界面
#import "QukanDetailsViewController.h"
// section的头
#import "QukanHotDateHeaderView.h"
// 主cell
#import "QukanHotTableViewCell.h"
// 时间处理

// 自定义刷新控件
#import "QukanRefreshControl.h"
// 比赛信息主模型
#import "QukanMatchInfoModel.h"

// 数据接口头

// 数据刷新统计
#import "QukanMatchDataRefreshManager.h"

// 显示空白页面

@interface QukanFocusOnViewController ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
// 主列表
@property (nonatomic, strong) UITableView *Qukan_myTableView;
// 刷新按钮
@property(nonatomic, strong) QukanRefreshControl *refreshBtn;
// 所有数据的模型
@property(nonatomic, strong) NSArray <QukanMatchInfoContentModel *>    *allModels;
// 所有数据的模型
@property (nonatomic, strong) NSMutableArray *datas;
// 所有时间的模型
@property (nonatomic, strong) NSArray        *times;

/**是否需要显示占位图*/
@property(nonatomic, assign) BOOL   bool_shouldShowEmpty;
/**刷新是否需要下拉动画*/
@property(nonatomic, assign) BOOL  bool_refreshShouldAnimation ;

@end

@implementation QukanFocusOnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bool_refreshShouldAnimation = YES;
    self.datas = @[].mutableCopy;
    self.Qukan_myTableView.mj_header = [QukanHomeRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(Qukan_requestData)];
    
    [self addRefreshButton];
}


- (void)refreshData {
    if ([self bool_refreshShouldAnimation]) {
        self.bool_refreshShouldAnimation = NO;
        [self.Qukan_myTableView.mj_header beginRefreshing];
    }else {
        [self Qukan_requestData];
    }
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)addRefreshButton {
    _refreshBtn = [[QukanRefreshControl alloc] initWithFrame:CGRectMake(kScreenWidth - SCALING_RATIO(70),
    isIPhoneXSeries() ? kScreenHeight - (150 + 69) - SCALING_RATIO(70) : kScreenHeight - (160) - SCALING_RATIO(70),SCALING_RATIO(80),SCALING_RATIO(80)) relevanceScrollView:self.Qukan_myTableView];
    
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

#pragma mark ===================== NetWork ==================================

- (void)Qukan_requestData {
    @weakify(self)
    //登录判断
    if (!kUserManager.isLogin) {//未登录
        [self.refreshBtn endAnimation];
        
        NSMutableArray *nowArr = [NSMutableArray new];
        for (NSArray *modelarr in self.datas) {
            
            for (QukanMatchInfoContentModel *model1 in modelarr) {
                if (model1.state >= 1 && model1.state <= 4) {
                    [nowArr addObject:model1];
                }
            }
        }
        
        [[QukanMatchDataRefreshManager sharedQukanMatchDataRefreshManager] listRemoveAllData:nowArr andType:1];
        
        self.bool_shouldShowEmpty = YES;
        [self.datas removeAllObjects];
        [self.Qukan_myTableView.mj_header endRefreshing];
        [self.Qukan_myTableView reloadData];
        return;
    }
    
    [[[kApiManager QukanAttention_Find_attention] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        KHideHUD
        //处理
        self.bool_shouldShowEmpty = YES;
        [self dataSourceDealWithModel:x];
        [self.refreshBtn endAnimation];
        [self.Qukan_myTableView.mj_header endRefreshing];
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        [self.refreshBtn endAnimation];
        [self.Qukan_myTableView.mj_header endRefreshing];
        self.bool_shouldShowEmpty = YES;
      [self.Qukan_myTableView reloadData];
    }];
}

- (void)dataSourceDealWithModel:(id)response {
    // 移除数据刷新工具中对应的模型
    NSMutableArray *nowArr = [NSMutableArray new];
    for (NSArray *modelarr in self.datas) {
        for (QukanMatchInfoContentModel *model1 in modelarr) {
            if (model1.state >= 1 && model1.state <= 4) {
                [nowArr addObject:model1];
            }
        }
    }
    [[QukanMatchDataRefreshManager sharedQukanMatchDataRefreshManager] listRemoveAllData:nowArr andType:3];
    [self.datas removeAllObjects];
    
    NSArray *array = (NSArray *)response;
    NSMutableArray *tempArray = [NSMutableArray array];
    
    for (NSDictionary  *obj in array) {
        NSMutableDictionary *indexDict = [NSMutableDictionary dictionaryWithDictionary:obj];
        [indexDict setObject:obj[@"matchId"] forKey:@"match_id"];
        [indexDict setObject:obj[@"bfZqLeague"][@"gb"] forKey:@"league_name"];
        [indexDict setObject:obj[@"matchTime"] forKey:@"match_time"];
        [indexDict setObject:obj[@"passTime"] forKey:@"pass_time"];
        [indexDict setObject:obj[@"bfZqTeamHome"][@"g"] forKey:@"home_name"];
        [indexDict setObject:obj[@"bfZqTeamAway"][@"gs"] forKey:@"away_name"];
        [indexDict setObject:obj[@"homeScore"] forKey:@"home_score"];
        [indexDict setObject:obj[@"awayScore"] forKey:@"away_score"];
        [indexDict setObject:obj[@"bfZqTeamHome"][@"flag"] forKey:@"flag1"];
        [indexDict setObject:obj[@"bfZqTeamAway"][@"flags"] forKey:@"flag2"];
        [indexDict setObject:obj[@"stateDesb"] forKey:@"start_time"];
        [indexDict setObject:obj[@"leagueId"] forKey:@"league_id"];
        [indexDict setObject:obj[@"homeId"] forKey:@"home_id"];
        [indexDict setObject:obj[@"awayId"] forKey:@"away_id"];
        [tempArray addObject:indexDict];
    }
    
    NSArray *tempModelArray = [NSArray modelArrayWithClass:[QukanMatchInfoContentModel class] json:tempArray];
    self.allModels = tempModelArray;
    
    self.times = [tempModelArray.rac_sequence map:^id _Nullable(QukanMatchInfoContentModel *  _Nullable value) {
        NSString *time = value.match_time.length > 10 ? [value.match_time substringToIndex:10] : value.match_time;
        return time;
    }].array.rac_sequence.distinctUntilChanged.array;
    self.times = (NSMutableArray *)[[self.times reverseObjectEnumerator] allObjects];
    
    NSArray *datas = [self.times.rac_sequence map:^id _Nullable(NSString *  _Nullable value) {
       NSArray *filters = [tempModelArray.rac_sequence filter:^BOOL(QukanMatchInfoContentModel *  _Nullable infoModel) {
            NSString *time = infoModel.match_time.length > 10 ? [infoModel.match_time substringToIndex:10] : infoModel.match_time;
           return [value isEqualToString:time];
        }].array;
        return filters;
    }].array;
    
    [self.datas addObjectsFromArray:datas];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.Qukan_myTableView.mj_header endRefreshing];
    });
    
    for (NSArray *modelarr in self.datas) {
        for (QukanMatchInfoContentModel *model1 in modelarr) {
            if (model1.state >= 1 && model1.state <= 4) {
                [[QukanMatchDataRefreshManager sharedQukanMatchDataRefreshManager] addNeedRefreshData:model1 andType:3];
            }
        }
    }
    
    [self.Qukan_myTableView reloadData];
}


#pragma mark ===================== Actions ============================

//点击跳转事件
-(void)selectAtIndexPath:(NSIndexPath *)indexPath{
    QukanMatchInfoContentModel *model = self.datas[indexPath.section][indexPath.row];
    QukanDetailsViewController *vc = [[QukanDetailsViewController alloc] init];
    vc.Qukan_model = model;
    vc.hidesBottomBarWhenPushed = YES;
//    [self.navController pushViewController:vc animated:YES];
    // 每次进入详情界面时断开连接
    [[QukanIMChatManager sharedInstance] logOutChat:^(NSError * _Nullable error) {
    }];
    [self.navController pushViewController:vc animated:YES];
}


#pragma mark ===================== UITableViewDelegate, UITableViewDataSource ==================================

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sectionArray = self.datas[section];
    return sectionArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *v = [UIView new]; v.backgroundColor = [UIColor clearColor]; return v;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {    
    QukanHotDateHeaderView *v = QukanHotDateHeaderView.new;
    [v setDataWithTime:self.times[section]];
    return v;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellStr = @"QukanHotTableViewCell";
    QukanHotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    @weakify(self)
    cell.Qukan_controller = self;
    NSArray *indexSectionArray = self.datas[indexPath.section];
    QukanMatchInfoContentModel *model = indexSectionArray[indexPath.row];
    [cell setDataWithModel:model];
    cell.sign = 1;
    cell.QukanHot_didBlock = ^{
        @strongify(self)
        [self Qukan_requestData];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self selectAtIndexPath:indexPath];
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

#pragma mark ===================== scorlloer delegate ==================================
// 控制刷新按钮的显示隐藏
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
- (UIView *)listView {
    return self.view;
}

- (void)listDidAppear {
    [self refreshData];
}

#pragma mark ===================== Getters =================================

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
        
        _Qukan_myTableView.rowHeight = 120;
        
        _Qukan_myTableView.showsVerticalScrollIndicator = NO;
        _Qukan_myTableView.tableFooterView = [UIView new];
        _Qukan_myTableView.separatorStyle = 0;
        
        [_Qukan_myTableView registerClass:[QukanHotTableViewCell class] forCellReuseIdentifier:@"QukanHotTableViewCell"];
        
        [_Qukan_myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        [self.view bringSubviewToFront:self.refreshBtn];
    }
    return _Qukan_myTableView;
}


@end
