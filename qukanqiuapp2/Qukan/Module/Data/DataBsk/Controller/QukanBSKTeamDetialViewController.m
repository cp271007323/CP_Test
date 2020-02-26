//
//  QukanBSKTeamDetialViewController.m
//  Qukan
//
//  Created by blank on 2019/12/26.
//  Copyright © 2019 mac. All rights reserved.
//
#define Tag_Seg 0x11
#import "QukanBSKTeamDetialViewController.h"
#import <UIViewController+HBD.h>
#import "QukanBSKDetailScheduleCell.h"
#import "QukanBSKDetailPlayerCell.h"
#import "QukanBSKDetailInfoCell.h"
#import "QukanApiManager+QukanDataBSK.h"
#import "QukanBSKMemberInfoViewController.h"
#import "QukanBasketDetailVC.h"
#import "QukanLocalNotification.h"

#import "QukanUIViewController+Ext.h"
#import "QukanBasketDetailVC.h"
#import "QukanBasketTool.h"

@interface QukanBSKTeamDetialViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong)UIButton *focusBtn;
@property (nonatomic, strong)UIImageView *teamIcon;
@property (nonatomic, strong)UILabel *teamName;
@property (nonatomic, strong)UILabel *rank;
@property (nonatomic, strong)UILabel *rankName;
@property (nonatomic, strong)UILabel *win;
@property (nonatomic, strong)UILabel *winName;
@property (nonatomic, strong)UIView *segmentLine;
@property (nonatomic, strong)UIScrollView *mScrollView;
@property (nonatomic, strong)UITableView *scheduleTableView;
@property (nonatomic, strong)UITableView *playerTableView;
@property (nonatomic, strong)UITableView *infoTableView;
@property (nonatomic, strong)QukanBSKDataTeamDetailModel *teamDetailModel;
@property (nonatomic, assign)BOOL showEmpty_schedule;
@property (nonatomic, assign)BOOL showEmpty_player;

@property(nonatomic,strong) NSMutableArray< NSMutableDictionary<NSString*,NSMutableArray*>*>* totalArray;
@property(nonatomic, strong) NSIndexPath *showIndexPath;

@property (nonatomic, assign)BOOL showCoach;

@property (nonatomic, assign)BOOL showError_view;
@property (nonatomic, strong)NSString *error_msg;
@end

@implementation QukanBSKTeamDetialViewController
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.hbd_barHidden = 1;
    self.view.backgroundColor = kTableViewCommonBackgroudColor;
    [self QukanInitTopView];
    [self QukanInitTab];
    [self QukanLoadTeamDetail];
//    [self QukanLoadAttentionStatus];
    [self QukanLoadSchedule];
    
    @weakify(self)
    [[[kNotificationCenter rac_addObserverForName:kUserDidLoginNotification object:nil]
      takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        [self QukanLoadSchedule];
    }];
    
}
- (void)QukanInitTopView {
    UIView *topBackView = [UIView new];
    [self.view addSubview:topBackView];
    [topBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
        make.height.offset(295);
    }];
    topBackView.backgroundColor = HEXColor(0x6A0832);
    
    UIImageView *igv = [UIImageView new];
    [topBackView addSubview:igv];
    [igv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(kStatusBarHeight + 8);
        make.width.offset(11);
        make.height.offset(18);
    }];
    igv.image = kImageNamed(@"返回_白色");
    igv.userInteractionEnabled = 1;
    
    UIButton *backBtn = [UIButton new];
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.offset(20);
        make.width.offset(64);
        make.height.offset(64);
    }];
    [backBtn addTarget:self action:@selector(QukanBackClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    [topBackView addSubview:self.teamIcon];
    [topBackView addSubview:self.teamName];
    [topBackView addSubview:self.rank];
    [topBackView addSubview:self.rankName];
    [topBackView addSubview:self.win];
    [topBackView addSubview:self.winName];
    [self.teamIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.offset(kStatusBarHeight + 49);
        make.width.height.offset(50);
    }];
    [self.teamName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.mas_equalTo(self.teamIcon.mas_bottom).offset(4);
        make.height.offset(20);
    }];
    [self.rank mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.teamName.mas_bottom).offset(31);
        make.left.offset(30);
        make.width.offset(kScreenWidth/2-30);
        make.height.offset(20);
    }];
    [self.rankName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.top.mas_equalTo(self.rank.mas_bottom).offset(1);
        make.height.offset(16);
        make.width.offset(kScreenWidth/2-30);
    }];
    [self.win mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-30);
        make.height.offset(20);
        make.top.mas_equalTo(self.teamName.mas_bottom).offset(31);
        make.width.offset(kScreenWidth/2-30);
    }];
    [self.winName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-30);
        make.height.offset(16);
        make.top.mas_equalTo(self.win.mas_bottom).offset(1);
        make.width.offset(kScreenWidth/2-30);
    }];
    UIView *verticleLine = [UIView new];
    [topBackView addSubview:verticleLine];
    [verticleLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.teamName.mas_bottom).offset(39);
        make.height.offset(22);
        make.width.offset(1);
        make.centerX.offset(0);
    }];
    verticleLine.backgroundColor = kCommonWhiteColor;
    
    UIView *segmentView = [UIView new];
    [topBackView addSubview:segmentView];
    [segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.offset(46);
    }];
    segmentView.backgroundColor = COLOR_HEX(0x000000, 0.1);
    
    CGFloat width = 60;
    CGFloat blank = (kScreenWidth - 30 - 180)/2;
    NSArray *titles = @[@"赛程",@"球员",@"资料"];
    for (int i = 0;i < titles.count;i++) {
        UIButton *btn = [UIButton new];
        [segmentView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15 + i *(width + blank));
            make.width.offset(width);
            make.top.bottom.offset(0);
        }];
        btn.tag = Tag_Seg + i;
        btn.selected = i == 0 ? 1 : 0;
        [btn addTarget:self action:@selector(QukanSegmentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        [btn setTitleColor:HEXColor(0xB5B5B5) forState:UIControlStateNormal];
        [btn setTitleColor:kThemeColor forState:UIControlStateSelected];
    }
    [segmentView addSubview:self.segmentLine];
    self.segmentLine.frame = CGRectMake(15, 42, width, 4);
}


- (void)QukanInitTab {
    [self.view addSubview:self.mScrollView];
    self.mScrollView.frame = CGRectMake(0, 295, kScreenWidth, kScreenHeight - 295);
    [self.mScrollView addSubview:self.scheduleTableView];
    [self.mScrollView addSubview:self.playerTableView];
    [self.mScrollView addSubview:self.infoTableView];
    self.scheduleTableView.frame = CGRectMake(0, 0, kScreenWidth, self.mScrollView.height);
    self.playerTableView.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, self.mScrollView.height);
    self.infoTableView.frame = CGRectMake(kScreenWidth * 2, 0, kScreenWidth, self.mScrollView.height);
    self.scheduleTableView.mj_header = [QukanHomeRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(QukanLoadSchedule)];

}
- (void)QukanSetTopData {
    [self.teamIcon sd_setImageWithURL:[NSURL URLWithString:self.teamDetailModel.logo] placeholderImage:kImageNamed(@"Qukan_bsk_team")];
    self.teamName.text = self.teamDetailModel.gb.length ? self.teamDetailModel.gb : @"--";
    self.win.text = self.teamDetailModel.near10Win.length ? FormatString(@"%ld%%",self.teamDetailModel.near10Win.integerValue * 10) : @"--";
    self.rankName.text = self.teamDetailModel.league.length ? self.teamDetailModel.league : @"--";
    self.rank.text = self.teamDetailModel.totalOrder.length ? self.teamDetailModel.totalOrder : @"--";
    self.winName.text = self.teamDetailModel.near10Win.length ? @"近10场胜率" : @"--";
}
- (void)QukanLoadTeamDetail {
    @weakify(self)
    [[[kApiManager QukanSelectTeamDetailWith:self.teamId] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.showError_view = 0;
        self.teamDetailModel = [QukanBSKDataTeamDetailModel modelWithDictionary:x];
        if (self.teamDetailModel.introduce.length == 0) {
            self.teamDetailModel.introduce = @"暂无介绍";
        }
        if (self.teamDetailModel.playerList.count) {
            QukanPlayerList *playerM = self.teamDetailModel.playerList[0];
            self.showCoach = [playerM.place containsString:@"教练"];
        }
        [self.infoTableView reloadData];
        self.showEmpty_player = 1;
        [self.playerTableView reloadData];
        [self QukanSetTopData];
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        self.showEmpty_player = self.showError_view = 1;
        self.error_msg = error.localizedDescription;
        [self.playerTableView reloadData];
    }];
}

- (void)QukanLoadSchedule {
    if (!self.totalArray.count) {
            if (!self.scheduleTableView.mj_header.isRefreshing) {
                KShowHUD
            }
        }
        @weakify(self)
        [self.totalArray removeAllObjects];
        [[[kApiManager QukanSelectScheduleTeamWith:self.teamId] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
             KHideHUD
            @strongify(self)
            self.showError_view = 0;
            NSMutableArray *arrs = [NSMutableArray array];
            for (NSDictionary *dic in x) {
                [arrs addObject:[QukanSelectScheduleTeamModel modelWithDictionary:dic]];
    //            [self.schedules addObject:[QukanSelectScheduleTeamModel modelWithDictionary:dic]];
            }
            
            
            NSInteger section = 0;
            NSInteger row = 0;
            NSMutableArray< NSMutableDictionary<NSString*, NSMutableArray*>*>* totalDatas = [NSMutableArray new];
            for(QukanSelectScheduleTeamModel* model in arrs){
                if (model.matchTime.length < 6) {
                    return;
                }
                NSString* time = FormatString(@"%@年%@月",[model.matchTime substringToIndex:4], [model.matchTime substringWithRange:NSMakeRange(4, 2)] );
                
                
                NSMutableDictionary<NSString*, NSMutableArray*>*lastDic = totalDatas.lastObject;
                NSString*key = lastDic.allKeys.lastObject;
                NSMutableArray* sectionArray;
                if([key isEqualToString:time]){
                    sectionArray = lastDic[time];
                    [sectionArray addObject:model];
                }else{
                    sectionArray = [NSMutableArray new];
                    [sectionArray addObject:model];
                    NSMutableDictionary* dic = @{time:sectionArray}.mutableCopy;
                    [totalDatas addObject:dic];
                }
                
                if(model.status.intValue > 0){//当前进行的
                    section = [totalDatas indexOfObject:lastDic];
                    row = [sectionArray indexOfObject:model];
                    self.showIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
                }
            }
            self.totalArray = totalDatas;
            
            self.showEmpty_schedule = 1;
            [self.scheduleTableView.mj_header endRefreshing];
            [self.scheduleTableView reloadData];

             dispatch_after(0.3, dispatch_get_main_queue(), ^{
                    [self locateToPresent];
            });
           
        } error:^(NSError * _Nullable error) {
            KHideHUD
            @strongify(self)
            [self.totalArray removeAllObjects];
            self.showEmpty_schedule = self.showError_view = 1;
            self.error_msg = error.localizedDescription;
            [self.scheduleTableView reloadData];
            [self.scheduleTableView.mj_header endRefreshing];
        }];
}

- (void)locateToPresent {
    if (self.totalArray.count <= 0){
        return;
    }
    NSInteger section = 0;
    NSInteger row = 0;
    for(int i=0; i < self.totalArray.count && (section + row) == 0; i++){
        NSMutableDictionary<NSString*,NSMutableArray*>* dic = self.totalArray[i];
        NSArray* sectionDatas = dic.allValues.lastObject;
        for(QukanSelectScheduleTeamModel* model in sectionDatas){
            if (model.status.integerValue >= 0) {
                section = i;
                row = [sectionDatas indexOfObject:model];
                break;
            }
        }
    }
    [self.scheduleTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (void)QukanSegmentBtnClick:(UIButton *)sender {
    NSArray *btns = @[(UIButton *)[self.view viewWithTag:Tag_Seg],(UIButton *)[self.view viewWithTag:Tag_Seg + 1],(UIButton *)[self.view viewWithTag:Tag_Seg + 2]];
    for (UIButton *btn in btns) {
        btn.selected = 0;
    }
    sender.selected = 1;
    [self.mScrollView setContentOffset:CGPointMake(kScreenWidth * (sender.tag -Tag_Seg), 0) animated:YES];
    UITableView *tableView = nil;
    tableView = sender.tag == Tag_Seg ? self.scheduleTableView : sender.tag == Tag_Seg+ 1 ? self.playerTableView :self.infoTableView;
    [tableView reloadData];
 
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat width = 60;
    CGFloat blank = (kScreenWidth - 30 - 180)/2;
    int i = self.mScrollView.contentOffset.x/kScreenWidth;
    
    NSArray *btns = @[(UIButton *)[self.view viewWithTag:Tag_Seg],(UIButton *)[self.view viewWithTag:Tag_Seg + 1],(UIButton *)[self.view viewWithTag:Tag_Seg + 2]];
    for (UIButton *btn in btns) {
        btn.selected = btn.tag == i + Tag_Seg ? 1 : 0;
    }
    self.segmentLine.frame = CGRectMake(15+self.mScrollView.contentOffset.x/kScreenWidth * (blank + width), 42, width, 4);
}
- (void)QukanBackClick {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark ===================== tab delegate ==================================

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.scheduleTableView) {
        return 50;
    } else if (tableView == self.playerTableView) {
        return 60;
    } else {
        return 320 + [self.teamDetailModel caculateHeight];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.scheduleTableView) {
        NSDictionary* dic = self.totalArray[section];
        NSString* key = dic.allKeys.lastObject;
        NSArray* array = dic[key];
        return array.count;
        
    } else if (tableView == self.playerTableView) {
        if (section == 0) {
            return self.showCoach ? 1 : 0;
        } else {
            return self.showCoach ? self.teamDetailModel.playerList.count - 1 : self.teamDetailModel.playerList.count;
        }
    } else {
        return 1;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.scheduleTableView) {
        return self.totalArray.count;
    } else if (tableView == self.playerTableView) {
        return self.teamDetailModel.playerList.count ? 2 : 0;
    } else {
        return 1;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self.scheduleTableView) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 35)];
        NSDictionary*dic = self.totalArray[section];
        NSString*key = dic.allKeys.lastObject;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = key;
        label.textColor = kCommonTextColor;
        label.font = kFont14;
        label.backgroundColor = HEXColor(0xE9E9E9);
        return label;
    } else if (tableView == self.playerTableView) {
        UIView *view = [UIView new];
        view.backgroundColor = HEXColor(0xECECEC);
        UILabel *leftLab = [UILabel new];
        [view addSubview:leftLab];
        [leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(14);
            make.height.offset(17);
            make.centerY.offset(0);
        }];
        leftLab.text = section == 0 ? @"教练":@"球员";
        leftLab.font = kFont12;
        leftLab.textColor = kCommonTextColor;
        CGFloat leftMargin = 170;
        CGFloat width =( kScreenWidth - 170 -14)/4;
        NSArray *titles = @[@"位置",@"身高(CM)",@"体重(KG)",@"年薪(美元)"];
        for (int i = 0;i < titles.count;i++) {
            UILabel *lab = [UILabel new];
            [view addSubview:lab];
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(leftMargin + i * width);
                make.width.offset(width);
                make.top.bottom.offset(0);
            }];
            lab.textColor = kTextGrayColor;
            lab.font = kFont10;
            lab.textAlignment = NSTextAlignmentCenter;
            lab.text = section == 0 ? @"" : titles[i];
        }
        return view;
    } else return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return tableView == self.scheduleTableView ? 40 : (tableView == self.playerTableView ? (section == 0 ? (self.showCoach ? 35 : 0) : 35) : 0.01);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.scheduleTableView) {
        QukanBSKDetailScheduleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QukanBSKDetailScheduleCell"];
        cell.teamId = self.teamId;
        NSDictionary* dic = self.totalArray[indexPath.section];
        NSString* key = dic.allKeys.lastObject;
        NSArray* array = dic[key];
        cell.model = array[indexPath.row];
        cell.selectionStyle = 0;
        return cell;
    } else if (tableView == self.playerTableView){
        QukanBSKDetailPlayerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QukanBSKDetailPlayerCell"];
        cell.selectionStyle = 0;
        if (indexPath.section == 0) {
            cell.model = self.teamDetailModel.playerList[0];
            [cell setRightLabsHidden:YES];
        } else {
            NSInteger index = self.showCoach ? indexPath.row + 1 : indexPath.row;
            cell.model = self.teamDetailModel.playerList[index];
            [cell setRightLabsHidden:NO];
        }
        return cell;
    } else {
        QukanBSKDetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QukanBSKDetailInfoCell"];
        cell.model = self.teamDetailModel;
        cell.selectionStyle = 0;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.playerTableView) {
        if (indexPath.section == 0) {
            return;
        }
        NSInteger index = self.showCoach ? indexPath.row + 1: indexPath.row;
        QukanPlayerList *model = self.teamDetailModel.playerList[index];
        QukanBSKMemberInfoViewController *vc = [QukanBSKMemberInfoViewController new];
        vc.playerTeam = self.teamDetailModel.gb;
        vc.pid = model.playerId;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (tableView == self.scheduleTableView){
        NSDictionary* dic = self.totalArray[indexPath.section];
        NSString* key = dic.allKeys.lastObject;
        NSArray* array = dic[key];
        QukanSelectScheduleTeamModel *model = array[indexPath.row];
        
        UIViewController *avc = [self findDesignatedViewController:[QukanBasketDetailVC class]];
        QukanBasketMatchState state = [QukanBasketTool getStateForMathStatus:model.status.integerValue];
        [[QukanIMChatManager sharedInstance] logOutChat:^(NSError * _Nullable error) {
            
        }];
        if (avc && state == QukanBasketMatching) {
            [self.navigationController popToViewController:avc animated:YES];
        }else {
            UINavigationController *nav = self.navigationController;
//            [self.navigationController popToRootViewControllerAnimated:NO];
            QukanBasketDetailVC *vc = [QukanBasketDetailVC new];
            vc.matchId = model.matchId;
            vc.hidesBottomBarWhenPushed = YES;
            [nav pushViewController:vc animated:YES];
        }
    }
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
// 占位图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *imageName = @"Qukan_Null_Data";
    return [UIImage imageNamed:imageName];
}
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return YES;
//    if (scrollView == self.scheduleTableView) {
//        return self.showEmpty_schedule;
//    } else if (scrollView == self.playerTableView){
//        return self.showEmpty_player;
//    } else return NO;
}
- (UIImageView *)teamIcon {
    if (!_teamIcon) {
        _teamIcon = [UIImageView new];
        _teamIcon.contentMode = UIViewContentModeScaleAspectFit;
        _teamIcon.image = kImageNamed(@"Qukan_BSK");
    }
    return _teamIcon;
}
- (UILabel *)teamName {
    if (!_teamName) {
        _teamName = [UILabel new];
        _teamName.textAlignment = NSTextAlignmentCenter;
        _teamName.textColor = kCommonWhiteColor;
        _teamName.font = kFont14;
    }
    return _teamName;
}
- (UILabel *)rank {
    if (!_rank) {
        _rank = [UILabel new];
        _rank.textAlignment = NSTextAlignmentCenter;
        _rank.textColor = kCommonWhiteColor;
        _rank.font = kFont14;
    }
    return _rank;
}
- (UILabel *)rankName {
    if (!_rankName) {
        _rankName = [UILabel new];
        _rankName.textAlignment = NSTextAlignmentCenter;
        _rankName.textColor = kCommonWhiteColor;
        _rankName.font = kFont11;
    }
    return _rankName;
}
- (UILabel *)win {
    if (!_win) {
        _win = [UILabel new];
        _win.textAlignment = NSTextAlignmentCenter;
        _win.textColor = kCommonWhiteColor;
        _win.font = kFont14;
    }
    return _win;
}
- (UILabel *)winName {
    if (!_winName) {
        _winName = [UILabel new];
        _winName.textAlignment = NSTextAlignmentCenter;
        _winName.textColor = kCommonWhiteColor;
        _winName.font = kFont11;
        
    }
    return _winName;
}
- (UIScrollView *)mScrollView {
    if (!_mScrollView) {
        _mScrollView = [UIScrollView new];
        _mScrollView.contentSize = CGSizeMake(kScreenWidth * 3, 0);
        _mScrollView.pagingEnabled = 1;
        _mScrollView.backgroundColor = kTableViewCommonBackgroudColor;
        _mScrollView.delegate = self;
    }
    return _mScrollView;
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
        _scheduleTableView.backgroundColor = kTableViewCommonBackgroudColor;
        _scheduleTableView.emptyDataSetDelegate = self;
        _scheduleTableView.emptyDataSetSource = self;
        [_scheduleTableView registerClass:[QukanBSKDetailScheduleCell class] forCellReuseIdentifier:@"QukanBSKDetailScheduleCell"];
    }
    return _scheduleTableView;
}
- (UITableView *)playerTableView {
    if (!_playerTableView) {
        _playerTableView = [UITableView new];
        _playerTableView.showsVerticalScrollIndicator = 0;
        _playerTableView.separatorStyle = 0;
        _playerTableView.delegate = self;
        _playerTableView.dataSource = self;
        _playerTableView.emptyDataSetDelegate = self;
        _playerTableView.emptyDataSetSource = self;
        _playerTableView.backgroundColor = kTableViewCommonBackgroudColor;
        [_playerTableView registerClass:[QukanBSKDetailPlayerCell class] forCellReuseIdentifier:@"QukanBSKDetailPlayerCell"];
    }
    return _playerTableView;
}
- (UITableView *)infoTableView {
    if (!_infoTableView) {
        _infoTableView = [UITableView new];
        _infoTableView.showsVerticalScrollIndicator = 0;
        _infoTableView.separatorStyle = 0;
        _infoTableView.delegate = self;
        _infoTableView.dataSource = self;
        _infoTableView.backgroundColor = kTableViewCommonBackgroudColor;
        [_infoTableView registerClass:[QukanBSKDetailInfoCell class] forCellReuseIdentifier:@"QukanBSKDetailInfoCell"];
    }
    return _infoTableView;
}

- (UIView *)segmentLine {
    if (!_segmentLine) {
        _segmentLine = [UIView new];
        _segmentLine.backgroundColor = kThemeColor;
    }
    return _segmentLine;
}
- (QukanBSKDataTeamDetailModel *)teamDetailModel {
    if (!_teamDetailModel) {
        _teamDetailModel = [QukanBSKDataTeamDetailModel new];
    }
    return _teamDetailModel;
}
@end
