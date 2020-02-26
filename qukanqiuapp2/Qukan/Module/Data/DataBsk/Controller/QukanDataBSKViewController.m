//
//  QukanDataBSKViewController.m
//  Qukan
//
//  Created by blank on 2019/12/25.
//  Copyright © 2019 mac. All rights reserved.
//
typedef NS_ENUM(NSInteger,BtnType) {
    T_customize   = 10, //联赛筛选
    T_season,           //赛季or联盟选择
    T_schedule,         //赛程
    T_rank,             //排名
    T_year,             //赛季年份
    T_month             //月份
};
#import "QukanDataBSKViewController.h"
#import "QukanBSKDataLeagueCell.h"
#import "QukanBSKDataScheduleCell.h"
#import "QukanBSKDataPjCell.h"
#import "QukanBSKTeamDetialViewController.h"
#import "QukanApiManager+QukanDataBSK.h"
#import "QukanDataFilterView.h"
#import "MMPickerView.h"
#import "QukanBSKDataCountryModel.h"
#import "QukanBSKDataMenuButtonView.h"
#import "QukanBasketDetailVC.h"
@interface QukanDataBSKViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong)UICollectionView *leagueCollectionView;//联赛collectionview
@property (nonatomic, strong)UIButton *customizeButton;//联赛筛选按钮
@property (nonatomic, strong)QukanDataFilterView *filterView;//联赛筛选viwe
@property (nonatomic, strong)QukanBSKDataMenuButtonView *yearView;
@property (nonatomic, strong)QukanBSKDataMenuButtonView *seasonView;
@property (nonatomic, strong)QukanBSKDataMenuButtonView *monthView;
@property (nonatomic, strong)UIScrollView *mScrollView;//主scrollview
@property (nonatomic, strong)UIView *scheduleTopView;//赛程头部view
@property (nonatomic, strong)UIView *rankTopView;//排名头部view
@property (nonatomic, strong)UITableView *scheduleTableView;//赛程tab
@property (nonatomic, strong)UITableView *rankTableView;//排名tab
@property (nonatomic, strong)NSMutableArray *leagueArray;//联赛数组
@property (nonatomic, copy)NSArray *leagues;//保存首次联赛数组
@property (nonatomic, strong)NSMutableArray *yearArray;//年份数组
@property (nonatomic, strong)NSMutableArray *eventTypeArray;//赛事类型数组
@property (nonatomic, strong)NSMutableArray *monthArray;//月份数组
@property (nonatomic, strong)NSMutableArray *scheduleArray;//赛程array
@property (nonatomic, strong)NSMutableArray *allianceArray;//联盟数组
@property (nonatomic, strong)NSMutableArray *rankArray;//排名数组
@property (nonatomic, strong)QukanDataBSKParamsModel *paramModel_schedule;//赛程参数
@property (nonatomic, strong)QukanDataBSKParamsModel *paramModel_rank;//排名参数
@property (nonatomic, assign)BOOL showEmptyView_schedule;//赛程无数据
@property (nonatomic, assign)BOOL showEmptyView_rank;//排名无数据
@property (nonatomic, assign)BtnType btnType;//赛程or排名

@property (nonatomic, assign)BOOL showError_view;
@property (nonatomic, strong)NSString *error_msg;
@end

@implementation QukanDataBSKViewController
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MMPickerView dismissWithCompletion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.btnType = T_schedule;
    [self QukanInitMenuTop];
    [self QukanInitMenuBot];
    [self QukanInitScrollView_scheduleTopView_rankTopView_scheduleTableView_ranTableView];
    [self QukanInitFilterView];
    [self QukanLoadLeagues];
}

- (void)QukanInitScrollView_scheduleTopView_rankTopView_scheduleTableView_ranTableView {
    [self.view addSubview:self.mScrollView];
    [self QukanInit_ScheduleTopView_RankTopView];
    [self.mScrollView addSubview:self.scheduleTableView];
    [self.mScrollView addSubview:self.rankTableView];
    [self.scheduleTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.mas_equalTo(self.scheduleTopView.mas_bottom).offset(0);
        make.width.offset(kScreenWidth);
        make.height.offset(self.mScrollView.height - 30);
    }];
    [self.rankTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(kScreenWidth);
        make.top.mas_equalTo(self.rankTopView.mas_bottom).offset(0);
        make.width.offset(kScreenWidth);
        make.height.offset(self.mScrollView.height - 30);
    }];
    self.scheduleTableView.mj_header = [QukanHomeRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    self.rankTableView.mj_header = [QukanHomeRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
}

- (void)QukanInitMenuTop {
    [self.view addSubview:self.leagueCollectionView];
    [self.view addSubview:self.customizeButton];
    [self.leagueCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(0);
        make.height.offset(40);
        make.right.offset(0);
    }];
    [self.customizeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.offset(0);
        make.height.offset(40);
        make.width.offset(12+36);
    }];
    
    //action-自定义联赛
    [[self.customizeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        self.filterView.hidden = 0;
        [self animateHiddenFilter:NO];
    }];
}

- (void)QukanInitMenuBot {
    UIView *menuBackView = [UIView new];
    [self.view addSubview:menuBackView];
    [menuBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.mas_equalTo(self.leagueCollectionView.mas_bottom).offset(0);
        make.height.offset(49);
    }];
    menuBackView.backgroundColor = HEXColor(0x333D46);
    for (int i = 0;i < 3;i++) {
        QukanBSKDataMenuButtonView *menuBtnView = [QukanBSKDataMenuButtonView new];
        [menuBackView addSubview:menuBtnView];
        [menuBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.offset(0);
            if (i == 0) {
                make.left.offset(10);
                make.width.offset(45);
            } else if (i == 1) {
                make.left.offset(60);
                make.right.mas_equalTo(self.view.mas_centerX).offset(-77);
            } else if (i == 2) {
                make.right.offset(-10);
                make.width.offset(36);
            }
        }];
        if (i == 0) {
            self.yearView = menuBtnView;
        } else if (i == 1) {
            self.seasonView = menuBtnView;
        } else {
            self.monthView = menuBtnView;
        }
        menuBtnView.btn.tag = i == 0 ? T_year : (i == 1 ? T_season : T_month);
        //action-年份,赛季/联赛,月份选择
        [[menuBtnView.btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            NSInteger tag = menuBtnView.btn.tag;
            if (tag == T_year) {
                [self popMenuWithArray:self.yearArray tag:tag];
            } else if (tag == T_season) {
                NSMutableArray *titles = [NSMutableArray new];
                if (self.btnType == T_schedule) {
                    for (int i = 0; i < self.eventTypeArray.count;i++) {
                        QukanEventTypeModel *model = self.eventTypeArray[i];
                        [titles addObject:model.kindName];
                    }
                } else {
                    for (int i = 0; i < self.allianceArray.count;i++) {
                        QukanDataAllianceModel *model = self.allianceArray[i];
                        [titles addObject:model.allianceName];
                    }
                }
                [self popMenuWithArray:titles tag:tag];
            } else if (tag == T_month) {
                 [self popMenuWithArray:self.monthArray tag:tag];
            }
        }];
    }
    [self QukanInitSegmentViewWithMenuBackView:menuBackView];
}

- (void)QukanInit_ScheduleTopView_RankTopView{
    [self.mScrollView addSubview:self.scheduleTopView];
    NSArray *scheduleTitles = @[@"时间",@"客队",@"赛果",@"主队"];
    for (int i = 0; i < scheduleTitles.count; i++) {
        UILabel *lab = [UILabel new];
        [self.scheduleTopView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.offset(0);
            make.left.offset(i == 0 ? 15:(i == 1 ? SCALING_RATIO(155) : (i == 2 ? SCALING_RATIO(216) :SCALING_RATIO(280))));
            make.width.offset(20);
        }];
        lab.textColor = kCommonWhiteColor;
        lab.text = scheduleTitles[i];
        lab.font = kFont10;
        lab.textAlignment = NSTextAlignmentCenter;
    }
    
    [self.mScrollView addSubview:self.rankTopView];
    NSArray *rankTitles = @[@"排名",@"球队",@"胜率",@"负",@"胜"];
    NSArray *margins = @[@(7),@(65),@(-48),@(-86),@(-128)];
    for (int i = 0; i < rankTitles.count; i++) {
        UILabel *lab = [UILabel new];
        [self.rankTopView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset(0);
            make.height.offset(22);
            if (i == 0 || i == 1) {
                make.left.offset([margins[i] intValue]);
            } else {
                make.left.mas_equalTo(self.rankTopView.mas_right).offset([margins[i] intValue]);
            }
        }];
        lab.textColor = kCommonWhiteColor;
        lab.font = kFont10;
        lab.text = rankTitles[i];
    }
}

- (void)QukanInitSegmentViewWithMenuBackView:(UIView *)menuBackView {
    NSArray *segTitles = @[@"赛程",@"排名"];
    NSMutableArray *segBtns = [NSMutableArray new];
    for (int i = 0;i<segTitles.count;i++) {
        UIButton *segBtn = [UIButton new];
        [menuBackView addSubview:segBtn];
        segBtn.frame = CGRectMake(i == 0 ? self.view.centerX - SCALING_RATIO(kScreenWidth > 375 ? 73 : 65) : self.view.centerX, 10, SCALING_RATIO(kScreenWidth > 375 ? 73 : 65), 29);
        segBtn.titleLabel.font = kFont12;
        [self applyRoundCorners:i == 0 ? UIRectCornerTopLeft|UIRectCornerBottomLeft : UIRectCornerTopRight|UIRectCornerBottomRight  radius:4 view:segBtn];
        [segBtn setTitle:segTitles[i] forState:UIControlStateNormal];
        [segBtns addObject:segBtn];
        //action-赛程,排名
        @weakify(self)
        [[segBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            if (self.btnType == segBtn.tag) {
                return;
            }
            for (UIButton *btn in segBtns) {
                btn.selected = 0;
            }
            segBtn.selected = 1;
            self.btnType = segBtn.tag;
            [self.mScrollView setContentOffset:CGPointMake(segBtn.tag == T_schedule ? 0 : kScreenWidth, 0) animated:1];
            self.monthView.hidden = segBtn.tag == T_schedule ? 0 : 1;
            self.scheduleTopView.hidden = segBtn.tag == T_schedule ? 0 : 1;
            self.rankTopView.hidden = segBtn.tag == T_rank ? 0 : 1;
            if (self.btnType == T_schedule) {
                self.seasonView.content = self.paramModel_schedule.kindName;
                [self QukanLoadEventTypeWithModel:self.paramModel_schedule];
            } else {
                NSString *str = [self.paramModel_rank.allianceName isEqualToString:@"无联盟"] ? @"" : self.paramModel_rank.allianceName;
                self.seasonView.content = str;
                [self QukanLoadAlliancesWithModel:self.paramModel_rank];
            }
        }];
        [segBtn setBackgroundImage:[UIImage imageWithColor:HEXColor(0x333D46)] forState:UIControlStateNormal];
        [segBtn setBackgroundImage:[UIImage imageWithColor:HEXColor(0x1B2227)] forState:UIControlStateSelected];
        [segBtn setTitleColor:HEXColor(0x8D95A8) forState:UIControlStateNormal];
        [segBtn setTitleColor:kCommonWhiteColor forState:UIControlStateSelected];
        segBtn.selected = i == 0 ? 1 : 0;
        segBtn.tag = i == 0 ? T_schedule : T_rank;
    }
}

#pragma mark ===================== 隐藏/显示FilterView ==================================
- (void)animateHiddenFilter:(BOOL)hidden {
    [UIView animateWithDuration:0.3 animations:^{
        if (hidden == YES) {
            self.filterView.centerY -= kScreenHeight - kTopBarHeight;
            self.scrollView.height -= kBottomBarHeight;
            CGRect frame = self.tabBarController.tabBar.frame;
            frame.origin.y = kScreenHeight - kBottomBarHeight;
            self.tabBarController.tabBar.frame = frame;
        } else {
           self.filterView.centerY += kScreenHeight - kTopBarHeight;
            self.scrollView.height += kBottomBarHeight;
        }
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            if (hidden == NO) {
                CGRect frame = self.tabBarController.tabBar.frame;
                frame.origin.y = kScreenHeight;
                self.tabBarController.tabBar.frame = frame;
            }
        }];
    }];
}

- (void)QukanInitFilterView {
    @weakify(self)
    CGFloat height = kScreenHeight - kTopBarHeight;
    self.filterView = [[QukanDataFilterView alloc]initWithFrame:CGRectMake(0, -height, kScreenWidth, kScreenHeight - kTopBarHeight) block:^(id filterId) {
        @strongify(self)
        [self animateHiddenFilter:YES];
        if (filterId) {
            QukanBtSclassVos *btM = (QukanBtSclassVos *)filterId;
            self.paramModel_schedule = [QukanDataBSKParamsModel new];
            self.paramModel_schedule.sclassId = btM.sclassId;
            self.paramModel_schedule.season = btM.currMatchSeason;
            if (self.btnType == T_schedule) {
                [self QukanLoadEventTypeWithModel:self.paramModel_schedule];
            } else {
                [self QukanLoadAlliancesWithModel:self.paramModel_rank];
            }
            QukanBtSclassHotModel *model = [QukanBtSclassHotModel new];
            model.sclassId = btM.sclassId;
            model.xshort = btM.xshort;
            model.currMatchSeason = btM.currMatchSeason;
//            [self.leagueArray removeAllObjects];
            [self.leagueArray addObjectsFromArray:self.leagues];
            BOOL hasFilter = 0;
            for (QukanBtSclassHotModel *htModel in self.leagueArray) {
                if (htModel.sclassId.integerValue == btM.sclassId.integerValue) {
                    hasFilter = 1;
                }
            }
            if (!hasFilter) {
                [self.leagueArray addObject:model];
            }
            for (int i = 0;i<self.leagueArray.count;i++) {
                QukanBtSclassHotModel *model = self.leagueArray[i];
                model.selected = 0;
                if (model.sclassId.integerValue == btM.sclassId.integerValue) {
                    model.selected = 1;
                }
            }
            [self.leagueCollectionView reloadData];
        }
    }];
    [self.filterView QukanLoadBSKFilterData];
    [self.view insertSubview:self.filterView belowSubview:self.navTop];
}

#pragma mark ===================== scheduleOrRank_tab_headerRefresh ==================================
- (void)headerRefresh {
    if (self.btnType == T_schedule) {
        [self QukanLoadScheduleWithModel:self.paramModel_schedule];
    } else {
        [self QukanLoadRank:self.paramModel_rank];
    }
}

#pragma mark ===================== bottom_alert ==================================
- (void)popMenuWithArray:(NSArray *)array tag:(NSInteger)tag; {
    if (array.count == 0) {
        return;
    }
    @weakify(self)
    UIFont *customFont  = [UIFont systemFontOfSize:14];
    NSString *selectString;
    if (tag == T_year) {
        selectString = self.paramModel_rank.season;
    } else if (tag == T_season) {
        selectString = self.btnType == T_schedule ? self.paramModel_schedule.kindName : self.paramModel_rank.allianceName;
    } else if (tag == T_month) {
        selectString = self.paramModel_schedule.month;
    }
    NSDictionary *options = @{MMbackgroundColor:[UIColor whiteColor],
                              MMtextColor: kCommonBlackColor,
                              MMtoolbarColor:[UIColor whiteColor],
                              MMbuttonColor:kThemeColor,
                              MMfont: customFont,
                              MMvalueY:@(4.5),
                              MMselectedObject:selectString,
                              };
    [MMPickerView showPickerViewInView:self.view
                           withStrings:array
                           withOptions:options
                            completion:^(NSString *selectedString) {
                                @strongify(self)
                                if (tag == T_year) {
                                    self.yearView.content = selectedString;
                                    self.paramModel_schedule.season = selectedString;
                                    self.paramModel_rank.season = selectedString;
                                    if (self.btnType == T_schedule) {
                                        [self QukanLoadEventTypeWithModel:self.paramModel_schedule];
                                    } else {
                                        [self QukanLoadAlliancesWithModel:self.paramModel_rank];
                                    }
                                } else if (tag == T_month) {
                                   
                                    self.monthView.content = FormatString(@"%@月",selectedString);
                                    self.paramModel_schedule.month = selectedString;
                                    [self QukanLoadScheduleWithModel:self.paramModel_schedule];
                                } else if (tag == T_season) {
                                    if (self.btnType == T_schedule) {
                                        for (QukanEventTypeModel *model in self.eventTypeArray) {
                                            if ([model.kindName isEqualToString:selectedString]) {
                                                self.paramModel_schedule.matchKind = model.matchKind;
                                                self.paramModel_schedule.kindName = model.kindName;
                                            }
                                        }
                                        [self QukanLoadSelectMonthWithModel:self.paramModel_schedule];
                                    } else {
                                        for (QukanDataAllianceModel *model in self.allianceArray) {
                                            if ([model.allianceName isEqualToString:selectedString]) {
                                                self.paramModel_rank.allianceId = model.allianceId;
                                                self.paramModel_rank.allianceName = model.allianceName;
                                            }
                                        }
                                        [self QukanLoadRank:self.paramModel_rank];
                                    }
                                    self.seasonView.content = selectedString;
                                }
                            }];
}

#pragma mark ===================== hidden_filterView ==================================
- (void)hideFilterView:(BOOL)hidden{
    self.filterView.hidden = hidden;
}

#pragma mark ===================== select_Leagues ==================================
- (void)QukanLoadLeagues {
    self.showError_view = self.showEmptyView_rank = self.showEmptyView_schedule = 0;
    @weakify(self)
    
    [[[kApiManager QukanSelectBtSclassHot] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.leagueArray removeAllObjects];
        self.showError_view = NO;
        for (NSDictionary *dic in x) {
            [self.leagueArray addObject:[QukanBtSclassHotModel modelWithDictionary:dic]];
        }
        if (self.leagueArray.count) {
            QukanBtSclassHotModel *model0 = self.leagueArray[0];
            model0.selected = 1;
            self.paramModel_schedule.sclassId = model0.sclassId;
            self.paramModel_schedule.sclassKind = model0.sclassKind;
            self.paramModel_schedule.currMatchSeason = model0.currMatchSeason;
            
            self.paramModel_rank.sclassId = model0.sclassId;
            self.paramModel_rank.sclassKind = model0.sclassKind;
            if (model0.sclassKind.integerValue == 2) {
                self.yearView.content = @"";
                self.seasonView.content = @"";
            }
        } else {
        }
        
        self.leagues = self.leagueArray;
        [self.leagueCollectionView reloadData];
        [self QukanLoadSeasons:self.btnType == T_schedule ? self.paramModel_schedule : self.paramModel_rank];
        
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        self.error_msg = error.localizedDescription;
        self.showError_view = self.showEmptyView_schedule = self.showEmptyView_rank = 1;
        [self.scheduleArray removeAllObjects];
        [self.rankArray removeAllObjects];
        [self.scheduleTableView reloadData];
        [self.rankTableView reloadData];
        
    }];
}

#pragma mark ===================== select_season ==================================
- (void)QukanLoadSeasons:(QukanDataBSKParamsModel *)model {
    [self.yearArray removeAllObjects];
    self.paramModel_rank.season = @"";
    self.paramModel_schedule.season = @"";
    KShowHUD
    @weakify(self)
    [[[kApiManager QukanSelectSclassSeasonWith:model.sclassId] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.yearArray = [x mutableCopy];
        self.showError_view = 0;
        if (self.yearArray.count) {
            self.paramModel_schedule.season = self.yearArray.lastObject;
            self.paramModel_rank.season = self.yearArray.lastObject;
            self.yearView.content = model.sclassKind.integerValue == 2 ? @"" : self.yearArray.lastObject;
            if (self.btnType == T_schedule) {
                [self QukanLoadEventTypeWithModel:self.paramModel_schedule];
            } else {
                [self QukanLoadAlliancesWithModel:self.paramModel_rank];
            }
        } else {
            self.showEmptyView_schedule = self.showEmptyView_rank = 1;
            KHideHUD
            self.yearView.content = self.seasonView.content = self.monthView.content = @"";
            [self.scheduleArray removeAllObjects];
            [self.rankArray removeAllObjects];
            self.showEmptyView_rank = 1;
            self.showEmptyView_schedule = 1;
            [self.scheduleTableView reloadData];
            [self.rankTableView reloadData];
            
        }

    } error:^(NSError * _Nullable error) {
        @strongify(self)
        KHideHUD
        [self.scheduleArray removeAllObjects];
        [self.rankArray removeAllObjects];
        self.showError_view = self.showEmptyView_rank = self.showEmptyView_schedule = 1;
        self.error_msg = error.localizedDescription;
        [self.scheduleTableView reloadData];
        [self.rankTableView reloadData];
    }];
}

#pragma mark ===================== select_eventTypes ==================================
- (void)QukanLoadEventTypeWithModel:(QukanDataBSKParamsModel *)model {
    [self.eventTypeArray removeAllObjects];
    self.paramModel_schedule.kindName = @"";
    self.paramModel_schedule.matchKind = @"";
    @weakify(self)
    [[[kApiManager QukanSelectKindWith:model.sclassId season:model.season] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.showError_view = 0;
        for (NSDictionary *dic in x) {
            [self.eventTypeArray addObject:[QukanEventTypeModel modelWithDictionary:dic]];
        }
        if (self.eventTypeArray.count) {
            QukanEventTypeModel *eventTypeModel = self.eventTypeArray.lastObject;
            self.paramModel_schedule.kindName = eventTypeModel.kindName;
            self.paramModel_schedule.matchKind = eventTypeModel.matchKind;
            self.seasonView.content = model.sclassKind.integerValue == 2 ? @"" : eventTypeModel.kindName;
            [self QukanLoadSelectMonthWithModel:self.paramModel_schedule];
        } else {
            self.showEmptyView_schedule = 1;
            KHideHUD
            self.seasonView.content = self.monthView.content = @"";
            [self.scheduleArray removeAllObjects];
            [self.scheduleTableView reloadData];
            
        }
        
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        [self.scheduleArray removeAllObjects];
        self.showEmptyView_schedule = self.showError_view = 1;
        self.error_msg = error.localizedDescription;
        [self.scheduleTableView reloadData];
        KHideHUD
    }];
}

#pragma mark ===================== select_alliances ==================================
- (void)QukanLoadAlliancesWithModel:(QukanDataBSKParamsModel *)model {
    @weakify(self)
    [self.allianceArray removeAllObjects];
    self.paramModel_rank.allianceId = @"";
    self.paramModel_rank.allianceName = @"";
    [[[kApiManager QukanSelectAllianceWith:model.sclassId] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.showError_view = 0;
        for (NSDictionary *dic in x) {
            [self.allianceArray addObject:[QukanDataAllianceModel modelWithDictionary:dic]];
        }
        if (self.allianceArray.count) {
            QukanDataAllianceModel *model = self.allianceArray[0];
            self.paramModel_rank.allianceId = model.allianceId;
            self.paramModel_rank.allianceName = model.allianceName;
            if ([model.allianceName isEqualToString:@"无联盟"]) {
                self.seasonView.content = @"";
            }else{
                self.seasonView.content = self.paramModel_rank.sclassKind.integerValue == 2 ?
                @"" : model.allianceName;
            }
             [self QukanLoadRank:self.paramModel_rank];
        } else {
            self.showEmptyView_rank = 1;
            KHideHUD
            self.paramModel_rank.allianceName = @"";
            [self.rankArray removeAllObjects];
            [self.rankTableView reloadData];
        }
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        [self.rankArray removeAllObjects];
        self.showEmptyView_rank = self.showError_view = 1;
        self.error_msg = error.localizedDescription;
        [self.rankTableView reloadData];
        KHideHUD
    }];
}

#pragma mark ===================== select_months ==================================
- (void)QukanLoadSelectMonthWithModel:(QukanDataBSKParamsModel *)model {
    [self.monthArray removeAllObjects];
    self.paramModel_schedule.month = @"";
    @weakify(self)
    [[[kApiManager QukanSelectMonthsWith:model.sclassId season:model.season matchKind:model.matchKind] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.showError_view = 0;
        for (id obj in x) {
            NSString *num_str = [NSNumberFormatter localizedStringFromNumber:obj numberStyle:NSNumberFormatterNoStyle];
            [self.monthArray addObject:num_str];
        }
        //计算最靠近本月的月份
        float xmin = MAXFLOAT;
        for (NSNumber *num in x) {
            int x = num.intValue;
            int absx = abs(x-[self getCurrentMonth].intValue);
            if (absx == 0) {
                xmin = x;
                break;
            }
            if (absx < xmin) xmin = x;
        }
        NSInteger seasonYeay = 0;
        if (self.btnType == T_schedule) {
            if (self.paramModel_schedule.season.length > 2) {
                seasonYeay = [[self.paramModel_schedule.season substringFromIndex:self.paramModel_schedule.season.length -2] integerValue];
            }
        } else {
            if (self.paramModel_rank.season.length > 2) {
                seasonYeay = [[self.paramModel_rank.season substringFromIndex:self.paramModel_rank.season.length -2] integerValue];
            }
        }
        if (seasonYeay < [self getCurrentYear]) {
            xmin = [self.monthArray.lastObject floatValue];
        }
        if (self.monthArray.count) {
            self.paramModel_schedule.month = FormatString(@"%.0f",xmin);
            self.monthView.content = FormatString(@"%.0f月",xmin);
            [self QukanLoadScheduleWithModel:self.paramModel_schedule];
        } else {
            self.showEmptyView_schedule = 1;
            KHideHUD
            self.monthView.content = @"";
            [self.scheduleArray removeAllObjects];
            [self.scheduleTableView reloadData];
        }
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        [self.scheduleArray removeAllObjects];
        self.showEmptyView_schedule = self.showError_view = 1;
        self.error_msg = error.localizedDescription;
        [self.scheduleTableView reloadData];
        KHideHUD
    }];
}

#pragma mark ===================== select_schedule ==================================
- (void)QukanLoadScheduleWithModel:(QukanDataBSKParamsModel *)paramModel {
    @weakify(self)
    if (!self.scheduleTableView.mj_header.isRefreshing) {
        KShowHUD
    }
    [self.scheduleArray removeAllObjects];
    NSMutableArray *schedules = [NSMutableArray new];
    [[[kApiManager QukanSelectScheduleWith:paramModel.sclassId season:paramModel.season matchKind:paramModel.matchKind month:paramModel.month] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.showError_view = 0;
        NSMutableArray *originArray = [x mutableCopy];
        if (paramModel.sclassKind.integerValue == 2) {
            originArray = [[[originArray reverseObjectEnumerator] allObjects] mutableCopy];
        }
        for (NSDictionary *dic in originArray) {
            [schedules addObject:[QukanBSKDataScheduleModel modelWithDictionary:dic]];
        }
        //dealData ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
        NSMutableArray *dateArray=[NSMutableArray array];
        [schedules enumerateObjectsUsingBlock:^(QukanBSKDataScheduleModel *model, NSUInteger idx, BOOL *stop) {
            if (paramModel.sclassKind.integerValue == 2) {
                if (model.chiCificat.length && [model.cificat isEqualToString:@"小组赛"]) {
                    model.cificat = model.chiCificat;
                }
                [dateArray addObject:model.cificat];
            } else {
                [dateArray addObject:model.matchTime];
            }
        }];
        //数组去重
        NSOrderedSet *orderSet = [NSOrderedSet orderedSetWithArray:dateArray];
        NSMutableArray *sortedDateArray = [[orderSet array] mutableCopy];
        
        NSMutableArray *zuArray = [NSMutableArray new];
        for (NSString *string in sortedDateArray) {
            if ([string containsString:@"组"]) {
                [zuArray addObject:string];
            }
        }
        [sortedDateArray removeObjectsInArray:zuArray];
        NSArray *sortedZuArray = [zuArray sortedArrayUsingSelector:@selector(compare:)];
        NSArray *sZu = [[sortedZuArray reverseObjectEnumerator] allObjects];
        [sortedDateArray addObjectsFromArray:sZu];
        
        NSMutableArray *tempArray = [NSMutableArray array];
        [sortedDateArray enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableArray *arr=[NSMutableArray array];
            [tempArray addObject:arr];
        }];
        [schedules enumerateObjectsUsingBlock:^(QukanBSKDataScheduleModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            for (NSString *str in sortedDateArray) {
                if (paramModel.sclassKind.integerValue == 2) {
                    if([str isEqualToString:model.cificat]) {
                        NSMutableArray *arr=[tempArray objectAtIndex:[sortedDateArray indexOfObject:str]];
                        [arr addObject:model];//是的话就添加到数组里面
                    }
                } else {
                    if([str integerValue] ==[model.matchTime integerValue]) {
                        NSMutableArray *arr=[tempArray objectAtIndex:[sortedDateArray indexOfObject:str]];
                        [arr addObject:model];//是的话就添加到数组里面
                    }
                }
            }
        }];
        //dealData ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
        self.showEmptyView_schedule = 1;
        self.scheduleArray = [tempArray mutableCopy];
        [self.scheduleTableView.mj_header endRefreshing];
        [self.scheduleTableView reloadData];
        if (self.scheduleArray.count) {
            if ([self.paramModel_schedule.currMatchSeason isEqualToString:self.paramModel_schedule.season]) {
                dispatch_after(0.2, dispatch_get_main_queue(), ^{
                    [self QukanLocate];
                });
            }
        }
       
        
        KHideHUD
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        [self.scheduleArray removeAllObjects];
        self.showEmptyView_schedule = self.showEmptyView_schedule = 1;
        self.error_msg = error.localizedDescription;
        [self.scheduleTableView reloadData];
        [self.scheduleTableView.mj_header endRefreshing];
        KHideHUD
    }];
}

- (void)QukanLocate {
    __block BOOL recordIndex = NO;
    [self.scheduleArray enumerateObjectsUsingBlock:^(NSArray *tempArray, NSUInteger section, BOOL * _Nonnull stop) {
        [tempArray enumerateObjectsUsingBlock:^(QukanBSKDataScheduleModel *model, NSUInteger row, BOOL * _Nonnull stop1) {
            if (model.status.integerValue >= 0) {
                recordIndex = YES;
               
                [self.scheduleTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                *stop1 = YES;
                *stop = YES;
                return;
            }
        }];
    }];
    if (recordIndex == NO) {
        [self.scheduleTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        
    }
}

#pragma mark ===================== select_rank ==================================
- (void)QukanLoadRank:(QukanDataBSKParamsModel *)model {
    if (!self.rankTableView.mj_header.isRefreshing) {
        KShowHUD
    }
    [self.rankArray removeAllObjects];
    @weakify(self)
    if (model.sclassKind.integerValue == 2) {
        self.showEmptyView_rank = 1;
        [self.rankTableView reloadData];
        KHideHUD
        return;
    }
    [[[kApiManager QukanSelectBtRankWith:model.sclassId season:model.season allianceId:model.allianceId] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        KHideHUD
        for (NSDictionary *dic in x) {
            if (model.sclassKind.intValue == 1) {
               [self.rankArray addObject:[QukanBSKDataPjModel modelWithDictionary:dic]];
            }
        }
        self.showEmptyView_rank = 1;
        [self.rankTableView reloadData];
        [self.rankTableView.mj_header endRefreshing];
    } error:^(NSError * _Nullable error) {
        KHideHUD
        @strongify(self)
        self.showEmptyView_rank = self.showError_view = 1;
        self.error_msg = error.localizedDescription;
        [self.rankArray removeAllObjects];
        [self.rankTableView reloadData];
        [self.rankTableView.mj_header endRefreshing];
    }];
}

#pragma mark ===================== JXCategoryListContentViewDelegate ==================================
- (UIView *)listView {
    return self.view;
}



#pragma mark ===================== tab delegate ==================================
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.scheduleTableView) {
        return 25;
    } else {
        return 0.01;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self.scheduleTableView) {
        UIView *view = [UIView new];
        view.backgroundColor = HEXColor(0x333D46);
        UIBezierPath *polygonPath = [UIBezierPath bezierPath];
        [polygonPath moveToPoint:CGPointMake(0, 0)];
        [polygonPath addLineToPoint:CGPointMake(122, 0)];
        [polygonPath addLineToPoint:CGPointMake(112, 25)];
        [polygonPath addLineToPoint:CGPointMake(0, 25)];
        [polygonPath closePath];
        CAShapeLayer *polygonLayer = [CAShapeLayer layer];
        polygonLayer.strokeColor = HEXColor(0x27313C).CGColor;
        polygonLayer.path = polygonPath.CGPath;
        polygonLayer.fillColor = HEXColor(0x27313C).CGColor; // 默认为blackColor
        [view.layer addSublayer:polygonLayer];
        UILabel *label = [UILabel new];
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(6);
            make.height.offset(14);
            make.left.offset(15);
        }];
        label.textColor = kCommonWhiteColor;
        label.font = kFont10;
        NSArray *array = self.scheduleArray[section];
        
        UILabel *matchTypeLab = [UILabel new];
        [view addSubview:matchTypeLab];
        [matchTypeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-15);
            make.centerY.offset(0);
            make.height.offset(14);
        }];
        matchTypeLab.textAlignment = NSTextAlignmentRight;
        matchTypeLab.textColor = kCommonWhiteColor;
        matchTypeLab.font = kFont12;
        if (array.count) {
            QukanBSKDataScheduleModel *model = array[0];
            NSString *str1 = [model.matchTime substringToIndex:4];
            NSString *str2 = [[model.matchTime substringFromIndex:4] substringToIndex:2];
            NSString *str3 = [model.matchTime substringFromIndex:6];
            NSString *dateString = FormatString(@"%@-%@-%@",str1,str2,str3);
            NSString *weekString = [model weekDayStr:dateString];
            label.text = FormatString(@"%@   %@",dateString,weekString);
            matchTypeLab.text = model.cificat;
        }
        return view;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.scheduleTableView) {
        NSArray *array = self.scheduleArray[section];
        return array.count;;
    } else {
        return self.rankArray.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.scheduleTableView) {
        return self.scheduleArray.count;
    } else {
        return 1;
    };
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.scheduleTableView) {
        QukanBSKDataScheduleModel *scheduleM = self.scheduleArray[indexPath.section][indexPath.row];
        QukanBasketDetailVC *vc = [QukanBasketDetailVC new];
        vc.hidesBottomBarWhenPushed = 1;
        vc.matchId = scheduleM.matchId;
        
        // 每次进入详情界面时断开连接
        [[QukanIMChatManager sharedInstance] logOutChat:^(NSError * _Nullable error) {
        }];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        QukanBSKDataPjModel *rankM = self.rankArray[indexPath.row];
        QukanBSKTeamDetialViewController *vc = [QukanBSKTeamDetialViewController new];
        vc.hidesBottomBarWhenPushed = 1;
        vc.teamId = rankM.teamId;
        if (self.paramModel_rank.sclassKind.integerValue == 1) {
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.scheduleTableView) {
        QukanBSKDataScheduleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QukanDataScheduleCell"];
        [cell setModel:self.scheduleArray[indexPath.section][indexPath.row]];
        cell.selectionStyle = 0;
        return cell;
    } else {
        QukanBSKDataPjCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QukanDataPjCell"];
        cell.model = self.rankArray[indexPath.row];
        cell.contentView.backgroundColor = indexPath.row < 8 ? HEXColor(0x005F4E) : HEXColor(0x31373C);
        cell.selectionStyle = 0;
        return cell;
    }
}

#pragma mark ===================== collectionView delegate ==================================
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QukanBSKDataLeagueCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QukanDataLeagueCell" forIndexPath:indexPath];
    cell.model = self.leagueArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = 0;
    for (int i = 0;i < self.leagueArray.count;i++) {
        QukanBtSclassHotModel *model = self.leagueArray[i];
        if (model.selected == 1) {
            index = i;
        }
    }
    if (indexPath.row == index) {
        return;
    }
    for (int i = 0;i< self.leagueArray.count; i++) {
        QukanBtSclassHotModel *model = self.leagueArray[i];
        model.selected = i == indexPath.row ? 1 : 0;
        index = indexPath.row;
        
    }
    QukanBtSclassHotModel *selectModel = self.leagues[indexPath.row];
    self.paramModel_schedule.sclassId = selectModel.sclassId;
    self.paramModel_schedule.sclassKind = selectModel.sclassKind;
    self.paramModel_rank.sclassId = selectModel.sclassId;
    self.paramModel_rank.sclassKind = selectModel.sclassKind;
    [self QukanLoadSeasons:self.btnType == T_schedule ? self.paramModel_schedule : self.paramModel_rank];
    if (selectModel.sclassKind.integerValue == 2) {
        self.yearView.content = @"";
        self.seasonView.content = @"";
    }
    [self.leagueCollectionView reloadData];
    
    [MMPickerView dismissWithCompletion:nil];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.leagueArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    QukanBtSclassHotModel *model = self.leagueArray[indexPath.row];
    CGFloat width=[(NSString *)model.xshort boundingRectWithSize:CGSizeMake(1000, 22) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.width;
    return CGSizeMake(width+20, 40);
    
}

#pragma mark ===================== DZNEmptyDataSetSource ==================================
// 占位图提示文本
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *description = !self.showError_view ? @"暂无数据" : self.error_msg;
    return [[NSAttributedString alloc] initWithString:description attributes:@{NSFontAttributeName : kFont16,NSForegroundColorAttributeName : [UIColor grayColor]}];
}

- (void)emptyDataSetWillAppear:(UIScrollView *)scrollView {
    if (scrollView == self.scheduleTableView) {
        [self.scheduleTableView setContentOffset:CGPointMake(0, 0)];
    } else {
        
    }
}
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    [self QukanLoadLeagues];
}
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    if (scrollView == self.scheduleTableView) {
        return self.showEmptyView_schedule;
    } else {
        return self.showEmptyView_rank;
    }
}

#pragma mark ===================== lazy ==================================
- (UIScrollView *)mScrollView {
    if (!_mScrollView) {
        _mScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 89, kScreenWidth, kScreenHeight-89-kBottomBarHeight - (isIPhoneXSeries() ? 88 : 64))];
        _mScrollView.scrollEnabled = 0;
        _mScrollView.contentSize = CGSizeMake(kScreenWidth * 2, 0);
    }
    return _mScrollView;
}

- (UICollectionView *)leagueCollectionView {
    if (!_leagueCollectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 12);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _leagueCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _leagueCollectionView.delegate = self;
        _leagueCollectionView.dataSource = self;
        _leagueCollectionView.backgroundColor = kCommonWhiteColor;
        [_leagueCollectionView registerClass:[QukanBSKDataLeagueCell class] forCellWithReuseIdentifier:@"QukanDataLeagueCell"];
    }
    return _leagueCollectionView;
}

- (NSMutableArray *)eventTypeArray {
    if (!_eventTypeArray) {
        _eventTypeArray = [NSMutableArray new];
    }
    return _eventTypeArray;
}

- (NSMutableArray *)allianceArray {
    if (!_allianceArray) {
        _allianceArray = [NSMutableArray new];
    }
    return _allianceArray;
}

- (NSMutableArray *)leagueArray {
    if (!_leagueArray) {
        _leagueArray = [NSMutableArray new];
    }
    return _leagueArray;
}

- (UITableView *)scheduleTableView {
    if (!_scheduleTableView) {
        _scheduleTableView = [UITableView new];
        _scheduleTableView.showsVerticalScrollIndicator = 0;
        _scheduleTableView.separatorStyle = 0;
        _scheduleTableView.delegate = self;
        _scheduleTableView.dataSource = self;
        _scheduleTableView.estimatedRowHeight = 0;
        _scheduleTableView.estimatedSectionFooterHeight = 0;
        _scheduleTableView.estimatedSectionHeaderHeight = 0;
        _scheduleTableView.emptyDataSetDelegate = self;
        _scheduleTableView.emptyDataSetSource = self;
        _scheduleTableView.backgroundColor = HEXColor(0x333D46);
        [_scheduleTableView registerClass:[QukanBSKDataScheduleCell class] forCellReuseIdentifier:@"QukanDataScheduleCell"];
    }
    return _scheduleTableView;
}

- (UITableView *)rankTableView {
    if (!_rankTableView) {
        _rankTableView = [UITableView new];
        _rankTableView.showsVerticalScrollIndicator = 0;
        _rankTableView.separatorStyle = 0;
        _rankTableView.delegate = self;
        _rankTableView.dataSource = self;
        _rankTableView.emptyDataSetSource = self;
        _rankTableView.emptyDataSetDelegate = self;
        _rankTableView.backgroundColor = HEXColor(0x333D46);
        [_rankTableView registerClass:[QukanBSKDataPjCell class] forCellReuseIdentifier:@"QukanDataPjCell"];
    }
    return _rankTableView;
}

- (QukanDataBSKParamsModel *)paramModel_schedule {
    if (!_paramModel_schedule) {
        _paramModel_schedule = [QukanDataBSKParamsModel new];
    }
    return _paramModel_schedule;
}

- (QukanDataBSKParamsModel *)paramModel_rank {
    if (!_paramModel_rank) {
        _paramModel_rank = [QukanDataBSKParamsModel new];
    }
    return _paramModel_rank;
}

- (NSMutableArray *)yearArray {
    if (!_yearArray) {
        _yearArray = [NSMutableArray new];
    }
    return _yearArray;
}

- (NSMutableArray *)monthArray {
    if (!_monthArray) {
        _monthArray = [NSMutableArray new];
    }
    return _monthArray;
}

- (NSMutableArray *)scheduleArray {
    if (!_scheduleArray) {
        _scheduleArray = [NSMutableArray new];
    }
    return _scheduleArray;
}

- (NSMutableArray *)rankArray {
    if (!_rankArray) {
        _rankArray = [NSMutableArray new];
    }
    return _rankArray;
}

- (UIView *)scheduleTopView {
    if (!_scheduleTopView) {
        _scheduleTopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        _scheduleTopView.backgroundColor = HEXColor(0x21282D);
    }
    return _scheduleTopView;
}

- (UIView *)rankTopView {
    if (!_rankTopView) {
        _rankTopView = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, 30)];
        _rankTopView.backgroundColor = HEXColor(0x21282D);
    }
    return _rankTopView;
}

- (UIButton *)customizeButton {
    if (!_customizeButton) {
        _customizeButton = [UIButton new];
        _customizeButton.backgroundColor = kCommonWhiteColor;
        [_customizeButton setImage:kImageNamed(@"kqds_data_tab_more_nor") forState:UIControlStateNormal];
        _customizeButton.tag = T_customize;
        _customizeButton.hidden = 1;
    }
    return _customizeButton;
}

#pragma mark ===================== corners ==================================
- (void)applyRoundCorners:(UIRectCorner)corners radius:(CGFloat)radius view:(UIView *)view
{
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    
    CAShapeLayer *temp = [CAShapeLayer layer];
    temp.lineWidth = 1.f;
    temp.fillColor = [UIColor clearColor].CGColor;
    temp.strokeColor = HEXColor(0x1B2227).CGColor;
    temp.frame = view.bounds;
    temp.path = path.CGPath;
    [view.layer addSublayer:temp];
    
    CAShapeLayer *mask = [[CAShapeLayer alloc]initWithLayer:temp];
    mask.path = path.CGPath;
    view.layer.mask = mask;
}

#pragma mark ===================== getCurrentMonth ==================================
- (NSString *)getCurrentMonth {
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | //年
    NSCalendarUnitMonth | //月份
    NSCalendarUnitDay | //日
    NSCalendarUnitHour |  //小时
    NSCalendarUnitMinute |  //分钟
    NSCalendarUnitSecond;  // 秒
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:nowDate];
    NSInteger month = [dateComponent month];
    return FormatString(@"%ld",month);
}

#pragma mark ===================== getCurrentYear ==================================
- (NSInteger)getCurrentYear {
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | //年
    NSCalendarUnitMonth | //月份
    NSCalendarUnitDay | //日
    NSCalendarUnitHour |  //小时
    NSCalendarUnitMinute |  //分钟
    NSCalendarUnitSecond;  // 秒
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:nowDate];
    NSInteger year = [dateComponent year];
    NSString *yearString = FormatString(@"%ld",year);
    NSString *lastTwoStringOfYear = [yearString substringFromIndex:yearString.length - 2];
    return [lastTwoStringOfYear integerValue];
}
@end
