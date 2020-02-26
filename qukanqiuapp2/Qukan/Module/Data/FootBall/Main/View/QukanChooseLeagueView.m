//
//  QukanChooseLeagueView.m
//  Qukan
//
//  Created by Charlie on 2019/12/28.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanChooseLeagueView.h"

#import "QukanLeagueLeftCell.h" // tabcell
#import "QukanLeagueRightCell.h"  // collectioncell
#import "QukanLeagueRightHeaderView.h"  // collection的header头

//#import "QukanApiManager+MJBallTeam.h"  // 列表网络请求

#define kLeftTabWidth kScaleScreen(100)

@interface QukanChooseLeagueView()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>

//
//@property (strong, nonatomic)  UITableView      *tableView;
@property (assign, nonatomic)  NSInteger        selectMenuIndex;
//
//@property (strong, nonatomic)  UICollectionView *collectionView;
//@property (strong, nonatomic)  NSArray<NSArray*> *datas;
//
//@property (strong, nonatomic)  NSArray<NSString*> *areaLeagueNames;
/**左边的tableview*/
@property (nonatomic, strong) UITableView        * tab_view;
/**右边的collection列表*/
@property (nonatomic, strong) UICollectionView   * collection_view;

/**数据源*/
@property(nonatomic, strong)  NSArray<NSArray *>   * arr_source;

/**判断是往上滑 还是往下滑*/
@property(nonatomic, assign) BOOL   bool_isScrollDown;

@property(nonatomic, strong)  NSArray<NSString *>   * areaNames;
@end

#define kLeftCell @"tableViewCell"
#define kRightCell @"collectionViewCell"


@implementation QukanChooseLeagueView

-(instancetype) initWithFrame:(CGRect)frame dataSource:(nonnull NSArray<NSArray *> *)datas{
    if(self = [super init]){
        [self addSubview:self.tab_view];
        [self addSubview:self.collection_view];
        self.backgroundColor = kCommonWhiteColor;
        
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(18, 0, 150, 40)];
        [self addSubview:label];
        label.text = @"点击切换赛事";
        label.textColor = kThemeColor;
        label.font = kFont15;
        
        UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 40, 0, 40, 40)];
        [self addSubview:btn];
//        [btn setTitle:@"收起" forState:UIControlStateNormal];
        [btn setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
//        btn.titleLabel.font = kFont13;
        [btn setImage:kImageNamed(@"arrow_dropUp") forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];
        
        self.tab_view.delegate = self;
        self.tab_view.dataSource = self;
        self.collection_view.delegate = self;
        self.collection_view.dataSource = self;
        [self layoutViews];
        self.arr_source = datas;
        [self.tab_view reloadData];
    }
    return self;
}

-(void)setSelectMenuIndex:(NSInteger)selectMenuIndex{
    _selectMenuIndex = selectMenuIndex;
//    [self.collection_view reloadData];
}
//
- (void)layoutViews{
    [self.tab_view mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.mas_equalTo(40);
        make.left.bottom.mas_equalTo(0);
        make.width.mas_equalTo(120);
    }];
    self.tab_view.backgroundColor= UIColor.clearColor;

    [self.collection_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(40);

        make.right.bottom.mas_equalTo(0);
        make.left.mas_equalTo(120);
    }];
//    self.collection_view.backgroundColor= UIColor.clearColor;

}

- (void)hideView{
    [UIView animateWithDuration:0.0001 animations:^{
        self.frame = CGRectMake(0, -(CGRectGetHeight(self.frame)), kScreenWidth, CGRectGetHeight(self.frame));
    }];
}

#pragma mark ===================== UI布局 ==================================
- (void)initUI {
    [self addSubview:self.tab_view];
    [self.tab_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self);
        make.width.equalTo(@(100));
    }];
    
    [self addSubview:self.collection_view];
    [self.collection_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self);
        make.left.equalTo(self.tab_view.mas_right);
    }];
    self.collection_view.backgroundColor = HEXColor(0xFAF9F9);
    
}


#pragma mark ===================== network ==================================
//- (void)queryDataFromSever {
//    KShowHUD
//    [[[kApiManager QukanQuertBallTeamList] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
//        if ([x isKindOfClass:[NSArray class]]) {
//            KHideHUD
//            [self.arr_source removeAllObjects];
//            for (NSDictionary *dic in x) {
//                QukanBallTeamModel *model = [QukanBallTeamModel modelWithDictionary:dic];
//                [self.arr_source addObject:model];
//            }
//            [self.tab_view reloadData];
//            [self.collection_view reloadData];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.tab_view selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
//            });
//        }else {
//            kShowTip(@"数据错误");
//        }
//    } error:^(NSError * _Nullable error) {
//        kShowTip(error.localizedDescription);
//    }];
//}


#pragma mark ===================== function ==================================
//- (void)addBtn_releasePostClick {
//    
//}

#pragma mark - collectionView
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    QukanLeagueRightCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QukanLeagueRightCellID" forIndexPath:indexPath];
//    cell.contentView.backgroundColor = HEXColor(0xFAF9F9);
    [cell fullCellWithModel:self.arr_source[indexPath.section][indexPath.row]];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arr_source[section].count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.arr_source.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%zd", indexPath.row);
//    QukanLeagueInfoModel *m = self.arr_source[indexPath.section][indexPath.row];
    //    QukanBallTeamBollingPointListVC *vc = [QukanBallTeamBollingPointListVC new];
    //    vc.model_main = m;
    //    vc.hidesBottomBarWhenPushed = YES;
    //    [self.navigationController pushViewController:vc animated:YES];
    
    if(self.leagueSelectedBlock){
        self.leagueSelectedBlock(indexPath.section, indexPath.row);
        [self hideView];
    };

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kScreenWidth - kLeftTabWidth, 40);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        QukanLeagueRightHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"QukanLeagueRightHeaderViewID" forIndexPath:indexPath];
        //        [header fullHeaderWithMode:self.arr_source[indexPath.section][indexPath.row]];
        header.lab_title.text = self.areaNames[indexPath.section];
        return header;
    }
    
    return nil;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat w = (kScreenWidth - kLeftTabWidth - 1) / 3 ;
    return CGSizeMake(w, 100);
}

#pragma mark ===================== scroller ==================================
// CollectionView分区标题即将展示
- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    //当前CollectionView滚动的方向向上，CollectionView是用户拖拽而产生滚动的（
    if (!self.bool_isScrollDown && collectionView.dragging) {
        [self selectRowAtIndexPath:indexPath.section];
    }
}

// CollectionView分区标题展示结束
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(nonnull UICollectionReusableView *)view forElementOfKind:(nonnull NSString *)elementKind atIndexPath:(nonnull NSIndexPath *)indexPath {
    //当前CollectionView滚动的方向向下，并且是由于用户拖拽而产生滚动的
    if (self.bool_isScrollDown && collectionView.dragging) {
        [self selectRowAtIndexPath:indexPath.section + 1];
    }
}

// 当拖动CollectionView的时候，处理TableView
- (void)selectRowAtIndexPath:(NSInteger)index {
    
    if (self.arr_source.count <= index) {
        return;
    }
    [self.tab_view selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

#pragma mark - UIScrollView Delegate
// 标记一下CollectionView的滚动方向，是向上还是向下
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    static float lastOffsetY = 0;
    if (self.collection_view == scrollView) {
        self.bool_isScrollDown = lastOffsetY < scrollView.contentOffset.y;
        lastOffsetY = scrollView.contentOffset.y;
    }
}

#pragma mark ===================== tabview代理 ==================================
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QukanLeagueLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QukanLeagueLeftCellID"];
    if (!cell) {
        cell = [[QukanLeagueLeftCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QukanLeagueLeftCellID"];
    }
    cell.lab_teamName.text = self.areaNames[indexPath.row];
    //    [cell fullCellWithModel:self.arr_source[indexPath.section]];
    return cell;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arr_source.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes*attributes = [self.collection_view layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.row]];
    CGRect rect = attributes.frame;
    [self.collection_view setContentOffset:CGPointMake(0, rect.origin.y - 40) animated:YES];
}


#pragma mark ===================== lazy ==================================

-(NSArray*)areaNames{
    return @[@"国际杯赛",@"欧洲联赛",@"美洲联赛",@"亚洲联赛",@"大洋洲联赛",@"非洲联赛",@"热门"];
}


- (UITableView *)tab_view {
    if (!_tab_view) {
        _tab_view = [[UITableView alloc] initWithFrame:CGRectZero];
        
        _tab_view.delegate = self;
        _tab_view.dataSource = self;
        _tab_view.tableFooterView = [UIView new];
        _tab_view.rowHeight = 55;
        _tab_view.showsVerticalScrollIndicator = NO;
        
        
        _tab_view.separatorColor = [UIColor clearColor];
        [_tab_view registerClass:[QukanLeagueLeftCell class] forCellReuseIdentifier:@"QukanLeagueLeftCellID"];
    }
    return _tab_view;
}

- (UICollectionView *)collection_view
{
    if (!_collection_view)
    {
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
        //设置滚动方向
        [flowlayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        //左右间距
        flowlayout.minimumInteritemSpacing = 0.f;
        //上下间距
        flowlayout.minimumLineSpacing = 0.f;
        _collection_view = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowlayout];
        _collection_view.delegate = self;
        _collection_view.dataSource = self;
        _collection_view.showsVerticalScrollIndicator = NO;
        _collection_view.showsHorizontalScrollIndicator = NO;
        [_collection_view setBackgroundColor:HEXColor(0xFAF9F9)];
        
        //注册cell
        [_collection_view registerClass:[QukanLeagueRightCell class] forCellWithReuseIdentifier:@"QukanLeagueRightCellID"];
        //注册分区头标题
        [_collection_view registerClass:[QukanLeagueRightHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"QukanLeagueRightHeaderViewID"];
    }
    return _collection_view;
}
//-(NSArray*)areaLeagueNames{
//    return @[@"国际杯赛",@"欧洲联赛",@"美洲联赛",@"亚洲联赛",@"大洋洲联赛",@"非洲联赛",@"热门"];
//}
//
//-(UITableView *)tableView{
//    if(!_tableView){
//        _tableView = [UITableView new];
//        [_tableView registerNib:[UINib nibWithNibName:@"QukanChooseLeftCell" bundle:nil] forCellReuseIdentifier:kLeftCell];
//    }
//    return _tableView;
//}
//
//-(UICollectionView *)collectionView{
//    if(!_collectionView){
//        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//        //设置collectionView滚动方向
//        //    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
//        //设置headerView的尺寸大小
//        //        layout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 100);
//        //该方法也可以设置itemSize
//        layout.itemSize =CGSizeMake(110, 150);
//
//        //2.初始化collectionView
//        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
//        [_collectionView registerNib:[UINib nibWithNibName:@"QukanChooseRightCell" bundle:nil] forCellWithReuseIdentifier:kRightCell];
//    }
//    return _collectionView;
//}
//
//
//#pragma mark - Table View Data Source
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.areaLeagueNames.count;
//    //    return _jsonData.menus.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    QukanChooseLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:kLeftCell forIndexPath:indexPath];
//    //    QukanLeagueInfoModel* model = self
//    cell.label_1.text = self.areaLeagueNames[indexPath.row];
//    if(indexPath.row == 6){
//        self.selectMenuIndex = indexPath.row;
//
//        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
//    }
//    //    Menu *menu = (Menu *)_jsonData.menus[indexPath.row];
//    //    cell.textLabel.text = @(indexPath.row).stringValue;// menu.menuName;
//    //
//    //    cell.textLabel.font = [UIFont systemFontOfSize:12];
//    //    cell.textLabel.textAlignment = NSTextAlignmentCenter;
//    //
//    //    cell.backgroundColor = kMenuColor;
//    //    cell.contentView.backgroundColor = kMenuColor;
//    return cell;
//}
//
//#pragma mark - Table View Delegate
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    QukanChooseLeftCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//
//    // 滚动到顶部
//    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
//
//    self.selectMenuIndex = indexPath.row;
//    //    _selectMenu = (Menu *)_jsonData.menus[_selectMenuIndex];
//
//    [_collectionView reloadData];
//}
//
//#pragma mark - Collection View Data Source
//
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    //    return [[[_jsonData.menus[_selectMenuIndex] groups] objectAtIndex:section] movies].count;
//    return self.datas[_selectMenuIndex].count;// [_selectMenu.groups[section] movies].count;
//}
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    QukanLeagueInfoModel* model = self.datas[_selectMenuIndex][indexPath.row];
//    QukanChooseRightCell *cell = (QukanChooseRightCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kRightCell forIndexPath:indexPath];
//    cell.label_1.text = model.bigShort;
//
//    // 填写数据
//    //    Movie *movie = (Movie *)[[_selectMenu.groups[indexPath.section] movies] objectAtIndex:indexPath.row];
//    //    cell.name.text = @(indexPath.section* 10 + indexPath.row).stringValue;//movie.name;
//    //    cell.picture.backgroundColor = [UIColor grayColor];
//    //    [cell.picture sd_setImageWithURL:[NSURL URLWithString:movie.imageURL]];
//    return cell;
//}
//
//#pragma mark - Collection Flow Layout
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return CGSizeMake(100, 30);
//}
//
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    return UIEdgeInsetsMake(8, 8, 8, 8);
//}
//
//#pragma mark - Collection View Delegate
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    //    XSMutiCatagoryCollectionViewCell * cell = (XSMutiCatagoryCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    if(self.leagueSelectedBlock){
//        self.leagueSelectedBlock(_selectMenuIndex, indexPath.row);
//        [self hideView];
//    }
//    NSLog(@"%d %d %d 被点击", (int)_selectMenuIndex, (int)indexPath.section, (int)indexPath.row);
//}
//
////- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
////    NSString *reusedId;
////    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
////        reusedId = collectionFooterId;
////
////    } else {
////        reusedId = collectionHeaderId;
////        XSHeaderCollectionReusableView *header =  [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:collectionHeaderId forIndexPath:indexPath];
////        header.colorLabel.backgroundColor = [UIColor redColor];
////        header.titleLabel.text = [_selectMenu.groups[indexPath.section] groupName];
////        return header;
////    }
////    return nil;
////}
//
//
//@implementation QukanChooseLeagueView
//
///*
//// Only override drawRect: if you perform custom drawing.
//// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//}
//*/

@end
