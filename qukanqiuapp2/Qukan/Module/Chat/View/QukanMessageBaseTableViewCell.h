//
//  QukanMessageBaseTableViewCell.h
//  Cell
//
//  Created by pfc on 2019/8/15.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NIMSDK/NIMMessage.h>

#define bubbleMinHeight 40
#define kHeadWidth bubbleMinHeight
#define kRightContentGap 20
#define kLeftContentGap 14
#define contentMaxWidth [UIScreen mainScreen].bounds.size.width-kHeadWidth-25-90

#define LocationCellSize CGSizeMake(contentMaxWidth-30, 130)
#define kFileCellSize CGSizeMake(contentMaxWidth-30, 110)
#define kVideoMaxCellSize CGSizeMake(150, 150)
#define kaCellSize CGSizeMake(contentMaxWidth-30, 100)
#define VoiceCellSize CGSizeMake(100, bubbleMinHeight)
#define kMaxImageSize CGSizeMake(150, 150)

#define leftContentInsets UIEdgeInsetsMake(8, 24, 8, 14)
#define rightContentInsets UIEdgeInsetsMake(8, 14, 8, 8)

//#define kChatTextFont [UIFont systemFontOfSize:17]

@interface NIMMessage (QukanSize)

@property(nonatomic, assign) CGSize messageContentSize;

@end

@implementation NIMMessage  (QukanSize)

- (void)setMessageContentSize:(CGSize)messageContentSize {
    objc_setAssociatedObject(self, @selector(messageContentSize), @(messageContentSize), OBJC_ASSOCIATION_RETAIN);
}

- (CGSize)messageContentSize {
    return [objc_getAssociatedObject(self, _cmd) CGSizeValue];
}

@end

@class QukanMessageBaseTableViewCell;
@protocol MessageTableViewCellDelegate <NSObject>

@optional

// 图片消息的图片下载完成图片后
- (void)imageDidDownloadOnMessage:(NIMMessage *)message atCell:(QukanMessageBaseTableViewCell *)cell;

- (void)didTapLocationCellOnMessage:(NIMMessage *)message atCell:(QukanMessageBaseTableViewCell *)cell;

- (void)didTapFileCellOnMessage:(NIMMessage *)message atCell:(QukanMessageBaseTableViewCell *)cell;

- (void)didTapImageCellOnMessage:(NIMMessage *)message atCell:(QukanMessageBaseTableViewCell *)cell;

- (void)didTapVideoCellOnMessage:(NIMMessage *)message atCell:(QukanMessageBaseTableViewCell *)cell;

- (void)didTapkaCellOnMessage:(NIMMessage *)message atCell:(QukanMessageBaseTableViewCell *)cell;

// 点击重发
- (void)didTapResendOnMessage:(NIMMessage *)message atCell:(QukanMessageBaseTableViewCell *)cell;

// 点击头像
- (void)didTapAvatarOnMessage:(NIMMessage *)message atCell:(QukanMessageBaseTableViewCell *)cell;

// 点击空白地方
- (void)didTapBlankOnMessage:(NIMMessage *)message atCell:(QukanMessageBaseTableViewCell *)cell;

// 长按头像
- (void)didLongTapAvatarOnMessage:(NIMMessage *)message atCell:(QukanMessageBaseTableViewCell *)cell;

// 长按点击删除
- (void)didDeleteOnMessage:(NIMMessage *)message atCell:(QukanMessageBaseTableViewCell *)cell;

- (void)didForwardOnMessage:(NIMMessage *)message atCell:(QukanMessageBaseTableViewCell *)cell;

- (void)didCollectOnMessage:(NIMMessage *)message atCell:(QukanMessageBaseTableViewCell *)cell;

- (void)didWhdrawOnMessage:(NIMMessage *)message atCell:(QukanMessageBaseTableViewCell *)cell;

/// 是否显示消息发送时间
- (BOOL)shouldDisplayTimestampOnMessage:(NIMMessage *)message;

/// 是否显示历史消息分割线
- (BOOL)shouldDisplayHistorySeparatorOnMessage:(NIMMessage *)message;

@end;

@interface QukanMessageBaseTableViewCell : UITableViewCell

@property(nonatomic, weak) id<MessageTableViewCellDelegate> delegate;

// 头像
@property (nonatomic, strong) UIImageView *headImgView;

// 昵称
@property (nonatomic, strong) UILabel *nickLab;

// 气泡背景
@property (nonatomic, strong) UIImageView *bubbleView;

// 时间
@property(nonatomic, strong) UIView *timeView;
@property (nonatomic, strong) UILabel *timeLab;

@property(nonatomic, strong) UILabel *labSeparator; // 展示历史消息分割

// 小红点（用于语音消息）
@property (nonatomic, strong) UIImageView *redTipView;

// 显示发送失败的按钮，点击展示重发选项（消息发送失败显示）
@property (nonatomic, strong) UIButton *resendButton;

// 正在发送提示
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@property (nonatomic, strong) NIMMessage *message;

- (void)buildView;

// override
- (CGSize)contentViewSize;
// override
//- (void)tapCellAction;
- (void)tapBubbleAction;

- (BOOL)showBubbleImage;

// 如果子类覆盖，必须调用super
- (void)configWithMessage:(NIMMessage *)message;

- (void)adjustViewFrame;

+ (CGFloat)cacluteHeightForMessage:(NIMMessage *)message;

- (void)updateSendStatus:(NIMMessageDeliveryState)status;

@end
