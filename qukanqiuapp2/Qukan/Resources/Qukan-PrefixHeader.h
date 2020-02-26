#ifndef Qukan_PrefixHeader_h
#define Qukan_PrefixHeader_h

#import "QukanAppCore.h"
#import "QukanUICore.h"
#import "static_inline.h"

#import <JXCategoryView/JXCategoryView.h>
#import <JXPagerListContainerView.h>
#import <JXPagerListRefreshView.h>

#import "QukanHomeRefreshHeader.h"
#import "QukanNetworkTool.h"
#import "QukanViewController.h"
#import "QukanTool.h"

#import "QukanFailureView.h"

#import "QukanLoginViewController.h"
#import "QukanPhoneLoginViewController.h"
#import "QukanBindingPhoneViewController.h"
#import "QukanCacheManager.h"
#import <UIScrollView+EmptyDataSet.h>
#import "CPCoverView.h" //覆盖层弹框



#pragma mark ===================== 项目配置 ==================================
// 技术支持  没地方用到  但是放这里提醒要更改
#define Qukan_jishuzhichi_Url @""
//隐私链接
#define Qukan_Privacy_Url @"http://xlrgcn.cn/shaozi/agreenment.html"

#define Qukan_UMAppKey                     @"5d7b07ae4ca357ca73000f10" //

#define Qukan_UMQQAppKey                   @"1109809229"//
#define Qukan_UMQQAppSecretKey             @"5bACjjFMguvXeZEl"//

#define Qukan_UMWeChatAppKey               @"wxf9f41e9baa430239"//
#define Qukan_UMWeChatAppSecretKey         @"e44b14ccc30103a8e0c0ff458a8d8ca6"//

#define Qukan_UMChannel                    @"Kanqiudashi"
#define Qukan_OpeninstallKey               @"nx2a33"//
#define Qukan_AdChannel                    @"kanqiudashi"


#define Qukan_AppEnName  @"kanqiudashi"//

#define Qukan_AirPlayAppID                 @"12182"//
#define Qukan_AirPlayAppSecretKey          @"fded24c6654ee7d179a406a788e86600"//

#define Qukan_AppStoreID                   @"1473821983"//


#pragma mark =====================  ==================================

#define Qukan_GoalTips_Voice_Key          @"Qukan_GoalTips_Voice_Key"
#define Qukan_GoalTips_Shock_Key          @"Qukan_GoalTips_Shock_Key"
#define Qukan_RedkaTips_Voice_Key       @"Qukan_RedkaTips_Voice_Key"
#define Qukan_RedkaTips_Shock_Key       @"Qukan_RedkaTips_Shock_Key"
#define Qukan_RangeTips_Shock_Key         @"Qukan_RangeTips_Shock_Key"
#define Qukan_IsShow_Ranking_Key          @"Qukan_IsShow_Ranking_Key"
#define Qukan_IsShow_RedAndYellowka_Key @"Qukan_IsShow_RedAndYellowka_Key"

#define Qukan_Follow_File_Name_Key        @"Qukan_Follow_File_Name_Key"
#define Qukan_newsShareHttp               @"Qukan_newsShareHttp"
#define Qukan_matchShareHttp              @"Qukan_matchShareHttp"

#define Qukan_AirPlayConnectSucceed       @"Qukan_AirPlayConnectSucceed"
#define Qukan_AirPlayCancle               @"Qukan_AirPlayCancle"
#define Qukan_DeviceShouldRotate          @"Qukan_DeviceShouldRotate"
#define Qukan_Follow_NotificationName     @"Qukan_Follow_NotificationName"
#define Qukan_Recommend_Follow_NotificationName     @"Qukan_Recommend_Follow_NotificationName"
#define Qukan_GoalAndRedka_NotificationName    @"Qukan_GoalAndRedka_NotificationName"
#define Qukan_FonsOn_NotificationName    @"Qukan_FonsOn_NotificationName"
#define Qukan_EventsChanges_NotificationName    @"Qukan_EventsChanges_NotificationName"

#define Qukan_Reminder_NotificationName    @"Qukan_Reminder_NotificationName"
#define Qukan_BallPrompt_NotificationName    @"Qukan_BallPrompt_NotificationName"

//#define Qukan_PlayerChangeLine_NotificationName    @"Qukan_PlayerChangeLine_NotificationName"
#define Qukan_AddLiveLineView_NotificationName    @"Qukan_AddLiveLineView_NotificationName"
#define Qukan_GetLiveArray_NotificationName    @"Qukan_GetLiveArray_NotificationName"
#define Qukan_ChangeLine_NotificationName    @"Qukan_ChangeLine_NotificationName"

#define Qukan_PublishRecommendSuccess_NotificationName  @"Qukan_PublishRecommendSuccess_NotificationName"
//#define Qukan_OutLogin_NotificationName  @"Qukan_OutLogin_NotificationName"
#define Qukan_FailButton_NotificationName  @"Qukan_FailButton_NotificationName"
#define Qukan_PlayShare_NotificationName  @"Qukan_PlayShare_NotificationName"
#define Qukan_Nsnotition_CommentNumberChange  @"Qukan_Nsnotition_CommentNumberChange"

#define Qukan_FirstGoInPlayer @"Qukan_FirstGoInPlayer"
#define AppName [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]

#define Qukan_adDidCilck         @"Qukan_adDidCilck"
#define Qukan_webDealloc         @"Qukan_webDealloc"
#define Qukan_openinstallIntCode @"Qukan_openinstallIntCode"
#define Qukan_airPlayTips        @"Qukan_airPlayTips"

// 域名轮询获取的地址  本地存储字段
#define Qukan_locationHostUrl    @"Qukan_locationHostUrl"

// 需要转屏通知
#define Qukan_needRotatScreen_notificationName @"Qukan_needRotatScreen_notificationName"

#endif
