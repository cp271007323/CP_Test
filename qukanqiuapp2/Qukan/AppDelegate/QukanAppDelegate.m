#import "QukanAppDelegate.h"
#import "QukanAppDelegate+Push.h"
#import "QukanAirPlayManager.h"

#import <OpenInstallSDK.h>

#import "QukanApiManager+Mine.h"

#import <TABAnimated.h>

@interface QukanAppDelegate ()<UNUserNotificationCenterDelegate,OpenInstallDelegate>

@end

@implementation QukanAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //  APP启动  判断是否是由通知点击进入
    NSDictionary * userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    UILocalNotification *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (userInfo) {
        [kUserDefaults setObject:userInfo forKey:@"kRemoteNotificationDataKey"];
    }
    if (notification) {
        [kUserDefaults setObject:notification.userInfo forKey:@"kLocalNotificationDataKey"];
    }
    [self setTABAnimation];
    
    // 重新设置根视图控制器
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = self.tarBar;
    [self.window makeKeyAndVisible];
        
    // 初始化本地数据(进球设置等)
    [QukanTool Qukan_initLocalData];
    
    //友盟
    [kUMShareManager Qukan_ShareSet];
    
    [self QukanregisterNotification:launchOptions];
    
    //统计
    [OpenInstallSDK initWithDelegate:self];
    
    // 设置投屏参数
    [[QukanAirPlayManager sharedManager] Qukan_asyncRegister];

    // 查看设备当前网络状况 （这个y我也不知道有啥用）
    [kNetworkManager addReachabilityMonitor];
    
    // 网易云
    [self setupIM];

    return YES;
}


- (void)setTABAnimation {
#ifdef DEBUG
    // 骨架屏core部分不依赖reveal工具
    // reveal工具依赖骨架屏core，实时预览效果，无需编译
    // 请务必放在debug环境下
    //    [[TABAnimatedBall shared] install];
#endif
    
    // Init `TABAnimated`, and set the properties you need.
    // 初始化TABAnimated，并设置TABAnimated相关属性
    // 初始化方法仅仅设置的是全局的动画效果
    // 你可以设置`TABViewAnimated`中局部动画属性`superAnimationType`覆盖全局属性，在工程中兼容多种动画
    [[TABAnimated sharedAnimated] initWithOnlySkeleton];
    // open log
    // 开启日志
    [TABAnimated sharedAnimated].openLog = YES;
    // 是否开启动画坐标标记，如果开启，也仅在debug环境下有效。
    // 开启后，会在每一个动画元素上增加一个红色的数字，该数字表示该动画元素所在下标，方便快速定位某个动画元素。
    [TABAnimated sharedAnimated].openAnimationTag = NO;
    
    /*****************************************
     *****************************************
     ************     重要必读    *************
     *****************************************
     *****************************************
     */
    // debug 环境下，默认关闭缓存功能（为了方便调试预处理回调)
    // release 环境下，默认开启缓存功能
    // 如果你想在 debug 环境下测试缓存功能，可以手动置为NO，但是预处理回调只生效一次！！！！
    // 如果你始终都不想使用缓存功能，可以手动置为YES
    // 请仔细阅读：https://juejin.im/post/5d86d16ce51d4561fa2ec135
    //    [TABAnimated sharedAnimated].closeCache = NO;
}


#pragma mark ===================== Application =======================
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响。
    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
    if (!result) {
        
    }
    if ([OpenInstallSDK handLinkURL:url]){//必写
        return YES;
    }
    return result;
}


#pragma mark ===================== OpenInstall ==================================

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler {
    //判断是否通过OpenInstall Universal Link 唤起App
    if ([OpenInstallSDK continueUserActivity:userActivity]){//如果使用了Universal link ，此方法必写
        return YES;
    }
    //其他第三方回调；
    return YES;
}

- (void)getInstallParamsFromOpenInstall:(nullable NSDictionary *)params withError:(nullable NSError *)error {
    if (params.allKeys.count) {
        NSString *YQMA = [params stringValueForKey:@"YQMA" default:@""];
        if (YQMA.length > 0 && YQMA != nil) {
            [kUserDefaults setObject:params[@"YQMA"] forKey:Qukan_openinstallIntCode];
            [self Qukan_JoinAddWithInvitationCode:params[@"YQMA"]];
        }
    }
}

-(void)getWakeUpParams:(OpeninstallData *)appData{
    if (appData.data) {//(动态唤醒参数)
        //e.g.如免填码建立关系、自动加好友、自动进入某个群组或房间等
//        NSDictionary *dict = (NSDictionary *)appData.data;
        NSString *YQMA = [appData.data stringValueForKey:@"YQMA" default:@""];
        if (YQMA.length > 0 && YQMA != nil) {
            [kUserDefaults setObject:appData.data[@"YQMA"] forKey:Qukan_openinstallIntCode];
            [self Qukan_JoinAddWithInvitationCode:appData.data[@"YQMA"]];
        }
        
    }
    if (appData.channelCode) {//(通过渠道链接或二维码唤醒会返回渠道编号)
        //e.g.可自己统计渠道相关数据等
    }
}

// app 进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // 进入后台时发送需要转屏通知
    [kNotificationCenter postNotificationName:Qukan_needRotatScreen_notificationName object:nil];
}


- (void)Qukan_JoinAddWithInvitationCode:(NSString *)invitationCode {
    [[[kApiManager QukanUserJoinAdd:invitationCode] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
    } error:^(NSError * _Nullable error) {
    }];
}

- (QukanTarBarViewController *)tarBar {
    if (!_tarBar) {
        _tarBar = [[QukanTarBarViewController alloc] init];
    }
    return _tarBar;
}


#pragma mark ======================= 网易云 ==================================

- (void)setupIM {
    NIMSDKOption *option    = [NIMSDKOption optionWithAppKey:@"9bed274d6b6434b9a27e5eff0f152a17"];
    //    option.apnsCername      = @"your APNs cer name";
    //    option.pkCername        = @"your pushkit cer name";
    [[NIMSDK sharedSDK] registerWithOption:option];
}

/// 在这里写支持的旋转方向，为了防止横屏方向，应用启动时候界面变为横屏模式
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

@end
