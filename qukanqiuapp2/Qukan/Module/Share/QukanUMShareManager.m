//
//  QukanShareManager.m
//  Qukan
//
//  Created by Kody on 2019/7/16.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

//#import "WXApi.h"
#import "QukanApiManager+PersonCenter.h"

#import "YYShareView.h"
#import "QukanShareView.h"

// 主模型
#import "QukanMatchInfoModel.h"
#import "QukanNewsModel.h"
#import "QukanBasketBallMatchDetailModel.h"

@interface QukanUMShareManager ()<UMSocialShareMenuViewDelegate>

// 横屏展示分享视图的view
@property(nonatomic, strong) QukanShareView   * view_landShare;
// 竖屏时展示分享视图的view
@property(nonatomic, strong) YYShareView      * view_portShare;
// 分享界面展示的主视图  一般横屏时有值 竖屏时为空
@property(nonatomic, strong) UIView   * view_shareContent;
@end

@implementation QukanUMShareManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static QukanUMShareManager *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}

#pragma mark ===================== 初始化分享 ==================================
- (void)Qukan_ShareSet {
    [UMConfigure setEncryptEnabled:YES];   //打开加密传输
    [UMConfigure setLogEnabled:YES];  //设置打开日志
    [UMConfigure initWithAppkey:Qukan_UMAppKey channel:kAppManager.Qukan_channel];  // 设置友盟appkey
    
    // 设置可分享的平台
    //微信
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:Qukan_UMWeChatAppKey appSecret:Qukan_UMWeChatAppSecretKey redirectURL:@"https://itunes.apple.com/cn/app/id?mt=8"];
//    [WXApi registerApp:Qukan_UMWeChatAppKey];
    [UMConfigure initWithAppkey:Qukan_UMWeChatAppKey channel:@"App Store"];
    
    //QQ
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:Qukan_UMQQAppKey appSecret:Qukan_UMQQAppSecretKey redirectURL:@"https://itunes.apple.com/cn/app/id?mt=8"];
    

    // 测试数据
    self.str_newsShareHttp = @"http://154.211.159.144/dist/news/dist/index.html";
    self.str_matchShareHttp = @"http://154.211.159.144/dist/news/dist/index.html";
//    self.str_matchShareHttp = @"";
//    self.str_newsShareHttp = @"";
}


#pragma mark ===================== network ==================================
// 如果APP启动时未获取到分享的配置  则重新获取分享配置
- (void)Qukan_regetAppConfigWithSuccessBlock:(void (^)(void))successBlock failBlock:(void(^)(void))errorBlock {
    [self.view_shareContent showHUD];
    [[[kApiManager QukanAppGetConfig] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        DEBUGLog(@"---%@",x);
        [self.view_shareContent dismissHUD];
        NSDictionary *xDict = (NSDictionary *)x;
        if (!xDict.allKeys.count) { [self.view_shareContent showTip:@"分享失败"]; return ;}
        NSDictionary *news_config = [[xDict objectForKey:@"news_config"] isKindOfClass:[NSDictionary class]] ? [xDict objectForKey:@"news_config"] : nil;
        NSDictionary *news_share_url = [[news_config objectForKey:@"share_url"] isKindOfClass:[NSDictionary class]] ? [news_config objectForKey:@"share_url"] : nil;
        NSString *newsShareUrl = [news_share_url stringValueForKey:@"name" default:@""];
        if (newsShareUrl.length > 0 && newsShareUrl != nil) {
            self.str_newsShareHttp = newsShareUrl;
        }
        
        NSDictionary *zq_match = [[xDict objectForKey:@"zq_match"] isKindOfClass:[NSDictionary class]] ? [xDict objectForKey:@"zq_match"] : nil;
        NSDictionary *match_share_url = [[zq_match objectForKey:@"share_url"] isKindOfClass:[NSDictionary class]] ? [zq_match objectForKey:@"share_url"] : nil;
        NSString *matchShareUrl = [match_share_url stringValueForKey:@"name" default:@""];
        if (matchShareUrl.length > 0 && matchShareUrl != nil) {
            self.str_matchShareHttp = matchShareUrl;
        }
        
        successBlock();
    } error:^(NSError * _Nullable error) {
        errorBlock();
        [self.view_shareContent showTip:error.localizedDescription];
    }];
}


#pragma mark ===================== function ==================================
// 分享弹出视图
- (void)Qukan_showShareViewWithMainModel:(id)mainModel Type:(shareScreenType)screenType superView:(nullable UIView *)superView{
    NSAssert(mainModel != nil, @"分享内容不能为空");
    
    self.view_shareContent = superView;
    
    // 是否没有比赛分享域名
    if ([self lookUpHaveHostWithModel:mainModel]) {
        @weakify(self);
        [self Qukan_regetAppConfigWithSuccessBlock:^{
            @strongify(self);
            if ([self lookUpHaveHostWithModel:mainModel]) {  // 若重新请求回来还是没有域名  则直接失败
                if (screenType == shareScreenTypeLand) {
                    [superView showTip:@"分享失败"];
                }else {
                    [kwindowLast showTip:@"分享失败"];
                }
                return ;
            }
            
            if (screenType == shareScreenTypeLand) {   // 如果是横屏时分享  弹出自定义分享视图
                [self Qukan_shareLandWithModel:mainModel superView:superView];
                return;
            }
            // 竖屏时分享  直接弹出yyshare
            [self Qukan_sharePortWithModel:mainModel];
        } failBlock:^{
            [SVProgressHUD showErrorWithStatus:@"分享失败"];
        }];
        return;
    }
    
    if (screenType == shareScreenTypeLand) {
        [self Qukan_shareLandWithModel:mainModel superView:superView];
        return;
    }
    
    [self Qukan_sharePortWithModel:mainModel];
}

// 检测是否有分享的域名
- (BOOL)lookUpHaveHostWithModel:(id)mainModel {
    BOOL havNoMatchHost = ([mainModel isKindOfClass:[QukanMatchInfoContentModel class]] || [mainModel isKindOfClass:[QukanBasketBallMatchDetailModel class]])&& self.str_matchShareHttp.length == 0;
    // 是否没有新闻分享域名
    BOOL havNoNewsHost = [mainModel isKindOfClass:[QukanNewsModel class]] && self.str_newsShareHttp.length == 0;
    
    return havNoNewsHost || havNoMatchHost;
}

// 横屏的时候分享
- (void)Qukan_shareLandWithModel:(id)mainModel superView:(UIView *)superView{
    if (self.view_landShare.superview) {  // 若已经加了  直接去掉  避免重复添加
        [self.view_landShare removeFromSuperview];
        self.view_landShare = nil;
    }
    
    // 初始化
    self.view_landShare = [[QukanShareView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    @weakify(self)
    self.view_landShare.shareTypeblock = ^(NSInteger type) {
        @strongify(self);
        if ([mainModel isKindOfClass:[QukanMatchInfoContentModel class]]) {  // 分享比赛
            QukanMatchInfoContentModel *currentModel = (QukanMatchInfoContentModel *)mainModel;
            [self Qukan_shareActionWithType:type ftBallmatchModel:currentModel];
        }
        
        if ([mainModel isKindOfClass:[QukanNewsModel class]]) {
            QukanNewsModel *currentModel = (QukanNewsModel *)mainModel;
            [self Qukan_shareActionWithType:type newsModel:currentModel];
        }
        
        if ([mainModel isKindOfClass:[QukanBasketBallMatchDetailModel class]]) {
            QukanBasketBallMatchDetailModel *currentModel = (QukanBasketBallMatchDetailModel *)mainModel;
            [self Qukan_shareActionWithType:type basketMatchModel:currentModel];
        }
    };
    
    [superView addSubview:self.view_landShare];
    return;
    
}

 //   竖屏分享
- (void)Qukan_sharePortWithModel:(id)mainModel {
    if (self.view_portShare.superview) {
        [self.view_portShare removeFromSuperview];
        self.view_portShare = nil;
    }
    
    @weakify(self)
    self.view_portShare = [[YYShareView alloc] initWithFrame:UIScreen.mainScreen.bounds clickblock:^(YYShareViewItemType type) {
        @strongify(self)
        if ([mainModel isKindOfClass:[QukanMatchInfoContentModel class]]) {
            QukanMatchInfoContentModel *currentModel = (QukanMatchInfoContentModel *)mainModel;
            [self Qukan_shareActionWithType:type ftBallmatchModel:currentModel];
        }
        
        if ([mainModel isKindOfClass:[QukanNewsModel class]]) {
            QukanNewsModel *currentModel = (QukanNewsModel *)mainModel;
            [self Qukan_shareActionWithType:type newsModel:currentModel];
        }
        
        if ([mainModel isKindOfClass:[QukanBasketBallMatchDetailModel class]]) {
            QukanBasketBallMatchDetailModel *currentModel = (QukanBasketBallMatchDetailModel *)mainModel;
            [self Qukan_shareActionWithType:type basketMatchModel:currentModel];
        }
        
    }];
    [self.view_portShare show];

}

/**足球比赛分享时分享事件*/
- (void)Qukan_shareActionWithType:(NSInteger)type ftBallmatchModel:(QukanMatchInfoContentModel *)currentModel {
    NSString *shareHttp = self.str_matchShareHttp;
    NSInteger intId = currentModel.match_id;
    NSString *shareUrl = [NSString stringWithFormat:@"%@?id=%ld&type=2&appkey=%@",shareHttp,intId,Qukan_OpeninstallKey];
    UIImage  *shareImage = kImageNamed(@"Qukan_login");
    NSString *shareTitle = [NSString stringWithFormat:@"%@  %@ VS %@", currentModel.league_name,currentModel.home_name,currentModel.away_name];
    NSString *shareDescr = [NSString stringWithFormat:@"%@",currentModel.start_time];
    NSInteger shareType = type;
    [kUMShareManager Qukan_ShareWebPageToPlatformType:shareType addTitle:shareTitle addThumbImage:shareImage addDescr:shareDescr addWebPageUrl:shareUrl WithSourceId:currentModel.match_id WithSourceType:3];
}

/**蓝球比赛分享时分享事件*/
- (void)Qukan_shareActionWithType:(NSInteger)type basketMatchModel:(QukanBasketBallMatchDetailModel *)currentModel {
    NSString *shareHttp = self.str_matchShareHttp;
    NSInteger intId = currentModel.matchId.integerValue;
    NSString *shareUrl = [NSString stringWithFormat:@"%@?id=%ld&type=3&appkey=%@",shareHttp,intId,Qukan_OpeninstallKey];
    UIImage  *shareImage = kImageNamed(@"Qukan_login");
    NSString *shareTitle = [NSString stringWithFormat:@"%@  %@ VS %@", currentModel.leagueName,currentModel.guestTeam,currentModel.homeTeam];
    NSString *shareDescr = [NSString stringWithFormat:@"%@",currentModel.startTime];
    NSInteger shareType = type;
    [kUMShareManager Qukan_ShareWebPageToPlatformType:shareType addTitle:shareTitle addThumbImage:shareImage addDescr:shareDescr addWebPageUrl:shareUrl WithSourceId:currentModel.matchId.integerValue WithSourceType:3];
}


/**新闻分享时分享事件*/
- (void)Qukan_shareActionWithType:(NSInteger)type newsModel:(QukanNewsModel *)currentModel {
    NSString *shareHttp = self.str_newsShareHttp;
    NSString *shareUrl = [NSString stringWithFormat:@"%@?id=%ld&type=1&appkey=%@",shareHttp,currentModel.nid,Qukan_OpeninstallKey];
    NSString  *shareImage =  currentModel.imageUrl;
    NSString *shareTitle = currentModel.title;
    NSString *shareDescr = @"体育爱好者的精神家园";
    NSInteger shareType = type;
    [kUMShareManager Qukan_ShareWebPageToPlatformType:shareType addTitle:shareTitle addThumbImage:shareImage addDescr:shareDescr addWebPageUrl:shareUrl WithSourceId:currentModel.nid WithSourceType:currentModel.newType];
}


#pragma mark ===================== ShareAction =======================
//分享网页
- (void)Qukan_ShareWebPageToPlatformType:(UMSocialPlatformType)platformType addTitle:(NSString *)title addThumbImage:( id)shareImage addDescr:(NSString *)descr addWebPageUrl:(NSString *)webPageUrl WithSourceId:(long)sourceId WithSourceType:(NSInteger)sourceType {
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:descr thumImage:shareImage];
    //设置网页地址
    shareObject.webpageUrl = webPageUrl;
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:error.userInfo[@"message"]];
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
            [self Qukan_userShareAddWithSourceId:sourceId WithSourceType:sourceType];
        }
    }];
}

//分享文本
- (void)Qukan_ShareTextToPlatformType:(UMSocialPlatformType)platformType addTitle:(NSString *)title{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //设置文本
    messageObject.text = title;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:error.userInfo[@"message"]];
        }else{
        }
    }];
}

//分享图文
- (void)Qukan_ShareImageAndTextToPlatformType:(UMSocialPlatformType)platformType addTitle:(NSString *)title addThumImage:(UIImage *)shareImage addShareImageStr:(NSString * _Nullable)shareImageStr{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //设置文本
    messageObject.text = title;
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图
    shareObject.thumbImage = shareImage;
    [shareObject setShareImage:shareImage];
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:error.userInfo[@"message"]];
        }else{
            NSLog(@"response data is %@",data);
        }
    }];
}

#pragma mark ===================== Third Login =======================
// 获取第三方登录信息
- (void)Qukan_UMGetShareInfoWithPlatform:(UMSocialPlatformType)platformType successBlock:(void (^)(UMSocialUserInfoResponse *result))successBlock failBlock:(void (^)(NSError *error))errorBlock{
    
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            errorBlock(error);
        } else {
            UMSocialUserInfoResponse *resp = result;
            successBlock(resp);
        }
    }];
}


#pragma mark ===================== NetWork ==================================
// 分享统计
- (void)Qukan_userShareAddWithSourceId:(long)sourceId WithSourceType:(NSInteger)sourceType{
    [[[kApiManager QukanUserShareAddWithSourceId:sourceId WithSourceType:sourceType] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
    } error:^(NSError * _Nullable error) {
    }];
}

@end
