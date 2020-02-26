//
//  QukanNewsComentView.m
//  Qukan
//
//  Created by Kody on 2019/7/18.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanNewsComentView.h"

@interface QukanNewsComentView ()

@property(nonatomic, strong) UIView              *putView;
@property(nonatomic, strong, readwrite) UILabel             *titleLabel;
@property(nonatomic, strong) UIButton            *commentButton;
@property(nonatomic, strong) UIButton            *shareButton;
@property(nonatomic, strong) UILabel             *zanCountLabel;
@property(nonatomic, assign) commentViewType     type;

@property(nonatomic, strong) QukanNewsModel      *model;

@end

@implementation QukanNewsComentView


- (instancetype)initWithFrame:(CGRect)frame withType:(commentViewType)type{
    self = [super initWithFrame:frame];
    self.userInteractionEnabled = YES;
    self.type = type;
    [self addSubviews];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withType:(commentViewType)type withModel:(nonnull QukanNewsModel *)model{
    self = [super initWithFrame:frame];
    self.userInteractionEnabled = YES;
    self.type = type;
    self.model = model;
    [self addSubviews];
    [self addNSNotition];
    return self;
}

- (void)addSubviews {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.putView];
    [self.putView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.putView).offset(5);
        make.centerY.equalTo(self.putView);
    }];
    if (self.type == CommentView_NewsDetails) {//新闻视频详情页的
        
        [self addSubview:self.shareButton];
        [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-30);
            make.width.height.offset(30);
            make.top.mas_equalTo(self.putView);
        }];
        
        [self addSubview:self.zanCountLabel];
        [self.zanCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.shareButton.mas_left).offset(-15);
            make.centerY.mas_equalTo(self.shareButton);
        }];

        [self addSubview:self.commentButton];
        [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(30);
            make.right.mas_equalTo(self.zanCountLabel.mas_left).offset(-5);
            make.centerY.mas_equalTo(self.shareButton);
        }];
        
        self.zanCountLabel.text = [NSString stringWithFormat:@"%ld",self.model.commentNum];
        if (self.model.commentNum > 100000) {
            self.zanCountLabel.text = @"10W+";
        } else if (self.model.commentNum > 10000) {
            self.zanCountLabel.text = [NSString stringWithFormat:@"%.1fK",(float)self.model.commentNum / (float)10000];
        } else if (self.model.commentNum > 1000) {
            self.zanCountLabel.text = [NSString stringWithFormat:@"%.1fK",(float)self.model.commentNum / (float)1000];
        }
        CGFloat zanWidth = floor([self.zanCountLabel.text widthForFont:kSystemFont(8)]);
        self.zanCountLabel.frame = CGRectMake(20, 0, zanWidth + 10, 12);
        if (self.zanCountLabel.text.length == 4) {
            self.zanCountLabel.frame = CGRectMake(15, 0, zanWidth + 10, 12);
        }

        if (self.model.commentNum == 0) {
            self.zanCountLabel.hidden = YES;
        }
        self.backgroundColor = HEXColor(0xEEEEEE);
        self.putView.backgroundColor = kCommonWhiteColor;
        self.titleLabel.textColor = HEXColor(0xD8D8D8);
        self.putView.layer.cornerRadius = 4;
        self.titleLabel.text = @" 输入您的看法吧";
    } else if (self.type == CommentView_NewsDetails_Details) {//评论详情
        self.backgroundColor = HEXColor(0xEEEEEE);
        self.putView.backgroundColor = kCommonWhiteColor;
        self.titleLabel.textColor = HEXColor(0xD8D8D8);
        self.putView.layer.cornerRadius = 4;
        self.titleLabel.text = @" 输入您的看法吧";
    } else if (self.type == CommentView_LiveChat) {//直播聊天
        
    }
    
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(putViewClick)];
    [self.putView addGestureRecognizer:singleTap];
}

- (void)addNSNotition {
    [kNotificationCenter addObserver:self selector:@selector(commentChane:) name:Qukan_Nsnotition_CommentNumberChange object:nil];
}

#pragma mark ===================== Public Methods =======================
- (void)putViewClick {
    kGuardLogin
    if (self.putBlock) {
        self.putBlock(0);
    }
}

- (void)buttonCilck:(UIButton *)button  {
    switch (button.tag) {
        case 1:
            if (self.addCommentViewBlock) {
                self.addCommentViewBlock();
            }
            break;
        case 2://分享
            [self shareChoose];
            break;
        default:
            break;
    }
}

- (void)shareChoose {
    if (self.addShareViewBlock) {
        self.addShareViewBlock();
    }
}

- (void)commentChane:(NSNotification *)not {
    self.zanCountLabel.hidden = NO;
    if ([self.zanCountLabel.text containsString:@"."]) {//说明很大
        if (self.model.commentNum > 100000) {
            self.zanCountLabel.text = @"10W+";
        } else if (self.model.commentNum > 10000) {
            self.zanCountLabel.text = [NSString stringWithFormat:@"%.1fK",(float)self.model.commentNum / (float)10000];
        } else if (self.model.commentNum > 1000) {
            self.zanCountLabel.text = [NSString stringWithFormat:@"%.1fK",(float)self.model.commentNum / (float)1000];
        }
        CGFloat zanWidth = floor([self.zanCountLabel.text widthForFont:kSystemFont(8)]);
        self.zanCountLabel.frame = CGRectMake(20, 0, zanWidth + 10, 12);
        if (self.zanCountLabel.text.length == 4) {
            self.zanCountLabel.frame = CGRectMake(15, 0, zanWidth + 10, 12);
        }
    } else {
        NSInteger number = [self.zanCountLabel.text integerValue];
        self.zanCountLabel.text = [NSString stringWithFormat:@"%ld",number + 1];
        if (number == 999) {
            self.zanCountLabel.text = @"1.0K";
        }
    }
}

#pragma mark ===================== Getters =================================
- (UIView *)putView {
    if (!_putView) {
        _putView = [UIView new];
        _putView.backgroundColor = HEXColor(0xEEEEEE);
        _putView.layer.cornerRadius = 15.5;
        _putView.layer.masksToBounds = YES;
        
        if (self.type == CommentView_NewsDetails) {
            _putView.frame = CGRectMake(15, 9, kScreenWidth - 150, 31);
        } else if (self.type == CommentView_NewsDetails_Details) {
            _putView.frame = CGRectMake(15, 9, kScreenWidth - 30, 31);
        }else if (self.type == CommentView_LiveChat) {
            _putView.layer.cornerRadius = 4;
            _putView.frame = CGRectMake(15, 8, kScreenWidth - 120, 33);
        }else if(self.type == CommentView_KefuChat) {
            _putView.frame = CGRectMake(15, 9, kScreenWidth - 60, 31);
        }else if(self.type == CommentView_basketBall) {
             _putView.layer.cornerRadius = 4;
            _putView.frame = CGRectMake(15, 9, kScreenWidth - 30, 31);
        }
    }
    return _putView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth - 200, 33)];
        _titleLabel.font = kFont13;
        _titleLabel.text = @" 我也聊聊～";
        _titleLabel.textColor = kCommonBlackColor;
    }
    return _titleLabel;
}

- (UIButton *)commentButton {
    if (!_commentButton) {
        _commentButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_commentButton setImage:kImageNamed(@"Qukan_news_comment") forState:UIControlStateNormal];
        [_commentButton addTarget:self action:@selector(buttonCilck:) forControlEvents:UIControlEventTouchUpInside];
        _commentButton.tag = 1;
    }
    return _commentButton;
}

- (UIButton *)shareButton {
    if (!_shareButton) {
        _shareButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 50, 10, 40, 33)];
        [_shareButton setImage:kImageNamed(@"Qukan_news_share") forState:UIControlStateNormal];
        _shareButton.titleLabel.font = kFont12;
        [_shareButton addTarget:self action:@selector(buttonCilck:) forControlEvents:UIControlEventTouchUpInside];
        _shareButton.tag = 2;
    }
    return _shareButton;
}

- (UILabel *)zanCountLabel {
    if (!_zanCountLabel) {
        _zanCountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _zanCountLabel.layer.masksToBounds = YES;
        _zanCountLabel.font = kFont12;
        _zanCountLabel.textColor = kThemeColor;
    }
    return _zanCountLabel;
}

@end
