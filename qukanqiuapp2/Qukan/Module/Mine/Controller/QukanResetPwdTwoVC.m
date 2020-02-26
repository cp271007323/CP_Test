//
//  QukanResetPwdTwoVC.m
//  Topic
//
//  Created by leo on 2019/9/9.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanResetPwdTwoVC.h"
#import "QukanApiManager+Mine.h"
#import "QukanInfoViewController.h"

@interface QukanResetPwdTwoVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *tf_pwdOne;
@property (weak, nonatomic) IBOutlet UITextField *tf_pwdTwo;
@property (weak, nonatomic) IBOutlet UIButton *btn_save;

@end

@implementation QukanResetPwdTwoVC


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"修改密码";
 
    [self.btn_save setBackgroundImage:[UIImage imageWithColor:HEXColor(0xeeeeee)] forState:UIControlStateDisabled];
    [self.btn_save setBackgroundImage:[UIImage imageWithColor:kThemeColor] forState:UIControlStateNormal];
    [self.btn_save setBackgroundImage:[UIImage imageWithColor:kThemeColor] forState:UIControlStateHighlighted];
    [self.btn_save setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    self.tf_pwdOne.delegate = self;
    
    self.tf_pwdTwo.delegate = self;
    self.btn_save.enabled = NO;
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


#pragma mark - tfdelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if ([textField isEqual:self.tf_pwdOne]) {
        if (str.length > 0 && self.tf_pwdTwo.text.length > 0 )  {
            self.btn_save.enabled = YES;
        }else {
            self.btn_save.enabled = NO;
        }
    }else {
        if (str.length > 0 && self.tf_pwdOne.text.length > 0 )  {
            self.btn_save.enabled = YES;
        }else {
            self.btn_save.enabled = NO;
        }
    }
    
    return YES;
}


- (IBAction)btn_saveClick:(id)sender {
    
    if (![self.tf_pwdOne.text isEqualToString:self.tf_pwdTwo.text]) {
        [SVProgressHUD showErrorWithStatus:@"两次密码不一致!"];
        return;
    }
    
    if (self.tf_pwdTwo.text.length < 6 || self.tf_pwdOne.text.length > 16) {
        [SVProgressHUD showErrorWithStatus:@"密码长度需为6-16位！"];
        return;
    }
    
    KShowHUD
    NSString *tel = [NSString stringWithFormat:@"%@%@", [@"+86" stringByReplacingOccurrencesOfString:@"+" withString:@""], self.str_phone];
    
    @weakify(self)
    [[[kApiManager TopicgcuserForgetPassWithTel:tel addCode:self.str_yzCode addPassword:self.tf_pwdOne.text] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        KHideHUD
        [SVProgressHUD showSuccessWithStatus:@"密码修改成功"];
        for (UIViewController *vc in self.navigationController.childViewControllers) {
            if ([vc isKindOfClass:[QukanInfoViewController class]]) {
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
        [self.navigationController popViewControllerAnimated:YES];
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)dealloc {
    NSLog(@"vc deallocdeallocdeallocdeallocdealloc");
}

@end
