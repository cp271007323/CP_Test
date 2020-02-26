//
//  QukanBasketDetailDataVC.m
//  Qukan
//
//  Created by leo on 2020/1/3.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanBasketDetailDataVC.h"
#import "QukanMatchTabSectionHeaderView.h"

#import "QukanApiManager+BasketBall.h"

#import "QukanBasketDetailDataCell.h"
#import "QukanMatchRecordCell.h"

#import "QukanBasketDetailDataModel.h"

#import <YYKit/YYKit.h>

@interface QukanBasketDetailDataVC ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tab_view;

@property (nonatomic, assign) BOOL isRequesting;

/**数据主模型*/
@property(nonatomic, strong) QukanBasketDetailDataModel  *QukanModel_source;


// 用于滑动回调
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);

@end

@implementation QukanBasketDetailDataVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kCommentBackgroudColor;

    
    [self initUI];
    
//    [self.tab_view tab_startAnimationWithDelayTime:.5f completion:^{
//        [self queryDatasFromSevers];
//    }];
    
    [self queryDatasFromSevers];
}


- (void)initUI {
    [self.view addSubview:self.tab_view];
    [self.tab_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)loadView {
    [super loadView];
    self.view = [[UIView alloc] init];
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
    
    @weakify(self);
    [[[kApiManager QukanGetMatchTeamHistoryData:self.QukanMainMatchId_str] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        KHideHUD;
        if ([x isKindOfClass:[NSDictionary class]]) {
            self.QukanModel_source = [QukanBasketDetailDataModel modelWithDictionary:x];
            for (QukanBasketDetailHisFightData *model in self.QukanModel_source.homeRecentFightData) {
                 model.selectTeamIsHomeTeam = (self.QukanModel_source.homeId.integerValue == model.homeId);
                
                if (model.homeFullScore > model.awayFullScore) {
                    // 根据主队所属判断输赢情况
                    model.winState = model.selectTeamIsHomeTeam?1:2;
                }else {
                    model.winState = model.selectTeamIsHomeTeam?2:1;
                }
            }
            
            for (QukanBasketDetailHisFightData *model in self.QukanModel_source.awayRecentFightData) {
                
                model.selectTeamIsHomeTeam = (self.QukanModel_source.awayId.integerValue == model.homeId);
                
                if (model.homeFullScore > model.awayFullScore) {
                    // 根据主队所属判断输赢情况
                    model.winState = model.selectTeamIsHomeTeam?1:2;
                }else {
                    model.winState = model.selectTeamIsHomeTeam?2:1;
                }
            }
            
            for (QukanBasketDetailHisFightData *model in self.QukanModel_source.teamHisFightData) {
                
                model.selectTeamIsHomeTeam = (self.QukanModel_source.homeId.integerValue == model.homeId);
                
                if (model.homeFullScore > model.awayFullScore) {
                    // 根据主队所属判断输赢情况
                    model.winState = model.selectTeamIsHomeTeam?1:2;
                }else {
                    model.winState = model.selectTeamIsHomeTeam?2:1;
                }
            }
        }

        if (self.QukanModel_source.homeRecentFightData.count == 0) {
            self.QukanModel_source = nil;
        }
        
        [self.tab_view reloadData];
    } error:^(NSError * _Nullable error) {
//        kShowTip(@"网络错误");
        NSLog(@"请求错误");
        [self.tab_view reloadData];
    }];
}


#pragma mark ========================== UITableViewDelegate, UITableViewDataSource ==========================

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 || indexPath.section == 1) {
        QukanBasketDetailDataCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QukanBasketDetailDataCellID"];
        if (!cell) {
            cell = [[QukanBasketDetailDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QukanBasketDetailDataCellID"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell fullCellWitModel:self.QukanModel_source andType:indexPath.section];
        return cell;
    }
    
    if (indexPath.section == 2 || indexPath.section == 3) {
        QukanMatchRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QukanMatchRecordCellID"];
        if (!cell) {
            cell = [[QukanMatchRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QukanMatchRecordCellID"];
        }
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.section == 2) {  // 历史交锋
            cell.lab_homeName.text = [NSString stringWithFormat:@"%@ VS %@",self.QukanModel_source.homeGb,self.QukanModel_source.awayGb];
            [cell fullCellWithBasketJFLSData:self.QukanModel_source.teamHisFightData.mutableCopy];
        }
        
        if (indexPath.section == 3) {  // 近期战绩
            if (indexPath.row == 0) {
                cell.lab_homeName.text = self.QukanModel_source.homeGb;
                 [cell fullCellWithBasketQDZJData:self.QukanModel_source.homeRecentFightData.mutableCopy];
            }
            
            if (indexPath.row == 1) {
                cell.lab_homeName.text = self.QukanModel_source.awayGb;
                 [cell fullCellWithBasketQDZJData:self.QukanModel_source.awayRecentFightData.mutableCopy];
            }
        }
        
        return cell;
    }
    
    return [UITableViewCell  new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 ) {
         return 13 + 50 + 24 + 30 * 6 + 10;
    }
    if (indexPath.section == 1) {
        return 13 + 50 + 24 + 30 * 8 + 10;
    }
    if (indexPath.section == 2) {
        return 30 +  25 + 55 * self.QukanModel_source.teamHisFightData.count   + 10 + 30;
    }
    
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            return 30 +  25 + 55 * self.QukanModel_source.homeRecentFightData.count   + 10 + 30;
        }
        if (indexPath.row == 1) {
            return 30 +  25 + 55 * self.QukanModel_source.awayRecentFightData.count   + 10 + 30 ;
        }
    }
   
    return 200;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.QukanModel_source) {
        return 0;
    }
    
    if (section == 2 ) {
        return 1;
    }
    
    if (section == 1 ) {
        if (self.QukanModel_source.homeTeamAvgData.shootScale.length > 0) {
            return 1;
        }else {
            return 0;
        }
    }
    
    if (section == 0){
        if (self.QukanModel_source.homeTeamRankData.awayWin + self.QukanModel_source.homeTeamRankData.homeWin == 0) {
            return 0;
        }else {
            return 1;
        }
    }
    
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (!self.QukanModel_source) {
        return [UIView new];
    }
    
    if  (section == 1 && self.QukanModel_source.homeTeamAvgData.shootScale.length == 0) {
        return [UIView new];
    }
    
    if (section == 0 && self.QukanModel_source.homeTeamRankData.awayWin + self.QukanModel_source.homeTeamRankData.homeWin == 0) {
        return [UIView new];
    }
    
    QukanMatchTabSectionHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"QukanMatchTabSectionHeaderViewID"];
    if(!header){
        header = [[QukanMatchTabSectionHeaderView alloc] initWithReuseIdentifier:@"QukanMatchTabSectionHeaderViewID"];
    }
    
    NSArray *arr = @[@"球队状况",@"场均数据对比",@"历史交战",@"近期战绩"];
    
    [header fullHeaderWithTitle:arr[section]];

    return header;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (!self.QukanModel_source) {
        return 0.001f;
    }
    
    if (section == 0 && self.QukanModel_source.homeTeamRankData.awayWin + self.QukanModel_source.homeTeamRankData.homeWin == 0) {
        return 0.001f;
    }
    
    if  (section == 1 && self.QukanModel_source.homeTeamAvgData.shootScale.length == 0) {
        return 0.001f;
    }
    
    return 56;
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
    [self queryDatasFromSevers];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return kCommentBackgroudColor;
}

//- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
//    return -(kScreenWidth*(212/375.0) + kStatusBarHeight + 44) / 2;
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
        
        [_tab_view registerClass:[QukanBasketDetailDataCell class] forCellReuseIdentifier:@"QukanBasketDetailDataCellID"];
        [_tab_view registerClass:[QukanMatchRecordCell class] forCellReuseIdentifier:@"QukanMatchRecordCellID"];
        [_tab_view registerClass:[QukanMatchTabSectionHeaderView class] forHeaderFooterViewReuseIdentifier:@"QukanMatchTabSectionHeaderViewID"];
        
//
//
//        // 设置tabAnimated相关属性
//        // 可以不进行手动初始化，将使用默认属性
//        _tab_view.tabAnimated = [TABTableAnimated animatedWithCellClassArray:@[[QukanMatchDetaiDataCell  class],[QukanMatchDetaiDataCell  class],[QukanMatchDetaiDataCell  class]] cellHeightArray:@[@(150),@(150),@(150)] animatedCountArray:@[@(2),@(1),@(2)] animatedSectionArray:@[@(0),@(1),@(2)]];
        
//        _tab_view.tabAnimated.superAnimationType = TABViewSuperAnimationTypeShimmer;
//
//        [_tab_view.tabAnimated addHeaderViewClass:[QukanMatchTabSectionHeaderView class] viewHeight:56];
//        // 新回调
//        _tab_view.tabAnimated.adjustBlock = ^(TABComponentManager * _Nonnull manager) {
//            manager.animation(0).down(50).height(0);
//            manager.animation(1).height(20).width(50);
//            manager.animation(2).down(50);
//            manager.animation(9).down(50);
//            manager.animation(3).down(50);
//            manager.animation(8).down(50);
//            manager.animation(10).down(20).up(10).height(100).radius(0.).reducedWidth(-20).left(-15).width(kScreenWidth - 30);
//        };
    }
    
    return _tab_view;
}


@end

