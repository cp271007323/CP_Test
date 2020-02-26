//
//  QukanNewsDetailsTableViewCell.m
//  Qukan
//
//  Created by Kody on 2019/7/17.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanNewsDetailsTableViewCell.h"
#import "QukanApiManager+News.h"

@interface QukanNewsDetailsTableViewCell ()

@property(nonatomic, strong) QukanNewsCommentModel *model;

@end

@implementation QukanNewsDetailsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self) {
        [self.contentView addSubview:self.publishHeaderImageView];
        [self.publishHeaderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.offset(15);
            make.width.height.offset(40);
        }];
        
        [self.contentView addSubview:self.publishNameLabel];
        [self.publishNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.publishHeaderImageView.mas_right).offset(4);
            make.top.offset(21);
            make.height.offset(12);
        }];
        
        [self.contentView addSubview:self.publishTimeLabel];
        [self.publishTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.publishNameLabel);
            make.width.mas_equalTo(self.publishNameLabel);
            make.top.mas_equalTo(self.publishNameLabel.mas_bottom).offset(4);
        }];
        
        [self.contentView addSubview:self.likesButton];
        [self.likesButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-15);
            make.width.height.offset(30);
            make.centerY.mas_equalTo(self.publishTimeLabel);
        }];
        
        [self.contentView addSubview:self.likesLabel];
        [self.likesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-50);
            make.width.height.offset(30);
            make.centerY.equalTo(self.publishTimeLabel).offset(2);
        }];
        
        [self.contentView addSubview:self.publishTextLabel];
        [self.publishTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.publishHeaderImageView);
            make.right.offset(-18);
            make.top.mas_equalTo(self.publishHeaderImageView.mas_bottom).offset(10);
        }];
        
        [self.contentView addSubview:self.filterBtn];
        [self.filterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.likesButton);
            make.bottom.mas_equalTo(-5);
            make.width.height.mas_equalTo(25);
        }];
        
        [self.contentView addSubview:_likesBtnCover = [UIView new]];
        [_likesBtnCover mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(self.likesButton);
        }];
        _likesBtnCover.hidden = YES;
    }
    return self;
}

#pragma mark ===================== Public Methods =======================
- (void)Qukan_SetNewsDetailsWith:(QukanNewsCommentModel *)model {
    self.model = model;
    self.publishNameLabel.text = model.userName;
    if ([NSString isEmptyStr:model.userName] == YES) {
         self.publishNameLabel.text = @"暂无";
    }
    self.publishTimeLabel.text = model.createdDateBefore;
    [self.publishHeaderImageView sd_setImageWithURL:[NSURL URLWithString:model.userIcon] placeholderImage:kImageNamed(@"Qukan_user_DefaultAvatar")];
    self.likesLabel.text = [NSString stringWithFormat:@"%ld",model.likeCount];
    self.publishTextLabel.text = model.commentContent;
    [self frameSizeAgain];
    
    self.likesButton.selected = model.isLike == 1;
    
    NSString *likeCountStr = nil;
    if (self.model.likeCount / 100000 > 0) {
        likeCountStr = @"10W+";
    } else if (self.model.likeCount / 10000 > 0) {
        likeCountStr = [NSString stringWithFormat:@"%.1fW",(float) self.model.likeCount / (float)10000];
    } else if (self.model.likeCount / 1000 > 0) {
        likeCountStr = [NSString stringWithFormat:@"%.1fK",(float) self.model.likeCount / (float)1000];
    } else {
        likeCountStr = [NSString stringWithFormat:@"%ld",self.model.likeCount];
    }
    self.likesLabel.text = likeCountStr;
    
    
    if ([model.userName isEqualToString:@""]) {
        [self locationAgain];
    }
}

- (void)likesButtonCilck {
    kGuardLogin
//    self.likesButton.enabled = NO;
    self.likesBtnCover.hidden = NO;
    if (self.model.isLike == 1) {
        [self Qukan_commentSwitchWithCommentId:self.model.newsId addType:2];
    } else {
        [self Qukan_commentSwitchWithCommentId:self.model.newsId addType:1];
    }
}

- (void)locationAgain {
    
}

#pragma mark ===================== other ============================
- (CGFloat)Qukan_SetSizeToFitWith:(UILabel *)label addSelfWidth:(CGFloat)selfWidth {
    [label sizeToFit];
    CGSize size = [label sizeThatFits:CGSizeMake(kScreenWidth - 40, MAXFLOAT)];
    return size.height;
}

- (void)frameSizeAgain {
    CGFloat publishTextLabelHight = [self Qukan_SetSizeToFitWith:self.publishTextLabel addSelfWidth:kScreenWidth - 20];
    if (publishTextLabelHight > 20) {
        publishTextLabelHight = publishTextLabelHight;
    } else {
        publishTextLabelHight = 20;
    }
    self.publishTextLabel.frame = CGRectMake(10, 40, kScreenWidth - 20, publishTextLabelHight);
    self.frame = CGRectMake(0, 0, kScreenWidth, publishTextLabelHight + 50);
}

#pragma mark ===================== NetWork ==================================

- (void)Qukan_commentSwitchWithCommentId:(NSInteger)commentId addType:(NSInteger)type {
    @weakify(self)
    [[[kApiManager QukancommentSwitchWithCommentId:commentId addType:type] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (type == 1) {
            NSString *title = self.likesLabel.text;
            self.likesLabel.text = [NSString stringWithFormat:@"%ld",[title integerValue] + 1];
            if (self.model.likeCount > 1000) {
                self.likesLabel.text = title;
            }
            self.model.isLike = 1;
            
        } else if (type == 2){
            NSString *title = self.likesLabel.text;
            self.likesLabel.text = [NSString stringWithFormat:@"%ld",[title integerValue] - 1];
            if (self.model.likeCount > 1000) {
                self.likesLabel.text = title;
            }
            self.model.isLike = 2;
            
        }
        self.likesButton.selected = self.model.isLike == 1;
        self.likesBtnCover.hidden = YES;
    } error:^(NSError * _Nullable error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        self.likesBtnCover.hidden = YES;
    }];
}


#pragma mark ===================== Getters =================================
- (UIImageView *)publishHeaderImageView {
    if (!_publishHeaderImageView) {
        _publishHeaderImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _publishHeaderImageView.layer.cornerRadius = 12;
        _publishHeaderImageView.layer.masksToBounds = YES;
    }
    return _publishHeaderImageView;
}

- (UILabel *)publishNameLabel {
    if (!_publishNameLabel) {
        _publishNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _publishNameLabel.font = [UIFont boldSystemFontOfSize:12];
        _publishNameLabel.textColor = kThemeColor;
    }
    return _publishNameLabel;
}

- (UILabel *)publishTimeLabel {
    if (!_publishTimeLabel) {
        _publishTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _publishTimeLabel.font = kSystemFont(12);
        _publishTimeLabel.textColor = kCommonTextColor;
    }
    return _publishTimeLabel;
}

-(TTFaveButton *)likesButton {
    if (!_likesButton) {
        UIImage*norImg = kImageNamed(@"Qukan_like");
        UIImage*selImg = [kImageNamed(@"Qukan_like") imageWithColor:kThemeColor];;
        
        _likesButton = [[TTFaveButton alloc] initWithFrame:CGRectMake(kScreenWidth - 40, 0, 30, 30)faveIconImage:norImg selectedFaveIconImage:selImg];
        [_likesButton addTarget:self action:@selector(likesButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    }
    return _likesButton;
}

- (UILabel *)likesLabel {
    if (!_likesLabel) {
        _likesLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _likesLabel.textAlignment = NSTextAlignmentRight;
        _likesLabel.font = kSystemFont(10);
        _likesLabel.textColor = kCommonDarkGrayColor;
    }
    return _likesLabel;
}


- (UILabel *)publishTextLabel {
    if (!_publishTextLabel) {
        _publishTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _publishTextLabel.font = kFont14;
        _publishTextLabel.numberOfLines = 0;
        _publishTextLabel.textColor = kCommonTextColor;
    }
    return _publishTextLabel;
}

- (UIButton *)filterBtn {
    if (!_filterBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _filterBtn = btn;
        [btn setImage:[kImageNamed(@"Qukan_news_filter") imageWithColor:COLOR_HEX(0x313131, 0.3)] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:6];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        @weakify(self)
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            BlockUserObject* userObj = [BlockUserObject new];
            userObj.userId = @(self.model.userId).stringValue;
            userObj.userAvatarUrl = self.model.userIcon;
            userObj.userName = self.model.userName;
            userObj.extCommentId = @(self.model.newsId).stringValue;
            [[QukanFilterManager sharedInstance] showFilterViewWithObject:userObj filterType:QukanFilterTypeUserOrComment];
        }];
    }
    
    return _filterBtn;
}

@end
