//
//  QukanIMChatManager.m
//  Qukan
//
//  Created by leo on 2019/8/24.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanApiManager+QukanChatApi.h"

@interface QukanIMChatManager () <NIMChatManagerDelegate>

@property(nonatomic, strong) QukanIMAcount *imAccount; // 网易云账号信息

@end

@implementation QukanIMChatManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static QukanIMChatManager *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
        [instance addNotif];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}

- (void)addNotif {  //  因为直播聊天室需要离线模式  所以不能每次登陆登出时重连IM  不然会有问题
//    @weakify(self)
//    [[[kNotificationCenter rac_addObserverForName:kUserDidLogoutNotification object:nil]
//      takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
//        @strongify(self)
//        [self loadIMAccountData];
//    }];
//
//    [[[kNotificationCenter rac_addObserverForName:kUserDidLoginNotification object:nil]
//      takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
//        @strongify(self)
//        [self loadIMAccountData];
//    }];

}

- (void)resetChatInfo {
    [self loadIMAccountData];
    [NIMSDK.sharedSDK.chatManager addDelegate:self];
}

- (void)logOutChat:(NIMLoginHandler)complet{
//    [kNotificationCenter removeObserver:self name:kUserDidLogoutNotification object:nil];
//    [kNotificationCenter removeObserver:self name:kUserDidLoginNotification object:nil];
    [NIMSDK.sharedSDK.chatManager removeDelegate:self];
    [NIMSDK.sharedSDK.loginManager logout:complet];
}
    
#pragma mark ===================== Private Methods =========================

- (void)loadIMAccountData {
    @weakify(self)
    [[[kApiManager QukanacquireIMAccount] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(QukanIMAcount *  _Nullable x) {
        @strongify(self)
        self.imAccount = x;
        [self loadMessages];
    } error:^(NSError * _Nullable error) {
        
    }];
}

- (void)loadMessages {
    // 开始登陆账号  直接接收信息
    [[[NIMSDK sharedSDK] loginManager] login:self.imAccount.fromAccid token:self.imAccount.token completion:^(NSError * _Nullable error) {
        if (error) DEBUGLog(@"%@", error);

        NIMSession *session = [NIMSession session:self.imAccount.toAccid type:NIMSessionTypeP2P];
        NSArray<NIMMessage *> *messages = [[[NIMSDK sharedSDK] conversationManager] messagesInSession:session message:nil limit:10];
        if (messages) {
            self.lastedMessage = messages.lastObject;
        }
    }];
}

#pragma MARK - NIMChatManagerDelegate
- (void)willSendMessage:(NIMMessage *)message {
}

- (void)sendMessage:(NIMMessage *)message didCompleteWithError:(nullable NSError *)error {
    DEBUGLog(@"send message error: %@", error);
    
    if (!error) {
        self.lastedMessage = message;
    }
}

- (void)uploadAttachmentSuccess:(NSString *)urlString
                     forMessage:(NIMMessage *)message {
    
    DEBUGLog(@"%@", message);
}

- (void)sendMessage:(NIMMessage *)message
           progress:(float)progress {
    DEBUGLog(@"ooooooooooooooo %.2f", progress);
}

- (void)onRecvMessages:(NSArray<NIMMessage *> *)messages {
    
    NSArray *realMessages = [messages.rac_sequence filter:^BOOL(NIMMessage *  _Nullable value) {
        return (value.messageType == NIMMessageTypeText || value.messageType == NIMMessageTypeImage) && [value.from containsString:@"3_"];
    }].array;
    
    if (!realMessages.count) return;
    NSString *unReadNumberStr = [NSString stringWithFormat:@"unReadNumber%zd",[QukanUserManager sharedInstance].user.userId];
    NSInteger nuReadNum = [[kUserDefaults objectForKey:unReadNumberStr] integerValue];
    nuReadNum += realMessages.count;
    
    [kUserDefaults setObject:[NSString stringWithFormat:@"%zd",nuReadNum] forKey:unReadNumberStr];
    
    self.lastedMessage = realMessages.lastObject;
}


@end
