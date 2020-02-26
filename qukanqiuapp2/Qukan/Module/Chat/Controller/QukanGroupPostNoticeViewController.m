//
//  QukanGroupPostNoticeViewController.m
//  Qukan
//
//  Created by Mac on 2020/2/24.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanGroupPostNoticeViewController.h"

@interface QukanGroupPostNoticeViewController ()

@property (nonatomic , strong) UITextView *textView;

@end

@implementation QukanGroupPostNoticeViewController

#pragma mark - set



#pragma mark - Life
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"群公告";
    [self qukan_setNavBarRightButtonItem];
    [self setupInitLayoutForHBHomeViewController];
    [self setupInitBindingForHBHomeViewController];
}

#pragma mark - Private
- (void)setupInitLayoutForHBHomeViewController
{
    [self.view addSubview:self.textView];
    self.textView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
}

- (void)setupInitBindingForHBHomeViewController
{
    
}

///导航栏右侧按钮
- (void)qukan_setNavBarRightButtonItem
{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(0.0, 0.0, 40, 40.0);
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    [[rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"完成");
        
    }];
}

#pragma mark - Public



#pragma mark - get
- (UITextView *)textView
{
    if (_textView == nil) {
        _textView = [[UITextView alloc] initWithFrame:self.view.bounds];
        _textView.textColor = CPColor(@"222222");
        _textView.font = CPFont_Regular(18);
        _textView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    }
    return _textView;
}

@end
