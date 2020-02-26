//
//  QukanApiManager+Mine.h
//  Qukan
//
//  Created by pfc on 2019/6/20.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanApiManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface QukanApiManager (Mine)

/** 登录接口 */
- (RACSignal *)QukanloginWithAccount:(NSString *)account andPassword:(NSString *)password;

/** 出现赛事关注、话题关注数量 */
- (RACSignal *)QukansearchFocusInfo;

/** 根据id查看个人信息 */
- (RACSignal *)QukangcuserFindUserById:(NSString *)userId;

/** 用户意见反馈 */
- (RACSignal *)QukangcUserFeedbackAddWithContent:(NSString *)content addcontact:(NSString *)contact addImageUrl:(NSString *)imageurl;

/** 用户注册 */
- (RACSignal *)QukangcuserRegisterWithTel:(NSString *)tel addCode:(NSString *)code addPassword:(NSString *)password addInvitationCode:(NSString *)invitationCode;

/** 用户找回密码验证码 */
- (RACSignal *)QukansmsSendCodeWithMobile:(NSString *)mobile addCode:(NSString *)code;

/** 修改密码 */
- (RACSignal *)QukangcuserForgetPassWithTel:(NSString *)tel addCode:(NSString *)code  addPassword:(NSString *)password;

/** 更改信息 */
- (RACSignal *)QukangcuserUpdateWithNickname:(NSString *)nickname;


/** 用户绑定邮箱获取验证码 email:邮箱 type:类型，1修改密码，2注册*/
- (RACSignal *)TopicBindEmailSendCodeWithEmail:(NSString *)email type:(NSString *)type;


/** 用户绑定邮箱 email:邮箱 yzCode:验证码*/
- (RACSignal *)TopicBindEmailWithEmail:(NSString *)email yzCode:(NSString *)yzCode;

/** 修改密码 */
- (RACSignal *)QukangcuserEditPassWithPassword:(NSString *)password addOpassword:(NSString *)opassword;

/** 根据手机号修改密码 */
- (RACSignal *)TopicgcuserForgetPassWithTel:(NSString *)tel addCode:(NSString *)code  addPassword:(NSString *)password;

/** 手机绑定 */
- (RACSignal *)QukangcuserBindWithTel:(NSString *)tel addCode:(NSString *)code addThirdId:(NSString *)thirdId;

/** 获取新手任务*/
- (RACSignal *)QukanNewUserList;


/** 获取用户关注数量 */
- (RACSignal *)QukanMyFollow;

/** 第三方登录 */
- (RACSignal *)QukanUserWithId:(NSString *)thirdFlag addOpenId:(NSString *)openId addUnionid:(NSString *)unionid addNickname:(NSString *)nickname addHeadimgUrl:(NSString *)headimgUrl addAccessToken:(NSString *)accessToken addInvitationCode:(NSString *)invitationCode;

/** 查询友盟未读通知数量接口 */
- (RACSignal *)QukanNoReadMessageWithUserId:(NSString *)userId;


/** 新手机绑定 */
- (RACSignal *)QukangcuserBindWithTel:(NSString *)tel addCode:(NSString *)code addThirdId:(NSString *)thirdId thirdFlag:(NSString *)thirdFlag unionId:(NSString *)unionId;


/** 新第三方登录 */
- (RACSignal *)QukanUserWithId:(NSString *)thirdFlag addOpenId:(NSString *)openId addUnionid:(NSString *)unionid addNickname:(NSString *)nickname addHeadimgUrl:(NSString *)headimgUrl addAccessToken:(NSString *)accessToken umengToken:(NSString *)umengToken invitationCode:(NSString *)invitationCode type:(NSString *)type tel:(NSString *)tel code:(NSString *)code pass:(NSString *)pass;


/**友盟用户加入*/
- (RACSignal *)QukanUserJoinAdd:(NSString *)invitationCode;

/**友盟绑定用户和设备*/
-(RACSignal *)QukanUmengToken:(NSString *)umengToken;

/**赛事信息分享*/
-(RACSignal *)QukangGetId:(NSString *)matchId;

/**分享调用新闻详情*/
-(RACSignal *)QukangGetNewId:(NSString *)newId;

/**检查更新*/
- (RACSignal *)QukancheckAppStoreUpdate;

@end

NS_ASSUME_NONNULL_END
