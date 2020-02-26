//
//  QukanTheRegisterViewController.m
//  Qukan
//
//  Created by Kody on 2019/12/25.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanTheRegisterViewController.h"
#import "QukanAgreementViewController.h"

#import "QukanApiManager+Mine.h"
#import <OpenInstallSDK.h>

@interface QukanTheRegisterViewController ()<UITextFieldDelegate>

@property(nonatomic, strong) UIButton *back_btn;
@property(nonatomic, strong) UIImageView *icon_imgaeView;
@property(nonatomic, strong) UITextField *phone_textField;
@property(nonatomic, strong) UITextField *code_textField;
@property(nonatomic, strong) UITextField *password_textField;
@property(nonatomic, strong) UIImageView *phoneIcon_imageView;
@property(nonatomic, strong) UIImageView *codeIcon_imageView;
@property(nonatomic, strong) UIImageView *passwordIcon_imageView;
@property(nonatomic, strong) UILabel *number_label;
@property(nonatomic, strong) UILabel *phoneLine_label;
@property(nonatomic, strong) UILabel *codeLine_label;
@property(nonatomic, strong) UILabel *passwordLine_label;

@property(nonatomic, strong) UIButton *code_btn;
@property(nonatomic, strong) UIButton *register_btn;
@property(nonatomic, strong) UILabel *agreement_label;
@property(nonatomic, strong) UIButton *agrement_btn;

@property(nonatomic, copy) NSString              *invtiionCode;

@end

@implementation QukanTheRegisterViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self OpeninstallGetInstallParmsCompleted];
}

- (void)initUI {
    self.view.backgroundColor = kCommonWhiteColor;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.view addSubview:self.back_btn];
    [self.back_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(40);
        make.width.height.offset(50);
        make.left.offset(10);
    }];
    
    [self.view addSubview:self.icon_imgaeView];
    [self.icon_imgaeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(100);
        make.top.offset(isIPhoneXSeries() ? kTopBarHeight + 30 : kTopBarHeight + 30);
        make.centerX.mas_equalTo(self.view);
    }];
    
    [self.view addSubview:self.phoneIcon_imageView];
    [self.phoneIcon_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(50);
        make.top.mas_equalTo(self.icon_imgaeView.mas_bottom).offset(40);
        make.height.offset(40);
        make.width.offset(20);
    }];
    
    [self.view addSubview:self.number_label];
    [self.number_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.phoneIcon_imageView.mas_right).offset(0);
        make.width.offset(50);
        make.centerY.height.mas_equalTo(self.phoneIcon_imageView);
    }];
    
    [self.view addSubview:self.phone_textField];
    [self.phone_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.number_label.mas_right).offset(0);
        make.right.offset(-50);
        make.height.mas_equalTo(self.phoneIcon_imageView);
        make.centerY.mas_equalTo(self.number_label);
    }];
    
    [self.view addSubview:self.phoneLine_label];
    [self.phoneLine_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.phoneIcon_imageView);
        make.right.mas_equalTo(self.phone_textField);
        make.top.mas_equalTo(self.phone_textField.mas_bottom).offset(1);
        make.height.offset(0.5);
    }];
    
    [self.view addSubview:self.codeIcon_imageView];
    [self.codeIcon_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.height.mas_equalTo(self.phoneIcon_imageView);
        make.top.mas_equalTo(self.phoneLine_label.mas_bottom).offset(1);
    }];
    
    [self.view addSubview:self.code_textField];
    [self.code_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.codeIcon_imageView.mas_right).offset(10);
        make.right.height.mas_equalTo(self.phone_textField);
        make.centerY.mas_equalTo(self.codeIcon_imageView);
    }];
    
    [self.view addSubview:self.codeLine_label];
    [self.codeLine_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.phoneLine_label);
        make.top.mas_equalTo(self.code_textField.mas_bottom).offset(1);
    }];
    
    [self.view addSubview:self.passwordIcon_imageView];
    [self.passwordIcon_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.height.mas_equalTo(self.phoneIcon_imageView);
        make.top.mas_equalTo(self.codeLine_label.mas_bottom).offset(1);
    }];
    
    [self.view addSubview:self.password_textField];
    [self.password_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.passwordIcon_imageView.mas_right).offset(10);
        make.right.height.mas_equalTo(self.code_textField);
        make.centerY.mas_equalTo(self.passwordIcon_imageView);
    }];
    
    [self.view addSubview:self.passwordLine_label];
    [self.passwordLine_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.password_textField.mas_bottom).offset(1);
        make.right.left.height.mas_equalTo(self.phoneLine_label);
    }];
    
    [self.view addSubview:self.register_btn];
    [self.register_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.password_textField.mas_bottom).offset(30);
        make.left.mas_equalTo(self.passwordIcon_imageView);
        make.right.mas_equalTo(self.password_textField);
        make.height.offset(45);
    }];
    
    [self.view addSubview:self.agreement_label];
    [self.agreement_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_equalTo(self.register_btn);
        make.top.mas_equalTo(self.register_btn.mas_bottom).offset(10);
        make.height.offset(20);
    }];
    
    [self.view addSubview:self.agrement_btn];
    [self.agrement_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.agreement_label.mas_bottom).offset(0);
        make.height.offset(30);
        make.right.left.mas_equalTo(self.agreement_label);
    }];
    
    [self.view addSubview:self.code_btn];
    [self.code_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(80);
        make.height.offset(25);
        make.right.mas_equalTo(self.register_btn.mas_right).offset(-10);
        make.centerY. mas_equalTo(self.codeIcon_imageView);
    }];
}

#pragma mark ===================== Public Methods =======================

- (void)OpeninstallGetInstallParmsCompleted {
    [[OpenInstallSDK defaultManager] getInstallParmsCompleted:^(OpeninstallData*_Nullable appData) {
        //在主线程中回调
        if (appData.data) {//(动态唤醒参数)
            //e.g.如免填码建立关系、自动加好友、自动进入某个群组或房间等
            NSDictionary *dict = (NSDictionary *)appData.data;
            if ([dict objectForKey:@"YQMA"]) {
                self.invtiionCode = appData.data[@"YQMA"];
            }
        }
        
        if (appData.channelCode) {//(通过渠道链接或二维码安装会返回渠道编号)
            //e.g.可自己统计渠道相关数据等
        }
    }];
}

- (void)Qukan_countdown {
    self.code_btn.userInteractionEnabled = NO;
    __block int timeout = 59;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.code_btn.userInteractionEnabled = YES;
                [self.code_btn setTitle:@"获取验证码" forState:UIControlStateNormal];
            });
        }else{
            int seconds = timeout%60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d秒", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.code_btn setTitle:strTime forState:UIControlStateNormal];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

#pragma mark ===================== Actions ============================

- (void)backBtnCilck {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)codeBtnCilck {
    [self.phone_textField endEditing:YES];
   if (self.phone_textField.text.length==0) {
       [SVProgressHUD showErrorWithStatus:@"手机号码不能为空"];
   }
   else {
       [MBProgressHUD showHUDAddedTo:self.view animated:NO];
       NSString *countryCallingCode = [self.number_label.text stringByReplacingOccurrencesOfString:@"+" withString:@""];
       NSDictionary *parameters = @{@"countryCallingCode":countryCallingCode,
                                    @"mobile":self.phone_textField.text,};
       [QukanNetworkTool Qukan_POST:@"sms/sendCode" parameters:parameters success:^(NSDictionary *response) {
           [MBProgressHUD hideHUDForView:self.view animated:YES];
           if ([response[@"status"] integerValue] == 200) {
               [self Qukan_countdown];
           }else if ([response[@"status"] integerValue] == 20013){
               
               [SVProgressHUD showSuccessWithStatus:response[@"msg"]];
           }else {
               [SVProgressHUD showSuccessWithStatus:@"验证码获取失败"];
           }
       } failure:^(NSError *error) {
           [MBProgressHUD hideHUDForView:self.view animated:NO];
           //            [SVProgressHUD showErrorWithStatus:@"验证码获取失败"];
           [SVProgressHUD showErrorWithStatus:error.localizedDescription];
       }];
   }
}

- (void)registerBtnCilck {
    if (self.phone_textField.text.length == 0) {
           [SVProgressHUD showErrorWithStatus:@"手机号码不能为空"];
       }
       else if (self.code_textField.text.length == 0) {
           [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
       }
       else if (self.password_textField.text.length == 0) {
           [SVProgressHUD showErrorWithStatus:@"请输入密码"];
       }
       else {
           
           if (self.password_textField.text.length < 6) {
               
               [SVProgressHUD showErrorWithStatus:@"密码最低长度为6位"];
           }else{
               
               [MBProgressHUD showHUDAddedTo:self.view animated:NO];
               NSString *tel = [NSString stringWithFormat:@"%@%@", [self.number_label.text stringByReplacingOccurrencesOfString:@"+" withString:@""], self.phone_textField.text];
               NSString *invitationCode = [kUserDefaults objectForKey:Qukan_openinstallIntCode];
               if (self.invtiionCode.length == 0 || self.invtiionCode == nil) {
                   self.invtiionCode = invitationCode;
               }
               @weakify(self)
               [[[kApiManager QukangcuserRegisterWithTel:tel addCode:self.code_textField.text addPassword:self.password_textField.text addInvitationCode:self.invtiionCode] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
                   @strongify(self)
                   [SVProgressHUD showSuccessWithStatus:@"注册成功"];
                   [self.navigationController popViewControllerAnimated:YES];
                   [OpenInstallSDK reportRegister];
               } error:^(NSError * _Nullable error) {
                   @strongify(self)
                   [MBProgressHUD hideHUDForView:self.view animated:NO];
                   [SVProgressHUD showErrorWithStatus:error.localizedDescription];
               }];
           }
       }
}

- (void)agreementBtnCilck {
    QukanAgreementViewController *vc = [[QukanAgreementViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ===================== UITextFieldDelegate ==================================

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == self.password_textField) {
        
        if (textField.text.length == 16) {
            //            [SVProgressHUD showErrorWithStatus:@"输入超限"];
        }
        
        if (range.location == 15 && [string isEqualToString:@""]) {
            return YES;
        }
        
        return textField.text.length <=  15 ? YES : NO;
    }else if (textField == self.phone_textField){
        
        if (textField.text.length == 11) {
            //            [SVProgressHUD showErrorWithStatus:@"输入超限"];
        }
        
        if (range.location == 10 && [string isEqualToString:@""]) {
            return YES;
        }
        
        return textField.text.length <=  10 ? YES : NO;
        
    }else if (textField == self.code_textField){
        if (textField.text.length == 6) {
        }
        if (range.location == 5 && [string isEqualToString:@""]) {
            return YES;
        }
        return textField.text.length <=  5 ? YES : NO;
    }
    
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField == self.password_textField) {
        
        if (textField.text.length < 6) {
            //            [SVProgressHUD showErrorWithStatus:@"密码最低长度为6位"];
        }
    }
}

#pragma mark ===================== Getters =================================

- (UIButton *)back_btn {
    if (!_back_btn) {
        _back_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_back_btn setImage:kImageNamed(@"Qukan_dismiss_icon") forState:UIControlStateNormal];
        @weakify(self)
        [[_back_btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [self backBtnCilck];
        }];
    }
    return _back_btn;
}

- (UIImageView *)icon_imgaeView {
    if (!_icon_imgaeView) {
        _icon_imgaeView = UIImageView.new;
        _icon_imgaeView.image = kImageNamed(@"Qukan_login");
    }
    return _icon_imgaeView;
}

- (UIImageView *)phoneIcon_imageView {
    if (!_phoneIcon_imageView) {
        _phoneIcon_imageView = UIImageView.new;
        _phoneIcon_imageView.image = kImageNamed(@"Qukan_phoneIcon");
        _phoneIcon_imageView.contentMode = UIViewContentModeCenter;
    }
    return _phoneIcon_imageView;
}

- (UIImageView *)codeIcon_imageView {
    if (!_codeIcon_imageView) {
        _codeIcon_imageView = UIImageView.new;
        _codeIcon_imageView.image = kImageNamed(@"Qukan_code");
        _codeIcon_imageView.contentMode = UIViewContentModeCenter;
    }
    return _codeIcon_imageView;
}

- (UIImageView *)passwordIcon_imageView {
    if (!_passwordIcon_imageView) {
        _passwordIcon_imageView = UIImageView.new;
        _passwordIcon_imageView.image = kImageNamed(@"Qukan_pwdIcon");
        _passwordIcon_imageView.contentMode = UIViewContentModeCenter;
    }
    return _passwordIcon_imageView;
}

- (UITextField *)phone_textField {
    if (!_phone_textField) {
        _phone_textField = UITextField.new;
        _phone_textField.font = kFont14;
        _phone_textField.delegate = self;
        _phone_textField.keyboardType = UIKeyboardTypeNumberPad;
        
        NSString *placeholderStr = @"请输入手机号";
        NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:placeholderStr attributes:@{NSForegroundColorAttributeName :kTextGrayColor , NSFontAttributeName : [UIFont systemFontOfSize:14]}];
        _phone_textField.attributedPlaceholder = placeholderString;
    }
    return _phone_textField;
}

- (UITextField *)code_textField {
    if (!_code_textField) {
        _code_textField = UITextField.new;
        _code_textField.font = kFont14;
        _code_textField.delegate = self;
        _code_textField.keyboardType = UIKeyboardTypeNumberPad;
        
        NSString *placeholderStr = @"请输入验证码";
        NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:placeholderStr attributes:@{NSForegroundColorAttributeName :kTextGrayColor , NSFontAttributeName : [UIFont systemFontOfSize:14]}];
        _code_textField.attributedPlaceholder = placeholderString;
    }
    return _code_textField;
}

- (UITextField *)password_textField {
    if (!_password_textField) {
        _password_textField = UITextField.new;
        _password_textField.font = kFont14;
        _password_textField.delegate = self;
        _password_textField.secureTextEntry = YES;
        NSString *placeholderStr = @"请输入密码";
       NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:placeholderStr attributes:@{NSForegroundColorAttributeName :kTextGrayColor , NSFontAttributeName : [UIFont systemFontOfSize:14]}];
       _password_textField.attributedPlaceholder = placeholderString;
    }
    return _password_textField;
}

- (UILabel *)number_label {
    if (!_number_label) {
        _number_label = UILabel.new;
        _number_label.text = @"+86";
        _number_label.textColor = kCommonDarkGrayColor;
        _number_label.textAlignment = NSTextAlignmentCenter;
        _number_label.font = kFont14;
    }
    return _number_label;
}

- (UILabel *)phoneLine_label {
    if (!_phoneLine_label) {
        _phoneLine_label = UILabel.new;
        _phoneLine_label.backgroundColor = kThemeColor;
    }
    return _phoneLine_label;
}

- (UILabel *)codeLine_label {
    if (!_codeLine_label) {
        _codeLine_label = UILabel.new;
        _codeLine_label.backgroundColor = kThemeColor;
    }
    return _codeLine_label;
}

- (UILabel *)passwordLine_label {
    if (!_passwordLine_label) {
        _passwordLine_label = UILabel.new;
        _passwordLine_label.backgroundColor = kThemeColor;
    }
    return _passwordLine_label;
}

- (UIButton *)code_btn {
    if (!_code_btn) {
        _code_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_code_btn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_code_btn setTitleColor:kThemeColor forState:UIControlStateNormal];
        _code_btn.backgroundColor = kCommonWhiteColor;
        _code_btn.layer.cornerRadius = 2;
        _code_btn.layer.masksToBounds = YES;
        _code_btn.layer.borderColor = kThemeColor.CGColor;
        _code_btn.layer.borderWidth = 1.0f;
        _code_btn.titleLabel.font = kFont11;
        @weakify(self)
        [[_code_btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [self codeBtnCilck];
        }];
    }
    return _code_btn;
}

- (UIButton *)register_btn {
    if (!_register_btn) {
        _register_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_register_btn setTitle:@"注册" forState:UIControlStateNormal];
        [_register_btn setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
        _register_btn.backgroundColor = kThemeColor;
        _register_btn.layer.cornerRadius = 5;
        _register_btn.layer.masksToBounds = YES;
        @weakify(self)
        [[_register_btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [self registerBtnCilck];
        }];
    }
    return _register_btn;
}

- (UILabel *)agreement_label {
    if (!_agreement_label) {
        _agreement_label = UILabel.new;
        _agreement_label.text = @"点击上面的“注册”按钮，即表示您同意";
        _agreement_label.font = kFont12;
        _agreement_label.textColor = HEXColor(0x666666);
        _agreement_label.textAlignment = NSTextAlignmentCenter;
    }
    return _agreement_label;
}

- (UIButton *)agrement_btn {
    if (!_agrement_btn) {
        _agrement_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_agrement_btn setTitle:@"《用户服务协议》" forState:UIControlStateNormal];
        [_agrement_btn setTitleColor:kCommonDarkGrayColor forState:UIControlStateNormal];
        _agrement_btn.titleLabel.font = kFont13;
        @weakify(self)
        [[_agrement_btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [self agreementBtnCilck];
        }];
    }
    return _agrement_btn;
}

@end
