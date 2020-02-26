//
//  QukanAirPlayLandscapeTermView.m
//  dxMovie-ios
//
//  Created by james on 2019/6/7.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanAirPlayLandscapeTermView.h"
#import "QukanAirPlayManager.h"
#import "SDAutoLayout.h"

@interface TermCell : UICollectionViewCell
@property (nonatomic,strong) UIButton *btn;
@property (nonatomic,copy) void(^clickBlock)(void);
@end
@implementation TermCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_btn];
        _btn.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
        _btn.layer.masksToBounds = YES;
        _btn.layer.cornerRadius = 3.0;
//        _btn.layer.borderWidth = 1.0;
        _btn.titleLabel.font = [UIFont systemFontOfSize:14];
        _btn.layer.borderColor = [UIColor whiteColor].CGColor;
        [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_btn setTitleColor:RGB(248, 69, 110) forState:UIControlStateSelected];
        [_btn addTarget:self action:@selector(handleBtn) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return self;
}
- (void)handleBtn{
    if (_clickBlock) {
        _clickBlock();
    }
}

@end
@interface QukanAirPlayLandscapeTermView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,weak) NSArray <NSString *>*dataSourceArr;
@end
@implementation QukanAirPlayLandscapeTermView

+ (void)showInView:(UIView *)superView{
    QukanAirPlayLandscapeTermView *view = [[QukanAirPlayLandscapeTermView alloc] init];
    [superView addSubview:view];
    view.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
}
- (instancetype)init
{
    self = [super init];
    if (self) {
         self.backgroundColor = [kCommonBlackColor colorWithAlphaComponent:0.5];
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumInteritemSpacing = 10;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [self addSubview:_collectionView];
        _collectionView.sd_layout.leftSpaceToView(self, 100).topSpaceToView(self, 50).rightSpaceToView(self, 100).bottomSpaceToView(self, 50);
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:TermCell.class forCellWithReuseIdentifier:@"cell"];
//        _dataSourceArr = QukanAirPlayManager.sharedManager.movieDetailRes.movieInfo.movieSubsets;
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [self addGestureRecognizer:tap];
        @weakify(self)
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            @strongify(self)
            [self removeFromSuperview];
            
        }];
        [[QukanAirPlayManager.sharedManager.deviceOrientationChangeSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            [self removeFromSuperview];
        }];
        
    }
    return self;
}


#pragma mark - UICollectionViewDataSource
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    return UIEdgeInsetsMake(30.0, 100.0, 30.0, 100.0);
//}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    DXMovieSubsets *model = self.dataSourceArr[indexPath.section];
//
//    CGSize size = sizeWithFont([UIFont systemFontOfSize:14], CGSizeMake(200.0, 50.0), model.term);
//    CGFloat width = size.width<50.0?50.0:size.width+20.0;
    return CGSizeMake(100, 50.0);
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSourceArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    TermCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
//    DXMovieSubsets *model = self.dataSourceArr[indexPath.row];
//    [cell.btn setTitle:model.term forState:UIControlStateNormal];
//    if (QukanAirPlayManager.sharedManager.currentSubset == model) {
////        cell.btn.layer.borderColor = RGB(248, 69, 110).CGColor;
////        cell.btn.selected = YES;
//        cell.btn.backgroundColor = RGB(248, 69, 110);
//    }else{
////        cell.btn.layer.borderColor = [UIColor whiteColor].CGColor;
////        cell.btn.selected = NO;
//        cell.btn.backgroundColor = RGBA(1, 1, 1, 0.3);
//    }
//    @weakify(self)
//    cell.clickBlock = ^{
//     @strongify(self)
//      DXMovieSubsets *model = self.dataSourceArr[indexPath.row];
//        for (DXMovieSubsets *temp in self.dataSourceArr) {
//            temp.isSelected = NO;
//        }
//        model.isSelected = YES;
//        [QukanAirPlayManager.sharedManager playWithSubsetModel:model];
//        [self removeFromSuperview];
//
//    };
    
    return cell;
}


@end
