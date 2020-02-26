//
//  QukanChatExtensionModel.m
//  Qukan
//
//  Created by Jeff on 2019/10/24.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanChatExtensionModel.h"

@implementation QukanChatExtensionModel

- (BOOL)isMeSend {
    return self.fromUserId == kUserManager.user.userId;
}

@end
