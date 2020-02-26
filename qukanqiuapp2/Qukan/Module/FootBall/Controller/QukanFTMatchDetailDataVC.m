//
//  QukanFTMatchDetailDataVC.m
//  Qukan
//
//  Created by leo on 2019/12/30.
//  Copyright © 2019 mac. All rights reserved.
//  详情数据vc

#import "QukanFTMatchDetailDataVC.h"
#import "QukanMatchTabSectionHeaderView.h"
#import "QukanMatchDetaiDataCell.h"

#import "QukanApiManager+Competition.h"
#import "QukanMatchInfoModel.h"

#import "QukanMatchDetailJSTJModel.h"
#import <YYKit/YYKit.h>

#import "QukanMatchDetailHistoryModel.h"
#import "QukanMatchRecordCell.h"


#import "QukanTabAnimationCell.h"
#import "QukanTabAnimationHeader.h"

#import <TABAnimated.h>

@interface QukanFTMatchDetailDataVC ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tab_view;

@property (nonatomic, assign) BOOL isRequesting;

/**主队技术统计*/
@property(nonatomic, strong) QukanMatchDetailJSTJModel   * model_homeJstj;
/**客队技术统计*/
@property(nonatomic, strong) QukanMatchDetailJSTJModel   * model_awayJstj;

/**两队历史交锋*/
@property(nonatomic, strong) NSMutableArray<QukanMatchDetailHistoryModel *>   * arr_teamLsjf;

/**主队近期交战记录*/
@property(nonatomic, strong) NSMutableArray<QukanMatchDetailHistoryModel *>   * arr_homeHistoryMatch;
/**客队近期交战记录*/
@property(nonatomic, strong) NSMutableArray<QukanMatchDetailHistoryModel *>   * arr_awayHistoryMatch;

// 用于滑动回调
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);

/**历史交战最大显示数*/
@property(nonatomic, assign) NSInteger   int_maxLSJZCount;
/**近期战绩最大显示数*/
@property(nonatomic, assign) NSInteger   int_maxJQJZCount;

/**历史交战同赛事*/
@property(nonatomic, assign) BOOL    bool_lsjzSameMatch;
/**历史交战同主客*/
@property(nonatomic, assign) BOOL    bool_lsjzSameHA;

/**近期战绩同赛事*/
@property(nonatomic, assign) BOOL    bool_jqzjSameMatch;
/**近期战绩同主客*/
@property(nonatomic, assign) BOOL    bool_jqzjSameHA;


/**是否是第一次请求主队积分*/
@property(nonatomic, assign) NSInteger    bool_isFistQueryHomeJF;
/**是否是第一次请求客队积分*/
@property(nonatomic, assign) NSInteger    bool_isFistQueryAwayJF;
/**是否是第一次请求双方历史战绩*/
@property(nonatomic, assign) NSInteger    bool_isFistQueryHomeAndAwayZJ;
/**是否是第一次请求主队主客队历史战绩*/
@property(nonatomic, assign) NSInteger    bool_isFistQueryAllZJ;


@end

@implementation QukanFTMatchDetailDataVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kCommentBackgroudColor;
    
    //是否是第一次请求主队积分
    self.bool_isFistQueryHomeJF = YES;;
    //是否是第一次请求客队积分
    self.bool_isFistQueryAwayJF = YES;;
    //是否是第一次请求双方历史战绩
    self.bool_isFistQueryHomeAndAwayZJ = YES;
    //是否是第一次请求主队主客队历史战绩
    self.bool_isFistQueryAllZJ = YES;
    
    self.int_maxJQJZCount = 10;
    self.int_maxLSJZCount = 6;
    
    [self initUI];

    [self.tab_view tab_startAnimationWithDelayTime:.5f completion:^{
        [self queryDatasFromSevers];
    }];
}


- (void)initUI {
    [self.view addSubview:self.tab_view];
    [self.tab_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark ================================ network ================================
- (void)queryDatasFromSevers{
   
    // 获取主队技术统计
    [self getHomeJSTJData];
    // 获取客队技术统计
    [self getAwayJSTJData];
    
    // 查询球队历史交锋
    [self QueryAllHomeWithAwayZJ];
    // 查询主队近期战绩
    [self QueryHomeAndAwayZJ];
}

/** 获取球队技术统计数据
 leagueId    是    int    联赛id
 season    是    string    赛季
 teamId    是    int    球队id
 */
- (void)getHomeJSTJData{
    @weakify(self);
    [[[kApiManager QukanGetMatchDetailJSTJDataWith:self.model_main.league_id.integerValue season:self.model_main.season?self.model_main.season:@"" teamId:self.model_main.home_id.integerValue] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        KHideHUD;
        
        if ([x isKindOfClass:[NSArray class]]) {    
            NSArray *arr = x;
            self.model_homeJstj = [QukanMatchDetailJSTJModel modelWithDictionary:(NSDictionary *)arr.firstObject];
            
            if (self.bool_isFistQueryHomeJF) {
               [self.tab_view tab_endAnimationWithSection:0];
            }else {
                [self.tab_view reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
            }
        } else {
            NSLog(@"数据解析错误");
            if (self.bool_isFistQueryHomeJF) {
                [self.tab_view tab_endAnimationWithSection:0];
            }
            [self.tab_view reloadData];
        }
        
        [self.tab_view reloadEmptyDataSet];
        self.bool_isFistQueryHomeJF = NO;
    } error:^(NSError * _Nullable error) {
        KHideHUD;
        if (self.bool_isFistQueryHomeJF) {
            [self.tab_view tab_endAnimationWithSection:0];
        }else {
            [UIView performWithoutAnimation:^{
                [self.tab_view reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
            }];
        }
        
        [self.tab_view reloadEmptyDataSet];
        self.bool_isFistQueryHomeJF = NO;
    }];
}

- (void)getAwayJSTJData {
    @weakify(self);
    [[[kApiManager QukanGetMatchDetailJSTJDataWith:self.model_main.league_id.integerValue season:self.model_main.season teamId:self.model_main.away_id.integerValue] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        KHideHUD;
        if ([x isKindOfClass:[NSArray class]]) {
            
            NSArray *arr = x;
         
            self.model_awayJstj = [QukanMatchDetailJSTJModel modelWithDictionary:(NSDictionary *)arr.firstObject];
            
            if (self.bool_isFistQueryAwayJF) {
                [self.tab_view tab_endAnimationWithSection:1];
            }else {
                 [self.tab_view reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
            }
        }else {
            NSLog(@"数据解析错误");
            if (self.bool_isFistQueryAwayJF) {
                [self.tab_view tab_endAnimationWithSection:1];
            }
            
            [self.tab_view reloadData];
        }
        
        [self.tab_view reloadEmptyDataSet];
        self.bool_isFistQueryAwayJF = NO;
    } error:^(NSError * _Nullable error) {
        KHideHUD;
        if (self.bool_isFistQueryAwayJF) {
            [self.tab_view tab_endAnimationWithSection:1];
        }else {
            [UIView performWithoutAnimation:^{
                [self.tab_view reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
            }];
        }
        
        [self.tab_view reloadEmptyDataSet];
        self.bool_isFistQueryAwayJF = NO;
    }];
}


/**
 查询交战记录
 
 @param type 1主客队历史对战,2近期战绩
 @param homeId 主队id
 @param awayId     客队id
 @param leagueId 联赛id
 @param flagLeague 是否同赛事 1是 0否
 @param flagHA 是否同主客 1是 0否
 @return 请求信号
 */
- (void)QueryAllHomeWithAwayZJ{
    @weakify(self);
    [[[kApiManager QukanGetMatchDetailLSZJDataWithType:1 homeId:self.model_main.home_id.integerValue awayId:self.model_main.away_id.integerValue leagueId:self.model_main.league_id.integerValue flagLeague:self.bool_lsjzSameMatch flagHA:self.bool_lsjzSameHA] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        KHideHUD;
        [self.arr_teamLsjf removeAllObjects];
        if ([x isKindOfClass:[NSArray class]]) {
            [self.tab_view reloadEmptyDataSet];
            
            NSArray *arr = x;
            for (NSDictionary *dic in arr) {
                QukanMatchDetailHistoryModel *model = [QukanMatchDetailHistoryModel modelWithDictionary:dic];
                model.selectTeamIsHomeTeam = (self.model_main.home_id.integerValue == model.homeId);
                
                if (model.homeScore > model.awayScore) {
                    // 根据主队所属判断输赢情况
                    model.winState = model.selectTeamIsHomeTeam?1:2;
                }else if (model.homeScore < model.awayScore) {
                    model.winState = model.selectTeamIsHomeTeam?2:1;
                }else {
                    model.winState = 3;
                }
                
                // 如果当前的主队id 和 球队的主队id相同  则当前比赛的主队属于此条数据的主队  反正则为客队
                [self.arr_teamLsjf addObject:model];
            }
           
            if (self.bool_isFistQueryHomeAndAwayZJ) {
                [self.tab_view tab_endAnimationWithSection:2];
            }else {
                [UIView performWithoutAnimation:^{
                    [self.tab_view reloadSection:2 withRowAnimation:UITableViewRowAnimationNone];
                }];
            }
            
        }else {
            NSLog(@"数据解析错误");
            
            if (self.bool_isFistQueryHomeAndAwayZJ) {
                [self.tab_view tab_endAnimationWithSection:2];
            }else {
                [UIView performWithoutAnimation:^{
                    [self.tab_view reloadSection:2 withRowAnimation:UITableViewRowAnimationNone];
                }];
            }
        }
        
        [self.tab_view reloadEmptyDataSet];
        self.bool_isFistQueryHomeAndAwayZJ = NO;
    } error:^(NSError * _Nullable error) {
        KHideHUD;
        [self.arr_teamLsjf removeAllObjects];
        if (self.bool_isFistQueryHomeAndAwayZJ) {
            [self.tab_view tab_endAnimationWithSection:2];
        }else {
            [UIView performWithoutAnimation:^{
                [self.tab_view reloadSection:2 withRowAnimation:UITableViewRowAnimationNone];
            }];
        }
         [self.tab_view reloadEmptyDataSet];
        self.bool_isFistQueryHomeAndAwayZJ = NO;
    }];
}

// 获取主队客队各自的历史交战
- (void)QueryHomeAndAwayZJ{
    @weakify(self);
    [[[kApiManager QukanGetMatchDetailLSZJDataWithType:2 homeId:self.model_main.home_id.integerValue awayId:self.model_main.away_id.integerValue leagueId:self.model_main.league_id.integerValue flagLeague:self.bool_jqzjSameMatch flagHA:self.bool_jqzjSameHA] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        KHideHUD;
        
        [self.arr_awayHistoryMatch removeAllObjects];
        [self.arr_homeHistoryMatch removeAllObjects];
        
        if ([x isKindOfClass:[NSArray class]]) {
            [self.tab_view reloadEmptyDataSet];
            NSArray *arr = x;
            for (NSDictionary *dic in arr) {
                QukanMatchDetailHistoryModel *model = [QukanMatchDetailHistoryModel modelWithDictionary:dic];
                model.selectTeamIsHomeTeam = (self.model_main.home_id.integerValue == model.homeId);
                
                if (model.homeScore > model.awayScore) {
                    // 根据主队所属判断输赢情况
                    model.winState = model.selectTeamIsHomeTeam?1:2;
                }else if (model.homeScore < model.awayScore) {
                    model.winState = model.selectTeamIsHomeTeam?2:1;
                }else {
                    model.winState = 3;
                }
                
                if (model.type == 2) {   // 主队的近期战绩列表
                    [self.arr_homeHistoryMatch addObject:model];
                }
                if (model.type == 3) {  // 客队的近期战绩列表
                    [self.arr_awayHistoryMatch addObject:model];
                }
            }
         
            if (self.bool_isFistQueryAllZJ) {
                [self.tab_view tab_endAnimationWithSection:3];
            }else {
                [UIView performWithoutAnimation:^{
                    [self.tab_view reloadSection:3 withRowAnimation:UITableViewRowAnimationNone];
//                    [self.tab_view reloadData];
                }];
            }
        }else {
            NSLog(@"数据解析错误");
            if (self.bool_isFistQueryAllZJ) {
                [self.tab_view tab_endAnimationWithSection:3];
            }else {
                [UIView performWithoutAnimation:^{
                    [self.tab_view reloadSection:3 withRowAnimation:UITableViewRowAnimationNone];
                }];
            }
        }
        
        [self.tab_view reloadEmptyDataSet];
        self.bool_isFistQueryAllZJ = NO;
    } error:^(NSError * _Nullable error) {
        
        KHideHUD;
        [self.arr_awayHistoryMatch removeAllObjects];
        [self.arr_homeHistoryMatch removeAllObjects];
        if (self.bool_isFistQueryAllZJ) {
            [self.tab_view tab_endAnimationWithSection:3];
        }else {
            [UIView performWithoutAnimation:^{
                [self.tab_view reloadSection:3 withRowAnimation:UITableViewRowAnimationNone];
            }];
        }
        
        [self.tab_view reloadEmptyDataSet];
        self.bool_isFistQueryAllZJ = NO;
    }];
}

#pragma mark ========================== UITableViewDelegate, UITableViewDataSource ==========================

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 || indexPath.section == 1) {  // 技术统计
        QukanMatchDetaiDataCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QukanMatchDetaiDataCellID"];
        if (!cell) {
            cell = [[QukanMatchDetaiDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QukanMatchDetaiDataCellID"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        if (indexPath.section == 0) {
            cell.lab_homeName.text = self.model_main.home_name;
            [cell fullCellWithJSTJData:self.model_homeJstj];
        }else if (indexPath.section == 1){
            cell.lab_homeName.text = self.model_main.away_name;
            [cell fullCellWithJSTJData:self.model_awayJstj];
        }
        return cell;
    }
    
    QukanMatchRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QukanMatchRecordCellID"];
    if (!cell) {
        cell = [[QukanMatchRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QukanMatchRecordCellID"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 2){  // 历史交锋
        cell.homeName = self.model_main.home_name;
        if (self.arr_teamLsjf.count > self.int_maxLSJZCount) {
            [cell fullCellWithJFLSData:(NSMutableArray *)[self.arr_teamLsjf subarrayWithRange:NSMakeRange(0, self.int_maxLSJZCount)]];
        }else {
            [cell fullCellWithJFLSData:self.arr_teamLsjf];
        }
    }else if (indexPath.section == 3) {  // 近期战绩
        
        if (indexPath.row == 0) {
            cell.lab_homeName.text = self.model_main.home_name;
            cell.homeName = self.model_main.home_name;
            if (self.arr_homeHistoryMatch.count > self.int_maxJQJZCount) {
                [cell fullCellWithQDZJData:(NSMutableArray *)[self.arr_homeHistoryMatch subarrayWithRange:NSMakeRange(0, self.int_maxJQJZCount)]];
            }else {
                [cell fullCellWithQDZJData:self.arr_homeHistoryMatch];
            }
        }
        if (indexPath.row == 1) {
            cell.lab_homeName.text = self.model_main.away_name;
            cell.homeName = self.model_main.away_name;
            if (self.arr_awayHistoryMatch.count > self.int_maxJQJZCount) {
                [cell fullCellWithQDZJData:(NSMutableArray *)[self.arr_awayHistoryMatch subarrayWithRange:NSMakeRange(0, self.int_maxJQJZCount)]];
            }else {
                [cell fullCellWithQDZJData:self.arr_awayHistoryMatch];
            }
        }
        
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 || indexPath.section == 1) {
        if (indexPath.section == 0 && self.model_homeJstj) {
             return 30 + 25 * 4 + 10;
        }
        if (indexPath.section == 1 && self.model_awayJstj) {
            return 30 + 25 * 4 + 10;
        }
    }
    if (indexPath.section == 2) {
        if (self.arr_teamLsjf.count > 0) {
            return 30 +  25 + 55 * MIN(self.arr_teamLsjf.count, self.int_maxLSJZCount)   + 10 + 75;
        }
    }
    if (indexPath.section == 3) {
        if (indexPath.row == 0 && self.arr_homeHistoryMatch.count > 0) {
            return 30 +  25 + 55 * MIN(self.arr_homeHistoryMatch.count,self.int_maxJQJZCount) + 10 + 30;
        }
        if (indexPath.row == 1 && self.arr_awayHistoryMatch.count > 0) {
            return 30 +  25 + 55 * MIN(self.arr_awayHistoryMatch.count,self.int_maxJQJZCount) + 10 + 30;
        }
    }
    return 0.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        NSInteger count = self.model_homeJstj?1:0;
        return count;
    }
    if (section == 1) {
        NSInteger count = self.model_awayJstj?1:0;
        return count;
    }
    if (section == 2 && (self.arr_teamLsjf.count > 0 || self.bool_lsjzSameHA || self.bool_lsjzSameMatch)) {
        return 1;
    }
    if (section == 3 && (self.arr_homeHistoryMatch.count + self.arr_awayHistoryMatch.count > 0 || self.bool_lsjzSameMatch || self.bool_lsjzSameHA)) {
        return 2;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    if (section == 1) {
        return [UIView new];
    }
    
    QukanMatchTabSectionHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"QukanMatchTabSectionHeaderViewID"];
    if(!header){
        header = [[QukanMatchTabSectionHeaderView alloc] initWithReuseIdentifier:@"QukanMatchTabSectionHeaderViewID"];
    }
    
    NSArray *arr = @[@"技术统计",@"",@"历史交战",@"近期战绩"];
    if (section == 0) {
        [header fullHeaderWithTitle:arr[section]];
    }else {
        if (section == 2) {
           [header fullShowBtnHeaderWithTitle:arr[section] sameMatch:self.bool_lsjzSameMatch sameTeam:self.bool_lsjzSameHA type:1 andMaxCount:self.int_maxLSJZCount];
        }
        if (section == 3) {
            [header fullShowBtnHeaderWithTitle:arr[section] sameMatch:self.bool_jqzjSameMatch sameTeam:self.bool_jqzjSameHA type:2 andMaxCount:self.int_maxJQJZCount];
        }
    }

    @weakify(self);
    if (section != 0 && section != 1) {
        header.sameTeamBlock = ^(BOOL isSelect) {
            @strongify(self);
            if (section == 2) {
                self.bool_lsjzSameHA = !self.bool_lsjzSameHA;
//                [self.view showClearLoadingWithYoffset:-kScreenWidth*(212/375.0) / 2];
                [self QueryAllHomeWithAwayZJ];
            }
            if (section == 3) {
                self.bool_jqzjSameHA = !self.bool_jqzjSameHA;
//                [self.view showClearLoadingWithYoffset:-kScreenWidth*(212/375.0) / 2];
                [self QueryHomeAndAwayZJ];
            }
        };

        header.sameMatchBlock = ^(BOOL isSelect) {
            @strongify(self);
            if (section == 2) {
                self.bool_lsjzSameMatch = !self.bool_lsjzSameMatch;
//                [self.view showClearLoadingWithYoffset:-kScreenWidth*(212/375.0) / 2];
                 [self QueryAllHomeWithAwayZJ];
            }
            if (section == 3) {
                self.bool_jqzjSameMatch = !self.bool_jqzjSameMatch;
//                [self.view showClearLoadingWithYoffset:-kScreenWidth*(212/375.0) / 2];
                [self QueryHomeAndAwayZJ];
            }
        };

        header.lessBlock = ^{
            @strongify(self);
            if (section == 2) {
                self.int_maxLSJZCount = 6;
            }
            if (section == 3) {
                self.int_maxJQJZCount = 10;
            }

            [UIView performWithoutAnimation:^{
                [self.tab_view reloadSection:section withRowAnimation:UITableViewRowAnimationNone];
            }];
        };

        header.moreBlock = ^{
            @strongify(self);
            if (section == 2) {
                self.int_maxLSJZCount = 12;
            }
            if (section == 3) {
                self.int_maxJQJZCount = 20;
            }
            [UIView performWithoutAnimation:^{
                [self.tab_view reloadSection:section withRowAnimation:UITableViewRowAnimationNone];
            }];
        };
    }
    if (section == 0 && (self.model_awayJstj || self.model_homeJstj)) {
        return header;
    }
    if (section == 2 && self.arr_teamLsjf.count > 0) {
        return header;
    }
    if (section == 3 ) {
        return header;
    }
    return [UIView new];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 0.001f;
    }
    
    if (section == 0 && self.model_homeJstj) {
        return 56;
    }
    if (section == 2 && self.arr_teamLsjf.count > 0) {
        return 56;
    }
    if (section == 3) {
        return 56;
    }
     return 0.001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

#pragma mark =========================== DZNEmptyDataSetSource ===========================
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *description = @"暂无数据";
    return [[NSAttributedString alloc] initWithString:description attributes:@{NSFontAttributeName : kFont16,NSForegroundColorAttributeName : [UIColor grayColor]}];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *imageName = @"nodate_footBall";

    return [UIImage imageNamed:imageName];
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    [self.view showClearLoadingWithYoffset:-kScreenWidth*(212/375.0) / 2];
    [self queryDatasFromSevers];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return kCommentBackgroudColor;
}

//- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
//    return -kScreenWidth*(212/375.0) / 2;
//}

#pragma mark - DZNEmptyDataSetDelegate

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

#pragma mark =========== JXCategoryView/JXCategoryListContainerView==================================
- (UIView *)listView{
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.tab_view;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback ?: self.scrollCallback(self.tab_view);
}

#pragma  mark - lazy
- (UITableView *)tab_view {
    if (!_tab_view) {
        _tab_view = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        _tab_view.delegate = self;
        _tab_view.dataSource = self;
        
        _tab_view.emptyDataSetSource = self;
        _tab_view.emptyDataSetDelegate = self;
        
        _tab_view.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tab_view.backgroundColor = kCommentBackgroudColor;
        
        _tab_view.estimatedRowHeight = 0.0f;
        _tab_view.estimatedSectionFooterHeight = 0.0f;
        _tab_view.estimatedSectionHeaderHeight = 0.;
        
        [_tab_view registerClass:[QukanMatchDetaiDataCell class] forCellReuseIdentifier:@"QukanMatchDetaiDataCellID"];
        [_tab_view registerClass:[QukanMatchRecordCell class] forCellReuseIdentifier:@"QukanMatchRecordCellID"];
        [_tab_view registerClass:[QukanMatchTabSectionHeaderView class] forHeaderFooterViewReuseIdentifier:@"QukanMatchTabSectionHeaderViewID"];
        
        
        // 设置tabAnimated相关属性
        // 可以不进行手动初始化，将使用默认属性
        _tab_view.tabAnimated = [TABTableAnimated animatedWithCellClassArray:@[[QukanTabAnimationCell  class],[QukanTabAnimationCell  class],[QukanTabAnimationCell  class],[QukanTabAnimationCell  class]] cellHeightArray:@[@(150),@(150),@(150),@(150)] animatedCountArray:@[@(1),@(1),@(1),@(2)] animatedSectionArray:@[@(0),@(1),@(2),@(3)]];

        _tab_view.tabAnimated.superAnimationType = TABViewSuperAnimationTypeShimmer;
        
        [_tab_view.tabAnimated addHeaderViewClass:[QukanTabAnimationHeader class] viewHeight:56 toSection:0];
        [_tab_view.tabAnimated addHeaderViewClass:[QukanTabAnimationHeader class] viewHeight:56 toSection:2];
        [_tab_view.tabAnimated addHeaderViewClass:[QukanTabAnimationHeader class] viewHeight:56 toSection:3];
        // 新回调
        _tab_view.tabAnimated.adjustBlock = ^(TABComponentManager * _Nonnull manager) {
        };
    }
    
    return _tab_view;
}

- (NSMutableArray<QukanMatchDetailHistoryModel *> *)arr_teamLsjf {
    if (!_arr_teamLsjf) {
        _arr_teamLsjf = [NSMutableArray new];
    }
    return _arr_teamLsjf;
}

- (NSMutableArray<QukanMatchDetailHistoryModel *> *)arr_homeHistoryMatch {
    if (!_arr_homeHistoryMatch) {
        _arr_homeHistoryMatch = [NSMutableArray new];
    }
    return _arr_homeHistoryMatch;
}

- (NSMutableArray<QukanMatchDetailHistoryModel *> *)arr_awayHistoryMatch {
    if (!_arr_awayHistoryMatch) {
        _arr_awayHistoryMatch = [NSMutableArray new];
    }
    return _arr_awayHistoryMatch;
}
@end


