//
//  QukanFTPlayerSubDataVC.m
//  Qukan
//
//  Created by Charlie on 2019/12/31.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanFTPlayerSubDataVC.h"
#import "QukanApiManager+FTAnalysis.h"
#import "QukanFTPlayerGoalModel.h"
#import "QukanMemberDataItemCell.h"
#import "QukanMemberSubDataHeader.h"

@interface QukanFTPlayerSubDataVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong) UICollectionView* collectionView;
@property(nonatomic,strong) NSMutableArray<NSMutableArray*>* dataSource;
@property(nonatomic,strong) NSArray<NSArray<NSString*>*>* titles;

@property(nonatomic,strong) NSDictionary* dataDic;

@end

@implementation QukanFTPlayerSubDataVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    // Do any additional setup after loading the view.
}

- (void)configWithData:(NSArray*)dataFromSever{
    if (dataFromSever.count) {
        [self.dataSource[0] removeAllObjects];
        [self.dataSource[0] addObjectsFromArray:dataFromSever];
    }
    self.dataDic = dataFromSever.lastObject;
    [self.collectionView reloadData];
}


#pragma mark ===================== collectionView delegate ==================================
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QukanMemberDataItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QukanMemberDataItemCell" forIndexPath:indexPath];
//    cell.model = self.leagueArray[indexPath.row];
//    cell.contentView.backgroundColor = UIColor.greenColor;
    cell.titleLabel.text = self.titles[indexPath.section][indexPath.row];
    cell.dataLabel.text = [self dataForCellAtSection:indexPath.section row:indexPath.row];
    
    cell.contentView.backgroundColor = indexPath.section == 2? RGBSAMECOLOR(242):UIColor.clearColor;
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

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
////    QukanBtSclassHotModel *model = self.leagueArray[indexPath.row];
////    CGFloat width=[(NSString *)model.xshort boundingRectWithSize:CGSizeMake(1000, 22) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.width;
//    return CGSizeMake((kScreenWidth-40)/3.0, 60);
//
//}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *supplementaryView;
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        QukanMemberSubDataHeader *header = (QukanMemberSubDataHeader *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"QukanMemberSubDataHeader" forIndexPath:indexPath];
        header.label_1.text = @[@"常规数据",@"防守数据",@"进攻数据"][indexPath.section];
        supplementaryView = header;
        
    }
    
    return supplementaryView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    return CGSizeMake(screenWidth, 35);
}


#pragma mark ===================== Getter ==================================
-(UICollectionView *)collectionView{
    if(!_collectionView){
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc]init];
//        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        layout.minimumLineSpacing = 0.01;
        layout.minimumInteritemSpacing = 0.01;
        layout.itemSize = CGSizeMake((kScreenWidth-0.3)/3.0, 78);
//        layout.minimumLineSpacing = 10;
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
        [_collectionView registerClass:[QukanMemberDataItemCell class] forCellWithReuseIdentifier:@"QukanMemberDataItemCell"];
        [_collectionView registerClass:[QukanMemberSubDataHeader class] forSupplementaryViewOfKind: UICollectionElementKindSectionHeader withReuseIdentifier:@"QukanMemberSubDataHeader"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        
        _collectionView.backgroundColor = kCommonWhiteColor;
    }
    return _collectionView;
}


- (NSString*)dataForCellAtSection:(NSInteger)section row:(NSInteger)row{
    NSNumber* str1 = nil;
    NSNumber* str2 = nil;
    NSDictionary* dic = self.dataDic;
    if(!dic){
        return @"--";
    }
    if(section == 0){
        str1 = [dic objectForKey:@[@"schSum", @"backSum", @"penaltyGoals", @"red",@"yellow",@"offside",@"bestSum",@"rating"][row]];
        str2 = [dic objectForKey:@[@"goals",  @"",        @"",             @"",   @"",      @"",       @"",       @""]      [row]];
    }else if(section == 1){
        
        str1 = [dic objectForKey:@[@"shots",       @"assist", @"totalPass", @"keyPass", @"longBall",     @"throughBall",    @"dribblesSuc",@"wasFouled",@"crossNum"][row]];
        str2 = [dic objectForKey:@[@"shotsTarget", @"",       @"passSuc",   @"",        @"longBallsSuc", @"throughBallSuc", @"",           @"",         @"crossSuc"][row]];
    }else{
    
        str1 = [dic objectForKey:@[@"fouls",@"interception",@"shotsBlocked",@"dispossessed",@"turnOver",@"tackle",@"aerialSuc",@"clearance",@"nothing"][row]];
        str2 = [dic objectForKey:@[@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""][row]];
    }
    if(!str1){//第三分区最后一个cell
        return @"";
    }
    if(section == 0 && row == 7){
       return [NSString stringWithFormat:@"%.1f",str1.floatValue];

    }
    return FormatString(@"%@%@",[str1 stringValue],str2? [@"/" stringByAppendingString:str2.stringValue]:@"");
}

- (NSArray<NSArray<NSString *> *> *)titles{
    return @[
             @[@"首发/进球", @"替补", @"点球", @"红牌", @"黄牌", @"越位", @"最佳球员", @"评分"],
             @[@"射门/射正", @"助攻", @"传球/成功", @"关键传球", @"长传/精准长传", @"直塞/精准直塞", @"带球摆脱", @"被犯规", @"横传/横传成功"],
             @[@"犯规", @"拦截", @"封堵", @"抢断", @"失误", @"铲断", @"头球", @"解围",@""]
             ];
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
