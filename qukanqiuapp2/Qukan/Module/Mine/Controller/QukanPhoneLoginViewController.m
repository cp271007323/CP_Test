//
//  QukanPhoneLoginViewController.m
//  Qukan
//
//  Created by tl on 2019/7/18.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanApiManager+Mine.h"
#import "QukanPrivacyAgreementViewController.h"
//#import <WXApi.h>

#import <UMSocialWechatHandler.h>
#define backColor RGBA(236, 239, 243, 1)

@interface QukanPhoneLoginViewController ()<UITextFieldDelegate>

@property(nonatomic, strong) UIView            *headerView;
@property(nonatomic, strong) UIButton          *backButton;
@property(nonatomic, strong) UIImageView       *logoImageView;
@property(nonatomic, strong) UILabel           *nameLabel;
@property(nonatomic, strong) UIButton          *loginButton;
@property(nonatomic, strong) UIButton          *agreementButton;
@property(nonatomic, strong) UILabel           *line;
@property(nonatomic, strong) UILabel           *otherTitleLabel;
@property(nonatomic, strong) UIButton          *messageButton;
@property(nonatomic, strong) UIImageView       *logoImageBG;

@property(nonatomic, strong) UITextField *phoneTextfield;
@property(nonatomic, strong) UITextField *passTextfield;


/**微信第三方*/
@property (copy, nonatomic)  NSString *name;
@property (copy, nonatomic)  NSString *openid;
@property (copy, nonatomic)  NSString *unionid;
@property (copy, nonatomic)  NSString *iconurl;
@property (copy, nonatomic)  NSString *accessToken;

@end

@implementation QukanPhoneLoginViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    kGuardLogin
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
        self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self interFace];
    //    [self isFristvVisit];
    _phoneTextfield = [UITextField new];
    _passTextfield = [UITextField new];
    [self addSubviews];
}

- (void)interFace {
    self.view.backgroundColor = kCommonWhiteColor;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
}

- (void)isFristvVisit {
    NSString *QukanForTheFirstTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"QukanForTheFirstTime"];
    if (QukanForTheFirstTime==nil || QukanForTheFirstTime.length==0) {
        QukanPrivacyAgreementViewController *vc = [[QukanPrivacyAgreementViewController alloc] init];
        [self addChildViewController:vc];
        [self.view addSubview:vc.view];
    } else {
        [self addSubviews];
    }
}

- (void)addSubviews {
    
    [self.view addSubview:self.logoImageBG];
    //    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.agreementButton];
    //    [self.view addSubview:self.line];
    //    [self.view addSubview:self.otherTitleLabel];
    //    [self.view addSubview:self.btnSinaLogin];
    //    [self.view addSubview:self.messageButton];
    //    [self.view addSubview:self.btnQQLogin];
    
}


#pragma mark ===================== Actions ============================
- (void)ButtonCilck:(UIButton *)button {
    DEBUGLog(@"%ld",button.tag);
    switch (button.tag) {
        case 0:
            [self backButtonCilck];
            break;
        case 1:
            [self autoLogin];
            break;
        case 2:
            [self UserProtocol];
            break;
        case 3:
            [self LoginPhone];
            break;
        case 4:
            [self LoginPhone];
            break;
        case 5:
            [self LoginPhone];
            break;
        default:
            break;
    }
}

- (void)backButtonCilck {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)autoLogin {
   
    if ([[UMSocialWechatHandler defaultManager] umSocial_isInstall]) {
        [self getUserInfoInformation];
    } else {
        [SVProgressHUD showErrorWithStatus:@"未安装微信"];
    }
    
//    if ([WXApi isWXAppInstalled]) {
//           [self getUserInfoInformation];
//       } else {
//           [SVProgressHUD showErrorWithStatus:@"未安装微信"];
//       }
}
- (void)LoginPhone {
    QukanLoginViewController *vc = [[QukanLoginViewController alloc] init];
    vc.isFromRegister = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)UserProtocol {
    QukanPrivacyAgreementViewController *vc = [[QukanPrivacyAgreementViewController alloc] init];
    vc.title = @"用户协议";
//    vc.isPresent = YES;
        [self.navigationController pushViewController:vc animated:YES];
//    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark ===================== NetWork ==================================
- (void)getUserInfoInformation {
    //    KShowHUD
    @weakify(self);
    [self.view showTip:@"正在获取微信授权..."];
    
    [kUMShareManager Qukan_UMGetShareInfoWithPlatform:UMSocialPlatformType_WechatSession successBlock:^(UMSocialUserInfoResponse * _Nonnull result) {
        self.name = result.name;
        self.openid = result.openid;
        self.unionid =result.unionId;
        self.iconurl = result.iconurl;
        self.accessToken =result.accessToken;
        @strongify(self);
        [[[kApiManager QukanUserWithId:@"01" addOpenId:result.openid addUnionid:result.unionId  addNickname:result.name addHeadimgUrl:result.iconurl addAccessToken:result.accessToken umengToken:Qukan_UMAppKey invitationCode:@"" type:@"1" tel:@"" code:@"" pass:@""] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            KHideHUD

            [self dataSourceDealLoginWith:x];
        } error:^(NSError * _Nullable error) {
            @strongify(self);
            KHideHUD
            [self.view showTip:error.localizedDescription];
        }];
    } failBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        KHideHUD
        [self.view showTip:@"登录取消"];
    }];
}


- (void)dataSourceDealLoginWith:(id)response {
    NSDictionary *dict = (NSDictionary *)response;
    QukanUserModel *model = [QukanUserModel modelWithJSON:dict];
    if (model.tel.length > 0) {
        [kUserManager setUserData:model];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:Qukan_Recommend_Follow_NotificationName object:nil];
        [kNotificationCenter postNotificationName:kUserDidLoginNotification object:nil];
    }else{
        QukanBindingPhoneViewController *VC = [QukanBindingPhoneViewController new];
        VC.name = self.name;
        VC.openid = self.openid;
        VC.unionid = self.unionid;
        VC.iconurl  = self.iconurl;
        VC.accessToken = self.accessToken;
        [self.navigationController pushViewController:VC animated:YES];
    }
    
}


#pragma mark ===================== Getters =================================

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 44)];
        if (isIPhoneXSeries()) {
            _headerView.frame = CGRectMake(0, 40, kScreenWidth, 44);
        }
        //        _headerView.backgroundColor = backColor;
    }
    return _headerView;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(25, 0, 44, 44)];
        [_backButton setImage:kImageNamed(@"Qukan_dismiss_icon") forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(ButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        _backButton.backgroundColor = RGBA(255, 255, 255, 0.5);
        _backButton.layer.masksToBounds = YES;
        _backButton.layer.cornerRadius = 22;
        
        _backButton.tag = 0;
    }
    return _backButton;
}

- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 45, self.logoImageBG.bottom - 180, 90, 90)];
        _logoImageView.image = kImageNamed(@"Qukan_login");
    }
    return _logoImageView;
}

- (UIImageView *)logoImageBG {
    if (!_logoImageBG) {
        UIImage* img = kImageNamed(@"Qukan_LoginB");
        _logoImageBG = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,kScreenHeight/2)];
        _logoImageBG.image = img;
        _logoImageBG.userInteractionEnabled = YES;
        [_logoImageBG addSubview:self.headerView];
        [_headerView addSubview:self.backButton];
        [_logoImageBG addSubview:self.logoImageView];
        [_logoImageBG addSubview:self.nameLabel];
    }
    return _logoImageBG;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 100, CGRectGetMaxY(self.logoImageView.frame) + 20, 200, 20)];
        //        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        //        NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
        _nameLabel.text = AppName;
        _nameLabel.font = [UIFont boldSystemFontOfSize:16];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return _nameLabel;
}

-(UIButton *)loginButton {
    if (!_loginButton) {
//        _loginButton = [[UIButton alloc] initWithFrame:CGRectMake(30, kScreenHeight/2 + 40, kScreenWidth - 60, 55)];
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginButton.frame = CGRectMake(30, kScreenHeight/2 + 40, kScreenWidth - 60, 55);
        _loginButton.titleLabel.font = kFont15;
        _loginButton.layer.cornerRadius = 5;
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginButton setImage:kImageNamed(@"Qukan_wxIcon") forState:UIControlStateNormal];
        [_loginButton setImage:kImageNamed(@"Qukan_wxIcon") forState:UIControlStateHighlighted];
        [_loginButton setTitle:@"  一键登录" forState:UIControlStateNormal];
        [_loginButton setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
        _loginButton.backgroundColor = HEXColor(0x53B435);
        [_loginButton addTarget:self action:@selector(ButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        _loginButton.tag = 1;
    }
    return _loginButton;
}

- (UIButton *)agreementButton {
    if (!_agreementButton) {
        _agreementButton = [[UIButton alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(self.loginButton.frame) + 20, kScreenWidth - 60, 20)];
        _agreementButton.backgroundColor = [UIColor whiteColor];
        _agreementButton.titleLabel.font = kSystemFont(11);
        //        _agreementButton.backgroundColor = backColor;
        
        NSString * allStr = @"登录即代表同意《用户协议》";
        NSMutableAttributedString *AttriStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",allStr]];
        //        [AttriStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldItalicMT" size:16.0] range:NSMakeRange(7,6)];
        [AttriStr addAttribute:NSForegroundColorAttributeName value:kThemeColor range:NSMakeRange(7,6)];
        [_agreementButton setAttributedTitle:AttriStr forState:UIControlStateNormal];
        [_agreementButton addTarget:self action:@selector(ButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        _agreementButton.tag = 2;
    }
    return _agreementButton;
}

- (UILabel *)line {
    if (!_line) {
        _line = [[UILabel alloc] initWithFrame:CGRectMake(10, kScreenHeight - 170, kScreenWidth - 20, 0.5)];
        _line.backgroundColor = [UIColor lightGrayColor];
    }
    return _line;
}

//- (UILabel *)otherTitleLabel {
//    if (!_otherTitleLabel) {
//        _otherTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 60, kScreenHeight - 180, 120, 20)];//CGRectGetMaxY(self.agreementButton.frame) + 100
//        _otherTitleLabel.text = @"其他登录方式";
//        _otherTitleLabel.font = [UIFont boldSystemFontOfSize:13];
//        _otherTitleLabel.textAlignment = NSTextAlignmentCenter;
//        _otherTitleLabel.textColor = kCommonDarkGrayColor;
//        _otherTitleLabel.backgroundColor = kCommonWhiteColor;
//    }
//    return _otherTitleLabel;
//}

//- (UIButton *)messageButton {
//    if (!_messageButton) {
//        _messageButton = [[UIButton alloc] initWithFrame:CGRectMake(self.btnSinaLogin.right + 25, self.btnSinaLogin.mj_y, 40, 40)];
//        [_messageButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
//        [_messageButton setBackgroundImage:kImageNamed(@"Qukan_Phone") forState:UIControlStateNormal];
//        [_messageButton addTarget:self action:@selector(ButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
//        _messageButton.tag = 3;
//    }
//    return _messageButton;
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}

@end
