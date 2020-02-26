#import "QukanPhoneVerificationViewController.h"
#import "QukanAgreementViewController.h"

#import "QukanApiManager+Mine.h"
@interface QukanPhoneVerificationViewController ()
@property (weak, nonatomic) IBOutlet UILabel *countryCodeLabel;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;
@property (weak, nonatomic) IBOutlet UITextField *iphoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *skipButton;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@end
@implementation QukanPhoneVerificationViewController
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
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *inputBgView = [self.view viewWithTag:200];
    inputBgView.layer.masksToBounds = YES;
    inputBgView.layer.cornerRadius = 3.0;
    UIButton *loginBtn = [self.view viewWithTag:300];
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.cornerRadius = 4.0;
    loginBtn.backgroundColor = kThemeColor;
    UIButton *codeBtn = [self.view viewWithTag:400];
    codeBtn.layer.masksToBounds = YES;
    codeBtn.layer.cornerRadius = 2.5;
    codeBtn.layer.borderColor = kThemeColor.CGColor;
    codeBtn.layer.borderWidth = 0.5;
    [codeBtn setTitleColor:kThemeColor forState:UIControlStateNormal];
    if (self.isLogin) {
        [[self.view viewWithTag:555] setHidden:YES];
    }
}
- (IBAction)backBtnClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
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
                [self.codeButton setTitle:@"验证" forState:UIControlStateNormal];
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
- (IBAction)skipButtonClicked:(id)sender {
    [self Qukan_loginSuccessSaveWithData:self.dict phone:@"" countryCode:@""];
    [self.navigationController popToRootViewControllerAnimated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:Qukan_Recommend_Follow_NotificationName object:nil];
}
- (IBAction)nextButtonClicked:(id)sender {
    if (self.iphoneTextField.text.length==0) {
        [SVProgressHUD showErrorWithStatus:@"手机号码不能为空"];
    }
    else if (self.codeTextField.text.length==0) {
        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
    }
    else {
        [MBProgressHUD showHUDAddedTo:self.view animated:NO];
        NSString *tel = [NSString stringWithFormat:@"%@%@", [self.countryCodeLabel.text stringByReplacingOccurrencesOfString:@"+" withString:@""], self.iphoneTextField.text];
//        NSDictionary *parameters = @{@"tel":tel,
//                                     @"code":self.codeTextField.text,
//                                     @"thirdId":self.thirdId?:@""};
//        [QukanNetworkTool Qukan_POST:@"gcuser/bind" parameters:parameters success:^(NSDictionary *response) {
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            if ([response[@"status"] integerValue]==200) {
//                NSString *countryCode = [self.countryCodeLabel.text stringByReplacingOccurrencesOfString:@"+" withString:@""];
//                NSString *tel = [NSString stringWithFormat:@"%@%@", countryCode, self.iphoneTextField.text];
//                if (self.isLogin) {
////                    [[NSUserDefaults standardUserDefaults] setObject:tel forKey:Qukan_Iphone_Key];
////                    [[NSUserDefaults standardUserDefaults] synchronize];
//                    kUserManager.user.tel = tel;
//                    [self.navigationController popViewControllerAnimated:YES];
//                } else {
//                    [self Qukan_loginSuccessSaveWithData:self.dict phone:self.iphoneTextField.text countryCode:countryCode];
//                    [self.navigationController popToRootViewControllerAnimated:NO];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:Qukan_Recommend_Follow_NotificationName object:nil];
//                }
//            } else {
//                [SVProgressHUD showErrorWithStatus:response[@"msg"]];
//            }
//        } failure:^(NSError *error) {
//            [MBProgressHUD hideHUDForView:self.view animated:NO];
//            [SVProgressHUD showErrorWithStatus:@"手机号绑定失败"];
//        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
//        }];
        
        
        [[[kApiManager QukangcuserBindWithTel:tel addCode:self.codeTextField.text addThirdId:kUserManager.user.thirdId] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
            [self dataSourceDealWith:x];
        } error:^(NSError * _Nullable error) {
            [MBProgressHUD hideHUDForView:self.view animated:NO];
//            [SVProgressHUD showErrorWithStatus:@"手机号绑定失败"];
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }];
    }
}

- (void)dataSourceDealWith:(id)response {
    NSString *countryCode = [self.countryCodeLabel.text stringByReplacingOccurrencesOfString:@"+" withString:@""];
    NSString *tel = [NSString stringWithFormat:@"%@%@", countryCode, self.iphoneTextField.text];
    if (self.isLogin) {
        kUserManager.user.tel = tel;
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self Qukan_loginSuccessSaveWithData:self.dict phone:self.iphoneTextField.text countryCode:countryCode];
        [self.navigationController popToRootViewControllerAnimated:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:Qukan_Recommend_Follow_NotificationName object:nil];
    }
}

- (IBAction)codeButtonClicked:(id)sender {
    [self.iphoneTextField endEditing:YES];
    if (self.iphoneTextField.text.length==0) {
        [SVProgressHUD showErrorWithStatus:@"手机号码不能为空"];
    }
    else {
        [SVProgressHUD showWithStatus:@""];
        NSString *countryCallingCode = [self.countryCodeLabel.text stringByReplacingOccurrencesOfString:@"+" withString:@""];
//        NSDictionary *parameters = @{@"countryCallingCode":countryCallingCode,
//                                     @"mobile":self.iphoneTextField.text,};
//        [QukanNetworkTool Qukan_POST:@"sms/sendCode" parameters:parameters success:^(NSDictionary *response) {
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            if ([response[@"status"] integerValue]==200) {
//                [self Qukan_countdown];
//            } else {
//                [SVProgressHUD showSuccessWithStatus:@"验证码获取失败"];
//            }
//        } failure:^(NSError *error) {
//            [MBProgressHUD hideHUDForView:self.view animated:NO];
//            [SVProgressHUD showErrorWithStatus:@"验证码获取失败"];
//        }];
        
        [[[kApiManager QukansmsSendCodeWithMobile:self.iphoneTextField.text addCode:countryCallingCode] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
            [self Qukan_countdown];
            [SVProgressHUD showSuccessWithStatus:@"发送验证码成功"];
        } error:^(NSError * _Nullable error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }];
    }
}
- (IBAction)agreementButtonClicked:(id)sender {
    QukanAgreementViewController *vc = [[QukanAgreementViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)countryCodeButtonClicked:(id)sender {
   
}
- (void)Qukan_loginSuccessSaveWithData:(NSDictionary *)d phone:(NSString *)phone countryCode:(NSString *)countryCode {
    
//    NSString *token = d[@"token"]?:@"";
//    NSString *headImg = d[@"avatorId"]?:@"";
//    NSString *md5Key = d[@"key"]?:@"";
//    NSString *name = d[@"nickname"]?:@"";
//    NSString *appId = [NSString stringWithFormat:@"%@", d[@"appId"]?:@""];
//    NSString *userId = [NSString stringWithFormat:@"%@", d[@"id"]?:@""];
//    NSString *tel = [NSString stringWithFormat:@"%@%@", countryCode, phone];
//    NSString *thirdId = [NSString stringWithFormat:@"%@", d[@"thirdId"]?:@""];
////    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:Qukan_Is_Login_Key];
//    [[NSUserDefaults standardUserDefaults] setObject:tel forKey:Qukan_Iphone_Key];
//    [[NSUserDefaults standardUserDefaults] setObject:token forKey:Qukan_Token_Key];
//    [[NSUserDefaults standardUserDefaults] setObject:headImg forKey:Qukan_HeadImage_Key];
//    [[NSUserDefaults standardUserDefaults] setObject:md5Key forKey:Qukan_MD5_Key];
//    [[NSUserDefaults standardUserDefaults] setObject:name forKey:Qukan_Name_Key];
//    [[NSUserDefaults standardUserDefaults] setObject:appId forKey:Qukan_AppId_Key];
//    [[NSUserDefaults standardUserDefaults] setObject:userId forKey:Qukan_UserId_Key];
//    [[NSUserDefaults standardUserDefaults] setObject:thirdId forKey:Qukan_ThirdId_Key];
//    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
