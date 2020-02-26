#import "QukanLineupHeaderView.h"
#import "QukanLineupHeaderCell.h"
@interface QukanLineupHeaderView()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, weak) IBOutlet UIView *bgView;
@property (nonatomic, weak) IBOutlet UIView *circularView;
@property (nonatomic, weak) IBOutlet UIView *teamMemberView_1;
@property (nonatomic, weak) IBOutlet UIView *teamMemberView_2;
@property (nonatomic, weak) IBOutlet UILabel *chiefUmpireLabel;
@property (nonatomic, weak) IBOutlet UILabel *footballFieldLabel;
@property (nonatomic, weak) IBOutlet UILabel *goalkeeperNumberLabel_1;
@property (nonatomic, weak) IBOutlet UILabel *goalkeeperNumberLabel_2;
@property (nonatomic, weak) IBOutlet UILabel *goalkeeperNameLabel_1;
@property (nonatomic, weak) IBOutlet UILabel *goalkeeperNameLabel_2;
@property (weak, nonatomic) IBOutlet UIImageView *img_caipan;
@property(strong, nonatomic) UICollectionView *Qukan_teamMemberCollectionView_1;
@property(strong, nonatomic) UICollectionView *Qukan_teamMemberCollectionView_2;
@property(strong, nonatomic) NSMutableArray *Qukan_homeArray;
@property(strong, nonatomic) NSMutableArray *Qukan_awayArray;
@property(strong, nonatomic) NSMutableArray *Qukan_homeFormationArray;
@property(strong, nonatomic) NSMutableArray *Qukan_awayFormationArray;
@property (weak, nonatomic) IBOutlet UILabel *homeLineUp;
@property (weak, nonatomic) IBOutlet UILabel *awayName;
@property (weak, nonatomic) IBOutlet UILabel *awayLineUp;
@property (weak, nonatomic) IBOutlet UILabel *homeNmae;
@end
@implementation QukanLineupHeaderView
- (NSMutableArray *)Qukan_homeArray {
    if (!_Qukan_homeArray) {
        _Qukan_homeArray = [[NSMutableArray alloc] init];
    }
    return _Qukan_homeArray;
}
- (NSMutableArray *)Qukan_awayArray {
    if (!_Qukan_awayArray) {
        _Qukan_awayArray = [[NSMutableArray alloc] init];
    }
    return _Qukan_awayArray;
}
- (NSMutableArray *)Qukan_homeFormationArray {
    if (!_Qukan_homeFormationArray) {
        _Qukan_homeFormationArray = [[NSMutableArray alloc] init];
    }
    return _Qukan_homeFormationArray;
}
- (NSMutableArray *)Qukan_awayFormationArray {
    if (!_Qukan_awayFormationArray) {
        _Qukan_awayFormationArray = [[NSMutableArray alloc] init];
    }
    return _Qukan_awayFormationArray;
}
- (UICollectionView *)Qukan_teamMemberCollectionView_1 {
    if (!_Qukan_teamMemberCollectionView_1) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _Qukan_teamMemberCollectionView_1 = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _Qukan_teamMemberCollectionView_1.backgroundColor = [UIColor clearColor];
        _Qukan_teamMemberCollectionView_1.bounces = NO;
        _Qukan_teamMemberCollectionView_1.delegate = self;
        _Qukan_teamMemberCollectionView_1.dataSource = self;
        [_Qukan_teamMemberCollectionView_1 registerNib:[UINib nibWithNibName:@"QukanLineupHeaderCell" bundle:nil] forCellWithReuseIdentifier:@"QukanLineupHeaderCell"];
        [self.teamMemberView_1 addSubview:_Qukan_teamMemberCollectionView_1];
        [_Qukan_teamMemberCollectionView_1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.teamMemberView_1);
        }];
    }
    return _Qukan_teamMemberCollectionView_1;
}
- (UICollectionView *)Qukan_teamMemberCollectionView_2 {
    if (!_Qukan_teamMemberCollectionView_2) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _Qukan_teamMemberCollectionView_2 = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _Qukan_teamMemberCollectionView_2.backgroundColor = [UIColor clearColor];
        _Qukan_teamMemberCollectionView_2.bounces = NO;
        _Qukan_teamMemberCollectionView_2.delegate = self;
        _Qukan_teamMemberCollectionView_2.dataSource = self;
        [_Qukan_teamMemberCollectionView_2 registerNib:[UINib nibWithNibName:@"QukanLineupHeaderCell" bundle:nil] forCellWithReuseIdentifier:@"QukanLineupHeaderCell"];
        [self.teamMemberView_2 addSubview:_Qukan_teamMemberCollectionView_2];
        [_Qukan_teamMemberCollectionView_2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.teamMemberView_2);
        }];
    }
    return _Qukan_teamMemberCollectionView_2;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.img_caipan.image = [kImageNamed(@"Qukan_chuisao") imageWithColor:kCommonWhiteColor];
    self.img_caipan.alpha = 0.5;
    
    self.bgView.backgroundColor = [UIColor clearColor];
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.borderColor = HEXColor(0x4BC569).CGColor;
    self.bgView.layer.borderWidth = 1.0;
    self.circularView.backgroundColor = [UIColor clearColor];
    self.circularView.layer.masksToBounds = YES;
    self.circularView.layer.cornerRadius = 50.0f;
    self.circularView.layer.borderColor =  HEXColor(0x4BC569).CGColor;
    self.circularView.layer.borderWidth = 1.0;
    self.goalkeeperNumberLabel_1.layer.masksToBounds = YES;
    self.goalkeeperNumberLabel_1.layer.cornerRadius = 12.0;
    self.goalkeeperNumberLabel_1.layer.borderColor = [UIColor whiteColor].CGColor;
    self.goalkeeperNumberLabel_1.layer.borderWidth = 1.0;
    self.goalkeeperNumberLabel_2.layer.masksToBounds = YES;
    self.goalkeeperNumberLabel_2.layer.cornerRadius = 12.0;
    self.goalkeeperNumberLabel_2.layer.borderColor = [UIColor whiteColor].CGColor;
    self.goalkeeperNumberLabel_2.layer.borderWidth = 1.0;
    [self Qukan_teamMemberCollectionView_1];
    [self Qukan_teamMemberCollectionView_2];
}
- (void)Qukan_setData:(NSDictionary *)dict {
    self.chiefUmpireLabel.text = [NSString stringWithFormat:@"%@", dict[@"master"]?:@""];
    self.footballFieldLabel.text = [NSString stringWithFormat:@"%@", dict[@"gym"]?:@""];
    if ([dict[@"homeLiseupList"] isKindOfClass:[NSArray class]]) {
        [self.Qukan_homeArray removeAllObjects];
        NSArray *homeLiseupList = dict[@"homeLiseupList"];
        if (homeLiseupList.count>10) {
            NSString *infoStr = homeLiseupList[0];
            NSArray *infoArray = [infoStr componentsSeparatedByString:@","];
            if (infoArray.count>=4) {
                self.goalkeeperNameLabel_1.text = infoArray[1];
                self.goalkeeperNumberLabel_1.text = infoArray[3];
            } else {
                self.goalkeeperNameLabel_1.text = @"";
                self.goalkeeperNumberLabel_1.text = @"";
            }
            for (int i=1; i<homeLiseupList.count; i++) {
                NSString *s = homeLiseupList[i];
                [self.Qukan_homeArray addObject:s];
            }
        }
    }
    if ([dict[@"awayLineupList"] isKindOfClass:[NSArray class]]) {
        [self.Qukan_awayArray removeAllObjects];
        NSArray *awayLineupList = dict[@"awayLineupList"];
        if (awayLineupList.count>10) {
            NSString *infoStr = awayLineupList[0];
            NSArray *infoArray = [infoStr componentsSeparatedByString:@","];
            if (infoArray.count>=4) {
                self.goalkeeperNameLabel_2.text = infoArray[1];
                self.goalkeeperNumberLabel_2.text = infoArray[3];
            } else {
                self.goalkeeperNameLabel_2.text = @"";
                self.goalkeeperNumberLabel_2.text = @"";
            }
            for (NSInteger i=awayLineupList.count-1; i>0; i--) {
                NSString *s = awayLineupList[i];
                [self.Qukan_awayArray addObject:s];
            }
        }
    }
    [self.Qukan_homeFormationArray removeAllObjects];
    NSString *homeFormation = [NSString stringWithFormat:@"%@", dict[@"homeArray"]];
    if (homeFormation && homeFormation.length!=0 && ![homeFormation isEqualToString:@"<null>"]) {
        for(int i =0; i < homeFormation.length; i++) {
            NSString *s = [homeFormation substringWithRange:NSMakeRange(i, 1)];
            [self.Qukan_homeFormationArray addObject:s];
        }
//        for (NSInteger i=self.Qukan_homeFormationArray.count; i<4; i++) {
//            [self.Qukan_homeFormationArray addObject:@"0"];
//        }
    } else {
        [self.Qukan_homeFormationArray addObject:@"4"];
        [self.Qukan_homeFormationArray addObject:@"2"];
        [self.Qukan_homeFormationArray addObject:@"3"];
        [self.Qukan_homeFormationArray addObject:@"1"];
    }
    [self.Qukan_awayFormationArray removeAllObjects];
    NSString *awayFormation = [NSString stringWithFormat:@"%@", dict[@"awayArray"]];
    if (awayFormation && awayFormation.length!=0 && ![awayFormation isEqualToString:@"<null>"]) {
        for(NSInteger i=awayFormation.length-1; i>=0; i--) {
            NSString *s = [awayFormation substringWithRange:NSMakeRange(i, 1)];
            [self.Qukan_awayFormationArray addObject:s];
        }
//        for (NSInteger i=self.Qukan_awayFormationArray.count; i<4; i++) {
//            [self.Qukan_awayFormationArray addObject:@"0"];
//        }
    } else {
        [self.Qukan_awayFormationArray addObject:@"1"];
        [self.Qukan_awayFormationArray addObject:@"3"];
        [self.Qukan_awayFormationArray addObject:@"2"];
        [self.Qukan_awayFormationArray addObject:@"4"];
    }
    
    self.homeNmae.text = self.str_homeName;
    self.awayName.text = self.str_awayName;
    self.homeLineUp.text = [self.Qukan_homeFormationArray componentsJoinedByString:@"-"];
    self.awayLineUp.text = [[[self.Qukan_awayFormationArray reverseObjectEnumerator] allObjects] componentsJoinedByString:@"-"];
    
    [self.Qukan_teamMemberCollectionView_1 reloadData];
    [self.Qukan_teamMemberCollectionView_2 reloadData];
}
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.01f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.01f;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
        NSInteger count = 0;
        CGFloat height = 0;
        if (collectionView==self.Qukan_teamMemberCollectionView_1) {
            NSString *s = self.Qukan_homeFormationArray[indexPath.section];
            height = collectionView.height / self.Qukan_homeFormationArray.count;
            count = [s integerValue];
        } else {
            NSString *s = self.Qukan_awayFormationArray[indexPath.section];
            height = collectionView.height / self.Qukan_awayFormationArray.count;
            count = [s integerValue];
        }
        CGFloat Width = (kScreenWidth-80.0) / count;
    //    CGFloat height = collectionView.height/count;
        
        return CGSizeMake(Width, height);
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (collectionView==self.Qukan_teamMemberCollectionView_1) {
        return self.Qukan_homeFormationArray.count;
    } else {
        return self.Qukan_awayFormationArray.count;
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = 0;
    if (collectionView==self.Qukan_teamMemberCollectionView_1) {
        NSString *s = self.Qukan_homeFormationArray[section];
        count = [s integerValue];
    } else {
        NSString *s = self.Qukan_awayFormationArray[section];
        count = [s integerValue];
    }
    return count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QukanLineupHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QukanLineupHeaderCell" forIndexPath:indexPath];
    NSArray *sectionArray = nil;
    NSArray *contentArray = nil;
    if (collectionView==self.Qukan_teamMemberCollectionView_1) {
        cell.numberLabel.backgroundColor = HEXColor(0xFE0000);
        cell.numberLabel.layer.borderColor = [UIColor whiteColor].CGColor;
        sectionArray = self.Qukan_homeFormationArray;
        contentArray = self.Qukan_homeArray;
    } else {
        cell.numberLabel.backgroundColor = HEXColor(0x878787);
        cell.numberLabel.layer.borderColor = HEXColor(0x2B2B2B).CGColor;
        sectionArray = self.Qukan_awayFormationArray;
        contentArray = self.Qukan_awayArray;
    }
    if (sectionArray && contentArray) {
        NSInteger row = 0;
        if (indexPath.section==0) {
            row = indexPath.row;
        } else {
            NSInteger sectionNumber = 0;
            for (NSInteger i=0; i<indexPath.section; i++) {
                NSString *s = sectionArray[i];
                sectionNumber += [s integerValue];
            }
            row = indexPath.row + sectionNumber;
        }
        if (row<contentArray.count) {
            NSString *infoStr = contentArray[row];
            NSArray *infoArray = [infoStr componentsSeparatedByString:@","];
            if (infoArray.count>=4) {
                cell.nameLabel.text = infoArray[1];
                cell.numberLabel.text = infoArray[3];
            } else {
                cell.nameLabel.text = @"";
                cell.numberLabel.text = @"";
            }
        } else {
            cell.nameLabel.text = @"";
            cell.numberLabel.text = @"";
        }
    }
    return cell;
}
@end
