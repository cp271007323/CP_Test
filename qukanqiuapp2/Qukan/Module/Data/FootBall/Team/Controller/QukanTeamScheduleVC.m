//
//  QukanTeamScheduleVC.m
//  Qukan
//
//  Created by Charlie on 2019/12/31.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanTeamScheduleVC.h"

#import "QukanFTMatchScheduleModel.h"
#import "QukanApiManager+FTAnalysis.h"
#import "QukanTeamScoreModel.h"
#import "QukanTeamScheduleCell.h"
#import "QukanNSDate+Time.h"
#import "QukanNSDate+Extensions.h"
#import "QukanDetailsViewController.h"
#import "QukanMatchInfoModel.h"

#import "QukanUIViewController+Ext.h"
#import "QukanFootTool.h"

@interface QukanTeamScheduleVC () <UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property(nonatomic,strong) UITableView* mTab;
@property(nonatomic,strong) NSMutableArray< NSMutableDictionary<NSString*,NSMutableArray*>*>* totalArray ;
@property(nonatomic,strong) NSIndexPath* showIndexPath; //显示当前的cell

@property(nonatomic,assign) NSInteger requestStatus; //-1 未请求 0请求报错  1请求成功
@property(nonatomic,copy) NSString* errorMsg; //-1 未请求 0请求报错  1请求成功

@end

@implementation QukanTeamScheduleVC

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
    [self requestTeamSchedule];
    
}

- (void)requestTeamSchedule {
    KShowHUD
    QukanTeamScoreModel* model = (QukanTeamScoreModel*) self.myModel;
    
    NSString* season = model.season;
    
    NSDictionary*params = @{@"type":@(1),@"teamId":model.teamId, @"season":season};
    @weakify(self)
    [[kApiManager QukanFetchTeamScheduleWithParams:params] subscribeNext:^(NSDictionary *  _Nullable x){
        @strongify(self)
        [self handleData:x];
//        if (x.count) {
//            [self.dataArrays removeAllObjects];
//            [self.dataArrays addObjectsFromArray:x];
//        }
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

- (void)locateToPresent {
    if (self.totalArray.count <= 0){
        return;
    }
    NSInteger section = 0;
    NSInteger row = 0;
    for(int i=0; i < self.totalArray.count && (section + row) == 0; i++){
        NSMutableDictionary<NSString*,NSMutableArray*>* dic = self.totalArray[i];
        NSArray* sectionDatas = dic.allValues.lastObject;
        for(QukanFTMatchScheduleModel* model in sectionDatas){
            if (model.state.integerValue >= 0) {
                section = i;
                row = [sectionDatas indexOfObject:model];
                break;
            }
        }
    }
    [self.mTab scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

-(void)configWithDatas:(NSDictionary*)dataFromServer{
    [self handleData:dataFromServer];
//    self.requestStatus = 1;
    [self.mTab reloadData];
}

- (NSDate *) dateFromFomate:(NSString *)datestring formate:(NSString*)formate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formate];
    NSDate *date = [formatter dateFromString:datestring];
    return date;
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
    NSInteger section = 0;
    NSInteger row = 0;

    NSMutableArray< NSMutableDictionary<NSString*, NSMutableArray*>*>* totalDatas = [NSMutableArray new];
    for(QukanFTMatchScheduleModel* model in allData){
        NSDate* date = [NSDate dateFromFomate:model.start_time formate:kTimeDetail_Format];
        NSString* time = [date formatYM];
        
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
        if(model.state.intValue > 0){//当前进行的
            section = [totalDatas indexOfObject:lastDic];
            row = [sectionArray indexOfObject:model];
            self.showIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
        }
    }
    self.totalArray = totalDatas;
    [self.mTab reloadData];
    dispatch_after(0.3, dispatch_get_main_queue(), ^{
        [self locateToPresent];
//        [self.mTab scrollToRowAtIndexPath:self.showIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    });
//    if(self.showIndexPath){
//        dispatch_after(0.3, dispatch_get_main_queue(), ^{
//            [self.mTab scrollToRowAtIndexPath:self.showIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
//        });
//    }
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
    resultModel.state = orgModel.state.integerValue;
    resultModel.start_time = orgModel.start_time;
    resultModel.season = orgModel.season;
    resultModel.league_id = orgModel.league_id;
    
    return resultModel;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 35)];
    NSDictionary*dic = self.totalArray[section];
    NSString*key = dic.allKeys.lastObject;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = key;
    label.font = kFont14;
    label.backgroundColor = HEXColor(0xececec);
    return label;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary* dic = self.totalArray[section];
    NSString* key = dic.allKeys.lastObject;
    NSArray* array = dic[key];
    return array.count;
    //    return section == 0? self.basicTitles.count : self.tRecords.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.totalArray.count;
    //    NSInteger section = self.tRecords.count>0? 1:0;
    //    return 1 + section;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QukanTeamScheduleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QukanTeamScheduleCell" forIndexPath:indexPath];
    NSDictionary* dic = self.totalArray[indexPath.section];
    NSString* key = dic.allKeys.lastObject;
    NSArray* array = dic[key];
    QukanTeamScoreModel* vcModel = (QukanTeamScoreModel*)self.myModel;
    QukanFTMatchScheduleModel* model = array[indexPath.row];
    model.currentTeamName = vcModel.g;
    [cell setModel:model];
    cell.selectionStyle = 0;
    
    //        cell.titleLabel.text = self.basicTitles[indexPath.row];
    //        cell.contentLabel.text = @[_introModel.nameE,_introModel.nameF,[_introModel.birthday substringToIndex:10],[_introModel.weight stringByAppendingString:@" KG"],[_introModel.tallness stringByAppendingString:@" CM"],_introModel.feet,[_introModel.number stringByAppendingString:@"号球衣"]][indexPath.row];
    //        //        cell.contentView.backgroundColor = UIColor.greenColor;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary* dic = self.totalArray[indexPath.section];
    NSString* key = dic.allKeys.lastObject;
    NSArray* array = dic[key];
    
    QukanFTMatchScheduleModel *scheduleModel = array[indexPath.row];
    
    UIViewController *avc = [self findDesignatedViewController:[QukanDetailsViewController class]];
    QukanFootMatchState state = [QukanFootTool getFootballMatchStateForFlag:scheduleModel.state.integerValue];
    if (avc && state == QukanFootMatchStateMathcing) {
        [self.navigationController popToViewController:avc animated:YES];
    }else {
//        UINavigationController *nav = self.navigationController;
//        [self.navigationController popToRootViewControllerAnimated:NO];
        
        QukanMatchInfoContentModel *model = [QukanFootTool createWithModel:scheduleModel];
        QukanDetailsViewController *vc = [[QukanDetailsViewController alloc] init];
        vc.Qukan_model = model;
        vc.hidesBottomBarWhenPushed = YES;
        // 每次进入详情界面时断开连接
        [[QukanIMChatManager sharedInstance] logOutChat:^(NSError * _Nullable error) {
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
//    [self.navigationController pushViewController:vc animated:YES];
    
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
    [self requestTeamSchedule];
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



//-(NSMutableArray *)dataArrays{
//    if(!_dataArrays){
//        _dataArrays = [NSMutableArray array];
//    }
//    return _dataArrays;
//}

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
        [_mTab registerClass:[QukanTeamScheduleCell class] forCellReuseIdentifier:@"QukanTeamScheduleCell"];
        
        _mTab.estimatedRowHeight = 0.0f;
        _mTab.estimatedSectionFooterHeight = 0.0f;
        _mTab.estimatedSectionHeaderHeight = 0.;
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
