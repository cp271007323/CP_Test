//
//  QukanApiManager+PersonCenter.h
//  Qukan
//
//  Created by Kody on 2019/8/17.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanApiManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface QukanApiManager (PersonCenter)

/** 客服聊天 */
- (RACSignal *)QukanCustDialogCreate;

/** 二维码图片 */
- (RACSignal *)QukanCodeCreateQR:(NSString *)openAppId;

/** 获取 */
- (RACSignal *)QukanCodeCreateYRWithUserId:(NSString *)userId;

- (RACSignal *)QukanGcUserSelectTpList;

- (RACSignal *)QukanSelectDate;


/** 获取投屏剩余时间 */
- (RACSignal *)QukanSelectTpTime;


- (RACSignal *)QukanGetInfoWithCode:(NSString *)code;

/** 获取徽章 */
- (RACSignal *)QukanGcUserSelectParmList;

/** 点亮徽章 */
- (RACSignal *)QukanGcUserDlWithCode:(NSString *)code;

/** 佩戴徽章 */
- (RACSignal *)QukanGcUserDataWithCode:(NSString *)code;

/** 用户点亮和佩戴徽章 */
- (RACSignal *)QukanGcUserHeadImage;

/** 今日比赛时间更新 */
- (RACSignal *)QukanAddTodayTime:(NSString *)todayTimeStr WithMatchId:(long)matchId;

/** 任务查询 */
- (RACSignal *)QukanSportQuery;

/** 用户微信绑定查询 */
- (RACSignal *)QukanGcUserCollectionQuery;

/** 绑定用户微信 */
- (RACSignal *)QukanGcUserbingWithOpenId:(NSString *)openId unionId:(NSString *)unionId nickName:(NSString *)nickName accessToken:(NSString *)accessToken;

/** 阅读文章或者观看视频数据收集 */
- (RACSignal *)QukanUserReadAddWithSourceId:(long)sourceId WithSourceType:(NSInteger)sourceType WithStopTime:(long)stopTime;

/** 分享数据收集 */
- (RACSignal *)QukanUserShareAddWithSourceId:(long)sourceId WithSourceType:(NSInteger)sourceType;

/** 几分 */
- (RACSignal *)QukanFocusNum:(NSString *)num WithRecordId:(long)recordId;

/** 鸿包 */
- (RACSignal *)QukanGcUserReadList:(double)today WithRecordId:(long)recordId;

/** 友盟通知查询 */
- (RACSignal *)QukanGcUserNoticeSelectNoticeWithCursor:(NSString *)cursor WithPagingSize:(NSInteger)pagingSize;

/** 友盟未读通知 */
- (RACSignal *)QukanGcUserNoticeSselectCount;

///** 我分享和下载地址 */
//- (RACSignal *)QukanShow;

/** 配置获取 */
- (RACSignal *)QukanAppGetConfig;


- (RACSignal *)QukanUserReads:(NSString *)red;

- (RACSignal *)QukangcuserData:(NSString *)val;

/**微信tixian记录查询 */
- (RACSignal *)QukanreadListWithCurrent:(NSInteger)current size:(NSInteger)size;
/**hongList*/
- (RACSignal *)QukanGetInfoList;

/**g获取提现规则*/
- (RACSignal *)QukanGetSig;

@end


NS_ASSUME_NONNULL_END
