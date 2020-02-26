


#import "QukanLocalNotification.h"

#import "QukanBasketBallMatchModel.h"
#import <UserNotifications/UserNotifications.h>
#import "QukanMatchInfoModel.h"
#import "QukanBSKDataTeamDetailModel.h"
#import "QukanFTMatchScheduleModel.h"

@implementation QukanLocalNotification

+(void)initialize{
    [self registerNotification];
}

+(void)noticeWithType:(NSString *)matchType model:(id)model {
    NSString *identifier;
    NSString *matchId;
    NSString *alertBody;
    NSString *alertTitle;
    NSString *time;
    if ([matchType isEqualToString:MatchTypeBasketball]) {
        QukanBasketBallMatchModel *bskModel = model;
        identifier = FormatString(@"%@%@",MatchTypeBasketball,bskModel.matchId);
        matchId = bskModel.matchId;
        alertBody = MatchBody;
        alertTitle = FormatString(@"%@ vs %@",bskModel.awayName,bskModel.homeName);
        time = bskModel.matchTime;
        [self notificationIdentifier:identifier matchId:matchId alertBody:alertBody alertTitle:alertTitle withTime:time matchType:matchType];
    } else if ([matchType isEqualToString:MatchTypeFootball]) {
        QukanMatchInfoContentModel *ftbModel = model;
        identifier = FormatString(@"%@%ld",MatchTypeFootball,ftbModel.match_id);
        matchId = FormatString(@"%ld",ftbModel.match_id);
        alertBody = MatchBody;
        alertTitle = FormatString(@"%@ vs %@",ftbModel.home_name,ftbModel.away_name);
        time = ftbModel.start_time;
        [self notificationIdentifier:identifier matchId:matchId alertBody:alertBody alertTitle:alertTitle withTime:time matchType:matchType];
    } else if ([matchType isEqualToString:BasketballTeam]) {
        QukanSelectScheduleTeamModel *scheduleModel = model;
        identifier = FormatString(@"%@%ld",BasketballTeam,scheduleModel.matchId.integerValue);
        matchId = FormatString(@"%ld",scheduleModel.matchId.integerValue);
        alertBody = MatchBody;
        alertTitle = FormatString(@"%@ vs %@",scheduleModel.homeName,scheduleModel.awayName);
        time = scheduleModel.startTime;
        [self notificationIdentifier:identifier matchId:matchId alertBody:alertBody alertTitle:alertTitle withTime:time matchType:matchType];
    } else if ([matchType isEqualToString:FootballTeam]) {
        QukanFTMatchScheduleModel *scheduleModel = model;
        identifier = FormatString(@"%@%@",FootballTeam,scheduleModel.match_id);
        matchId = scheduleModel.match_id;
        alertBody = MatchBody;
        alertTitle = FormatString(@"%@ vs %@",scheduleModel.home_name,scheduleModel.away_name);
        time = scheduleModel.start_time;
        [self notificationIdentifier:identifier matchId:matchId alertBody:alertBody alertTitle:alertTitle withTime:time matchType:matchType];
    }
}
+(void)notificationIdentifier:(NSString  *)identifier
                      matchId:(NSString  *)matchId
                    alertBody:(NSString  *)alertBody
                   alertTitle:(NSString  *)alertTitle
                     withTime:(NSString *)time matchType:(NSString *)matchType{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *endTime = [formatter dateFromString:time];
    NSDate *fireTime = [endTime dateByAddingTimeInterval:-5 * 60];
    NSDate *startTime = [NSDate date];
    NSTimeInterval intervalTime = [fireTime timeIntervalSinceDate:startTime];
    if (intervalTime <= 0) {
        return;
    }
    
    [self registerNotification];
    [self cancleLocationIdentifier:identifier];
    
    if (@available(iOS 10.0, *)) {
        [self notificationiOSTenLaterWithKey:identifier alertBody:alertBody alertTitle:alertTitle time:intervalTime matchId:matchId matchType:matchType];
    } else {
        [self notificationiOSTenBeforeIdentifier:identifier alertBody:alertBody alertTitle:alertTitle fireDate:fireTime matchId:matchId matchType:matchType];
    }
      
}

+(void)notificationiOSTenBeforeIdentifier:(NSString *)identifier
                                alertBody:(NSString *)alertBody
                               alertTitle:(NSString *)alertTitle
                                 fireDate:(NSDate*)fireDate matchId:(NSString *)matchId matchType:(NSString *)matchType{
    
    UILocalNotification *notification           = [[UILocalNotification alloc] init];
    if (notification!=nil) {
        notification.fireDate                   = fireDate;
        notification.timeZone                   = [NSTimeZone defaultTimeZone];
        notification.soundName                  = UILocalNotificationDefaultSoundName;//声音，可以换成alarm.soundName = @"myMusic.caf"
        //去掉下面2行就不会弹出提示框
//        NSDictionary *dic                       = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:activityId], identifier,nil];
        NSDictionary *dic = @{@"localNotice":@"localNotice",@"identifier":identifier,@"matchType":matchType,@"matchId":matchId};
        notification.userInfo                   = dic;
        notification.alertBody                  = alertBody;//提示信息 弹出提示框
        notification.alertTitle                 = alertTitle;
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

+(void)notificationiOSTenLaterWithKey:(NSString *)key alertBody:(NSString *)alertBody alertTitle:(NSString *)alertTitle time:(NSTimeInterval)time matchId:(NSString *)matchId matchType:(NSString *)matchType{
    // 使用 UNUserNotificationCenter 来管理通知
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000

    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
        //需创建一个包含待通知内容的 UNMutableNotificationContent 对象，注意不是 UNNotificationContent ,此对象为不可变对象。
        UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
        content.title = [NSString localizedUserNotificationStringForKey:alertTitle arguments:nil];
        content.body = [NSString localizedUserNotificationStringForKey:alertBody arguments:nil];
        content.sound = [UNNotificationSound defaultSound];
        
        // 在 alertTime 后推送本地推送
        content.userInfo = @{@"localNotice":@"localNotice",@"matchType":matchType,@"matchId":matchId};
        UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:time repeats:NO];
        UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:key content:content trigger:trigger];
        //添加推送成功后的处理！
        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            NSLog(@"error = %@",request);
        }];
    } else {
        // Fallback on earlier versions
    }

#endif
}

+(void)registerNotification{
    
    if (@available(iOS 10.0, *)) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        //请求获取通知权限（角标，声音，弹框）
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                //获取用户是否同意开启通知
                NSLog(@"request authorization successed!");
            }
        }];
        
#endif
    }else if (@available(iOS 8.0, *)){
        if ([[UIApplication sharedApplication]  respondsToSelector:@selector(registerUserNotificationSettings:)]) {
            UIUserNotificationSettings* settings=[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
            NSLog(@"iOS 8.0 ");
        }
    }
}

+(void)cancleLocationIdentifier:(NSString *)identifier {
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
            for (UNNotificationRequest *req in requests){
                NSLog(@"存在的ID:%@\n",req.identifier);
            }
            NSLog(@"移除currentID:%@",identifier);
        }];
        
        [center removePendingNotificationRequestsWithIdentifiers:@[identifier]];
    }else {
        NSArray *array=[[UIApplication sharedApplication] scheduledLocalNotifications];
        for (UILocalNotification *localNotification in array){
            NSDictionary *userInfo = localNotification.userInfo;
            NSString *obj = [userInfo objectForKey:@"identifier"];
            if ([obj isEqualToString:identifier]) {
                [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
            }
        }
    }
}



+ (void)checkUserNotificationEnable { // 判断用户是否允许接收通知
    if (@available(iOS 10.0, *)) {
        __block BOOL isOn = NO;
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            if (settings.notificationCenterSetting == UNNotificationSettingEnabled) {
                isOn = YES;
                NSLog(@"打开了通知");
            }else {
                isOn = NO;
                NSLog(@"关闭了通知");
                [self showAlertView];
            }
        }];
    }else {
        if ([[UIApplication sharedApplication] currentUserNotificationSettings].types == UIUserNotificationTypeNone){
            NSLog(@"关闭了通知");
            [self showAlertView];
        }else {
            NSLog(@"打开了通知");
        }
    }
}

+ (void)showAlertView {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"打开APP通知，畅享精彩赛事" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self goToAppSystemSetting];
    }]];
    [[self jsd_getCurrentViewController] presentViewController:alert animated:YES completion:nil];
    
    
    
}
+ (UIViewController *)jsd_getCurrentViewController{
    
    UIViewController* currentViewController = [self jsd_getRootViewController];
    BOOL runLoopFind = YES;
    while (runLoopFind) {
        if (currentViewController.presentedViewController) {
            
            currentViewController = currentViewController.presentedViewController;
        } else if ([currentViewController isKindOfClass:[UINavigationController class]]) {
            
            UINavigationController* navigationController = (UINavigationController* )currentViewController;
            currentViewController = [navigationController.childViewControllers lastObject];
            
        } else if ([currentViewController isKindOfClass:[UITabBarController class]]) {
            
            UITabBarController* tabBarController = (UITabBarController* )currentViewController;
            currentViewController = tabBarController.selectedViewController;
        } else {
            
            NSUInteger childViewControllerCount = currentViewController.childViewControllers.count;
            if (childViewControllerCount > 0) {
                
                currentViewController = currentViewController.childViewControllers.lastObject;
                
                return currentViewController;
            } else {
                
                return currentViewController;
            }
        }
        
    }
    return currentViewController;
}
+ (UIViewController *)jsd_getRootViewController{
    
    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    NSAssert(window, @"The window is empty");
    return window.rootViewController;
}

// 如果用户关闭了接收通知功能，该方法可以跳转到APP设置页面进行修改
+ (void)goToAppSystemSetting {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIApplication *application = [UIApplication sharedApplication];
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([application canOpenURL:url]) {
            if (@available(iOS 10.0, *)) {
                if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                    [application openURL:url options:@{} completionHandler:nil];
                }
            }else {
                [application openURL:url];
            }
        }
    });
}
@end
