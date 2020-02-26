//
//  QukanAppDelegate+Push.m
//  Qukan
//
//  Created by mac on 2018/12/7.
//  Copyright © 2018 Ningbo Suda. All rights reserved.
//

#import "QukanAppDelegate+Push.h"

#import <UMPush/UMessage.h>

#import "QukanDailyVC.h"
#import "QukanShareCenterViewController.h"
#import "QukanBasketDetailVC.h"

#import "QukanUIViewController+Ext.h"
#import "QukanApiManager+Mine.h"
#import "QukanLocalNotification.h"

@interface QukanSelfViewController : UIAlertController
@end

@implementation QukanSelfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view dismissHUD];
}

- (BOOL)shouldAutorotate {
    return YES;
}

@end
 
// crash: Supported orientations has no common orientation with the application, and [UIAlertController shouldAutorotate] is returning YES
// 参考链接：https://www.cnblogs.com/widgetbox/p/11274117.html
@interface UIAlertController (Rotation)
- (BOOL)shouldAutorotate;
@end
 
@implementation UIAlertController (Rotation)
- (BOOL)shouldAutorotate
{
    return NO;
}
@end

@implementation QukanAppDelegate (Push)

- (void)QukanregisterNotification:(NSDictionary *)launchOptions {
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
        if (@available(iOS 10.0, *)) {
            UNUserNotificationCenter * center =[UNUserNotificationCenter currentNotificationCenter];
            center.delegate=self;
            UNAuthorizationOptions options = UNAuthorizationOptionAlert|UNAuthorizationOptionSound|UNAuthorizationOptionBadge|UNAuthorizationOptionCarPlay;
            [center requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError * _Nullable error) {
                
            }];
        }
    }
    else if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
    {
        UIUserNotificationSettings *sets= [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge|UIUserNotificationTypeAlert|UIUserNotificationTypeSound) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:sets];
    }
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self alertVC];
//    });

}

#if DEBUG
- (void)alertVC {
    
    QukanSelfViewController *alert = [QukanSelfViewController alertControllerWithTitle:@"11"message:@"222" preferredStyle:UIAlertControllerStyleAlert];
    @weakify(self)
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"去看看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self)
        
        [self jumpToNewsDetailWithId:@"71525"];
    }];
    UIAlertAction *no = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:ok];
    [alert addAction:no];

    [self.tarBar presentViewController:alert animated:NO completion:nil];
}
#endif

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler API_AVAILABLE(ios(10.0)){
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭U-Push自带的弹出框
        [UMessage setAutoAlert:NO];
        
        NSArray *keyArray = [userInfo allKeys];
        if ([keyArray containsObject:@"title"] && [keyArray containsObject:@"text"]) {
            QukanTuiSongModel *model = [QukanTuiSongModel modelWithJSON:userInfo];
            QukanSelfViewController *alert = [QukanSelfViewController alertControllerWithTitle:model.title message:model.text preferredStyle:UIAlertControllerStyleAlert];
            @weakify(self)
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"去看看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                @strongify(self)
                [self QukanJumpNotificationWith:userInfo];
            }];
            UIAlertAction *no = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:ok];
            [alert addAction:no];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // UI更新代码
                [[UIViewController visibleViewController]  presentViewController:alert animated:YES completion:nil];
            });
            
        }
    }else{
        //应用处于前台时的本地推送接受
        if ([[userInfo allKeys] containsObject:@"localNotice"]) {
        UNNotificationContent* content = notification.request.content;
        QukanSelfViewController *alert = [QukanSelfViewController alertControllerWithTitle:content.title message:content.body preferredStyle:UIAlertControllerStyleAlert];
        @weakify(self)
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"看比赛" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self)
            [self QukanLocalNotificationJump:userInfo[@"matchType"] matchId:userInfo[@"matchId"]];
        }];
        UIAlertAction *no = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:ok];
        [alert addAction:no];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // UI更新代码
            [[UIViewController visibleViewController]  presentViewController:alert animated:YES completion:nil];
        });
        }
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge);
}


//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler API_AVAILABLE(ios(10.0)){
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground){
            //销毁唤醒会走
            
        }else if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateInactive){
            //活着的时候会走
            NSDictionary *dictionary = [kUserDefaults objectForKey:@"kRemoteNotificationDataKey"];
            if(dictionary == nil){
                [self QukanJumpNotificationWith:userInfo];
            }
            
        }else if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive){
            //电话进来或者其他中断事件
        }
        //
        
    }else{
        //应用处于后台时的本地推送接受
        if ([[userInfo allKeys] containsObject:@"localNotice"]) {
            NSDictionary *dictionary = [kUserDefaults objectForKey:@"kLocalNotificationDataKey"];
            if (dictionary == nil) {
                [self QukanLocalNotificationJump:userInfo[@"matchType"] matchId:userInfo[@"matchId"]];
            }
        }
    }
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    completionHandler(UIBackgroundFetchResultNewData);
    [UMessage didReceiveRemoteNotification:userInfo];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
        
    }else{
        if ([[userInfo allKeys] containsObject:@"localNotice"]) {
            [self QukanLocalNotificationJump:userInfo[@"matchType"] matchId:userInfo[@"matchId"]];
        } else {
            [self QukanJumpNotificationWith:userInfo];
        }
    }
    
    //收到推送消息手机震动，播放音效
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    AudioServicesPlaySystemSound(1007);
    //    }
    //设置应用程序角标数为0
    [UIApplication sharedApplication].applicationIconBadgeNumber = 9999;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    [UMessage registerDeviceToken:deviceToken];
    NSString *token;
    if (@available(iOS 13.0, *)) {
        if (![deviceToken isKindOfClass:[NSData class]]) return;
        const unsigned *tokenBytes = (const unsigned *)[deviceToken bytes];
        token = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                              ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                              ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                              ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    } else {
        token = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]stringByReplacingOccurrencesOfString: @">" withString: @""]stringByReplacingOccurrencesOfString: @" " withString: @""];
    }
    
    NSLog(@" device token %@",token);
    [self Qukan_UmengToken:token];
}


- (void)Qukan_UmengToken:(NSString *)UmengToken {
    [[[kApiManager QukanUmengToken:UmengToken] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        DEBUGLog(@"x = %@",x);
    } error:^(NSError * _Nullable error) {
    }];
}
#pragma mark -本地通知跳转
- (void)QukanLocalNotificationJump:(NSString *)matchType matchId:(NSString *)matchId {
    if ([matchType isEqualToString:MatchTypeFootball] || [matchType isEqualToString:FootballTeam]) {
        [self localJumpToFTDetailWithMatchId:matchId];
    } else if ([matchType isEqualToString:MatchTypeBasketball] || [matchType isEqualToString:BasketballTeam]) {
        
        QukanBasketDetailVC *vc = [[QukanBasketDetailVC alloc] init];
        vc.matchId = matchId;
        vc.hidesBottomBarWhenPushed = YES;
        [[QukanIMChatManager sharedInstance] logOutChat:^(NSError * _Nullable error) {
        }];
        [[self jsd_findVisibleViewController].navigationController pushViewController:vc animated:1];
        
    }
}
- (void)localJumpToFTDetailWithMatchId:(NSString *)matchId {
    @weakify(self)
    [[[kApiManager QukangGetId:matchId] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        QukanPictureModel *m = [QukanPictureModel modelWithJSON:x];
        QukanMatchInfoContentModel *model = [QukanMatchInfoContentModel modelWithJSON:x];
        @strongify(self)
        
        model.match_id = m.matchId;
        model.flag1 = m.awayFlag;
        model.flag2 = m.homeFlag;
        model.away_name = m.awayName;
        model.home_name = m.homeName;
        
        model.away_score = m.awayScore;
        model.home_score = m.homeScore;
        model.start_time = m.time;
        
        model.match_time = m.matchTime;
        model.league_name = m.leagueName;
        model.pass_time =  m.passTime;
        
        QukanDetailsViewController *vc = [[QukanDetailsViewController alloc] init];
        vc.Qukan_model = model;
        vc.hidesBottomBarWhenPushed = YES;

        // 每次进入详情界面时断开连接
        [[QukanIMChatManager sharedInstance] logOutChat:^(NSError * _Nullable error) {
            [kNotificationCenter postNotificationName:Qukan_needRotatScreen_notificationName object:nil];
            @strongify(self)
        }];
        [[self jsd_findVisibleViewController].navigationController pushViewController:vc animated:1];
        
        
    } error:^(NSError * _Nullable error) {
        [kKeyWindow showTip:error.localizedDescription];
    }];
}
#pragma mark -推送获取的跳转代码
- (void)QukanJumpNotificationWith:(NSDictionary *)userInfo {
    QukanTuiSongModel *model = [QukanTuiSongModel modelWithJSON:userInfo];
    //  1= 内部跳转  2 = 外部跳转
    if([model.jumpModel isEqualToString:@"1"]){
        //内部跳转
        //1 == 直播间  2 = 任务活动 3 = H5链接  4 = 新闻详情。  5 篮球
        if([model.jumpType isEqualToString:@"1"]){
            
            NSString *str = model.jumpCustomized;
            if(![str containsString:@"."]){
                [self jumpToFTDetailWithMatchId:str];
            }else {
                [kKeyWindow showTip:@"获取数据失败"];
            }
            
        }else if ([model.jumpType isEqualToString:@"2"]) {
            [self jumpToMRRWVC];
        }
        else if ([model.jumpType isEqualToString:@"3"]) {
            [self jumpToFXZXWithModel:model];
        }
        else if ([model.jumpType isEqualToString:@"4"]) {
            NSString *str = model.jumpCustomized;
            [self jumpToNewsDetailWithId:str];
        } else if ([model.jumpType isEqualToString:@"5"]) {
            [self jumpToBasketBallDetailWithModel:model];
        }
    }else{
        //外部跳转
        NSString *str = model.jumpCustomized;
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
    
}

// 跳转到足球详情
- (void)jumpToFTDetailWithMatchId:(NSString *)matchId {
    UIViewController *avc = [UIViewController visibleViewController];
    
    @weakify(avc)
    [avc.view showHUD];
    [[[kApiManager QukangGetId:matchId] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(avc)
        [avc.view dismissHUD];
        
        QukanPictureModel *m = [QukanPictureModel modelWithJSON:x];
        QukanMatchInfoContentModel *model = [QukanMatchInfoContentModel modelWithJSON:x];
        
        
        model.match_id = m.matchId;
        model.flag1 = m.awayFlag;
        model.flag2 = m.homeFlag;
        model.away_name = m.awayName;
        model.home_name = m.homeName;
        
        model.away_score = m.awayScore;
        model.home_score = m.homeScore;
        model.start_time = m.time;
        
        model.match_time = m.matchTime;
        model.league_name = m.leagueName;
        model.pass_time =  m.passTime;
        
        QukanDetailsViewController *vc = [[QukanDetailsViewController alloc] init];
        vc.Qukan_model = model;
        vc.hidesBottomBarWhenPushed = YES;
        
        // 每次进入详情界面时断开连接
        [[QukanIMChatManager sharedInstance] logOutChat:^(NSError * _Nullable error) {
            
        }];
        [self pushViewControllerBySelf:vc];
       
        
    } error:^(NSError * _Nullable error) {
        [kKeyWindow showTip:error.localizedDescription];
    }];
}


// 跳转到每日任务界面
- (void)jumpToMRRWVC {
    UIViewController *curVC = [UIViewController visibleViewController];
    if ([curVC isKindOfClass:[QukanDailyVC class]]) {
        [kKeyWindow showTip:[NSString stringWithFormat:@"已经在%@页",kStStatus.caseNum]];
        return;
    }
    
    QukanDailyVC *vc = [QukanDailyVC new];
    vc.hidesBottomBarWhenPushed = YES;
    [self pushViewControllerBySelf:vc];
}

// 跳转到分享中心
- (void)jumpToFXZXWithModel:(QukanTuiSongModel *)model {
    NSString *str = model.jumpCustomized;
    if([model.jumpModel isEqualToString:@"1"]){
        //判断是否登录
        kGuardLogin
        if ([[UIViewController visibleViewController] isKindOfClass:[QukanShareCenterViewController class]]) {
            [kKeyWindow showTip:@"已经在分享中心"];
            return;
        }
        QukanShareCenterViewController *vc = [[QukanShareCenterViewController alloc] init];
        NSString *url = [NSString stringWithFormat:@"%@?adType=%@&bunleId=%@&appKey=%@",str,@"0",Qukan_AppBundleId,Qukan_OpeninstallKey];
        vc.webUrl = url;
        vc.hidesBottomBarWhenPushed = YES;
        [self pushViewControllerBySelf:vc];
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}

// 跳转到新闻详情
- (void)jumpToNewsDetailWithId:(NSString *)newId {
    UIViewController *curVC = [UIViewController visibleViewController];
    @weakify(curVC)
    [curVC.view showHUD];
    [[[kApiManager QukangGetNewId:newId] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(curVC)
        [curVC.view dismissHUD];
        
        QukanNewsModel *model =  [QukanNewsModel modelWithDictionary:x];
        QukanNewsDetailsViewController *vc = [[QukanNewsDetailsViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.videoNews = model;
        vc.isBaner = YES;
        
        [self pushViewControllerBySelf:vc];
    } error:^(NSError * _Nullable error) {
        [curVC.view dismissHUD];
        [kKeyWindow showTip:error.localizedDescription];
    }];
}

// 跳转到篮球详情页面
- (void)jumpToBasketBallDetailWithModel:(QukanTuiSongModel *)model {
    NSString *str = model.jumpCustomized;
    if(![str containsString:@"."]){
       QukanBasketDetailVC *vc = [[QukanBasketDetailVC alloc] init];
       vc.matchId = model.jumpCustomized;
       vc.hidesBottomBarWhenPushed = YES;
        
        [[QukanIMChatManager sharedInstance] logOutChat:^(NSError * _Nullable error) {
        }];
        [self pushViewControllerBySelf:vc];
       
    }else {
       [kKeyWindow showTip:@"获取数据失败"];
    }
}

// 判断是否为竖屏
- (BOOL)isPortrait {
    return [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait;
}
// 跳转控制器
- (void)pushViewControllerBySelf:(UIViewController *)controller {
    [kNotificationCenter postNotificationName:Qukan_needRotatScreen_notificationName object:nil];
    
    if (![self isPortrait]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[self jsd_findVisibleViewController].navigationController pushViewController:controller animated:1];
//            [[UIViewController visibleViewController].navigationController pushViewController:controller animated:YES];
        });
    }else {
        [[self jsd_findVisibleViewController].navigationController pushViewController:controller animated:1];
//        [[UIViewController visibleViewController].navigationController pushViewController:controller animated:YES];
    }
}




- (UIViewController *)jsd_getRootViewController{
    
    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    NSAssert(window, @"The window is empty");
    return window.rootViewController;
}
- (UIViewController *)jsd_findVisibleViewController {
    
    UIViewController* currentViewController = [self jsd_getRootViewController];
    
    BOOL runLoopFind = YES;
    while (runLoopFind) {
        if (currentViewController.presentedViewController) {
            currentViewController = currentViewController.presentedViewController;
        } else {
            if ([currentViewController isKindOfClass:[UINavigationController class]]) {
                currentViewController = ((UINavigationController *)currentViewController).visibleViewController;
            } else if ([currentViewController isKindOfClass:[UITabBarController class]]) {
                currentViewController = ((UITabBarController* )currentViewController).selectedViewController;
            } else {
                break;
            }
        }
    }
    
    return currentViewController;
}
@end
