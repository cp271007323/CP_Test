//
//  FilterManager.h
//
//
//  Created by wqin on 2019/7/31.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
//评论
#define kFilterCommentNotification @"kFilterCommentNotification"
//新闻
#define kFilterNewsNotification @"kFilterNewsNotification"
//拉黑用户
#define kFilterUserNotification @"kFilterUserNotification"

typedef NS_ENUM(NSUInteger, FilterType) {
    QukanFilterTypeNews,
    QukanFilterTypeComment,
//    QukanFilterTypeForUser,
    QukanFilterTypeUserOrComment,//可能屏蔽用户或者评论
};

@interface BlockUserObject:NSObject

@property(nonatomic, copy) NSString* userId;
@property(nonatomic, copy) NSString* userAvatarUrl;
@property(nonatomic, copy) NSString* userName;
@property(nonatomic, copy) NSString* extCommentId;     //commentId

-(instancetype) initWithDic:(NSDictionary*)dic;

@end

@interface QukanFilterManager : NSObject

+ (instancetype)sharedInstance;

//屏蔽评论
- (BOOL)isFilteredComment:(NSInteger)commentId;

//屏蔽新闻
- (BOOL)isFilteredNews:(NSInteger)newsId;

//屏蔽 user时参数为BlockUserObject，屏蔽新闻和评论时参数为新闻或评论id
- (void)showFilterViewWithObject:(id)obj filterType:(FilterType)filterType;


//拉黑用户
- (void)blockUser:(BlockUserObject*)userId;
- (void)unBlockUser:(NSInteger)userId;
- (BOOL)isBlockedUser:(NSInteger)userId;
- (NSArray*)blockedList;            //黑名单


@end

NS_ASSUME_NONNULL_END
