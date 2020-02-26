//
//  QukanBindEmailVC.m
//  Topic
//
//  Created by leo on 2019/9/9.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanBindEmailVC.h"
#import "QukanApiManager+Mine.h"
#import "QukanBindEmailSuccessVC.h"

@interface QukanBindEmailVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *tf_email;
@property (weak, nonatomic) IBOutlet UITextField *TF_yzCode;
@property (weak, nonatomic) IBOutlet UIButton *btn_getYzCode;
@property (weak, nonatomic) IBOutlet UIButton *btn_bind;




@end

@implementation QukanBindEmailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString *email =  [NSString stringWithFormat:@"%@",kUserManager.user.email];
    if ([email isEqualToString: @"(null)"] || [email isEqualToString:@""]) {
        self.title = @"绑定邮箱";
    }else {
        self.title = @"修改绑定邮箱";
    }
    
    
    [self.btn_getYzCode setBackgroundImage:[UIImage imageWithColor:kThemeColor] forState:UIControlStateNormal];
    [self.btn_getYzCode setBackgroundImage:[UIImage imageWithColor:HEXColor(0xeeeeee)] forState:UIControlStateDisabled];
    [self.btn_getYzCode setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    
    
    [self.btn_bind setBackgroundImage:[UIImage imageWithColor:kThemeColor] forState:UIControlStateNormal];
    [self.btn_bind setBackgroundImage:[UIImage imageWithColor:HEXColor(0xeeeeee)] forState:UIControlStateDisabled];
    [self.btn_bind setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    self.tf_email.delegate = self;
    
    self.TF_yzCode.delegate = self;
    self.btn_bind.enabled = NO;
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
    

    if (self.tf_email.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"邮箱号不能为空"];
    }
    else if (self.TF_yzCode.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
    }
    else {
        KShowHUD
        @weakify(self)
        [[kApiManager TopicBindEmailWithEmail:self.tf_email.text yzCode:self.TF_yzCode.text] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
             KHideHUD
            if (![x isKindOfClass:[NSError class]]) {
                [SVProgressHUD showSuccessWithStatus:@"邮箱绑定成功"];
                
                QukanUserModel *user = kUserManager.user;
                user.email = self.tf_email.text;
                [kUserManager setUserData:user];
                
                if (self.bindEmialSuccessBlock) {
                    self.bindEmialSuccessBlock();
                }
                
                
                
                QukanBindEmailSuccessVC *vc = [QukanBindEmailSuccessVC new];
                vc.str_email = self.tf_email.text;
                [self.navigationController pushViewController:vc animated:YES];
                
                NSMutableArray *marr = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
                for (UIViewController *vc in marr) {
                    if (vc == self) {
                        [marr removeObject:vc];
                        break;//break一定要加，不加有时候有bug
                    }
                }
                self.navigationController.viewControllers = marr;
                
                return;
            }

            [SVProgressHUD showErrorWithStatus:@"邮箱绑定失败"];
        } error:^(NSError * _Nullable error) {
            KHideHUD
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }];

    }
}

- (IBAction)codeButtonClicked:(id)sender {
    [self.view endEditing:YES];
    if (self.tf_email.text.length==0) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的邮箱号"];
    }else {
        KShowHUD
        @weakify(self);
        [[kApiManager TopicBindEmailSendCodeWithEmail:self.tf_email.text type:@"3"] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            KHideHUD
            if (![x isKindOfClass:[NSError class]]) {
                 [self Topic_countdown];
                [SVProgressHUD showSuccessWithStatus:@"验证码获取成功"];
                return;
            }
            [SVProgressHUD showErrorWithStatus:@"验证码获取失败"];
        } error:^(NSError * _Nullable error) {
            KHideHUD
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }];
    }
}

#pragma mark - tfdelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if ([textField isEqual:self.tf_email]) {
        if (str.length > 0 && self.TF_yzCode.text.length > 0 )  {
            self.btn_bind.enabled = YES;
        }else {
            self.btn_bind.enabled = NO;
        }
        return YES;
    }else if ([textField isEqual:self.TF_yzCode]) {
        if (str.length > 0 && self.tf_email.text.length > 0 )  {
            self.btn_bind.enabled = YES;
        }else {
            self.btn_bind.enabled = NO;
        }
        if (range.length == 1 && string.length == 0) {
            return YES;
        } else
        if (self.TF_yzCode.text.length >= 6) {
            self.TF_yzCode.text = [textField.text substringToIndex:6];
            return NO;
        }
    }
    return YES;
    
}

- (void)dealloc {
    NSLog(@"vc deallocdeallocdeallocdeallocdealloc");
}


@end
