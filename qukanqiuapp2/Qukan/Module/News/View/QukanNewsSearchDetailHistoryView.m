//
//  QukanNewsSearchDetailHistoryView.m
//  Qukan
//
//  Created by blank on 2020/1/5.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanNewsSearchDetailHistoryView.h"
#import "QukanNewsSearchDetailHistoryCell.h"
#import "QukanUICollectionViewLeftAlignedLayout.h"
@interface QukanNewsSearchDetailHistoryView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong)UILabel *historyLab;
@property (nonatomic, strong)UIButton *deleteButton;
@property (nonatomic, strong)UICollectionView *mCollectionView;
@property (nonatomic, strong)UIView *botView;
@property (nonatomic, strong)NSMutableArray *dataArray;

@end
@implementation QukanNewsSearchDetailHistoryView

- (instancetype)initWithFrame:(CGRect)frame itemSelectBlock:(nonnull void (^)(NSString * _Nonnull))itemSelect deleteBlock:(nonnull void (^)(void))deleteBlock{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kCommonWhiteColor;
        [self addSubview:self.historyLab];
        [self addSubview:self.deleteButton];
        [self addSubview:self.mCollectionView];
        [self addSubview:self.botView];
        
        [self.historyLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.top.offset(9);
            make.height.offset(17);
        }];
        [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(0);
            make.width.offset(15+17*2);
            make.height.offset(15+6*2);
            make.centerY.mas_equalTo(self.historyLab.mas_centerY).offset(0);
        }];
        [self.mCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.top.mas_equalTo(self.deleteButton.mas_bottom).offset(0);
            make.width.offset(kScreenWidth);
            make.bottom.offset(-17);
        }];
        [self.botView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.offset(0);
            make.height.offset(10);
        }];
        [[self.deleteButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            deleteBlock();
        }];
        self.itemClickBlock = itemSelect;
        self.historyLab.hidden = 1;
    }
    return self;
}
- (CGFloat)heightOfHistoryView {
    if (self.dataArray.count == 0) {
        return 0;
    }
    CGFloat x = 15;
    CGFloat rightMargin = 15+17;
    CGFloat height = 33;
    
    for (int i = 0;i < _dataArray.count;i++) {
        NSString *string = _dataArray[i];
        //i == 5时,转行
        CGFloat width = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, 17) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFont12} context:nil].size.width + 15 + 10;
        width = width > kScreenWidth - rightMargin -15 ? kScreenWidth - rightMargin - 15 : width;
        if (x + width +rightMargin <= kScreenWidth) {
            x += width;
            
        } else {
            x = width + 15;
            height += 23 + 10;
        }
    }
    return height +23+ 17 + 10;
}
- (void)reloadMcollectionData {
    [self.mCollectionView reloadData];
}
- (void)setData:(NSArray *)array {
    self.dataArray = [array mutableCopy];
    self.hidden = !array.count;
    self.historyLab.hidden = !array.count;
    self.deleteButton.hidden = !array.count;
    self.botView.hidden = !array.count;
}
#pragma mark ===================== collectionView delegate ==================================
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QukanNewsSearchDetailHistoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QukanNewsSearchDetailHistoryCell" forIndexPath:indexPath];
    cell.contentString = self.dataArray[indexPath.row];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *string = _dataArray[indexPath.row];
    if (self.itemClickBlock) {
        self.itemClickBlock(string);
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *string = self.dataArray[indexPath.row];
    CGFloat width = [string boundingRectWithSize:CGSizeMake(1000, 17) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFont12} context:nil].size.width + 15;
    return CGSizeMake(width + 10 > kScreenWidth - 15 -17 - 15 ? kScreenWidth - 15 -17 -15 : width, 23);
}


- (UILabel *)historyLab {
    if (!_historyLab) {
        _historyLab = [UILabel new];
        _historyLab.textColor = kTextGrayColor;
        _historyLab.font = kFont12;
        _historyLab.text = @"搜索历史";
    }
    return _historyLab;
}
- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [UIButton new];
        [_deleteButton setImage:kImageNamed(@"Qukan_News_delete") forState:UIControlStateNormal];
        _deleteButton.hidden = 1;
    }
    return _deleteButton;
}
- (UICollectionView *)mCollectionView {
    if (!_mCollectionView) {
        QukanUICollectionViewLeftAlignedLayout *layout = [QukanUICollectionViewLeftAlignedLayout new];
        layout.minimumInteritemSpacing = 10;
        layout.minimumLineSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 32);
        _mCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        
       
        _mCollectionView.backgroundColor = kCommonWhiteColor;
        _mCollectionView.delegate = self;
        _mCollectionView.dataSource = self;
        [_mCollectionView registerClass:[QukanNewsSearchDetailHistoryCell class] forCellWithReuseIdentifier:@"QukanNewsSearchDetailHistoryCell"];
        _mCollectionView.scrollEnabled = 0;
    }
    return _mCollectionView;
}
- (UIView *)botView {
    if (!_botView) {
        _botView = [UIView new];
        _botView.backgroundColor = kSecondTableViewBackgroudColor;
        _botView.hidden = 1;
    }
    return _botView;
}
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}
@end
