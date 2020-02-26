//
//  QukanMacro.h
//  DaiXiongTV
//
//  Created by pfc on 2019/6/11.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#ifndef QukanMacro_h
#define QukanMacro_h

#define kApplication            [UIApplication sharedApplication]
#define kKeyWindow              [UIApplication sharedApplication].keyWindow
#define kAppDelegate            [UIApplication sharedApplication].delegate
#define kUserDefaults           [NSUserDefaults standardUserDefaults]
#define kNotificationCenter     [NSNotificationCenter defaultCenter]

#define kwindowLast [[UIApplication sharedApplication].windows lastObject]

#define FormatString(f, ...) [NSString stringWithFormat:f, ## __VA_ARGS__]
#pragma mark - Log
#ifdef DEBUG
#   define DEBUGLog(fmt, ...) {NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
#   define ELog(err) {if(err) DLog(@"%@", err)}
#else
#   define DEBUGLog(...)
#   define ELog(err)
#endif

#ifndef dispatch_queue_async_safe
#define dispatch_queue_async_safe(queue, block)\
if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(queue)) == 0) {\
block();\
} else {\
dispatch_async(queue, block);\
}
#endif

#ifndef dispatch_main_async_safe
#define dispatch_main_async_safe(block) dispatch_queue_async_safe(dispatch_get_main_queue(), block)
#endif


//#define kGuardLogin if (!kUserManager.isLogin) { \
//UIViewController *rootViewController = kKeyWindow.rootViewController; \
//QukanPhoneLoginViewController *vc = [[QukanPhoneLoginViewController alloc] init]; \
//UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc]; \
//[rootViewController presentViewController:nav animated:YES completion:nil]; \
//return; \
//} \

#define weLog  [QukanTool Qukan_xuan:kQukan11]

#define kGuardLogin if (!kUserManager.isLogin) { \
    if (weLog == 1) {\
        UIViewController *rootViewController = kKeyWindow.rootViewController; \
        QukanPhoneLoginViewController *vc = [[QukanPhoneLoginViewController alloc] init]; \
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc]; \
        nav.modalPresentationStyle = UIModalPresentationFullScreen; \
        [rootViewController presentViewController:nav animated:YES completion:nil]; \
        return; \
        }\
    if (weLog == 0) {\
        UIViewController *rootViewController = kKeyWindow.rootViewController; \
        QukanLoginViewController *vc = [[QukanLoginViewController alloc] init]; \
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc]; \
        nav.modalPresentationStyle = UIModalPresentationFullScreen; \
        [rootViewController presentViewController:nav animated:YES completion:nil]; \
        return; \
    }\
}

#define FormatString(f, ...) [NSString stringWithFormat:f, ## __VA_ARGS__]

//app名字
#define Qukan_AppName [infoDictionary objectForKey:@"CFBundleDisplayName"];

//下拉刷新 GIF
#define  kRefreshImages @[kImageNamed(@"Qukan_Follow2"),kImageNamed(@"Qukan_Follow2"),kImageNamed(@"Qukan_Follow2"),kImageNamed(@"Qukan_Follow2")]

#define Qukan_AppBundleId [[NSBundle mainBundle]bundleIdentifier]


// 比赛模块
#define kQukan2          @"2"
// 客服qq
#define kQukan1       @"1"
// 微信
#define kQukan6  @"6"
// 任务
#define kQukan4          @"4"
// 足球直播
#define kQukan3           @"3"
//足球动画直播
#define kQukan15           @"15"
//篮球直播
#define kQukan14           @"14"
//足球动画直播
#define kQukan16           @"16"
// 微信登录
#define kQukan11           @"11"
// 好评领红包
#define kQukan5           @"5"
//兑换
#define kQukan8           @"8"
//火爆交流群
#define kQukan9          @"9"
//积分投屏红包展示
#define kQukan10          @"10"
// 手机登录
#define kQukan12           @"12"
//个人中心
#define kQukan7      @"7"
//马甲包开关
#define kQukan13      @"13"

//篮球聊天室
#define kQukan17      @"17"
//足球聊天室
#define kQukan18      @"18"


//爆点
#define kNews35      35
//视频
#define kNews36      36
//欧洲杯
#define kNews37      37
//欧联杯
#define kNews38      38
//亚冠
#define kNews39      39
//欧冠
#define kNews40      40
//中超
#define kNews41      41
//中甲
#define kNews42      42
//法甲
#define kNews43      43
//西甲
#define kNews44      44
//意甲
#define kNews45      45
//英超
#define kNews46      46
//德甲
#define kNews47      47
//CBA
#define kNews48      48
//NBA
#define kNews49      49

#endif /* QukanMacro_h */

