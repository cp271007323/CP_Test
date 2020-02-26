//
//  QukanTheLoginViewController.m
//  Qukan
//
//  Created by Kody on 2019/12/25.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanForgetPasswordViewController.h"
#import "QukanPrivacyAgreementViewController.h"
#import "QukanApiManager+Mine.h"

#import "QukanTheRegisterViewController.h"

@interface QukanLoginViewController ()<UITextFieldDelegate>

@property(nonatomic, strong) UIImageView *icon_imgaeView;
@property(nonatomic, strong) UITextField *name_textField;
@property(nonatomic, strong) UITextField *password_textField;
@property(nonatomic, strong) UILabel *number_label;
@property(nonatomic, strong) UILabel *password_label;
@property(nonatomic, strong) UILabel *nameLine_label;
@property(nonatomic, strong) UILabel *passwordLine_label;

@property(nonatomic, strong) UIButton *back_btn;
@property(nonatomic, strong) UIButton *login_btn;
@property(nonatomic, strong) UIButton *register_btn;
@property(nonatomic, strong) UIButton *forget_btn;
@property(nonatomic, strong) UILabel *agreement_label;

@end

@implementation QukanLoginViewController

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
    
    [self.view addSubview:self.number_label];
    [self.number_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.icon_imgaeView.mas_bottom).offset(30);
        make.height.offset(40);
        make.left.offset(50);
        make.width.offset(60);
    }];
    
    [self.view addSubview:self.password_label];
    [self.password_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.number_label.mas_bottom).offset(10);
        make.left.height.width.mas_equalTo(self.number_label);
    }];
    
    [self.view addSubview:self.name_textField];
    [self.name_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.number_label.mas_right).offset(0);
        make.right.offset(-50);
        make.height.offset(40);
        make.top.mas_equalTo(self.number_label);
    }];
    
    [self.view addSubview:self.nameLine_label];
    [self.nameLine_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.number_label);
        make.right.mas_equalTo(self.name_textField);
        make.height.offset(0.3);
        make.top.mas_equalTo(self.name_textField.mas_bottom).offset(1);
    }];

    [self.view addSubview:self.password_textField];
    [self.password_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.name_textField.mas_bottom).offset(10);
        make.height.left.right.mas_equalTo(self.name_textField);
    }];
    
    [self.view addSubview:self.passwordLine_label];
    [self.passwordLine_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.nameLine_label);
        make.top.mas_equalTo(self.password_textField.mas_bottom).offset(1);
    }];

    [self.view addSubview:self.login_btn];
    [self.login_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.number_label);
        make.right.mas_equalTo(self.password_textField);
        make.top.mas_equalTo(self.password_textField.mas_bottom).offset(40);
        make.height.offset(45);
    }];

    [self.view addSubview:self.register_btn];
    [self.register_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.login_btn.mas_bottom).offset(10);
        make.height.left.right.mas_equalTo(self.login_btn);
    }];

    [self.view addSubview:self.forget_btn];
    [self.forget_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.register_btn.mas_bottom).offset(5);
        make.height.right.mas_equalTo(self.register_btn);
    }];

    [self.view addSubview:self.agreement_label];
    [self.agreement_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.login_btn);
        make.centerX.mas_equalTo(self.view);
        make.bottom.offset(isIPhoneXSeries() ? -50 : -30);
    }];
}

#pragma mark ===================== NetWork ==================================

- (void)loginBtnCilck {
     if (![self guardInputCorrect]) {
        return;
    }
    
    [self.view endEditing:YES];
    NSString *tel = [NSString stringWithFormat:@"%@%@", [self.number_label.text stringByReplacingOccurrencesOfString:@"+" withString:@""], self.name_textField.text];
    @weakify(self)
    KShowHUD
    [[[kApiManager QukanloginWithAccount:tel andPassword:self.password_textField.text] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        KHideHUD
        [self Qukan_loginSuccessSaveWithData:x];
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        KHideHUD
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}


#pragma mark ===================== UITextFieldDelegate ==================================

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
 
    NSLog(@"kkk = %@",textField.text);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.name_textField) {
        if (textField.text.length == 11 && (range.location != 10 && ![string isEqualToString:@""])) {
//            [SVProgressHUD showErrorWithStatus:@"输入超限"];
        }
        if (range.location == 10 && [string isEqualToString:@""]) {
            return YES;
        }
        return textField.text.length <=  10 ? YES : NO;
    }else if (textField == self.password_textField){
        return YES;
    }
    return NO;
}


#pragma mark ===================== Actions ============================

- (void)backBtnCilck {
    if (self.isFromRegister) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)labelCilck {
    QukanPrivacyAgreementViewController *vc = [[QukanPrivacyAgreementViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)Qukan_loginSuccessSaveWithData:(NSDictionary *)dict {
    QukanUserModel *model = [QukanUserModel modelWithJSON:dict];
    [kUserManager setUserData:model];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:Qukan_Recommend_Follow_NotificationName object:nil];
    [kNotificationCenter postNotificationName:kUserDidLoginNotification object:nil];
}

- (BOOL)guardInputCorrect {
    BOOL inputRight = YES;
    if (!self.name_textField.text.length || !self.password_textField.text.length) {
        inputRight = NO;
        [SVProgressHUD showErrorWithStatus:@"请输入账号密码"];
    }else if (!(self.password_textField.text.length >= 6 && self.password_textField.text.length <= 16)) {
        inputRight = NO;
        [SVProgressHUD showErrorWithStatus:@"密码长度需在6到16位之间"];
    }
    
    return inputRight;
}

#pragma mark ===================== Getters =================================

- (UIImageView *)icon_imgaeView {
    if (!_icon_imgaeView) {
        _icon_imgaeView = UIImageView.new;
        _icon_imgaeView.image = kImageNamed(@"Qukan_login");
    }
    return _icon_imgaeView;
}

- (UITextField *)name_textField {
    if (!_name_textField) {
        _name_textField = UITextField.new;
        _name_textField.font = kFont14;
        _name_textField.delegate = self;
        _name_textField.keyboardType = UIKeyboardTypeNumberPad;
        
        NSString *placeholderStr = @"请输入手机号";
        NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:placeholderStr attributes:@{NSForegroundColorAttributeName :kTextGrayColor , NSFontAttributeName : [UIFont systemFontOfSize:14]}];
        _name_textField.attributedPlaceholder = placeholderString;
    }
    return _name_textField;
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


- (UILabel *)password_label {
    if (!_password_label) {
        _password_label = UILabel.new;
        _password_label.text = @"密码";
        _password_label.font = kFont14;
        _password_label.textAlignment = NSTextAlignmentCenter;
        _password_label.textColor = kCommonDarkGrayColor;
    }
    return _password_label;
}

- (UILabel *)nameLine_label {
    if (!_nameLine_label) {
        _nameLine_label = UILabel.new;
        _nameLine_label.backgroundColor = kThemeColor;
    }
    return _nameLine_label;
}

- (UILabel *)passwordLine_label {
    if (!_passwordLine_label) {
        _passwordLine_label = UILabel.new;
        _passwordLine_label.backgroundColor = kThemeColor;
    }
    return _passwordLine_label;
}

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

- (UIButton *)login_btn {
    if (!_login_btn) {
        _login_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_login_btn setTitle:@"登录" forState:UIControlStateNormal];
        [_login_btn setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
        _login_btn.backgroundColor = kThemeColor;
        _login_btn.layer.cornerRadius = 5;
        _login_btn.layer.masksToBounds = YES;
        @weakify(self)
        [[_login_btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [self loginBtnCilck];
        }];
    }
    return _login_btn;
}

- (UIButton *)register_btn {
    if (!_register_btn) {
        _register_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_register_btn setTitle:@"注册" forState:UIControlStateNormal];
        [_register_btn setTitleColor:kThemeColor forState:UIControlStateNormal];
        _register_btn.backgroundColor = kCommonWhiteColor;
        _register_btn.layer.cornerRadius = 5;
        _register_btn.layer.masksToBounds = YES;
        _register_btn.layer.borderColor = kThemeColor.CGColor;
        _register_btn.layer.borderWidth = 1;
        @weakify(self)
        [[_register_btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            QukanTheRegisterViewController *vc = [[QukanTheRegisterViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _register_btn;
}

- (UIButton *)forget_btn {
    if (!_forget_btn) {
        _forget_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_forget_btn setTitle:@"忘记密码" forState:UIControlStateNormal];
        _forget_btn.titleLabel.font = kFont14;
        [_forget_btn setTitleColor:kTextGrayColor forState:UIControlStateNormal];
        @weakify(self)
        [[_forget_btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            QukanForgetPasswordViewController *vc = [[QukanForgetPasswordViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _forget_btn;
}

- (UILabel *)agreement_label {
    if (!_agreement_label) {
        _agreement_label = UILabel.new;
        _agreement_label.textAlignment = NSTextAlignmentCenter;
        _agreement_label.font = kFont13;
        _agreement_label.userInteractionEnabled = YES;
        NSString *str = @"登录即代表同意《用户协议》";
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:str];
        [attrStr addAttribute:NSForegroundColorAttributeName value:kThemeColor range:NSMakeRange(7, 6)];
        _agreement_label.attributedText = attrStr;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelCilck)];
        [_agreement_label addGestureRecognizer:tap];
    }
    return _agreement_label;
}

@end
