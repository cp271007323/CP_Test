#import "QukanDateView.h"
#import "QukanDateCell.h"
#import "QukanDateModel.h"
@interface QukanDateView()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong) NSMutableArray *Qukan_dataArray;
@property(strong, nonatomic) UICollectionView *Qukan_myCollectionView;
@end
@implementation QukanDateView
- (NSMutableArray *)Qukan_dataArray {
    if (!_Qukan_dataArray) {
        _Qukan_dataArray = [[NSMutableArray alloc] init];
    }
    return _Qukan_dataArray;
}
- (UICollectionView *)Qukan_myCollectionView {
    if (!_Qukan_myCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _Qukan_myCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _Qukan_myCollectionView.backgroundColor = [UIColor clearColor];
        _Qukan_myCollectionView.showsHorizontalScrollIndicator = NO;
        _Qukan_myCollectionView.delegate = self;
        _Qukan_myCollectionView.dataSource = self;
        [_Qukan_myCollectionView registerNib:[UINib nibWithNibName:@"QukanDateCell" bundle:nil] forCellWithReuseIdentifier:@"QukanDateCell"];
        [self addSubview:_Qukan_myCollectionView];
        [_Qukan_myCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return _Qukan_myCollectionView;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self=[super initWithFrame:frame]) {
    self.backgroundColor = HEXColor(0xe8e8e8);
        [self Qukan_myCollectionView];
    }
    return self;
}
- (BOOL)Qukan_setFirstSevenDaysData {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *nowDate = [NSDate date];
    NSTimeInterval oneDay = 24*60*60;
    NSString *yesterdayDateStr = [dateFormatter stringFromDate:nowDate];
    if ([yesterdayDateStr isEqualToString:self.Qukan_yesterday]) {
        return NO;
    }
    NSMutableArray *dateArray = [NSMutableArray array];
    for (int i=6; i>=1; i--) {
        NSDate *theDate = [nowDate initWithTimeIntervalSinceNow: -oneDay*i];
        NSString *currentDateStr = [dateFormatter stringFromDate:theDate];
        [dateArray addObject:currentDateStr];
    }
    self.Qukan_yesterday = yesterdayDateStr;
    [dateArray addObject:yesterdayDateStr];
    [self.Qukan_dataArray removeAllObjects];
    for (int i=0; i<dateArray.count; i++) {
        NSString *date = dateArray[i];
        QukanDateModel *model = [[QukanDateModel alloc] init];
        model.dateType = (dateArray.count-i-1);
        model.date = date;
        if ([date isEqualToString:yesterdayDateStr]) {
            model.week = [QukanTool Qukan_getWeekDay:date];
            model.isSelected = YES;
            model.date = @"今";
            self.Qukan_yesterdayDateType = (dateArray.count-i-1);
        } else {
            model.week = [QukanTool Qukan_getWeekDay:date];
        }
        [self.Qukan_dataArray addObject:model];
    }
    [self.Qukan_myCollectionView reloadData];
    [self.Qukan_myCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.Qukan_dataArray.count-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
    return YES;
}
- (BOOL)Qukan_setNextSevenDaysData {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *nowDate = [NSDate date];
    NSTimeInterval oneDay = 24*60*60;
    NSMutableArray *dateArray = [NSMutableArray array];
    NSDate *theDate = [nowDate initWithTimeIntervalSinceNow: +oneDay*1];
    NSString *tomorrowDateStr = [dateFormatter stringFromDate:theDate];
    NSString *todayDateStr = [dateFormatter stringFromDate:nowDate];
    if ([tomorrowDateStr isEqualToString:self.Qukan_tomorrow]) {
        return NO;
    }
//    [dateArray addObject:tomorrowDateStr];
    self.Qukan_tomorrow = tomorrowDateStr;
    for (int i=0; i<=6; i++) {
        NSDate *theDate = [nowDate initWithTimeIntervalSinceNow: +oneDay*i];
        NSString *currentDateStr = [dateFormatter stringFromDate:theDate];
        [dateArray addObject:currentDateStr];
    }
    [self.Qukan_dataArray removeAllObjects];
    for (int i=0; i<dateArray.count; i++) {
        NSString *date = dateArray[i];
        QukanDateModel *model = [[QukanDateModel alloc] init];
        model.dateType = i+1;
        model.date = date;
        if ([date isEqualToString:todayDateStr]) {
            model.isSelected = YES;
            model.date = @"今";
            model.week = [QukanTool Qukan_getWeekDay:date];
            self.Qukan_tomorrowDateType = i+1;
        } else {
            model.week = [QukanTool Qukan_getWeekDay:date];
        }
        [self.Qukan_dataArray addObject:model];
    }
    [self.Qukan_myCollectionView reloadData];
    [self.Qukan_myCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.Qukan_dataArray.count-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
    return YES;
}
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (CGRectGetWidth([[UIScreen mainScreen] bounds])-6)/7.0;
    return CGSizeMake(width, 70);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1.0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1.0;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.Qukan_dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QukanDateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QukanDateCell" forIndexPath:indexPath];
    QukanDateModel *model = self.Qukan_dataArray[indexPath.row];
    if (indexPath.row == self.Qukan_dataArray.count-1) {
        cell.showSep = NO;
    }else {
        cell.showSep = YES;
    }
    [cell Qukan_setData:model];
    return cell;
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    for (QukanDateModel *obj in self.Qukan_dataArray) {
        obj.isSelected = NO;
    }
    QukanDateModel *model = self.Qukan_dataArray[indexPath.row];
    model.isSelected = YES;
    [self.Qukan_myCollectionView reloadData];
    if (self.Qukan_didSelectItemBlock) {
        self.Qukan_didSelectItemBlock(model.dateType);
    }
}
@end
