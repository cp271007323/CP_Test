//
//  QukanApiManager+QukanChatApi.h
//  Qukan
//
//  Created by pfc on 2019/8/15.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanApiManager.h"
#import "QukanIMAcount.h"

NS_ASSUME_NONNULL_BEGIN

@interface QukanApiManager (QukanChatApi)

- (RACSignal *)QukanacquireIMAccount;

- (RACSignal *)QukanacquireUserIMAccount:(NSInteger)userId;

- (RACSignal *)hasSendMessageToCustomerServiceSuccess;

/// 查询用户好友列表
- (RACSignal *)QukanChatFriends;
@end

NS_ASSUME_NONNULL_END
