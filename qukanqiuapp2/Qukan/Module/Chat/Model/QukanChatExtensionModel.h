//
//  QukanChatExtensionModel.h
//  Qukan
//
//  Created by Jeff on 2019/10/24.
//  Copyright © 2019 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanChatExtensionModel : NSObject

@property(nonatomic, copy) NSString *fromName;
@property(nonatomic, assign) NSInteger fromUserId;
@property(nonatomic, copy) NSString *fromHeadUrl;

@property(nonatomic, copy) NSString *toName;
@property(nonatomic, assign) NSInteger toUserId;
@property(nonatomic, copy) NSString *toHeadUrl;


- (BOOL)isMeSend;

@end

NS_ASSUME_NONNULL_END
