//
//  QukanShowTaskHeaderView.m
//  Qukan
//
//  Created by leo on 2020/1/7.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanDailyHeaderView.h"

// view
#import "QukanDailyHeaderCenterCell.h"
#import "QukanDailyHedaerBottomCell.h"

// model
#import "QukanTModel.h"

@interface QukanDailyHeaderView()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,QukanDailyHedaerBottomCellDelegate, QukanDailyHeaderCenterCellDelegate>

/**顶部背景视图*/
@property(nonatomic, strong) UIView   * QukanTopBg_view;
///**等级lab*/
//@property(nonatomic, strong) UILabel   * QukanLevel_lab;
///**积分lab*/
//@property(nonatomic, strong) UILabel   * QukanJF_lab;
///**我的等级*/
//@property(nonatomic, strong) UILabel   * QukanMyLevel_lab;

/**中间的视图*/
@property(nonatomic, strong) UIView   * QukanCenterBg_view;
/**底部的背景视图*/
@property(nonatomic, strong) UIView   * QukanBottomBg_view;
/**中间的列表视图*/
@property(nonatomic, strong) UICollectionView   * QukanCenterMain_collection;
/**中间去邀请按钮*/
@property(nonatomic, strong) UIButton   * QukanCenterYQ_btn;

/**底部列表视图*/
@property(nonatomic, strong) UICollectionView   * QukanBottomMain_collection;

/**底部collection数据源*/
@property(nonatomic, strong) QukanTModel   * QukanBottomSource_model;

/**底部collection数据源*/
@property(nonatomic, strong) QukanTModel   * QukanCenterSource_model;


/***/
@property(nonatomic, strong) UILabel   * QukanCenterTop_lab;
/**<#注释#>*/
@property(nonatomic, strong) UILabel   * QukanCenterBottom_lab;

/**<#注释#>*/
@property(nonatomic, strong) UILabel   * QukanBottomTop_lab;
/**ui*/
@property(nonatomic, strong) UILabel   * QukanBootomBottom_lab;

@end

@implementation QukanDailyHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kCommentBackgroudColor;
        [self initUI];
    }
    return self;
}


#pragma mark ===================== UI ==================================
- (void)initUI {
    [self layoutTopViews];  // 布局上方视图
    [self layoutCenterViews]; // 布局中间视图
    [self layoutBottomViews]; // 布局下方视图
}

- (void)layoutTopViews {
    [self addSubview:self.QukanTopBg_view];
    [self.QukanTopBg_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self);
         make.width.equalTo(@(kScreenWidth));
        make.height.equalTo(@(210 + kStatusBarHeight));
    }];
    
    
//    [self.QukanTopBg_view addSubview:self.QukanMyLevel_lab];
//    [self.QukanMyLevel_lab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).offset(15);
//        make.centerY.equalTo(self.QukanTopBg_view);
//    }];
//    
//    [self.QukanTopBg_view addSubview:self.QukanLevel_lab];
//    [self.QukanLevel_lab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.QukanMyLevel_lab);
//        make.top.equalTo(self.QukanMyLevel_lab.mas_bottom).offset(10);
//    }];
//    
//    [self.QukanTopBg_view addSubview:self.QukanJF_lab];
//    [self.QukanJF_lab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.QukanMyLevel_lab);
//        make.top.equalTo(self.QukanLevel_lab.mas_bottom).offset(10);
//    }];
}


- (void)layoutCenterViews {
    [self addSubview:self.QukanCenterBg_view];
    [self.QukanCenterBg_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.QukanTopBg_view.mas_bottom);
        make.left.equalTo(self).offset(15);
        make.width.equalTo(@(kScreenWidth - 30));
    }];
    
    UILabel *lab = [UILabel new];
    lab.textColor = kCommonTextColor;
    lab.text = @"--";
    lab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    [self.QukanCenterBg_view addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.QukanCenterBg_view).offset(15);
        make.left.equalTo(self.QukanCenterBg_view).offset(12);
        make.right.equalTo(self.QukanCenterBg_view).offset(-12);
    }];
    _QukanCenterTop_lab = lab;

    UILabel *lab1 = [UILabel new];
    lab1.textColor = kTextGrayColor;
    lab1.text = @"--";
    lab1.font = [UIFont systemFontOfSize:12];
    lab1.numberOfLines = 0;
    [self.QukanCenterBg_view addSubview:lab1];
    [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab.mas_bottom).offset(3);
        make.left.equalTo(self.QukanCenterBg_view).offset(12);
        make.right.equalTo(self.QukanCenterBg_view).offset(-12);
    }];
    _QukanCenterBottom_lab = lab1;
    
    [self.QukanCenterBg_view addSubview:self.QukanCenterMain_collection];
    [self.QukanCenterMain_collection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab1.mas_bottom).offset(4);
        make.left.equalTo(self.QukanCenterBg_view).offset(10);
        make.right.equalTo(self.QukanCenterBg_view).offset(-10);
        make.height.equalTo(@(120));
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 18;
    btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    [btn setTitle:@"去邀请" forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageWithColor:kThemeColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(YQBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.QukanCenterBg_view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.QukanCenterMain_collection.mas_bottom).offset(17);
        make.left.equalTo(self.QukanCenterBg_view).offset(15);
        make.right.equalTo(self.QukanCenterBg_view).offset(-15);
        make.height.equalTo(@(50));
        make.bottom.equalTo(self.QukanCenterBg_view).offset(-15);
    }];
}


- (void)layoutBottomViews {
    [self addSubview:self.QukanBottomBg_view];
    [self.QukanBottomBg_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.QukanCenterBg_view.mas_bottom).offset(20);
        make.left.equalTo(self).offset(15);
        make.width.equalTo(@(kScreenWidth - 30));
        make.bottom.equalTo(self).offset(-25);
    }];

    UILabel *lab = [UILabel new];
    lab.textColor = kCommonTextColor;
    lab.text = @"--";
    lab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    [self.QukanBottomBg_view addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.QukanBottomBg_view).offset(15);
        make.left.equalTo(self.QukanBottomBg_view).offset(12);
        make.right.equalTo(self.QukanBottomBg_view).offset(-12);
    }];
    _QukanBottomTop_lab = lab;

    UILabel *lab1 = [UILabel new];
    lab1.textColor = kTextGrayColor;
    lab1.text = @"--";
    lab1.font = [UIFont systemFontOfSize:12];
    lab1.numberOfLines = 0;
    [self.QukanBottomBg_view addSubview:lab1];
    [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab.mas_bottom).offset(3);
        make.left.equalTo(self.QukanBottomBg_view).offset(12);
        make.right.equalTo(self.QukanBottomBg_view).offset(-12);
    }];
    _QukanBootomBottom_lab = lab1;

    [self.QukanBottomBg_view addSubview:self.QukanBottomMain_collection];
    [self.QukanBottomMain_collection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab1.mas_bottom).offset(4);
        make.left.equalTo(self.QukanBottomBg_view).offset(10);
        make.right.equalTo(self.QukanBottomBg_view).offset(-10);
        make.height.equalTo(@(120));
        make.bottom.equalTo(self.QukanBottomBg_view).offset(-10);
    }];
}

#pragma mark ===================== public function ==================================
// 给底部的collection赋值
- (void)fullBottomViewWithModel:(QukanTModel *)model {
    self.QukanBottomSource_model = model;
    self.QukanBottomTop_lab.text = model.name;
    self.QukanBootomBottom_lab.text = model.descr;
    [self.QukanBottomMain_collection reloadData];
}


// 给中间的view赋值
- (void)fullCenterViewWithModel:(QukanTModel *)model {
    self.QukanCenterSource_model = model;
    
    self.QukanCenterTop_lab.text = model.name;
    self.QukanCenterBottom_lab.text = model.descr;
    
    [self.QukanCenterMain_collection reloadData];
}

- (void)YQBtnClick{}

#pragma mark ===================== collectionViewdelegate ==================================
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([collectionView isEqual:self.QukanBottomMain_collection]) {
        
        QukanDailyHedaerBottomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QukanDailyHedaerBottomCellID" forIndexPath:indexPath];
        if (!cell) {
            cell = [[QukanDailyHedaerBottomCell alloc] initWithFrame:CGRectZero];
        }
        
        cell.delegate = self;
        cell.QukanArrow_img.hidden = (indexPath.row == self.QukanBottomSource_model.configList.count - 1);
        [cell fullCellWithModel:self.QukanBottomSource_model.configList[indexPath.row]];
        return cell;
    }
    
    QukanDailyHeaderCenterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QukanDailyHeaderCenterCellID" forIndexPath:indexPath];
    if (!cell) {
        cell = [[QukanDailyHeaderCenterCell alloc] initWithFrame:CGRectZero];
    }
    
    cell.delegate = self;
    cell.QukanArrow_img.hidden = (indexPath.row == self.QukanCenterSource_model.configList.count - 1);
    [cell fullCellWithModel:self.QukanCenterSource_model.configList[indexPath.row]];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([collectionView isEqual:self.QukanCenterMain_collection]) {
        return self.QukanCenterSource_model.configList.count;
    }
    
    if ([collectionView isEqual:self.QukanBottomMain_collection]) {
        return self.QukanBottomSource_model.configList.count;
    }
    return 10;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%zd", indexPath.row);
}

// 定义每个UICollectionView的横向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.00f;
}

// 定义每个UICollectionView的纵向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.00f;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(70, 120);
}


#pragma mark ===================== cellDelegate ==================================
- (void)linquActionWithActionModel:(QukanActionModel *)model{};

- (void)QukanDailyHedaerBottomCellQukanLinqu_btnClick:(QukanDailyHedaerBottomCell *)cell {
    NSIndexPath *indexPath = [self.QukanBottomMain_collection indexPathForCell:cell];
    QukanActionModel *model = self.QukanBottomSource_model.configList[indexPath.row];
    [self linquActionWithActionModel:model];
}

- (void)QukanDailyHeaderCenterCellQukanLinqu_btnClick:(QukanDailyHeaderCenterCell *)cell {
    NSIndexPath *indexPath = [self.QukanCenterMain_collection indexPathForCell:cell];
    QukanActionModel *model = self.QukanCenterSource_model.configList[indexPath.row];
    [self linquActionWithActionModel:model];
}


#pragma mark ===================== lazy ==================================

- (UIView *)QukanTopBg_view {  // 顶部背景视图
    if (!_QukanTopBg_view) {
        _QukanTopBg_view = [UIView new];
        
        UIImageView *img = [UIImageView new];
        img.image = kImageNamed(@"Qukan_ta_bg");
        [_QukanTopBg_view addSubview:img];
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.QukanTopBg_view);
        }];
    }
    return _QukanTopBg_view;
}

//- (UILabel *)QukanMyLevel_lab {
//    if (!_QukanMyLevel_lab) {
//        _QukanMyLevel_lab = [UILabel new];
//        _QukanMyLevel_lab.text = @"我的等级";
//        _QukanMyLevel_lab.alpha = 0.5;
//        _QukanMyLevel_lab.textColor = kCommonWhiteColor;
//        _QukanMyLevel_lab.font = [UIFont systemFontOfSize:12];
//    }
//    return _QukanMyLevel_lab;
//}
//
//
//-(UILabel *)QukanLevel_lab {  // 等级lab
//    if (!_QukanLevel_lab) {
//        _QukanLevel_lab = [UILabel new];
//        _QukanLevel_lab.text = @"lv:11";
//        _QukanLevel_lab.font = [UIFont fontWithName:@"HiraginoSans-W6" size:40];
//        _QukanLevel_lab.textColor = kCommonWhiteColor;
//    }
//    return _QukanLevel_lab;
//}
//
//- (UILabel *)QukanJF_lab {  // 积分lab
//    if (!_QukanJF_lab) {
//        _QukanJF_lab = [UILabel new];
//        _QukanJF_lab.font = [UIFont systemFontOfSize:12];
//        _QukanJF_lab.textColor = kCommonWhiteColor;
//        _QukanJF_lab.text = @"我的积分:1000";
//    }
//    return _QukanJF_lab;
//}

- (UIView *)QukanCenterBg_view {  // 中间背景视图
    if (!_QukanCenterBg_view) {
        _QukanCenterBg_view = [UIView new];
        _QukanCenterBg_view.backgroundColor = kCommonWhiteColor;
        _QukanCenterBg_view.layer.masksToBounds = YES;
        _QukanCenterBg_view.layer.cornerRadius = 20;
        
    }
    return _QukanCenterBg_view;
}

- (UIView *)QukanBottomBg_view {
    if (!_QukanBottomBg_view) {
        _QukanBottomBg_view = [UIView new];
        _QukanBottomBg_view.backgroundColor = kCommonWhiteColor;
        _QukanBottomBg_view.layer.masksToBounds = YES;
        _QukanBottomBg_view.layer.cornerRadius = 20;
    }
    return _QukanBottomBg_view;
}

- (UICollectionView *)QukanCenterMain_collection {  // 中间的列表
    if (!_QukanCenterMain_collection) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeZero;
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        
        //设置CollectionView的属性
        _QukanCenterMain_collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        
        _QukanCenterMain_collection.backgroundColor = [UIColor whiteColor];
        _QukanCenterMain_collection.delegate = self;
        _QukanCenterMain_collection.dataSource = self;
        
        
        [_QukanCenterMain_collection registerClass:[QukanDailyHeaderCenterCell class] forCellWithReuseIdentifier:@"QukanDailyHeaderCenterCellID"];
        
    }
    return _QukanCenterMain_collection;
}

- (UICollectionView *)QukanBottomMain_collection {  // 中间的列表
    if (!_QukanBottomMain_collection) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeZero;
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        
        //设置CollectionView的属性
        _QukanBottomMain_collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        
        _QukanBottomMain_collection.backgroundColor = [UIColor whiteColor];
        _QukanBottomMain_collection.delegate = self;
        _QukanBottomMain_collection.dataSource = self;
        
        
        [_QukanBottomMain_collection registerClass:[QukanDailyHedaerBottomCell class] forCellWithReuseIdentifier:@"QukanDailyHedaerBottomCellID"];
        
    }
    return _QukanBottomMain_collection;
}

@end
