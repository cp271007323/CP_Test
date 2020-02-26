//
//  QukanBasketAnalysisVC.m
//  Qukan
//
//  Created by leo on 2019/9/3.
//  Copyright © 2019 mac. All rights reserved.
//  篮球赛事分析
#import "QukanBasketAnalysisVC.h"
#import "QukanMatchStatisticsCell.h"
#import "QukanShowDtaCell.h"

#import "QukanShowStatisticsCell.h"

#import "QukanTeamPlayerDetailCell.h"

#import "QukanApiManager+BasketBall.h"

#import "QukanApiManager+info.h"

#import "QukanHomeModels.h"

#import "QukanGDataView.h"

#import "QukanMatchTabSectionHeaderView.h"
#import "QukanBasketDetailVC.h"
#import "QukanBSKMemberInfoViewController.h"

@interface QukanBasketAnalysisVC ()<UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property(nonatomic, strong) QukanHomeModels *model;
@property(nonatomic, strong) QukanGDataView *Qukan_gView;

@property(nonatomic, weak)QukanBasketBallMatchDetailModel *detailModel;

@property(nonatomic, strong) UITableView   * view_tab;

@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);



@end

@implementation QukanBasketAnalysisVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    
    QukanBasketDetailVC *vc = (QukanBasketDetailVC *)self.parentViewController.parentViewController;
    NSAssert([vc isKindOfClass:[QukanBasketDetailVC class]], @"未能正确拿到视图控制器");
    self.detailModel = vc.detailModel;
    
    @weakify(self)
    [[[RACObserve(self.detailModel, homeScore) distinctUntilChanged] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
        [self.view_tab reloadData];
    }];
    
    [[[[RACObserve(self, detailModel) distinctUntilChanged] ignore:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
        [self setData];
    }];
    
    [self.view_tab reloadData];
}

- (void)setData {
    if (self.detailModel.phpAdvId.length) {
        [self Qukan_newsChannelHomepWithAd:self.detailModel.phpAdvId.integerValue];
    } else {
        [self qukanAD];
    }
}
- (void)qukanAD {
    @weakify(self)
    [[[kApiManager QukanInfoWithType:21] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self dataSourceWith:x];
        
    }];
}
- (void)Qukan_newsChannelHomepWithAd:(NSInteger)adId {
    @weakify(self)
    [[[kApiManager QukanInfoWithType:41 withid:adId] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
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
    [self setShowView];
}
- (void)setShowView {
    if (!self.model) return;
    [self.Qukan_gView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.equalTo(@(68));
    }];
    [self.view_tab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.Qukan_gView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.offset(-0);
    }];
    
    //设置ad
    [self.Qukan_gView Qukan_setAdvWithModel:self.model];
    @weakify(self)
    self.Qukan_gView.dataImageView_didBlock = ^{
        @strongify(self)
        if (self.analysisVc_didBolck) {
            self.analysisVc_didBolck(self.model);
        }
    };
}
#pragma mark ===================== ui ==================================
- (void)initUI {
    [self.view addSubview:self.view_tab];
    [self.view_tab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark ===================== public moth ==================================
- (void)loadView {
    self.view = [[UIView alloc] init];
}

#pragma mark ===================== JXCategoryListContentViewDelegate ==================================
- (UIView *)listView{
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.view_tab;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback ?: self.scrollCallback(self.view_tab);
}


#pragma mark - UITableViewDelegate, UITableViewDataSource

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    QukanMatchTabSectionHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"QukanMatchTabSectionHeaderViewID"];
    if(!header){
        header = [[QukanMatchTabSectionHeaderView alloc] initWithReuseIdentifier:@"QukanMatchTabSectionHeaderViewID"];
    }
    
    NSArray *titles = @[@"技术支持",@"球员-数据王",@"球队统计",self.detailModel.guestTeam,self.detailModel.homeTeam];
    [header fullHeaderWithTitle:titles[section]];
    if (section == 0) {
        return header;
    }
    if (section == 1 && (self.detailModel.homePlayerList.count > 0 || self.detailModel.guestPlayerList.count > 0)) {
        return header;
    }
    if (section == 2 && (self.detailModel.homePlayerList.count > 0 || self.detailModel.guestPlayerList.count > 0)) {
        return header;
    }
    if (section == 3 && (self.detailModel.homePlayerList.count > 0 )) {
        return header;
    }
    if (section == 4 && (self.detailModel.guestPlayerList.count > 0)) {
        return header;
    }
    
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 65;
    }
    if (section == 1 && (self.detailModel.homePlayerList.count > 0 || self.detailModel.guestPlayerList.count > 0)) {
        return 65;
    }
    if (section == 2 && (self.detailModel.homePlayerList.count > 0 || self.detailModel.guestPlayerList.count > 0)) {
        return 65;
    }
    if (section == 3 && (self.detailModel.homePlayerList.count > 0 )) {
        return 65;
    }
    if (section == 4 && (self.detailModel.guestPlayerList.count > 0)) {
        return 65;
    }
    return 0.01f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        QukanMatchStatisticsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QukanMatchStatisticsCell"];
        if (!cell) {
            cell = [[QukanMatchStatisticsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QukanMatchStatisticsCell"];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell fullCellWithData:self.detailModel];
        return cell;
    }
    if (indexPath.section == 1) {
        QukanShowDtaCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QukanShowDtaCell"];
        if (!cell) {
            cell = [[QukanShowDtaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QukanShowDtaCell"];
        }
        [cell setHomePlayers:self.detailModel.homePlayerList guestPlayers:self.detailModel.guestPlayerList];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        @weakify(self)
        cell.playerCilckBlock = ^(QukanHomeAndGuestPlayerListModel * _Nonnull model) {
            @strongify(self)
            QukanBSKMemberInfoViewController *vc = [[QukanBSKMemberInfoViewController alloc] init];
            vc.pid = model.playerId;
            if (self.detailModel.xtype.integerValue == 1) {
                [self.navgation_vc pushViewController:vc animated:YES];
            }
        };
        return cell;
    }
    
    if (indexPath.section == 2) {
        QukanShowStatisticsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QukanShowStatisticsCell"];
        if (!cell) {
            cell = [[QukanShowStatisticsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QukanShowStatisticsCell"];
        }
        cell.detailModel = self.detailModel;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    if (indexPath.section == 3) {
        QukanTeamPlayerDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QukanTeamPlayerDetailCell"];
        if (!cell) {
            cell = [[QukanTeamPlayerDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QukanTeamPlayerDetailCell"];
        }
        [cell setGuestPlayers:self.detailModel.guestPlayerList];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.teamName = self.detailModel.homeTeam;
        return cell;
    }
    
    
    if (indexPath.section == 4) {
        QukanTeamPlayerDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QukanTeamPlayerDetailCell"];
        if (!cell) {
            cell = [[QukanTeamPlayerDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QukanTeamPlayerDetailCell"];
        }
        [cell setHomePlayers:self.detailModel.homePlayerList];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.teamName = self.detailModel.guestTeam;
        return cell;
    }
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
//        return 320;  // 有数据统计列表
        return 100;  // 无数据统计列表
    }
    
    if (indexPath.section == 1) {
        return 10 + PlayerDtaCellHeight * 5 + 10;
    }
    
    if (indexPath.section == 2) {
        return 35 + QukanShowStatisticsListCellHeight * 12;
        // return 0;
    }
    
    if (indexPath.section == 3) {
        return QukanTeamPlayerDetailListCellHeight * ([self guestPlayerTime] +1);
    }
    
    if (indexPath.section == 4) {
        return QukanTeamPlayerDetailListCellHeight * ([self homePlayerTime] + 1);
    }
    return 44;
}
//计算主队上场有比赛时常的人数
- (NSInteger)homePlayerTime {
    NSArray *array = [[_detailModel.homePlayerList.rac_sequence filter:^BOOL(QukanHomeAndGuestPlayerListModel *model) {
        return ![model.playTime isEqualToString:@"0"];
    }] array];
    return array.count;
}
//计算客队上场有比赛时常的人数
- (NSInteger)guestPlayerTime {
    NSArray *array = [[_detailModel.guestPlayerList.rac_sequence filter:^BOOL(QukanHomeAndGuestPlayerListModel *model) {
        return ![model.playTime isEqualToString:@"0"];
    }] array];
    return array.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    if (section == 1 && (self.detailModel.homePlayerList.count > 0 || self.detailModel.guestPlayerList.count > 0)) {
         return 1;
    }
    if (section == 2 && (self.detailModel.homePlayerList.count > 0 || self.detailModel.guestPlayerList.count > 0)) {
        return 1;
    }
    if (section == 3 && (self.detailModel.homePlayerList.count > 0 )) {
        return 1;
    }
    if (section == 4 && (self.detailModel.guestPlayerList.count > 0)) {
        return 1;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.detailModel) {
        if (self.detailModel.status.integerValue == 0
            || self.detailModel.status.integerValue == -2
            || self.detailModel.status.integerValue == -5) {  // 未开或者待定
            return 0;
        } else {
            if (self.detailModel.statistics.length) {
                return 5;
            } else {
                return 1;
            }
        }

    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

#pragma mark - DZNEmptyDataSetSource
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    UIFont *font = [UIFont boldSystemFontOfSize:14];
    NSString *description = @"暂无数据";
    return [[NSAttributedString alloc] initWithString:description attributes:@{NSFontAttributeName : font,NSForegroundColorAttributeName : [UIColor grayColor]}];
}
//
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *imageName = @"nodata_basketBall";
    return [UIImage imageNamed:imageName];
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return YES;
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



#pragma mark ===================== lazy ==================================
- (UITableView *)view_tab {
    if (!_view_tab) {
        _view_tab = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        _view_tab.delegate = self;
        _view_tab.dataSource = self;
        
        _view_tab.emptyDataSetSource = self;
        _view_tab.emptyDataSetDelegate = self;
        
        
        _view_tab.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _view_tab.estimatedRowHeight = 0;
        _view_tab.backgroundColor = kCommentBackgroudColor;
        
        
        [_view_tab registerClass:[QukanMatchStatisticsCell class] forCellReuseIdentifier:@"QukanMatchStatisticsCell"];
        [_view_tab registerClass:[QukanShowDtaCell class] forCellReuseIdentifier:@"QukanShowDtaCell"];
        
        
        [_view_tab registerClass:[QukanShowStatisticsCell class] forCellReuseIdentifier:@"QukanShowStatisticsCell"];
        [_view_tab registerClass:[QukanTeamPlayerDetailCell class] forCellReuseIdentifier:@"QukanTeamPlayerDetailCell"];

    }
    return _view_tab;
}

- (UIView *)Qukan_gView {
    if (!_Qukan_gView) {
        _Qukan_gView = [[QukanGDataView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
        [self.view addSubview:_Qukan_gView];
        [_Qukan_gView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.left.equalTo(self.view).offset(0);
            make.right.equalTo(self.view).offset(0);
            make.height.mas_equalTo(68);
        }];
    }
    return _Qukan_gView;
}
@end
