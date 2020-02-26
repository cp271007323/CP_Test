//
//  QukanFTPlayerDetailVC.m
//  Qukan
//
//  Created by Charlie on 2019/12/31.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanFTPlayerDetailVC.h"

#import <JXCategoryView/JXCategoryListContainerView.h>
#import <UIViewController+HBD.h>

#import "QukanFTPlayerSubDataVC.h"
#import "QukanFTPlayerSubInfoVC.h"
#import "QukanApiManager+FTAnalysis.h"

@interface QukanFTPlayerDetailVC ()<JXCategoryViewDelegate, JXCategoryListContainerViewDelegate>
@property(nonatomic,strong) UIView* headerView;
@property(nonatomic,strong) UIButton* backBtn;
@property(nonatomic,strong) UIButton* followBtn;

@property(nonatomic,strong) UIImageView* zqbgImgV;
@property(nonatomic,strong) UIImageView* avatarImgV;
@property(nonatomic,strong) UILabel* playerNameLabel;

@property(nonatomic,strong) UIView* nationalView;
@property(nonatomic,strong) UILabel* nationalLabel;
@property(nonatomic,strong) UIImageView* nationalFlayImgV;
@property(nonatomic,strong) UILabel* positionLabel;
@property(nonatomic,strong) UILabel* worthLabel;

@property(nonatomic,strong) JXCategoryTitleView* categoryView;
@property(nonatomic,strong) JXCategoryListContainerView* listContainerView;

@property(nonatomic,strong) NSArray* categoryTitleNames;
@property(nonatomic,strong) NSArray* categoryVCClassNames;

@property(nonatomic,strong) NSMutableArray* categoryVCs;

@property(nonatomic,strong) QukanFTPlayerGoalModel* goalModel;
@property(nonatomic,strong) QukanMemberIntroModel* introModel;

@end

@implementation QukanFTPlayerDetailVC

- (instancetype)initWithModel:(QukanFTPlayerGoalModel*)model{
    if(self = [super init]){
        self.goalModel = model;
    }
    return self;
}

- (void)viewDidLoad {
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
    [self requestDataInfo];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestPlayerIntroduce];

}

- (void) requestDataInfo{
    
    NSDictionary*params = @{@"playerId":_goalModel.playerId, @"season":_goalModel.season, @"leagueId":_goalModel.leagueId};
    @weakify(self)
    [[kApiManager QukanFetchPlayerAnalysisSubDataWithParams:params] subscribeNext:^(NSDictionary *  _Nullable x){
        @strongify(self)
        NSArray* players = [x objectForKey:@"list"];
        [self.categoryVCs[0] configWithData:players];
        
    } error:^(NSError * _Nullable error) {
        DEBUGLog(@"%@",error);
//        [self.view showTip:@"加载失败"];
    }];
}

- (void)requestPlayerIntroduce{

    KShowHUD
    NSDictionary*params = @{@"teamId":_goalModel.teamId,@"playerId":_goalModel.playerId};
    @weakify(self)
    [[kApiManager requestPlayerIntroduceInfoWithParams:params] subscribeNext:^(NSArray *  _Nullable x) {
        @strongify(self)
        if (x.count) {
            NSArray *datas = [NSArray modelArrayWithClass:[QukanMemberIntroModel class] json:x];
            self.introModel = datas.lastObject;
            [self updateHeadeWithData:self.introModel];
        }
        KHideHUD
        
    } error:^(NSError * _Nullable error) {
        DEBUGLog(@"%@",error);
        @strongify(self)
        KHideHUD
//        [self.view showTip:@"加载失败"];
    }];
}

- (void)updateHeadeWithData:(QukanMemberIntroModel*)model{
    [self.avatarImgV sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:kImageNamed(@"Player_defaultAvatar")];
    self.playerNameLabel.text = model.nameJ;
    self.nationalLabel.text = model.country;
    self.positionLabel.text = model.place;
    NSString *str = model.value.length ? @"万欧元" : @"";
    self.worthLabel.text = [model.value stringByAppendingString:str];
}

-(void)setModel:(QukanFTPlayerGoalModel *)model{
    _goalModel = model;
    [self.avatarImgV sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:kImageNamed(@"")];
    self.playerNameLabel.text = model.playerName;
    self.positionLabel.text = model.teamName;
}

#pragma mark ===================== JXCategoryListContainerViewDelegate ==================================
- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.categoryTitleNames.count;
}

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {

    return self.categoryVCs[index];
}

- (void)setIntroModel:(QukanMemberIntroModel *)introModel{
    _introModel = introModel;
    QukanFTPlayerSubInfoVC* vc2 = (QukanFTPlayerSubInfoVC*)self.categoryVCs[1];
    [vc2 configWithBasicData:introModel];

}

- (NSMutableArray*)categoryVCs{
    if(!_categoryVCs){
        _categoryVCs = [NSMutableArray array];
        QukanFTPlayerSubDataVC* vc1 = [[QukanFTPlayerSubDataVC alloc] initWithModel:self.goalModel];
        QukanFTPlayerSubInfoVC* vc2 = [[QukanFTPlayerSubInfoVC alloc] initWithModel:self.goalModel];
        [_categoryVCs addObject:vc1];
        [_categoryVCs addObject:vc2];
    }
    return _categoryVCs;
}

- (NSArray*)categoryVCClassNames{
    return @[@"QukanFTPlayerSubDataVC",@"QukanFTPlayerSubInfoVC"];
}

- (NSArray*)categoryTitleNames{
    return @[@"数据",@"资料"];
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
        _headerView.backgroundColor = HEXColor(0x2F2F2F);
        [_headerView addSubview:_backBtn = [UIButton new]];
        [_headerView addSubview:_followBtn = [UIButton new]];
        [_headerView addSubview:_avatarImgV = [UIImageView new]];
        [_headerView addSubview:_zqbgImgV = [UIImageView new]];
        [_headerView addSubview:_playerNameLabel = [UILabel new]];
        [_headerView addSubview:_nationalView = [UIView new]];
        [_nationalView addSubview:_nationalLabel = [UILabel new]];
        [_nationalView addSubview:_nationalFlayImgV = [UIImageView new]];
        [_headerView addSubview:_positionLabel = [UILabel new]];
        [_headerView addSubview:_worthLabel = [UILabel new]];
        
        
    }
    return _headerView;
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
    
//    [_followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(-20);
//        make.centerY.mas_equalTo(_backBtn);
//        make.height.mas_equalTo(22);
//        make.width.mas_equalTo(58);
//    }];
//    [_followBtn setTitle:@"+关注" forState:UIControlStateNormal];
//
//    [_followBtn setImage:kImageNamed(@"") forState:UIControlStateNormal];
//    [[_followBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
//        @strongify(self)
//
//    }];
//    _followBtn.layer.borderWidth = 1;
//    _followBtn.layer.borderColor = kCommonWhiteColor.CGColor;
    
    [_zqbgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(self.zqbgImgV.mas_height);
    }];
    _zqbgImgV.image = kImageNamed(@"bgImg_1");
    
    [_avatarImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
//        make.top.mas_equalTo(self.backBtn.mas_bottom).offset(20);
        make.width.height.mas_equalTo(70);
    }];
    _avatarImgV.backgroundColor = UIColor.lightGrayColor;
    _avatarImgV.layer.masksToBounds = YES;
    _avatarImgV.layer.cornerRadius = 35;
    _avatarImgV.contentMode = UIViewContentModeScaleAspectFit;
    
    [_playerNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.avatarImgV.mas_bottom).offset(5);
        make.height.mas_equalTo(24);
    }];
    
    _playerNameLabel.textColor = kCommonWhiteColor;
    _playerNameLabel.font = [UIFont systemFontOfSize:15];
    _playerNameLabel.textAlignment = NSTextAlignmentCenter;
    _playerNameLabel.text = @"--";
    
    [_nationalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(-23);
        make.width.mas_equalTo((kScreenWidth-2)/3.0);
    }];
    _nationalView.backgroundColor = UIColor.yellowColor;
    
    [_nationalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(-8);
        make.centerY.offset(0);
    }];
    _nationalLabel.textColor = kCommonWhiteColor;
    _nationalLabel.font = [UIFont systemFontOfSize:15];
    _nationalLabel.textAlignment = NSTextAlignmentCenter;
    _nationalLabel.text = @"---";
    
    
    [_nationalFlayImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nationalLabel.mas_right).offset(3);
        make.centerY.mas_equalTo(self.nationalLabel);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    _nationalFlayImgV.backgroundColor = UIColor.lightGrayColor;
    _nationalFlayImgV.hidden = YES;
    
    UIView* sep1 = [UIView new];
    [_headerView addSubview:sep1];
    
    [sep1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nationalView.mas_right);
        make.centerY.mas_equalTo(self.nationalLabel);
        make.height.mas_equalTo(18);
        make.width.mas_equalTo(1);
    }];
    sep1.backgroundColor = kCommonWhiteColor;
    
    [_positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(sep1.mas_right);
        make.centerY.mas_equalTo(self.nationalView);
        make.width.mas_equalTo((kScreenWidth-2)/3.0);
    }];
    _positionLabel.textColor = kCommonWhiteColor;
    _positionLabel.font = [UIFont systemFontOfSize:14];
    _positionLabel.textAlignment = NSTextAlignmentCenter;
    _positionLabel.text = @"--/--";
    
    UIView* sep2 = [UIView new];
    [_headerView addSubview:sep2];
    
    [sep2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.positionLabel.mas_right);
        make.centerY.mas_equalTo(self.nationalLabel);
        make.height.mas_equalTo(18);
        make.width.mas_equalTo(1);
    }];
    sep2.backgroundColor = kCommonWhiteColor;
    
    [_worthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(sep2);
        make.width.mas_equalTo(self.positionLabel);
        make.centerY.mas_equalTo(self.nationalView);
    }];
    _worthLabel.textColor = kCommonWhiteColor;
    _worthLabel.font = [UIFont systemFontOfSize:14];
    _worthLabel.textAlignment = NSTextAlignmentCenter;
    _worthLabel.text = @"---";
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
