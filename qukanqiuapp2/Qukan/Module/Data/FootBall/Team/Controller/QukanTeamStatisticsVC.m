//
//  QukanTeamStatisticsVC.m
//  Qukan
//
//  Created by Charlie on 2019/12/31.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanTeamStatisticsVC.h"

#import "QukanApiManager+FTAnalysis.h"
#import "QukanMemberDataItemCell.h"
#import "QukanMemberSubDataHeader.h"
#import "QukanTeamScoreModel.h"
#import "QukanMemberColvCutLineFooter.h"

@interface QukanTeamStatisticsVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong) UICollectionView* collectionView;
@property(nonatomic,strong) NSMutableArray<NSDictionary*>* dataSource;
@property(nonatomic,strong) NSArray<NSArray<NSString*>*>* titles;

@property(nonatomic,strong) NSDictionary* dataDic;
@property(nonatomic,assign) NSInteger sence;
@property(nonatomic,assign) NSInteger goals;    //服务器返回的球队进球数，不一定准确，如果没有则自己统计所有球员的进球总和

@end

@implementation QukanTeamStatisticsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(!self.dataSource.count){
        [self requestPlayerInfo];
    }
}

- (void) requestPlayerInfo{
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
            NSArray* players = [x objectForKey:@"list"];
            NSInteger svGoals =  [[x objectForKey:@"haveTo"] intValue];
            self.goals = svGoals > 0? svGoals:0;
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:players];
        }
        [self.collectionView reloadData];
        KHideHUD
    } error:^(NSError * _Nullable error) {
        DEBUGLog(@"%@",error);
        @strongify(self)

        KHideHUD
//        [self.view showTip:@"加载失败"];
        [self.collectionView reloadData];

    }];
}

- (void)setTeamSence:(NSInteger)sence{
    _sence = sence;
}


#pragma mark ===================== collectionView delegate ==================================
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QukanMemberDataItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QukanMemberDataItemCell" forIndexPath:indexPath];
    cell.titleLabel.text = self.titles[indexPath.section][indexPath.row];
    cell.dataLabel.text = [self dataForCellAtSection:indexPath.section row:indexPath.row];
//    cell.contentView.backgroundColor = RGBSAMECOLOR(245);
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.titles[section].count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.titles.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{

    UICollectionReusableView *supplementaryView;

    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        QukanMemberSubDataHeader *header = (QukanMemberSubDataHeader *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"QukanMemberSubDataHeader" forIndexPath:indexPath];
        [header.label_1 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.bottom.mas_equalTo(0);
        }];
        header.label_1.font = [UIFont boldSystemFontOfSize:16];
        header.backgroundColor = RGBSAMECOLOR(255);
        header.label_1.text = @[@"进攻",@"组织",@"防守",@"纪律"][indexPath.section];
        supplementaryView = header;
    }
    else{
        QukanMemberColvCutLineFooter *footer = (QukanMemberColvCutLineFooter *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"QukanMemberColvCutLineFooter" forIndexPath:indexPath];
        supplementaryView = footer;

    }
    return supplementaryView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    return CGSizeMake(screenWidth, 50);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(kScreenWidth, 1);
}

#pragma mark ===================== Getter ==================================
-(NSMutableArray<NSDictionary *> *)dataSource{
    if(!_dataSource){
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

-(UICollectionView *)collectionView{
    if(!_collectionView){
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc]init];
        //        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        layout.minimumLineSpacing = 0.01;
        layout.minimumInteritemSpacing = 0.01;
        layout.itemSize = CGSizeMake((kScreenWidth-0.3)/4.0, 78);
//        layout.footerReferenceSize = CGSizeMake(kScreenWidth,1);
        //        layout.minimumLineSpacing = 10;
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
        [_collectionView registerClass:[QukanMemberDataItemCell class] forCellWithReuseIdentifier:@"QukanMemberDataItemCell"];
        [_collectionView registerClass:[QukanMemberSubDataHeader class] forSupplementaryViewOfKind: UICollectionElementKindSectionHeader withReuseIdentifier:@"QukanMemberSubDataHeader"];
        [_collectionView registerClass:[QukanMemberColvCutLineFooter class] forSupplementaryViewOfKind: UICollectionElementKindSectionFooter withReuseIdentifier:@"QukanMemberColvCutLineFooter"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        
        _collectionView.backgroundColor = kCommonWhiteColor;
    }
    return _collectionView;
}

- (NSString*)dataForCellAtSection:(NSInteger)section row:(NSInteger)row{
    NSString* key = nil;
    if(section == 0){
        key = @[@"goals", @"penaltyGoals", @"shots", @"shotsTarget"][row];
    }else if(section == 1){
        key = @[@"totalPass", @"passSuc", @"keyPass"][row];
    }else if(section == 2){
        key = @[@"turnOver",@"tackle",@"interception",@"clearance"][row];
    }else{
        key = @[@"fouls",@"yellow",@"red"][row];
    }
    if(!key){//第三分区最后一个cell
        return @"0";
    }
    NSInteger total = [self numberForKey:key];
    NSString*result = @(total).stringValue;

    
    QukanTeamScoreModel* model = self.myModel;
    NSInteger useSence = self.sence > model.scene.intValue?  self.sence:model.scene.intValue;
    if(section == 0){
        if(row == 2){
            result = useSence <= 0? @"0" : [NSString stringWithFormat:@"%.1f",total*1.0/useSence];

        }else if(row == 3){
            result = useSence <= 0? @"0" : [NSString stringWithFormat:@"%.1f",total*1.0/useSence];

        }
    }else if(section ==1){
        if(row == 0){
            result = useSence <= 0? @"0" : [NSString stringWithFormat:@"%.1f",total*1.0/useSence];

        }else if(row == 1){
            NSInteger totalPas = [self numberForKey:@"totalPass"];
            NSInteger suc = [self numberForKey:@"passSuc"];
            totalPas = totalPas <= 0? 1:totalPas;
            result = [NSString stringWithFormat:@"%.1f%%",suc*100.0/totalPas];
        }
    }
    if([key isEqualToString:@"goals"] && self.goals > 0){
        result =  @(self.goals).stringValue;
    }
    return result;
}

- (NSInteger) numberForKey:(NSString*)key{
    NSInteger sum = 0;
    for(NSDictionary* dic in self.dataSource){
        sum += [dic[key] floatValue];
    }
    return sum;
}

- (NSArray<NSArray<NSString *> *> *)titles{
    return @[
             @[@"进球", @"点球", @"场均射门", @"场均射正"],
             @[@"场均传球", @"传球成功率", @"关键传球"],
             @[@"失误", @"铲断", @"拦截", @"解围"],
             @[@"犯规", @"黄牌", @"红牌"]
             ];
}


@end
