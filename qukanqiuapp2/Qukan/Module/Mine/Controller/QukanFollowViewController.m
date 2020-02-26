#import "QukanFollowViewController.h"
#import "QukanDetailsViewController.h"

#import "QukanMatchInfoModel.h"

#import "QukanNullDataView.h"
#import "QukanHotTableViewCell.h"

//table 头部视图
#import "QukanMatchTabSectionHeaderView.h"

#import <YYKit/YYKit.h>
#import "QukanHotDateHeaderView.h"
#import <UIScrollView+EmptyDataSet.h>
@interface QukanFollowViewController ()<UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UITableView    *Qukan_myTableView;
@property(nonatomic, strong) NSMutableArray  *datas;
@property(nonatomic, strong) NSArray         *times;

@end
@implementation QukanFollowViewController

#pragma mark ===================== Life Cycle ==================================

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.datas = @[].mutableCopy;
    
    
    [self.view addSubview:self.Qukan_myTableView];
    [self.Qukan_myTableView.mj_header beginRefreshing];
}

#pragma mark ===================== NetWork ==================================

- (void)Qukan_requestData {
    @weakify(self)
    [[[kApiManager QukanAttention_Find_attention] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        KHideHUD
        //处理
        [self.Qukan_myTableView.mj_header endRefreshing];
        [self dataSourceDealWithModel:x];
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        [self.Qukan_myTableView.mj_header endRefreshing];
        //[self showEmptyTip];
    }];
}

- (void)dataSourceDealWithModel:(id)response {
    [self.datas removeAllObjects];
    self.times = [NSArray array];
    NSArray *array = (NSArray *)response;
    if (!array.count) {
//        [self showEmptyTip];
        [self.Qukan_myTableView reloadData];
        return;

    }
    NSMutableArray *tempArray = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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
    }];
    
    NSArray *tempModelArray = [NSArray modelArrayWithClass:[QukanMatchInfoContentModel class] json:tempArray];
    
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
//    self.datas.count == 0 ? [self showEmptyTip] : [QukanNullDataView Qukan_hideWithView:self.view];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.Qukan_myTableView.mj_header endRefreshing];
    });
    [self.Qukan_myTableView reloadData];
}

#pragma mark - DZNEmptyDataSetDelegate,DZNEmptyDataSetSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"nodate_footBall"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无数据";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: kTextGrayColor};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return self.Qukan_myTableView.tableHeaderView.frame.size.height / 2;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sectionArray = self.datas[section];
    return sectionArray.count;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return SCALING_RATIO(25);
//}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *v = [UIView new]; v.backgroundColor = [UIColor clearColor]; return v;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    QukanHotDateHeaderView *v = [[QukanHotDateHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, SCALING_RATIO(25)) withType:@"2"];
//    [v setDataWithTime:self.times[section]];
//    return v;
//}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    QukanHotDateHeaderView *v = QukanHotDateHeaderView.new;
    if (section < self.times.count) {
        [v setDataWithTime:self.times[section]];
    }
    return v;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellStr = @"QukanHotTableViewCell";
    QukanHotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    cell.Qukan_controller = self;
    NSArray *indexSectionArray = self.datas[indexPath.section];
    QukanMatchInfoContentModel *model = indexSectionArray[indexPath.row];
    [cell setDataWithModel:model];
    cell.sign = 1;
    cell.QukanHot_didBlock = ^{
        [self Qukan_requestData];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QukanMatchInfoContentModel *model = self.datas[indexPath.section][indexPath.row];
    QukanDetailsViewController *vc = [[QukanDetailsViewController alloc] init];
    vc.Qukan_model = model;
    vc.hidesBottomBarWhenPushed = YES;
//    [self.vc_parentNav pushViewController:vc animated:YES];
    // 每次进入详情界面时断开连接
    [[QukanIMChatManager sharedInstance] logOutChat:^(NSError * _Nullable error) {
    }];
    [self.vc_parentNav pushViewController:vc animated:YES];
    
}

- (UIView *)listView {
    return self.view;
}

#pragma mark ===================== Getters =================================

- (UITableView *)Qukan_myTableView {
    if (!_Qukan_myTableView) {
        _Qukan_myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _Qukan_myTableView.backgroundColor = [UIColor clearColor];
        _Qukan_myTableView.delegate = self;
        _Qukan_myTableView.dataSource = self;
        _Qukan_myTableView.emptyDataSetDelegate = self;
        _Qukan_myTableView.emptyDataSetSource = self;
        [self.view addSubview:_Qukan_myTableView];
        _Qukan_myTableView.estimatedSectionHeaderHeight = 0;
        _Qukan_myTableView.estimatedSectionFooterHeight = 0;
        _Qukan_myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _Qukan_myTableView.separatorInset = UIEdgeInsetsMake(0,10, 0, 10);
        //        _Qukan_myTableView.estimatedRowHeight = 75.0;
        _Qukan_myTableView.rowHeight = 110;
        _Qukan_myTableView.emptyDataSetSource = self;
        _Qukan_myTableView.emptyDataSetDelegate = self;
        //        _Qukan_myTableView.rowHeight = UITableViewAutomaticDimension;
        _Qukan_myTableView.showsVerticalScrollIndicator = NO;
        //        _Qukan_myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _Qukan_myTableView.tableFooterView = [UIView new];
        _Qukan_myTableView.mj_header = [QukanHomeRefreshHeader headerWithRefreshingTarget:self
                                                                         refreshingAction:@selector(Qukan_requestData)];
        [_Qukan_myTableView registerClass:[QukanHotTableViewCell class]
                   forCellReuseIdentifier:@"QukanHotTableViewCell"];
        
        [_Qukan_myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.bottom.equalTo(self.view);
        }];
    }
    return _Qukan_myTableView;
}


@end
