//
//  QukanDetalisHeaderView.h
//  Qukan
//
//  Created by Kody on 2019/7/17.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <YYLabel.h>
#import "QukanNewsModel.h"
#import "TTFaveButton.h"

@class QukanNewsModel;
NS_ASSUME_NONNULL_BEGIN

@interface QukanNewsDetalisHeaderView : UIView

@property(nonatomic, copy) void(^QukanNews_GetHightBlock)(CGFloat hight);
@property(nonatomic, copy) void(^QukanFocus_didBlock)(void);
@property(nonatomic, strong) UIView      *explodeView;//爆点
@property(nonatomic, strong) UIImageView *explode_imageView;
@property(nonatomic, strong) UILabel     *league_label;
@property(nonatomic, strong) UILabel     *dataSource_label;
@property(nonatomic, strong) UILabel     *time_label;
@property(nonatomic, strong) UILabel     *readNumber_label;


@property(nonatomic, strong) UILabel     *titleLabel;//新闻标题
@property(nonatomic, strong) UIImageView *publishHeaderImageView;//发布者头像
@property(nonatomic, strong) UIButton    *attentionButton;//关注
@property(nonatomic, strong) UILabel     *publishTextLabel;//正文
@property(nonatomic, strong) UIImageView      *newsImagesView;//图像


@property(nonatomic, strong) UILabel     *likeNumberLabel;//点赞
@property(nonatomic, strong) UIView      *likeNumberView;//点赞底色

@property(nonatomic, strong) TTFaveButton    *likesButton;//点赞数


@property(nonatomic, strong) WKWebView      *Qukan_NewsWebView;
@property(nonatomic, strong) UIProgressView *Qukan_progressView;

@property(nonatomic, copy) NSString         *webUrlStr;


- (instancetype)initWithFrame:(CGRect)frame withDict:(QukanNewsModel *__nullable)model;
- (void)Qukan_SetNewsHeaderWith:(QukanNewsModel *__nullable)model;

@end

NS_ASSUME_NONNULL_END

