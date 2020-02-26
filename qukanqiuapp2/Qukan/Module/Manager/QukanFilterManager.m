//
//  QukanFilterManager.m
//  Qukan
//
//  Created by wqin on 2019/7/31.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//


#import <TBActionSheet/TBActionSheet.h>

//新闻
static NSString * const kFilterNewsKey = @"kFilterAuthContentKey";
//评论
static NSString * const kFilterCommentKey = @"kFilterCommontKey";
//用户
static NSString * const kBlockUserListKey = @"kBlockUserListKey";

//不对外开放
typedef NS_ENUM(NSUInteger, PrivateFilterType) {
    Private_FilterTypeNews,
    Private_FilterTypeComment,
    Private_FilterTypeForUser,
};


@implementation BlockUserObject

-(instancetype) initWithDic:(NSDictionary*)dic{
    if(self = [super init]){
        self.userAvatarUrl = dic[@"userAvatarUrl"]?:@"";
        self.userName = dic[@"userName"]?:@"";
        self.userId = dic[@"userId"]?:@"";
        self.extCommentId = dic[@"extCommentId"]?:@"";
    }
    return self;
}

@end



@interface QukanFilterManager ()

@property(nonatomic, strong, readwrite) NSMutableArray<NSNumber *> *newsIdList;
@property(nonatomic, strong, readwrite) NSMutableArray<NSNumber *> *commentIdList;
@property(nonatomic, strong, readwrite) NSMutableArray<BlockUserObject *> *myBlockList;


@end

@implementation QukanFilterManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static QukanFilterManager *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}

#pragma mark --------------------拉黑用户---------------------------
- (void)savemyBlockListToUserdefault{
    NSMutableArray* datas = @[].mutableCopy;
    for (int i = 0;i < self.myBlockList.count; i++){
        BlockUserObject*obj = self.myBlockList[i];
        NSDictionary *dic = @{@"userId":obj.userId,@"userName":obj.userName,@"userAvatarUrl":obj.userAvatarUrl};
        [datas addObject: dic];
    }
    [kUserDefaults setObject:datas forKey:kBlockUserListKey];
}

- (void)blockUser:(BlockUserObject*)obj{
    if(![self isBlockedUser:obj.userId.integerValue]){
        [self.myBlockList addObject:obj];
        [self savemyBlockListToUserdefault];
    }
}

- (void)unBlockUser:(NSInteger)userId{
    NSMutableArray* temArray = self.myBlockList;
    for(BlockUserObject* user in temArray){
        if(user.userId.integerValue == userId){
            [temArray removeObject:user];
            break;
        }
    }
    self.myBlockList = temArray;
    [self savemyBlockListToUserdefault];
}

- (BOOL)isBlockedUser:(NSInteger)userId{
    for(BlockUserObject* user in self.myBlockList){
        if(user.userId.integerValue == userId){
            return YES;
        }
    }
    return NO;
}

- (NSArray*)blockedList{
    return self.myBlockList;
}

-(NSMutableArray *)myBlockList{
    if(!_myBlockList){
        _myBlockList = @[].mutableCopy;
        NSArray *dics = [kUserDefaults objectForKey:kBlockUserListKey];
        if(dics.count){
            for (int i = 0;i < dics.count; i++){
                NSDictionary* dic = dics[i];
                BlockUserObject*obj = [[BlockUserObject alloc]initWithDic:dic];
                [_myBlockList addObject: obj];
            }
        }
    }
    return _myBlockList;
}

#pragma mark --------------------屏蔽新闻---------------------------
- (void)filterNewsWithId:(NSInteger)newsId{
    if(![self isFilteredNews:newsId]){
        [self.newsIdList addObject:@(newsId)];
    }
    [kUserDefaults setObject:self.newsIdList forKey:kFilterNewsKey];
}

-(BOOL)isFilteredNews:(NSInteger)newsId{
    for(NSNumber* news in self.newsIdList){
        if(news.integerValue == newsId){
            return YES;
        }
    }
    return NO;
}

- (NSMutableArray<NSNumber *> *)newsIdList{
    if(!_newsIdList){
        _newsIdList = @[].mutableCopy;
        NSArray *newsIds = [kUserDefaults objectForKey:kFilterNewsKey];
        if(newsIds){
            [_newsIdList addObjectsFromArray:newsIds];
        }
    }
    return _newsIdList;
}

#pragma mark --------------------屏蔽评论---------------------------
- (void)filterCommentWithId:(NSInteger)commentId{
    if(![self isFilteredComment:commentId]){
        [self.commentIdList addObject:@(commentId)];
    }
    [kUserDefaults setObject:self.commentIdList forKey:kFilterCommentKey];
}

-(BOOL)isFilteredComment:(NSInteger)commentId{
    for(NSNumber* comment in self.commentIdList){
        if(comment.integerValue == commentId){
            return YES;
        }
    }
    return NO;
}

- (NSMutableArray<NSNumber *> *)commentIdList{
    if(!_commentIdList){
        _commentIdList = @[].mutableCopy;
        NSArray *commentIds = [kUserDefaults objectForKey:kFilterCommentKey];
        if(commentIds){
            [_commentIdList addObjectsFromArray:commentIds];
        }
    }
    return _commentIdList;
}



- (void)filterWithObject:(id)filterObjct Type:(PrivateFilterType)type {
    NSString *notificationName;
    if (type == Private_FilterTypeNews) {
        if([filterObjct isKindOfClass:[NSString class]]){
            NSString* newsId = filterObjct;
            [self filterNewsWithId:newsId.integerValue];
            notificationName = kFilterNewsNotification;
        }
    }else if (type == Private_FilterTypeComment) {
        
        if([filterObjct isKindOfClass:[BlockUserObject class]]){
            BlockUserObject* obj = filterObjct;
            NSString* newsId = obj.extCommentId;
            [self filterCommentWithId:newsId.integerValue];
            notificationName = kFilterCommentNotification;
        }
    }else if (type == Private_FilterTypeForUser) {
        if([filterObjct isKindOfClass:[BlockUserObject class]]){
            BlockUserObject* userObj = filterObjct;
            [self blockUser:userObj];
            notificationName = kFilterUserNotification;
        }
    }
    
    if (notificationName) {
        [kNotificationCenter postNotificationName:notificationName object:filterObjct];
    }
}

#pragma mark ===================== Public Methods =======================
- (void)showFilterViewWithObject:(id)filterObj filterType:(FilterType)filterType{
    TBActionSheet *sheet = [[TBActionSheet alloc] init];
    @weakify(self)
    
    PrivateFilterType privateType = (filterType == QukanFilterTypeUserOrComment)? Private_FilterTypeComment:Private_FilterTypeNews;
    if(filterType == QukanFilterTypeComment){
        privateType = Private_FilterTypeComment;
    }
    
    [sheet addButtonWithTitle:@"举报" style:TBActionButtonStyleDefault handler:^(TBActionButton * _Nonnull button) {
        @strongify(self)
        [self showReportSheet:filterObj filerType:privateType];
    }];
    NSString *title = @"外星人";
    if (filterType == QukanFilterTypeUserOrComment) {
        if([filterObj isKindOfClass:[BlockUserObject class]]){
            BlockUserObject*model = (BlockUserObject*)filterObj;
            title = [NSString stringWithFormat:@"拉黑用户：%@", model.userName];
        }
        [sheet addButtonWithTitle:title style:TBActionButtonStyleDefault handler:^(TBActionButton * _Nonnull button) {
            [self filterWithObject:filterObj Type:Private_FilterTypeForUser];
        }];
    }
    
    [sheet addButtonWithTitle:@"内容重复" style:TBActionButtonStyleDefault handler:^(TBActionButton * _Nonnull button) {
        @strongify(self)
        [self filterWithObject:filterObj Type:privateType];
    }];
    
    [sheet addButtonWithTitle:@"内容引起不适" style:TBActionButtonStyleDefault handler:^(TBActionButton * _Nonnull button) {
        @strongify(self)
        [self filterWithObject:filterObj Type:privateType];
    }];
    
    [sheet addButtonWithTitle:@"取消" style:TBActionButtonStyleCancel handler:^(TBActionButton * _Nonnull button) {
        
    }];
    sheet.buttonFont = kSystemFont(16);
    sheet.buttonHeight = 54;
    sheet.backgroundTransparentEnabled = NO;
    sheet.sheetWidth = kScreenWidth;
    sheet.ambientColor = kCommonWhiteColor;
    sheet.rectCornerRadius = 0;
    sheet.blurEffectEnabled = NO;
    sheet.offsetY = -kSafeAreaBottomHeight;
    [sheet setupStyle];
    [sheet show];
}

//
//- (void)showFilterWithObject:(NSObject<QukanFilterObjct> *)filterObjct filterType:(QukanFilterType)filterType {
//    [self showFilterWithObject:filterObjct filterType:filterType filterUser:NO];
//}
//
//- (void)showFilterWithObject:(NSObject<QukanFilterObjct> *)filterObjct filterType:(QukanFilterType)filterType filterUser:(BOOL)filterUser  {
//
//    TBActionSheet *sheet = [[TBActionSheet alloc] init];
//
//    @weakify(self)
//    [sheet addButtonWithTitle:@"举报" style:TBActionButtonStyleDefault handler:^(TBActionButton * _Nonnull button) {
//        @strongify(self)
//        [self showReportSheet:filterObjct filerType:filterType];
//    }];
//    NSString *title = @"外星人";
//    if (filterUser) {
//        if([filterObjct isKindOfClass:[QukanBolingPointListModel class]]){
//            QukanBolingPointListModel*model = (QukanBolingPointListModel*)filterObjct;
//            title = [NSString stringWithFormat:@"拉黑用户：%@", model.username];
//        }else{
//            if(filterObjct.filterName.length){
//                title = [NSString stringWithFormat:@"拉黑用户：%@", filterObjct.filterName];
//            }
//        }
//        [sheet addButtonWithTitle:title style:TBActionButtonStyleDefault handler:^(TBActionButton * _Nonnull button) {
//            //            [self filterWithObject:filterObjct Type:QukanFilterTypeUser];
//
//            // 屏蔽用户当前有点问题。。 先直接屏蔽模型吧。。
//            [self filterWithObject:filterObjct Type:filterType];
//        }];
//    }
//
//    [sheet addButtonWithTitle:@"内容重复" style:TBActionButtonStyleDefault handler:^(TBActionButton * _Nonnull button) {
//        @strongify(self)
//        [self filterWithObject:filterObjct Type:filterType];
//    }];
//
//    [sheet addButtonWithTitle:@"内容引起不适" style:TBActionButtonStyleDefault handler:^(TBActionButton * _Nonnull button) {
//        @strongify(self)
//        [self filterWithObject:filterObjct Type:filterType];
//    }];
//
//    [sheet addButtonWithTitle:@"取消" style:TBActionButtonStyleCancel handler:^(TBActionButton * _Nonnull button) {
//
//    }];
//    sheet.buttonFont = kSystemFont(16);
//    sheet.buttonHeight = 54;
//    sheet.backgroundTransparentEnabled = NO;
//    sheet.sheetWidth = kScreenWidth;
//    sheet.ambientColor = kCommonWhiteColor;
//    sheet.rectCornerRadius = 0;
//    sheet.blurEffectEnabled = NO;
//    sheet.offsetY = -kSafeAreaBottomHeight;
//    [sheet setupStyle];
//    [sheet show];
//}

#pragma mark ===================== filter ==================================

- (void)showReportSheet:(id)filterObjct filerType:(PrivateFilterType)filterType {
    TBActionSheet *sheet = [[TBActionSheet alloc] init];
    
    @weakify(self)
    
    [sheet addButtonWithTitle:@"和话题不符" style:TBActionButtonStyleDefault handler:^(TBActionButton * _Nonnull button) {
        @strongify(self)
        [self reportWithContent:@"和话题不符"];
        [self filterWithObject:filterObjct Type:filterType];
    }];
    
    [sheet addButtonWithTitle:@"低俗色情" style:TBActionButtonStyleDefault handler:^(TBActionButton * _Nonnull button) {
        @strongify(self)
        [self reportWithContent:@"低俗色情"];
        [self filterWithObject:filterObjct Type:filterType];
    }];
    
    [sheet addButtonWithTitle:@"政治敏感" style:TBActionButtonStyleDefault handler:^(TBActionButton * _Nonnull button) {
        @strongify(self)
        [self reportWithContent:@"政治敏感"];
        [self filterWithObject:filterObjct Type:filterType];
    }];
    
    [sheet addButtonWithTitle:@"其它" style:TBActionButtonStyleDefault handler:^(TBActionButton * _Nonnull button) {
        @strongify(self)
        [self reportWithContent:@"其它"];
        [self filterWithObject:filterObjct Type:filterType];
    }];
    
    [sheet addButtonWithTitle:@"取消" style:TBActionButtonStyleCancel handler:^(TBActionButton * _Nonnull button) {
        
    }];
    sheet.buttonFont = kSystemFont(16);
    sheet.buttonHeight = 54;
    sheet.backgroundTransparentEnabled = NO;
    sheet.sheetWidth = kScreenWidth;
    sheet.ambientColor = kCommonWhiteColor;
    sheet.rectCornerRadius = 0;
    sheet.blurEffectEnabled = NO;
    sheet.offsetY = -kSafeAreaBottomHeight;
    [sheet setupStyle];
    [sheet show];
}

- (void)reportWithContent:(NSString *)content {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:content forKey:@"content"];
    [parameters setObject:@"" forKey:@"contact"];
    [parameters setObject:@"" forKey:@"imgurl"];
    
    //    @weakify(self)
    [QukanNetworkTool Qukan_POST:@"gcUserFeedback/add" parameters:parameters success:^(NSDictionary *response) {

    } failure:^(NSError *error) {
        //        @strongify(self)
        //        [self.viewController.view dismissHUD];
        //        [self.viewController.view showTip:@"提交失败"];
    }];
}

@end
