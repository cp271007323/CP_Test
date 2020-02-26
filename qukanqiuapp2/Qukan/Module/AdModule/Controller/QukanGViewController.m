//
//  QukanGViewController.m
//  Qukan
//
//  Created by Kody on 2019/8/9.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanGViewController.h"
#import <WebKit/WebKit.h>
#import <UIViewController+HBD.h>
#import <WebViewJavascriptBridge/WebViewJavascriptBridge.h>
#import "QukanShareCenterViewController.h"
#import "NSObject+WMSafeKVO.h"

@interface QukanGViewController ()<WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler>

@property(nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) WebViewJavascriptBridge     *webViewJB;//桥接
@property(nonatomic, strong) UIProgressView *myProgressView;

@end

@implementation QukanGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.hbd_barTintColor = kThemeColor;
    self.hbd_tintColor = [UIColor whiteColor];
    self.hbd_titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont boldSystemFontOfSize:17]};
    
    if (self.isPresentPush) {
        [self addBackButton];
    }
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) configuration:configuration];
    _webView.navigationDelegate = self;
    _webView.opaque = NO;
    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_webView];
    [self.view addSubview:self.myProgressView];
    
    NSURLRequest* p= nil;
    if (![_url localizedCaseInsensitiveContainsString:@"http"] && ![_url localizedCaseInsensitiveContainsString:@"www"]) {
        p = [[NSURLRequest alloc] initWithURL:[NSURL fileURLWithPath:_url]];
        [_webView loadFileURL:[NSURL fileURLWithPath:_url] allowingReadAccessToURL:[NSURL fileURLWithPath:_url]];
    }else{
        if ([_url hasPrefix:@"www."]) {
            _url = [NSString stringWithFormat:@"http://%@",_url];
        }
        //        _url = [_url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        p = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:_url]];
        if (!p.URL) {
            p = [[NSURLRequest alloc] initWithURL:[NSURL fileURLWithPath:_url]];
        }
        [_webView loadRequest:p];
    }
    
    [_webView wm_addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:NSKeyValueObservingOptionOld| NSKeyValueObservingOptionNew context:nil];
    [_webView wm_addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:NULL];
    
    [self setwebViewJB];
}


- (void)setwebViewJB {
    @weakify(self)
    // 开启日志
    [WebViewJavascriptBridge enableLogging];
    self.webViewJB = [WebViewJavascriptBridge bridgeForWebView:self.webView];
    [self.webViewJB setWebViewDelegate:self];
    
    [self.webViewJB registerHandler:@"toActivity" handler:^(id data, WVJBResponseCallback responseCallback) {
        @strongify(self)
        if (!kUserManager.isLogin) {
            kGuardLogin;
        }
        QukanShareCenterViewController *vc = [[QukanShareCenterViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
}

- (void)addBackButton {
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn addTarget:self
                action:@selector(JiuAi_leftBarButtonItemClick)
      forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setTitleColor:kCommonWhiteColor
                  forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(0.0, 0.0, 50.0, 44.0);
    leftBtn.titleEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    [leftBtn setImage:kImageNamed(@"JiuAi_Play_Back") forState:UIControlStateNormal];
    leftBtn.titleLabel.font = kFont13;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)JiuAi_leftBarButtonItemClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - getter and setter
- (UIProgressView *)myProgressView {
    if (_myProgressView == nil) {
        _myProgressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, kTopBarHeight+1, [UIScreen mainScreen].bounds.size.width, 0)];
        _myProgressView.tintColor = RGBA(45, 169, 38, 0.6);
        _myProgressView.trackTintColor = [UIColor whiteColor];
        _myProgressView.progress = 0.1;
    }
    
    return _myProgressView;
}

#pragma mark KVO的监听代理
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    //网页title
    if ([keyPath isEqualToString:@"title"]) {
        NSString *theTitle = self.webView.title;
        if (theTitle.length > 20) {
            theTitle = [theTitle substringToIndex:18];
            theTitle = [NSString stringWithFormat:@"%@...", theTitle];
        }
        if (theTitle.length) {
            self.title = theTitle;
        }
    }else if ([keyPath isEqualToString:@"estimatedProgress"] && object == self.webView) {
        
        DEBUGLog(@"old----------%.1f", [[change objectForKey:NSKeyValueChangeNewKey] doubleValue]);
        DEBUGLog(@"new----------%.1f",[[change objectForKey:NSKeyValueChangeOldKey] doubleValue]);
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if ([[change objectForKey:NSKeyValueChangeNewKey] doubleValue] <= [[change objectForKey:NSKeyValueChangeOldKey] doubleValue]) {
            return;
        }
        
        self.myProgressView.alpha = 1.0f;
        [self.myProgressView setProgress:newprogress animated:YES];
        if (newprogress >= 1.0f) {
            [UIView animateWithDuration:0.3f
                                  delay:0.3f
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 self.myProgressView.alpha = 0.0f;
                             }
                             completion:^(BOOL finished) {
                                 [self.myProgressView setProgress:0 animated:NO];
                             }];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - WKWebView

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self.view dismissHUD];
    
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    DEBUGLog(@"%@", error);
    [self.view dismissHUD];
    [self.view showTip:@"加载失败，请稍后再试"];
}

- (void)webView:(WKWebView*)webView decidePolicyForNavigationAction:(WKNavigationAction*)navigationAction decisionHandler:(void(^)(WKNavigationActionPolicy))decisionHandler {
    
    WKNavigationActionPolicy policy = WKNavigationActionPolicyAllow;
    
    if([[navigationAction.request.URL host] isEqualToString:@"--"] && [[UIApplication sharedApplication] openURL:navigationAction.request.URL]){
        policy = WKNavigationActionPolicyCancel;
    }
    
    decisionHandler(policy);
}



#pragma mark -
- (void)dealloc {
    [self.webView wm_removeObserver:self forKeyPath:@"title"];
    [self.webView wm_removeObserver:self forKeyPath:@"estimatedProgress"];
    
//    [self.webView removeObserver:self forKeyPath:@"title"];
//    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    DEBUGLog("dealloc");
    [kNotificationCenter postNotificationName:Qukan_webDealloc object:nil];
}




@end
