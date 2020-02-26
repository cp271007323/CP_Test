//
//  QukanNewsDetailsTableViewCell.h
//  Qukan
//
//  Created by Kody on 2019/7/17.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QukanNewsCommentModel.h"
#import "TTFaveButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface QukanNewsDetailsTableViewCell : UITableViewCell

@property(nonatomic, strong) UILabel     *titleLabel;//新闻标题
@property(nonatomic, strong) UIImageView *publishHeaderImageView;//发布者头像
@property(nonatomic, strong) UILabel     *publishNameLabel;//发布者
@property(nonatomic, strong) UILabel     *publishTimeLabel;//发布时间
@property(nonatomic, strong) TTFaveButton    *likesButton;//点赞按钮
@property(nonatomic, strong) UIView    *likesBtnCover;//点赞按钮遮罩
@property(nonatomic, strong) UILabel     *likesLabel;//点赞数
@property(nonatomic, strong) UILabel     *publishTextLabel;//正文

@property(nonatomic, strong) UIButton *filterBtn; // 过滤评论

@property (nonatomic, copy) void(^QukanNewsDetails_didSeleLivesBlock)(void);


- (void)Qukan_SetNewsDetailsWith:(QukanNewsCommentModel *__nullable)model;

@end

NS_ASSUME_NONNULL_END
