//
//  QukanNewsComentView.h
//  Qukan
//
//  Created by Kody on 2019/7/18.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QukanShareView.h"
#import "QukanNewsModel.h"
@class QukanNewsModel;
NS_ASSUME_NONNULL_BEGIN

@interface QukanNewsComentView : UIView

typedef NS_ENUM(NSUInteger, commentViewType) {
    CommentView_NewsDetails          = 1,
    CommentView_NewsDetails_Details  = 2,
    CommentView_LiveChat             = 3,
    CommentView_KefuChat            = 4,
    CommentView_basketBall            = 5,
};

@property (nonatomic, copy) void(^putBlock)(NSInteger type);
@property (nonatomic, copy) void(^addShareViewBlock)(void);
@property (nonatomic, copy) void(^addCommentViewBlock)(void);
@property (nonatomic, weak) UIViewController *controller;

@property(nonatomic, strong, readonly) UILabel             *titleLabel;

- (instancetype)initWithFrame:(CGRect)frame withType:(commentViewType)type;
- (instancetype)initWithFrame:(CGRect)frame withType:(commentViewType)type withModel:(QukanNewsModel *)model;

@end

NS_ASSUME_NONNULL_END
