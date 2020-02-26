//
//  QukanBGViewController.m
//  Qukan
//
//  Created by Kody on 2019/8/13.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanBGViewController.h"
#import <UIViewController+HBD.h>
#import "QukanApiManager+PersonCenter.h"
#import "QukanBgModel.h"

@interface QukanBGViewController ()

@property(nonatomic, strong) UIScrollView    *scrollView;
@property(nonatomic, strong) UIView          *headView;
@property(nonatomic, strong) UIView          *bgeView;
@property(nonatomic, strong) UIView          *allView;

@property(nonatomic, strong) NSArray         *bgeListArr;
@property(nonatomic, strong) NSString        *bgePDStr;
@property(nonatomic, strong) NSString        *selectbgePDStr;
@property(nonatomic, strong) UIImageView     *headImageView;
@property(nonatomic, strong) UILabel         *bgeLabel;
@property(nonatomic, strong) UILabel        *joinTimeLabel;
@property(nonatomic, strong) NSArray <QukanBgModel *> *datas;

@end

@implementation QukanBGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self interFace];
    [self addScrollView];
    [self Qukan_gcUserBadgeSelectBadge];
}

- (void)interFace {
    self.hbd_barShadowHidden = YES;
    self.edgesForExtendedLayout = isIPhoneXSeries() ? UIRectEdgeNone : UIRectEdgeAll;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我的徽章";
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark ===================== SubViews ==================================

- (void)addScrollView {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, isIPhoneXSeries() ? -50 : 0, kScreenWidth,isIPhoneXSeries() ? kScreenHeight - 84 : kScreenHeight - 55)];
    [self.view addSubview:_scrollView];
    
    if (@available(iOS 11, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

#pragma mark - 添加头部视图
- (void)addHeadView {
    UIImageView * headView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, isIPhoneXSeries()?250:200)];
    headView.contentMode = UIViewContentModeScaleToFill;
    headView.backgroundColor = [UIColor whiteColor];
    [headView setImage:kImageNamed(@"Qukan_badgesImage")];
    [_scrollView addSubview:headView];
    _headView = headView;
    
    UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 40, 100, 80, 80)];
//    headImageView.image = [UIImage imageNamed:@"Qukan_crazyFansHeader"];
    headImageView.backgroundColor = HEXColor(0xF0F0F0);
    headImageView.layer.cornerRadius = headImageView.width / 2;
    headImageView.layer.masksToBounds = YES;
//    headImageView.backgroundColor = [UIColor redColor];
    [headView addSubview:headImageView];
    _headImageView = headImageView;
    
    UILabel *bgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, headImageView.bottom + 10, kScreenWidth - 100, 20)];
    bgeLabel.text = @"暂无徽章";
    bgeLabel.textColor = kCommonDarkGrayColor;
    bgeLabel.textAlignment = NSTextAlignmentCenter;
    bgeLabel.font = [UIFont systemFontOfSize:16];
    [headView addSubview:bgeLabel];
    _bgeLabel = bgeLabel;
    
    UILabel *joinTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, bgeLabel.bottom + 6 , kScreenWidth - 100, 12)];
    joinTimeLabel.text = @"快去点亮徽章吧";
    joinTimeLabel.textColor = HEXColor(0x666666);
    joinTimeLabel.textAlignment = NSTextAlignmentCenter;
    joinTimeLabel.font = [UIFont systemFontOfSize:11];
    [headView addSubview:joinTimeLabel];
    _joinTimeLabel = joinTimeLabel;
}


#pragma mark 设置头部数据
-(void)setUserHead{
    for (QukanBgModel *model in self.datas) {
        if ([model.code isEqualToString:self.bgePDStr]) {
            _bgeLabel.text = model.name;
            _joinTimeLabel.text = model.vals;
            __block NSInteger tag;
            if ([model.name isEqualToString:@"初出茅庐"]) {
                tag = QukanImageNumber_CCML_3;
            }else if ([model.name isEqualToString:@"疯狂球迷"]){
                tag = QukanImageNumber_FKFS_3;
            }else if ([model.name isEqualToString:@"神评达人"]){
                tag = QukanImageNumber_PLDR_3;
            }else if ([model.name isEqualToString:@"球场指挥官"]){
                tag = QukanImageNumber_ZHG_3;
            }else if ([model.name isEqualToString:[NSString stringWithFormat:@"%@达人",kStStatus.caseNum]]){
                tag = QukanImageNumber_RWDR_3;
            }else if ([model.name isEqualToString:FormatString(@"%@大虾",kStStatus.pageSize)]){
                tag = QukanImageNumber_HBDX_3;
            } else {
                tag = 0;
            }
            
            [self.headImageView sd_setImageWithURL:[QukanTool Qukan_getImageStr:[NSString stringWithFormat:@"%ld",tag]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            }];
            break;
        }
    }
}

- (void)addbgeView {
    
    UIView *bgeView = [[UIView alloc] initWithFrame:CGRectMake(0, _headView.bottom + 100, kScreenWidth, 500)];
    bgeView.backgroundColor = [UIColor whiteColor];
    bgeView.layer.cornerRadius = 10;
    bgeView.layer.masksToBounds = YES;
    [_scrollView addSubview:bgeView];
    _bgeView = bgeView;
    
    UILabel *badgesTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 10, 200, 20)];
    badgesTitleLabel.text = FormatString(@"%@徽章",kStStatus.dayNum);
    badgesTitleLabel.textColor = kCommonDarkGrayColor;
    badgesTitleLabel.font = [UIFont systemFontOfSize:15];
    [bgeView addSubview:badgesTitleLabel];
    
    NSMutableArray *headerImages = [NSMutableArray array];
    NSArray *numbers = @[FormatString(@"%ld",QukanImageNumber_CCML),FormatString(@"%ld",QukanImageNumber_FKFS),FormatString(@"%ld",QukanImageNumber_PLDR),FormatString(@"%ld",QukanImageNumber_ZHG),FormatString(@"%ld",QukanImageNumber_RWDR),FormatString(@"%ld",QukanImageNumber_HBDX),@"/10086666/12121"];
    for (int i = 0 ; i < numbers.count; i ++) {
        [headerImages addObject:[QukanTool Qukan_getImageStr:[numbers objectAtIndex:i]]];
    }
    NSMutableArray *iconImages = [NSMutableArray array];
    NSArray *iconNumbers = @[FormatString(@"%ld",QukanImageNumber_CCML_1),FormatString(@"%ld",QukanImageNumber_FKFS_1),FormatString(@"%ld",QukanImageNumber_PLDR_1),FormatString(@"%ld",QukanImageNumber_ZHG_1),FormatString(@"%ld",QukanImageNumber_RWDR_1),FormatString(@"%ld",QukanImageNumber_HBDX_1),@"/10086666/12121"];
    
    
    for (int i = 0 ; i < iconNumbers.count; i ++) {
        [iconImages addObject:[QukanTool Qukan_getImageStr:[iconNumbers objectAtIndex:i]]];
    }
    
    int number = 3;
    CGFloat clearanceW = 10;
    CGFloat indexViewW = (bgeView.width - (number - 1) * clearanceW) / number;
    CGFloat indexViewH = indexViewW;
    CGFloat imageW = 50;
    CGFloat imageH = imageW;
    for (int i = 0 ; i < numbers.count; i ++) {
        QukanBgModel *badgeModel = self.datas.count > i ? self.datas[i] : nil;
        UIView *indexView = [[UIView alloc] initWithFrame:CGRectMake((i % number) * (indexViewW + clearanceW), (i / number) * (indexViewH + clearanceW) + 40, indexViewW, indexViewH)];
        indexView.backgroundColor = [UIColor whiteColor];
        indexView.tag = i;
        [bgeView addSubview:indexView];
        
        UIImageView *badgesImageView = [[UIImageView alloc] initWithFrame:CGRectMake(indexViewW / 2 - imageW / 2, 10, imageW, imageH)];
        [badgesImageView sd_setImageWithURL: [iconImages objectAtIndex:i] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            
        }];
        badgesImageView.layer.cornerRadius = imageW / 2;
        badgesImageView.layer.masksToBounds = YES;
        badgesImageView.backgroundColor = [UIColor whiteColor];
        [indexView addSubview:badgesImageView];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, badgesImageView.bottom + 10, indexViewW, 20)];
        nameLabel.text = badgeModel.name;
        nameLabel.textColor = kCommonBlackColor;
        nameLabel.font = [UIFont systemFontOfSize:13];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        [indexView addSubview:nameLabel];
        
        UILabel *describeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, nameLabel.bottom, indexViewW - 20, 30)];
        describeLabel.text = badgeModel.vals;
        describeLabel.textColor = kTextGrayColor;
        describeLabel.font = [UIFont systemFontOfSize:11];
        describeLabel.numberOfLines = 2;
        describeLabel.textAlignment = NSTextAlignmentCenter;
        [indexView addSubview:describeLabel];
        
        if (i == iconNumbers.count - 1) {
            badgesImageView.backgroundColor = HEXColor(0xF0F0F0);
            nameLabel.font = [UIFont systemFontOfSize:12];
            nameLabel.text = @"敬请等待";
            nameLabel.mj_y = badgesImageView.mj_y + imageH/2 - 10;
        }
        
        for (NSString *code in self.bgeListArr) {
            if ([badgeModel.code isEqualToString:code]) {
                [badgesImageView sd_setImageWithURL:[headerImages objectAtIndex:i]];
            }
        }
        
        
        
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(indexViewTap:)];
        [indexView addGestureRecognizer:ges];
        
        bgeView.frame = CGRectMake(0,_headView.bottom + 100, kScreenWidth,indexView.bottom + 10);
        _scrollView.contentSize = CGSizeMake(kScreenWidth, bgeView.bottom + 20);
    }
}

#pragma mark ===================== Actions ============================
#pragma mark 徽章点击事件
- (void)indexViewTap:(UITapGestureRecognizer *)ges {
    @weakify(self);
    if (ges.view.tag >= self.datas.count) return;
    
        QukanBgModel *model = self.datas[ges.view.tag];
        if ([self.bgeListArr containsObject:model.code]) {
            QukanBgModel *badgeModel = self.datas.count > ges.view.tag ? self.datas[ges.view.tag] : nil;
//            NSArray *iconImageArray = @[@"Qukan_fledglingBig",@"Qukan_crazyFansBig",@"Qukan_commentPersonBig",@"Qukan_commanderBig",@"Qukan_taskPersonBig",@"Qukan_bigPrawnsBig",@""];
            
            NSMutableArray *iconImages = [NSMutableArray array];
            NSArray *numbers = @[FormatString(@"%ld",QukanImageNumber_CCML_2),FormatString(@"%ld",QukanImageNumber_FKFS_2),FormatString(@"%ld",QukanImageNumber_PLDR_2),FormatString(@"%ld",QukanImageNumber_ZHG_2),FormatString(@"%ld",QukanImageNumber_RWDR_2), FormatString(@"%ld",QukanImageNumber_HBDX_2),@""];
            
            
            for (int i = 0 ; i < numbers.count; i ++) {
                [iconImages addObject:[QukanTool Qukan_getImageStr:[numbers objectAtIndex:i]]];
            }
            
            UIView * allView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
            allView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
            [kwindowLast addSubview:allView];
            _allView = allView;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCilk:)];
            [allView addGestureRecognizer:tap];
            
            UIView *showView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 654 / 2, 456 / 2)];
            showView.backgroundColor = [UIColor whiteColor];
            showView.userInteractionEnabled = YES;
            showView.layer.cornerRadius = 5;
            showView.center = allView.center;
            [allView addSubview:showView];
            
            UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, -70, showView.width - 40 , 100)];
            [iconImageView sd_setImageWithURL:iconImages[ges.view.tag] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                iconImageView.image = [image imageByResizeToSize:CGSizeMake(750 / 2, 370 / 2) contentMode:0];
            }];
            iconImageView.contentMode = UIViewContentModeCenter;
            iconImageView.backgroundColor = [UIColor clearColor];
            [showView addSubview:iconImageView];
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, iconImageView.bottom + 50, showView.width - 20, 25)];
            titleLabel.text = badgeModel.name;
            titleLabel.textColor = kCommonDarkGrayColor;
            titleLabel.font = [UIFont systemFontOfSize:25];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            [showView addSubview:titleLabel];
            
            UILabel *describeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, titleLabel.bottom + 9, showView.width - 20, 30)];
            describeLabel.text = badgeModel.vals;
            describeLabel.textColor = kTextGrayColor;
            describeLabel.textAlignment = NSTextAlignmentCenter;
            describeLabel.font = [UIFont systemFontOfSize:14];
            [showView addSubview:describeLabel];
            
            UIButton *wearButton = [UIButton buttonWithType:UIButtonTypeCustom];
            wearButton.frame = CGRectMake(showView.width / 2 - 132 / 2, describeLabel.bottom + 25,132, 34);
            [wearButton setTitle:@"点击佩戴" forState:UIControlStateNormal];
            [wearButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            wearButton.backgroundColor = kThemeColor;
            wearButton.layer.cornerRadius = wearButton.height / 2;
            wearButton.titleLabel.font = kFont16;
            [showView addSubview:wearButton];
            [[wearButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
                @strongify(self);
                [self wearButtonWithModel:badgeModel];
            }];
            
            UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
            cancleButton.frame = CGRectMake(kScreenWidth / 2 - 30, showView.bottom + 20, 60, 60);
            [cancleButton setImage:kImageNamed(@"Qukan_windowClosed") forState:UIControlStateNormal];
            [allView addSubview:cancleButton];
            [[cancleButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
                @strongify(self);
                [self tapCilk:nil];
            }];
        }else{
            [self Qukan_GcUserBadgeBadgeDlWithCode:model.code];
        }
    
    
    
}

- (void)wearButtonWithModel:(QukanBgModel *)badgeModel {
    [self tapCilk:nil];
    self.selectbgePDStr = badgeModel.code;
    
    [self Qukan_gcUserBadgeBadgePdWithCode:badgeModel.code];
}

- (void)dataSourceWith:(id)response {
    NSArray *array = (NSArray *)response;
    if (!array.count) {return;}
    self.datas = [NSArray modelArrayWithClass:[QukanBgModel class] json:array];
    
    [self.headView removeFromSuperview];
    [self addHeadView];
    [self setUserHead];
    
    [self.bgeView removeFromSuperview];
    [self addbgeView];
}

#pragma mark ===================== NetWork ==================================
#pragma mark 获取用户的徽章列表与佩戴的徽章信息
- (void)Qukan_gcUserBadgeSelectBadge {
    @weakify(self)
    [[[kApiManager QukanGcUserHeadImage] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        KHideHUD
        DEBUGLog(@"%@",x);
        if(![x[0][@"badgePd"] isKindOfClass:[NSNull class]]){
            self.bgePDStr = x[0][@"badgePd"];
        }else{
//            self.bgePDStr = @"badge-2";
        }
        
       
        if([x[0][@"badgeDl"] count] != 0){
            self.bgeListArr = x[0][@"badgeDl"];
        }else{
//            self.bgeListArr = @[@"badge-1",@"badge-2",@"badge-3"];
        }
        
        [self Qukan_gcUserBadgeSelectParmList];
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        KHideHUD
    }];
}
#pragma mark - 获取徽章列表
- (void)Qukan_gcUserBadgeSelectParmList {
    @weakify(self)
    [[[kApiManager QukanGcUserSelectParmList] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        DEBUGLog(@"%@",x);
        [self dataSourceWith:x];
        
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        KHideHUD
    }];
}


#pragma mark - 佩戴徽章的请求
- (void)Qukan_gcUserBadgeBadgePdWithCode:(NSString *)code {
    @weakify(self)
    [[[kApiManager QukanGcUserDataWithCode:code] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        KHideHUD
        [SVProgressHUD showSuccessWithStatus:@"操作成功"];
        
        self.bgePDStr = self.selectbgePDStr;
        [self setUserHead];
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        KHideHUD
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

#pragma mark - 点亮徽章
- (void)Qukan_GcUserBadgeBadgeDlWithCode:(NSString *)code {
    @weakify(self)
    [[[kApiManager QukanGcUserDlWithCode:code] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        KHideHUD
        [SVProgressHUD showSuccessWithStatus:@"操作成功"];
        [self Qukan_gcUserBadgeSelectBadge];
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        KHideHUD
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}
//QukanGcUserDlWithCode


- (void)tapCilk:(UITapGestureRecognizer *)ges {
    [_allView removeAllSubviews];
    [_allView removeFromSuperview];
}


@end
