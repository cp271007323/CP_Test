//
//  QukanBindingPhoneViewController.h
//  Qukan
//
//  Created by hello on 2019/9/20.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanBindingPhoneViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btn_Return;
@property (weak, nonatomic) IBOutlet UIButton *btnGetCode;
@property (weak, nonatomic) IBOutlet UIButton *btnOK;
@property (weak, nonatomic) IBOutlet UIButton *btnLookProtocol;
@property (weak, nonatomic) IBOutlet UITextField *txtPhone;
@property (weak, nonatomic) IBOutlet UITextField *txtCode;
/**微信unionId*/
@property (copy, nonatomic)  NSString *name;
@property (copy, nonatomic)  NSString *openid;
@property (copy, nonatomic)  NSString *unionid;
@property (copy, nonatomic)  NSString *iconurl;
@property (copy, nonatomic)  NSString *accessToken;
@end

NS_ASSUME_NONNULL_END
