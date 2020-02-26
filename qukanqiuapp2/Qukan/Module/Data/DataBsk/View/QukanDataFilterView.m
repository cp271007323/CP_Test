//
//  QukanDataFilterView.m
//  Qukan
//
//  Created by blank on 2019/12/29.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanDataFilterView.h"
#import "QukanLeagueInfoModel.h"

#import "QukanFilterCollectionViewCell.h"
#import "QukanFilterCollectionViewHeaderView.h"
#import "QukanFilterCollectionViewFlowLayout.h"
#import "QukanFilterLeftTableViewCell.h"
#import "QukanApiManager+QukanDataBSK.h"
static float kLeftTableViewWidth = 100.f;
static float kCollectionViewMargin = 3.f;

@interface QukanDataFilterView()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegateFlowLayout,
UICollectionViewDataSource>

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) QukanFilterCollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSArray<NSDictionary<NSString*, QukanLeagueInfoModel*>*>* ftDataSource;
@property (nonatomic, assign) NSInteger type; //0-足球 1-篮球
@property (nonatomic, strong) NSArray *areaNames;




@end

@implementation QukanDataFilterView
{
    NSInteger _selectIndex;
    BOOL _isScrollDown;
}
- (instancetype)initWithFrame:(CGRect)frame block:(FilterBlock _Nullable)block {
    if (self = [super initWithFrame:frame]) {
        self.hidden = 1;
        _selectIndex = 0;
        _isScrollDown = YES;
        self.backgroundColor = kCommonWhiteColor;
        [self addSubview:self.topView];
        [self addSubview:self.tableView];
        [self addSubview:self.collectionView];
        [self layoutViews];
        self.leagueBlock = block;
    }
    return self;
}

- (void)hideView{
    if (self.leagueBlock){
        self.leagueBlock(nil);
    }
}

- (void)layoutViews{
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topView.mas_bottom);
        make.left.bottom.mas_equalTo(0);
        make.width.mas_equalTo(kLeftTableViewWidth);
        
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tableView);
        make.right.bottom.mas_equalTo(0);
        make.left.mas_equalTo(kLeftTableViewWidth);
    }];
    
}

- (void)configFtDatas:(NSArray*)ftSource{
    _ftDataSource = ftSource;
    self.type = 0;

    [self.tableView reloadData];
    [self.collectionView reloadData];
    
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                animated:YES
                          scrollPosition:UITableViewScrollPositionNone];
    
}

- (void)QukanLoadBSKFilterData {
    self.type = 1;
    [[[kApiManager QukanSelectSclassList] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        for (NSDictionary *dic in x) {
            [self.dataSource addObject:[QukanBSKDataCountryModel modelWithDictionary:dic]];
        }
        
        [self.tableView reloadData];
        [self.collectionView reloadData];
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                    animated:YES
                              scrollPosition:UITableViewScrollPositionNone];
        
    } error:^(NSError * _Nullable error) {
        
    }];
}
#pragma mark - UITableView DataSource Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_type == 0){
        return self.ftDataSource.count;
    }else{
        return self.dataSource.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QukanFilterLeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Left forIndexPath:indexPath];
    if(_type == 0){
        NSDictionary* dic = self.ftDataSource[indexPath.row];
        cell.name.text = dic.allKeys.lastObject;
    }else{
        QukanBSKDataCountryModel *model = self.dataSource[indexPath.row];
        cell.name.text = model.country;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectIndex = indexPath.row;
    
    // http://stackoverflow.com/questions/22100227/scroll-uicollectionview-to-section-header-view
    // 解决点击 TableView 后 CollectionView 的 Header 遮挡问题。
    [self scrollToTopOfSection:_selectIndex animated:YES];
    
    //    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:_selectIndex] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_selectIndex inSection:0]
                          atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark - 解决点击 TableView 后 CollectionView 的 Header 遮挡问题

- (void)scrollToTopOfSection:(NSInteger)section animated:(BOOL)animated
{
    CGRect headerRect = [self frameForHeaderForSection:section];
    CGPoint topOfHeader = CGPointMake(0, headerRect.origin.y - _collectionView.contentInset.top);
    [self.collectionView setContentOffset:topOfHeader animated:animated];
}

- (CGRect)frameForHeaderForSection:(NSInteger)section
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
    UICollectionViewLayoutAttributes *attributes = [self.collectionView.collectionViewLayout layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
    return attributes.frame;
}

#pragma mark - UICollectionView DataSource Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if(_type == 0){
        return self.ftDataSource.count;
    }else{
        return self.dataSource.count;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(_type == 0){
        NSDictionary* dic = self.ftDataSource[section];
        NSArray* array = dic.allValues.lastObject;
        return array.count;
    }
    QukanBSKDataCountryModel *model = self.dataSource[section];
    return model.btSclassVos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    QukanFilterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier_CollectionView forIndexPath:indexPath];
    if(_type == 0){
        NSDictionary* dic = self.ftDataSource[indexPath.section];
        NSArray* array = dic.allValues.lastObject;
        
        QukanLeagueInfoModel *model = array[indexPath.row];
        cell.name.text = model.gbShort;
        [cell.imageV sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:kImageNamed(@"ft_default_flag")];
    }else{
        
        QukanBSKDataCountryModel *model = self.dataSource[indexPath.section];
        QukanBtSclassVos *bModel = model.btSclassVos[indexPath.row];
        cell.name.text = bModel.xshort;
        [cell.imageV sd_setImageWithURL:[NSURL URLWithString:bModel.logo] placeholderImage:[UIImage imageWithColor:HEXColor(0xdddddd)]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(_type == 0){
        if (self.leagueBlock) {
            self.leagueBlock(indexPath);
        }
    }else{
        QukanBSKDataCountryModel *model = self.dataSource[indexPath.section];
        if (self.leagueBlock) {
            self.leagueBlock(model.btSclassVos[indexPath.row]);
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kScreenWidth - kLeftTableViewWidth - 4 * kCollectionViewMargin) / 3,
                      (kScreenWidth - kLeftTableViewWidth - 4 * kCollectionViewMargin) / 3);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    { // header
        reuseIdentifier = @"CollectionViewHeaderView";
    }
    QukanFilterCollectionViewHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                        withReuseIdentifier:reuseIdentifier
                                                                               forIndexPath:indexPath];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        if(_type == 0){
            NSDictionary*dic = self.ftDataSource[indexPath.section];
            view.title.text = dic.allKeys.lastObject;
        }else{
            QukanBSKDataCountryModel *model = self.dataSource[indexPath.section];
            view.title.text = model.country;
        }
    }
    view.line.hidden = indexPath.section == 0 ? 1 : NO;
    return view;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(kScreenWidth, 60);
}

// CollectionView分区标题即将展示
- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    // 当前CollectionView滚动的方向向上，CollectionView是用户拖拽而产生滚动的（主要是判断CollectionView是用户拖拽而滚动的，还是点击TableView而滚动的）
    if (!_isScrollDown && (collectionView.dragging || collectionView.decelerating))
    {
        [self selectRowAtIndexPath:indexPath.section];
    }
}

// CollectionView分区标题展示结束
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(nonnull UICollectionReusableView *)view forElementOfKind:(nonnull NSString *)elementKind atIndexPath:(nonnull NSIndexPath *)indexPath
{
    // 当前CollectionView滚动的方向向下，CollectionView是用户拖拽而产生滚动的（主要是判断CollectionView是用户拖拽而滚动的，还是点击TableView而滚动的）
    if (_isScrollDown && (collectionView.dragging || collectionView.decelerating))
    {
        [self selectRowAtIndexPath:indexPath.section + 1];
    }
}

// 当拖动CollectionView的时候，处理TableView
- (void)selectRowAtIndexPath:(NSInteger)index
{
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

#pragma mark - UIScrollView Delegate
// 标记一下CollectionView的滚动方向，是向上还是向下
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    static float lastOffsetY = 0;
    
    if (self.collectionView == scrollView)
    {
        _isScrollDown = lastOffsetY < scrollView.contentOffset.y;
        lastOffsetY = scrollView.contentOffset.y;
    }
}



#pragma mark - Setter
- (void)setType:(NSInteger)type{
    _type = type;
}
#pragma mark - Getters

- (UIView *)topView{
    if(!_topView){
        _topView = [UIView new];
        
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(18, 0, 150, 40)];
        [self addSubview:label];
        label.text = @"点击切换赛事";
        label.textColor = kThemeColor;
        label.font = kFont14;
        [_topView addSubview:label];
        
        UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 48, 0, 48, 40)];
        [_topView addSubview:btn];
        [btn setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
        [btn setImage:kImageNamed(@"kqds_data_tab_more_sel") forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];

    }
    return _topView;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource)
    {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.rowHeight = 60;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorColor = [UIColor clearColor];
        [_tableView registerClass:[QukanFilterLeftTableViewCell class] forCellReuseIdentifier:kCellIdentifier_Left];
    }
    return _tableView;
}

- (QukanFilterCollectionViewFlowLayout *)flowLayout
{
    if (!_flowLayout)
    {
        _flowLayout = [[QukanFilterCollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _flowLayout.minimumInteritemSpacing = 2;
        _flowLayout.minimumLineSpacing = 2;
    }
    return _flowLayout;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView setBackgroundColor:HEXColor(0xFAF9F9)];
        [_collectionView registerClass:[QukanFilterCollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier_CollectionView];
        [_collectionView registerClass:[QukanFilterCollectionViewHeaderView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:@"CollectionViewHeaderView"];
    }
    return _collectionView;
}

-(NSArray*)areaNames{
    return @[@"国际杯赛",@"欧洲联赛",@"美洲联赛",@"亚洲联赛",@"大洋洲联赛",@"非洲联赛",@"热门"];
}
@end
