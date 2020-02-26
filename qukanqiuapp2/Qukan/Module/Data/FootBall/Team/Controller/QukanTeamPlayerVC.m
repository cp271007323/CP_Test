//
//  QukanTeamPlayerVC.m
//  Qukan
//
//  Created by Charlie on 2020/1/2.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanTeamPlayerVC.h"

#import "QukanMemberSimpleCell.h"
#import "QukanFTPlayerGoalModel.h"
#import "QukanApiManager+FTAnalysis.h"
#import "QukanFTSubPlayerSimpleHeader.h"
#import "QukanTeamScoreModel.h"
#import "QukanFTPlayerDetailVC.h"

@interface QukanTeamPlayerVC () <UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property(nonatomic,strong) UITableView* mTab;
@property(nonatomic,strong) NSMutableArray<NSDictionary*> * dataArrays ;
@property(nonatomic,strong) NSDictionary* coachDic;

@property(nonatomic,assign) NSInteger requestStatus; //-1 未请求 0请求报错  1请求成功
@property(nonatomic,copy) NSString* errorMsg; //-1 未请求 0请求报错  1请求成功

@end

@implementation QukanTeamPlayerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.requestStatus = -1;
    // Do any additional setup after loading the view.
    [self.view addSubview:self.mTab];
    [self.mTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(0);
        make.right.offset(0);
        make.bottom.offset(0);
    }];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(!self.dataArrays.count){
        [self requestTeamPlayers];
    }
}

- (void)requestTeamPlayers {
    KShowHUD
    QukanTeamScoreModel* model = (QukanTeamScoreModel*) self.myModel;
    
    NSString* season = model.season;// [self.chooseSeasonBtn titleForState:UIControlStateNormal];
    if([season containsString:@"/"]){
        NSArray* strs = [season componentsSeparatedByString:@"/"];
        season = FormatString(@"20%@-20%@",strs[0],strs[1]);
    }
    
    NSDictionary*params = @{@"teamId":model.teamId, @"season":season, @"leagueId":model.leagueId};
    @weakify(self)
    [[kApiManager QukanFetchPlayerAnalysisSubDataWithParams:params] subscribeNext:^(NSDictionary *  _Nullable x){
        @strongify(self)
        if (x) {
//            NSMutableArray* fakeDatas = [NSMutableArray arrayWithArray:x];
//            NSMutableDictionary* fakeDic = [NSMutableDictionary dictionaryWithDictionary: x.firstObject];
//            [fakeDic setObject:@"主教练" forKey:@"playerPlace"];
//            [fakeDatas addObject:fakeDic];
            NSArray* svPlayer = [x objectForKey:@"list"];
            NSMutableArray* players = [NSMutableArray new];
            
            for(NSDictionary* dic in svPlayer){
                if([[dic objectForKey:@"playerPlace"] length] > 0 && [dic[@"playerPlace"] isEqualToString:@"主教练"]){
                    self.coachDic = dic;
                }else{
                    [players addObject:dic];
                }
            }
            NSArray *arr1 = [players sortedArrayUsingComparator:^NSComparisonResult(NSDictionary  * obj1, NSDictionary * obj2) {
                
                NSString* value1 = [obj1 objectForKey:@"value"];
                NSString* value2 = [obj2 objectForKey:@"value"];
                return value1.intValue > value2.intValue? NSOrderedAscending:NSOrderedDescending;
            }];
            
            [self.dataArrays removeAllObjects];
            [self.dataArrays addObjectsFromArray:arr1];
        }
        self.requestStatus = 1;
        [self.mTab reloadData];
        KHideHUD
    } error:^(NSError * _Nullable error) {
        DEBUGLog(@"%@",error);
        @strongify(self)
        KHideHUD
        self.requestStatus = 0;
        self.errorMsg = @"加载失败 请稍后再试";// error.localizedDescription;

        [self.mTab reloadData];
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    QukanFTSubPlayerSimpleHeader *header = [[QukanFTSubPlayerSimpleHeader alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 35)];
//    header.label_1.text = section == 0? @"基本资料":@"转会赛季";
//    header.label_2.text = section == 0? @"":@"转会时间";
//    header.label_3.text = section == 0? @"":@"合同到期";
//    header.label_4.text = section == 0? @"":@"来自";
    
//    @property(nonatomic,strong) UILabel* positionLabel;
//    @property(nonatomic,strong) UILabel* goalLabel;
//    @property(nonatomic,strong) UILabel* assistLabel;
//    @property(nonatomic,strong) UILabel* worthLabel;
    
    if(self.coachDic){
        if(section == 0){
            header.nameLabel.text = @"教练";
            header.goalLabel.text = @"";
            header.assistLabel.text = @"";
            header.worthLabel.text = @"";
            header.positionLabel.text = @"";
        }else{
        
            header.nameLabel.text = @"球员";
            header.positionLabel.text = @"位置";
            header.goalLabel.text = @"进球";
            header.assistLabel.text = @"助攻";
            header.worthLabel.text = @"身价";
        }
    }
    
    return header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0 && self.coachDic){
        return 1;
    }
    return self.dataArrays.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.coachDic){
        return 2;
    }
    return 1;
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QukanMemberSimpleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QukanMemberSimpleCell" forIndexPath:indexPath];
    NSDictionary* cellDic;
    if(self.coachDic && indexPath.section == 0){
        cellDic = self.coachDic;
    }else{
        cellDic = self.dataArrays[indexPath.row];

    }
    [cell setDataWithDic:cellDic];
    cell.selectionStyle = 0;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QukanFTPlayerGoalModel*model = [QukanFTPlayerGoalModel new];

    NSDictionary* soureDic = self.dataArrays[indexPath.row];
    model.playerName = soureDic[@"playerName"];
    model.photo = soureDic[@"photo"];
//    model.teamName = soureDic[@"teamName"];
    model.season = soureDic[@"matchSeason"];
    model.playerId = soureDic[@"playerId"];
    model.teamId = soureDic[@"teamId"];
    model.leagueId = soureDic[@"leagueId"];
    QukanFTPlayerDetailVC* vc = [[QukanFTPlayerDetailVC alloc]initWithModel:model];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ===================== DZNEmptyDataSetSource ==================================
// 占位图提示文本
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString* showStr = self.requestStatus > 0?@"暂无数据" : self.errorMsg;
    return [[NSAttributedString alloc] initWithString:showStr attributes:@{NSFontAttributeName : kFont16,NSForegroundColorAttributeName : [UIColor grayColor]}];
}
// 占位图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *imageName = @"Qukan_Null_Data";
    return [UIImage imageNamed:imageName];
}
// 占位图点击效果
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    //    [self Qukan_requestData];
    [self requestTeamPlayers];
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
    return self.requestStatus > -1;
}

- (NSArray*)basicTitles{
    return @[@"英文名", @"繁体名", @"生日", @"体重", @"身高", @"惯用脚", @"球衣"];
}

-(NSMutableArray *)dataArrays{
    if(!_dataArrays){
        _dataArrays = [NSMutableArray array];
    }
    return _dataArrays;
}

- (UITableView *)mTab {
    if (!_mTab) {
        _mTab = [UITableView new];
        _mTab.delegate = self;
        _mTab.dataSource = self;
        _mTab.emptyDataSetSource = self;
        _mTab.emptyDataSetDelegate = self;
        _mTab.showsVerticalScrollIndicator = 0;
        _mTab.separatorStyle = 0;
        _mTab.backgroundColor = kCommonWhiteColor;
        [_mTab registerClass:[QukanMemberSimpleCell class] forCellReuseIdentifier:@"QukanMemberSimpleCell"];
        
        
    }
    return _mTab;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
