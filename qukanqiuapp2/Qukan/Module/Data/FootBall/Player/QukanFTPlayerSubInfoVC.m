//
//  QukanFTPlayerSubInfoVC.m
//  Qukan
//
//  Created by Charlie on 2019/12/31.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanFTPlayerSubInfoVC.h"
#import "QukanMemberBasicInfoCell.h"
#import "QukanGoRecordTableViewCell.h"
#import "QukanFTPlayerGoalModel.h"
#import "QukanApiManager+FTAnalysis.h"
#import "QukanMemberSubDataHeader.h"

@interface QukanFTPlayerSubInfoVC () <UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView* mTab;
@property(nonatomic,strong) NSMutableArray<QukanPlayerTRecordModel*>* tRecords;
@property(nonatomic,strong) QukanMemberIntroModel* introModel;
@property(nonatomic,strong) NSArray* basicTitles;

@property(nonatomic,assign) NSInteger requestStatus; //-1 未请求 0请求报错  1请求成功
@property(nonatomic,copy) NSString* errorMsg; //-1 未请求 0请求报错  1请求成功

@end

@implementation QukanFTPlayerSubInfoVC

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
    [self requesttRecords];
}

- (void)configWithBasicData:(QukanMemberIntroModel*)model{
    _introModel = model;
    [self.mTab reloadData];
}

- (void)requesttRecords {
    KShowHUD
    QukanFTPlayerGoalModel* model = (QukanFTPlayerGoalModel*)self.myModel;
    NSDictionary*params = @{@"playerId":model.playerId};
    @weakify(self)
    [[kApiManager requestPtrWithParams:params] subscribeNext:^(NSArray *  _Nullable x) {
        @strongify(self)
        if (x.count) {
            NSArray *datas = [NSArray modelArrayWithClass:[QukanPlayerTRecordModel class] json:x];
            [self.tRecords removeAllObjects];
            [self.tRecords addObjectsFromArray:datas];
        }
        self.requestStatus = 1;

        [self.mTab reloadData];
        KHideHUD
        
    } error:^(NSError * _Nullable error) {
        DEBUGLog(@"%@",error);
        @strongify(self)
        self.requestStatus = 0;
        self.errorMsg = @"加载失败 请稍后再试";// error.localizedDescription;
        [self.mTab reloadData];

        KHideHUD
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    QukanMemberSubDataHeader *header = [[QukanMemberSubDataHeader alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 35)];
    header.label_1.text = section == 0? @"基本资料":@"转会赛季";
    header.label_2.text = section == 0? @"":@"转会时间";
    header.label_3.text = section == 0? @"":@"转出球队";
    header.label_4.text = section == 0? @"":@"转入球队";

    return header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0? self.basicTitles.count : self.tRecords.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger section = [self.tRecords count] > 0? 1:0;
    return 1 + section;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        QukanMemberBasicInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QukanMemberBasicInfoCell"];
        cell.selectionStyle = 0;
        cell.titleLabel.text = self.basicTitles[indexPath.row];
        cell.contentLabel.text = @"--";

        switch (indexPath.row) {
            case 0: cell.contentLabel.text = [_introModel.nameE length] > 0? _introModel.nameE:@"--"; break;
            case 1: cell.contentLabel.text = [_introModel.nameF length] > 0? _introModel.nameF :@"--"; break;
            case 2: cell.contentLabel.text = [_introModel.birthday length] > 0? [_introModel.birthday substringToIndex:10]:@"--"; break;
            case 3: cell.contentLabel.text = [_introModel.weight length] > 0? [_introModel.weight stringByAppendingString:@" KG"]:@"--"; break;
            case 4: cell.contentLabel.text = [_introModel.tallness length] > 0? [_introModel.tallness stringByAppendingString:@" CM"]:@"--"; break;
            case 5: cell.contentLabel.text = [_introModel.feet length] > 0? _introModel.feet :@"--"; break;
            case 6: cell.contentLabel.text = [_introModel.number length] > 0? [_introModel.number stringByAppendingString:@"号球衣"]:@"--"; break;

        }
        return cell;
    }else{
        QukanGoRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QukanGoRecordTableViewCell"];
        QukanPlayerTRecordModel* model = self.tRecords[indexPath.row];
        cell.selectionStyle = 0;
        cell.seasonLab.text = [model.zhSeason length] > 0? [model.zhSeason substringToIndex:9]:@"--";
        cell.timeLab.text = [model.tTime length] > 0? [model.tTime substringToIndex:10]:@"--";
        cell.fromClubLab.text = [model.teamName length] > 0?model.teamName:@"--";
        cell.toClubLab.text = [model.teamNowName length] > 0?model.teamNowName:@"--";

        return cell;
    }
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
    [self requesttRecords];
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

-(NSMutableArray *)tRecords{
    if(!_tRecords){
        _tRecords = [NSMutableArray array];
    }
    return _tRecords;
}

- (UITableView *)mTab {
    if (!_mTab) {
        _mTab = [UITableView new];
        _mTab.delegate = self;
        _mTab.dataSource = self;
        _mTab.showsVerticalScrollIndicator = 0;
        _mTab.separatorStyle = 0;
        _mTab.backgroundColor = kCommonWhiteColor;
        [_mTab registerClass:[QukanMemberBasicInfoCell class] forCellReuseIdentifier:@"QukanMemberBasicInfoCell"];
        [_mTab registerClass:[QukanGoRecordTableViewCell class] forCellReuseIdentifier:@"QukanGoRecordTableViewCell"];
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
