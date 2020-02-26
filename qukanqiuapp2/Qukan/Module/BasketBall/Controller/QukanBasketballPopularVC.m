//
//  QukanBasketballPopularVC.m
//  Qukan
//
//  Created by hello on 2019/9/4.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanBasketballPopularVC.h"
#import "QukanRefreshControl.h"
#import "QukanBasketListTableViewCell.h"
#import "QukanApiManager+BasketBall.h"

#import "QukanApiManager+info.h"
#import "QukanHomeModels.h"
#import "QukanHotGTableViewCell.h"
#import "QukanGViewController.h"
#import "QukanBasketDetailVC.h"

#import <YYKit/YYKit.h>
#import "QukanLocalNotification.h"
@interface QukanBasketballPopularVC () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
// 刷新按钮
@property(nonatomic, strong) QukanRefreshControl *refreshBtn;
// 所有数据的数组
@property(nonatomic, strong) NSMutableArray *datas;
// 所有时间的数组
@property(nonatomic, strong) NSMutableArray *arrTime;
// 广告模型
@property(nonatomic, strong) QukanHomeModels    *model;


@property(nonatomic, assign) BOOL isLocation;
// 主列表
@property(nonatomic, strong) UITableView *tableView;
/**是否需要显示占位图*/
@property(nonatomic, assign) BOOL   bool_shouldShowEmpty;


// 当前定位到的section  用于插入广告
@property (nonatomic, assign) NSInteger section;
// 当前定位到的index 用于插入广告
@property (nonatomic, assign) NSInteger index;

// 当前定位到的section
@property (nonatomic, assign) NSInteger location_section;
// 当前定位到的index
@property (nonatomic, assign) NSInteger location_index;


@end

@implementation QukanBasketballPopularVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.isLocation = YES;

    [self initUI];
    [self addRefreshButton];
    
    self.shouldRelocation = YES;
    self.tableView.mj_header = [QukanHomeRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    [self Qukan_newsPage];
}


- (void)initUI {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)addRefreshButton {
    _refreshBtn = [[QukanRefreshControl alloc] initWithFrame:CGRectMake(kScreenWidth - SCALING_RATIO(70),
    isIPhoneXSeries() ? kScreenHeight - (150 + 69) - SCALING_RATIO(70) : kScreenHeight - (160) - SCALING_RATIO(70),SCALING_RATIO(80),SCALING_RATIO(80)) relevanceScrollView:self.tableView];
    
    @weakify(self)
    _refreshBtn.beginRefreshBlock = ^{
        @strongify(self)
        [self headerRefresh];
    };
    
    [self.view addSubview:_refreshBtn];
    [self.view bringSubviewToFront:_refreshBtn];
}

- (void)headerRefresh {
    self.shouldRelocation = YES;
    [self queryListDataFromSevers];
}


#pragma mark ===================== 网络请求 ==================================

// 请求广告
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
    if (!array.count) {
        return;
    }
    for (NSDictionary *dict in array) {
        QukanHomeModels *model = [QukanHomeModels modelWithDictionary:dict];
        self.model = model;
    }
}

// 关注
- (void)Qukan_GuanZhuWithIndex:(NSIndexPath *)index{
    QukanBasketBallMatchModel *model = self.datas[index.section][index.row];
    KShowHUD;
    @weakify(self)
    [[[kApiManager QukanGuanZhuPKWithMatchId:model.matchId] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        KHideHUD
        //        [SVProgressHUD showSuccessWithStatus:@"关注成功"];
        model.attention = @"1";
        [self.tableView reloadData];
        [QukanLocalNotification noticeWithType:MatchTypeBasketball model:model];
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        [self.tableView.mj_header endRefreshing];
        KHideHUD
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

// 取消关注
- (void)Qukan_QuXiaoWithIndex:(NSIndexPath *)index{
    QukanBasketBallMatchModel *model = self.datas[index.section][index.row];
    KShowHUD;
    @weakify(self)
    [[[kApiManager QukanQuXiaoPKWithMatchId:model.matchId] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        KHideHUD
        @synchronized (self) {
            model.attention = @"0";
            [self.tableView reloadData];
            [QukanLocalNotification cancleLocationIdentifier:FormatString(@"%@%@",MatchTypeBasketball,model.matchId)];
        }
        
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        [self.tableView.mj_header endRefreshing];
        KHideHUD
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

// 列表请求
- (void)queryListDataFromSevers {
    @weakify(self)
    CFAbsoluteTime state1 = CFAbsoluteTimeGetCurrent();
    if (!self.datas.count) {
        KShowHUD
    }
    [[[kApiManager QukanHotList] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        KHideHUD
        CFAbsoluteTime state2 = CFAbsoluteTimeGetCurrent();
        NSLog(@"请求篮球列表耗时 ============  %f",state2 - state1);
        [self.refreshBtn endAnimation];
        self.bool_shouldShowEmpty = YES;
        [self.tableView.mj_header endRefreshing];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self setDataWithX:x];
        });
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        KHideHUD
        CFAbsoluteTime state2 = CFAbsoluteTimeGetCurrent();
        NSLog(@"请求篮球列表耗时 ============  %f",state2 - state1);
        self.bool_shouldShowEmpty = YES;
        [self.tableView reloadData];
        [self.refreshBtn endAnimation];
        [self.tableView.mj_header endRefreshing];
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}


#pragma mark ===================== 私有方法 ==================================
- (void)setDataWithX:(NSDictionary *)x {
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
        self.arrTime =[NSMutableArray arrayWithArray: sortedArr];
    }
    
    
   NSMutableArray *muDatas = [NSMutableArray array];
    for (NSString *string in self.arrTime) {
        NSArray *arr = [NSArray modelArrayWithClass:[QukanBasketBallMatchModel class] json:dic[string]];
        [muDatas addObject:arr];
    }
    
    //每个分区列表里的数据排序，已结束的排前面
    for(int i = 0; i < muDatas.count; i++){
        NSMutableArray* sortedArray = muDatas[0];
        [sortedArray sortUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2){
            QukanBasketBallMatchModel* opt1 = (QukanBasketBallMatchModel*)obj1;
            QukanBasketBallMatchModel* opt2 = (QukanBasketBallMatchModel*)obj2;
            //已结束的排前面
             if(opt1.status == -1 && opt2.status == -1 ){
                   return [opt1.startTime compare:opt2.startTime];
               }else if (opt1.status == 0 && opt2.status == 0){
                   return [opt1.startTime compare:opt2.startTime];
               }else if(opt1.status > 0 && opt2.status > 0){
                   return [opt1.startTime compare:opt2.startTime];
               }else if(opt1.status > 0 && opt2.status == 0){
                   return NSOrderedAscending;
               }
               return [opt1.startTime compare:opt2.startTime];
        }];
    }
    
    if (self.model) [self setAdapToArr:muDatas];
    
    @weakify(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        @strongify(self);
        self.datas = muDatas;
        [self.tableView reloadData];
        if (self.shouldRelocation) {
            self.shouldRelocation = NO;
            [self locationTab];
        }
    });
    
    
}

- (void)locationTab {
    for (int i = 0; i < self.datas.count; i++) {
        for (int j = 0; j < [self.datas[i] count]; j++) {
            QukanBasketBallMatchModel *model = self.datas[i][j];
            if (model.status >= 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.location_section = i;
                    self.location_index = j;
                    [self.tableView scrollToRow:j inSection:i atScrollPosition:UITableViewScrollPositionTop animated:NO];
                });
                return;
            }
        }
    }
}




#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.datas[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id x = self.datas[indexPath.section][indexPath.row];
    if ([x isKindOfClass:[QukanBasketBallMatchModel class]]) {
        QukanBasketListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QukanBasketListTableViewCell" forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        QukanBasketBallMatchModel *model = self.datas[indexPath.section][indexPath.row];
        [cell setDataWithModel:model];
        [cell.btnCollection addTarget:self action:@selector(Qukan_Collection:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
        
    } else if ([x isKindOfClass:[QukanHomeModels class]]) {
        QukanHomeModels *model = x;
        static NSString *cellStr = @"QukanHotGTableViewCell";
        QukanHotGTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        [cell Qukan_setDataWith:model];
        cell.separatorInset = UIEdgeInsetsMake(0, kScreenWidth, 0, 0);
        return cell;
    }
    
    return nil;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    id x = self.datas[indexPath.section][indexPath.row];
    if ([x isKindOfClass:[QukanBasketBallMatchModel class]]) {
        return 135;
    } else if ([x isKindOfClass:[QukanHomeModels class]]) {
        return 68;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
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

#pragma mark -cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self selectAtIndexPath:indexPath];
}

//点击跳转事件
-(void)selectAtIndexPath:(NSIndexPath *)indexPath{
    id x = self.datas[indexPath.section][indexPath.row];
    if ([x isKindOfClass:[QukanBasketBallMatchModel class]]) {
        NSArray *indexSectionArray = self.datas[indexPath.section];
        QukanBasketBallMatchModel *model = indexSectionArray[indexPath.row];
        QukanBasketDetailVC *vc = [[QukanBasketDetailVC alloc] init];
        vc.Qukan_model = model;
        vc.matchId = model.matchId;
        vc.hidesBottomBarWhenPushed = YES;
//        [self.navController pushViewController:vc animated:YES];
         // 进入篮球详情界面时断开IM
        [[QukanIMChatManager sharedInstance] logOutChat:^(NSError * _Nullable error) {
        }];
        [self.navController pushViewController:vc animated:YES];
    }else {
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

- (void)setAdapToArr:(NSMutableArray *)muDatas{
    NSInteger index = 0;
    for (int i = 0; i < muDatas.count; i++) {
        for (int j = 0; j < [muDatas[i] count]; j++) {
            if ([muDatas[i][j] isKindOfClass:[QukanBasketBallMatchModel class]]) {
                QukanBasketBallMatchModel *model = muDatas[i][j];
                if (model.status >= 0 && model.status <= 50) {
                    index++;
                }
                
                if (index == 2) {
                    [muDatas[i] insertObject:self.model atIndex:j+1];
                    return;
                }
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
    [self queryListDataFromSevers];
}


#pragma mark ===================== scorll delegate ==================================
// 滑动结束后显示出刷新按钮
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView == self.tableView) {
        if (!decelerate) {  //
            BOOL dragToDragStop = scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
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
        _tableView = [[UITableView alloc] init];
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = kSecondTableViewBackgroudColor;
        
        _tableView.emptyDataSetDelegate = self;
        _tableView.emptyDataSetSource = self;
        
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0.0f;
        _tableView.estimatedSectionHeaderHeight = 0.;
        
        [_tableView registerClass:[QukanBasketListTableViewCell class] forCellReuseIdentifier:@"QukanBasketListTableViewCell"];
        
        [_tableView registerClass:[QukanHotGTableViewCell class] forCellReuseIdentifier:@"QukanHotGTableViewCell"];
        
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
