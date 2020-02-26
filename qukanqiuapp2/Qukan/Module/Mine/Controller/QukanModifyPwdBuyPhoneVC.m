//
//  QukanModifyPwdBuyPhoneVC.m
//  Topic
//
//  Created by leo on 2019/9/9.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanModifyPwdBuyPhoneVC.h"
#import "QukanResetPwdTwoVC.h"

@interface QukanModifyPwdBuyPhoneVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *tf_phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *TF_yzCode;
@property (weak, nonatomic) IBOutlet UIButton *btn_getYzCode;
@property (weak, nonatomic) IBOutlet UIButton *btn_submit;

@end

@implementation QukanModifyPwdBuyPhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"修改密码";
    
    [self.btn_getYzCode setBackgroundImage:[UIImage imageWithColor:HEXColor(0xeeeeee)] forState:UIControlStateDisabled];
    [self.btn_getYzCode setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    
    
    [self.btn_submit setBackgroundImage:[UIImage imageWithColor:HEXColor(0xeeeeee)] forState:UIControlStateDisabled];
    [self.btn_submit setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    self.tf_phoneNumber.delegate = self;
    
    self.TF_yzCode.delegate = self;
    self.btn_submit.enabled = NO;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


- (void)Topic_countdown {
    self.btn_getYzCode.enabled = NO;
    __block int timeout = 59;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.btn_getYzCode.enabled = YES;
                [self.btn_getYzCode setTitle:@"重新获取" forState:UIControlStateNormal];
            });
        }else{
            int seconds = timeout%60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d秒", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.btn_getYzCode setTitle:strTime forState:UIControlStateDisabled];
                
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}


- (IBAction)bindButtonClicked:(id)sender {
    if (self.tf_phoneNumber.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"手机号不能为空"];
    }
    else if (self.TF_yzCode.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
    }
    else {
        QukanResetPwdTwoVC *vc = [QukanResetPwdTwoVC new];
        vc.str_phone = self.tf_phoneNumber.text;
        vc.str_yzCode = self.TF_yzCode.text;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)codeButtonClicked:(id)sender {
    [self.view endEditing:YES];
    if (self.tf_phoneNumber.text.length==0) {
        [SVProgressHUD showErrorWithStatus:@"手机号码不能为空"];
    }
    else {
        [MBProgressHUD showHUDAddedTo:self.view animated:NO];
        NSString *countryCallingCode = [@"+86" stringByReplacingOccurrencesOfString:@"+" withString:@""];
        NSDictionary *parameters = @{@"countryCallingCode":countryCallingCode,
                                     @"mobile":self.tf_phoneNumber.text,
                                     @"type":@"2"
                                     };
        [QukanNetworkTool Qukan_POST:@"sms/sendCode" parameters:parameters success:^(NSDictionary *response) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if ([response[@"status"] integerValue] == 200) {
                [self Topic_countdown];
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

- (void)dealloc {
    NSLog(@"vc deallocdeallocdeallocdeallocdealloc");
}

#pragma mark - tfdelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if ([textField isEqual:self.tf_phoneNumber]) {
        if (str.length > 0 && self.TF_yzCode.text.length > 0 )  {
            self.btn_submit.enabled = YES;
        }else {
            self.btn_submit.enabled = NO;
        }
    }else {
        if (str.length > 0 && self.tf_phoneNumber.text.length > 0 )  {
            self.btn_submit.enabled = YES;
        }else {
            self.btn_submit.enabled = NO;
        }
    }
    
    return YES;
}


@end
