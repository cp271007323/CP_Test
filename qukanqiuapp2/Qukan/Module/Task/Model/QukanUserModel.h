//
//  QukanUserModel.h
//  Qukan
//
//  Created by pfc on 2019/6/19.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanUserModel :NSObject

//@property (nonatomic , copy) NSString              * beginTime;
@property (nonatomic , copy) NSString              * key;
@property (nonatomic , copy) NSString              * code;
@property (nonatomic , copy) NSString              * tel;
@property (nonatomic , copy) NSString              * nickname;

@property (nonatomic , copy) NSString              * updateTime;
@property (nonatomic , copy) NSString              * endTime;
//@property (nonatomic , copy) NSString              * isZhuanJia;
//@property (nonatomic , copy) NSString              * loginType;
@property (nonatomic , assign) NSInteger              userId;

@property (nonatomic , copy) NSString              * guestTime;
@property (nonatomic , copy) NSString              * token;
@property (nonatomic , copy) NSString              * lastLoginTime;
//@property (nonatomic , copy) NSString              * thirdFlag;
@property (nonatomic , copy) NSString              * appId;
@property (nonatomic , copy) NSString              * avatorId; // 头像地址

//@property (nonatomic , copy) NSString              * remarks;
//@property (nonatomic , copy) NSString              * createTime;
//@property (nonatomic , copy) NSString              * createIp;
//@property (nonatomic , copy) NSString              * updateIp;
@property (nonatomic , copy) NSString              * password;

@property (nonatomic , copy) NSString              * thirdId;
@property (nonatomic , copy) NSString              * username;

@property (nonatomic , copy) NSString              * email;

@end

NS_ASSUME_NONNULL_END
