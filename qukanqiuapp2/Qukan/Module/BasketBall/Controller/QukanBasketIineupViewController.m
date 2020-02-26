//
//  QukanBasketIineupViewController.m
//  Qukan
//
//  Created by Kody on 2020/1/2.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanBasketIineupViewController.h"
#import "QukanBasketLineupCollectionViewCell.h"
#import "QukanApiManager+BasketBall.h"
#import "QukanBasketLineupCollectionReusableView.h"
#import "QukanBSKMemberInfoViewController.h"
#import "QukanBSKTeamDetialViewController.h"

#import "QukanBasketBallMatchDetailModel.h"
#import "QukanBasketDetailVC.h"

@interface QukanBasketIineupViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) NSMutableArray *datas;
@property(nonatomic, strong) NSArray <QukanHomeAndGuestPlayerListModel *> *home_array;
@property(nonatomic, strong) NSArray <QukanHomeAndGuestPlayerListModel *> *guest_array;

@property(nonatomic, strong) NSArray<QukanHomeAndGuestPlayerListModel *> *homeFirst_array;
@property(nonatomic, strong) NSArray<QukanHomeAndGuestPlayerListModel *> *guestFirst_array;

@property(nonatomic, strong) NSArray<QukanHomeAndGuestPlayerListModel *> *homeSubstitution_array;
@property(nonatomic, strong) NSArray<QukanHomeAndGuestPlayerListModel *> *guestSubstitution_array;

@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);

@property(nonatomic, weak) QukanBasketBallMatchDetailModel *detailModel;

@end

@implementation QukanBasketIineupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self setData];
}

- (void)initUI {
    self.datas = @[].mutableCopy;
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    QukanBasketDetailVC *vc = (QukanBasketDetailVC *)self.parentViewController.parentViewController;
    NSAssert([vc isKindOfClass:[QukanBasketDetailVC class]], @"未能正确拿到视图控制器");
    self.detailModel = vc.detailModel;
    
    @weakify(self)
    [[[RACObserve(self.detailModel, homePlayerList) distinctUntilChanged] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
        [self.collectionView reloadData];
    }];
}

- (void)setData {
    self.home_array = self.detailModel.homePlayerList;
    self.guest_array = self.detailModel.guestPlayerList;
    
    self.homeFirst_array = [self.home_array.rac_sequence filter:^BOOL(QukanHomeAndGuestPlayerListModel *  _Nullable value) {
        return value.location.length;
     }].array;
    self.homeSubstitution_array = [self.home_array.rac_sequence filter:^BOOL(QukanHomeAndGuestPlayerListModel *  _Nullable value) {
       return !value.location.length;
    }].array;
    
    self.guestFirst_array = [self.guest_array.rac_sequence filter:^BOOL(QukanHomeAndGuestPlayerListModel *  _Nullable value) {
        return value.location.length;
     }].array;
    self.guestSubstitution_array = [self.guest_array.rac_sequence filter:^BOOL(QukanHomeAndGuestPlayerListModel *  _Nullable value) {
        return !value.location.length;
     }].array;
    [self.collectionView reloadData];;
}

#pragma mark ===================== NetWork ==================================

- (void)loadData {
//    @weakify(self)
    [[[kApiManager QukanQueryMatchInfoWithMatchId:self.matchId] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
//       @strongify(self)
        
        DEBUGLog(@"---------%@",x);
        
    } error:^(NSError * _Nullable error) {
//        @strongify(self)
    }];
}

#pragma mark ===================== UICollectionViewDataSource ==================================

// 设置headerView和footerView的
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    NSArray *titles = @[@"首发阵容",@"替补阵容"];
    if (kind == UICollectionElementKindSectionHeader) {
         QukanBasketLineupCollectionReusableView *header= [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"QukanBasketLineupCollectionReusableView" forIndexPath:indexPath];
        [header setDataWithTitle:[titles objectAtIndex:indexPath.section]];
        return header;
    }
    return UICollectionReusableView.new;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.home_array.count && self.guest_array.count ? 2 : 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (!self.homeFirst_array.count) return 0;
    return section == 0 ? self.homeFirst_array.count + self.guestFirst_array.count + 2 : self.homeSubstitution_array.count + self.guestSubstitution_array.count + 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    QukanBasketLineupCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QukanBasketLineupCollectionViewCell" forIndexPath:indexPath];
    QukanHomeAndGuestPlayerListModel *indexModel;
    BOOL isHeader = NO;
    if (indexPath.section == 0) {
        if (indexPath.item % 2 == 0) {//主队
            if (indexPath.item == 0) {
                isHeader = YES;
            } else {
                indexModel = self.guestFirst_array.count > indexPath.item / 2 - 1 ? [self.guestFirst_array objectAtIndex:indexPath.item / 2 - 1] : QukanHomeAndGuestPlayerListModel.new;
            }
        } else {//客队
            if (indexPath.item == 1) {
                isHeader = YES;
            } else {
                indexModel = self.homeFirst_array.count > indexPath.item / 2 - 1 ? [self.homeFirst_array objectAtIndex:indexPath.item / 2 - 1] : QukanHomeAndGuestPlayerListModel.new;
            }
        }
    } else {
        if (indexPath.item % 2 == 0) {
            if (indexPath.item == 0) {
                isHeader = YES;
            } else {
                indexModel = self.guestSubstitution_array.count > indexPath.item / 2 - 1 ? [self.guestSubstitution_array objectAtIndex:indexPath.item / 2 - 1] : QukanHomeAndGuestPlayerListModel.new;
            }
        } else {
            if (indexPath.item == 1) {
                isHeader = YES;
            } else {
                 indexModel = self.homeSubstitution_array.count > indexPath.item / 2 - 1 ? [self.homeSubstitution_array objectAtIndex:indexPath.item / 2 - 1] : QukanHomeAndGuestPlayerListModel.new;
            }
        }
    }
    
    isHeader ? [cell setDataWithModel:self.detailModel withIndex:indexPath.item] : [cell setDataWithModel:indexModel withSection:indexPath.section withIndex:indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 || indexPath.section == 1) {
        if (indexPath.item == 0 || indexPath.item == 1) {
            QukanBSKTeamDetialViewController *vc = [[QukanBSKTeamDetialViewController alloc] init];
            vc.teamId = indexPath.item == 0 ? self.detailModel.guestTeamId : self.detailModel.homeTeamId;
            [self.navgiation_vc pushViewController:vc animated:YES];
        } else {
            QukanBSKMemberInfoViewController *vc = [[QukanBSKMemberInfoViewController alloc] init];
            QukanHomeAndGuestPlayerListModel *indexModel;
            if (indexPath.section == 0) {//首发阵容
                indexModel = indexPath.item % 2 == 0 ? [self.guestFirst_array objectAtIndex:indexPath.item / 2 - 1] : [self.homeFirst_array objectAtIndex:indexPath.item / 2 - 1];
            } else if (indexPath.section == 1) {//替补阵容
                indexModel = indexPath.item % 2 == 0 ? [self.guestSubstitution_array objectAtIndex:indexPath.item / 2 - 1] : [self.homeSubstitution_array objectAtIndex:indexPath.item / 2 - 1];
            }
            vc.playerTeam = indexPath.item % 2 == 0 ? self.detailModel.guestTeam : self.detailModel.homeTeam;
            vc.pid = indexModel.playerId;
            if (self.detailModel.xtype.integerValue == 1) {
                [self.navgiation_vc pushViewController:vc animated:YES];
            }
        }
    }
}

#pragma mark ===================== JXCategoryListContentViewDelegate ==================================
- (UIView *)listView{
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.collectionView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback ?: self.scrollCallback(self.collectionView);
}

#pragma mark ===================== DZNEmptyDataSetSource ==================================

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSString *description = @"暂无数据";
    return [[NSAttributedString alloc] initWithString:description attributes:@{NSFontAttributeName : kFont16,NSForegroundColorAttributeName : [UIColor grayColor]}];
}
//
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *imageName = @"nodata_basketBall";
    return [UIImage imageNamed:imageName];
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    [self setData];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return kCommentBackgroudColor;
}

#pragma mark - DZNEmptyDataSetDelegate
//- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
//    return -kScreenWidth*(212/375.0) / 2;
//}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}


#pragma mark ===================== Getters =================================

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat itemW = (kScreenWidth - 2) / 2;
        CGFloat itemH = 42;
        layout.itemSize = CGSizeMake(itemW, itemH);
        layout.sectionInset = UIEdgeInsetsMake(1, 0, 1, 0);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 1;
        layout.minimumInteritemSpacing = 1;
        
        layout.headerReferenceSize = CGSizeMake(kScreenWidth, 40);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.backgroundColor = HEXColor(0xF5F3F3);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.emptyDataSetSource = self;
        _collectionView.emptyDataSetDelegate = self;
        [_collectionView registerClass:[QukanBasketLineupCollectionViewCell class] forCellWithReuseIdentifier:@"QukanBasketLineupCollectionViewCell"];
        
        [_collectionView registerClass:[QukanBasketLineupCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"QukanBasketLineupCollectionReusableView"];
    }
    return _collectionView;
}


@end
