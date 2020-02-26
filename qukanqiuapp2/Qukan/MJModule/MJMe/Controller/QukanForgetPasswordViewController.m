#import "QukanForgetPasswordViewController.h"

#import "QukanApiManager+Mine.h"
@interface QukanForgetPasswordViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *countryCodeLabel;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;
@property (weak, nonatomic) IBOutlet UITextField *iphoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *passTextField;
@property (weak, nonatomic) IBOutlet UITextField *passTextField2;
@end
@implementation QukanForgetPasswordViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"忘记密码";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *forgetPasswordBtn = [self.view viewWithTag:300];
    forgetPasswordBtn.layer.masksToBounds = YES;
    forgetPasswordBtn.layer.cornerRadius = 4.0;
    forgetPasswordBtn.backgroundColor = kThemeColor;
    UIButton *codeBtn = [self.view viewWithTag:400];
    codeBtn.layer.masksToBounds = YES;
    codeBtn.layer.cornerRadius = 2.5;
    codeBtn.layer.borderColor = kThemeColor.CGColor;
    codeBtn.layer.borderWidth = 0.5;
    [codeBtn setTitleColor:kThemeColor forState:UIControlStateNormal];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.iphoneTextField.delegate = self;
    self.codeTextField.delegate = self;
    self.passTextField.delegate = self;
    self.passTextField2.delegate = self;
}

- (void)didReceiveMemoryWarning {[super didReceiveMemoryWarning];}

- (void)Qukan_countdown {
    self.codeButton.userInteractionEnabled = NO;
    __block int timeout = 59;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.codeButton.userInteractionEnabled = YES;
                [self.codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
            });
        }else{
            int seconds = timeout%60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d秒", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.codeButton setTitle:strTime forState:UIControlStateNormal];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

- (IBAction)getCode:(id)sender {
    [self.iphoneTextField endEditing:YES];
    if (self.iphoneTextField.text.length==0) {
        [SVProgressHUD showErrorWithStatus:@"手机号码不能为空"];
    }
    else {
        [MBProgressHUD showHUDAddedTo:self.view animated:NO];
        NSString *countryCallingCode = [self.countryCodeLabel.text stringByReplacingOccurrencesOfString:@"+" withString:@""];
//        NSDictionary *parameters = @{@"countryCallingCode":countryCallingCode,
//                                     @"mobile":self.iphoneTextField.text,};
//        [QukanNetworkTool Qukan_POST:@"sms/sendCode" parameters:parameters success:^(NSDictionary *response) {
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            if ([response[@"status"] integerValue]==200) {
//                [self Qukan_countdown];
//            } else {
//                [SVProgressHUD showErrorWithStatus:@"验证码获取失败"];
//            }
//        } failure:^(NSError *error) {
//            [MBProgressHUD hideHUDForView:self.view animated:NO];
//            [SVProgressHUD showErrorWithStatus:@"验证码获取失败"];
//        }];
        
        @weakify(self)
        [[[kApiManager QukansmsSendCodeWithMobile:self.iphoneTextField.text addCode:countryCallingCode] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            [self Qukan_countdown];
            [MBProgressHUD hideHUDForView:self.view animated:NO];
        } error:^(NSError * _Nullable error) {
            @strongify(self)
//            if (error.code == 20013) {
//                [SVProgressHUD showErrorWithStatus:error.userInfo[@"NSLocalizedDescription"]];
//            }
            [MBProgressHUD hideHUDForView:self.view animated:NO];
//            [SVProgressHUD showErrorWithStatus:@"验证码获取失败"];
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }];
    }
}

- (IBAction)sure:(id)sender {
    
    if (self.iphoneTextField.text.length==0) {
        [SVProgressHUD showErrorWithStatus:@"手机号码不能为空"];
    }
    else if (self.codeTextField.text.length==0) {
        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
    } else if (![self.passTextField.text isEqualToString:self.passTextField2.text]) {
        [SVProgressHUD showErrorWithStatus:@"两次密码输入不相等"];
    }
    else {
        if (self.passTextField.text.length < 6 || self.passTextField2.text.length < 6) {
            [SVProgressHUD showErrorWithStatus:@"密码最低长度为6位"];
        }else{
            
            [MBProgressHUD showHUDAddedTo:self.view animated:NO];
            NSString *tel = [NSString stringWithFormat:@"%@%@", [self.countryCodeLabel.text stringByReplacingOccurrencesOfString:@"+" withString:@""], self.iphoneTextField.text];
            //        NSDictionary *parameters = @{@"tel":tel,
            //                                     @"code":self.codeTextField.text,
            //                                     @"password":self.passTextField2.text,};
            //        [QukanNetworkTool Qukan_POST:@"gcuser/forgetPass" parameters:parameters success:^(NSDictionary *response) {
            //            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //            if ([response[@"status"] integerValue]==200) {
            //                [SVProgressHUD showSuccessWithStatus:@"密码修改成功"];
            //                [self.navigationController popViewControllerAnimated:YES];
            //            } else {
            //                [SVProgressHUD showErrorWithStatus:response[@"msg"]];
            //            }
            //        } failure:^(NSError *error) {
            //            [MBProgressHUD hideHUDForView:self.view animated:NO];
            //            [SVProgressHUD showErrorWithStatus:@"修改失败"];
            //        }];
            
            
            @weakify(self)
            [[[kApiManager QukangcuserForgetPassWithTel:tel addCode:self.codeTextField.text addPassword:self.passTextField.text] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
                @strongify(self)
                [SVProgressHUD showSuccessWithStatus:@"密码修改成功"];
                [self.navigationController popViewControllerAnimated:YES];
            } error:^(NSError * _Nullable error) {
                @strongify(self)
                [MBProgressHUD hideHUDForView:self.view animated:NO];
                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                //            if (error.code == 1001) {
                //                [SVProgressHUD showErrorWithStatus:(NSString *)error.userInfo[@"NSLocalizedDescription"]];
                //            }else{
                //                [SVProgressHUD showErrorWithStatus:@"修改失败"];
                //            }
            }];
        }
    }
}

- (IBAction)countryCodeButtonClicked:(id)sender {
//    QukanCountryCodeViewController *vc = [[QukanCountryCodeViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
//    Qukan_WeakSelf;
//    vc.Qukan_didBlock = ^(NSString *code) {
//        weakSelf.countryCodeLabel.text = code;
//    };
}

#pragma mark UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == self.passTextField || textField == self.passTextField2) {
        
        if (textField.text.length == 16) {
//            [SVProgressHUD showErrorWithStatus:@"输入超限"];
        }
        
        if (range.location == 15 && [string isEqualToString:@""]) {
            return YES;
        }
        
        return textField.text.length <=  15 ? YES : NO;
    }else if (textField == self.iphoneTextField){
        
        if (textField.text.length == 11) {
//            [SVProgressHUD showErrorWithStatus:@"输入超限"];
        }
        
        if (range.location == 10 && [string isEqualToString:@""]) {
            return YES;
        }
        
        return textField.text.length <=  10 ? YES : NO;
        
    }else if (textField == self.codeTextField){
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
    
    if (self.passTextField == textField || self.passTextField2 == textField) {
        
        if (self.passTextField.text.length < 6) {
//            [SVProgressHUD showErrorWithStatus:@"密码最低长度要求6位"];
        }
    }
}


@end
