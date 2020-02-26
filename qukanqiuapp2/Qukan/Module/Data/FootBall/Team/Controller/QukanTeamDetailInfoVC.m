//
//  QukanTeamDetailInfoVC.m
//  Qukan
//
//  Created by Charlie on 2019/12/31.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanTeamDetailInfoVC.h"
#import "QukanApiManager+FTAnalysis.h"

#import "QukanMemberSubDataHeader.h"
#import "QukanMemberBasicInfoCell.h"
#import "QukanTeamBasicModel.h"
#import "QukanTeamScoreModel.h"


@interface QukanTeamDetailInfoVC () <UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property(nonatomic,strong) UITableView* mTab;
@property(nonatomic,strong) NSMutableArray<NSDictionary*> * dataArrays ;
@property(nonatomic,strong) QukanTeamBasicModel* basicModel ;

@property(nonatomic,assign) NSInteger requestStatus; //-1 未请求 0请求报错  1请求成功
@property(nonatomic,copy) NSString* errorMsg; //-1 未请求 0请求报错  1请求成功


@end

@implementation QukanTeamDetailInfoVC
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.requestStatus = -1;
    [self.view addSubview:self.mTab];
    [self.mTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(0);
        make.right.offset(0);
        make.bottom.offset(0);
    }];
    [self requestTeamBasicInfo];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(!self.dataArrays.count){
    }
}


- (void)requestTeamBasicInfo {
    
    KShowHUD
    QukanTeamScoreModel* model = (QukanTeamScoreModel*) self.myModel;
    
    NSDictionary*params = @{@"teamId":model.teamId};
    @weakify(self)
    [[kApiManager QukanFetchTeamBasicInfoWithParams:params] subscribeNext:^(NSDictionary *  _Nullable x){
        @strongify(self)
        if ([x isKindOfClass:[NSDictionary class]]) {
            self.basicModel = [QukanTeamBasicModel modelWithDictionary:x];
        }
        self.requestStatus = 1;
        [self.mTab reloadData];
        KHideHUD
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        DEBUGLog(@"%@",error);
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
    QukanMemberSubDataHeader *header = [[QukanMemberSubDataHeader alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 35)];
        header.label_1.text = @"球队资料";
    header.label_2.hidden = YES;
    header.label_3.hidden = YES;
    header.label_4.hidden = YES;
    
    return header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.basicModel)
        return 4;
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QukanMemberBasicInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QukanMemberBasicInfoCell" forIndexPath:indexPath];
    cell.titleLabel.text = @[@"所在城市", @"球队主场", @"成立时间", @"主教练"][indexPath.row];
    cell.contentLabel.text = @[self.basicModel.area?:@"--",self.basicModel.gym?:@"--",self.basicModel.found?:@"--",self.basicModel.master?:@"--"][indexPath.row];
    cell.selectionStyle = 0;
    
    //        cell.titleLabel.text = self.basicTitles[indexPath.row];
    //        cell.contentLabel.text = @[_introModel.nameE,_introModel.nameF,[_introModel.birthday substringToIndex:10],[_introModel.weight stringByAppendingString:@" KG"],[_introModel.tallness stringByAppendingString:@" CM"],_introModel.feet,[_introModel.number stringByAppendingString:@"号球衣"]][indexPath.row];
    //        //        cell.contentView.backgroundColor = UIColor.greenColor;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
    [self requestTeamBasicInfo];
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
        _mTab.emptyDataSetDelegate = self;
        _mTab.emptyDataSetSource = self;
        _mTab.showsVerticalScrollIndicator = 0;
        _mTab.separatorStyle = 0;
        _mTab.backgroundColor = kCommonWhiteColor;
        [_mTab registerClass:[QukanMemberBasicInfoCell class] forCellReuseIdentifier:@"QukanMemberBasicInfoCell"];
    }
    return _mTab;
}
@end
