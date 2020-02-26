//
//  AllMembersView.h
//  ixcode
//
//  Created by Mac on 2019/11/9.
//  Copyright © 2019 macmac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MembersView.h"

typedef enum : NSUInteger {
    AllMembersViewType_Chat,    //单聊
    AllMembersViewType_Group,   //群聊
} AllMembersViewType;

NS_ASSUME_NONNULL_BEGIN

@protocol AllMembersViewDelegate;

@interface AllMembersView : UIView

@property (nonatomic , weak) id<AllMembersViewDelegate> cpDelegate;

/// 类型
@property (nonatomic , assign) AllMembersViewType type;

/// 是否为群主
@property (nonatomic , assign) BOOL isGroup;

/// 初始化
+ (instancetype)allMemberViewWithType:(AllMembersViewType)type;


#pragma mark - 没有模型现在，暂时先用字符串替代

/// 有模型，传模型数组
//- (void)addMemberForFriendModel:(NSMutableArray<NSString *> *)dataSource;

/// 没有模型，传模字典数组
- (void)addMemberForDictionary:(NSMutableArray<NSString *> *)dataSource;

///// 重新添加，有模型，传模型数组
- (void)reAddMemberForFriendModel:(NSMutableArray<NSString *> *)dataSource;
//
///// 重新添加，没有模型，传模字典数组
//- (void)reAddMemberForDictionary:(NSMutableArray<NSString *> *)dataSource;

@end

@protocol AllMembersViewDelegate <NSObject>

@optional

/// 选中
- (void)allMembersView:(AllMembersView *)allmembersView didSelector:(NSString *)model;

/// 查看更多
- (void)allMembersViewForLookAllMembers:(AllMembersView *)allmembersView;

/// 添加
- (void)allMembersViewWithAdd:(AllMembersView *)allmembersView;

/// 移除
- (void)allMembersViewWithRemove:(AllMembersView *)allmembersView;



@required


@end



NS_ASSUME_NONNULL_END
