//
//  QukanPrivacyAgreementViewController.m
//  Qukan
//
//  Created by mac on 2018/11/19.
//  Copyright © 2018 Ningbo Suda. All rights reserved.
//

#import "QukanPrivacyAgreementViewController.h"
#import <WebKit/WebKit.h>
#import "NSObject+WMSafeKVO.h"
//#import "QukanUIViewController+HHConstruct.h"
//#import <UIViewController+HBD.h>

@interface QukanPrivacyAgreementViewController ()<WKNavigationDelegate, WKUIDelegate>
@property (nonatomic, strong) WKWebView *Qukan_myWebView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHeight;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation QukanPrivacyAgreementViewController

- (WKWebView *)Qukan_myWebView {
    if (!_Qukan_myWebView) {
        _Qukan_myWebView = [[WKWebView alloc] initWithFrame:CGRectZero];
        _Qukan_myWebView.backgroundColor = [UIColor whiteColor];
        _Qukan_myWebView.UIDelegate = self;
        _Qukan_myWebView.navigationDelegate = self;
        _Qukan_myWebView.allowsBackForwardNavigationGestures = YES;
        _Qukan_myWebView.scrollView.showsHorizontalScrollIndicator = NO;
        _Qukan_myWebView.scrollView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_Qukan_myWebView];
        [_Qukan_myWebView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(10);
            make.right.equalTo(self.view).offset(-10);
            make.bottom.equalTo(self.view);
            CGFloat height = isIPhoneXSeries() ? 88.0:64.0;
            make.top.mas_equalTo(self.isPresent ? height : 0);
        }];
    }
    return _Qukan_myWebView;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.Qukan_myWebView wm_addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.Qukan_myWebView wm_removeObserver:self forKeyPath:@"estimatedProgress"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"隐私协议";
    if (isIPhoneXSeries()) { self.navHeight.constant = 88.0; }
    self.view.backgroundColor = [UIColor whiteColor];
//    self.hbd_barHidden = YES;
    UIView *nav = [self.view viewWithTag:100];
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = kThemeColor;
    lineView.hidden = YES;
    [nav addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(nav);
        make.height.mas_equalTo(0.3);
    }];
    
    NSString *appName = AppName;
    NSString *privacyStr = @"隐私协议";
    self.titleLabel.text = [NSString stringWithFormat:@"%@%@",appName,privacyStr];
    [self.Qukan_myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:Qukan_Privacy_Url]]];

}

- (IBAction)backBtnClick {
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)agreeBtnClick {
    [[NSUserDefaults standardUserDefaults] setObject:@"QukanForTheFirstTime" forKey:@"QukanForTheFirstTime"];
//    if (self.isPresent) {
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }else {
//        [self removeFromParentViewController];
//        [self.view removeFromSuperview];        
//    }
    
     [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    KShowHUD
}
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    KHideHUD
    UIButton *agreeBtn = [self.view viewWithTag:200];
    agreeBtn.hidden = NO;
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    KHideHUD
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress>=0.6) {
            KHideHUD
            UIButton *agreeBtn = [self.view viewWithTag:200];
            agreeBtn.hidden = NO;
        }
    }
}
@end
