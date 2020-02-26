#import "QukanHotViewController.h"

// 比赛详情界面
#import "QukanDetailsViewController.h"
// 比赛列表cell
#import "QukanHotTableViewCell.h"
// 广告cell
#import "QukanHotGTableViewCell.h"

// 刷新按钮
#import "QukanRefreshControl.h"
// ad的模型
// 广告跳转的vc
#import "QukanGViewController.h"
// 比赛的接口
// 广告接口
#import "QukanApiManager+info.h"
// 时间

// 展示时间的header
#import "QukanHotDateHeaderView.h"
/**监听数据变化*/
#import "QukanMatchDataRefreshManager.h"
// 主模型
#import "QukanMatchInfoModel.h"
// 无数据显示


@interface QukanHotViewController ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>


@property (nonatomic, strong) UITableView *Qukan_myTableView;

// 刷新按钮
@property(nonatomic, strong) QukanRefreshControl *refreshBtn;
// 广告模型
@property(nonatomic, strong) QukanHomeModels    *model;

// 所有数据数组
@property (nonatomic, strong) NSMutableArray        *datas;
// 所有时间数组
@property (nonatomic, strong) NSArray               *times;
// 完成的比赛
@property (nonatomic, strong) NSArray <QukanMatchInfoContentModel *>               *finished_match;
// 正在打的比赛
@property (nonatomic, strong) NSArray <QukanMatchInfoContentModel *>               *now_match;
// 未开的比赛
@property (nonatomic, strong) NSArray <QukanMatchInfoContentModel *>               *scheduler_match;


// 当前定位到的section  用于插入广告
@property (nonatomic, assign) NSInteger section;
// 当前定位到的index 用于插入广告
@property (nonatomic, assign) NSInteger index;

/**是否需要显示占位图*/
@property(nonatomic, assign) BOOL   bool_shouldShowEmpty;

@end

@implementation QukanHotViewController

#pragma mark ===================== Life Cycle ==================================

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;

    
    // 获取到广告
    [self Qukan_newsPage];
    
    // 设置第一次进入需要定位
    self.shouldRelocation = YES;
    
    // 视图布局
    [self initUI];
    
    // 添加刷新按钮
    [self addRefreshButton];
}

// 初始化布局
- (void)initUI {
    [self.view addSubview:self.Qukan_myTableView];
    [self.Qukan_myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)addRefreshButton {
    _refreshBtn = [[QukanRefreshControl alloc] initWithFrame:CGRectMake(kScreenWidth - SCALING_RATIO(70),
                  isIPhoneXSeries() ? kScreenHeight - (150 + 69) - SCALING_RATIO(70) : kScreenHeight - (160) - SCALING_RATIO(70),SCALING_RATIO(80), SCALING_RATIO(80)) relevanceScrollView:self.Qukan_myTableView];
    
    @weakify(self)
    _refreshBtn.beginRefreshBlock = ^{
        @strongify(self)
        [self Qukan_refreshData];
    };
    
    [self.view addSubview:_refreshBtn];
    [self.view bringSubviewToFront:_refreshBtn];
}

#pragma mark ===================== NetWork ==================================

- (void)Qukan_refreshData {
    self.shouldRelocation = YES;
    [self Qukan_requestData];
}

- (void)Qukan_requestData {
    @weakify(self)
    if (!self.datas.count) {
        KShowHUD
    }
    [[[kApiManager QukanmatchInfosWithType:@"5" andLeague_ids:@"" addOffset_day:@"" andAll:@(1) addIshot:@""] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        KHideHUD
        //处理
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
           [self setDatasWith:x];
        });
        [self.refreshBtn endAnimation];
        [self.Qukan_myTableView.mj_header endRefreshing];
        self.bool_shouldShowEmpty = YES;
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        [self.refreshBtn endAnimation];
        [self.Qukan_myTableView.mj_header endRefreshing];
        self.bool_shouldShowEmpty = YES;
        [self.Qukan_myTableView reloadData];
    }];
}

- (void)Qukan_newsPage {
    @weakify(self)
    [[[kApiManager QukanInfoWithType:16] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self dataSourceWith:x];
    } error:^(NSError * _Nullable error) {
    }];
}

- (void)dataSourceWith:(id)response {
    NSArray *array = (NSArray *)response;
    if (!array.count) {return;}
    for (NSDictionary *dict in array) {
        QukanHomeModels *model = [QukanHomeModels modelWithDictionary:dict];
        self.model = model;
    }
}


- (void)setDatasWith:(id)response {
    [[QukanMatchDataRefreshManager sharedQukanMatchDataRefreshManager] listRemoveAllData:self.now_match andType:0];
    
//    [self.datas removeAllObjects];
    
    NSArray *finished_match = [NSArray modelArrayWithClass:[QukanMatchInfoContentModel class] json:(NSArray *)response[@"finished_match"]];
    NSArray *now_match = [NSArray modelArrayWithClass:[QukanMatchInfoContentModel class] json:(NSArray *)response[@"now_match"]];
    NSArray *scheduler_match = [NSArray modelArrayWithClass:[QukanMatchInfoContentModel class] json:(NSArray *)response[@"scheduler_match"]];
    NSMutableArray *allMatch = [NSMutableArray array];
    [allMatch addObjectsFromArray:finished_match];
    [allMatch addObjectsFromArray:now_match];
    [allMatch addObjectsFromArray:scheduler_match];
    
    
    // 正在打的比赛  加入需要刷新队列
    for (QukanMatchInfoContentModel *model in now_match) {
        if (model.state >= 1 && model.state <= 4) {
             [[QukanMatchDataRefreshManager sharedQukanMatchDataRefreshManager] addNeedRefreshData:model andType:0];
        }
    }
    
    _finished_match = finished_match;
    _now_match = now_match;
    _scheduler_match = scheduler_match;
    
    //获取今天的时间戳
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *nowDate = [NSDate date];
    NSString *todayDateStr = [dateFormatter stringFromDate:nowDate];
    NSString *todayTimeSp = [self getTimeStrWithString:todayDateStr];
    
    self.times = [allMatch.rac_sequence map:^id _Nullable(QukanMatchInfoContentModel *  _Nullable value) {
        NSString *time = value.start_time.length > 10 ? [value.start_time substringToIndex:10] : value.start_time;
        NSString *valueTime = [self getTimeStrWithString:time];
        if ([valueTime integerValue] < [todayTimeSp integerValue]) {
            if (value.state == -1) {
                return nil;
            } else {
                return time;
            }
        } else {
            return time;
        }
    }].array.rac_sequence.distinctUntilChanged.array;
    
    NSArray *datas = [self.times.rac_sequence map:^id _Nullable(NSString *  _Nullable value) {
        NSArray *filters = [allMatch.rac_sequence filter:^BOOL(QukanMatchInfoContentModel *  _Nullable model) {
            NSString *time = model.start_time.length > 10 ? [model.start_time substringToIndex:10] : model.start_time;
            NSString *valueTime = [self getTimeStrWithString:time];
            if ([valueTime integerValue] < [todayTimeSp integerValue]) {
                if (model.state == -1) {
                    return NO;
                } else {
                    return [value isEqualToString:time];
                }
            }
            return [value isEqualToString:time];
        }].array;
        return filters;
    }].array;
    
    NSMutableArray *muDatas = [NSMutableArray arrayWithArray:datas];
    
    self.finished_match = [self.finished_match.rac_sequence filter:^BOOL(QukanMatchInfoContentModel *  _Nullable value) {
        NSString *time = value.start_time.length > 10 ? [value.start_time substringToIndex:10] : value.start_time;
        NSString *valueTime = [self getTimeStrWithString:time];
        if ([valueTime integerValue] < [todayTimeSp integerValue]) {
            if (value.state == -1) {
                return NO;
            } else {
                return YES;
            }
        } else {
            return YES;
        }
    }].array;
    
    //添加ad
    self.model && muDatas ? [self dataSourceAddAd:self.model toArr:muDatas] : nil;
    
    @weakify(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        @strongify(self);
        self.datas = muDatas;
        if ([self.Qukan_myTableView.mj_header isRefreshing]) {
            self.Qukan_myTableView.contentOffset = CGPointZero;
        }
        [self.Qukan_myTableView reloadData];
        
        //偏移量的判断
        if (self.shouldRelocation) {
            self.shouldRelocation = NO;
            //偏移量的判断
            [self DealWithTime];
        }
    });
}


- (void)dataSourceAddAd:(QukanHomeModels *)model toArr:(NSMutableArray *)muDatas{
    if (muDatas.count == 0) { return;}
    QukanMatchInfoContentModel *flagModel;
    if (self.now_match.count < 2) {
        if (self.now_match.count == 0) {
            flagModel = self.scheduler_match.count > 2 ? self.scheduler_match[2] : nil;
        } else if (self.now_match.count == 1) {
            flagModel = self.scheduler_match.count > 1 ? self.scheduler_match[1] : nil;
        }
    } else if (self.now_match.count == 2) {
        flagModel = self.scheduler_match.count > 0 ? self.scheduler_match[0] : nil;
    } else if (self.now_match.count > 2) {
        flagModel = self.now_match[2];
    }
    
    
    __block NSInteger index = 0;
    __block NSInteger section = 0;
    [muDatas enumerateObjectsUsingBlock:^(NSArray *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger row, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[QukanMatchInfoContentModel class]]) {
                QukanMatchInfoContentModel *model = obj;
                if (model.match_id == flagModel.match_id) {
                    section = idx;
                    index = row;
                }
            }
        }];
    }];
    
    NSMutableArray *temp = [NSMutableArray arrayWithArray:muDatas[section]];
    temp.count >= index ? [temp insertObject:model atIndex:index] : nil;
    [muDatas replaceObjectAtIndex:section withObject:temp];
    
    self.section = section;
    self.index = index;
}

#pragma mark ===================== UITableViewDelegate, UITableViewDataSource ==================================

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sectionArray = self.datas.count > section ? self.datas[section] : nil;
    return sectionArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id x = self.datas[indexPath.section][indexPath.row];
    if ([x isKindOfClass:[QukanMatchInfoContentModel class]]) {
        return 120;
    } else if ([x isKindOfClass:[QukanHomeModels class]]) {
        return 68;
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *v = [UIView new]; v.backgroundColor = [UIColor clearColor]; return v;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    QukanHotDateHeaderView *v = QukanHotDateHeaderView.new;
    if (section < self.times.count) {
        [v setDataWithTime:self.times[section]];
    }
    return v;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id x = self.datas[indexPath.section][indexPath.row];
    if ([x isKindOfClass:[QukanMatchInfoContentModel class]]) {
        static NSString *cellStr = @"QukanHotTableViewCell";
        QukanHotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        @weakify(self)
        [cell actionBlock:^(id data) {
            @strongify(self)
            [self selectAtIndexPath:indexPath];
        }];
        cell.Qukan_controller = self;
        NSArray *indexSectionArray = self.datas[indexPath.section];
        QukanMatchInfoContentModel *model = indexSectionArray[indexPath.row];
        [cell setDataWithModel:model];
        if (indexPath.section == self.section && indexPath.row == self.index - 1) {
             cell.separatorInset = UIEdgeInsetsMake(0, kScreenWidth, 0, 0);
        }else {
            cell.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
        }

        return cell;
    } else if ([x isKindOfClass:[QukanHomeModels class]]) {
        QukanHomeModels *model = x;
        static NSString *cellStr = @"QukanHotGTableViewCell";
        QukanHotGTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        [cell Qukan_setDataWith:model];
        cell.separatorInset = UIEdgeInsetsMake(0, kScreenWidth, 0, 0);
        return cell;
    } else {
        return nil;
    }
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
        [self Qukan_requestData];
//    [self.Qukan_myTableView.mj_header beginRefreshing];
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

//点击跳转事件
-(void)selectAtIndexPath:(NSIndexPath *)indexPath{
    id x = self.datas[indexPath.section][indexPath.row];
    if ([x isKindOfClass:[QukanMatchInfoContentModel class]]) {
        NSArray *indexSectionArray = self.datas[indexPath.section];
        QukanMatchInfoContentModel *model = indexSectionArray[indexPath.row];
        QukanDetailsViewController *vc = [[QukanDetailsViewController alloc] init];
        vc.Qukan_model = model;
        vc.hidesBottomBarWhenPushed = YES;
//        [self.navController pushViewController:vc animated:YES];
        // 每次进入详情界面时断开连接
        [[QukanIMChatManager sharedInstance] logOutChat:^(NSError * _Nullable error) {
        }];
        [self.navController pushViewController:vc animated:YES];
    } else {
        if ([self.model.jump_type intValue] == QukanViewJumpType_In) {//内部
            QukanGViewController *vc = [[QukanGViewController alloc] init];
            vc.url = self.model.v_url;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navController pushViewController:vc animated:YES];
        } else if ([self.model.jump_type intValue] == QukanViewJumpType_Out) {//外部
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.model.v_url]];
        } else if ([self.model.jump_type intValue] == QukanViewJumpType_AppIn) {
            
        } else if ([self.model.jump_type intValue] == QukanViewJumpType_Other) {
            QukanGViewController *vc = [[QukanGViewController alloc] init];
            NSString *url = [NSString stringWithFormat:@"%@?adType=%@&bunleId=%@&appKey=%@",self.model.v_url,self.model.type,Qukan_AppBundleId,Qukan_OpeninstallKey];
            vc.url = url;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark ===================== 数据时间处理 ==================================

- (void)DealWithTime {
    if (self.finished_match.count == 0) {
        CGPoint off = self.Qukan_myTableView.contentOffset;
        off.y = 0 - self.Qukan_myTableView.contentInset.top;
        [self.Qukan_myTableView setContentOffset:off animated:NO];
        return;
    }
    
    // 需要定位到的模型
    QukanMatchInfoContentModel *flagModel = self.now_match.firstObject;
    if (self.now_match.count) { // 如果有正在打的比赛 定位到正在打的第一个比赛
        flagModel = self.now_match.firstObject;
    }else if(self.scheduler_match.count){ // 如果没有正在打的比赛但是有未开始的比赛。定位到未开赛的比赛
        flagModel = self.scheduler_match.firstObject;
    }else {
        return;
    }
    __block NSInteger index = 0;
    __block NSInteger section = 0;
    
    // 循环遍历查找需要定位到下表
    [self.datas enumerateObjectsUsingBlock:^(NSArray *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger row, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[QukanMatchInfoContentModel class]]) {
                QukanMatchInfoContentModel *model = obj;
                if (model.match_id == flagModel.match_id) {
                    section = idx;
                    index = row;
                }
            } else if ([obj isKindOfClass:[QukanHomeModels class]]){
            }
        }];
    }];
    
    
    // 获取到下标。定位tableview
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.Qukan_myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    });
}

// 设置按钮的隐藏显示
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
    [self Qukan_requestData];
}

#pragma mark ===================== timer ==================================
- (NSString *)getTimeStrWithString:(NSString *)str{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
    [dateFormatter setDateFormat:@"yyyy-MM-dd"]; //设定时间的格式
    NSDate *tempDate = [dateFormatter dateFromString:str];//将字符串转换为时间对象
    NSString *timeStr = [NSString stringWithFormat:@"%ld", (long)[tempDate timeIntervalSince1970]];//字符串转成时间戳,精确到毫秒*1000
    return timeStr;
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
        
        _Qukan_myTableView.rowHeight = 120;
        
        _Qukan_myTableView.separatorInset = UIEdgeInsetsMake(0,10, 0, 10);
        
        _Qukan_myTableView.showsVerticalScrollIndicator = NO;
        _Qukan_myTableView.tableFooterView = [UIView new];
        
        _Qukan_myTableView.estimatedRowHeight = 0.0f;
        _Qukan_myTableView.estimatedSectionFooterHeight = 0.0f;
        _Qukan_myTableView.estimatedSectionHeaderHeight = 0.;
        _Qukan_myTableView.separatorStyle = 0;
        
        [_Qukan_myTableView registerClass:[QukanHotTableViewCell class] forCellReuseIdentifier:@"QukanHotTableViewCell"];
        [_Qukan_myTableView registerClass:[QukanHotGTableViewCell class] forCellReuseIdentifier:@"QukanHotGTableViewCell"];
        
        
        _Qukan_myTableView.mj_header = [QukanHomeRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(Qukan_refreshData)];
    }
    return _Qukan_myTableView;
}


- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [NSMutableArray new];
    }
    return _datas;
}

@end
