//
//  QukanPersonalCenterHeaderView.m
//  Qukan
//
//  Created by Kody on 2019/8/13.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanPersonalCenterHeaderView.h"


#import "QukanUserHeaderListCell.h"

#define kViewMargin 8
@interface QukanPersonalCenterHeaderView() <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

// 顶部背景view
@property(nonatomic, strong) UIView            *QukanTopBg_view;
// 中间的view
@property(nonatomic, strong) UIView            *QukanMidBg_view;
// 底部的view
@property(nonatomic, strong) UIView            *QukanBottonBg_view;

// 中间的列表
@property(nonatomic, strong) UICollectionView   *QukanCenterContent_collection;

// 用户头像
@property(nonatomic, strong) UIButton          *QukanUserHeader_btn;
// 用户昵称
@property(nonatomic, strong) UILabel           *QukanUserName_lab;
// 用户id
@property(nonatomic, strong) UILabel           *QukanId_lab;
// 欢迎lab
@property(nonatomic, strong) UILabel           *QukanWelcome_lab;

/**方向小图标*/
@property(nonatomic, strong) UIImageView     *QukanArrow_img ;


/**中部视图数据源*/
@property(nonatomic, strong) NSMutableArray   * arr_source;

@end

@implementation QukanPersonalCenterHeaderView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kCommentBackgroudColor;
        [self initUI];
    }
    return self;
}


- (void)initUI {
    [self addTopSubviews];
    
    if ([QukanTool Qukan_xuan:kQukan10] == 1) {
        [self addMidSubviews];
    }
    
    [self addBottomViews];
}


- (void)addTopSubviews {
    [self addSubview:self.QukanTopBg_view];
    
    [self.QukanTopBg_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(@(280 * screenScales));
    }];
    
    
    [self.QukanTopBg_view addSubview:self.QukanUserHeader_btn];
    [self.QukanUserHeader_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.QukanTopBg_view);
        make.left.equalTo(self.QukanTopBg_view).offset(15);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    [self.QukanTopBg_view addSubview:self.QukanUserName_lab];
    [self.QukanUserName_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.QukanUserHeader_btn.mas_centerY).offset(-5);
        make.left.equalTo(self.QukanUserHeader_btn.mas_right).offset(10);
        make.width.lessThanOrEqualTo(@(200));
    }];
    
    [self.QukanTopBg_view addSubview:self.BadgeBtn];
    [self.BadgeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.QukanUserName_lab);
        make.left.equalTo(self.QukanUserName_lab.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    [self.QukanTopBg_view addSubview:self.QukanWelcome_lab];
    [self.QukanWelcome_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.QukanUserHeader_btn.mas_right).offset(10);
        make.centerY.equalTo(self.QukanUserHeader_btn);
    }];
    
    [self.QukanTopBg_view addSubview:self.QukanId_lab];
    [self.QukanId_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.QukanUserHeader_btn.mas_centerY).offset(5);
        make.left.equalTo(self.QukanUserName_lab);
        make.width.equalTo(@(100));
    }];
    
    [self.QukanTopBg_view addSubview:self.QukanArrow_img];
    [self.QukanArrow_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.QukanUserHeader_btn);
        make.right.equalTo(self.QukanTopBg_view).offset(-15);
    }];
}

- (void)addMidSubviews {
    [self addSubview:self.QukanMidBg_view];
    [self.QukanMidBg_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.height.equalTo(@(100));
        make.bottom.equalTo(self.QukanTopBg_view).offset(30);
    }];
    
    [self.QukanMidBg_view addSubview:self.QukanCenterContent_collection];
    [self.QukanCenterContent_collection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.QukanMidBg_view);
    }];
    
}

- (void)addBottomViews {
    [self addSubview:self.QukanBottonBg_view];
    
    if ([QukanTool Qukan_xuan:kQukan10] == 1) {
        [self.QukanBottonBg_view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.QukanMidBg_view.mas_bottom).offset(25);
            make.left.right.equalTo(self);
            make.height.equalTo(@(86));
        }];
    }else {
        [self.QukanBottonBg_view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.QukanTopBg_view.mas_bottom).offset(25);
            make.left.right.equalTo(self);
            make.height.equalTo(@(86));
        }];
    }
    
    
    
    UIImageView *bgImg = [UIImageView new];
    bgImg.image = kImageNamed(@"user_centerheader_BottomBg");
    [self.QukanBottonBg_view addSubview:bgImg];
    [bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.QukanBottonBg_view);
    }];
    
    UIImageView *shareTextImg = [UIImageView new];
    shareTextImg.image = kImageNamed(@"user_center_shareBall");
    [self.QukanBottonBg_view addSubview:shareTextImg];
    [shareTextImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.QukanBottonBg_view).offset(12);
        make.left.equalTo(self.QukanBottonBg_view).offset(30 * screenScales);
        make.size.mas_equalTo(CGSizeMake(120, 30));
    }];

    UILabel *goLab = [UILabel new];
    goLab.text = @"GO >";
    goLab.textColor = kThemeColor;
    goLab.font = kFont14;
    goLab.backgroundColor = kCommonWhiteColor;
    goLab.textAlignment = NSTextAlignmentCenter;
    goLab.layer.masksToBounds = YES;
    goLab.layer.cornerRadius = 10;
    [self.QukanBottonBg_view addSubview:goLab];
    [goLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shareTextImg);
        make.bottom.equalTo(@(-14));
        make.size.mas_equalTo(CGSizeMake(52, 20));
    }];
    
    UIImageView *iconImg = [UIImageView new];
//    iconImg.image = kImageNamed(@"user_header_bottomBg");
    [iconImg sd_setImageWithURL:[QukanTool Qukan_getImageStr:@"user_header_bottomBg"]];
    [self.QukanBottonBg_view addSubview:iconImg];
    [iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.bottom.equalTo(self.QukanBottonBg_view).offset(9);
        make.size.mas_equalTo(CGSizeMake(183, 120));
    }];
}


#pragma mark ===================== public fuction ==================================
- (void)freshUserHeaderTopView {
    [kUserManager isLogin]?[self setLoginData]:[self setNoLoginData];
}

- (void)freshUserHeaderMidViewWithArr:(NSArray *)arr{
    self.arr_source = arr.mutableCopy;
    [self.QukanCenterContent_collection reloadData];
}

#pragma mark ===================== privete function ==================================
- (void)setLoginData {
    NSLog(@"%@",kUserManager.user.avatorId);
    [self.QukanUserHeader_btn sd_setBackgroundImageWithURL:[NSURL URLWithString:kUserManager.user.avatorId] forState:UIControlStateNormal placeholderImage:kImageNamed(@"Qukan_user_DefaultAvatar")];
    
    self.QukanUserName_lab.hidden = NO;
    self.QukanId_lab.hidden = NO;
    self.BadgeBtn.hidden = self.QukanUserName_lab.hidden;
    self.QukanWelcome_lab.hidden = YES;
    
    self.QukanUserName_lab.text = kUserManager.user.nickname.length > 0?kUserManager.user.nickname:@"外星人";
    self.QukanId_lab.text = [NSString stringWithFormat:@"ID:%@",kUserManager.user.appId];
    
}

- (void)setNoLoginData {
    [self.QukanUserHeader_btn setBackgroundImage:kImageNamed(@"Qukan_user_DefaultAvatar") forState:UIControlStateNormal];
    
    self.QukanUserName_lab.hidden = YES;
    self.QukanId_lab.hidden = YES;
    self.BadgeBtn.hidden = self.QukanUserName_lab.hidden;
    self.QukanWelcome_lab.hidden = NO;
}


- (void)topViewTap {
    self.topViewDidSele(10086);
}

- (void)bottomViewTap {
    self.bottomViewDidSele(10086);
}

#pragma mark ===================== collectionview delegate datasource==================================
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QukanUserHeaderListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QukanUserHeaderListCellID" forIndexPath:indexPath];
    
    [cell fullCellWithIndex:indexPath.row andDatas:self.arr_source];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%zd", indexPath.row);
}

// 定义每个UICollectionView的纵向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kScreenWidth / 3 - 10 , 100);
}


#pragma mark ===================== lazy ==================================
- (UICollectionView *)QukanCenterContent_collection {
    if (!_QukanCenterContent_collection) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(kScreenWidth / 4 , 80);
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        //设置CollectionView的属性
        _QukanCenterContent_collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        
        _QukanCenterContent_collection.backgroundColor = [UIColor whiteColor];
        _QukanCenterContent_collection.delegate = self;
        _QukanCenterContent_collection.dataSource = self;
        _QukanCenterContent_collection.scrollEnabled = NO;
        
        [_QukanCenterContent_collection registerNib:[UINib nibWithNibName:@"QukanUserHeaderListCell" bundle:nil] forCellWithReuseIdentifier:@"QukanUserHeaderListCellID"];
    }
    return _QukanCenterContent_collection;
}

// 顶部背景
- (UIView *)QukanTopBg_view {
    if (!_QukanTopBg_view) {
        _QukanTopBg_view = [UIView new];
        _QukanTopBg_view.backgroundColor = HEXColor(0x2A2A2A);
        
        _QukanTopBg_view.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topViewTap)];
        [_QukanTopBg_view addGestureRecognizer:tap];
    }
    return _QukanTopBg_view;
}


- (UILabel *)QukanId_lab {
    if (!_QukanId_lab) {
        _QukanId_lab = [UILabel new];
        _QukanId_lab.text = @"ID:---";
        _QukanId_lab.textColor = kCommonWhiteColor;
        _QukanId_lab.font = [UIFont systemFontOfSize:12];

    }
    return _QukanId_lab;
}


- (UILabel *)QukanUserName_lab {
    if (!_QukanUserName_lab) {
        _QukanUserName_lab = [UILabel new];
        _QukanUserName_lab.text = @"---";
        _QukanUserName_lab.textColor = kCommonWhiteColor;
        _QukanUserName_lab.font = [UIFont systemFontOfSize:20];
        
    }
    return _QukanUserName_lab;
}

- (UIButton *)QukanUserHeader_btn {
    if (!_QukanUserHeader_btn) {
        _QukanUserHeader_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _QukanUserHeader_btn.userInteractionEnabled = NO;
        _QukanUserHeader_btn.layer.masksToBounds = YES;
        _QukanUserHeader_btn.layer.cornerRadius = 30;
        [_QukanUserHeader_btn setBackgroundImage:kImageNamed(@"Qukan_user_DefaultAvatar") forState:UIControlStateNormal];
    }
    return _QukanUserHeader_btn;
}

- (UILabel *)QukanWelcome_lab {
    if (!_QukanWelcome_lab) {
        _QukanWelcome_lab = [UILabel new];
        _QukanWelcome_lab.text = @"欢迎来到看球大师";
        _QukanWelcome_lab.textColor = kCommonWhiteColor;
        _QukanWelcome_lab.font = [UIFont systemFontOfSize:20];
    }
    return _QukanWelcome_lab;
}

- (UIView *)QukanMidBg_view {  // 中间背景
    if (!_QukanMidBg_view) {
        _QukanMidBg_view = [UIView new];
        _QukanMidBg_view.backgroundColor = kCommonWhiteColor;
    }
    return _QukanMidBg_view;
}

- (UIView *)QukanBottonBg_view {  // 底部背景
    if (!_QukanBottonBg_view) {
        _QukanBottonBg_view = [UIView new];
        _QukanBottonBg_view.backgroundColor = kThemeColor;
        
        _QukanBottonBg_view.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bottomViewTap)];
        [_QukanBottonBg_view addGestureRecognizer:tap];
    }
    return _QukanBottonBg_view;
}

- (UIImageView *)QukanArrow_img {
    if (!_QukanArrow_img) {
        _QukanArrow_img = [UIImageView new];
        _QukanArrow_img.image = kImageNamed(@"arrow_toRight");
    }
    return _QukanArrow_img;
}

-(NSMutableArray *)arr_source {
    if (!_arr_source) {
        _arr_source = [NSMutableArray new];
    }
    return _arr_source;
}

- (UIButton *)BadgeBtn {
    if (!_BadgeBtn) {
        _BadgeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _BadgeBtn;
}
@end
