//
//  QukanTeamDetailVC.m
//  Qukan
//
//  Created by Charlie on 2019/12/29.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanTeamDetailVC.h"
#import <JXCategoryView/JXCategoryListContainerView.h>
#import <UIViewController+HBD.h>
#import "QukanTeamNewsVC.h"
#import "QukanTeamScheduleVC.h"
#import "QukanTeamPlayerVC.h"
#import "QukanTeamStatisticsVC.h"
#import "QukanTeamDetailInfoVC.h"
#import "QukanApiManager+FTAnalysis.h"
#import "QukanFTMatchScheduleModel.h"
#import "QukanLocalNotification.h"

@interface QukanTeamDetailVC ()<JXCategoryViewDelegate, JXCategoryListContainerViewDelegate>
@property(nonatomic,strong) UIView* headerView;
@property(nonatomic,strong) UIButton* backBtn;
@property(nonatomic,strong) UIButton* followBtn;
@property(nonatomic,strong) UIImageView* teamFlagImgV;

@property(nonatomic,strong) UIImageView* zqbgImgV;
@property(nonatomic,strong) UILabel* teamNameLabel;

@property(nonatomic,strong) UILabel* rankLabel_t;
@property(nonatomic,strong) UILabel* teamWorthLabel_t;
@property(nonatomic,strong) UILabel* recentRecord_t;

@property(nonatomic,strong) UILabel* rankLabel;
@property(nonatomic,strong) UILabel* teamWorthLabel;
@property(nonatomic,strong) UILabel* recentRecord;

@property(nonatomic,strong) UIView* animateContainerView;


@property(nonatomic,strong) JXCategoryTitleView* categoryView;
@property(nonatomic,strong) JXCategoryListContainerView* listContainerView;

@property(nonatomic,strong) NSArray* categoryTitleNames;
@property(nonatomic,strong) NSArray* categoryVCClassNames;

@property(nonatomic,strong) NSMutableArray* categoryVCs;

@property(nonatomic,strong) QukanTeamScoreModel* teamModel;

@property(nonatomic,strong) NSMutableDictionary* recentRecordDic;

@property(nonatomic,strong) NSMutableArray<QukanFTMatchScheduleModel*>* teamScheduleArray;

@property(nonatomic,assign) BOOL isFollowed;




@end

@implementation QukanTeamDetailVC
- (instancetype)initWithModel:(QukanTeamScoreModel*)model{
    if(self = [super init]){
        self.teamModel = model;
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    self.hbd_barHidden = YES;
    [self.view addSubview:self.headerView];
    [self configHeaderView];
    [self.view addSubview:self.categoryView];

    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.headerView.mas_bottom);
        make.height.mas_equalTo(50);
    }];
    
    [self.listContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.categoryView.mas_bottom);
    }];

    
//    [self.view showLoadingWithTouchable];
    [self requestRecentRecords];
    [self requestTeamSchedule];
}

#pragma mark ===================== private method ==================================

- (void)addLocalNotification{
    for (QukanFTMatchScheduleModel *model in self.teamScheduleArray) {
        [QukanLocalNotification noticeWithType:FootballTeam model:model];
    }
}

- (void)removeLocalNotification{
    for (QukanFTMatchScheduleModel *model in self.teamScheduleArray) {
        [QukanLocalNotification cancleLocationIdentifier:FormatString(@"%@%@",FootballTeam,model.match_id)];
    }
}

- (void)useData{
    self.rankLabel.text = [self.recentRecordDic[@"sort"] longValue] >0? @([self.recentRecordDic[@"sort"] longValue]).stringValue:@"-";
    NSString*record = [self.recentRecordDic[@"victoryDefeat"] substringToIndex:5];
    
    self.recentRecord.text = record? :@"-----";// [self.recentRecordDic[@"victoryDefeat"] substringToIndex:5];
    
    self.isFollowed = [self.recentRecordDic[@"flagAttention"] boolValue];
    QukanTeamStatisticsVC* vc = (QukanTeamStatisticsVC*)self.categoryVCs[3];
    [vc setTeamSence:[self.recentRecordDic[@"scene"] intValue]];
}

- (void)configHeaderView{
    @weakify(self)
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(250);
    }];
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.top.mas_equalTo(kStatusBarHeight);
        make.width.height.mas_equalTo(48);
    }];
    [_backBtn setImage:kImageNamed(@"ft_back") forState:UIControlStateNormal];
    [[_backBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [_followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(self.backBtn);
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(60);
    }];
    _followBtn.backgroundColor = UIColor.clearColor;
    _followBtn.layer.borderWidth = 0.5;
    _followBtn.titleLabel.font = kFont14;
    _followBtn.layer.borderColor = kCommonWhiteColor.CGColor;
    [_followBtn setTitle:@"+ 关注" forState:UIControlStateNormal];
    [_followBtn setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
    
    [[_followBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIButton * _Nullable sender) {
        kGuardLogin
        @strongify(self)
        if(![self.recentRecordDic[@"flagAttention"] boolValue]){
            [self followTeam];
        }else{
            [self unFollowTeam];
        }
    }];
    _followBtn.layer.borderWidth = 1;
    _followBtn.layer.borderColor = kCommonWhiteColor.CGColor;
    
    [_zqbgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(self.zqbgImgV.mas_height);
    }];
    _zqbgImgV.image = kImageNamed(@"bgImg_2");
    
    
    
    [_teamFlagImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.followBtn.mas_bottom).offset(10);
        make.width.height.mas_equalTo(50);
    }];
    [_teamFlagImgV sd_setImageWithURL:[NSURL URLWithString:self.teamModel.flag] placeholderImage:kImageNamed(@"ft_default_flag")];
    _teamFlagImgV.backgroundColor = UIColor.lightGrayColor;
    
    [_teamNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.teamFlagImgV.mas_bottom).offset(8);
        make.height.mas_equalTo(24);
    }];
    
    _teamNameLabel.textColor = kCommonWhiteColor;
    _teamNameLabel.font = [UIFont systemFontOfSize:15];
    _teamNameLabel.textAlignment = NSTextAlignmentCenter;
    _teamNameLabel.text = self.teamModel.g;
    
    [_rankLabel_t mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.headerView.mas_centerX).offset(-40);
        make.bottom.mas_equalTo(-15);
        make.width.mas_equalTo(80);
    }];
    _rankLabel_t.textColor = kCommonWhiteColor;
    _rankLabel_t.font = [UIFont systemFontOfSize:11];
    _rankLabel_t.textAlignment = NSTextAlignmentCenter;
    _rankLabel_t.text = @"球队排名";
    
    [_rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.width.mas_equalTo(self.rankLabel_t);
        make.bottom.mas_equalTo(self.rankLabel_t.mas_top).offset(-3);
    }];
    _rankLabel.textColor = kCommonWhiteColor;
    _rankLabel.font = [UIFont systemFontOfSize:14];
    _rankLabel.textAlignment = NSTextAlignmentCenter;
    _rankLabel.text = @"-";
    
    UIView* sep1 = [UIView new];
    [_headerView addSubview:sep1];
    
    [sep1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.headerView);
        make.top.mas_equalTo(self.rankLabel.mas_top).offset(8);
        make.height.mas_equalTo(18);
        make.width.mas_equalTo(1);
    }];
    sep1.backgroundColor = kCommonWhiteColor;
    
    
    //    [_teamWorthLabel_t mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.mas_equalTo(sep1.mas_right);
    //        make.bottom.mas_equalTo(-15);
    //        make.width.mas_equalTo((kScreenWidth-2)/3.0);
    //    }];
    //    _teamWorthLabel_t.textColor = kCommonWhiteColor;
    //    _teamWorthLabel_t.font = [UIFont systemFontOfSize:11];
    //    _teamWorthLabel_t.textAlignment = NSTextAlignmentCenter;
    //    _teamWorthLabel_t.text = @"球队身价";
    //
    //    [_teamWorthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.width.mas_equalTo(_teamWorthLabel_t);
    //        make.bottom.mas_equalTo(_teamWorthLabel_t.mas_top).offset(-3);
    //    }];
    //    _teamWorthLabel.textColor = kCommonWhiteColor;
    //    _teamWorthLabel.font = [UIFont systemFontOfSize:14];
    //    _teamWorthLabel.textAlignment = NSTextAlignmentCenter;
    //    _teamWorthLabel.text = @"一亿三千万";
    
    //    UIView* sep2 = [UIView new];
    //    [_headerView addSubview:sep2];
    //
    //    [sep2 mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.mas_equalTo(_teamWorthLabel.mas_right);
    //        make.top.mas_equalTo(_teamWorthLabel.mas_top).offset(3);
    //        make.height.mas_equalTo(28);
    //        make.width.mas_equalTo(1);
    //    }];
    //    sep2.backgroundColor = kCommonWhiteColor;
    
    [_recentRecord_t mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headerView.mas_centerX).offset(40);
        make.bottom.mas_equalTo(-15);
        make.width.mas_equalTo(80);
    }];
    _recentRecord_t.textColor = kCommonWhiteColor;
    _recentRecord_t.font = [UIFont systemFontOfSize:11];
    _recentRecord_t.textAlignment = NSTextAlignmentCenter;
    _recentRecord_t.text = @"最近五场";
    
    [_recentRecord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.mas_equalTo(self.recentRecord_t);
        make.bottom.mas_equalTo(self.recentRecord_t.mas_top).offset(-3);
    }];
    _recentRecord.textColor = kCommonWhiteColor;
    _recentRecord.font = [UIFont systemFontOfSize:14];
    _recentRecord.textAlignment = NSTextAlignmentCenter;
    _recentRecord.text = @"-----";
}

- (void) handleData:(NSDictionary*)dic{
    NSArray* preMatch = [NSArray modelArrayWithClass:[QukanFTMatchScheduleModel class] json: dic[@"scheduler_match"]];
    NSArray* nowMatch = [NSArray modelArrayWithClass:[QukanFTMatchScheduleModel class] json: dic[@"now_match"]];
    NSArray* finishMatch = [NSArray modelArrayWithClass:[QukanFTMatchScheduleModel class] json: dic[@"finished_match"]];
    
    NSMutableArray* allData = [NSMutableArray array];
    [allData addObjectsFromArray:preMatch];
    [allData addObjectsFromArray:nowMatch];
    [allData addObjectsFromArray:finishMatch];
    
    [allData sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        QukanFTMatchScheduleModel* model1 = (QukanFTMatchScheduleModel*)obj1;
        QukanFTMatchScheduleModel* model2 = (QukanFTMatchScheduleModel*)obj2;
        return [model1.start_time compare:model2.start_time];
    }];
    _teamScheduleArray = allData;
}

- (void)requestTeamSchedule {
    return;
//    KShowHUD
    QukanTeamScoreModel* model = (QukanTeamScoreModel*) _teamModel;
    
    NSString* season = model.season;
    
    NSDictionary*params = @{@"type":@(1),@"teamId":model.teamId, @"season":season};
    @weakify(self)
    [[kApiManager QukanFetchTeamScheduleWithParams:params] subscribeNext:^(NSDictionary *  _Nullable x){
        @strongify(self)
        [self.categoryVCs[1] configWithDatas:x];
        [self handleData:x];
//        KHideHUD
    } error:^(NSError * _Nullable error) {
        DEBUGLog(@"%@",error);
        @strongify(self);
//        KHideHUD
//        [self.view showTip:@"加载失败"];
    }];
    
}

- (void)requestRecentRecords{

    NSDictionary*params = @{@"teamId":_teamModel.teamId, @"leagueId":_teamModel.leagueId, @"season":_teamModel.season};
    @weakify(self)
    [[kApiManager QukanFetchTeamRecentRecordWithParams:params] subscribeNext:^(NSArray *  _Nullable x){
        @strongify(self)
        self.recentRecordDic = [x.lastObject mutableCopy];
        [self useData];
        
//        [self.view dismissHUD];
        
    } error:^(NSError * _Nullable error) {
        DEBUGLog(@"%@",error);
//        [self.view showTip:@"加载失败"];
    }];
}

- (void)followTeam {
    KShowHUD
    NSDictionary*params = @{@"teamId":_teamModel.teamId, @"type":@"1"};
    [[[kApiManager QukanFollowFTTeamWithParams:params] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        KHideHUD
        self.isFollowed = YES;

        [self.recentRecordDic setObject:@(YES) forKey:@"flagAttention"];
        [self addLocalNotification];

    } error:^(NSError * _Nullable error) {
        KHideHUD
    }];
}

- (void)unFollowTeam {
    KShowHUD
    NSDictionary*params = @{@"teamId":_teamModel.teamId, @"type":@"1"};

    [[[kApiManager QukanUnFollowFTTeamWithParams:params] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        KHideHUD
        self.isFollowed = NO;
        [self.recentRecordDic setObject:@(NO) forKey:@"flagAttention"];

        [self removeLocalNotification];

    } error:^(NSError * _Nullable error) {
        KHideHUD
    }];
}

- (void)setIsFollowed:(BOOL)isFollowed{
    _isFollowed = isFollowed;
    if(isFollowed){
        self.followBtn.layer.borderColor = COLOR_HEX(0xffffff, 0.5).CGColor;
        [self.followBtn setTitle:@"取消关注" forState:UIControlStateNormal];
        [self.followBtn setTitleColor:COLOR_HEX(0xffffff, 0.5) forState:UIControlStateNormal];
    }else{
        self.followBtn.layer.borderColor = kCommonWhiteColor.CGColor;
        [self.followBtn setTitle:@"+ 关注" forState:UIControlStateNormal];
        [self.followBtn setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
        
    }
}

#pragma mark ===================== 旋转 ==================================

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    QukanTeamNewsVC *vc = _categoryVCs.firstObject;
    if (vc.player.isFullScreen && vc.player.orientationObserver.fullScreenMode == ZFFullScreenModeLandscape) {
        return UIInterfaceOrientationMaskLandscape;
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    QukanTeamNewsVC *vc = _categoryVCs.firstObject;
    if (vc.player.isFullScreen) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    QukanTeamNewsVC *vc = _categoryVCs.firstObject;
    return vc.player.isStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

#pragma mark ===================== JXCategoryListContainerViewDelegate ==================================

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.categoryTitleNames.count;
}

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {

    return self.categoryVCs[index];
}

#pragma mark ===================== getter ==================================

- (NSMutableArray*)categoryVCs{
    if(!_categoryVCs){
        _categoryVCs = [NSMutableArray array];
        QukanTeamNewsVC* vc1 = [[QukanTeamNewsVC alloc]initWithModel:self.teamModel];
        vc1.navigation_vc = self.navigationController;
        QukanTeamScheduleVC* vc2 = [[QukanTeamScheduleVC alloc]initWithModel:self.teamModel];
        QukanTeamPlayerVC* vc3 = [[QukanTeamPlayerVC alloc]initWithModel:self.teamModel];
        QukanTeamStatisticsVC* vc4 = [[QukanTeamStatisticsVC alloc]initWithModel:self.teamModel];
        QukanTeamDetailInfoVC* vc5 = [[QukanTeamDetailInfoVC alloc]initWithModel:self.teamModel];
        [_categoryVCs addObject:vc1];
        [_categoryVCs addObject:vc2];
        [_categoryVCs addObject:vc3];
        [_categoryVCs addObject:vc4];
        [_categoryVCs addObject:vc5];
        
    }
    return _categoryVCs;
}

- (NSArray*)categoryVCClassNames{
    return @[@"QukanTeamNewsVC",@"QukanTeamScheduleVC",@"QukanTeamPlayerVC",@"QukanTeamStatisticsVC",@"QukanTeamDetailInfoVC"];
}

- (NSArray*)categoryTitleNames{
    return @[@"新闻",@"赛程",@"球员",@"统计",@"资料"];
}

-(JXCategoryTitleView *)categoryView{
    if(!_categoryView){
        JXCategoryTitleView* categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.headerView.frame), kScreenWidth, 46)];
        categoryView.delegate = self;
        categoryView.titles = self.categoryTitleNames;
        categoryView.titleColor = HEXColor(0xb5b5b5);
        categoryView.titleSelectedColor = kThemeColor;
        categoryView.titleColorGradientEnabled = YES;
        categoryView.titleFont = [UIFont boldSystemFontOfSize:14];
        categoryView.titleSelectedFont = [UIFont boldSystemFontOfSize:15];
        _categoryView = categoryView;
        categoryView.backgroundColor = kCommonBlackColor;
        categoryView.defaultSelectedIndex = 1;
        
        JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
        lineView.indicatorColor = kThemeColor;
        lineView.indicatorWidth = 60;
        lineView.verticalMargin = 0;
        categoryView.indicators = @[lineView];
        
        categoryView.contentScrollViewClickTransitionAnimationEnabled = NO;
        self.listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_CollectionView delegate:self];
        [self.view addSubview:self.listContainerView];
        //关联cotentScrollView，关联之后才可以互相联动！！！
        self.categoryView.listContainer = self.listContainerView;
        
    }
    return _categoryView;
}

- (UIView *)headerView{
    if(!_headerView){
        _headerView = [UIView new];
        _headerView.backgroundColor = kThemeColor;
        [_headerView addSubview:_backBtn = [UIButton new]];
        [_headerView addSubview:_followBtn = [UIButton new]];
        _followBtn.hidden = YES;
        
        [_headerView addSubview:_zqbgImgV = [UIImageView new]];
        [_headerView addSubview:_teamFlagImgV = [UIImageView new]];
        [_headerView addSubview:_teamNameLabel = [UILabel new]];
        [_headerView addSubview:_rankLabel_t = [UILabel new]];
        //        [_headerView addSubview:_teamWorthLabel_t = [UILabel new]];
        [_headerView addSubview:_recentRecord_t = [UILabel new]];
        [_headerView addSubview:_rankLabel = [UILabel new]];
        //        [_headerView addSubview:_teamWorthLabel = [UILabel new]];
        [_headerView addSubview:_recentRecord = [UILabel new]];
        
    }
    return _headerView;
}

@end
