//
//  QukanShareCenterViewController.m
//  Qukan
//
//  Created by Kody on 2019/8/26.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanShareCenterViewController.h"
#import <WebKit/WebKit.h>
#import <WebViewJavascriptBridge/WebViewJavascriptBridge.h>
#import "QukanApiManager+News.h"
#import "QukanApiManager+PersonCenter.h"

#import "QukanNullDataView.h"
//#import "QukanHHWaitingHudView.h"

#import "YYShareView.h"
#import <AdSupport/AdSupport.h>
#import <Photos/Photos.h>

@interface QukanShareCenterViewController ()<WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong) WKWebView                   *wkWebView;
@property (nonatomic, strong) WebViewJavascriptBridge     *webViewJB;
@property (nonatomic, strong) UIProgressView              *webProgressView;

@property(nonatomic, copy) NSString *text;
@property(nonatomic, copy) NSString *shareUrl;

//@property(nonatomic, copy) NSString *allUrlStr;

@property(nonatomic, assign) BOOL   isUse;

@end

@implementation QukanShareCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self interFace];
    if (!self.webUrl) {
        [self Qukan_loadWebView];
    } else {
        [self initTheWebView];
    }
}

- (void)interFace {
    self.view.backgroundColor = [UIColor whiteColor];
    self.wkWebView.backgroundColor = [UIColor whiteColor];
    self.isUse = YES;
}

- (void)initTheWebView {
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]]];
    [self.view addSubview:self.webProgressView];
    [self layoutWebView];
}

- (void)dealloc {

}

- (void)layoutWebView {
    @weakify(self)
//    // 开启日志
//    [WebViewJavascriptBridge enableLogging];
    self.webViewJB = [WebViewJavascriptBridge bridgeForWebView:self.wkWebView];
    [self.webViewJB setWebViewDelegate:self];
    
    // 网页按钮点击
    [self.webViewJB registerHandler:@"getParams" handler:^(id data, WVJBResponseCallback responseCallback) {
        @strongify(self)
        DEBUGLog(@"%@",data);
        NSString *lastStr = [self noWhiteSpaceStringWithStr:[self showAlertWith:@{}]];
        responseCallback(lastStr);
    }];
    
    [self.webViewJB registerHandler:@"getYQ" handler:^(id data, WVJBResponseCallback responseCallback) {
        @strongify(self)
        DEBUGLog(@"%@",data);
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:@(kUserManager.user.userId) forKey:@"id"];
        NSString *lastStr = [self noWhiteSpaceStringWithStr:[self showAlertWith:dict]];
        responseCallback(lastStr);
    }];
    
    [self.webViewJB registerHandler:@"getTodayRed" handler:^(id data, WVJBResponseCallback responseCallback) {
        @strongify(self)
        NSDictionary *dataDict = (NSDictionary *)data;
        if (!dataDict.allKeys.count || dataDict == nil) {return ;}
        double todayRed = [dataDict doubleValueForKey:FormatString(@"%@Number", kGetImageType(20)) default:0.0];
        long taskRecordId = [dataDict longValueForKey:FormatString(@"%@RecordId", kGetImageType(20)) default:0];
        NSDictionary *parameters =  @{@"todayRed":@(todayRed),
                                      FormatString(@"%@RecordId", kGetImageType(20)):@(taskRecordId)};
        NSString *lastStr = [self noWhiteSpaceStringWithStr:[self showAlertWith:parameters]];
        responseCallback(lastStr);
    }];
    
    [self.webViewJB registerHandler:@"getEQ" handler:^(id data, WVJBResponseCallback responseCallback) {
        @strongify(self)
        DEBUGLog(@"%@",data);
        NSDictionary *dataDict = (NSDictionary *)data;
        if (!dataDict.allKeys.count || dataDict == nil) {return ;}
        NSString *url = (NSString *)[dataDict stringValueForKey:@"url" default:@""];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:url forKey:@"url"];
        NSString *lastStr = [self noWhiteSpaceStringWithStr:[self showAlertWith:dict]];
        responseCallback(lastStr);
    }];
    
    [self.webViewJB registerHandler:@"saveImage" handler:^(id data, WVJBResponseCallback responseCallback) {
        @strongify(self)
        NSDictionary *dataDict = (NSDictionary *)data;
        if (!dataDict.allKeys.count || dataDict == nil) {return ;}
        BOOL isPhotoAuthor = [self getPhotoAuthor];
        if (isPhotoAuthor == NO) { return;}
        long toImgflag = [dataDict longValueForKey:@"toImgflag" default:0];
        NSString *htmlUrl = dataDict[@"htmlUrl"];
        htmlUrl = htmlUrl.length > 22 ? [htmlUrl substringFromIndex:22] : htmlUrl;
        UIImage *codeImage = [self stringChangeToImage:htmlUrl];
        if (codeImage && toImgflag == 1) {
            UIImageWriteToSavedPhotosAlbum(codeImage, nil, nil, NULL);
            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
        } else {
            if (self.isUse && codeImage) {
                self.isUse = NO;
                [self contentShareWithImage:codeImage WithText:self.text];
            }
        }
    }];
    
    [self.webViewJB registerHandler:@"contentShare" handler:^(id data, WVJBResponseCallback responseCallback) {
        @strongify(self)
        NSDictionary *dataDict = (NSDictionary *)data;
        if (!dataDict.allKeys.count || dataDict == nil) {return ;}
        NSString *text = [dataDict stringValueForKey:@"text" default:@""];
        NSString *shareUrl = [dataDict stringValueForKey:@"url" default:@""];
        self.text = text;
        self.shareUrl = shareUrl;
    }];
        
    [self.webViewJB registerHandler:@"toActivity" handler:^(id data, WVJBResponseCallback responseCallback) {
           @strongify(self)
           if (!kUserManager.isLogin) {
               kGuardLogin;
           }
           QukanShareCenterViewController *vc = [[QukanShareCenterViewController alloc] init];
           [self.navigationController pushViewController:vc animated:YES];
    }];
}


#pragma mark ===================== PhotoAuthor ==================================

- (BOOL)getPhotoAuthor {
    //检查设备是否支持
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] || [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        
        PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
        if (authStatus == PHAuthorizationStatusNotDetermined) {   //未授权
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
                    
                } else if (status == PHAuthorizationStatusDenied) {
                    
                } else if (status == PHAuthorizationStatusRestricted) {
                    
                }
            }];
            return NO;
        } else if (authStatus == PHAuthorizationStatusAuthorized) {
            return YES;
        } else if (authStatus == PHAuthorizationStatusDenied) {
            [SVProgressHUD showErrorWithStatus:@"没有相册权限，请前往设置"];
            return NO;
        } else if (authStatus == PHAuthorizationStatusRestricted) {
            return YES;
        }
    } else {
        return NO;
    }
    return YES;
}


#pragma mark ===================== NetWork ==================================

- (void)Qukan_loadWebView {
    @weakify(self)
    [[[kApiManager QukanAppGetConfig] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        NSDictionary *xDict = (NSDictionary *)x;
        if (!xDict.allKeys.count) {[self showEmptyView];return ;}
        NSDictionary *invite_friend = [[xDict objectForKey:@"invite_friend"] isKindOfClass:[NSDictionary class]] ? [xDict objectForKey:@"invite_friend"] : nil;
        NSDictionary *share_url = [[invite_friend objectForKey:@"share_url"] isKindOfClass:[NSDictionary class]] ? [invite_friend objectForKey:@"share_url"] : nil;
        self.webUrl = [share_url stringValueForKey:@"name" default:@""];
        self.webUrl ? [self initTheWebView] : [self showEmptyView];
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        [self showEmptyView];
    }];
}

//- (void)Qukan_parmGetSigWithCodeImage:(UIImage *)codeImage WithText:(NSString *)text {
//    @weakify(self)
//    [[[kApiManager QukanParmGetSig] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
//        @strongify(self)
//        DEBUGLog(@"---%@",x);
//        [self contentShareWithImage:codeImage WithText:self.text WithData:(NSString *)x];
//    } error:^(NSError * _Nullable error) {
//        @strongify(self)
//        KHideHUD
//        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
//        self.isUse = YES;
//    }];
//}

#pragma mark ===================== Actions ============================

- (void)contentShareWithImage:(UIImage *)codeImage WithText:(NSString *)text{
//    @weakify(self)
    YYShareView *shareView = [[YYShareView alloc] initWithFrame:UIScreen.mainScreen.bounds clickblock:^(YYShareViewItemType type) {
//        @strongify(self)
        if (codeImage == nil || text == nil) {return ;};
        //复制文本
        UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
        pastboard.string = text;
        NSInteger shareType = type;
        [kUMShareManager Qukan_ShareImageAndTextToPlatformType:shareType addTitle:text addThumImage:codeImage addShareImageStr:nil];
    }];
    [shareView show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isUse = YES;
    });
}

#pragma mark ===================== NetWork ==================================


//#pragma mark ===================== NetWKScriptMessageHandlerWork ==================================
//
////实现js注入方法的协议方法
//- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
//    DEBUGLog("%@",message.body);
//}

#pragma mark ===================== WkWebViewDelegate ==================================

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
//     [self showWaitHud:WaitHudModeCircle];
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    KHideHUD
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [MBProgressHUD hideHUDForView:self.view animated:NO];
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

#pragma mark ===================== Public Methods =======================

- (NSString *)showAlertWith:(NSDictionary *)parameters {
    NSString *authorizationToken = kUserManager.user.token ? kUserManager.user.token : @"";
    NSData *encodData = [[parameters jsonStringEncoded] dataUsingEncoding:NSUTF8StringEncoding];
    NSString *paramersBase64 = [encodData base64EncodedStringWithOptions:0];
    if (!parameters) {parameters = @{};}
    NSString *secretKey = @"LfP2A0XgAzc4Epxf6pbTAoHNMnEu3Ix0";
    NSString *toKen = authorizationToken;
    if (authorizationToken.length!=0) {
        secretKey = kUserManager.user.key?:@"";
        toKen = [NSString stringWithFormat:@"%@", authorizationToken];
    }
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *bundleIdentifier = [infoDictionary objectForKey:@"CFBundleIdentifier"];
    
    NSMutableDictionary *common = @{}.mutableCopy;
    [common setObject:bundleIdentifier forKey:@"appPac"];
    [common setObject:@2 forKey:@"deviceType"];
    [common setObject:app_Version forKey:@"versionCode"];
//    [common setObject:[FCUUID uuidForDevice] forKey:@"devicenId"];
    
    NSString *deviceId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    [common setObject:deviceId forKey:@"devicenId"];
    [common setObject:Qukan_UMWeChatAppKey forKey:@"wechatOpenId"];
    [common setObject:kAppManager.Qukan_channel forKey:@"channelId"];
    
    NSString *commonParamJson = [common jsonStringEncoded];
    NSString *commonBase64String = [commonParamJson base64EncodedString];
    
    NSString *md5EncodedString = [NSString stringWithFormat:@"%@%@%@", paramersBase64, secretKey, commonBase64String];
    NSString *signString = [md5EncodedString md5String];
    NSDictionary *bodyDataDict = @{@"object":paramersBase64, @"sign":signString, @"common" : commonBase64String};
    NSMutableDictionary *JSdict = [NSMutableDictionary dictionary];
    
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:bodyDataDict options:NSJSONWritingPrettyPrinted error:&parseError];
    
    NSString *bodyDataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *bodyDataLastStr = [self noWhiteSpaceStringWithStr:bodyDataStr];
    
    [JSdict setObject:bodyDataLastStr forKey:@"data"];
    [JSdict setObject:secretKey forKey:@"privateKey"];
    [JSdict setObject:toKen forKey:@"token"];
    NSData *data = [NSJSONSerialization dataWithJSONObject:JSdict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *paraStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString *paraLastStr = [self noWhiteSpaceStringWithStr:paraStr];
    return paraLastStr;
}

- (NSString *)noWhiteSpaceStringWithStr:(NSString *)oldString {
    //去除掉首尾的空白字符和换行字符
    NSString *newString;
    newString = [oldString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    newString = [oldString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    newString = [oldString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符使用
    newString = [oldString stringByReplacingOccurrencesOfString:@" " withString:@""];
    //    可以去掉空格，注意此时生成的strUrl是autorelease属性的，所以不必对strUrl进行release操作！
    return newString;
}

//- (NSString *)showAlertWith:(NSDictionary *)dictionary{
//    //自定义
//    NSString *jsonStr = @"{";
//    NSArray * keys = [dictionary allKeys];
//    for (NSString * key in keys) {
//        jsonStr = [NSString stringWithFormat:@"%@\"%@\":\"%@\",",jsonStr,key,[dictionary objectForKey:key]];
//    }
//    jsonStr = [NSString stringWithFormat:@"%@%@",[jsonStr substringWithRange:NSMakeRange(0, jsonStr.length-1)],@"}"];
//    return jsonStr;
//}

- (UIImage *)stringChangeToImage:(NSString *)str {
    NSData * imageData =[[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *photo = [UIImage imageWithData:imageData];
    return photo;
}

- (void)showEmptyView {
    [QukanNullDataView Qukan_showWithView:self.view
                         contentImageView:@"Qukan_Null_Data"
                                  content:@"暂无数据"];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark ===================== Getters =================================

- (WKWebView *)wkWebView {
    if (!_wkWebView) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.preferences = [[WKPreferences alloc] init];
        config.preferences.minimumFontSize = 10;
        config.preferences.javaScriptEnabled = YES;
        config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        config.userContentController = [[WKUserContentController alloc] init];
        config.processPool = [[WKProcessPool alloc] init];
        
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
        _wkWebView.backgroundColor = [UIColor whiteColor];
        _wkWebView.UIDelegate = self;
        _wkWebView.navigationDelegate = self;
        _wkWebView.scrollView.bounces = NO;
        [self.view addSubview:_wkWebView];
        [_wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self.view);
        }];
        
        
        @weakify(self);
        [[[_wkWebView rac_valuesForKeyPath:@"estimatedProgress" observer:self] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            NSNumber *p = x;
            [self setProgressVWithProgress:p.floatValue];
        }];
        
        
        [[[_wkWebView rac_valuesForKeyPath:@"title" observer:self] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            NSString *title = x;
            self.title = title;
        }];
    }
    return _wkWebView;
}


// 动画直播监听进度条的进度
- (void)setProgressVWithProgress:(CGFloat)progress {
    self.webProgressView.progress = progress;
    self.webProgressView.hidden = (progress == 1);
}



- (UIProgressView *)webProgressView {
    if (!_webProgressView) {
        _webProgressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, kTopBarHeight + 1, kScreenWidth, 0)];
        _webProgressView.tintColor = kThemeColor;
        _webProgressView.trackTintColor = [UIColor whiteColor];
        _webProgressView.progress = 0.1;
    }
    return _webProgressView;
}

@end
