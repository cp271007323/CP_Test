//
//  QukanChatViewController.m
//  Qukan
//
//  Created by wdk on 2019/8/14.
//  Copyright © 2019 Beijing Xinmengxiang. All rights reserved.
//

#import "QukanChatViewController.h"
#import "QukanTextMessageCell.h"
#import "QukanImageMessageCell.h"

#import "QukanApiManager+QukanChatApi.h"
#import "QukanNewsComentView.h"
#import "QukanLXKeyBoard.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import <IQKeyboardManager/IQKeyboardManager.h>

//#import "QukanYBImageBrowser.h"
#import "QukanChatExtensionModel.h"

#import "QukanSensitiveTextTool.h"
#import <KSPhotoBrowser.h>
#define kAccessoryViewHeight 100

@interface QukanChatViewController ()<UITableViewDelegate, UITableViewDataSource, MessageTableViewCellDelegate, NIMChatManagerDelegate, TZImagePickerControllerDelegate>

@property(nonatomic, assign) NSInteger page;
@property(nonatomic, assign) NSInteger pageSize;
@property(nonatomic, strong) NSMutableArray<NIMMessage*> *messages;
@property(nonatomic, strong) QukanIMAcount *imAccount; // 网易云账号信息

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) UIImagePickerController *pickerVC;
@property(nonatomic, strong) UIButton *controlBtn;
@property(nonatomic, strong) UIView *operationView;
@property(nonatomic, strong) QukanNewsComentView *footerView;
@property(nonatomic, strong) QukanLXKeyBoard *keyboard;

//从会话列表进入的时候这个不为空，需要使用这个，   从私信过来的时候这个字段为空
@property(nonatomic, strong) NIMSession *session;

@property(nonatomic, strong) NSString *senderAvatarUrl;

@property(nonatomic, assign) NSInteger userId; // 对方的id 大于0是和用户聊天
@property(nonatomic, copy) NSString *chatHeadUrl;

@property(nonatomic, strong) NSString* chatName; // 对话标题

@end

@implementation QukanChatViewController

#pragma mark ===================== Life Cycle ==================================

- (instancetype)initWithUserId:(NSInteger)userId headUrl:(NSString *)urlString {
    if(self = [super init]){
        self.userId = userId;
        self.chatHeadUrl = urlString;
        self.chatName = @"官方客服";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.chatName;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    
    //    self.navigationController.navigationBar.translucent = NO;
    
    //    self.edgesForExtendedLayout = UIRectEdgeNone;
    _messages = [NSMutableArray array];
    _page = 0;
    _pageSize = 10;
    
    [self initSubViews];
    KShowHUD
    if (self.userId>0) {
        if(self.session){
            [self loadMessages];
        }else{
            [self loadUserIMAccount];
        }
    }else {
        [self loadIMAccountData];
    }
    
    [NIMSDK.sharedSDK.chatManager addDelegate:self];
    
    NSString *unReadNumberStr = [NSString stringWithFormat:@"unReadNumber%zd",[QukanUserManager sharedInstance].user.userId];
    // 设置未读信息数量为0
    [kUserDefaults setObject:@"0" forKey:unReadNumberStr];
    
    @weakify(self);
    [[[kNotificationCenter rac_addObserverForName:UIKeyboardWillShowNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        NSNotification *noti = x;
        NSDictionary *dicInfo = noti.userInfo;
        
        CGFloat duration = [[dicInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
        CGRect keyboardRect = [[dicInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
        
        //        self.tableView.backgroundColor = UIColor.blueColor;
        
        [UIView animateWithDuration:duration animations:^{
            self.tableView.frame = CGRectMake(0, kTopBarHeight, kScreenWidth, keyboardRect.origin.y - 44 - kTopBarHeight);
            
            [self gotoLastRow:YES];
        }];
        
        
        
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    }];
    
    [[[kNotificationCenter rac_addObserverForName:UIKeyboardWillHideNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        NSNotification *noti = x;
        NSDictionary *dicInfo = noti.userInfo;
        
        CGFloat duration = [[dicInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
        
        
        //        self.tableView.backgroundColor = UIColor.blueColor;
        
        [UIView animateWithDuration:duration animations:^{
            self.tableView.frame = CGRectMake(0, kTopBarHeight, kScreenWidth, kScreenHeight  - kTopBarHeight - kSafeAreaBottomHeight - 49);
        }];
        
        
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    
    NSString *unReadNumberStr = [NSString stringWithFormat:@"unReadNumber%zd",[QukanUserManager sharedInstance].user.userId];
    
    // 设置未读信息数量为0
    [kUserDefaults setObject:@"0" forKey:unReadNumberStr];
}

- (void)dealloc {
    [NIMSDK.sharedSDK.chatManager removeDelegate:self];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)initSubViews {
    [self.view addSubview:self.footerView];
    
    NSLog(@"%.2f,%.2f",kTopBarHeight,kSafeAreaBottomHeight);
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopBarHeight, kScreenWidth, kScreenHeight  - kTopBarHeight - kSafeAreaBottomHeight - 49) style:UITableViewStylePlain];
    
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    _tableView.estimatedRowHeight = 0.0f;
    _tableView.estimatedSectionFooterHeight = 0.0f;
    _tableView.estimatedSectionHeaderHeight = 0.;
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    //    _tableView.backgroundColor = UIColor.redColor;
    _tableView.backgroundColor = HEXColor(0xF8F8F8);
    //    _tableView.estimatedRowHeight = 50;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [_tableView registerClass:[QukanTextMessageCell class] forCellReuseIdentifier:NSStringFromClass([QukanTextMessageCell class])];
    [_tableView registerClass:[QukanImageMessageCell class] forCellReuseIdentifier:NSStringFromClass([QukanImageMessageCell class])];
    [self.view addSubview:_tableView];
}



#pragma mark ===================== UITableViewDataSource, UITableViewDelegate =================================

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NIMMessage *msg = self.messages[indexPath.row];
    NSString *reuseIdentify = NSStringFromClass([QukanTextMessageCell class]);
    if (msg.messageType == NIMMessageTypeImage) {
        reuseIdentify = NSStringFromClass([QukanImageMessageCell class]);
    }
    
    QukanMessageBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentify forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configWithMessage:msg];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NIMMessage *msg = self.messages[indexPath.row];
    
    BOOL showTime = [self shouldDisplayTimestampOnMessage:msg];
    BOOL showSeparator = [self shouldDisplayHistorySeparatorOnMessage:msg];
    CGFloat h = [QukanMessageBaseTableViewCell cacluteHeightForMessage:msg];
    h += showTime ? 40 : 0;
    h += showSeparator ? 28 : 0;
    
    return h;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self showOrHideAccessoryView:NO];
}

#pragma mark ===================== MessageTableViewCellDelegate ==================================

- (BOOL)shouldDisplayTimestampOnMessage:(NIMMessage *)message {
    BOOL showTime = NO;
    long index = [self.messages indexOfObject:message];
    if (index != NSNotFound) {
        if (index == 0) {
            showTime = YES;
        }
        else if (index > 1 && index < self.messages.count) {
            NIMMessage *preMsg = self.messages[index-1];
            showTime = (message.timestamp-preMsg.timestamp>5*60);
        }
    }
    
    return showTime;
}

- (BOOL)shouldDisplayTimestampForRowAtIndexPath:(NSIndexPath *)indexPath {
    NIMMessage *msg = self.messages[indexPath.row];
    
    BOOL showTime = NO;
    if (indexPath.row > 1) {
        NIMMessage *preMsg = self.messages[indexPath.row-1];
        showTime = (msg.timestamp-preMsg.timestamp>5*60);
    }
    
    return showTime;
}

- (BOOL)shouldDisplayHistorySeparatorOnMessage:(NIMMessage *)message {
    return NO;
}

- (void)didTapResendOnMessage:(NIMMessage *)message atCell:(QukanMessageBaseTableViewCell *)cell {
    [self resendMessage:message];
}

- (void)didTapImageCellOnMessage:(NIMMessage *)message atCell:(QukanMessageBaseTableViewCell *)cell {
    [self showOrHideAccessoryView:NO];
    
    NSArray *imageModleArray = [self.messages.rac_sequence filter:^BOOL(NIMMessage *  _Nullable value) {
        return value.messageType == NIMMessageTypeImage;
    }].array;
    
    
    NSMutableArray * imageArray = [NSMutableArray new];
    for (NIMMessage *value in imageModleArray) {
        NIMImageObject *imgObj = (NIMImageObject *)value.messageObject;
        QukanImageMessageCell *acell = (QukanImageMessageCell *)cell;
        
        KSPhotoItem *data = nil;
        data = [KSPhotoItem itemWithSourceView:acell.imgView imageUrl:[NSURL URLWithString:imgObj.url]];
        [imageArray addObject:data];
    }
    
    KSPhotoBrowser *browser = [[KSPhotoBrowser alloc] initWithPhotoItems:imageArray selectedIndex:[imageModleArray indexOfObject:message]];
    [browser showFromViewController:self];
}

- (void)didDeleteOnMessage:(NIMMessage *)message atCell:(QukanMessageBaseTableViewCell *)cell {
    @synchronized (self.messages) {
        [NIMSDK.sharedSDK.conversationManager deleteMessage:message];
        [self.messages removeObject:message];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        if (indexPath) {
            [self deleteRow:indexPath.row section:0];
        }else {
            [self.tableView reloadData];
        }
    }
}

- (void)didTapBlankOnMessage:(NIMMessage *)message atCell:(QukanMessageBaseTableViewCell *)cell {
    [self showOrHideAccessoryView:NO];
}

#pragma mark ===================== Private Methods =========================

- (void) setChatName:(NSString*)name{
    _chatName = [name length] > 0? name : @"外星人";
}

-(void)setSession:(NIMSession *)session{
    _session = session;
}

- (void)loadIMAccountData {
    @weakify(self)
    [[[kApiManager QukanacquireIMAccount] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(QukanIMAcount *  _Nullable x) {
        @strongify(self)
        KHideHUD
        self.imAccount = x;
        [self loadMessages];
        //        self.title = x.name;
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        KHideHUD
        [self.view showTip:error.localizedDescription];
    }];
}

- (void)loadUserIMAccount {
    @weakify(self)
    [[[[kApiManager QukanacquireUserIMAccount:self.userId] retry:2] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        KHideHUD
        if(x){
            self.imAccount = x;
            [self loadMessages];
        }else{
            [SVProgressHUD showErrorWithStatus:@"加载失败，请重试"];
        }
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        KHideHUD
        [self.view showTip:error.localizedDescription];
    }];
}

- (void)loadMessages {
    if(self.session){
        KHideHUD
        NSArray<NIMMessage *> *messages = [[[NIMSDK sharedSDK] conversationManager] messagesInSession:self.session
                                                                                              message:nil
                                                                                                limit:100];
        if (messages) {
            [self.messages addObjectsFromArray:messages];
            [self.tableView reloadData];
            [self gotoLastRow:YES];
            [[NIMSDK sharedSDK].conversationManager markAllMessagesReadInSession:self.session];
            
        }
    }else{
        //        [[[NIMSDK sharedSDK] loginManager]
        //         login:self.imAccount.fromAccid
        //         token:self.imAccount.token
        //         completion:^(NSError * _Nullable error) {
        
        NIMSession *session = [NIMSession session:self.imAccount.toAccid type:NIMSessionTypeP2P];
        NSArray<NIMMessage *> *messages = [[[NIMSDK sharedSDK] conversationManager] messagesInSession:session
                                                                                              message:nil
                                                                                                limit:100];
        if (messages) {
            [self.messages addObjectsFromArray:messages];
            [self.tableView reloadData];
            [self gotoLastRow:NO];
            [[NIMSDK sharedSDK].conversationManager markAllMessagesReadInSession:self.session];
            
        }
        //         }];
    }
    
}


//- (void)pullDown:(NIMMessage *)firstMessage handler:(NIMKitDataProvideHandler)handler{
//    [self remoteFetchMessage:firstMessage handler:handler];
//}
//
//
//- (void)remoteFetchMessage:(NIMMessage *)message
//                   handler:(NIMKitDataProvideHandler)handler
//{
//    NIMHistoryMessageSearchOption *searchOpt = [[NIMHistoryMessageSearchOption alloc] init];
//    searchOpt.startTime  = 0;
//    searchOpt.endTime    = message.timestamp;
//    searchOpt.currentMessage = message;
//    searchOpt.limit      = self.limit;
//    searchOpt.sync       =  [NTESBundleSetting sharedConfig].enableSyncWhenFetchRemoteMessages;
//    [[NIMSDK sharedSDK].conversationManager fetchMessageHistory:self.session option:searchOpt result:^(NSError *error, NSArray *messages) {
//        if (handler) {
//            handler(error,messages.reverseObjectEnumerator.allObjects);
//            if ([self.delegate respondsToSelector:@selector(fetchRemoteDataError:)]) {
//                [self.delegate fetchRemoteDataError:error];
//            }
//        };
//    }];
//}



-(void)deleteRow:(long)n section:(long)section {
    [self.tableView numberOfRowsInSection:0];
    
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:n inSection:section];
    [indexPaths addObject:indexPath];
    
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationBottom];
    [self.tableView endUpdates];
}

-(void)insertRow:(long)n section:(long)section {
    @synchronized (self.messages) {
        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:n inSection:section];
        [indexPaths addObject:indexPath];
        
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
}

- (void) gotoLastRow:(BOOL)animated {
    long n = [self.tableView numberOfRowsInSection:0]-1;
    
    if (n >= 1) {
        dispatch_block_t scrollBottomBlock = ^ {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:n inSection:0]
                                  atScrollPosition:UITableViewScrollPositionBottom
                                          animated:animated];
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
}

// https://stackoverflow.com/questions/4279730/keep-uitableview-static-when-inserting-rows-at-the-top/11602040#11602040
- (void)insertOldMessages {
    CGSize beforeContentSize = self.tableView.contentSize;
    [self.tableView reloadData];
    CGSize afterContentSize = self.tableView.contentSize;
    
    CGPoint afterContentOffset = self.tableView.contentOffset;
    CGPoint newContentOffset = CGPointMake(afterContentOffset.x, afterContentOffset.y + afterContentSize.height - beforeContentSize.height);
    self.tableView.contentOffset = newContentOffset;
}

- (void) gotoFirstRow:(BOOL)animated{
    long n = [self.tableView numberOfRowsInSection:0]-1;
    if(n>=1)
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:animated];
}

- (void)reloadCellForMessage:(NIMMessage *)msg {
    long msgIndex = 0;
    for (long i = self.messages.count-1; i>=0; i--) {
        NIMMessage *message = self.messages[i];
        if ([msg isEqual:message]) {
            msgIndex = i;
        }
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:msgIndex inSection:0];
    QukanMessageBaseTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell updateSendStatus:msg.deliveryState];
}

#pragma mark ===================== 消息 ==================================

- (void)sendMessageWithText:(NSString *)text {
    NIMMessage *message = [[NIMMessage alloc] init];
    
    NSString *str = [[QukanSensitiveTextTool sharedInstance] filter:text];
    
    message.text        = str;
    
    QukanChatExtensionModel *model = [[QukanChatExtensionModel alloc] init];
    model.fromName = kUserManager.user.username.length ? kUserManager.user.nickname : @"外星人";
    model.fromUserId = kUserManager.user.userId;
    model.fromHeadUrl = kUserManager.user.avatorId;
    
    model.toName = _chatName;
    model.toUserId = self.userId;
    model.toHeadUrl = _chatHeadUrl;
    
    NSDictionary *ext = [model modelToJSONObject];
    message.remoteExt   = ext;
    [self sendMessage:message];
}

- (void)sendImages:(NSArray *)images {
    for (UIImage *image in images) {
        NIMImageObject *obj = [[NIMImageObject alloc] initWithImage:image];
        NIMImageOption *option  = [[NIMImageOption alloc] init];
        option.compressQuality  = 0.7;
        obj.option      = option;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
        obj.displayName = [NSString stringWithFormat:@"图片发送于%@",dateString];
        NIMMessage *message     = [[NIMMessage alloc] init];
        message.messageObject   = obj;
        message.apnsContent = @"[图片]";
        
        QukanChatExtensionModel *model = [[QukanChatExtensionModel alloc] init];
        model.fromName = kUserManager.user.username.length ? kUserManager.user.nickname : @"外星人";
        model.fromUserId = kUserManager.user.userId;
        model.fromHeadUrl = kUserManager.user.avatorId;
        
        model.toName = _chatName;
        model.toUserId = self.userId;
        model.toHeadUrl = _chatHeadUrl;
        
        NSDictionary *ext = [model modelToJSONObject];
        message.remoteExt   = ext;
        
        NIMMessageSetting *setting = [[NIMMessageSetting alloc] init];
        setting.scene = NIMNOSSceneTypeMessage;
        message.setting = setting;
        
        if (!self.imAccount.toAccid) {
            [self requestAccidAndResendMessage:message];
        }else {
            [self sendMessage:message];
        }
        
    }
}

- (NSInteger)findMessage:(NIMMessage *)message {
    @synchronized (self.messages) {
        for (NIMMessage *msg in self.messages) {
            if ([message isEqual:msg]) {
                return [self.messages indexOfObject:msg];
                break;
            }
        }
    }
    
    return -1;
}

- (void)addOrReplaceWithMessage:(NIMMessage *)message {
    @synchronized (self.messages) {
        NSInteger index = [self findMessage:message];
        if (index >= 0 && index < self.messages.count) {
            [self.messages replaceObjectAtIndex:index withObject:message];
        }else {
            [self.messages addObject:message];
            [self insertRow:self.messages.count-1 section:0];
            [self gotoLastRow:YES];
        }
    }
}

/// 第一次获取聊天id会失败
- (void)requestAccidAndResendMessage:(NIMMessage *)message  {
    @weakify(self)
    [[[[kApiManager QukanacquireUserIMAccount:self.userId] retry:2] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        KHideHUD
        if(x){
            self.imAccount = x;
            [self sendMessage:message];
        }else{
            [SVProgressHUD showErrorWithStatus:@"加载失败，请重试"];
        }
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        KHideHUD
        [self.view showTip:error.localizedDescription];
    }];
}

- (void)sendMessage:(NIMMessage *)message {
    if (!self.imAccount.toAccid) {
        [self requestAccidAndResendMessage:message];
        return;
    }
    NIMSession *session = self.session? self.session: [NIMSession session:self.imAccount.toAccid type:NIMSessionTypeP2P];
    NSError *error = nil;
    [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:&error];
    if (error) {
        DEBUGLog(@"%@", error);
    }else{
        if(self.userId == CustomerServiceID){
            [[[kApiManager hasSendMessageToCustomerServiceSuccess] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
                
            } error:^(NSError * _Nullable error) {
                
            }];
        }
    }
}

- (void)resendMessage:(NIMMessage *)message {
    NSError *error = nil;
    [[NIMSDK sharedSDK].chatManager resendMessage:message error:&error];
    if (error) {
        DEBUGLog(@"%@", error);
    }
}

#pragma mark ===================== NIMChatManagerDelegate ==================================

- (void)willSendMessage:(NIMMessage *)message {
    [self addOrReplaceWithMessage:message];
    [self reloadCellForMessage:message];
}

- (void)sendMessage:(NIMMessage *)message didCompleteWithError:(nullable NSError *)error {
    DEBUGLog(@"send message error: %@", error);
    [self reloadCellForMessage:message];
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
        return (value.messageType == NIMMessageTypeText || value.messageType == NIMMessageTypeImage);
    }].array;
    
    if (realMessages.count >0){
        for (NIMMessage *msg in realMessages) {
            [self.messages addObject:msg];
            [self insertRow:self.messages.count-1 section:0];
            
            [self gotoLastRow:YES];
        }
    }
}

#pragma mark ===================== 图片选择器 ==================================

- (void)pushTZImagePickerController {
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:4 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    // 设置首选语言 / Set preferred language
    imagePickerVc.preferredLanguage = @"zh-Hans";
    
    // imagePickerVc.navigationBar.translucent = NO;
    
    imagePickerVc.isSelectOriginalPhoto = YES;
    imagePickerVc.maxImagesCount = 6;
    imagePickerVc.allowTakePicture = YES;
    imagePickerVc.allowTakeVideo = NO;
    [imagePickerVc setUiImagePickerControllerSettingBlock:^(UIImagePickerController *imagePickerController) {
        imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
    }];
    
    // imagePickerVc.photoWidth = 800;
    
    // 2. Set the appearance
    // 2. 在这里设置imagePickerVc的外观
    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
    //    imagePickerVc.oKButtonTitleColorDisabled = [kThemeColor colorWithAlphaComponent:0.6];
    //    imagePickerVc.oKButtonTitleColorNormal = kThemeColor;
    // imagePickerVc.navigationBar.translucent = NO;
    imagePickerVc.iconThemeColor = [UIColor colorWithRed:31 / 255.0 green:185 / 255.0 blue:34 / 255.0 alpha:1.0];
    //    imagePickerVc.iconThemeColor = kThemeColor;
    imagePickerVc.showPhotoCannotSelectLayer = YES;
    imagePickerVc.cannotSelectLayerColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    [imagePickerVc setPhotoPickerPageUIConfigBlock:^(UICollectionView *collectionView, UIView *bottomToolBar, UIButton *previewButton, UIButton *originalPhotoButton, UILabel *originalPhotoLabel, UIButton *doneButton, UIImageView *numberImageView, UILabel *numberLabel, UIView *divideLine) {
        [doneButton setTitleColor:[UIColor colorWithRed:31 / 255.0 green:185 / 255.0 blue:34 / 255.0 alpha:1.0] forState:UIControlStateNormal];
        //        [doneButton setTitleColor:kThemeColor forState:UIControlStateNormal];
    }];
    /*
     [imagePickerVc setAssetCellDidSetModelBlock:^(TZAssetCell *cell, UIImageView *imageView, UIImageView *selectImageView, UILabel *indexLabel, UIView *bottomView, UILabel *timeLength, UIImageView *videoImgView) {
     cell.contentView.clipsToBounds = YES;
     cell.contentView.layer.cornerRadius = cell.contentView.tz_width * 0.5;
     }];
     */
    
    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    imagePickerVc.allowPickingGif = NO;
    imagePickerVc.allowPickingMultipleVideo = NO;
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
    
    // imagePickerVc.minImagesCount = 3;
    // imagePickerVc.alwaysEnableDoneBtn = YES;
    
    // imagePickerVc.minPhotoWidthSelectable = 3000;
    // imagePickerVc.minPhotoHeightSelectable = 2000;
    
    /// 5. Single selection mode, valid when maxImagesCount = 1
    /// 5. 单选模式,maxImagesCount为1时才生效
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = NO;
    imagePickerVc.needCircleCrop = NO;
    //    // 设置竖屏下的裁剪尺寸
    //    NSInteger left = 30;
    //    NSInteger widthHeight = self.view.tz_width - 2 * left;
    //    NSInteger top = (self.view.tz_height - widthHeight) / 2;
    //    imagePickerVc.cropRect = CGRectMake(left, top, widthHeight, widthHeight);
    // 设置横屏下的裁剪尺寸
    // imagePickerVc.cropRectLandscape = CGRectMake((self.view.tz_height - widthHeight) / 2, left, widthHeight, widthHeight);
    /*
     [imagePickerVc setCropViewSettingBlock:^(UIView *cropView) {
     cropView.layer.borderColor = [UIColor redColor].CGColor;
     cropView.layer.borderWidth = 2.0;
     }];*/
    
    //imagePickerVc.allowPreview = NO;
    // 自定义导航栏上的返回按钮
    /*
     [imagePickerVc setNavLeftBarButtonSettingBlock:^(UIButton *leftButton){
     [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
     [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 20)];
     }];
     imagePickerVc.delegate = self;
     */
    
    // Deprecated, Use statusBarStyle
    // imagePickerVc.isStatusBarDefault = NO;
    imagePickerVc.statusBarStyle = UIStatusBarStyleLightContent;
    
    // 设置是否显示图片序号
    imagePickerVc.showSelectedIndex = YES;
    
    //    // 自定义gif播放方案
    //    [[TZImagePickerConfig sharedInstance] setGifImagePlayBlock:^(TZPhotoPreviewView *view, UIImageView *imageView, NSData *gifData, NSDictionary *info) {
    //        FLAnimatedImage *animatedImage = [FLAnimatedImage animatedImageWithGIFData:gifData];
    //        FLAnimatedImageView *animatedImageView;
    //        for (UIView *subview in imageView.subviews) {
    //            if ([subview isKindOfClass:[FLAnimatedImageView class]]) {
    //                animatedImageView = (FLAnimatedImageView *)subview;
    //                animatedImageView.frame = imageView.bounds;
    //                animatedImageView.animatedImage = nil;
    //            }
    //        }
    //        if (!animatedImageView) {
    //            animatedImageView = [[FLAnimatedImageView alloc] initWithFrame:imageView.bounds];
    //            animatedImageView.runLoopMode = NSDefaultRunLoopMode;
    //            [imageView addSubview:animatedImageView];
    //        }
    //        animatedImageView.animatedImage = animatedImage;
    //    }];
    
    
    // 设置languageBundle以使用其它语言 / Set languageBundle to use other language
    // imagePickerVc.languageBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"tz-ru" ofType:@"lproj"]];
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)imagePickerController:(TZImagePickerController *)picker
       didFinishPickingPhotos:(NSArray<UIImage *> *)photos
                 sourceAssets:(NSArray *)assets
        isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    
    [self sendImages:photos];
}

#pragma mark =====================  ==================================

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<UIImagePickerControllerInfoKey, id> *)editingInfo {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self sendImages:@[image]];
}

#pragma mark ===================== Getters =================================

- (QukanLXKeyBoard *)keyboard {
    if (!_keyboard) {
        _keyboard =[[QukanLXKeyBoard alloc]initWithFrame:CGRectZero];
        _keyboard.backgroundColor =[UIColor whiteColor];
        _keyboard.maxLine = 3;
        _keyboard.font = [UIFont systemFontOfSize:14];
        _keyboard.topOrBottomEdge = 15;
        _keyboard.yOffset = [self.view convertRect:self.view.frame toView:self.view.window].origin.y;
        [_keyboard beginUpdateUI];
        [self.view addSubview:_keyboard];
        _keyboard.placeholder = @"说点什么吧";
        
        @weakify(self)
        _keyboard.sendBlock = ^(NSString *text) {
            @strongify(self)
            //            self.liveChatVcBolck(YES);
            //            [self.keyboard endEditing];
            [self.keyboard clearText];
            if (text.length>0) {
                [self sendMessageWithText:text];
            }
            self.keyboard.placeholder = @"说点什么吧";
        };
    }
    return _keyboard;
}

- (QukanNewsComentView *)footerView {
    if (!_footerView) {
        QukanNewsComentView *view = [[QukanNewsComentView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) withType:4];
        _footerView = view;
        _footerView.titleLabel.text = kUserManager.isLogin ? @"说点什么吧..." : @"请先登录哦";
        _footerView.titleLabel.textColor = kTextGrayColor;
        [self.view addSubview:_footerView];
        [_footerView addSubview:self.operationView];
        [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.view.mas_bottom).offset(-kSafeAreaBottomHeight-49);
            make.height.mas_equalTo(164+kSafeAreaBottomHeight);
        }];
        
        [self.operationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(50);
            make.width.equalTo(view);
            make.height.mas_equalTo(120+kSafeAreaBottomHeight);
            make.leading.equalTo(view);
        }];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _controlBtn = btn;
        btn.titleLabel.font = kFont10;
        
        btn.backgroundColor = kCommentBackgroudColor;
        btn.layer.cornerRadius = 16;
        [btn setImage:kImageNamed(@"Qukan_blackAdd") forState:UIControlStateNormal];
        [btn setImage:kImageNamed(@"Qukan_blackAdd") forState:UIControlStateSelected];
        //        [btn setTitleColor:HEXColor(0x666666) forState:UIControlStateNormal];
        //        [btn setTitleColor:HEXColor(0xff5500) forState:UIControlStateSelected];
        [_footerView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(-10);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(30);
            make.top.mas_equalTo(10);
        }];
        
        @weakify(self)
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            btn.selected = !btn.selected;
            [self showOrHideAccessoryView:btn.selected];
        }];
        
        self.footerView.putBlock = ^(NSInteger type) {
            @strongify(self)
            kGuardLogin
            self.keyboard.placeholder = @"说点什么吧";
            [self.keyboard becomeFirstResponder];
            [self gotoLastRow:YES];
        };
    }
    return _footerView;
}

- (UIView *)operationView {
    if (!_operationView) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        view.alpha = 0;
        _operationView = view;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = kFont11;
        [btn setImage:kImageNamed(@"Qukan_chatPhoto") forState:UIControlStateNormal];
        [btn setTitle:@"发送照片" forState:UIControlStateNormal];
        [btn setTitleColor:kTextGrayColor forState:UIControlStateNormal];
        [view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(16);
            make.height.mas_equalTo(80);
            make.width.mas_equalTo(60);
            make.top.mas_equalTo(10);
        }];
        @weakify(self)
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [self pushTZImagePickerController];
        }];
        
        btn.titleEdgeInsets = UIEdgeInsetsMake(btn.imageView.frame.size.height+5, -btn.imageView.bounds.size.width, 0,0);
        // button图片的偏移量
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, btn.titleLabel.frame.size.width/2, btn.titleLabel.frame.size.height+5, -btn.titleLabel.frame.size.width/2);
        
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn1.titleLabel.font = kFont11;
        [btn1 setImage:kImageNamed(@"Qukan_chatCamler") forState:UIControlStateNormal];
        [btn1 setTitle:@"拍照" forState:UIControlStateNormal];
        [btn1 setTitleColor:kTextGrayColor forState:UIControlStateNormal];
        [view addSubview:btn1];
        [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(btn.mas_trailing).offset(16);
            make.height.width.top.equalTo(btn);
            //        make.top.mas_equalTo(10);
        }];
        [[btn1 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [self presentViewController:self.pickerVC animated:YES completion:nil];
        }];
        
        btn1.titleEdgeInsets = UIEdgeInsetsMake(btn1.imageView.frame.size.height+5, -btn1.imageView.bounds.size.width, 0,0);
        // button图片的偏移量
        btn1.imageEdgeInsets = UIEdgeInsetsMake(0, btn1.titleLabel.frame.size.width/2, btn1.titleLabel.frame.size.height+5, -btn1.titleLabel.frame.size.width/2);
    }
    
    return _operationView;
}

- (void)showOrHideAccessoryView:(BOOL)show {
    [self.keyboard endEditing];
    CGFloat alpha = show ? 1 : 0;
    CGFloat distance = show ? (-150-kSafeAreaBottomHeight) : -kSafeAreaBottomHeight-49;
    self.controlBtn.selected = show;
    [self.view bringSubviewToFront:self.footerView];
    [UIView animateWithDuration:0.25 animations:^{
        self.operationView.alpha = alpha;
        [self.footerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.view.mas_bottom).offset(distance);
            make.height.mas_equalTo(164+kSafeAreaBottomHeight);
        }];
        
        
        if (show) {
            self.tableView.frame = CGRectMake(0, kTopBarHeight, kScreenWidth, kScreenHeight - 150 - kSafeAreaBottomHeight - kTopBarHeight);
        }else {
            self.tableView.frame = CGRectMake(0, kTopBarHeight, kScreenWidth, kScreenHeight  - kTopBarHeight - kSafeAreaBottomHeight - 49);
        }
        // 注意需要再执行一次更新约束
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
    
    if (show) [self gotoLastRow:YES];
    
}

- (UIImagePickerController *)pickerVC {
    if (!_pickerVC) {
        _pickerVC = [[UIImagePickerController alloc] init];
        _pickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        _pickerVC.delegate = self;
    }
    
    return _pickerVC;
}

@end
