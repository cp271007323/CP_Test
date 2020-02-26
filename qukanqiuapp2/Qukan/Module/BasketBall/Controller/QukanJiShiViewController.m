//
//  QukanJiShiViewController.m
//  Qukan
//
//  Created by hello on 2019/9/10.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanJiShiViewController.h"

#import "QukanRefreshControl.h"

#import "QukanBasketListTableViewCell.h"

#import "QukanApiManager+BasketBall.h"

#import "QukanBasketDetailVC.h"

#import <YYKit/YYKit.h>

#import "QukanLocalNotification.h"
@interface QukanJiShiViewController ()<UITableViewDelegate,UITableViewDataSource, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>

@property(nonatomic, strong) QukanRefreshControl *refreshBtn;

@property(nonatomic, strong) NSMutableArray *datas;

@property(nonatomic, strong) NSMutableArray *arrTime;

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, assign) BOOL   bool_shouldShowEmpty;

/**刷新是否需要下拉动画*/
@property(nonatomic, assign) BOOL  bool_refreshShouldAnimation;

@end

@implementation QukanJiShiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.Qukan_leagueIds = @"";
    self.int_xType = 1;
    
    [self initUI];
    
    self.bool_refreshShouldAnimation = YES;
    self.view.backgroundColor = kCommentBackgroudColor;
    
    [self requestDataFromSever];
    
    self.tableView.mj_header = [QukanHomeRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestDataFromSever)];
}

- (void)refreshData {
//    if ([self bool_refreshShouldAnimation]) {
//        self.bool_refreshShouldAnimation = NO;
//        [self.tableView.mj_header beginRefreshing];
//    }else {
        [self requestDataFromSever];
//    }
}

// 初始化视图
- (void)initUI {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self addRefreshButton];
}

- (void)addRefreshButton {
    
    _refreshBtn = [[QukanRefreshControl alloc] initWithFrame:CGRectMake(kScreenWidth - SCALING_RATIO(70),
    isIPhoneXSeries() ? kScreenHeight - (150 + 69) - SCALING_RATIO(70) : kScreenHeight - (160) - SCALING_RATIO(70),SCALING_RATIO(80),  SCALING_RATIO(80)) relevanceScrollView:self.tableView];
    
    @weakify(self)
    _refreshBtn.beginRefreshBlock = ^{
        @strongify(self)
        if ([self.tableView.mj_header isRefreshing]) {
            return;
        }
        [self.tableView.mj_header beginRefreshing];

    };
    
    [self.view addSubview:_refreshBtn];
    [self.view bringSubviewToFront:_refreshBtn];
}


#pragma mark ===================== function ==================================

// 重新设置
- (void)resetLegueidsWithLegueids:(NSString *)legueids{
    if (legueids.length == 0) {
        self.Qukan_leagueIds = @"这是绝对不可能的id";
        return;
    }
    
    self.bool_refreshShouldAnimation = YES;
    self.Qukan_leagueIds = legueids;
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 135;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self selectAtIndexPath:indexPath];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSInteger count = [self.datas[section] count];
    if (count > 0) {
        return 40;
    } else {
        return 0.01;
    }
}
//点击跳转事件
-(void)selectAtIndexPath:(NSIndexPath *)indexPath{
    QukanBasketBallMatchModel *model = self.datas[indexPath.section][indexPath.row];
    QukanBasketDetailVC *vc = [[QukanBasketDetailVC alloc] init];
    vc.Qukan_model = model;
    vc.matchId = model.matchId;
    vc.hidesBottomBarWhenPushed = YES;
//    [self.navController pushViewController:vc animated:YES];
     // 进入篮球详情界面时断开IM
    [[QukanIMChatManager sharedInstance] logOutChat:^(NSError * _Nullable error) {
    }];
    [self.navController pushViewController:vc animated:YES];
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    NSInteger count1 = [self.datas[section] count];
    if (count1 == 0) {
        return view;
    }
    
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
    NSInteger count = [self.datas[section] count];
    layer.fillColor = count ? kCommonWhiteColor.CGColor : UIColor.clearColor.CGColor;
    if (date.isToday) {
         label.text = [NSString stringWithFormat:@"%@ 星期%@ (今天)",self.arrTime[section],whichWeekStr];
    } else if (date.isYesterday) {
        label.text = [NSString stringWithFormat:@"%@ 星期%@ (昨天)",self.arrTime[section],whichWeekStr];
    } else {
        label.text = [NSString stringWithFormat:@"%@ 星期%@",self.arrTime[section],whichWeekStr];
    }
    if (count == 0 ) {
        label.text = @"";
    }
    return view;
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
    }else{
        [self Qukan_GuanZhuWithIndex:myIndex];
    }
    
}


#pragma mark ----------------网络请求----------
#pragma mark 查询即时列表
- (RACSignal * _Nonnull)extracted {
    return [kApiManager QukanTimelyPKWithList:self.Qukan_leagueIds xtype:[NSString stringWithFormat:@"%zd",self.int_xType]];
}

- (void)requestDataFromSever {
    // 筛选空列表  则直接显示空数据
    if ([self.Qukan_leagueIds isEqualToString: @"这是绝对不可能的id"]) {
        self.bool_shouldShowEmpty = YES;
        // 移除监听列表里面的所有监听数据
        [self.datas removeAllObjects];
        [self.refreshBtn endAnimation];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
        return;
    }
    
    @weakify(self)
    if (!self.datas.count) {
        KShowHUD
    }
    [[[self extracted] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        KHideHUD
        [self.refreshBtn endAnimation];
        [self.tableView.mj_header endRefreshing];
        NSDictionary *dic = (NSDictionary *)x;
        NSArray *arrayKey = [x allKeys];
        self.bool_shouldShowEmpty = YES;
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
        
                self.arrTime =[NSMutableArray arrayWithArray: sortedArr];
                }
            self.datas = [NSMutableArray array];
            for (NSString *string in self.arrTime) {
                NSArray *arr = [NSArray modelArrayWithClass:[QukanBasketBallMatchModel class] json:dic[string]];
                [self.datas addObject:arr];
            }
        
            [self.tableView reloadData];
        

    } error:^(NSError * _Nullable error) {
        self.bool_shouldShowEmpty = YES;
        @strongify(self)
        [self.tableView.mj_header endRefreshing];
        KHideHUD
        [self.refreshBtn endAnimation];
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

#pragma mark 关注
- (void)Qukan_GuanZhuWithIndex:(NSIndexPath *)index{
    QukanBasketBallMatchModel *model = self.datas[index.section][index.row];
    KShowHUD;
    @weakify(self)
    [[[kApiManager QukanGuanZhuPKWithMatchId:model.matchId] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        
        @strongify(self)
        KHideHUD
        model.attention = @"1";
        [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
        [QukanLocalNotification noticeWithType:MatchTypeBasketball model:model];
    } error:^(NSError * _Nullable error) {
        @strongify(self)
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
        model.attention = @"0";
        [self.datas[index.section] replaceObjectAtIndex:index.row withObject:model];
        [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
        [QukanLocalNotification cancleLocationIdentifier:FormatString(@"%@%@",MatchTypeBasketball,model.matchId)];
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        [self.tableView.mj_header endRefreshing];
        KHideHUD
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}


#pragma mark ===================== JXCategoryListContentViewDelegate ==================================
- (UIView *)listView {
    return self.view;
}

- (void)listDidAppear {
    [self refreshData];
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


#pragma mark ===================== scrollViewdelegate ==================================
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView  willDecelerate:(BOOL)decelerate {
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


#pragma mark ===================== lazy ==================================

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kSecondTableViewBackgroudColor;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        
        
        _tableView.showsVerticalScrollIndicator = NO;
        
        [_tableView registerClass:[QukanBasketListTableViewCell class] forCellReuseIdentifier:@"QukanBasketListTableViewCell"];
        _tableView.separatorStyle = 0;
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
