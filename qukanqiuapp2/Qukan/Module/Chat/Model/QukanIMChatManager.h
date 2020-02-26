//
//  QukanIMChatManager.h
//  Qukan
//
//  Created by leo on 2019/8/24.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NIMSDK/NIMSDK.h>


NS_ASSUME_NONNULL_BEGIN

@interface QukanIMChatManager : NSObject 
@property(nonatomic, strong) NIMMessage   * lastedMessage;



+ (instancetype)sharedInstance;

- (void)logOutChat:(NIMLoginHandler)complet;
- (void)resetChatInfo;

@end

NS_ASSUME_NONNULL_END
