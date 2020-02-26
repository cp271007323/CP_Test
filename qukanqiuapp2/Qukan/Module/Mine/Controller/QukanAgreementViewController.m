#import "QukanAgreementViewController.h"
#import <WebKit/WebKit.h>
@interface QukanAgreementViewController ()<WKNavigationDelegate, WKUIDelegate>
@property (nonatomic, strong) WKWebView *Qukan_myWebView;
@property (nonatomic, strong) NSString *Qukan_requestUrl;
@end
@implementation QukanAgreementViewController
- (WKWebView *)Qukan_myWebView {
    if (!_Qukan_myWebView) {
        _Qukan_myWebView = [[WKWebView alloc] init];
        _Qukan_myWebView.backgroundColor = kCommentBackgroudColor;
        _Qukan_myWebView.UIDelegate = self;
        _Qukan_myWebView.navigationDelegate = self;
        _Qukan_myWebView.allowsBackForwardNavigationGestures = YES;
        _Qukan_myWebView.scrollView.showsVerticalScrollIndicator = NO;
        _Qukan_myWebView.scrollView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_Qukan_myWebView];
        [_Qukan_myWebView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.left.right.bottom.equalTo(self.view);
            make.left.equalTo(self.view).offset(10);
            make.right.equalTo(self.view).offset(-10);
            make.top.equalTo(self.view);
            make.bottom.equalTo(self.view);
        }];
    }
    return _Qukan_myWebView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"《用户注册协议》";
    self.Qukan_requestUrl = Qukan_Privacy_Url;
    self.view.backgroundColor = kCommonWhiteColor;
    
    [self.Qukan_myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.Qukan_requestUrl]]];
}
- (void)Qukan_netWorkClickRetry {
    [QukanFailureView Qukan_hideWithView:self.view];
    [self.Qukan_myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.Qukan_requestUrl]]];
}
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
}
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    @weakify(self)
    [QukanFailureView Qukan_showWithView:self.view centerY:-180.0 block:^{
        @strongify(self)
        [self Qukan_netWorkClickRetry];
    }];
}
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if ([challenge previousFailureCount] == 0) {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        } else {
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }
    } else {
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
@end
