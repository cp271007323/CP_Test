//
//  QukanSaiChenViewController.m
//  Qukan
//
//  Created by hello on 2019/9/10.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanSaiChenViewController.h"

#import "QukanDateView.h"

#import "QukanRefreshControl.h"

#import "QukanBasketListTableViewCell.h"

#import "QukanApiManager+BasketBall.h"

#import "QukanBasketDetailVC.h"

#import "QukanLocalNotification.h"
@interface QukanSaiChenViewController ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>

@property (nonatomic, strong) UITableView *Qukan_myTableView;

@property (nonatomic, strong) QukanDateView *Qukan_dateView;

@property(nonatomic, strong) QukanRefreshControl *refreshBtn;

@property(nonatomic, strong) NSMutableDictionary<NSNumber *, NSArray *> *sevenDayDatas;

@property(nonatomic, strong) NSMutableArray *arrTime;

@property(nonatomic, assign) BOOL   bool_refreshShouldAnimation;

@property(nonatomic, assign) BOOL   bool_shouldShowEmpty;

//@property (nonatomic, assign)BOOL clickDate;

@end

@implementation QukanSaiChenViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.clickDate = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    @weakify(self)
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = kSecondTableViewBackgroudColor;
    _sevenDayDatas = @{}.mutableCopy;
    
    self.Qukan_leagueIds = @"";
    self.int_fixDays = 0;
    self.bool_refreshShouldAnimation = YES;
    
    [self initUI];
  
    self.Qukan_dateView.Qukan_didSelectItemBlock = ^(NSInteger dateType) {
        @strongify(self)
        if (dateType == self.int_fixDays + 1) {
            return;
        }
        
        self.Qukan_leagueIds = @"";
        if (dateType > 0) {
            self.int_fixDays = dateType-1;
        }else{
            self.int_fixDays = dateType;
        }
//        self.clickDate = YES;
        self.bool_shouldShowEmpty = NO;
        [self.Qukan_myTableView reloadData];
        KShowHUD
        [self requestDataFromSever];
//        if (!self.Qukan_myTableView.mj_header.isRefreshing) {
//            [self requestDataFromSever];
//        }else {
//            [self.Qukan_myTableView.mj_header beginRefreshing];
//        }
    };
    
    
}

- (void)addRefreshButton {
    
    _refreshBtn = [[QukanRefreshControl alloc] initWithFrame:CGRectMake(kScreenWidth - SCALING_RATIO(70),
  isIPhoneXSeries() ? kScreenHeight - (150 + 69) - SCALING_RATIO(70) : kScreenHeight - (160) - SCALING_RATIO(70),
    SCALING_RATIO(80), SCALING_RATIO(80)) relevanceScrollView:self.Qukan_myTableView];
    
    @weakify(self)
    _refreshBtn.beginRefreshBlock = ^{
        @strongify(self)
        self.bool_refreshShouldAnimation = YES;
        [self refreshData];
    };
    
    [self.view addSubview:_refreshBtn];
    [self.view bringSubviewToFront:_refreshBtn];
}

- (void)refreshData {
    if ([self bool_refreshShouldAnimation]) {
        self.bool_refreshShouldAnimation = NO;
        [self.Qukan_myTableView.mj_header beginRefreshing];
    }else {
        [self requestDataFromSever];
    }
}

- (void)initUI {
    [self.view addSubview:self.Qukan_dateView];
    [self.Qukan_dateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@(70));
    }];
    
    [self.view addSubview:self.Qukan_myTableView];
    [self.Qukan_myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.Qukan_dateView.mas_bottom).offset(5);
    }];
    
    [self addRefreshButton];
}

- (void)resetLegueidsWithLegueids:(NSString *)legueids {
    if (legueids.length == 0) {
        self.Qukan_leagueIds = @"这是绝对不可能的id";
        return;
    }
    self.bool_refreshShouldAnimation = YES;
    self.Qukan_leagueIds = legueids;
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSArray *matchs = self.sevenDayDatas[@(self.int_fixDays)];
    return matchs.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *matchs = self.sevenDayDatas[@(self.int_fixDays)];
    return [matchs[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QukanBasketListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QukanBasketListTableViewCell" forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSArray *matchs = self.sevenDayDatas[@(self.int_fixDays)];
    NSArray *sections = matchs.count > indexPath.section ? [matchs objectAtIndex:indexPath.section] : nil;
    QukanBasketBallMatchModel *model = sections.count > indexPath.row ? [sections objectAtIndex:indexPath.row] : [QukanBasketBallMatchModel new];
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

//点击跳转事件
-(void)selectAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *matchs = self.sevenDayDatas[@(self.int_fixDays)];
    QukanBasketBallMatchModel *model = matchs[indexPath.section][indexPath.row];
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


#pragma mark -点击事件
-(void)Qukan_Collection:(UIButton *)button{
    kGuardLogin;
    UIView *aCell = button.superview;
    while (![aCell isKindOfClass:[UITableViewCell class]]) {
        aCell = aCell.superview;
    }
    NSIndexPath *myIndex =[self.Qukan_myTableView indexPathForCell:(QukanBasketListTableViewCell*)aCell];
    
    if (button.selected) {
        [self Qukan_QuXiaoWithIndex:myIndex];
    }else{
        [self Qukan_GuanZhuWithIndex:myIndex];
    }
    
}

#pragma mark ----------------网络请求----------
#pragma mark 查询正在开始的比赛是否有动画直播
- (void)Qukan_FetchAnimationLiveWithModel:(QukanBasketBallMatchModel *)model indexPath:(NSIndexPath *)index{
    @weakify(self)
    [[[kApiManager QukanFetchAnimationLiveWithMatchId:model.matchId] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        NSString *data = (NSString *)x;
        if (data.length > 0) {
            model.animatedLive = @"1";
//            [self.datas[index.section] replaceObjectAtIndex:index.row withObject:model];
            [self.Qukan_myTableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
        }
        
    } error:^(NSError * _Nullable error) {
    }];
}
#pragma mark 查询赛程列表
- (void)requestDataFromSever{
    // 筛选空列表  则直接显示空数据
    if ([self.Qukan_leagueIds isEqualToString: @"这是绝对不可能的id"]) {
        [self.sevenDayDatas removeObjectForKey:@(self.int_fixDays)];
        [self.refreshBtn endAnimation];
        [self.Qukan_myTableView.mj_header endRefreshing];
        [self.Qukan_myTableView reloadData];
        return;
    }
    
    NSInteger day = self.int_fixDays;
    @weakify(self)
    [[[kApiManager QukanPKWithTime:[NSString stringWithFormat:@"%ld",self.int_fixDays] xtype:[NSString stringWithFormat:@"%zd",self.int_xType] list:self.Qukan_leagueIds] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            KHideHUD
        self.bool_shouldShowEmpty = YES;
            [self.refreshBtn endAnimation];
            [self.Qukan_myTableView.mj_header endRefreshing];
        
            NSDictionary *dic = (NSDictionary *)x;
            NSArray *arrayKey = [x allKeys];
            self.arrTime = [NSMutableArray arrayWithArray:arrayKey];
            NSMutableArray *datas = [NSMutableArray array];
        
            for (NSString *string in self.arrTime) {
                
                NSDictionary *dic1  = dic[string];
                
                NSArray *arr = [NSArray modelArrayWithClass:[QukanBasketBallMatchModel class] json:dic1];
                if (arr.count != 0){
                    [datas addObject:arr];
                }else{
                    break;
                }
            }
            [self.sevenDayDatas setObject:datas forKey:@(day)];
            [self.Qukan_myTableView reloadData];
//        if (self.clickDate) {
//            [self.Qukan_myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
//        }
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        self.bool_shouldShowEmpty = YES;
        [self.refreshBtn endAnimation];
        [self.Qukan_myTableView.mj_header endRefreshing];
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

#pragma mark 关注
- (void)Qukan_GuanZhuWithIndex:(NSIndexPath *)index{
    NSArray *matchs = self.sevenDayDatas[@(self.int_fixDays)];
    QukanBasketBallMatchModel *model = matchs[index.section][index.row];
    KShowHUD;
    @weakify(self)
    [[[kApiManager QukanGuanZhuPKWithMatchId:model.matchId] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        KHideHUD
        model.attention = @"1";
        [self.Qukan_myTableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
        [QukanLocalNotification noticeWithType:MatchTypeBasketball model:model];
    } error:^(NSError * _Nullable error) {
        
        KHideHUD
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

#pragma mark 取消关注
- (void)Qukan_QuXiaoWithIndex:(NSIndexPath *)index{
    NSArray *matchs = self.sevenDayDatas[@(self.int_fixDays)];
    QukanBasketBallMatchModel *model = matchs[index.section][index.row];
    KShowHUD;
    @weakify(self)
    [[[kApiManager QukanQuXiaoPKWithMatchId:model.matchId] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        KHideHUD
        model.attention = @"0";
        [self.Qukan_myTableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
        [QukanLocalNotification cancleLocationIdentifier:FormatString(@"%@%@",MatchTypeBasketball,model.matchId)];
    } error:^(NSError * _Nullable error) {

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


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate {
    
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

#pragma mark ===================== lazy ==================================


- (UITableView *)Qukan_myTableView {
    
    if (!_Qukan_myTableView) {
        _Qukan_myTableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                          style:UITableViewStylePlain];
        _Qukan_myTableView.backgroundColor = kSecondTableViewBackgroudColor;
        _Qukan_myTableView.delegate = self;
        _Qukan_myTableView.dataSource = self;
        
        _Qukan_myTableView.emptyDataSetSource = self;
        _Qukan_myTableView.emptyDataSetDelegate  = self;
        
        _Qukan_myTableView.showsVerticalScrollIndicator = NO;
        
        [_Qukan_myTableView registerClass:[QukanBasketListTableViewCell class] forCellReuseIdentifier:@"QukanBasketListTableViewCell"];
        
        [_Qukan_myTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        _Qukan_myTableView.mj_header = [QukanHomeRefreshHeader headerWithRefreshingTarget:self
        refreshingAction:@selector(requestDataFromSever)];
        
        
    }
    return _Qukan_myTableView;
}

- (NSMutableDictionary<NSNumber *,NSArray *> *)sevenDayDatas {
    if (!_sevenDayDatas) {
        _sevenDayDatas = [NSMutableDictionary new];
    }
    return _sevenDayDatas;
}

- (QukanDateView *)Qukan_dateView {
    
    if (!_Qukan_dateView) {
        _Qukan_dateView = [[QukanDateView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth([[UIScreen mainScreen] bounds]), 70)];
        
        [_Qukan_dateView Qukan_setNextSevenDaysData];
        
    }
    return _Qukan_dateView;
}


@end
