//
//  QukanBasketFollowVC.m
//  Qukan
//
//  Created by leo on 2019/9/24.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanBasketFollowVC.h"

#import "QukanBasketListTableViewCell.h"
#import "QukanApiManager+BasketBall.h"
#import "QukanBasketDetailVC.h"

//tablet头部视图
#import "QukanMatchTabSectionHeaderView.h"

#import <YYKit/YYKit.h>



@interface QukanBasketFollowVC () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, UITableViewDelegate, UITableViewDataSource>

// 数据源
@property(nonatomic, strong) NSMutableArray *datas;
// 所有时间列表
@property(nonatomic, strong) NSMutableArray *arrTime;

// 主列表
@property(nonatomic, strong) UITableView *view_tab;

@end

@implementation QukanBasketFollowVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    [self initUI];
    [self Qukan_ChaXunPKList];
}

- (void)initUI {
    [self.view_tab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)refresh {
    [self.view_tab.mj_header beginRefreshing];
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

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *view = [UIView new];
//    view.backgroundColor = kCommentBackgroudColor;
//
//    UILabel *label = [[UILabel alloc] init];
//    label.font = kFont10;
//    label.text = self.arrTime[section];
//    label.textColor =kTextGrayColor;
//    [view addSubview:label];
//    [label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(13);
//        make.centerY.mas_equalTo(0);
//    }];
//
//    NSDate *date = [NSDate dateWithString:self.arrTime[section] format:@"yyyy-MM-dd"];
//       NSString *whichWeekStr = [QukanTool Qukan_getWeekDay:self.arrTime[section]];
//
//
//       if (date.isToday) {
//            label.text = [NSString stringWithFormat:@"%@ %@ (今天)",self.arrTime[section],whichWeekStr];
//       } else if (date.isYesterday) {
//           label.text = [NSString stringWithFormat:@"%@ %@ (昨天)",self.arrTime[section],whichWeekStr];
//       } else {
//           label.text = [NSString stringWithFormat:@"%@ %@",self.arrTime[section],whichWeekStr];
//       }
//
//    return view;
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    QukanMatchTabSectionHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"QukanMatchTabSectionHeaderViewID"];
    if(!header){
        header = [[QukanMatchTabSectionHeaderView alloc] initWithReuseIdentifier:@"QukanMatchTabSectionHeaderViewID"];
        header.view_bg_color = kCommonWhiteColor;
        header.view_WhirtBg_color = kSecondTableViewBackgroudColor;
    }
    NSDate *date = [NSDate dateWithString:self.arrTime[section] format:@"yyyy-MM-dd"];
    NSString *whichWeekStr = [QukanTool Qukan_getWeekDay:self.arrTime[section]];
    if ([whichWeekStr containsString:@"周"]) {
        whichWeekStr = [whichWeekStr stringByReplacingOccurrencesOfString:@"周" withString:@"星期"];
    }else {
        whichWeekStr = FormatString(@"星期%@", whichWeekStr);
    }
    NSString *titleStr;
    if (date.isToday) {
        titleStr = [NSString stringWithFormat:@"%@  今天  %@",self.arrTime[section],whichWeekStr];
    } else if (date.isYesterday) {
        titleStr = [NSString stringWithFormat:@"%@  昨天  %@",self.arrTime[section],whichWeekStr];
    } else {
        titleStr = [NSString stringWithFormat:@"%@  %@",self.arrTime[section],whichWeekStr];
    }
    [header fullHeaderWithTitle:titleStr];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 56;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    QukanBasketDetailVC *vc = [QukanBasketDetailVC new];
    QukanBasketBallMatchModel *model = self.datas[indexPath.section][indexPath.row];
    vc.matchId = model.matchId;
    vc.hidesBottomBarWhenPushed = YES;
//    [self.navController pushViewController:vc animated:YES];
    [[QukanIMChatManager sharedInstance] logOutChat:^(NSError * _Nullable error) {
    }];
    [self.navController pushViewController:vc animated:YES];
}


#pragma mark -点击事件
-(void)Qukan_Collection:(UIButton *)button{
    UIView *aCell = button.superview;
    while (![aCell isKindOfClass:[UITableViewCell class]]) {
        aCell = aCell.superview;
    }
    NSIndexPath *myIndex =[self.view_tab indexPathForCell:(QukanBasketListTableViewCell*)aCell];
    if (button.selected) {
        [self Qukan_QuXiaoWithIndex:myIndex];
    }else{
        [self Qukan_GuanZhuWithIndex:myIndex];
    }
    
}


#pragma mark ----------------网络请求----------
#pragma mark 查询关注列表
- (void)Qukan_ChaXunPKList {
    KShowHUD;
    @weakify(self)
    [[[kApiManager QukanChaXunPKList] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        KHideHUD
        [self.view_tab.mj_header endRefreshing];
        
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
        for (NSString *string in self.arrTime) {
            NSArray *arr = [NSArray modelArrayWithClass:[QukanBasketBallMatchModel class] json:dic[string]];
            [self.datas addObject:arr];
        }
        [self.view_tab reloadData];
  
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        KHideHUD
        
        [self.view_tab.mj_header endRefreshing];
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

#pragma mark 关注
- (void)Qukan_GuanZhuWithIndex:(NSIndexPath *)index{
    QukanBasketBallMatchModel *model = self.datas[index.section][index.row];
    @weakify(self)
    [[[kApiManager QukanGuanZhuPKWithMatchId:model.matchId] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self Qukan_ChaXunPKList];
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        [self.view_tab.mj_header endRefreshing];
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

#pragma mark 取消关注
- (void)Qukan_QuXiaoWithIndex:(NSIndexPath *)index{
    QukanBasketBallMatchModel *model = self.datas[index.section][index.row];
    @weakify(self)
    [[[kApiManager QukanQuXiaoPKWithMatchId:model.matchId] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self Qukan_ChaXunPKList];
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        [self.view_tab.mj_header endRefreshing];
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}



#pragma mark - DZNEmptyDataSetDelegate,DZNEmptyDataSetSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"nodata_basketBall"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无数据";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: kCommonDarkGrayColor};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}


- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}


#pragma mark ===================== JXCategoryListContentViewDelegate ==================================

- (UIView *)listView {
    return self.view;
}


#pragma mark ===================== lazy ==================================

- (UITableView *)view_tab
{
    if (!_view_tab) {
        _view_tab = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _view_tab.dataSource = self;
        _view_tab.delegate = self;
        
        _view_tab.emptyDataSetSource = self;
        _view_tab.emptyDataSetDelegate = self;
        _view_tab.backgroundColor = [UIColor clearColor];
        
        [self.view addSubview:_view_tab];
        
        [_view_tab registerClass:[QukanBasketListTableViewCell class] forCellReuseIdentifier:@"QukanBasketListTableViewCell"];
        [_view_tab setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        _view_tab.mj_header = [QukanHomeRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(Qukan_ChaXunPKList)];

    }
    
    return _view_tab;
}

@end
