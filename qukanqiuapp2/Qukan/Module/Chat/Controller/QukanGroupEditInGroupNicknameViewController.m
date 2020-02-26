//
//  QukanGroupEditInGroupNicknameViewController.m
//  Qukan
//
//  Created by Mac on 2020/2/24.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanGroupEditInGroupNicknameViewController.h"

@interface QukanGroupEditInGroupNicknameViewController ()

@property (nonatomic , strong) UILabel *titleLab;

@property (nonatomic , strong) UIView *backView;

@property (nonatomic , strong) UITextField *textField;

@end

@implementation QukanGroupEditInGroupNicknameViewController

#pragma mark - set



#pragma mark - Life
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"设置群聊昵称";
    self.view.backgroundColor = CPColor(@"f0f0f0");
    [self setupInitLayoutForHBHomeViewController];
    [self setupInitBindingForHBHomeViewController];
}

#pragma mark - Private
- (void)setupInitLayoutForHBHomeViewController
{
    [self.view sd_addSubviews:@[self.titleLab,self.backView]];
    [self.backView addSubview:self.textField];
    
    self.backView.sd_layout
    .topSpaceToView(self.view, kTopBarHeight)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .heightIs(50);
    
    self.titleLab.sd_layout
    .topSpaceToView(self.backView, 5)
    .leftSpaceToView(self.view, 15)
    .rightSpaceToView(self.view, 15)
    .autoHeightRatio(0);
    
    self.textField.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0, 15, 0, 15));
}

- (void)setupInitBindingForHBHomeViewController
{
    
}

///导航栏右侧按钮
- (void)qukan_setNavBarRightButtonItem
{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = CPFont_Regular(14);
    rightBtn.frame = CGRectMake(0.0, 0.0, 40, 40.0);
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    [[rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@">>>>>");
    }];
}
#pragma mark - Public



#pragma mark - get
- (UILabel *)titleLab
{
    if (_titleLab == nil) {
        _titleLab = [UILabel new];
        _titleLab.textColor = CPColor(@"999999");
        _titleLab.font = kFont13;
        _titleLab.text = @"在这里可以设置你在这个群里的昵称，这个昵称只会在此群\n内显示";
    }
    return _titleLab;
}

- (UIView *)backView
{
    if (_backView == nil) {
        _backView = [UIView new];
        _backView.backgroundColor = UIColor.whiteColor;
    }
    return _backView;
}

- (UITextField *)textField
{
    if (_textField == nil) {
        _textField = [UITextField new];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.placeholder = @"请输入昵称";
        _textField.font = kFont15;
    }
    return _textField;
}

@end
