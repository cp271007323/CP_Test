//
//  QukanLiveChatViewController.m
//  Qukan
//
//  Created by pfc on 2019/7/20.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//  直播聊天

#import "QukanLiveChatViewController.h"
#import "QukanApiManager+Competition.h"
#import "QukanApiManager+info.h"
#import "QukanHomeModels.h"
#import "QukanGDataView.h"

#import <IQKeyboardManager/IQKeyboardManager.h>

#import "QukanLXKeyBoard.h"
#import "QukanLiveChatCell.h"

@interface NIMMessage (QukanHeight)

@property(nonatomic, assign) CGFloat messageHeight;

@end

@implementation NIMMessage  (QukanHeight)

- (void)setMessageHeight:(CGFloat)messageHeight {
    objc_setAssociatedObject(self, @selector(messageHeight), @(messageHeight), OBJC_ASSOCIATION_RETAIN);
}

- (CGFloat)messageHeight {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

@end

@interface QukanLiveChatViewController ()<NIMChatroomManagerDelegate, NIMChatManagerDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property(nonatomic, copy) NSString *chatRoomToken;
@property(nonatomic, copy) NSString *roomId;
@property(nonatomic, copy) NSString *accid; // 网易云账号

@property(nonatomic, assign) NIMChatroomConnectionState connectionState;

@property(nonatomic, assign) BOOL hadGetRoomInfo;
@property(nonatomic, assign) BOOL hadRoomAddres; // 是否获取到房间地址
@property(nonatomic, assign) BOOL hadPullHistoryMessage; // 是否已经拉取了历史记录
@property(nonatomic, assign) BOOL hasRoom; // 比赛聊天室是否开启
@property(nonatomic, assign) BOOL onlyCompere; // 只看主持人聊天，默认NO
@property(nonatomic, assign) BOOL onlyUser; // 只看用户聊天，默认NO

@property(nonatomic, strong) NSMutableArray<NIMMessage *> *chats;
@property(nonatomic, strong) NSArray *allChats;
@property(nonatomic, strong) NSMutableArray<NIMChatroomNotificationMember *> *blackList; // 被禁言的用户

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIButton *tipMessageBtn;

@property(nonatomic, strong) UITextField *textField;
@property(nonatomic, strong) QukanGDataView *Qukan_gView;
@property(nonatomic, strong) QukanHomeModels *model;

@property(nonatomic, assign) BOOL basketballGetRoomInfo;//控制

@property(nonatomic, strong) QukanLXKeyBoard *Qukan_Keyboard;

@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);

/**是否需要显示占位图*/
@property(nonatomic, assign) BOOL   bool_shouldShowEmpty;

/**是否需要显示占位图*/
@property(nonatomic, assign) BOOL   bool_isNetworkError;

@end

@implementation QukanLiveChatViewController

#pragma mark ===================== Life Cycle ==================================

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = kCommentBackgroudColor;
    if (!_isBasketball) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if ([userDefaults stringForKey:@"phpAdvId"].length) {
            NSInteger phpAdvId = [[userDefaults objectForKey:@"phpAdvId"] integerValue];
            [self Qukan_newsChannelHomepWithAd:phpAdvId];
        } else {
            [self qukanAD];
        }
    }
    self.chats = [NSMutableArray array];
    
    [[NIMSDK sharedSDK].chatroomManager addDelegate:self];
    [[NIMSDK sharedSDK].chatManager addDelegate:self];
    
    @weakify(self)
    [[[kNotificationCenter rac_addObserverForName:kUserDidLoginNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        KHideHUD
        [self getRoomAccessInfo];
    }];
    
    [[[kNotificationCenter rac_addObserverForName:UIApplicationDidBecomeActiveNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        if (self.hadRoomAddres && (self.connectionState == NIMChatroomConnectionStateEnterFailed || self.connectionState == NIMChatroomConnectionStateLoseConnection)) {
            [self connectRoom];
        }
    }];
    
    [self getRoomAccessInfo];
    //
    [self createViews];
    
}
- (void)loadView {
    [super loadView];
    self.view = [[UIView alloc] init];
}

- (BOOL)shouldAutorotate {  // 控制转屏
    return  YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}
- (void)setAD:(QukanBasketBallMatchDetailModel *)model {
    if (model.phpAdvId.length) {
        [self Qukan_newsChannelHomepWithAd:model.phpAdvId.integerValue];
    } else {
        [self qukanAD];
    }
}
- (void)qukanAD {
    @weakify(self)
    [[[kApiManager QukanInfoWithType:22] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self dataSourceWith:x];
        
    }];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    
}
- (void)dealloc
{
    [[NIMSDK sharedSDK].chatroomManager removeDelegate:self];
    [[NIMSDK sharedSDK].chatManager removeDelegate:self];
    [[NIMSDK sharedSDK].chatroomManager exitChatroom:self.roomId completion:^(NSError * _Nullable error) {
        
    }];
    
    [[QukanIMChatManager sharedInstance] resetChatInfo];
}

#pragma mark ===================== Layout ====================================

- (void)createViews {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = kCommentBackgroudColor;
    _tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.emptyDataSetSource = self;
    _tableView.emptyDataSetDelegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [UIView new];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    _tableView.mj_header = [QukanHomeRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullHistoryMessage)];
    
    [_tableView registerClass:[QukanLiveChatCell class] forCellReuseIdentifier:@"QukanLiveChatCellID"];
    
    [_tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).mas_offset(- (kBottomBarHeight - kSafeAreaBottomHeight));
    }];
}

#pragma mark ===================== public Methods ==================================
- (void)showInputView {
    self.Qukan_Keyboard.placeholder = @"我也聊聊~";
    [self.Qukan_Keyboard becomeFirstResponder];
}

- (void)onlyCompClick:(UIButton *)btn {
    self.onlyCompere = btn.selected;
    self.onlyUser = !btn.selected;
//    if (!self.onlyCompere && !self.onlyUser) { // 只看主持人
//        self.onlyCompere = YES;
//        self.onlyUser = NO;
//    }else if (self.onlyCompere && !self.onlyUser) { // 只看用户
//        self.onlyUser = YES;
//        self.onlyCompere = NO;
//    }else if (self.onlyUser && !self.onlyCompere) { // 只看主持人
//        self.onlyCompere = YES;
//        self.onlyUser = NO;
//    }
    
//    self.onlyCompere = !self.onlyCompere;
    [self pullNewestHistoryMessageWithButton:btn];
}

#pragma mark ===================== Private Methods =========================

- (void)connect {
    
}

/// 获取房间信息
- (void)getRoomAccessInfo {
    if (![QukanTool Qukan_xuan:kQukan17] && _isBasketball) {
        return;
    }
    
    [self getRoomAddress];
    @weakify(self)
    [[kApiManager Qukan_getTokenForType:_isBasketball?4:1 matchId:self.matchId] subscribeNext:^(NSDictionary *  _Nullable x) {
        @strongify(self)
        KHideHUD
        self.bool_shouldShowEmpty = YES;
        if (!self.hadGetRoomInfo) {
            [self.chats addObject: [self buildMessageWithText:@"欢迎到看球大师聊天室，看球大师提倡健康文明的聊天室环境。"]];
        }
        self.hadGetRoomInfo = YES;
        
        self.roomId = [x stringValueForKey:@"roomid" default:nil];
        self.chatRoomToken = [x stringValueForKey:@"token" default:nil];
        self.accid = [x stringValueForKey:@"accid" default:nil];

        [self connectRoom];
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        KHideHUD
        self.bool_shouldShowEmpty = YES;
        self.bool_isNetworkError = YES;
        [self.tableView reloadData];
    }];
}

- (void)setRoomId:(NSString *)roomId {
    _roomId = [roomId copy];
    if (roomId) {
        self.hasRoom = YES;
        self.Qukan_FooterView.titleLabel.text = kUserManager.isLogin ? @"我也聊聊~" : @"请先登录";
        @weakify(self)
        self.Qukan_FooterView.putBlock = ^(NSInteger type) {
            @strongify(self)
            kGuardLogin
            self.Qukan_Keyboard.placeholder = kUserManager.isLogin ? @"我也聊聊~" : @"请先登录";
            [self.Qukan_Keyboard becomeFirstResponder];
        };
    }else {
        self.Qukan_FooterView.titleLabel.text = @"暂未开放聊天室，无法聊天";
        self.Qukan_FooterView.putBlock = ^(NSInteger type) {
        };
    }
}

- (void)setHadRoomAddres:(BOOL)hadRoomAddres {
    if (_hadRoomAddres != hadRoomAddres) {
        _hadRoomAddres = hadRoomAddres;
    }
    
    if (!hadRoomAddres) {
        self.Qukan_FooterView.titleLabel.text = @"聊天室已关闭，无法聊天";
        self.Qukan_FooterView.putBlock = ^(NSInteger type) {};
    }else {
        self.Qukan_Keyboard.placeholder = kUserManager.isLogin ? @"我也聊聊~" : @"请先登录";
        @weakify(self)
        self.Qukan_FooterView.putBlock = ^(NSInteger type) {
            @strongify(self)
            kGuardLogin
            self.Qukan_Keyboard.placeholder = @"我也聊聊~";
            [self.Qukan_Keyboard becomeFirstResponder];
        };
    }
}

- (NIMMessage *)buildMessageWithText:(NSString *)text {
    // 构造出具体消息
    NIMMessage *message = [[NIMMessage alloc] init];
    NIMMessageChatroomExtension *ext = [NIMMessageChatroomExtension new];
    ext.roomNickname = @"看球大师";
    message.messageExt = ext;
    message.text        = text;
    message.messageHeight = 40;
    message.localExt = @{@"app": @(YES)};
    
    message.messageHeight = [self heightForMessage:message];
    return message;
}

/// 获取房间地址
- (void)getRoomAddress {
    @weakify(self)
    [NIMChatroomIndependentMode registerRequestChatroomAddressesHandler:^(NSString * _Nonnull roomId,
                                                                          NIMRequestChatroomAddressesCallback  _Nonnull callback) {
        @strongify(self)
        KHideHUD
        [[kApiManager Qukan_getListAddre:self.roomId andType:self.isBasketball?4:1] subscribeNext:^(id  _Nullable x) {
            if ([x isKindOfClass:[NSArray class]]) {
                NSArray *arr = (NSArray *)x;
                self.hadRoomAddres = arr.count > 0;
            }
            callback(nil, x);
        } error:^(NSError * _Nullable error) {
            KHideHUD
            
            callback(error, nil);
        }];
    }];
}

/// 连接房间
- (void)connectRoom {
    NIMChatroomEnterRequest *request = [[NIMChatroomEnterRequest alloc] init];
    request.roomId = self.roomId;
    request.roomNickname = kUserManager.isLogin ? kUserManager.user.nickname : @"外星人";
    request.roomAvatar = kUserManager.isLogin ? kUserManager.user.avatorId : @"";
    request.retryCount = 1;
    
    NIMChatroomIndependentMode *independentModel = [NIMChatroomIndependentMode new];
    independentModel.username = kUserManager.isLogin ? self.accid : nil;
    independentModel.token = self.chatRoomToken;
    request.mode = independentModel;
    
    KShowHUD;
    @weakify(self)
    [[[NIMSDK sharedSDK] chatroomManager] enterChatroom:request completion:^(NSError *error,NIMChatroom *chatroom,NIMChatroomMember *me) {
        @strongify(self)
        KHideHUD
        self.bool_shouldShowEmpty = YES;
        if (error == nil){
            if (!self.hadPullHistoryMessage) {
                [self pullHistoryMessage];
            }
        }else{// 连接房间失败
             DEBUGLog(@"连接房间失败：%@", error);
            self.bool_shouldShowEmpty = YES;
            [self.chats removeAllObjects];
            [self.chats insertObject:[self buildMessageWithText:@"欢迎到看球大师聊天室，看球大师提倡健康文明的聊天室环境。"] atIndex:0];
            [self.tableView reloadData];
         }
    }];
}

/// 拉取历史聊天记录
- (void)pullHistoryMessage {
    NIMHistoryMessageSearchOption *option = [[NIMHistoryMessageSearchOption alloc] init];
    option.limit = 20;
    if (self.chats.count > 1) {
        NIMMessage *message = [self.chats objectAtIndex:1];
        option.startTime = message.timestamp - 1;
        option.order = NIMMessageSearchOrderDesc;
    } else {
        option.startTime = 0;
    }
    
    @weakify(self)
    [[NIMSDK sharedSDK].chatroomManager fetchMessageHistory:self.roomId option:option result:^(NSError *error, NSArray *messages) {
        @strongify(self)
        self.bool_shouldShowEmpty = YES;
        [self.tableView.mj_header endRefreshing];
        NSArray *chats = [[messages reverseObjectEnumerator] allObjects];
        
        NSArray *filterChats = [chats.rac_sequence filter:^BOOL(NIMMessage *  _Nullable value) {
            return self.onlyCompere ? [value.from isEqualToString:@"1_0"] : YES;
        }].array;
        @weakify(self)
        [filterChats enumerateObjectsUsingBlock:^(NIMMessage *  _Nonnull message, NSUInteger idx, BOOL * _Nonnull stop) {
            @strongify(self)
            self.hadPullHistoryMessage = YES;
            message.messageHeight = [self heightForMessage:message];
        }];
      
        if (self.chats.count > 1) {
            NSMutableArray *temp = NSMutableArray.new;
            [self.chats removeObjectAtIndex:0];
            [temp addObjectsFromArray:self.chats];
            [self.chats removeAllObjects];
            [self.chats insertObject:[self buildMessageWithText:@"欢迎到看球大师聊天室，看球大师提倡健康文明的聊天室环境。"] atIndex:0];
            [self.chats addObjectsFromArray:chats];
            [self.chats addObjectsFromArray:temp];
            [self.tableView reloadData];
//            [self.chats addObjectsFromArray:chats];
        } else {
            [self.chats addObjectsFromArray:chats];
            [self.tableView reloadData];
            [self gotoLastRow:NO];
        }
    }];
}

- (void)pullNewestHistoryMessageWithButton:(UIButton *)btn {
    btn.enabled = NO;
    NIMHistoryMessageSearchOption *option = [[NIMHistoryMessageSearchOption alloc] init];
    option.startTime = 0;
    option.limit = 50;
    
    @weakify(self)
    [[NIMSDK sharedSDK].chatroomManager fetchMessageHistory:self.roomId option:option result:^(NSError *error, NSArray *messages) {
        @strongify(self)
        [self.chats  removeAllObjects];
        NSArray *chats = [[messages reverseObjectEnumerator] allObjects];
        
        NSArray *filterChats = chats;
        if (self.onlyCompere && !self.onlyUser) {
            filterChats = [chats.rac_sequence filter:^BOOL(NIMMessage *  _Nullable value) {
                return [value.from isEqualToString:@"1_0"];
            }].array;
        }else if (self.onlyUser && !self.onlyCompere) {
            filterChats = [chats.rac_sequence filter:^BOOL(NIMMessage *  _Nullable value) {
                return ![value.from isEqualToString:@"1_0"];
            }].array;
        }
        
        @weakify(self)
        [filterChats enumerateObjectsUsingBlock:^(NIMMessage *  _Nonnull message, NSUInteger idx, BOOL * _Nonnull stop) {
            @strongify(self)
            self.hadPullHistoryMessage = YES;
            message.messageHeight = [self heightForMessage:message];
        }];
        [self.chats addObjectsFromArray:filterChats];
        self.allChats = [NSArray arrayWithArray:filterChats];
//        [self gotoLastRow:NO];

        if (self.onlyCompere && !self.onlyUser) {
            filterChats = [chats.rac_sequence filter:^BOOL(NIMMessage *  _Nullable value) {
                return [value.from isEqualToString:@"1_0"];
            }].array;
            self.allChats = [NSArray arrayWithArray:filterChats];
            [self.chats insertObject:[self buildMessageWithText:@"欢迎到看球大师聊天室，看球大师提倡健康文明的聊天室环境。"] atIndex:0];
        }else if (self.onlyUser && !self.onlyCompere) {
            filterChats = [chats.rac_sequence filter:^BOOL(NIMMessage *  _Nullable value) {
                return ![value.from isEqualToString:@"1_0"];
            }].array;
            self.allChats = [NSArray arrayWithArray:filterChats];
            [self.chats insertObject:[self buildMessageWithText:@"欢迎到看球大师聊天室，看球大师提倡健康文明的聊天室环境。"] atIndex:0];
        }

        [self.tableView reloadData];
        
        btn.enabled = YES;
    }];
}


/// 发送消息
- (void)sendMessage:(NSString *)text {
    text = [text stringByTrim];
    if (!text.length) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入有效内容" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    //    NIMLocalAntiSpamCheckOption *option = [NIMLocalAntiSpamCheckOption new];
    //    option.content = text;
    //    NSError *errors;
    //    NIMLocalAntiSpamCheckResult *checkResult = [[NIMSDK sharedSDK].antispamManager checkLocalAntispam:option error:&errors];
    //    if (errors) {
    //        DEBUGLog(@"%@", errors);
    //    }
    //    if (checkResult.type != NIMAntiSpamResultNotHit) {
    //        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"垃圾词语" preferredStyle:UIAlertControllerStyleAlert];
    //        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
    //        [alert addAction:cancel];
    //        [self presentViewController:alert animated:YES completion:nil];
    //
    //        return;
    //    }
    
    // 构造出具体会话
    NIMSession *session = [NIMSession session:self.roomId type:NIMSessionTypeChatroom];
    // 构造出具体消息
    NIMMessage *message = [[NIMMessage alloc] init];
    NIMMessageChatroomExtension *extension = [NIMMessageChatroomExtension new];
    // 发送者姓名
    extension.roomNickname = kUserManager.user.nickname.length > 0 ? kUserManager.user.nickname : @"外星人";
    // 发送者头像
    extension.roomAvatar = kUserManager.user.avatorId.length > 0 ? kUserManager.user.avatorId : @"";
    message.messageExt = extension;
    // 发送文本
    message.text        = text;
    message.messageHeight = [self heightForMessage:message];
    // 错误反馈对象
    NSError *error = nil;
    // 发送消息
    [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:&error];
}

- (BOOL)isCompereMessage:(NIMMessage *)message {
    return [message.from isEqualToString:@"1_0"];
}

- (void)getBlackListIfHave {
    
    if (!_blackList) {
        _blackList = [NSMutableArray arrayWithCapacity:10];
    }
    
    @synchronized (self) {
        for (NIMMessage *message in self.chats) {
            if (message.messageType != NIMMessageTypeNotification) {
                return;
            }
            
            NIMNotificationObject *notiObj = (NIMNotificationObject *)message.messageObject;
            if (notiObj.notificationType != NIMNotificationTypeChatroom) {
                return;
            }
            
            NIMChatroomNotificationContent *content = (NIMChatroomNotificationContent *)notiObj.content;
            NSArray *targets = content.targets ?: @[];
            
            @weakify(self)
            void (^removeBlackList)(NSArray *members) = ^void(NSArray *members) {
                @strongify(self)
                if (!self.blackList.count) {
                    return;
                }
                
                NSMutableArray *arr = [NSMutableArray arrayWithArray:self.blackList];
                for (NIMChatroomMember *member in members) {
                    for (NIMChatroomMember *blackMember in self.blackList) {
                        if ([member.userId isEqualToString:blackMember.userId] && [arr containsObject:blackMember]) {
                            [arr removeObject:blackMember];
                        }
                    }
                }
                self.blackList = [NSMutableArray arrayWithArray:arr];
            };
            
            switch (content.eventType) {
                case NIMChatroomEventTypeRemoveMute:
                case NIMChatroomEventTypeRemoveMuteTemporarily:
                case NIMChatroomEventTypeRemoveBlack:
                    removeBlackList(targets);
                    break;
                case NIMChatroomEventTypeAddMute:
                case NIMChatroomEventTypeAddBlack:
                case NIMChatroomEventTypeKicked:
                case NIMChatroomEventTypeAddMuteTemporarily:
                    [self.blackList addObjectsFromArray:targets];
                    break;
                    
                default:
                    break;
            }
        }
    }
    
}

- (void)filterBlackListMembersSpeak {
    if (!self.blackList.count) {
        return;
    }
    
    @synchronized (self) {
        NSMutableArray *chats = [NSMutableArray arrayWithArray:self.chats];
        for (NIMChatroomMember *member in self.blackList) {
            for (NIMMessage *message in self.chats) {
                if ([message.from isEqualToString:member.userId] && [chats containsObject:message]) {
                    [chats removeObject:message];
                }
            }
        }
        
        self.chats = [NSMutableArray arrayWithArray:chats];
    }
    
}


- (NSString *)messageTextForNotificationMessage:(NIMMessage *)message {
    if (message.messageType != NIMMessageTypeNotification) {
        return nil;
    }
    
    NIMNotificationObject *notiObj = (NIMNotificationObject *)message.messageObject;
    if (notiObj.notificationType != NIMNotificationTypeChatroom) {
        return nil;
    }
    
    NIMChatroomNotificationContent *content = (NIMChatroomNotificationContent *)notiObj.content;
    
    NSString *txt;
    switch (content.eventType) {
        case NIMChatroomEventTypeEnter:
            txt = @"进入聊天室";
            break;
        case NIMChatroomEventTypeAddMute:
            txt = @"已被管理员禁言";
            break;
        case NIMChatroomEventTypeRemoveMute:
            txt = @"被管理员取消禁言";
            break;
        case NIMChatroomEventTypeAddBlack:
            txt = @"被管理员拉黑";
            break;
        case NIMChatroomEventTypeRemoveBlack:
            txt = @"被管理员取消拉黑";
            break;
        case NIMChatroomEventTypeClosed:
            txt = @"管理员关闭了聊天室";
            break;
        case NIMChatroomEventTypeKicked:
            txt = @"被管理员移出聊天室";
            break;
        case NIMChatroomEventTypeRoomMuted:
            txt = @"聊天室禁言中";
            break;
        case NIMChatroomEventTypeAddMuteTemporarily:
            txt = @"被管理员临时禁言";
            break;
        case NIMChatroomEventTypeRemoveMuteTemporarily:
            txt = @"被管理员解除临时禁言";
            break;
            
        default:
            break;
    }
    
    NSArray *names = [content.targets.rac_sequence map:^id _Nullable(NIMChatroomNotificationMember * _Nullable value) {
        return [value.userId isEqualToString:self.accid] ? @"您" : value.nick;
    }].array;
    
    
    if (names.count) {
        NSString *nicks = [names componentsJoinedByString:@","];
        return [NSString stringWithFormat:@"%@ %@", nicks, txt];
    }
    
    return txt == nil ? @"" : txt;
}
/**
 *  成员进入聊天室
*/

//NIMChatroomEventTypeEnter         = 301,
///**
// *  成员离开聊天室
// */
//NIMChatroomEventTypeExit          = 302,
///**
// *  成员被拉黑
// */
//NIMChatroomEventTypeAddBlack      = 303,
///**
// *  成员被取消拉黑
// */
//NIMChatroomEventTypeRemoveBlack   = 304,
///**
// *  成员被设置禁言
// */
//NIMChatroomEventTypeAddMute       = 305,
///**
// *  成员被取消禁言
// */
//NIMChatroomEventTypeRemoveMute    = 306,
///**
// *  设置为管理员
// */
//NIMChatroomEventTypeAddManager    = 307,
///**
// *  移除管理员
// */
//NIMChatroomEventTypeRemoveManager = 308,
///**
// *  设置为固定成员
// */
//NIMChatroomEventTypeAddCommon     = 309,
///**
// *  取消固定成员
// */
//NIMChatroomEventTypeRemoveCommon  = 310,
///**
// *  聊天室被关闭
// */
//NIMChatroomEventTypeClosed        = 311,
///**
// *  聊天室信息更新
// */
//NIMChatroomEventTypeInfoUpdated   = 312,
///**
// *  聊天室成员被踢
// */
//NIMChatroomEventTypeKicked        = 313,
///**
// *  聊天室成员被临时禁言
// */
//NIMChatroomEventTypeAddMuteTemporarily   = 314,
///**
// *  聊天室成员被解除临时禁言
// */
//NIMChatroomEventTypeRemoveMuteTemporarily = 315,
///**
// *  聊天室成员主动更新了聊天室的角色信息
// */
//NIMChatroomEventTypeMemberUpdateInfo = 316,
///**
// *  聊天室通用队列变更的通知
// */
//NIMChatroomEventTypeQueueChange = 317,
///**
// *  聊天室被禁言了，只有管理员可以发言,其他人都处于禁言状态
// */
//NIMChatroomEventTypeRoomMuted = 318,

- (CGFloat)heightForMessage:(NIMMessage *)message {
    NSString *txt = message.text;
    
    CGFloat height = [txt heightForFont:[UIFont systemFontOfSize:14] width:kScreenWidth-86];
    
    return height+40;
}

- (BOOL)scrollViewContentAtBottom {
    CGFloat height = self.tableView.bounds.size.height + 15;
    CGFloat distanceFromBottom = self.tableView.contentSize.height - self.tableView.contentOffset.y;
    
    return distanceFromBottom <= height;
}

-(void)insertRowAtIndex:(unsigned long)n rows:(NSInteger)rowsCount section:(int)section {
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    for (int i = 0; i < rowsCount; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:n+i inSection:section];
        [indexPaths addObject:indexPath];
    }
    
    @try {
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    }
    @catch (NSException * e) {
        [self.tableView endUpdates];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
}

- (void) gotoLastRow:(BOOL)animated {
    dispatch_block_t scrollBottomBlock = ^ {
        long row = [self.tableView numberOfRowsInSection:0]-1;
        if (row >= 1) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]
                                  atScrollPosition:UITableViewScrollPositionBottom
                                          animated:animated];
        }
    };

    if (animated) {
        //when use `estimatedRowHeight` and `scrollToRowAtIndexPath` at the same time, there are some issue.
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            scrollBottomBlock();
        });
    } else {
        scrollBottomBlock();
    }
}


- (void)Qukan_newsChannelHomepWithAd:(NSInteger)adId {
    @weakify(self)
    [[[kApiManager QukanInfoWithType:41 withid:adId] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self dataSourceWith:x];
    } error:^(NSError * _Nullable error) {
    }];
}

- (void)dataSourceWith:(id)response {
    NSArray *array = (NSArray *)response;
    if (!array.count) {return;}
    for (NSDictionary *dict in array) {
        QukanHomeModels *model = [QukanHomeModels modelWithDictionary:dict];
        self.model = model;
    }
    [self setShowView];
}

- (void)setShowView {
    
    if (!self.model) return;
    [self.Qukan_gView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.equalTo(@(68));
    }];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.Qukan_gView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).mas_offset(-(kBottomBarHeight - kSafeAreaBottomHeight));
    }];
    
    //设置ad
    [self.Qukan_gView Qukan_setAdvWithModel:self.model];
    @weakify(self)
    self.Qukan_gView.dataImageView_didBlock = ^{
        @strongify(self)
        if (self.liveChatVc_didBolck) {
            self.liveChatVc_didBolck(self.model);
        }
    };
}



#pragma mark ===================== UITableViewDataSource, UITableViewDelegate =================================

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback ?: self.scrollCallback(self.tableView);
    if ([self scrollViewContentAtBottom]) {
        self.tipMessageBtn.hidden = YES;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chats.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NIMMessage *msg = (self.chats.count > indexPath.row) ? self.chats[indexPath.row] : [NIMMessage new];
    
    return msg.messageHeight > 30 ? msg.messageHeight : 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if (section == 0 && self.chats.count > 0) {
//        return 42;
//    }
    return 0.001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView *header = [UIView new];
//    header.backgroundColor = kCommentBackgroudColor;
//    UIImageView *img = [UIImageView new];
//    img.image = kImageNamed(@"Qukan_chuisao");
//    [header addSubview:img];
//    [img mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(header);
//        make.left.equalTo(header).offset(20);
//    }];
//
//    UILabel *lab = [UILabel new];
//    lab.text = @"聊天室公告：任何账号、广告均为诈骗，违规者封号处理";
//    lab.textColor = kCommonDarkGrayColor;
//    lab.font = [UIFont systemFontOfSize:10];
//
//    [header addSubview:lab];
//    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(header);
//        make.left.equalTo(img.mas_right).offset(5);
//    }];
//    return header;
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QukanLiveChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QukanLiveChatCellID"];
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"QukanLiveChatCellID" forIndexPath:indexPath];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
    NIMMessage *message = self.chats[indexPath.row];
    
    [cell fullCellWithMessage:message isBasket:self.isBasketball];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark ===================== NIMChatroomManagerDelegate ==================================

- (void)chatroom:(NSString *)roomId connectionStateChanged:(NIMChatroomConnectionState)state {
    self.connectionState = state;
    if (state == NIMChatroomConnectionStateEntering) {
        DEBUGLog(@"正在进入房间");
        if (self.connectionState != state && self.connectionState != NIMChatroomConnectionStateEnterFailed) {
            //            NSString *str = kUserManager.isLogin ? @"正在进入房间..." : @"房间连接中...";
            //            [self.chats addObject:[self buildMessageWithText:str]];
        }
        //        [self insertRowAtIndex:self.chats.count-1 rows:1 section:0];
    }else if (state == NIMChatroomConnectionStateEnterOK) {
                DEBUGLog(@"成功进入房间");
        //        NSString *str = kUserManager.isLogin ? @"成功进入房间." : @"成功连接房间.";
        //        [self.chats addObject:[self buildMessageWithText:str]];
        //        [self insertRowAtIndex:self.chats.count-1 rows:1 section:0];
    }else if (state == NIMChatroomConnectionStateEnterFailed) {
                DEBUGLog(@"进入房间失败");
        //        [self.chats addObject:[self buildMessageWithText:@"进入房间失败."]];
    }else if (state == NIMChatroomConnectionStateLoseConnection) {
                DEBUGLog(@"与房间失去连接.");
        //        [self.chats addObject:[self buildMessageWithText:@"房间连接已断开."]];
        //        [self insertRowAtIndex:self.chats.count-1 rows:1 section:0];
    }
    
    self.connectionState = state;
    
    [self.tableView reloadData];
}

/**
 *  聊天室自动登录出错
 *
 *  @param roomId 聊天室Id
 *  @param error  自动登录出错原因
 */
- (void)chatroom:(NSString *)roomId autoLoginFailed:(NSError *)error {
    
}

#pragma mark ===================== NIMChatManagerDelegate ==================================

- (void)sendMessage:(NIMMessage *)message didCompleteWithError:(nullable NSError *)error {
    if (!error) {
        [self.chats addObject:message];
        [self insertRowAtIndex:self.chats.count-1 rows:1 section:0];
        [self gotoLastRow:YES];
    }else if (error) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
}


/**
 *  收到消息回调
 *
 *  @param messages 消息列表,内部为NIMMessage
 */
- (void)onRecvMessages:(NSArray<NIMMessage *> *)messages {
    @weakify(self)
//    NSArray *filterMessages = [messages.rac_sequence filter:^BOOL(NIMMessage *  _Nullable value) {
//        @strongify(self)
//        BOOL con = self.onlyCompere ? [self isCompereMessage:value] : YES;
//        return con && ![value.from containsString:@"5_"];
//    }].array;
    
    NSArray *filterMessages = messages;
    if (self.onlyCompere && !self.onlyUser) {
        filterMessages = [messages.rac_sequence filter:^BOOL(NIMMessage *  _Nullable value) {
            return [value.from isEqualToString:@"1_0"];
        }].array;
    }else if ((self.onlyUser && !self.onlyCompere) || self.isBasketball) {
        filterMessages = [messages.rac_sequence filter:^BOOL(NIMMessage *  _Nullable value) {
            return ![value.from isEqualToString:@"1_0"] && ![value.from isEqualToString:@"5_0"] && ![value.from isEqualToString:@"5_0"];
        }].array;
    }
    
    [filterMessages enumerateObjectsUsingBlock:^(NIMMessage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self)
        obj.messageHeight = [self heightForMessage:obj];
    }];
    [self.chats addObjectsFromArray:filterMessages];
    
    BOOL needRemoveBlackListSpeak = NO;
    for (NIMMessage *message in messages) {
        if (message.messageType == NIMMessageTypeNotification) {
            needRemoveBlackListSpeak = YES;
            break;
        }
    }
    
    if (needRemoveBlackListSpeak) {
        [self getBlackListIfHave];
        [self filterBlackListMembersSpeak];
    }
    
    if ([self scrollViewContentAtBottom]) {
        self.tipMessageBtn.hidden = YES;
        [self insertRowAtIndex:self.chats.count-filterMessages.count rows:filterMessages.count section:0];
        [self gotoLastRow:YES];
    }else {
        self.tipMessageBtn.hidden = NO;
        [self insertRowAtIndex:self.chats.count-filterMessages.count rows:filterMessages.count section:0];
    }
}

- (void)handleMessage {
    
}

#pragma mark =========== JXCategoryView/JXCategoryListContainerView==================================
- (UIView *)listView{
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.tableView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

#pragma mark ===================== Getters =================================

- (UIButton *)tipMessageBtn {
    if (!_tipMessageBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.hidden = YES;
        _tipMessageBtn = btn;
        btn.titleLabel.font = kFont14;
        btn.layer.cornerRadius = 10;
        btn.layer.masksToBounds = YES;
        btn.titleLabel.font = kFont12;
        [btn setTitle:@"有新的消息" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor orangeColor];
        [self.view addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.width.mas_equalTo(70);
            make.height.mas_equalTo(30);
            make.bottom.equalTo(self.view.mas_bottom).offset(-60-kSafeAreaBottomHeight);
        }];
        
        @weakify(self)
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            btn.hidden = YES;
            [self gotoLastRow:YES];
        }];
    }
    
    return _tipMessageBtn;
}

- (QukanLXKeyBoard *)Qukan_Keyboard {
    if (!_Qukan_Keyboard) {
        _Qukan_Keyboard =[[QukanLXKeyBoard alloc]initWithFrame:CGRectZero];
        _Qukan_Keyboard.backgroundColor =[UIColor whiteColor];
        _Qukan_Keyboard.maxLine = 3;
        _Qukan_Keyboard.font = [UIFont systemFontOfSize:14];
        _Qukan_Keyboard.topOrBottomEdge = 15;
        _Qukan_Keyboard.yOffset = [self.view convertRect:self.view.frame toView:self.view.window].origin.y;
        [_Qukan_Keyboard beginUpdateUI];
        [self.view addSubview:_Qukan_Keyboard];
        _Qukan_Keyboard.placeholder = @"我也聊聊~";
        
        @weakify(self)
        _Qukan_Keyboard.sendBlock = ^(NSString *text) {
            @strongify(self)
            //            self.liveChatVcBolck(YES);
            [self.Qukan_Keyboard endEditing];
            [self.Qukan_Keyboard clearText];
            if (text.length>0) {
                [self sendMessage:text];
            }
            self.Qukan_Keyboard.placeholder = @"我也聊聊~";
        };
    }
    return _Qukan_Keyboard;
}

- (UIView *)Qukan_gView {
    if (!_Qukan_gView) {
        _Qukan_gView = [[QukanGDataView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
        [self.view addSubview:_Qukan_gView];
        [_Qukan_gView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.left.equalTo(self.view).offset(0);
            make.right.equalTo(self.view).offset(0);
            make.height.mas_equalTo(68);
        }];
    }
    return _Qukan_gView;
}


#pragma mark =========================== DZNEmptyDataSetSource ===========================
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *description = @"暂无数据";
    if (self.bool_isNetworkError == YES) {
        description = @"网络错误";
    }
    return [[NSAttributedString alloc] initWithString:description attributes:@{NSFontAttributeName : kFont16,NSForegroundColorAttributeName : [UIColor grayColor]}];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *imageName = @"nodate_footBall";
    if (_isBasketball) {
        imageName = @"nodata_basketBall";
    }
    if (self.bool_isNetworkError == YES) {
        imageName = @"Qukan_network";
    }
    return [UIImage imageNamed:imageName];
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    KShowHUD
    self.bool_shouldShowEmpty = NO;
    self.bool_isNetworkError = NO;
    [self.tableView reloadEmptyDataSet];
    [self getRoomAccessInfo];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return kCommentBackgroudColor;
}

//- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
//    return -kScreenWidth*(212/375.0) / 2;
//}

#pragma mark - DZNEmptyDataSetDelegate

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return self.bool_shouldShowEmpty;
}


@end
