//
//  QukanNotLoginView.m
//  Qukan
//
//  Created by mac on 2018/11/18.
//  Copyright © 2018 Ningbo Suda. All rights reserved.
//

#import "QukanNotLoginView.h"

@implementation QukanNotLoginView

- (void)awakeFromNib {
    [super awakeFromNib];
    UIButton *button = [self viewWithTag:100];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 2.0;
    button.layer.borderColor = [UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1.0].CGColor;
    button.layer.borderWidth = 0.5;
}
- (IBAction)buttonClick:(id)sender {
   kGuardLogin
}

+ (void)showWithView:(UIView *)view {
    QukanNotLoginView *loginView = [QukanNotLoginView Qukan_initWithXib];
    [view addSubview:loginView];
    [loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
}
+ (void)hideWithWiew:(UIView *)view {
    for (UIView *v in view.subviews) {
        if ([v isKindOfClass:[self class]]) {
            [v removeFromSuperview];
        }
    }
}

@end
