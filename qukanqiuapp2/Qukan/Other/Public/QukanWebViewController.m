#import "QukanWebViewController.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <WebKit/WebKit.h>
//#import "QukanNewsListModel.h"
//#import "QukanDetailsViewController.h"
//#import "QukanRecommendPersonalInfoViewController.h"
#import "NSObject+WMSafeKVO.h"
//#import "QukanUIViewController+HHConstruct.h"

@interface QukanWebViewController ()<WKNavigationDelegate, WKUIDelegate>
@property (nonatomic, strong) WKWebView *Qukan_myWebView;
@end
@implementation QukanWebViewController

- (WKWebView *)Qukan_myWebView {
    if (!_Qukan_myWebView) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.preferences = [[WKPreferences alloc] init];
        config.preferences.minimumFontSize = 10;
        config.preferences.javaScriptEnabled = YES;
        config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        config.userContentController = [[WKUserContentController alloc] init];
        config.processPool = [[WKProcessPool alloc] init];
        _Qukan_myWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
        _Qukan_myWebView.backgroundColor = [UIColor whiteColor];
        _Qukan_myWebView.UIDelegate = self;
        _Qukan_myWebView.navigationDelegate = self;
        _Qukan_myWebView.allowsBackForwardNavigationGestures = YES;
        [self.view addSubview:_Qukan_myWebView];
        [_Qukan_myWebView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view);
            
        }];
    }
    return _Qukan_myWebView;
}
//- (void)addScriptMessageHandler {
//    [self.Qukan_myWebView.configuration.userContentController addScriptMessageHandler:self name:@"isLogin"];
//    [self.Qukan_myWebView.configuration.userContentController addScriptMessageHandler:self name:@"goUserDetail"];
//    [self.Qukan_myWebView.configuration.userContentController addScriptMessageHandler:self name:@"goTodayScoreDetails"];
//    [self.Qukan_myWebView.configuration.userContentController addScriptMessageHandler:self name:@"goQukanMethod1"];
//    [self.Qukan_myWebView.configuration.userContentController addScriptMessageHandler:self name:@"goQukanMethod2"];
//}
//- (void)removeScriptMessageHandler {
//    [self.Qukan_myWebView.configuration.userContentController removeScriptMessageHandlerForName:@"isLogin"];
//    [self.Qukan_myWebView.configuration.userContentController removeScriptMessageHandlerForName:@"goUserDetail"];
//    [self.Qukan_myWebView.configuration.userContentController removeScriptMessageHandlerForName:@"goTodayScoreDetails"];
//    [self.Qukan_myWebView.configuration.userContentController removeScriptMessageHandlerForName:@"goQukanMethod1"];
//    [self.Qukan_myWebView.configuration.userContentController removeScriptMessageHandlerForName:@"goQukanMethod2"];
//}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.Qukan_myWebView wm_addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
//    [self addScriptMessageHandler];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
//    [self removeScriptMessageHandler];
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//    [self.navigationController.navigationBar setBackgroundImage:[QukanTool Qukan_createImageWithColor: kThemeColor] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    if (!self.Qukan_isDetails) {
//        [self Qukan_setNavBarButtonItem];
//    }
    [self.Qukan_myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.Qukan_requestUrl]]];
//    if (self.Qukan_recommendId!=0) {
//        [self Qukan_submissionStatistics];
//    }
    

//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Qukan_updateData) name:Qukan_Recommend_Follow_NotificationName object:nil];
    
}

- (void)dealloc
{
    [self.Qukan_myWebView wm_removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)reportWithContent:(NSString *)content {
    KShowHUD
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:content forKey:@"content"];
    [parameters setObject:@"" forKey:@"contact"];
    [parameters setObject:@"" forKey:@"imgurl"];
    
    @weakify(self)
    [QukanNetworkTool Qukan_POST:@"gcUserFeedback/add" parameters:parameters success:^(NSDictionary *response) {
        @strongify(self)
        KHideHUD
        [SVProgressHUD showSuccessWithStatus:FormatString(@"举报已提交，待工作人员%@",kStStatus.phone)];
        
    } failure:^(NSError *error) {
        @strongify(self)
        KHideHUD
        [SVProgressHUD showSuccessWithStatus:@"提交失败"];
    }];
}

//- (void)Qukan_updateData {
////    BOOL isLogin = kUserManager.isLogin
//    if (kUserManager.isLogin && self.Qukan_isBallBar) {
//        NSString *requestUrl = [NSString stringWithFormat:@"%@/match-detail/bolling/bolling_detail.html?id=%ld", Qukan_BaseURL, self.Qukan_isBallBarId];
//        NSString *authorization = kUserManager.user.token;
//        NSString *md5Key = kUserManager.user.key;
//        requestUrl = [NSString stringWithFormat:@"%@&token=Bearer_%@&number=%@", requestUrl, authorization, md5Key];
//        self.Qukan_requestUrl = requestUrl;
//    }
//    else if (kUserManager.isLogin && self.Qukan_recommendId!=0) {
//        NSString *Qukan_requestUrl = [NSString stringWithFormat:@"%@/match-detail/loss/scrollball_detail.html?recommenId=%ld", Qukan_BaseURL, self.Qukan_recommendId];
//        NSString *authorization = kUserManager.user.token;
//        NSString *md5Key = kUserManager.user.key;
//        Qukan_requestUrl = [NSString stringWithFormat:@"%@&token=Bearer_%@&number=%@", Qukan_requestUrl, authorization, md5Key];
//        self.Qukan_requestUrl = Qukan_requestUrl;
//    }
//
//    [self.Qukan_myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.Qukan_requestUrl?:@""]]];
//}
//- (void)Qukan_submissionStatistics {
//    NSString *url = [NSString stringWithFormat:@"v3/recommends/%ld/views", self.Qukan_recommendId];
//    [QukanNetworkTool Qukan_POST:url parameters:@{@"recommend_id":[NSNumber numberWithInteger:self.Qukan_recommendId]} success:nil failure:nil];
//}
- (void)Qukan_setNavBarButtonItem {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn addTarget:self action:@selector(Qukan_leftBarButtonItemClick) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"Qukan_dismiss_icon"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0.0, 0.0, 60.0, 44.0);
    btn.imageEdgeInsets = UIEdgeInsetsMake(0.0, -17.0, 0.0, 17.0);
    btn.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = backItem;
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [rightBtn addTarget:self action:@selector(Qukan_rightBarButtonItemClick) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setImage:[UIImage imageNamed:@"Qukan_Safari"] forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(0.0, 0.0, 60.0, 44.0);
    rightBtn.imageEdgeInsets = UIEdgeInsetsMake(0.0, 17.0, 0.0, -17.0);
    rightBtn.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}
- (void)Qukan_leftBarButtonItemClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)Qukan_rightBarButtonItemClick {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.Qukan_requestUrl]];
}
- (void)Qukan_netWorkClickRetry {
    [QukanFailureView Qukan_hideWithView:self.view];
    [self.Qukan_myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.Qukan_requestUrl?:@""]]];
}
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
}
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
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
//- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
//    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
//        if ([challenge previousFailureCount] == 0) {
//            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
//            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
//        } else {
//            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
//        }
//    } else {
//        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
//    }
//}
//- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
//    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        completionHandler();
//    }])];
//    [self presentViewController:alertController animated:YES completion:nil];
//}
//- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
//    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        completionHandler(NO);
//    }])];
//    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        completionHandler(YES);
//    }])];
//    [self presentViewController:alertController animated:YES completion:nil];
//}
//- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
//    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//        textField.text = defaultText;
//    }];
//    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        completionHandler(alertController.textFields[0].text?:@"");
//    }])];
//    [self presentViewController:alertController animated:YES completion:nil];
//}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress>=0.6) {
            [MBProgressHUD hideHUDForView:self.view animated:NO];
        }
    }
}

#pragma mark - 评论相关
@end
