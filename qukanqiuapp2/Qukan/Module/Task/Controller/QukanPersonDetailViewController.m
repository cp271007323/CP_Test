//
//  QukanPersonDetailViewController.m
//  Qukan
//
//  Created by Kody on 2019/8/13.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanPersonDetailViewController.h"
#import "QukanPersonChangeViewController.h"
#import "QukanApiManager+PersonCenter.h"
#import <UIViewController+HBD.h>
#import "QukanShowChangeViewController.h"
#import "QukanBangDingPhoneView.h"
#import "QukanWeekModel.h"
#import "QukanDailyVC.h"
#import "QukanScreenModel.h"

@interface QukanPersonDetailViewController ()

@property(nonatomic, strong) UIScrollView            *scrollView;
@property(nonatomic, strong) UIView                  *topView;
@property(nonatomic, strong) UIView                  *midView;
@property(nonatomic, strong) UIView                  *bottomView;
@property(nonatomic, strong) UIView                  *promptView;
@property(nonatomic, strong) UIView                  *taskView;

@property(nonatomic, strong) UIButton         *seleButton;
@property(nonatomic, strong) UIButton         *eButton;
@property(nonatomic, strong) UIButton         *envelopeButton;
@property(nonatomic, strong) UIButton         *wxOrWwButton;
@property(nonatomic, strong) UIButton         *availableButton;

@property(nonatomic, strong) UILabel          *jRelatedLabel;
@property(nonatomic, strong) UILabel          *totaljLabel;
@property(nonatomic, strong) UILabel          *availableEnvelopeLabel;
@property(nonatomic, strong) UILabel          *boundWxLabel;

//@property(nonatomic, strong) NSDictionary     *datas;

@property(nonatomic, assign) CGFloat          tLabelH;
@property(nonatomic, strong)QukanBangDingPhoneView *testView;
/**数据模型*/
@property (strong, nonatomic)  QukanWeekModel *model;


@end

@implementation QukanPersonDetailViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

//保证进入下个界面nav正常显示
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addScrollView];
    [self addTopView];
    [self addMidView];
    [self addBottomView];
//    [self addPromptView];
    [self QukanSelectDate];
    [self Qukan_getSig];
    
    
    self.hbd_barStyle = UIBarStyleDefault;
    self.hbd_tintColor = kCommonWhiteColor;
    self.hbd_barShadowHidden = YES;
    self.title = kStStatus.talk;
    self.hbd_barImage = [UIImage imageWithColor:HEXColor(0x2e2f36)];
}


-(void)weXinBangDing{
    [SVProgressHUD show];
    @weakify(self)
    [[[kApiManager QukanGcUserCollectionQuery] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [SVProgressHUD dismiss];
        
        if ([x[@"status"] integerValue] == 0) {
            self.wxOrWwButton.tag = 3;
            [self.wxOrWwButton setTitle:[NSString stringWithFormat:@"绑定%@",kStStatus.name] forState:UIControlStateNormal];
        }else{
            self.wxOrWwButton.tag = 5;
            [self.wxOrWwButton setTitle:[kCacheManager QukangetStStatus].pageNum forState:UIControlStateNormal];
        }
        
    } error:^(NSError * _Nullable error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
    

    
}


#pragma mark ===================== SubViews ==================================

- (void)addScrollView {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, isIPhoneXSeries() ? kScreenHeight  : kScreenHeight )];
    [self.view addSubview:scrollView];
    scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView = scrollView;
}

- (void)addTopView {
    @weakify(self);
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 130)];
    topView.backgroundColor = HEXColor(0x2e2f36);
    [_scrollView addSubview:topView];
    _topView = topView;
    
    UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, kScreenWidth - 40, 120)];
       
    [topImageView sd_setImageWithURL:[QukanTool Qukan_getImageStr:FormatString(@"%ld",QukanImageNumber_DHBJ)] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
         topImageView.image = [image imageByResizeToSize:CGSizeMake(669 / 2, 197 / 2) contentMode:0];
    }];
    topImageView.backgroundColor = HEXColor(0x2e2f36);
    topImageView.userInteractionEnabled = YES;
    [topView addSubview:topImageView];
    
    UILabel *jRelatedLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, topImageView.width - 30, 20)];
//    jRelatedLabel.text = FormatString(@"今日获得%@200        累计获得%@666",kStStatus.duration,kStStatus.duration);
    jRelatedLabel.textColor = kCommonDarkGrayColor;
    jRelatedLabel.font = [UIFont systemFontOfSize:13];
    jRelatedLabel.backgroundColor = [UIColor clearColor];
    [topImageView addSubview:jRelatedLabel];
    _jRelatedLabel = jRelatedLabel;
    
    UILabel *totaljLabel = [[UILabel alloc] initWithFrame:CGRectMake(jRelatedLabel.left, jRelatedLabel.bottom + 10,  topImageView.width - 30, 30)];
    totaljLabel.text = @"0";
    totaljLabel.textColor = kCommonDarkGrayColor;
    totaljLabel.font = [UIFont systemFontOfSize:25];
    [topImageView addSubview:totaljLabel];
    _totaljLabel = totaljLabel;
    
    UIButton *availableButton = [[UIButton alloc] initWithFrame:CGRectMake(totaljLabel.left, totaljLabel.bottom, 100, 15)];
    [availableButton setTitle:FormatString(@"可%@%@",kStStatus.email,kStStatus.duration) forState:UIControlStateNormal];
    [availableButton setTitleColor:kCommonDarkGrayColor forState:UIControlStateNormal];
    [availableButton setImage:[kImageNamed(@"Qukan_PublishRecommendSection") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    availableButton.tintColor = kCommonTextColor;
    
    // 先设置title，图片的x由title宽度决定
    [availableButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -availableButton.imageView.width, 0, availableButton.imageView.width)];
    [availableButton setImageEdgeInsets:UIEdgeInsetsMake(0, availableButton.titleLabel.width - 35, 0, -availableButton.titleLabel.width)];
    availableButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    availableButton.titleLabel.font = kFont11;
    [topImageView addSubview:availableButton];
    _availableButton = availableButton;
    
    
    UIButton *wxOrWwButton = [UIButton buttonWithType:UIButtonTypeCustom];
    wxOrWwButton.frame = CGRectMake(topImageView.width - 80, totaljLabel.bottom, 70, 15);
    [wxOrWwButton setTitle:[NSString stringWithFormat:@"绑定%@",kStStatus.name] forState:UIControlStateNormal];
    wxOrWwButton.titleLabel.font = kFont14;
    [wxOrWwButton setTitleColor:kCommonBlackColor forState:UIControlStateNormal];
    wxOrWwButton.tag = 4;
    [topImageView addSubview:wxOrWwButton];
    _wxOrWwButton = wxOrWwButton;
    [[wxOrWwButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self buttonCilck:wxOrWwButton];
    }];
}

- (void)addMidView {
    UIView *midView = [[UIView alloc] initWithFrame:CGRectMake(0, self.topView.bottom, kScreenWidth, 55)];
    midView.backgroundColor = HEXColor(0x464954);
    [_scrollView addSubview:midView];
    _midView = midView;
    
    CGFloat buttonw = kScreenWidth / 2;
    CGFloat buttonH = midView.height;
    UIButton *eButton = [UIButton buttonWithType:UIButtonTypeCustom];
    eButton.frame = CGRectMake(0, 0, buttonw, buttonH);
    eButton.titleLabel.font = kSystemFont(15);
    [eButton setTitle:FormatString(@" %@%@",kStStatus.duration,kStStatus.email) forState:UIControlStateNormal];

    [eButton sd_setImageWithURL:[QukanTool Qukan_getImageStr:FormatString(@"%ld",QukanImageNumber_JFDH_D)] forState:UIControlStateNormal completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [eButton setImage:[image imageByResizeToSize:CGSizeMake(30, 30) contentMode:0] forState:UIControlStateNormal];
    }];
    
    [eButton sd_setImageWithURL:[QukanTool Qukan_getImageStr:FormatString(@"%ld",QukanImageNumber_JFDH)] forState:UIControlStateSelected completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [eButton setImage:[image imageByResizeToSize:CGSizeMake(30, 30) contentMode:0] forState:UIControlStateSelected];
    }];
    
    [eButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [eButton setTitleColor:HEXColor(0xbdae84) forState:UIControlStateSelected];
    eButton.backgroundColor = [UIColor clearColor];
    eButton.tag = 1;
    [midView addSubview:eButton];
    _eButton = eButton;
    @weakify(self);
    [[eButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self buttonCilck:eButton];
    }];
    
    UIButton *envelopeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    envelopeButton.frame = CGRectMake(buttonw, 0, buttonw, buttonH);
    envelopeButton.titleLabel.font = kSystemFont(14);
    [envelopeButton setTitle:FormatString(@" %@%@",[kCacheManager QukangetStStatus].pageSize,[kCacheManager QukangetStStatus].pageNum) forState:UIControlStateNormal];
    
    [envelopeButton sd_setImageWithURL:[QukanTool Qukan_getImageStr:FormatString(@"%ld",QukanImageNumber_HBDH_D)] forState:UIControlStateNormal completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
         [envelopeButton setImage:[image imageByResizeToSize:CGSizeMake(30, 30) contentMode:0] forState:UIControlStateNormal];
    }];
    
    [envelopeButton sd_setImageWithURL:[QukanTool Qukan_getImageStr:FormatString(@"%ld",QukanImageNumber_HBDH)] forState:UIControlStateSelected completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
         [envelopeButton setImage:[image imageByResizeToSize:CGSizeMake(30, 30) contentMode:0] forState:UIControlStateSelected];
    }];
    
    [envelopeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [envelopeButton setTitleColor:kThemeColor forState:UIControlStateSelected];
    envelopeButton.backgroundColor = [UIColor clearColor];
    envelopeButton.tag = 2;
    [midView addSubview:envelopeButton];
    _envelopeButton = envelopeButton;
    [[envelopeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self buttonCilck:envelopeButton];
    }];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 2, 20, 1, midView.height - 40)];
    lineLabel.backgroundColor = [UIColor whiteColor];
    [midView addSubview:lineLabel];
}

- (void)addBottomView {
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.midView.bottom + 10, kScreenWidth, 160)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:bottomView];
    _bottomView = bottomView;
    
    
    //    UIButton *imgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    imgButton.frame = CGRectMake(10, 15, 10, 10);
    //    imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    //    [imgButton setImage:img forState:UIControlStateNormal];
    //    [imgButton setTintColor:HEXColor(0xd4d4d4)];
    //    imgButton.titleLabel.font = kFont11;
    //    [bottomView addSubview:imgButton];
    //
    //    UIButton *agreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    agreeButton.frame = CGRectMake(25, 10, 150, 20);
    //    [agreeButton setTitle:@"我已阅读并同意服务条款" forState:UIControlStateNormal];
    //    agreeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //    [agreeButton setTitleColor:kCommonDarkGrayColor forState:UIControlStateNormal];
    //    agreeButton.titleLabel.font = kFont11;
    //    [bottomView addSubview:agreeButton];
    //    [[agreeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
    //
    //    }];
    
    UIView *taskView = [[UIView alloc] initWithFrame:CGRectMake(10, 15, kScreenWidth - 20, 100)];
    taskView.backgroundColor = RGBA(255, 239, 203, 1);
    taskView.layer.cornerRadius = 5;
    taskView.layer.masksToBounds = YES;
    [bottomView addSubview:taskView];
    _taskView = taskView;
    
    UILabel *tLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth - 40, 20)];
    tLabel.text = kStStatus.names;
    tLabel.numberOfLines = 0;
    tLabel.textColor = kCommonDarkGrayColor;
    tLabel.font = [UIFont systemFontOfSize:12];
    [taskView addSubview:tLabel];
    
    
    
    CGFloat tLabelH = [tLabel.text heightForFont:tLabel.font width:kScreenWidth - 40];
    tLabel.frame = CGRectMake(10, 10, kScreenWidth - 40, tLabelH);
    taskView.frame = CGRectMake(10, 15, kScreenWidth - 20, tLabelH + 20);
    _tLabelH = tLabelH;
    
    
    UILabel *boundWxLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, tLabelH + 30, kScreenWidth - 60 - 20, 25)];
    
    boundWxLabel.text = kStStatus.title;
    boundWxLabel.textColor = kCommonDarkGrayColor;
    boundWxLabel.numberOfLines = 0;
    boundWxLabel.layer.cornerRadius = boundWxLabel.height / 2;
    boundWxLabel.layer.masksToBounds = YES;
    boundWxLabel.font = [UIFont systemFontOfSize:10];
    boundWxLabel.textAlignment = NSTextAlignmentCenter;
    boundWxLabel.backgroundColor = HEXColor(0xFFECC3);
    [taskView addSubview:boundWxLabel];
    _boundWxLabel = boundWxLabel;
    boundWxLabel.hidden = YES;
    //
    //    UIImageView *codeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 40, 10, 80, 80)];
    //    codeImageView.image = [UIImage imageNamed:@"Qukan_bj"];
    //    codeImageView.backgroundColor = [UIColor whiteColor];
    //    [bottomView addSubview:codeImageView];
    //
    //    UILabel *promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, codeImageView.bottom + 20, kScreenWidth - 20, 20)];
    //    promptLabel.textColor = kCommonWhiteColor;
    //    promptLabel.numberOfLines = 0;
    //    promptLabel.font = [UIFont systemFontOfSize:12];
    //    [bottomView addSubview:promptLabel];
    //    CGFloat promptHight = [promptLabel.text heightForFont:promptLabel.font width:kScreenWidth - 20];
    //    promptLabel.frame = CGRectMake(10, codeImageView.bottom + 20, kScreenWidth - 20, promptHight);
    
}

- (void)addPromptViewWithString:(NSString *)Str {
    UIView *promptView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 200, kScreenWidth, 200)];
    promptView.backgroundColor = RGB(237, 237, 237);
    [_scrollView addSubview:promptView];
    _promptView = promptView;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, kScreenWidth - 40, 20)];
    titleLabel.text = FormatString(@"%@规则",[kCacheManager QukangetStStatus].pageNum);
    titleLabel.textColor = kCommonBlackColor;
    titleLabel.font = [UIFont systemFontOfSize:15];
    [promptView addSubview:titleLabel];
    
    CGFloat labelMargin = 10;
    CGFloat labelY = 0;
    
    
    Str = [Str stringByReplacingOccurrencesOfString:@"\\n" withString:@"\r\n" ];
    Str = [Str stringByReplacingOccurrencesOfString:@" " withString:@"" ];
    Str = [Str stringByReplacingOccurrencesOfString:@"&gt;" withString:@">" ];
    
    UILabel *label = [[UILabel alloc] init];
   label.text = Str;
   label.textColor = kCommonBlackColor;
   label.font = [UIFont systemFontOfSize:12];
   label.numberOfLines = 0;
   [promptView addSubview:label];
   CGFloat labelHeight = [label.text heightForFont:label.font width:kScreenWidth - 20];
   label.frame = CGRectMake(10, 50, kScreenWidth - 20, labelHeight);
   labelY = labelY + labelHeight + labelMargin;
    
    CGFloat offset = isIPhoneXSeries() ? 120 : 94;
    promptView.frame = CGRectMake(0, kScreenHeight - labelY - 20 - offset - kSafeAreaBottomHeight, kScreenWidth, labelY + 20 +kSafeAreaBottomHeight);
    
    [self buttonCilck:_eButton];
    _scrollView.contentSize = CGSizeMake(kScreenWidth, promptView.bottom);
}

#pragma mark ===================== NetWork ==================================

- (void)QukanSelectDate {
    
    @weakify(self)
    KShowHUD
    [[[kApiManager QukanSelectDate] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        KHideHUD
        [self dataSourceWith:x];
    } error:^(NSError * _Nullable error) {
        kShowTip(error.localizedDescription)
    }];
}

- (void)dataSourceWith:(id)response {
    //    self.datas = response[@"data"];
    self.model = [QukanWeekModel modelWithJSON: response];
    NSInteger todayScore = self.model.todayScore.integerValue;
    NSInteger totalScore = self.model.totalScore.integerValue;
    NSInteger theScore =  self.model.theScore.integerValue;
    _jRelatedLabel.text = [NSString stringWithFormat:@"今日获得%@%ld            累计获得%@%ld",kStStatus.duration,todayScore,kStStatus.duration,totalScore];
    _totaljLabel.text = [NSString stringWithFormat:@"%ld",theScore];
}



- (void)buttonSwitch {
    
}

- (void)Qukan_getSig {
    @weakify(self)
    [[[kApiManager QukanGetSig] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if ([x isKindOfClass:[NSString class]]) {
            [self addPromptViewWithString:x];
        }
    } error:^(NSError * _Nullable error) {
        
    }];
}


#pragma mark ===================== Actions ============================

- (void)buttonCilck:(UIButton *)button {
    
    if (button.tag == 1) {//
         if (_eButton.selected) return;
        _eButton.selected = YES;
        _envelopeButton.selected = NO;
        _boundWxLabel.hidden = YES;
        self.promptView.hidden = YES;
        _taskView.frame = CGRectMake(10,_taskView.origin.y, kScreenWidth - 20, _tLabelH + 20);
        [_wxOrWwButton setTitle:kStStatus.email forState:UIControlStateNormal];
        _wxOrWwButton.tag = 4;
        
        NSInteger todayScore = self.model.todayScore.integerValue;
        NSInteger totalScore = self.model.totalScore.integerValue;
        NSInteger theScore =  self.model.theScore.integerValue;
        _jRelatedLabel.text = [NSString stringWithFormat:@"今日获得%@%ld            累计获得%@%ld",kStStatus.duration,todayScore,kStStatus.duration,totalScore];
        _totaljLabel.text = [NSString stringWithFormat:@"%ld",theScore];
        
        [_availableButton setTitle:FormatString(@"可%@%@",kStStatus.email,kStStatus.duration) forState:UIControlStateNormal];
        
        // 先设置title，图片的x由title宽度决定
        [_availableButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -_availableButton.imageView.width, 0, _availableButton.imageView.width)];
        [_availableButton setImageEdgeInsets:UIEdgeInsetsMake(0, _availableButton.titleLabel.width+5, 0, -_availableButton.titleLabel.width-5)];
        
    } else if (button.tag == 2) {//hongbaotixian
        if (_envelopeButton.selected) return;
        _eButton.selected = NO;
        _envelopeButton.selected = YES;
        _boundWxLabel.hidden = NO;
        self.promptView.hidden = NO;
        _taskView.frame = CGRectMake(10,_taskView.origin.y, kScreenWidth - 20, _tLabelH + 20 + 50);
        
        [self weXinBangDing];
//        _jRelatedLabel.text = FormatString(@"今日获得%@200           累计获得%@666",kStStatus.pageSize,kStStatus.pageSize);
   
        NSInteger todayScore = self.model.todayNum.integerValue;
        NSInteger totalScore = self.model.totalNum.integerValue;
        NSInteger theScore =  self.model.changeNum.integerValue;
        _jRelatedLabel.text = [NSString stringWithFormat:@"今日获得%@%ld%@           累计获得%@%ld%@",kStStatus.pageSize,todayScore,kStStatus.dark, kStStatus.pageSize,totalScore, kStStatus.dark];
        _totaljLabel.text = [NSString stringWithFormat:@"%ld",theScore];
        
        [_availableButton setTitle:FormatString(@"可%@%@",kStStatus.pageNum,kStStatus.page) forState:UIControlStateNormal];
        
        // 先设置title，图片的x由title宽度决定
        [_availableButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -_availableButton.imageView.width, 0, _availableButton.imageView.width)];
        [_availableButton setImageEdgeInsets:UIEdgeInsetsMake(0, _availableButton.titleLabel.width+5, 0, -_availableButton.titleLabel.width-5)];
        
    } else if (button.tag == 3) {
        @weakify(self)
        [kUMShareManager Qukan_UMGetShareInfoWithPlatform:UMSocialPlatformType_WechatSession successBlock:^(UMSocialUserInfoResponse * _Nonnull result) {
            @strongify(self)
            [[[kApiManager QukanGcUserbingWithOpenId:result.openid unionId:result.unionId nickName:result.name accessToken:result.accessToken] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
                @strongify(self)
                KHideHUD;
                [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@绑定成功",kStStatus.name]];
                self.wxOrWwButton.tag = 5;
                [self.wxOrWwButton setTitle:kStStatus.pageNum forState:UIControlStateNormal];
            } error:^(NSError * _Nullable error) {
                @strongify(self)
                KHideHUD
                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            }];
        } failBlock:^(NSError * _Nonnull error) {
            @strongify(self);
            KHideHUD
            [self.view showTip:@"登录取消"];
        }];
        
    } else if (button.tag == 4) {
        
        
        @weakify(self)
        KShowHUD
        [[[kApiManager QukanGcUserSelectTpList] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            KHideHUD
            [self aaa:x];
        } error:^(NSError * _Nullable error) {
             kShowTip(error.localizedDescription)
        }];
        
        
        
        
    }else if (button.tag == 5) {
        @weakify(self);
        QukanShowChangeViewController *vc = [[QukanShowChangeViewController alloc] init];
        vc.PopClickBlock = ^(NSInteger code) {
            self.model.changeNum =  [NSString stringWithFormat:@"%ld",self_weak_.model.changeNum.integerValue - code];
            self_weak_.totaljLabel.text = [NSString stringWithFormat:@"%ld",self.model.changeNum.integerValue];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)aaa:(id)x {
    QukanPersonChangeViewController *vc = [[QukanPersonChangeViewController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationCustom;
    
    [self presentViewController:vc animated:NO completion:^{
        vc.datas = [NSArray modelArrayWithClass:[QukanScreenModel class] json:x];
    }];
    
    @weakify(self);
    vc.CodeClickBlock = ^(BOOL code) {
        @strongify(self);
        [self QukanSelectDate];
    };
    vc.RenWuClickBlock = ^(BOOL isLogin) {
        @strongify(self);
        if (isLogin) {
            QukanDailyVC *VC = [QukanDailyVC new];
            [self.navigationController pushViewController:VC animated:YES];
        }
    };
    
}

- (void)targetDealWithButton:(UIButton *)button {
    
}

#pragma mark - 倒计时
-(void)setTime:(UIButton *)btnCode{
    __block NSInteger time = 59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(timer,DISPATCH_TIME_NOW,1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(timer);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮的样式
                [btnCode setTitle:@"重新发送" forState:UIControlStateNormal];
                
                btnCode.userInteractionEnabled = YES;
            });
            
        }else{
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                //设置label读秒效果
                [btnCode setTitle:[NSString stringWithFormat:@"已发送(%.2d)",seconds] forState:UIControlStateNormal];
                // 在这个状态下 用户交互关闭，防止再次点击 button 再次计时
                btnCode.userInteractionEnabled = NO;
                
            });
            
            time--;
        }
    });
    
    dispatch_resume(timer);
}

#pragma mark ===================== Getters =================================

@end
