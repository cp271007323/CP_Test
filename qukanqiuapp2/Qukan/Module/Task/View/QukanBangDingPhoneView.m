//
//  QukanBangDingPhoneView.m
//  Qukan
//
//  Created by hello on 2019/8/21.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanBangDingPhoneView.h"

@implementation QukanBangDingPhoneView
-(void)awakeFromNib{
    [super awakeFromNib];
    
}

#pragma mark - 获取验证码点击事件
- (IBAction)getCodeClick:(UIButton *)sender {
    if (self.CodeClickBlock) {
        self.CodeClickBlock(sender);
    }
}

#pragma mark - 绑定点击事件
- (IBAction)requestClick:(UIButton *)sender {
    if (self.bangDingClickBlock) {
        self.bangDingClickBlock(sender);
    }
}

#pragma mark - 关闭点击事件
- (IBAction)closeClick:(UIButton *)sender {
    [self removeFromSuperview];
}



@end
