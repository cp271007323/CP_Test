//
//  QukanAnalysisListVC.m
//  Qukan
//
//  Created by Charlie on 2019/12/25.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanAnalysisListVC.h"
#import <HBDNavigationBar/HBDNavigationController.h>
#import "MMPickerView.h"
#import "QukanApiManager+FTAnalysis.h"

#import "QukanTeamScoreHeader.h"
#import "QukanTeamScoreCell.h"

#import "QukanMemberCell.h"
#import "QukanMemberHeader.h"
#import "QukanScheduleCell.h"
#import "QukanScheduleHeader.h"

#import "QukanTeamDetailVC.h"
#import "QukanFTPlayerDetailVC.h"
#import "QukanCupMatchCell.h"

#import "QukanDetailsViewController.h"
#import "QukanMatchInfoModel.h"

typedef NS_OPTIONS(NSUInteger, ShowInfoType) {
    MatchType_ScheduleAndGroup,
    MatchType_OnlySchedule,
    MatchType_OnlyGroup,
    MatchType_None
};

@interface QukanAnalysisListVC ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property(nonatomic, strong)NSMutableArray<NSMutableArray*>* dataSource; //3种类别的数据

@property (nonatomic, strong)UIScrollView *mScrollView;
@property (nonatomic, strong)UITableView *rankTableView;
@property (nonatomic, strong)UITableView *playerTableView;
@property (nonatomic, strong)UITableView *scheduleTableView;

@property(nonatomic, weak)UITableView* curTableView;

@property(nonatomic, strong)NSArray* cellClassNames;

@property(nonatomic, strong) UIButton *chooseSeasonBtn;
@property(nonatomic, strong) UISegmentedControl *showTypeSegmentControl;

@property(assign,nonatomic) NSInteger type; // 0-积分 1-射手 2-赛程
@property(strong,nonatomic) NSString* curSeason; // 赛季

@property(assign,nonatomic) NSInteger playerPageIndex;

@property(nonatomic, strong)QukanLeagueInfoModel* infoModel;

@property(nonatomic, strong)NSMutableArray<NSString*>* matchRoundList; //比赛轮次
@property(nonatomic, assign) NSInteger roundIndex; //显示的下标
@property(nonatomic, strong)QukanScheduleHeader* scheduleHeader;


@property(nonatomic, strong)NSMutableArray< NSMutableDictionary<NSString*, NSMutableArray<QukanCupMatchModel*>*>*>* scheduleArray;
@property(nonatomic, strong)NSMutableArray< NSMutableDictionary<NSString*, NSMutableArray<QukanTeamScoreModel*>*>*>* groupArray;


@property(nonatomic, assign) ShowInfoType showMatchType; //展示类型

@property(nonatomic, strong)NSArray<UIColor*>* cellBkColors; //背景色;


@property(nonatomic, assign)NSInteger firstTableViewRequestedState; // -1 未请求 0 请求失败  1请求成功
@property(nonatomic, assign)NSInteger secondTableViewRequestedState; //-1 未请求 0 请求失败  1请求成功
@property(nonatomic, assign)NSInteger thirdTableViewRequestedState; //-1 未请求 0 请求失败  1请求成功
@property(nonatomic,copy) NSString* errorMsg_1; //-1 未请求 0请求报错  1请求成功
@property(nonatomic,copy) NSString* errorMsg_2; //-1 未请求 0请求报错  1请求成功
@property(nonatomic,copy) NSString* errorMsg_3; //-1 未请求 0请求报错  1请求成功



@end

#define kQukanMemberCell     @"QukanMemberCell"
#define kQukanTeamScoreCell  @"QukanTeamScoreCell"
#define kQukanScheduleCell   @"QukanScheduleCell"

#define darkColor HEXColor(0x333D46)
#define darkColor2 HEXColor(0x21282D)
#define darkColor3 HEXColor(0x31373C)

@implementation QukanAnalysisListVC

-(instancetype)initWithLeagueInfo:(QukanLeagueInfoModel*)model{
    if(self = [super init]){
        self.infoModel = model;
        self.firstTableViewRequestedState = -1;
        self.secondTableViewRequestedState = -1;
        self.thirdTableViewRequestedState = -1;
    }
    return self;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MMPickerView dismissWithCompletion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = darkColor;
    [self layoutViews];

    self.playerPageIndex = 1;
    _roundIndex = 0;
    [self requestRoundList];
    self.type = 0;
    DEBUGLog(@"%@------viewDidLoad",self);
}

- (void)applyRoundAtIndex:(NSInteger)index radius:(CGFloat)radius view:(UIView *)view
{
    UIRectCorner corners = 0;
    if(index == 0){
        corners = UIRectCornerTopLeft|UIRectCornerBottomLeft;
    }else if(index == 2){
        corners = UIRectCornerTopRight|UIRectCornerBottomRight;
    }else{
        radius = 0;
    }
    
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

- (void)layoutViews{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:kImageNamed(@"kqds_data_under") forState:UIControlStateNormal];
    _chooseSeasonBtn = btn;
    [_chooseSeasonBtn setTitle:_infoModel.currMatchSeason forState:UIControlStateNormal];
    [_chooseSeasonBtn setTitleColor:HEXColor(0x929CAD) forState:UIControlStateNormal];
    [self.view addSubview:_chooseSeasonBtn];
    btn.frame = CGRectMake(20, 16, 58, 18);
//    _chooseSeasonBtn.backgroundColor = UIColor.redColor;
    _chooseSeasonBtn.titleLabel.font = [UIFont systemFontOfSize:13];

    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, - btn.imageView.image.size.width, 0, btn.imageView.image.size.width)];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, btn.titleLabel.bounds.size.width + 5, 0, -btn.titleLabel.bounds.size.width)];

    [_chooseSeasonBtn addTarget:self action:@selector(chooseSeasonAction) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *segTitles = @[@"积分",@"射手",@"赛程"];
    NSMutableArray *segBtns = [NSMutableArray new];
    for (int i = 0;i<segTitles.count;i++) {
        UIButton *segBtn = [UIButton new];
        [self.view addSubview:segBtn];
        segBtn.frame = CGRectMake(0,0, 74, 29);
        segBtn.center = CGPointMake(self.view.centerX + (i-1)*74, 25);
        segBtn.titleLabel.font = kFont12;
        [self applyRoundAtIndex:i radius:4 view:segBtn];
        [segBtn setTitle:segTitles[i] forState:UIControlStateNormal];
        [segBtns addObject:segBtn];
        @weakify(self)
        [[segBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIButton * _Nullable x) {
            @strongify(self)
            for (UIButton *btn in segBtns) {
                btn.selected = 0;
            }
            segBtn.selected = 1;
            [self.mScrollView setContentOffset:CGPointMake(kScreenWidth * segBtn.tag, 0) animated:1];
            self.type = x.tag;
        }];
        [segBtn setBackgroundImage:[UIImage imageWithColor:HEXColor(0x333D46)] forState:UIControlStateNormal];
        [segBtn setBackgroundImage:[UIImage imageWithColor:HEXColor(0x1B2227)] forState:UIControlStateSelected];
        [segBtn setTitleColor:HEXColor(0x8D95A8) forState:UIControlStateNormal];
        [segBtn setTitleColor:kCommonWhiteColor forState:UIControlStateSelected];
        segBtn.selected = i == _type;
        segBtn.tag = i;
        
    }
    self.view.backgroundColor = darkColor;
    
    self.mScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 50, kScreenWidth, kScreenHeight-kBottomBarHeight - kTopBarHeight-50 -40)];
    self.mScrollView.backgroundColor = kRandomColor;
    self.mScrollView.scrollEnabled = 0;
    self.mScrollView.contentSize = CGSizeMake(kScreenWidth * 3, 0);
    [self.view addSubview:self.mScrollView];
    
    [self.mScrollView addSubview:self.rankTableView];
    
    [self.rankTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.mas_equalTo(0);
        make.width.offset(kScreenWidth);
        make.height.mas_equalTo(self.mScrollView);
    }];
    
//    self.rankTableView.backgroundColor = UIColor.redColor;
    
    [self.mScrollView addSubview:self.playerTableView];
    [self.playerTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(kScreenWidth);
        make.top.mas_equalTo(0);
        make.width.offset(kScreenWidth);
        make.height.mas_equalTo(self.mScrollView);
    }];
//    self.playerTableView.backgroundColor = UIColor.blueColor;
    
    [self.mScrollView addSubview:self.scheduleTableView];
    [self.scheduleTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(kScreenWidth*2);
        make.top.mas_equalTo(0);
        make.width.offset(kScreenWidth);
        make.height.mas_equalTo(self.mScrollView);
    }];
//    self.scheduleTableView.backgroundColor = UIColor.cyanColor;
}

#pragma mark ===================== Private Method ==================================
- (void)requestRankData{
    if(_infoModel.type.intValue == 1){
        [self requestLeagueRankData];
    }else{
        [self requesCupRankData];
    }
}

- (NSMutableArray*)groupByColorForArray:(NSArray*)originDatas{
    NSMutableArray< NSMutableDictionary<UIColor*, NSMutableArray*>*>* totalDatas = [NSMutableArray new];
    for(QukanTeamScoreModel* model in originDatas){
        NSString* upgradeKey = model.promotion;
        if(!upgradeKey){
            upgradeKey = @"";
        }
        NSInteger keyIndex = -1;
        for(NSMutableDictionary* dic in totalDatas){
            if([dic.allKeys containsObject:upgradeKey]){
                keyIndex = [totalDatas indexOfObject:dic];
                break;
            }
        }
        if(keyIndex > -1){
            NSMutableDictionary*dic = totalDatas[keyIndex];
            NSMutableArray* array = dic[upgradeKey];
            [array addObject:model];
        }else{
            NSMutableArray* array = [NSMutableArray new];
            [array addObject:model];
            NSMutableDictionary* dic = @{upgradeKey:array}.mutableCopy;
            [totalDatas addObject:dic];
        }
    }
    
    return totalDatas;
}

- (void)requestLeagueRankData {
//    KShowHUD
    NSString* season = self.curSeason;

    NSDictionary*params = @{@"leagueId":_infoModel.leagueId, @"season":season};
    @weakify(self)
    
    DEBUGLog(@"requestLeagueRankData---param:%@--",params);
    [[kApiManager QukanFetchTeamLeagueRankInfoWithParams:params] subscribeNext:^(NSArray *  _Nullable x){
        @strongify(self)
        if (x.count) {
            [self.dataSource[0] removeAllObjects];
            self.dataSource[0] = [self groupByColorForArray:x];
//            [self.dataSource[0] addObjectsFromArray:x];
        }
        self.firstTableViewRequestedState = 1;

        [self.rankTableView.mj_header endRefreshing];
        [self.rankTableView reloadData];
//        KHideHUD

    } error:^(NSError * _Nullable error) {
        DEBUGLog(@"%@",error);
        @strongify(self)

        self.firstTableViewRequestedState = 0;
        self.errorMsg_1 = @"加载失败 请稍后再试";//error.localizedDescription;
        
        [self.rankTableView reloadData];
        [self.rankTableView.mj_header endRefreshing];
//        KHideHUD
//        [self.view showTip:@"加载失败"];
    }];
}


- (NSMutableArray*)makeGroupWithDatas:(NSArray*)originDatas isisSch:(BOOL)isSch{
    NSMutableArray< NSMutableDictionary<NSString*, NSMutableArray*>*>* totalDatas = [NSMutableArray new];
    for(id model in originDatas){
        
        NSString*keyName;
        if(isSch){
            keyName = ((QukanCupMatchModel*)model).roundNum;
        }else{
            keyName = FormatString(@"%@ %@",((QukanTeamScoreModel*)model).groupN,((QukanTeamScoreModel*)model).groupX);
        }
        NSInteger keyIndex = -1;
        for(NSMutableDictionary* dic in totalDatas){
            if([dic.allKeys containsObject:keyName]){
                keyIndex = [totalDatas indexOfObject:dic];
                break;
            }
        }
        if(keyIndex > -1){
            NSMutableDictionary*dic = totalDatas[keyIndex];
            NSMutableArray* array = dic[keyName];
            [array addObject:model];
        }else{
            NSMutableArray* array = [NSMutableArray new];
            [array addObject:model];
            NSMutableDictionary* dic = @{keyName:array}.mutableCopy;
            [totalDatas addObject:dic];
        }
        
        [totalDatas sortUsingComparator:^NSComparisonResult(NSDictionary* obj1, NSDictionary* obj2) {
            NSString*key1 = obj1.allKeys.lastObject;
            NSString*key2 = obj2.allKeys.lastObject;
            return [key1 compare:key2];
        }];
    }
    return totalDatas;
}

- (void)handleCupData:(NSDictionary*)dic{
    NSMutableArray* schArray = [NSMutableArray array];
    NSMutableArray* grpArray = [NSMutableArray array];
    [schArray addObjectsFromArray: [NSArray modelArrayWithClass:[QukanCupMatchModel class] json:dic[@"matchSc"]]];
    [grpArray addObjectsFromArray: [NSArray modelArrayWithClass:[QukanTeamScoreModel class] json:dic[@"groupData"]]];
    
    
    [grpArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        QukanTeamScoreModel* model1 = (QukanTeamScoreModel*)obj1;
        QukanTeamScoreModel* model2 = (QukanTeamScoreModel*)obj2;
        return model1.sort.intValue < model2.sort.intValue? NSOrderedAscending:NSOrderedDescending;
    }];
    
    self.scheduleArray = [self makeGroupWithDatas:schArray isisSch:YES];
    self.groupArray = [self makeGroupWithDatas:grpArray isisSch:NO];
    
}

- (void)requesCupRankData {
//    KShowHUD
    NSString* season = self.curSeason;
    NSDictionary*params = @{@"leagueId":_infoModel.leagueId, @"season":season};
    DEBUGLog(@"requesCupRankData---param:%@--",params);
    @weakify(self)
    [[kApiManager QukanFetchTeamCupRankInfoWithParams:params] subscribeNext:^(NSDictionary *  _Nullable x){
        @strongify(self)
        if (x) {
            [self handleCupData:x];
          }
        self.firstTableViewRequestedState = 1;

        [self.rankTableView reloadData];
        
        [self.rankTableView.mj_header endRefreshing];
//        KHideHUD
        
    } error:^(NSError * _Nullable error) {
        DEBUGLog(@"%@",error);
        @strongify(self)

        self.firstTableViewRequestedState = 0;

        [self.rankTableView reloadData];

        [self.rankTableView.mj_header endRefreshing];
//        KHideHUD
//        [self.view showTip:@"加载失败"];
    }];
}

- (void)requestPlayerRankData {

    NSString* season = [self.chooseSeasonBtn titleForState:UIControlStateNormal];
    if([season containsString:@"/"]){
        NSArray* strs = [season componentsSeparatedByString:@"/"];
        season = FormatString(@"20%@-20%@",strs[0],strs[1]);
    }
    NSDictionary* params = @{@"current":@(_playerPageIndex),@"size":@(20),@"season":season,@"leagueId":_infoModel.leagueId};
    DEBUGLog(@"requestPlayerRankData---param:%@--",params);

    @weakify(self)
    [[kApiManager QukanFetchPlayerRankInfoWithParams:params] subscribeNext:^(NSDictionary *  _Nullable x) {
        @strongify(self)
        NSArray* records = [NSArray modelArrayWithClass:[QukanFTPlayerGoalModel class] json:[x objectForKey:@"records"]];

        if (self.playerPageIndex == 1 || self.dataSource[1].count == 0) {
            self.dataSource[1] = [NSMutableArray arrayWithArray:records];
            [self.playerTableView.mj_header endRefreshing];
            
            
        }else {
            [self.dataSource[1] addObjectsFromArray:records];
        }
        self.playerPageIndex += 1;
        
        self.playerTableView.mj_footer.hidden = self.dataSource[1].count == 0;
        if (records.count < 20) {
            [self.playerTableView.mj_footer endRefreshingWithNoMoreData];
            self.playerTableView.mj_footer.hidden = YES;
        }else {
            [self.playerTableView.mj_footer endRefreshing];
        }
        [self.dataSource[1] sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            QukanFTPlayerGoalModel* model1 = (QukanFTPlayerGoalModel*)obj1;
            QukanFTPlayerGoalModel* model2 = (QukanFTPlayerGoalModel*)obj2;
            return model1.goals > model2.goals? NSOrderedAscending:NSOrderedDescending;
        }];
        self.secondTableViewRequestedState = 1;

        [self.playerTableView reloadData];
//        KHideHUD
    } error:^(NSError * _Nullable error) {
        DEBUGLog(@"%@",error);
        @strongify(self)
        self.secondTableViewRequestedState = 0;
        [self.playerTableView.mj_header endRefreshing];
        [self.playerTableView.mj_footer endRefreshing];
        self.errorMsg_2 = @"加载失败 请稍后再试";//error.localizedDescription;

        [self.playerTableView reloadData];

    }];
}

/**查询赛程轮次*/
- (void)requestRoundList{
//    KShowHUD
    NSString* season = self.curSeason;
    NSDictionary*params = @{@"leagueId":_infoModel.leagueId, @"season": season};
    DEBUGLog(@"requestRoundList---param:%@--",params);
    @weakify(self)
    [[kApiManager QukanFetchMatchRoundListWithParams:params] subscribeNext:^(NSDictionary *  _Nullable x) {
        @strongify(self)
        [self.matchRoundList removeAllObjects];
        [self.matchRoundList addObjectsFromArray:[x objectForKey:@"rounds"] ];
        NSInteger index = [self.matchRoundList indexOfObject:[x objectForKey:@"currRound"]];
        if(index>=0 && index < self.matchRoundList.count){
            self.roundIndex = (index>=0 && index < self.matchRoundList.count)? index:0;
        }else{
            self.thirdTableViewRequestedState = 1;
            [self.scheduleTableView reloadData];
//            KHideHUD
        }
    } error:^(NSError * _Nullable error) {
        DEBUGLog(@"%@",error);
        @strongify(self)
        self.thirdTableViewRequestedState = 0;
        self.errorMsg_3 = @"加载失败 请稍后再试";//error.localizedDescription;

        [self.scheduleTableView reloadData];
//        KHideHUD

//        [self.view showTip:@"加载失败"];
    }];
}

- (void)requestScheduleData {
    NSString* roundNum = _roundIndex >= self.matchRoundList.count? @"":self.matchRoundList[_roundIndex];
    NSString* season = self.curSeason;
    NSDictionary*params = @{@"type":@(2), @"leagueId":_infoModel.leagueId, @"season":season, @"roundNum":roundNum};
    @weakify(self)
//    KShowHUD;
    [[kApiManager QukanFetchScheduleInfoWithParams:params] subscribeNext:^(NSDictionary *  _Nullable x) {
        @strongify(self)
        
        NSArray* preMatch = [NSArray modelArrayWithClass:[QukanFTMatchScheduleModel class] json: x[@"scheduler_match"]];
        NSArray* nowMatch = [NSArray modelArrayWithClass:[QukanFTMatchScheduleModel class] json: x[@"now_match"]];
        NSArray* finishMatch = [NSArray modelArrayWithClass:[QukanFTMatchScheduleModel class] json: x[@"finished_match"]];
        [self.dataSource[2] removeAllObjects];
        
        [self.dataSource[2] addObjectsFromArray:preMatch];
        [self.dataSource[2] addObjectsFromArray:nowMatch];
        [self.dataSource[2] addObjectsFromArray:finishMatch];
        
        self.thirdTableViewRequestedState = 1;
        [self.scheduleTableView reloadData];
        [self.scheduleTableView.mj_header endRefreshing];
//        KHideHUD

    } error:^(NSError * _Nullable error) {
        @strongify(self)

        DEBUGLog(@"%@",error);
//        KHideHUD;
        [self.dataSource[2] removeAllObjects];
        self.thirdTableViewRequestedState = 0;

        [self.scheduleTableView reloadData];
        
        [self.scheduleTableView.mj_header endRefreshing];

    }];
}

- (QukanMatchInfoContentModel*)createWithModel:(id)originModel{
    QukanMatchInfoContentModel* resultModel = [QukanMatchInfoContentModel new];
    QukanFTMatchScheduleModel* orgModel = (QukanFTMatchScheduleModel*)originModel;
    
    resultModel.match_id = orgModel.match_id.intValue;
    resultModel.away_id = orgModel.away_id;
    resultModel.home_id = orgModel.home_id;
    resultModel.league_name = orgModel.league_name;
    resultModel.match_time = orgModel.match_time;
    resultModel.pass_time = orgModel.pass_time;
    resultModel.bc1 = orgModel.bc1.intValue;
    resultModel.bc2 = orgModel.bc2.intValue;
    resultModel.corner1 = orgModel.corner1.intValue;
    resultModel.corner2 = orgModel.corner2.intValue;
    resultModel.home_name = orgModel.home_name;
    resultModel.away_name = orgModel.away_name;
    resultModel.home_score = orgModel.home_score.intValue;
    resultModel.away_score = orgModel.away_score.intValue;
    resultModel.order1 = orgModel.order1;
    resultModel.order2 = orgModel.order2;
    resultModel.red1 = orgModel.red1.intValue;
    resultModel.red2 = orgModel.red2.intValue;
    resultModel.yellow1 = orgModel.yellow1.intValue;
    resultModel.yellow2 = orgModel.yellow2.intValue;
    
    resultModel.flag1 = orgModel.flag1;
    resultModel.flag2 = orgModel.flag2;
    
    resultModel.state = [orgModel state].intValue;
    resultModel.start_time = orgModel.start_time;
    resultModel.season = orgModel.season;
    resultModel.league_id = orgModel.league_id;
    
    return resultModel;
}


#pragma mark ===================== Action Method ==================================
- (void)chooseSeasonAction{
    NSArray *strings = _infoModel.seasons;
    @weakify(self)
    UIFont *customFont  = [UIFont systemFontOfSize:17];
    NSDictionary *options = @{MMbackgroundColor:[UIColor whiteColor],
                              MMtextColor: kCommonBlackColor,
                              MMtoolbarColor:[UIColor whiteColor],
                              MMbuttonColor:kThemeColor,
                              MMfont: customFont,
                              MMvalueY: @5,
                              MMselectedObject:[self.chooseSeasonBtn titleForState:UIControlStateNormal]
                              };
    
    [MMPickerView showPickerViewInView:self.view
                           withStrings:strings
                           withOptions:options
                            completion:^(NSString *selectedString) {
                                @strongify(self)
                                
                                NSString* originTitle = [self.chooseSeasonBtn titleForState:UIControlStateNormal];
                                if([originTitle isEqualToString:selectedString])
                                    return ;
                                [self.chooseSeasonBtn setTitle:selectedString forState:UIControlStateNormal];
                                //请求数据
                                if(self.infoModel.type.intValue == 2){
                                    [self.groupArray removeAllObjects];
                                    [self.scheduleArray removeAllObjects];
                                }
                                [self.dataSource[0] removeAllObjects];
                                [self.dataSource[1] removeAllObjects];
                                [self.dataSource[2] removeAllObjects];
                                [self.matchRoundList removeAllObjects];
                                self.playerPageIndex = 1;
                                self.type = self.type;
                            }];
}

- (void)segmentAction:(UISegmentedControl *)Seg{
    NSInteger Index = Seg.selectedSegmentIndex;
    self.type = Index;
}

- (void)scheduleHeaderCilickedOnButton:(UIButton*)sender{
    if(self.matchRoundList.count <= 0){
        [self.view showTip:@"暂无赛程信息"];
        return ;
    }
    if(sender.tag == 100){
        if(_roundIndex == 0){
            [self.view showTip:@"已经是第一轮了"];
            return;
        }
        self.roundIndex -= 1;
        
    }else if(sender.tag == 101){
        NSMutableArray* showRoundStrs = [NSMutableArray new];
        for(int i = 0; i < self.matchRoundList.count; i++){
            [showRoundStrs addObject:[self  roundNameAtIndex:i]];
        }
        @weakify(self)
        NSArray *strings = showRoundStrs;
        
        UIFont *customFont  = [UIFont systemFontOfSize:17];
        NSDictionary *options = @{MMbackgroundColor:[UIColor whiteColor],
                                  MMtextColor: kCommonBlackColor,
                                  MMtoolbarColor:[UIColor whiteColor],
                                  MMbuttonColor:kThemeColor,
                                  MMfont: customFont,
                                  MMvalueY: @5,
                                  MMselectedObject:[self.scheduleHeader curRoundName]

                                  };
        
        [MMPickerView showPickerViewInView:self.view
                               withStrings:strings
                               withOptions:options
                                completion:^(NSString *selectedString) {
                                    @strongify(self)
                                    NSString* oriTitle = [self.scheduleHeader curRoundName];
                                    if([oriTitle isEqualToString:selectedString])
                                        return ;
                                    
                                    self.roundIndex = [strings indexOfObject:selectedString];
                                }];
    }else if(sender.tag == 102){
        if(_roundIndex == self.matchRoundList.count - 1){
            [self.view showTip:@"已经是最后一轮了"];
            return;
        }
        self.roundIndex += 1;
    }
}


#pragma mark ===================== TableView Delegate ==================================
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if([_rankTableView isEqual:tableView] && _infoModel.type.intValue == 1){
        return 0.01;
    }
    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* header = nil;
    if([_rankTableView isEqual:tableView]){
        QukanTeamScoreHeader* headView = [[QukanTeamScoreHeader alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 35)];
        if(_infoModel.type.intValue == 2){
            if(self.showMatchType == MatchType_ScheduleAndGroup){
                if(section < self.scheduleArray.count){
                    NSString* roundName = self.scheduleArray[section].allKeys.lastObject;
                    [headView onlyShowTitle: roundName];
                }else{
                    NSString* roundName = self.groupArray[section-self.scheduleArray.count].allKeys.lastObject;
                    headView.label_1.text = roundName;
                }
            }else if(self.showMatchType == MatchType_OnlySchedule){
                NSString* roundName = self.scheduleArray[section].allKeys.lastObject;
                [headView onlyShowTitle: roundName];
            }else if(self.showMatchType == MatchType_OnlyGroup){
                NSString* roundName = self.groupArray[section].allKeys.lastObject;
                headView.label_1.text = roundName;
            }
        }else{
            return [UIView new];
        }
        
        header = headView;
    }else if([_playerTableView isEqual:tableView]){
        header = [[QukanMemberHeader alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 35)];
    }else{
        if(self.scheduleHeader){
            return self.scheduleHeader;
        }
        QukanScheduleHeader* schHeader = [[QukanScheduleHeader alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 35)];// [[NSBundle mainBundle] loadNibNamed:@"QukanScheduleHeader" owner:self options:nil].lastObject;
        schHeader.scheduleHeaderClickAtButton = ^(UIButton * _Nonnull sender) {
            [self scheduleHeaderCilickedOnButton:(sender)];
        } ;
        header = schHeader;
        self.scheduleHeader = (QukanScheduleHeader*)header;
    }
    header.backgroundColor = darkColor2;
    return header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([_rankTableView isEqual:tableView] ){
        if(_infoModel.type.intValue == 2){
            if(self.showMatchType == MatchType_ScheduleAndGroup){
                if(section < self.scheduleArray.count){
                    NSDictionary* dic = self.scheduleArray[section];
                    NSArray*models = dic.allValues.lastObject;
                    return models.count;
                }else{
                    NSDictionary* dic = self.groupArray[section-self.scheduleArray.count];
                    NSArray*models = dic.allValues.lastObject;
                    return models.count;
                }
            }else if(self.showMatchType == MatchType_OnlySchedule){
                NSDictionary* dic = self.scheduleArray[section];
                NSArray*models = dic.allValues.lastObject;
                return models.count;
            }else if(self.showMatchType == MatchType_OnlyGroup){
                NSDictionary* dic = self.groupArray[section];
                NSArray*models = dic.allValues.lastObject;
                return models.count;
            }else{
                return 0;
            }
        }else{
            
            NSDictionary* dic = self.dataSource[0][section];
            NSArray*models = dic.allValues.lastObject;
            return models.count;
            
//            return self.dataSource[0].count;
        }
    } else if([_playerTableView isEqual:tableView]){
        return self.dataSource[1].count;
    }else{
        return self.dataSource[2].count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if([_rankTableView isEqual:tableView] && _infoModel.type.intValue == 2){//杯赛
        return self.scheduleArray.count + self.groupArray.count;
    }else if([_rankTableView isEqual:tableView] && _infoModel.type.intValue == 1){
        return self.dataSource[0].count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if([_rankTableView isEqual:tableView] && _infoModel.type.intValue == 2){
        if(self.showMatchType == MatchType_OnlySchedule){
            return kScaleScreen(110);
        }else if(self.showMatchType == MatchType_ScheduleAndGroup){
            if(indexPath.section < self.scheduleArray.count){
                return kScaleScreen(110);
            }
        }
    }
    return 45;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if([tableView isEqual:_scheduleTableView]){
        if(indexPath.row == self.dataSource[2].count - 1){
            DEBUGLog(@"finish reload _scheduleTableView -------%@",[NSDate date]);
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell;
    UIColor* contentBGColor = darkColor3;
    if([tableView isEqual:_rankTableView]){
        if(_infoModel.type.intValue == 1){
            QukanTeamScoreCell* cell_1 = (QukanTeamScoreCell*)[tableView dequeueReusableCellWithIdentifier:@"QukanTeamScoreCell"];
            cell_1.cutLine.alpha = 1;

            NSInteger rankIndex = 0;
            for(int i = 0; i < indexPath.section; i++){
                NSArray*array = [[self.dataSource[0][i] allValues]lastObject];
                rankIndex += array.count;
            }
            rankIndex += indexPath.row + 1;
            cell_1.label_1.text = @(rankIndex).stringValue;

            NSDictionary* dic = self.dataSource[0][indexPath.section];
            NSArray*models = dic.allValues.lastObject;
            NSString*upgradeKey = dic.allKeys.lastObject;

            QukanTeamScoreModel*model = models[indexPath.row];
            [cell_1 setModel:model];
            NSInteger colorIndex = 3;
            if(upgradeKey.length > 0){
                if(indexPath.section == [tableView numberOfSections] - 1){
                    colorIndex = 2;
                }else{
                    colorIndex = 0;
                    cell_1.cutLine.alpha = 0.1;
                }
            }else{
                colorIndex = 1;
            }
            cell_1.upGradeLabel.text = @"";
            if(indexPath.row == 0){
                cell_1.upGradeLabel.text = model.promotion? FormatString(@" %@ ",model.promotion):@"";
            }
            contentBGColor = self.cellBkColors[colorIndex];
            cell = cell_1;
        }else{//杯赛
            if(self.showMatchType == MatchType_ScheduleAndGroup){
                NSArray* models;
                if(indexPath.section < self.scheduleArray.count){
                    QukanCupMatchCell* cell_1 = (QukanCupMatchCell*)[tableView dequeueReusableCellWithIdentifier:@"QukanCupMatchCell"];
                    NSDictionary* dic = self.scheduleArray[indexPath.section];
                    models = dic.allValues.lastObject;
                    //设置model
                    [cell_1 setModel:models[indexPath.row]];
                    cell = cell_1;
                }else{
                    QukanTeamScoreCell* cell_1 = (QukanTeamScoreCell*)[tableView dequeueReusableCellWithIdentifier:@"QukanTeamScoreCell"];
                    NSDictionary* dic = self.groupArray[indexPath.section-self.scheduleArray.count];
                    models = dic.allValues.lastObject;
                    //设置model
                    [cell_1 setModel:models[indexPath.row]];
                    if(indexPath.row <= 1){
                        contentBGColor = kThemeColor;
                    }
                    cell_1.cutLine.backgroundColor = indexPath.row == 0? COLOR_HEX(0x360A0A, 0.2):HEXColor(0x27313C);
                    cell = cell_1;
                }
                
            } else if(self.showMatchType == MatchType_OnlySchedule){
                QukanCupMatchCell* cell_1 = (QukanCupMatchCell*)[tableView dequeueReusableCellWithIdentifier:@"QukanCupMatchCell"];
                NSArray* array = [[self.scheduleArray[indexPath.section] allValues] lastObject];
                [cell_1 setModel:array[indexPath.row]];
                //设置model
                cell = cell_1;
            } else if(self.showMatchType == MatchType_OnlyGroup){
                QukanTeamScoreCell* cell_1 = (QukanTeamScoreCell*)[tableView dequeueReusableCellWithIdentifier:@"QukanTeamScoreCell"];
                NSArray* array = [[self.groupArray[indexPath.section] allValues] lastObject];
                [cell_1 setModel:array[indexPath.row]];
                if(indexPath.row <= 1){
                    contentBGColor = kThemeColor;
                }
                cell_1.cutLine.backgroundColor = indexPath.row == 0? COLOR_HEX(0x360A0A, 0.2):HEXColor(0x27313C);
                cell = cell_1;
            } else{
                DEBUGLog(@"never should came here");
            }
        }
    }else if([tableView isEqual:_playerTableView]){
        QukanMemberCell* cell_1 = (QukanMemberCell*)[tableView dequeueReusableCellWithIdentifier:@"QukanMemberCell"];
        [cell_1 setModel:self.dataSource[1][indexPath.row]];
        cell_1.label_1.text = @(indexPath.row +1).stringValue;
        cell = cell_1;
    }else{
        QukanScheduleCell* cell_1 = (QukanScheduleCell*)[tableView dequeueReusableCellWithIdentifier:@"QukanScheduleCell"];
        [cell_1 setModel:self.dataSource[2][indexPath.row]];
        cell = cell_1;
    }
    cell.contentView.backgroundColor = contentBGColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if([tableView isEqual:_rankTableView]){
        if(_infoModel.type.intValue == 1){
            NSDictionary* dic = self.dataSource[0][indexPath.section] ;
            NSArray* modelArray = [[dic allValues]lastObject];
            QukanTeamScoreModel*model = modelArray[indexPath.row];
            model.season = self.curSeason;
            QukanTeamDetailVC* vc = [[QukanTeamDetailVC alloc]initWithModel:model];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            UITableViewCell*cell = [tableView cellForRowAtIndexPath:indexPath];
            NSArray* models;

            if(self.showMatchType == MatchType_ScheduleAndGroup){
                if(indexPath.section < self.scheduleArray.count){
                    NSDictionary* dic = self.scheduleArray[indexPath.section];
                    models = dic.allValues.lastObject;
                }else{
                    NSDictionary* dic = self.groupArray[indexPath.section-self.scheduleArray.count];
                    models = dic.allValues.lastObject;
                }
            } else if(self.showMatchType == MatchType_OnlySchedule){
                models = [[self.scheduleArray[indexPath.section] allValues] lastObject];
            } else if(self.showMatchType == MatchType_OnlyGroup){
                models = [[self.groupArray[indexPath.section] allValues] lastObject];
            } else{
                DEBUGLog(@"never should came here");
            }
            if(models.count > indexPath.row){
                id model = models[indexPath.row];
                if([cell isKindOfClass:[QukanTeamScoreCell class]]){
                    QukanTeamScoreModel*vcModel = (QukanTeamScoreModel*)model;
                    vcModel.season = self.curSeason;
                    QukanTeamDetailVC* vc = [[QukanTeamDetailVC alloc]initWithModel:vcModel];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }else{
                    QukanFTMatchScheduleModel *vcModel = (QukanFTMatchScheduleModel *)model;
                    QukanDetailsViewController* vc = [QukanDetailsViewController new];
                    vc.Qukan_model = [self createWithModel:vcModel];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
            
        }
    }else if([tableView isEqual:_playerTableView]){
        QukanFTPlayerGoalModel*model = self.dataSource[1][indexPath.row];
        model.season = self.curSeason;
        QukanFTPlayerDetailVC* vc = [[QukanFTPlayerDetailVC alloc]initWithModel:model];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if([tableView isEqual:_scheduleTableView]){
        QukanFTMatchScheduleModel *model = self.dataSource[2][indexPath.row];
        QukanDetailsViewController* vc = [QukanDetailsViewController new];
        vc.Qukan_model = [self createWithModel:model];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark ===================== JXCategoryListContentViewDelegate ==================================

- (UIView *)listView {
    return self.view;
}

#pragma mark ===================== DZNEmptyDataSetSource ==================================
// 占位图提示文本
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString* showStr = @"暂无数据";
    return [[NSAttributedString alloc] initWithString:showStr attributes:@{NSFontAttributeName : kFont16,NSForegroundColorAttributeName : [UIColor grayColor]}];
}
// 占位图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
//    NSString *imageName = @"Qukan_Null_Data";
    NSString *imageName = @"";
  return [UIImage imageNamed:imageName];
}
// 占位图点击效果
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    self.type = self.type;
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
    if([scrollView isEqual:self.rankTableView]){
        return self.firstTableViewRequestedState > -1;
    }else if([scrollView isEqual:self.playerTableView]){
        return self.secondTableViewRequestedState > -1;
    }else if([scrollView isEqual:self.scheduleTableView]){
        return self.thirdTableViewRequestedState > -1;
    }
    return YES;
}

#pragma mark ===================== Getter and Setter==================================
-(NSArray<UIColor *> *)cellBkColors{
    if(!_cellBkColors){
        _cellBkColors = @[COLOR_HEX(0xF7B500, 1),COLOR_HEX(0x31373C, 1),COLOR_HEX(0x202225, 1)];
    }
    return _cellBkColors;
}

- (BOOL)isNum:(NSString *)checkedNumString {
    checkedNumString = [checkedNumString stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(checkedNumString.length > 0) {
        return NO;
    }
    return YES;
}

- (NSString*) roundNameAtIndex:(NSInteger)index{
    NSString* str = self.matchRoundList[index];
    if( [self isNum:str]){
        return FormatString(@"第%@轮",str);
    }
    return str;
}

- (ShowInfoType)showMatchType{
    ShowInfoType type = MatchType_None;
    if(self.groupArray.count > 0 && self.scheduleArray.count > 0){
        type = MatchType_ScheduleAndGroup;
    }else if(self.groupArray.count > 0){
        type = MatchType_OnlyGroup;
    }else if(self.scheduleArray.count > 0){
        type = MatchType_OnlySchedule;
    }
    return type;
}


-(void)setRoundIndex:(NSInteger)roundIndex{
    _roundIndex = roundIndex;
    [self.scheduleHeader setRoundName:[self roundNameAtIndex:roundIndex]];
    [self requestScheduleData];
}

-(NSMutableArray<NSString *> *)matchRoundList{
    if(!_matchRoundList){
        _matchRoundList = [NSMutableArray array];
    }
    return _matchRoundList;
}
-(NSMutableArray<NSMutableDictionary<NSString *,NSMutableArray<QukanCupMatchModel *> *> *> *)scheduleArray{
    if(!_scheduleArray){
        _scheduleArray = [NSMutableArray array];
    }
    return _scheduleArray;
}

-(NSMutableArray<NSMutableDictionary<NSString *,NSMutableArray<QukanTeamScoreModel *> *> *> *)groupArray{
    if(!_groupArray){
        _groupArray = [NSMutableArray array];
    }
    return _groupArray;
}

-(void)setType:(NSInteger)type{
    _type = type;
   
    if(_type == 0 && _infoModel.type.intValue == 2){
        if(_scheduleArray.count == 0 && _groupArray.count == 0 ){
            [self requesCupRankData];
        }else{
            [self.curTableView reloadData];
        }
    }else{
        if(self.dataSource[_type].count <= 0){
            if(_type == 0){
                [self requestLeagueRankData];
            }else if(_type == 1){
                [self requestPlayerRankData];
            }else if(_type == 2){
                if(self.matchRoundList.count <= 0){
                    [self requestRoundList];
                }
//                [self requestScheduleData];
            }
        }else{
            [self.curTableView reloadData];
        }
    }
}

-(NSString *)curSeason{
    NSString* season = [self.chooseSeasonBtn titleForState:UIControlStateNormal];
    if([season containsString:@"/"]){
        NSArray* strs = [season componentsSeparatedByString:@"/"];
        season = FormatString(@"20%@-20%@",strs[0],strs[1]);
    }
    return season;
}

-(UITableView*)curTableView{
    if(_type == 0){
        return self.rankTableView;
    }else if(_type == 1){
        return self.playerTableView;
    }else{
        return self.scheduleTableView;
    }
}

-(NSArray*)cellClassNames{
    return  @[@"QukanTeamScoreCell",@"QukanMemberCell",@"QukanScheduleCell"];
}

-(NSMutableArray *)dataSource{
    if(!_dataSource){
        _dataSource = [NSMutableArray array];
        for(int i = 0; i < 3; i++){
            [_dataSource addObject:[NSMutableArray array]];
        }
    }
    return _dataSource;
}

- (NSArray*)typeNamse{
    return @[@"积分",@"射手",@"赛程",];
}

- (UISegmentedControl *)showTypeSegmentControl{
    if(!_showTypeSegmentControl ){
        _showTypeSegmentControl = [[UISegmentedControl alloc]initWithItems:self.typeNamse];
        _showTypeSegmentControl.selectedSegmentIndex = _type;
    }
    return _showTypeSegmentControl;
}

- (UITableView *)rankTableView {
    if (!_rankTableView) {
        _rankTableView = [UITableView new];
        _rankTableView.showsVerticalScrollIndicator = 0;
        _rankTableView.separatorStyle = 0;
        _rankTableView.delegate = self;
        _rankTableView.dataSource = self;
        _rankTableView.backgroundColor = HEXColor(0x333D46);
        _rankTableView.emptyDataSetSource = self;
        _rankTableView.emptyDataSetDelegate = self;
        if(_infoModel.type.intValue == 1){
            _rankTableView.tableHeaderView = [[QukanTeamScoreHeader alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 35)];
            _rankTableView.tableHeaderView.backgroundColor = HEXColor(0x21282D);
        }
        [_rankTableView registerClass:[QukanTeamScoreCell class] forCellReuseIdentifier:@"QukanTeamScoreCell"];
        [_rankTableView registerClass:[QukanCupMatchCell class] forCellReuseIdentifier:@"QukanCupMatchCell"];
        @weakify(self)
        _rankTableView.mj_header = [QukanHomeRefreshHeader headerWithRefreshingBlock:^{
            @strongify(self)
            [self requestRankData];
        }];
    }
    return _rankTableView;
}


- (UITableView *)playerTableView {
    if (!_playerTableView) {
        _playerTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _playerTableView.delegate = self;
        _playerTableView.dataSource = self;
        _playerTableView.showsVerticalScrollIndicator = 0;
        _playerTableView.separatorStyle = 0;
        _playerTableView.backgroundColor = darkColor;
        _playerTableView.emptyDataSetSource = self;
        _playerTableView.emptyDataSetDelegate = self;
        [_playerTableView registerClass:[QukanMemberCell class] forCellReuseIdentifier:@"QukanMemberCell"];
        
        @weakify(self)
        _playerTableView.mj_header = [QukanHomeRefreshHeader headerWithRefreshingBlock:^{
            @strongify(self)
            if(self.type == 1){
                self.playerPageIndex = 1;
                [self requestPlayerRankData];
            }
        }];
        
        _playerTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            @strongify(self)
            if(self.type == 1){
                self.playerPageIndex ++;
                [self requestPlayerRankData];
            }
        }];
        _playerTableView.mj_footer.hidden = YES;
        
    }
    return _playerTableView;
}


- (UITableView *)scheduleTableView {
    if (!_scheduleTableView) {
        _scheduleTableView = [UITableView new];
        _scheduleTableView.showsVerticalScrollIndicator = 0;
        _scheduleTableView.separatorStyle = 0;
        _scheduleTableView.delegate = self;
        _scheduleTableView.dataSource = self;
        _scheduleTableView.backgroundColor = HEXColor(0x333D46);
        _scheduleTableView.emptyDataSetSource = self;
        _scheduleTableView.emptyDataSetDelegate = self;
        NSString* cellName = self.cellClassNames[2];
        [_scheduleTableView registerNib:[UINib nibWithNibName:cellName bundle:nil] forCellReuseIdentifier:cellName];
        [_scheduleTableView registerClass:[QukanScheduleCell class] forCellReuseIdentifier:@"QukanScheduleCell"];
        @weakify(self)
        _scheduleTableView.mj_header = [QukanHomeRefreshHeader headerWithRefreshingBlock:^{
            @strongify(self)
            [self requestScheduleData];
        }];
    }
    return _scheduleTableView;
}


@end
