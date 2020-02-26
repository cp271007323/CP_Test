//
//  QukanGuanZhuViewController.m
//  Qukan
//
//  Created by hello on 2019/9/10.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanGuanZhuViewController.h"
#import "QukanRefreshControl.h"

#import "QukanBasketListTableViewCell.h"

#import "QukanApiManager+BasketBall.h"

#import "QukanBasketDetailVC.h"

#import <YYKit/YYKit.h>

#import "QukanLocalNotification.h"
@interface QukanGuanZhuViewController ()<UITableViewDelegate,UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property(nonatomic, strong) QukanRefreshControl *refreshBtn;

@property(nonatomic, strong) NSMutableArray *datas;

@property(nonatomic, strong) NSMutableArray *arrTime;

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, assign) BOOL   bool_refreshShouldAnimation;

@property(nonatomic, assign) BOOL   bool_shouldShowEmpty;

@end

@implementation QukanGuanZhuViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"GuanZhviewWillAppear");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    self.bool_refreshShouldAnimation = YES;
    self.tableView.mj_header = [QukanHomeRefreshHeader headerWithRefreshingTarget:self
                                                                 refreshingAction:@selector(requestDataFromSever)];
}

- (void)refreshData {
    if ([self bool_refreshShouldAnimation]) {
        self.bool_refreshShouldAnimation = NO;
        [self.tableView.mj_header beginRefreshing];
    }else {
        [self requestDataFromSever];
    }
}

- (void)initUI {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
     [self addRefreshButton];
}


- (void)addRefreshButton {
    _refreshBtn = [[QukanRefreshControl alloc] initWithFrame:CGRectMake(kScreenWidth - SCALING_RATIO(70),
    isIPhoneXSeries() ? kScreenHeight - (150 + 69) - SCALING_RATIO(70) : kScreenHeight - (160) - SCALING_RATIO(70),
    SCALING_RATIO(80), SCALING_RATIO(80))   relevanceScrollView:self.tableView];
    
    @weakify(self)
    _refreshBtn.beginRefreshBlock = ^{
        @strongify(self)
        if ([self.tableView.mj_header isRefreshing]) {
            return;
        }
        [self.tableView.mj_header beginRefreshing];
        [self refreshData];
    };
    
    [self.view addSubview:_refreshBtn];
    [self.view bringSubviewToFront:_refreshBtn];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
 
    return self.datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.datas[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QukanBasketListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QukanBasketListTableViewCell" forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    QukanBasketBallMatchModel *model = self.datas[indexPath.section][indexPath.row];
    [cell setDataWithModel:model];
    [cell.btnCollection addTarget:self action:@selector(Qukan_Collection:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 135;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = kSecondTableViewBackgroudColor;
    
    UIBezierPath *leftPath = [UIBezierPath bezierPath];
    [leftPath moveToPoint:CGPointMake(0, 5)];
    [leftPath addLineToPoint:CGPointMake(SCALING_RATIO(178), 5)];
    [leftPath addLineToPoint:CGPointMake(SCALING_RATIO(178-20), 35)];
    [leftPath addLineToPoint:CGPointMake(0, 35)];
    [leftPath closePath];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = leftPath.CGPath;
    layer.fillColor = kCommonWhiteColor.CGColor;
    [view.layer addSublayer:layer];
    UILabel *label = [[UILabel alloc] init];
    label.font = kFont10;
    label.text = self.arrTime[section];
    label.textColor =kCommonTextColor;
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.height.offset(30);
        make.centerY.mas_equalTo(0);
    }];
    NSDate *date = [NSDate dateWithString:self.arrTime[section] format:@"yyyy-MM-dd"];
    NSString *whichWeekStr = [QukanTool Qukan_getWeekDay:self.arrTime[section]];
    
    
    if (date.isToday) {
         label.text = [NSString stringWithFormat:@"%@ 星期%@ (今天)",self.arrTime[section],whichWeekStr];
    } else if (date.isYesterday) {
        label.text = [NSString stringWithFormat:@"%@ 星期%@ (昨天)",self.arrTime[section],whichWeekStr];
    } else {
        label.text = [NSString stringWithFormat:@"%@ 星期%@",self.arrTime[section],whichWeekStr];
    }
    
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    QukanBasketDetailVC *vc = [QukanBasketDetailVC new];
    QukanBasketBallMatchModel *model = self.datas[indexPath.section][indexPath.row];
    vc.Qukan_model = model;
    vc.matchId = model.matchId;
    vc.hidesBottomBarWhenPushed = YES;
//    [self.navController pushViewController:vc animated:YES];
     // 进入篮球详情界面时断开IM
    [[QukanIMChatManager sharedInstance] logOutChat:^(NSError * _Nullable error) {
    }];
    [self.navController pushViewController:vc animated:YES];
}


#pragma mark -点击事件
-(void)Qukan_Collection:(UIButton *)button{
    kGuardLogin;
    UIView *aCell = button.superview;
    while (![aCell isKindOfClass:[UITableViewCell class]]) {
        aCell = aCell.superview;
    }
    NSIndexPath *myIndex =[self.tableView indexPathForCell:(QukanBasketListTableViewCell*)aCell];
    
    if (button.selected) {
        [self Qukan_QuXiaoWithIndex:myIndex];
    }
    
}


#pragma mark 网络请求
#pragma mark 查询正在开始的比赛是否有动画直播
- (void)Qukan_FetchAnimationLiveWithModel:(QukanBasketBallMatchModel *)model indexPath:(NSIndexPath *)index{
    @weakify(self)
    [[[kApiManager QukanFetchAnimationLiveWithMatchId:model.matchId] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        NSString *data = (NSString *)x;
        if (data.length > 0) {
            model.animatedLive = @"1";
//            [self.datas[index.section] replaceObjectAtIndex:index.row withObject:model];
            [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
        }
        
    } error:^(NSError * _Nullable error) {
    }];
}

#pragma mark 查询关注列表
- (void)requestDataFromSever {
//    KShowHUD;
    
    if (![kUserManager isLogin]) {
        [self.tableView.mj_header endRefreshing];
        self.bool_shouldShowEmpty = YES;
        [self.datas removeAllObjects];
        [self.tableView reloadData];
        return;
    }
    @weakify(self)
    [[[kApiManager QukanChaXunPKList] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        KHideHUD
        [self.refreshBtn endAnimation];
        self.bool_shouldShowEmpty = YES;
        [self.tableView.mj_header endRefreshing];
        
        
        NSDictionary *dic = (NSDictionary *)x;
        NSArray *arrayKey = [x allKeys];
        
        if (arrayKey.count > 0) {
            NSArray *charArray = arrayKey;
            NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch|NSNumericSearch|NSDiacriticInsensitiveSearch|
            NSWidthInsensitiveSearch|NSForcedOrderingSearch;
            NSComparator sort = ^(NSString *obj1,NSString *obj2){
                NSRange range = NSMakeRange(0,obj1.length);
                return [obj1 compare:obj2 options:comparisonOptions range:range];
            };
            
            //数组排序
            NSArray *sortedArr = [charArray sortedArrayUsingComparator:sort];
            arrayKey = [[sortedArr reverseObjectEnumerator] allObjects];
            

        }
        self.arrTime = [NSMutableArray arrayWithArray:arrayKey];
        self.datas = [NSMutableArray array];
        if (self.arrTime.count != 0){
            for (NSString *string in self.arrTime) {
                NSArray *arr = [NSArray modelArrayWithClass:[QukanBasketBallMatchModel class] json:dic[string]];
                NSArray *finalArr = [arr sortedArrayUsingComparator:^NSComparisonResult(QukanBasketBallMatchModel *  _Nonnull obj1, QukanBasketBallMatchModel *  _Nonnull obj2) {
                    
                    NSDate *date1 = [NSDate dateWithString:obj1.matchTime format:@"yyyy-MM-dd HH:mm:ss"];
                    NSDate *date2 = [NSDate dateWithString:obj2.matchTime format:@"yyyy-MM-dd HH:mm:ss"];
                    
                    return [date2 compare:date1];
                    
                }];
                [self.datas addObject:finalArr];
            }
        }

        
        [self.tableView reloadData];
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        [self.refreshBtn endAnimation];
        self.bool_shouldShowEmpty = YES;
        [self.tableView.mj_header endRefreshing];
        KHideHUD
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}


#pragma mark 取消关注
- (void)Qukan_QuXiaoWithIndex:(NSIndexPath *)index{
    QukanBasketBallMatchModel *model = self.datas[index.section][index.row];
    KShowHUD;
    @weakify(self)
    [[[kApiManager QukanQuXiaoPKWithMatchId:model.matchId] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)

        KHideHUD        
        NSMutableArray *arr = [NSMutableArray arrayWithArray:self.datas[index.section]];
        [arr removeObject:model];
        self.datas[index.section] = [NSArray arrayWithArray:arr];
        
        if ([self.datas[index.section] count] == 0) {
            [self.datas removeObject:self.datas[index.section]];
            [self.arrTime removeObject:self.arrTime[index.section]];
        }
        
        [self.tableView reloadData];
        [QukanLocalNotification noticeWithType:MatchTypeBasketball model:model];
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        [self.tableView.mj_header endRefreshing];
        KHideHUD
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}


#pragma mark ===================== DZNEmptyDataSetSource ==================================
// 占位图提示文本
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *description = @"暂无数据";
    return [[NSAttributedString alloc] initWithString:description attributes:@{NSFontAttributeName : kFont16,NSForegroundColorAttributeName : [UIColor grayColor]}];
}
// 占位图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *imageName = @"nodata_basketBall";
    return [UIImage imageNamed:imageName];
}
// 占位图点击效果
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    //    [self Qukan_requestData];
    [self.tableView.mj_header beginRefreshing];
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


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate {
    
    if (scrollView == self.tableView) {
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

#pragma mark ===================== lazt ==================================
- (UITableView *)tableView {
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = kSecondTableViewBackgroudColor;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[QukanBasketListTableViewCell class] forCellReuseIdentifier:@"QukanBasketListTableViewCell"];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
    }
    return _tableView;
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [NSMutableArray new];
    }
    return _datas;
}

- (NSMutableArray *)arrTime {
    if (!_arrTime) {
        _arrTime = [NSMutableArray new];
    }
    return _arrTime;
}

@end
