//
//  QukanDetalisHeaderView.m
//  Qukan
//
//  Created by Kody on 2019/7/17.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanNewsDetalisHeaderView.h"
#import "QukanApiManager+News.h"
#import "NSObject+WMSafeKVO.h"

@interface QukanNewsDetalisHeaderView ()<WKNavigationDelegate, WKUIDelegate,UIScrollViewDelegate>

@property(nonatomic, strong) QukanNewsModel  *model;
@property(nonatomic, strong) UIView  *likeBtnCover;  //覆盖btn 不能点击

@end

@implementation QukanNewsDetalisHeaderView

- (instancetype)initWithFrame:(CGRect)frame withDict:(QukanNewsModel *)model{
    self = [super initWithFrame:frame];
    self.userInteractionEnabled = YES;
    self.model = model;
    [self addSubviews];
    return self;
}

- (void)addSubviews {
    [self addSubview:self.Qukan_progressView];
    [self.Qukan_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.offset(0);
        make.top.offset(1);
    }];
    
    [self addSubview:self.explodeView];
    [self.explodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.offset(16);
        make.width.offset(208);
        make.height.offset(36);
    }];
    
    [self.explodeView addSubview:self.explode_imageView];
    [self.explode_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.explodeView);
    }];
    
    [self.explodeView addSubview:self.league_label];
    [self.league_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.bottom.offset(0);
    }];
    
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.mas_equalTo(self.explodeView.mas_bottom).offset(10);
    }];
    
    [self addSubview:self.readNumber_label];
    [self.readNumber_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(5);

        make.left.mas_equalTo(self.titleLabel);
    }];
    
    [self addSubview:self.time_label];
    [self.time_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerY.mas_equalTo(self.readNumber_label);
        make.right.offset(-15);
    }];
    
    [self addSubview:self.newsImagesView];
    [self.newsImagesView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.centerX.mas_equalTo(self);
       make.top.equalTo(self.readNumber_label.mas_bottom).offset(5);
       make.width.mas_equalTo(kScreenWidth-30);
        make.height.mas_equalTo((kScreenWidth - 20) * 0.6);
    }];
    
    [self addSubview:self.Qukan_NewsWebView];
    [self.Qukan_NewsWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.readNumber_label.mas_bottom).offset(5);
        make.right.left.offset(0);
    }];
    
    [self Qukan_SetNewsHeaderWith:self.model];
}

#pragma mark ===================== Public Methods =======================

- (void)Qukan_SetNewsHeaderWith:(QukanNewsModel *__nullable)model {
    self.league_label.text = FormatString(@"#%@#",model.leagueName);
    self.titleLabel.text = model.title;
//    self.dataSource_label.text = model.source;
    self.readNumber_label.text = FormatString(@"%ld阅读",model.readNum);
    self.time_label.text = model.pubTimeBefore;
//    self.
    //    //重新定位
    [self againLocation];
}

#pragma mark ===================== Other Methods =======================

- (CGFloat)Qukan_SetSizeToFitWith:(UILabel *)label addSelfWidth:(CGFloat)selfWidth {
    [label sizeToFit];
    CGSize size = [label sizeThatFits:CGSizeMake(kScreenWidth - 40, MAXFLOAT)];
    return size.height;
}

- (void)againLocation {
    _webUrlStr = self.model.newsContent;
    self.Qukan_NewsWebView.alpha = 0;
    
    if (self.model.imageUrl.length > 0 && self.model.imageUrl != nil) {
        [self.newsImagesView sd_setImageWithURL:[NSURL URLWithString:self.model.imageUrl] placeholderImage:kImageNamed(@"Mengma_placeholder")];
        self.newsImagesView.frame = CGRectMake(10, self.titleLabel.bottom + 10, kScreenWidth - 20, (kScreenWidth - 20) * 0.6);
        [self.newsImagesView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.top.equalTo(self.readNumber_label.mas_bottom).offset(5);
            make.width.mas_equalTo(kScreenWidth-30);
            make.height.mas_equalTo((kScreenWidth - 20) * 0.6);
        }];
    } else {
        [self.newsImagesView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
            make.width.mas_equalTo(kScreenWidth-30);
            make.height.mas_equalTo(0);
        }];
    }
    
    NSString *lastStyleStr = [self htmlWithStyle];
    [self.Qukan_NewsWebView loadHTMLString:lastStyleStr baseURL:nil];
}

- (NSString *)htmlWithStyle {
//    NSString *divStr = [NSString stringWithFormat:@"<div style=\"margin:%dpx;border:10;padding:0;display:block;\"></div>",10];
    NSString *htmlString = [NSString stringWithFormat:@"<html> \n"
                            "<head> \n"
                            "<style type=\"text/css\"> \n"
                            "body {font-size:18px;}\n"
                            "</style> \n"
                            "</head> \n"
                            "<body>"
                            "<script type='text/javascript'>"
                            "window.onload = function(){\n"
                            "var $img = document.getElementsByTagName('img');\n"
                            "for(var p in  $img){\n"
                            " $img[p].style.width = '100%%';\n"
                            "$img[p].style.height ='auto'\n"
                            "}\n"
                            "}"
                            "</script>%@"
                            "</body>"
                            "</html>", _webUrlStr];
//    NSString *styleStr = [NSString stringWithFormat:@"<style> .mobile_upload {width:%fpx;height:auto;} </style><style> .emot {width:%fpx;height:%fpx;overflow:hidden;} img{max-width:%fpx;margin:10fpx  0;display:inline-block;} </style><div style=\"word-wrap:break-word;border-top:0px solid #999;padding-top:0px; width:%fpx;\"><font style=\"font-size:%fpx;color:#727272;\">",kScreenWidth - 10 * 2,12.0,12.0,kScreenWidth - 2 * 10,kScreenWidth - 10 * 2,14.0];
//    NSString *lastStyleStr = [NSString stringWithFormat:@"%@%@%@</font></div>",divStr,styleStr,_webUrlStr];
    return htmlString;
}

- (void)selfWebReload:(WKWebView *)webView {
    self.Qukan_NewsWebView.alpha = 1;
    [self addSubview:self.likesButton];
    
    CGFloat webHigth = webView.scrollView.contentSize.height;
    [self.Qukan_NewsWebView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.newsImagesView.mas_bottom);
        make.height.offset(webHigth);
        make.left.right.offset(0);
    }];
    self.QukanNews_GetHightBlock(webHigth + self.newsImagesView.bottom);
}

#pragma mark ===================== WKWebViewDelegate =======================
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [MBProgressHUD hideHUDForView:self animated:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self selfWebReload:webView];
    });
    
    NSString *injectionJSString = @"var script = document.createElement('meta');"
    "script.name = 'viewport';"
    "script.content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    [_Qukan_NewsWebView evaluateJavaScript:injectionJSString completionHandler:nil];
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [MBProgressHUD hideHUDForView:self animated:NO];
    @weakify(self)
    [QukanFailureView Qukan_showWithView:self centerY:-180.0 block:^{
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

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return nil;
}

- (void)dealloc {
//    [self.Qukan_NewsWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.Qukan_NewsWebView wm_removeObserver:self forKeyPath:@"estimatedProgress"];
}

#pragma mark ===================== KVO监听 ==================================
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"] && object == self.Qukan_NewsWebView) {
        
        DEBUGLog(@"old----------%.1f", [[change objectForKey:NSKeyValueChangeNewKey] doubleValue]);
        DEBUGLog(@"new----------%.1f",[[change objectForKey:NSKeyValueChangeOldKey] doubleValue]);
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if ([[change objectForKey:NSKeyValueChangeNewKey] doubleValue] <= [[change objectForKey:NSKeyValueChangeOldKey] doubleValue]) {
            return;
        }
        
        self.Qukan_progressView.alpha = 1.0f;
        [self.Qukan_progressView setProgress:newprogress animated:YES];
        if (newprogress >= 1.0f) {
            [UIView animateWithDuration:0.3f
                                  delay:0.3f
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 self.Qukan_progressView.alpha = 0.0f;
                             }
                             completion:^(BOOL finished) {
                                 [self.Qukan_progressView setProgress:0 animated:NO];
                             }];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark ===================== Actions ============================
- (void)likeButtonCilck {
    kGuardLogin
    self.likeBtnCover.hidden = NO;
    if (self.model.isLike == 1) {
        [self Qukan_NewsSwitchLikeWithType:2];
    } else if (self.model.isLike == 2) {
        [self Qukan_NewsSwitchLikeWithType:1];
    }

}

#pragma mark ===================== NetWork ==================================
- (void)Qukan_NewsSwitchLikeWithType:(NSInteger)type {
    @weakify(self)
    [[[kApiManager QukannewsSwitchLikeWithNewsId:self.model.nid addType:type] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        NSString *title = [NSString stringWithFormat:@" 赞%ld",self.model.likeNum];
        if (type == 1) {
            title = [NSString stringWithFormat:@" 赞%ld",self.model.likeNum + 1];
        } else {
            title = [NSString stringWithFormat:@" 赞%ld",self.model.likeNum - 1];

        }
        self.likeNumberLabel.text = title ;
        if (type == 1) {
            self.model.isLike = 1;
            self.model.likeNum = self.model.likeNum + 1;
        } else if (type == 2) {
            self.model.isLike = 2;
            self.model.likeNum = self.model.likeNum - 1;
        }
        self.likeBtnCover.hidden = YES;
            self.likesButton.selected = self.model.isLike == 1;

    } error:^(NSError * _Nullable error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        self.likeBtnCover.hidden = YES;

    }];
}


- (void)Qukan_netWorkClickRetry {
    [QukanFailureView Qukan_hideWithView:self];
    [self.Qukan_NewsWebView loadHTMLString:_webUrlStr?:@"" baseURL:nil];
}

#pragma mark ===================== Getters =================================

- (UIView *)explodeView {
    if (!_explodeView) {
        _explodeView = [[UIView alloc] initWithFrame:CGRectZero];
        _explodeView.backgroundColor = kCommonWhiteColor;
    }
    return _explodeView;
}

- (UIImageView *)explode_imageView {
    if (!_explode_imageView) {
        _explode_imageView = UIImageView.new;
        _explode_imageView.image = kImageNamed(@"Qukan_exPot_icon");
        _explode_imageView.contentMode = 2;
        _explode_imageView.clipsToBounds = YES;
    }
    return _explode_imageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont boldSystemFontOfSize:26];
        _titleLabel.textColor = kCommonTextColor;
    }
    return _titleLabel;
}

- (UIImageView *)publishHeaderImageView {
    if (!_publishHeaderImageView) {
        _publishHeaderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.titleLabel.frame) + 10, 30, 30)];
    }
    return _publishHeaderImageView;
}

- (UIButton *)attentionButton {
    if (!_attentionButton) {
        _attentionButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 90, CGRectGetMaxY(self.titleLabel.frame) + 10, 50, 30)];
        _attentionButton.titleLabel.font = kFont14;
        _attentionButton.backgroundColor = kThemeColor;
    }
    return _attentionButton;
}

- (UILabel *)publishTextLabel {
    if (!_publishTextLabel) {
        _publishTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.publishHeaderImageView.frame) + 10, kScreenWidth - 20, 20)];
        _publishTextLabel.numberOfLines = 0;
    }
    return _publishTextLabel;
}

- (UIImageView *)newsImagesView {
    if (!_newsImagesView) {
        _newsImagesView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame), kScreenWidth - 40, 100)];
    }
    return _newsImagesView;
}

- (WKWebView *)Qukan_NewsWebView {
    if (!_Qukan_NewsWebView) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.preferences = [[WKPreferences alloc] init];
        config.preferences.minimumFontSize = 10;
        config.preferences.javaScriptEnabled = YES;
        config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        config.userContentController = [[WKUserContentController alloc] init];
        config.processPool = [[WKProcessPool alloc] init];
        _Qukan_NewsWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame) + 10, kScreenWidth, 10) configuration:config];
        _Qukan_NewsWebView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _Qukan_NewsWebView.UIDelegate = self;
        _Qukan_NewsWebView.navigationDelegate = self;
        _Qukan_NewsWebView.scrollView.bounces = NO;
        _Qukan_NewsWebView.scrollView.scrollEnabled = NO;
        _Qukan_NewsWebView.scrollView.delegate = self;
        [self addSubview:_Qukan_NewsWebView];
        
        NSString *jSString = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        //用于进行JavaScript注入
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        [config.userContentController addUserScript:wkUScript];
        
        [_Qukan_NewsWebView wm_addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionOld| NSKeyValueObservingOptionNew context:NULL];
//        [_Qukan_NewsWebView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:NSKeyValueObservingOptionOld| NSKeyValueObservingOptionNew context:nil];
    }
    return _Qukan_NewsWebView;
}

- (UIProgressView *)Qukan_progressView {
    if (!_Qukan_progressView) {
        _Qukan_progressView = [[UIProgressView alloc] initWithFrame:CGRectZero];
        _Qukan_progressView.tintColor = kThemeColor;
        _Qukan_progressView.trackTintColor = [UIColor whiteColor];
        _Qukan_progressView.progress = 0.1;
        [_Qukan_NewsWebView addSubview:_Qukan_progressView];
    }
    return _Qukan_progressView;
}

//static CGAffineTransform affineTransformMakeShear(CGFloat xShear, CGFloat yShear) {
//    return CGAffineTransformMake(1, yShear, xShear, 1, 0, 0);
//}

- (UILabel *)league_label {
    if (!_league_label) {
        _league_label = UILabel.new;
        _league_label.textColor = kCommonTextColor;
        _league_label.font = [UIFont boldSystemFontOfSize:12];
    }
    return _league_label;
}

- (UILabel *)dataSource_label {
    if (!_dataSource_label) {
        _dataSource_label = UILabel.new;
        _dataSource_label.font = kFont12;
        _dataSource_label.textColor = kThemeColor;
    }
    return _dataSource_label;
}

- (UILabel *)readNumber_label {
    if (!_readNumber_label) {
        _readNumber_label = UILabel.new;
        _readNumber_label.textColor = kTextGrayColor;
        _readNumber_label.font = kFont14;
    }
    return _readNumber_label;
}

- (UILabel *)time_label {
    if (!_time_label) {
        _time_label = UILabel.new;
        _time_label.font = kFont14;
        _time_label.textColor = kTextGrayColor;
        _time_label.textAlignment = NSTextAlignmentRight;
    }
    return _time_label;
}

@end
