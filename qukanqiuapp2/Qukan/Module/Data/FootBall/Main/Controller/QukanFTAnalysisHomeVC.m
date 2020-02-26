//
//  QukanFTAnalysisHomeVC.m
//  Qukan
//
//  Created by Charlie on 2019/12/25.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanFTAnalysisHomeVC.h"
#import "QukanApiManager+FTAnalysis.h"

#import <JXCategoryView/JXCategoryListContainerView.h>

#import "QukanAnalysisListVC.h"

#import <UIViewController+HBD.h>

#import "QukanDataFilterView.h"
#import "MMPickerView.h"
typedef NS_ENUM(NSInteger, AreaType) {
    Area_Hot,
    Area_International,
    Area_Europ  ,
    Area_America  ,
    Area_Asia  ,
    Area_Oceania ,
    Area_Africa,
    Area_Count
};

@interface QukanFTAnalysisHomeVC ()<JXCategoryViewDelegate, JXCategoryListContainerViewDelegate>

@property(nonatomic, strong) JXCategoryTitleView *categoryView;

@property(nonatomic, strong) JXCategoryListContainerView *listContainerView;
@property(nonatomic, strong) UIView *topLeagueListBarView;


@property(nonatomic, copy) NSArray<NSString *> *typeNamse;

@property(nonatomic, assign) NSInteger preSelectedIndex;

@property(nonatomic,strong)NSMutableArray<NSMutableDictionary<NSString*,NSMutableArray*> *>* areaInfoDatas;

@property(nonatomic, strong) NSMutableDictionary<NSString *, id <JXCategoryListContentViewDelegate>> *leagueNameAndVCDic;

@property(nonatomic, assign) AreaType curAreaType;

@property(nonatomic,strong)NSArray* areaLeagueNames;

@property (nonatomic, strong)QukanDataFilterView *filterView;

@end

@implementation QukanFTAnalysisHomeVC

#pragma mark ===================== Life Cycle ==================================
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MMPickerView dismissWithCompletion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        self.edgesForExtendedLayout = UIRectEdgeNone;
    self.hbd_tintColor = kCommonBlackColor;
    
    [self loadLocalAreaCacheData];
    [self layoutViews];
    [self fetchAllAreaDatas];
    self.curAreaType = Area_Hot;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

#pragma mark ===================== Private Methods =========================
- (void)hideFilterView{
    self.filterView.hidden = YES;
}

- (NSMutableArray*)handleAreaData:(NSArray*)originDatas{
    NSMutableArray< NSMutableDictionary<NSString*, NSMutableArray*>*>* totalDatas = [NSMutableArray new];
    for(QukanLeagueInfoModel* model in originDatas){
        if(model.flagHot.intValue == 1){
            NSString* hotKey = @"热门";
            NSInteger hotKeyIndex = -1;
            
            for(NSMutableDictionary* dic in totalDatas){
                if([dic.allKeys containsObject:hotKey]){
                    hotKeyIndex = [totalDatas indexOfObject:dic];
                    break;
                }
            }
            if(hotKeyIndex > -1){
                NSMutableDictionary*dic = totalDatas[hotKeyIndex];
                NSMutableArray* array = dic[hotKey];
                [array addObject:model];
            }else{
                NSMutableArray* array = [NSMutableArray new];
                [array addObject:model];
                NSMutableDictionary* dic = @{hotKey:array}.mutableCopy;
                [totalDatas insertObject:dic atIndex:0];
            }
        }
        
        NSString*key = self.areaLeagueNames[model.areaId.intValue + 1];

        NSInteger keyIndex = -1;
        for(NSMutableDictionary* dic in totalDatas){
            if([dic.allKeys containsObject:key]){
                keyIndex = [totalDatas indexOfObject:dic];
                break;
            }
        }
        NSMutableArray* contantArray;
        if(keyIndex > -1){
            NSMutableDictionary*dic = totalDatas[keyIndex];
            contantArray = dic[key];
            [contantArray addObject:model];
        }else{
            contantArray = [NSMutableArray new];
            [contantArray addObject:model];
            NSMutableDictionary* dic = @{key:contantArray}.mutableCopy;
            [totalDatas addObject:dic];
        }
    }
    return totalDatas;
}

- (void)loadLocalAreaCacheData {
    NSArray*array = [kCacheManager fetechFTAnalysisDataForArea];
    self.areaInfoDatas = [self handleAreaData:array];
    DEBUGLog(@"%@",self.areaInfoDatas);
}

- (void)fetchAllAreaDatas{
    [self fectchAreaDataWithId:@(-1)];
}

- (void)fectchAreaDataWithId:(NSNumber*)areaId {
    @weakify(self)
    [[kApiManager QukanFetchLeagueInfoByAreaId:areaId] subscribeNext:^(NSArray *  _Nullable x) {
        @strongify(self)
        if (!x.count){
            return;
        }
        NSArray* cacheDatas = [kCacheManager fetechFTAnalysisDataForArea];
        if (cacheDatas.count != x.count || cacheDatas.count <= 0) {
            self.areaInfoDatas = [self handleAreaData:x];
            self.curAreaType = self.curAreaType;//刷新数据
        }
        [kCacheManager writeCacheFTAnalysisDatas:x];
//        [self.view dismissHUD];

    } error:^(NSError * _Nullable error) {
//        [self.view dismissHUD];
    }];
}

- (void)showFitlerViewAction {
    self.filterView.hidden = NO;
}

#pragma mark ===================== Layout ====================================

- (void)layoutViews {
    [self.view addSubview:self.topLeagueListBarView];
    [self.topLeagueListBarView addSubview:self.categoryView];
    
    [self.listContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.topLeagueListBarView.mas_bottom);
    }];
 
}

#pragma mark - UIPopoverPresentationControllerDelegate

// 即将要呈现 popover 时通知代理。
- (void)prepareForPopoverPresentation:(UIPopoverPresentationController *)popoverPresentationController {
    NSLog(@"%@",NSStringFromSelector(_cmd));
}

// Called on the delegate when the popover controller will dismiss the popover. Return NO to prevent the dismissal of the view.
- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    NSLog(@"%@",NSStringFromSelector(_cmd));
    return YES;
}

// Called on the delegate when the user has taken action to dismiss the popover. This is not called when the popover is dimissed programatically.
- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    NSLog(@"%@",NSStringFromSelector(_cmd));
}

// -popoverPresentationController:willRepositionPopoverToRect:inView: is called on your delegate when the
// popover may require a different view or rectangle.
// 告诉代理 UIKit 需要重新定位 popover 的位置。
- (void)popoverPresentationController:(UIPopoverPresentationController *)popoverPresentationController willRepositionPopoverToRect:(inout CGRect *)rect inView:(inout UIView  * __nonnull * __nonnull)view {
    NSLog(@"%@",NSStringFromSelector(_cmd));
    
}

/**
 *  在默认的情况下,UIPopoverPresentationController 会根据是否是 iphone 和 ipad 来选择弹出的样式,如果当前的设备是 iphone ,那么系统会选择 modal 样式,并弹出到全屏.如果我们需要改变这个默认的行为,则需要实现代理,在代理 - adaptivePresentationStyleForPresentationController: 这个方法中返回一个 UIModalPresentationNone 样式
 */
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}


#pragma mark ===================== JXCategoryViewDelegate ==================================

//点击选中或者滚动选中都会调用该方法。适用于只关心选中事件，不关心具体是点击还是滚动选中的。
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    self.preSelectedIndex = index;
    [MMPickerView dismissWithCompletion:nil];
}

//点击选中的情况才会调用该方法
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    
}

//滚动选中的情况才会调用该方法
- (void)categoryView:(JXCategoryBaseView *)categoryView didScrollSelectedItemAtIndex:(NSInteger)index {
    
}

- (void)categoryView:(JXCategoryBaseView *)categoryView scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio {
    
}

#pragma mark ===================== JXCategoryListContainerViewDelegate ==================================

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return [self areaInfosByType:_curAreaType].count;
}

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    
    QukanLeagueInfoModel *model = [self areaInfosByType:_curAreaType][index];
    QukanAnalysisListVC * vc = (QukanAnalysisListVC *)_leagueNameAndVCDic[model.gbShort];
    DEBUGLog(@"fetech-----QukanAnalysisListVC----%@",vc);
    
    return vc;
}

#pragma mark ===================== JXCategoryListContentViewDelegate ==================================
- (UIView *)listView {
    return self.view;
}


#pragma mark ===================== Setters =================================

-(void)setCurAreaType:(AreaType)curAreaType{
    _curAreaType = curAreaType;
    
    NSMutableArray* areaInfos = [self areaInfosByType:curAreaType];
    NSMutableDictionary* dic = [NSMutableDictionary new];
    
    [areaInfos enumerateObjectsUsingBlock:^(QukanLeagueInfoModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QukanAnalysisListVC* vc = [[QukanAnalysisListVC alloc] initWithLeagueInfo:obj];
        [dic setObject:vc forKey:obj.gbShort];
        DEBUGLog(@"create-----QukanAnalysisListVC----%@",vc);

    }];
    
    self.leagueNameAndVCDic = dic;
    
    NSArray* titles = [areaInfos.rac_sequence map:^id (QukanLeagueInfoModel* value) {
        return value.gbShort;
    }].array;
    
    self.categoryView.titles = titles;
    [self.categoryView reloadData];
    [self.listContainerView reloadData];

}

#pragma mark ===================== Getters =================================

-(NSArray*)areaLeagueNames{
    return @[@"热门",@"国际杯赛",@"欧洲联赛",@"美洲联赛",@"亚洲联赛",@"大洋洲联赛",@"非洲联赛"];
}

-(QukanDataFilterView *)filterView{
    @weakify(self)
    if(!_filterView){
        _filterView = [[QukanDataFilterView alloc]initWithFrame:CGRectMake(0, kTopBarHeight, kScreenWidth, kScreenHeight-kTopBarHeight) block:^(id filterId) {
            @strongify(self)
            if([filterId isKindOfClass:[NSIndexPath class]]){
                NSIndexPath* indexPath = (NSIndexPath*)filterId;
                self.curAreaType = indexPath.section;
                [self.categoryView selectCellAtIndex:indexPath.row selectedType:JXCategoryCellSelectedTypeCode];
            }
            self.filterView.hidden = YES;
        }];
        _filterView.hidden = NO;
        [_filterView configFtDatas:self.areaInfoDatas];
        [kwindowLast addSubview:_filterView];

    }
    return _filterView;
}

-(NSMutableArray<NSMutableDictionary<NSString *,NSMutableArray *> *> *)areaInfoDatas{
    if(!_areaInfoDatas){
        _areaInfoDatas = [NSMutableArray array];
    }
    return _areaInfoDatas;
}

- (NSMutableArray*) areaInfosByType:(AreaType)type{
    NSString* key = self.areaLeagueNames[type];
    if(self.areaInfoDatas.count){
        NSInteger index = 0;
        for(NSMutableDictionary* dic in self.areaInfoDatas){
            if([dic.allKeys.lastObject isEqualToString:key]){
                index = [self.areaInfoDatas indexOfObject:dic];
                break;
            }
        }
        NSDictionary* resultDic = self.areaInfoDatas[index];
        return resultDic[key];

    }
    return @[].mutableCopy;
}

-(JXCategoryTitleView *)categoryView{
    
    if(!_categoryView){
        JXCategoryTitleView* categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-40, 40)];
        categoryView.delegate = self;
        NSArray* areaInfo = [self areaInfosByType:Area_Hot];
        categoryView.titles =  [areaInfo.rac_sequence map:^id _Nullable(QukanLeagueInfoModel * _Nullable value) {
            return value.gbShort;
        }].array;
        categoryView.titleColor = [UIColor colorWithWhite:0 alpha:1];
        categoryView.titleSelectedColor = kThemeColor;
        categoryView.titleColorGradientEnabled = YES;
        categoryView.titleFont = [UIFont boldSystemFontOfSize:14];
        categoryView.titleSelectedFont = [UIFont boldSystemFontOfSize:15];
        NSInteger index = 0;
        for(QukanLeagueInfoModel* model in areaInfo){
            if([model.gbShort isEqualToString:@"英超"]){
                index = [areaInfo indexOfObject:model];
                break;
            }
        }
        categoryView.defaultSelectedIndex = index;
        //        [self.view addSubview:categoryView];
        _categoryView = categoryView;
        
        JXCategoryIndicatorTriangleView *lineView = [[JXCategoryIndicatorTriangleView alloc] init];
        lineView.indicatorColor = kThemeColor;
        lineView.indicatorWidth = 14;
        lineView.indicatorHeight = 5;
        lineView.verticalMargin = 0;
        categoryView.indicators = @[lineView];
        
        categoryView.contentScrollViewClickTransitionAnimationEnabled = NO;
        categoryView.contentScrollView.scrollEnabled = NO;
        self.listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_CollectionView delegate:self];
        [self.view addSubview:self.listContainerView];
        //关联cotentScrollView，关联之后才可以互相联动！！！
        self.categoryView.listContainer = self.listContainerView;
        
        self.preSelectedIndex = 0;
    }
    return _categoryView;
}

- (UIView *)topLeagueListBarView {
    if (!_topLeagueListBarView) {
        _topLeagueListBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        _topLeagueListBarView.backgroundColor = kCommonWhiteColor;
        
        UIButton *showFitlerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        showFitlerBtn.frame = CGRectMake(kScreenWidth-48, 0, 48, 40);
        [showFitlerBtn setImage:[kImageNamed(@"kqds_data_tab_more_sel") imageByRotate180] forState:UIControlStateNormal];

//        [showFitlerBtn setImage:kImageNamed(@"arrow_dropDown") forState:UIControlStateNormal];
//        menuBtn.backgroundColor = kCommonWhiteColor;
        [_topLeagueListBarView addSubview:showFitlerBtn];
        @weakify(self)
        [[showFitlerBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [self showFitlerViewAction];
        }];
    }
    return _topLeagueListBarView;
}

@end
