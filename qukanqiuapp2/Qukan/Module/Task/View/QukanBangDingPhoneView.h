//
//  QukanBangDingPhoneView.h
//  Qukan
//
//  Created by hello on 2019/8/21.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanBangDingPhoneView : UIView

/**获取验证码*/
@property (weak, nonatomic) IBOutlet UIButton *btnCode;

/**手机弹窗黑色蒙版*/
@property (weak, nonatomic) IBOutlet UIView *viewBlack;

/**手机弹窗白色背景*/
@property (weak, nonatomic) IBOutlet UIView *viewWhite;

/**手机号输入框*/
@property (weak, nonatomic) IBOutlet UITextField *txtPhone;

/**验证码输入框*/
@property (weak, nonatomic) IBOutlet UITextField *txtCode;

/**验证码点击回调*/
@property (copy, nonatomic)  void(^CodeClickBlock)(UIButton *btnCode);

/**绑定点击回调*/
@property (copy, nonatomic)  void(^bangDingClickBlock)(UIButton *btn);

@end

NS_ASSUME_NONNULL_END
