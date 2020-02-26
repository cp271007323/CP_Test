//
//  QukanBasketScreeningTableVC.m
//  Qukan
//
//  Created by leo on 2019/9/12.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanBasketScreeningTableVC.h"
#import "QukanBasketScreenTableModel.h"
#import "QukanNullDataView.h"
#import "QukanScreenCell.h"

@interface QukanBasketScreeningTableVC()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(strong,nonatomic)UICollectionView*Qukan_myCollectionView;
@end


@implementation QukanBasketScreeningTableVC
- (UICollectionView *)Qukan_myCollectionView {
    if (!_Qukan_myCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _Qukan_myCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _Qukan_myCollectionView.backgroundColor = [UIColor clearColor];
        _Qukan_myCollectionView.showsVerticalScrollIndicator = NO;
        _Qukan_myCollectionView.delegate = self;
        _Qukan_myCollectionView.dataSource = self;
        [_Qukan_myCollectionView registerNib:[UINib nibWithNibName:@"QukanScreenCell" bundle:nil] forCellWithReuseIdentifier:@"QukanScreenCell"];
        [self.view addSubview:_Qukan_myCollectionView];
        [_Qukan_myCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _Qukan_myCollectionView;
}
- (NSMutableArray *)Qukan_dataArray {
    if (!_Qukan_dataArray) {
        _Qukan_dataArray = [[NSMutableArray alloc] init];
    }
    return _Qukan_dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self Qukan_myCollectionView];
    [self Qukan_requestData];
}

- (void)Qukan_requestData {
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    @weakify(self);
    NSDictionary *parameters = @{@"ytype":[NSString stringWithFormat:@"%ld", self.Qukan_type],
                                 @"time":[NSString stringWithFormat:@"%ld", self.Qukan_fixDays]};
    
    NSString *urlStr = @"/btLqScore/selectFilterAll";
    if ([self.Qukan_labelFlag isEqualToString:@"1"]) {
        urlStr = @"/btLqScore/selectFilterHot";
    }
    
    [QukanNetworkTool Qukan_POST:urlStr parameters:parameters success:^(NSDictionary *response) {
        @strongify(self)
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        if ([response isKindOfClass:[NSDictionary class]]) {
            if ([response[@"data"] isKindOfClass:[NSArray class]]) {
                NSArray *data = (NSArray *)response[@"data"];
                NSArray *leagueIdsArray = [NSArray array];
                
                if ([self.Qukan_leagueIds isKindOfClass:[NSNumber class]]) {
                    leagueIdsArray = @[[NSString stringWithFormat:@"%ld",[self.Qukan_leagueIds integerValue]]];
                    self.Qukan_leagueIds = [NSString stringWithFormat:@"%ld",[self.Qukan_leagueIds integerValue]];
                } else if (![self.Qukan_leagueIds containsString:@","] && ![self.Qukan_leagueIds isEqualToString:@""]) {//说明只有一个id的时候
                    leagueIdsArray = @[[NSString stringWithFormat:@"%@",self.Qukan_leagueIds]];
                } else {
                    leagueIdsArray = [self.Qukan_leagueIds componentsSeparatedByString:@","];
                }
                self.Qukan_allMatchCount = 0;
                self.Qukan_selectedMatchCount = 0;
                BOOL noSelect = YES;
                for (NSDictionary *d in data) {
                    QukanBasketScreenTableModel *model = [QukanBasketScreenTableModel modelWithDictionary:d];
                    if (self.Qukan_leagueIds.length > 0) {
                        for (NSString *lid in leagueIdsArray) {
                            if (lid.integerValue == model.sclassId) {
                                model.selected = YES;
                                self.Qukan_selectedMatchCount += model.countz;
                                break;
                            }else {
                                model.selected = NO;
                            }
                        }
                    }else {
                        if (model.selected) {
                            self.Qukan_selectedMatchCount += model.countz;
                            noSelect = NO ;
                        }
                    }
                    
                    if((self.Qukan_type == 1)){
                        model.selected = ([self.Qukan_leagueIds length] == 0) || model.selected;
                    }

                    [self.Qukan_dataArray addObject:model];
                    if (model.leagueName.length > 0) {
                        self.Qukan_allMatchCount += model.countz;
                    }
                }
                
                if (noSelect && [self.Qukan_labelFlag isEqualToString:@"0"] && self.Qukan_type != 1 && self.Qukan_leagueIds.length == 0) {
                    for (QukanBasketScreenTableModel *model in self.Qukan_dataArray) {
                        model.selected = YES;
                    }
                }
                
            }
            if (self.Qukan_dataArray.count==0) {
                [QukanNullDataView Qukan_showWithView:self.view contentImageView:@"Qukan_Null_Data" content:@"暂无数据"];
            } else {
                [QukanNullDataView Qukan_hideWithView:self.view];
            }
            [self.Qukan_myCollectionView reloadData];
            [self Qukan_calculateTotalMatchCount];
        }else {
            
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        [self.Qukan_myCollectionView reloadData];
        if (self.Qukan_dataArray.count==0) {
            @weakify(self)
            [QukanFailureView Qukan_showWithView:self.view centerY:-180.0  block:^{
                @strongify(self)
                [self Qukan_netWorkClickRetry];
            }];
        }
    }];
}

- (void)Qukan_netWorkClickRetry {
    [QukanFailureView Qukan_hideWithView:self.view];
    [self Qukan_requestData];
}
- (void)Qukan_allAndReverseSelected:(BOOL)isAllSelected {
    for (QukanBasketScreenTableModel *model in self.Qukan_dataArray) {
        if (isAllSelected) {
            model.selected = YES;
        } else {
            model.selected = !model.selected;
        }
    }
    [self Qukan_calculateTotalMatchCount];
    [self.Qukan_myCollectionView reloadData];
}
- (void)Qukan_calculateTotalMatchCount {
    NSInteger matchCount = 0;
    for (QukanBasketScreenTableModel *model in self.Qukan_dataArray) {
        if (model.selected) {
            matchCount += model.countz;
        }
    }
    self.Qukan_selectedMatchCount = matchCount;
    if (self.Qukan_selectedBlock) {
        self.Qukan_selectedBlock();
    }
}
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (CGRectGetWidth([[UIScreen mainScreen] bounds])-41.0)/3.0;
    return CGSizeMake(width, 28.0);
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.Qukan_dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QukanScreenCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QukanScreenCell" forIndexPath:indexPath];
    
    QukanBasketScreenTableModel *model = self.Qukan_dataArray[indexPath.row];
    [cell Qukan_setBasketData:model];
    return cell;
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    QukanBasketScreenTableModel *model = self.Qukan_dataArray[indexPath.row];
    model.selected = !model.selected;
    [self Qukan_calculateTotalMatchCount];
    [self.Qukan_myCollectionView reloadData];
}

#pragma mark ===================== JXCategoryListContainerViewDelegate ==================================
- (UIView *)listView {
    return self.view;
}

@end


