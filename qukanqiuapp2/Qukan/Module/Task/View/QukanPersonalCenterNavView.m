//
//  QukanPersonalCenterNavView.m
//  Qukan
//
//  Created by leo on 2020/1/4.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanPersonalCenterNavView.h"

@interface QukanPersonalCenterNavView ()

/**头像*/
@property(nonatomic, strong) UIImageView  * QukanHeader_img;
/**名称lab*/
@property(nonatomic, strong) UILabel   * QukanNickName_lab;


/**设置按钮*/
@property(nonatomic, strong) UIButton   * QukanSet_btn;

/**主视图*/
@property(nonatomic, strong) UIView   * QukanContent_view;

/**<#说明#>*/
@property(nonatomic, assign) BOOL    QukanCOntentIsShow_bool;
@end


@implementation QukanPersonalCenterNavView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)initUI {
    
    [self addSubview:self.QukanContent_view];
    self.QukanContent_view.frame = CGRectMake(0, -kStatusBarHeight - 44, kScreenWidth, kStatusBarHeight + 44);
    
    [self.QukanContent_view addSubview:self.QukanHeader_img];
    [self.QukanContent_view addSubview:self.QukanNickName_lab];
    [self.QukanHeader_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.QukanNickName_lab);
        make.left.equalTo(self.QukanContent_view).offset(15);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
  
    [self.QukanNickName_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.QukanHeader_img.mas_right).offset(10);
        make.bottom.equalTo(self.QukanContent_view);
        make.height.equalTo(@(44));
        make.width.lessThanOrEqualTo(@(100));
    }];
    
    [self addSubview:self.QukanSet_btn];
    [self.QukanSet_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(kStatusBarHeight);
        make.right.equalTo(self).offset(-15);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
}

#pragma mark ===================== pubulic fuction ==================================
- (void)freshSubView {
    [self.QukanHeader_img sd_setImageWithURL:[NSURL URLWithString:kUserManager.user.avatorId] placeholderImage:kImageNamed(@"Qukan_user_DefaultAvatar")];
    
    if (kUserManager.isLogin) {
        self.QukanNickName_lab.text = kUserManager.user.nickname.length > 0? kUserManager.user.nickname:@"外星人";
    }else {
        self.QukanNickName_lab.text = @"登录/注册";
    }
}

- (void)setBtnClick {}

- (void)headerOrNickClickAction {}

- (void)showContentView{
    if (self.QukanCOntentIsShow_bool) {
        return;
    }
    
    self.QukanCOntentIsShow_bool = YES;
    [UIView animateWithDuration:0.5f animations:^{
        CGRect frame = self.QukanContent_view.frame;
        frame.origin.y = 0;
        self.QukanContent_view.frame = frame;
    }];
}
- (void)hideContentView {
    if (!self.QukanCOntentIsShow_bool) {
        return;
    }
    
    self.QukanCOntentIsShow_bool = NO;
    [UIView animateWithDuration:0.5f animations:^{
        CGRect frame = self.QukanContent_view.frame;
        frame.origin.y = -kStatusBarHeight - 44;
        self.QukanContent_view.frame = frame;
    }];
}


#pragma mark ===================== lazy ==================================
- (UIImageView *)QukanHeader_img {
    if (!_QukanHeader_img) {
        _QukanHeader_img = [UIImageView new];
        _QukanHeader_img.layer.masksToBounds = YES;
        _QukanHeader_img.layer.cornerRadius = 15;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerOrNickClickAction)];
        _QukanHeader_img.userInteractionEnabled = YES;
        
        [_QukanHeader_img addGestureRecognizer:tap];
    }
    return _QukanHeader_img;
}

- (UILabel *)QukanNickName_lab {
    if (!_QukanNickName_lab) {
        _QukanNickName_lab = [UILabel new];
        _QukanNickName_lab.textColor = kCommonWhiteColor;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerOrNickClickAction)];
        _QukanNickName_lab.userInteractionEnabled = YES;
        
        [_QukanNickName_lab addGestureRecognizer:tap];
    }
    return _QukanNickName_lab;
}

- (UIButton *)QukanSet_btn {
    if (!_QukanSet_btn) {
        _QukanSet_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_QukanSet_btn setImage:kImageNamed(@"sysSet") forState:UIControlStateNormal];
        
        [_QukanSet_btn addTarget:self action:@selector(setBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _QukanSet_btn;
}

- (UIView *)QukanContent_view{
    if (!_QukanContent_view) {
        _QukanContent_view = [UIView new];
        _QukanContent_view.backgroundColor = HEXColor(0x2a2a2a);
    }
    return _QukanContent_view;
}

@end
