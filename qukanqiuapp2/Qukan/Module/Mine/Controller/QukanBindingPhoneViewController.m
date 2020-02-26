//
//  QukanBindingPhoneViewController.m
//  Qukan
//
//  Created by hello on 2019/9/20.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanApiManager+Mine.h"
#import "QukanPrivacyAgreementViewController.h"
#import <OpenInstallSDK.h>

@interface QukanBindingPhoneViewController ()

@property(nonatomic, copy)   NSString          *invtiionCode;

@end

@implementation QukanBindingPhoneViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.btnOK.backgroundColor = kThemeColor;
    self.btnGetCode.backgroundColor = kThemeColor;
    
    
    NSMutableAttributedString *strM = [[NSMutableAttributedString alloc] initWithString:self.btnLookProtocol.titleLabel.text];
    
    NSRange rang = [self.btnLookProtocol.titleLabel.text rangeOfString:@"《用户协议》"];
    
    [strM addAttribute:NSForegroundColorAttributeName  value:kThemeColor range:rang];
    
    [self.btnLookProtocol setAttributedTitle:strM forState:UIControlStateNormal];
    
    
    
    @weakify(self);
#pragma mark 点击左上角返回
    [[self.btn_Return rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
#pragma mark 点击发送验证码
    [[self.btnGetCode rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self requestGetCode];
    }];
    
#pragma mark 点击查看协议
    [[self.btnLookProtocol rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self UserProtocol];
    }];
    
#pragma mark 点击确认按钮
    [[self.btnOK rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self requestData];
    }];
    
#pragma mark 监听手机号码输入
    [self.txtPhone.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        if (x.length >= 12) {
            self.txtPhone.text = [x substringToIndex:x.length-1];
            if (self.txtCode.text.length >= 6) {
                [self.txtPhone resignFirstResponder];
                [self.txtCode resignFirstResponder];
                [self requestData];
            }else{
                [self.txtCode becomeFirstResponder];
            }
            
        }
    }];
    
#pragma mark 监听验证码输入
    [self.txtCode.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        if (x.length >= 7) {
            
            self.txtCode.text = [x substringToIndex:x.length-1];
            if (self.txtPhone.text.length >= 11) {
                [self.txtPhone resignFirstResponder];
                [self.txtCode resignFirstResponder];
                [self requestData];
            }else{
                [self.txtPhone becomeFirstResponder];
            }
            
        }
    }];
    
     [self OpeninstallGetInstallParmsCompleted];
    
}

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
            kAppManager.openInstallChannelCode = appData.channelCode;
        }
    }];
}



#pragma mark -跳转用户协议
- (void)UserProtocol {
    QukanPrivacyAgreementViewController *vc = [[QukanPrivacyAgreementViewController alloc] init];
    vc.title = @"用户协议";
    vc.isPresent = YES;
//    [self.navigationController pushViewController:vc animated:YES];
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark -倒计时
- (void)Qukan_countdown {
    self.btnGetCode.userInteractionEnabled = NO;
    __block int timeout = 59;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.btnGetCode.userInteractionEnabled = YES;
                [self.btnGetCode setTitle:@"重新获取验证码" forState:UIControlStateNormal];
            });
        }else{
            int seconds = timeout%60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d秒", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.btnGetCode setTitle:strTime forState:UIControlStateNormal];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}


- (void)dataSourceDealLoginWith:(id)response {
    NSDictionary *dict = (NSDictionary *)response;
    QukanUserModel *model = [QukanUserModel modelWithJSON:dict];
    if (model.tel.length > 0) {
        [kUserManager setUserData:model];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:Qukan_Recommend_Follow_NotificationName object:nil];
        [kNotificationCenter postNotificationName:kUserDidLoginNotification object:nil];
        [OpenInstallSDK reportRegister];
    }

}

#pragma mark -绑定手机号请求
-(void)requestData{
    if (self.txtPhone.text.length==0) {
        [self.txtPhone becomeFirstResponder];
        [self.view showTip:@"手机号码不能为空"];
    }
    
    if (self.txtCode.text.length==0) {
        [self.txtCode becomeFirstResponder];
        [self.view showTip:@"请输入验证码"];
    }
    else {
        NSString *phone = [NSString stringWithFormat:@"86%@",self.txtPhone.text];
        
        NSString *invitationCode = [kUserDefaults objectForKey:Qukan_openinstallIntCode];
        if (self.invtiionCode.length == 0 || self.invtiionCode == nil) {
            self.invtiionCode = invitationCode;
        }
        KShowHUD
        @weakify(self);
        [[[kApiManager QukanUserWithId:@"01" addOpenId:self.openid addUnionid:self.unionid  addNickname:self.name addHeadimgUrl:self.iconurl addAccessToken:self.accessToken umengToken:Qukan_UMAppKey invitationCode:self.invtiionCode type:@"2" tel:phone code:self.txtCode.text pass:@""] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            KHideHUD
            
            [self dataSourceDealLoginWith:x];
        } error:^(NSError * _Nullable error) {
            @strongify(self);
            KHideHUD
            [self.view showTip:error.localizedDescription];
            
        }];

    }
}

#pragma mark -获取验证码
- (void)requestGetCode{
    if (self.txtPhone.text.length==0) {
        [self.view showTip:@"手机号码不能为空"];
    }
    else {
        @weakify(self);
        KShowHUD
        [[[kApiManager QukansmsSendCodeWithMobile:self.txtPhone.text addCode:@"86"] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            KHideHUD
            [self Qukan_countdown];
            [self.view showTip:@"发送验证码成功"];
        } error:^(NSError * _Nullable error) {
            @strongify(self);
            KHideHUD
            [self.view showTip:error.localizedDescription];
        }];
    }
}



@end
