//
//  ZFTableViewCell.m
//  ZFPlayer
//
//  Created by 紫枫 on 2018/4/3.
//  Copyright © 2018年 紫枫. All rights reserved.
//

#import "ZFTableViewCell.h"
#import "UIImageView+ZFCache.h"
#import "QukanNSString+Extras.h"
@interface ZFTableViewCell ()
//@property (nonatomic, strong) UIImageView *headImageView;
//@property (nonatomic, strong) UILabel *nickNameLabel;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIView *fullMaskView;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *leagueNameLabel;
@property (nonatomic, strong) UILabel *readLabel;
@property(nonatomic, strong) UIView *readLabelContainerView;
@property (nonatomic, strong) UILabel *commonLabel;
@property (nonatomic, strong) UIView *commonLabelContainerView;
@property(nonatomic, strong) UIButton *filterBtn;
@property (nonatomic, strong) UILabel *pulishTimeLabel;
@property (nonatomic, weak) id<ZFTableViewCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) UIImageView *bgImgView;

@property (nonatomic, strong) UIView *effectView;
//@property(nonatomic, strong) UIImageView *comment_imageView;

@property(nonatomic, strong) QukanNewsModel *model;



@end

@implementation ZFTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = kCommonWhiteColor;

        [self.contentView addSubview:self.bgImgView];
        [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(10);
            make.left.offset(15);
            make.right.offset(-15);
            make.height.offset(170);
        }];
        
        [self.bgImgView addSubview:self.effectView];
        [self.effectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.bgImgView);
        }];
        
        [self.contentView addSubview:self.coverImageView];
        [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.height.mas_equalTo(self.bgImgView);
        }];
        
        [self.coverImageView addSubview:self.playBtn];
        [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(40);
            make.center.mas_equalTo(self.coverImageView);
        }];
        
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.bgImgView.mas_bottom).offset(6);
            make.left.right.mas_equalTo(self.bgImgView);
            make.height.offset(22);
        }];
        
        [self.contentView addSubview:self.readLabel];
        [self.readLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel);
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(6);
        }];
        
//        [self.contentView addSubview:self.comment_imageView];
//        [self.comment_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.mas_equalTo(self.readLabel);
//            make.left.mas_equalTo(self.readLabel.mas_right).offset(20);
//            make.width.offset(30);
//            make.height.offset(16);
//        }];
        
        [self.contentView addSubview:self.commonLabel];
        [self.commonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.readLabel.mas_right).offset(5);
            make.centerY.mas_equalTo(self.readLabel);
        }];
        
        [self.contentView addSubview:self.pulishTimeLabel];
        [self.pulishTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.bgImgView);
            make.centerY.mas_equalTo(self.readLabel);
        }];
        
        [self.contentView addSubview:self.fullMaskView];
        [self.fullMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.offset(0);
        }];
        
        [self.contentView addSubview:self.filterBtn];
        [self.filterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.pulishTimeLabel.mas_left).offset(-10);
            make.centerY.mas_equalTo(self.readLabel);
            make.width.height.offset(40);
        }];
    }
    return self;
}

#pragma mark ===================== Public Methods =======================

- (void)setDataWithModel:(QukanNewsModel *)model {
    _model = model;

    [self.coverImageView setImageWithURLString:model.imageUrl placeholder:[UIImage imageNamed:@"loading_bgView"]];
   [self.bgImgView setImageWithURLString:model.imageUrl placeholder:[UIImage imageNamed:@"loading_bgView"]];
   self.titleLabel.text = model.title;
   self.leagueNameLabel.text = [NSString stringWithFormat:@"#%@", model.leagueName];
   self.readLabel.text = [NSString stringWithFormat:@"%ld阅读", model.readNum];
   self.commonLabel.text = [NSString stringWithFormat:@"%ld评", model.commentNum];
    self.pulishTimeLabel.text = [NSString stringWithFormat:@"%@", model.pubTimeBefore.length ? model.pubTimeBefore :
                                 @""];
   
   if (model.readNum / 100000 > 0) {
       self.readLabel.text = @"10W+";
   } else if (model.readNum / 10000 > 0) {
       self.readLabel.text = [NSString stringWithFormat:@"%.1fW阅读",(float) model.readNum / (float)10000];
   } else if (model.readNum / 1000 > 0) {
       self.readLabel.text = [NSString stringWithFormat:@"%.1fK阅读",(float) model.readNum / (float)1000];
   }
   
   if (model.commentNum / 100000 > 0) {
       self.commonLabel.text = @"10W+";
   } else if (model.commentNum / 10000 > 0) {
       self.commonLabel.text = [NSString stringWithFormat:@"%.1fW阅读",(float) model.commentNum / (float)10000];
   } else if (model.commentNum / 1000 > 0) {
       self.commonLabel.text = [NSString stringWithFormat:@"%.1fK阅读",(float) model.commentNum / (float)1000];
   }
}

- (void)setDelegate:(id<ZFTableViewCellDelegate>)delegate withIndexPath:(NSIndexPath *)indexPath {
    self.delegate = delegate;
    self.indexPath = indexPath;
}

- (void)setNormalMode {
    self.fullMaskView.hidden = YES;
    self.titleLabel.textColor = kCommonBlackColor;
    self.contentView.backgroundColor = kCommonWhiteColor;
}

- (void)showMaskView {
    [UIView animateWithDuration:0.3 animations:^{
        self.fullMaskView.alpha = 1;
    }];
}

- (void)hideMaskView {
    [UIView animateWithDuration:0.3 animations:^{
        self.fullMaskView.alpha = 0;
    }];
}

- (void)playBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(zf_playTheVideoAtIndexPath:)]) {
        [self.delegate zf_playTheVideoAtIndexPath:self.indexPath];
    }
}
- (void)hidePlayBtn{
    [_playBtn setHidden:YES];
}

- (void)hideBottomButtons{
    _commonLabel.hidden = YES;
    _readLabel.hidden = YES;
    _filterBtn.hidden = YES;
    _pulishTimeLabel.hidden = YES;
//    _comment_imageView.hidden = YES;
}
- (void)highLightKeyword:(NSString *)keyword {
//    NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc]initWithString:self.titleLabel.text];
//    [self jxt_enumerateRangeOfString:keyword sumString:self.titleLabel.text usingBlock:^(NSRange searchStringRange, NSUInteger idx, BOOL *stop) {
//        [contentStr addAttributes:@{
//                                  NSForegroundColorAttributeName:[UIColor redColor],
//                                  } range:searchStringRange];
//    }];
    self.titleLabel.attributedText = [NSString getAttributeStrWithString:self.titleLabel.text];
}

- (void)jxt_enumerateRangeOfString:(NSString *)searchString sumString:(NSString *)sumString usingBlock:(void (^)(NSRange searchStringRange, NSUInteger idx, BOOL *stop))block
{
    if ([self isKindOfClass:[NSString class]] && sumString.length &&
        [searchString isKindOfClass:[NSString class]] && searchString.length) {
        NSArray <NSString *>*separatedArray = [sumString componentsSeparatedByString:searchString];
        if (separatedArray.count < 2) {
            return ;
        }
        NSUInteger count = separatedArray.count - 1; //少遍历一次，因为拆分之后，最后一部分是没用的
        NSUInteger length = searchString.length;
        __block NSUInteger location = 0;
        [separatedArray enumerateObjectsUsingBlock:^(NSString * _Nonnull componentString, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx == count) {
                *stop = YES;
            }
            else {
                location += componentString.length; //跳过待筛选串前面的串长度
                if (block) {
                    block(NSMakeRange(location, length), idx, stop);
                }
                location += length; //跳过待筛选串的长度
            }
        }];
    }
}
#pragma mark ===================== Getter ==================================

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:kImageNamed(@"Qukan_news_play") forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

- (UIView *)fullMaskView {
    if (!_fullMaskView) {
        _fullMaskView = [UIView new];
        _fullMaskView.backgroundColor = [kCommonBlackColor colorWithAlphaComponent:0.8];
        _fullMaskView.userInteractionEnabled = NO;
    }
    return _fullMaskView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = kCommonTextColor;
        _titleLabel.numberOfLines = 1;
        _titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _titleLabel;
}

- (UILabel *)leagueNameLabel {
    if (!_leagueNameLabel) {
        _leagueNameLabel = [[UILabel alloc] init];
        _leagueNameLabel.textColor = HEXColor(0xFF6162);
        _leagueNameLabel.font = kSystemFont(10);
    }
    return _leagueNameLabel;
}

- (UILabel *)commonLabel {
    if (!_commonLabel) {
        _commonLabel = [UILabel new];
        _commonLabel.textColor = kTextGrayColor;
        _commonLabel.numberOfLines = 0;
        _commonLabel.font = [UIFont systemFontOfSize:12];
    }
    return _commonLabel;
}

- (UIView *)commonLabelContainerView {
    if (!_commonLabelContainerView) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        view.layer.cornerRadius = 4;
        view.backgroundColor = RGBSAMECOLOR(242);
        view.transform = affineTransformMakeShear(-0.3,0);
        _commonLabelContainerView = view;
    }
    return _commonLabelContainerView;
}

- (UILabel *)readLabel {
    if (!_readLabel) {
        _readLabel = [UILabel new];
        _readLabel.textColor = kTextGrayColor;
        _readLabel.numberOfLines = 0;
        _readLabel.font = [UIFont systemFontOfSize:12];
    }
    return _readLabel;
}

- (UIView *)readLabelContainerView {
    if (!_readLabelContainerView) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        view.layer.cornerRadius = 4;
        view.backgroundColor = RGBSAMECOLOR(242);
        view.transform = affineTransformMakeShear(-0.3,0);
        _readLabelContainerView = view;
    }
    return _readLabelContainerView;
}

static CGAffineTransform affineTransformMakeShear(CGFloat xShear, CGFloat yShear) {
    return CGAffineTransformMake(1, yShear, xShear, 1, 0, 0);
}

- (UIButton *)filterBtn {
    if (!_filterBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _filterBtn = btn;
        [btn setImage:[kImageNamed(@"Qukan_news_filter") imageWithColor:HEXColor(0xCCCCCC)] forState:UIControlStateNormal];
        @weakify(self)
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [[QukanFilterManager sharedInstance] showFilterViewWithObject:@(self.model.nid).stringValue filterType:QukanFilterTypeNews];
        }];
    }
    return _filterBtn;
}

- (UILabel *)pulishTimeLabel {
    if (!_pulishTimeLabel) {
        _pulishTimeLabel = [[UILabel alloc] init];
        _pulishTimeLabel.textColor = HEXColor(0xcccccc);
        _pulishTimeLabel.font = kSystemFont(12);
        _pulishTimeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _pulishTimeLabel;
}

- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.userInteractionEnabled = YES;
        _coverImageView.tag = kPlayerInCellContainerViewTag;
        _coverImageView.contentMode = UIViewContentModeScaleAspectFit;
        _coverImageView.layer.cornerRadius = 0;
        _coverImageView.layer.masksToBounds = YES;
        _coverImageView.shouldAutoClipImageToViewSize = YES;
    }
    return _coverImageView;
}

- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] init];
        _bgImgView.userInteractionEnabled = YES;
        _bgImgView.layer.cornerRadius = 0;
        _bgImgView.layer.masksToBounds = YES;
        _bgImgView.shouldAutoClipImageToViewSize = YES;
    }
    return _bgImgView;
}

- (UIView *)effectView {
    if (!_effectView) {
        if (@available(iOS 8.0, *)) {
            UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            _effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        } else {
            UIToolbar *effectView = [[UIToolbar alloc] init];
            effectView.barStyle = UIBarStyleBlackTranslucent;
            _effectView = effectView;
        }
    }
    return _effectView;
}

//- (UIImageView *)comment_imageView {
//    if (!_comment_imageView) {
//        _comment_imageView = UIImageView.new;
//        _comment_imageView.image = kImageNamed(@"Qukan_match_comment");
//        _comment_imageView.contentMode = 4;
//        _comment_imageView.clipsToBounds = YES;
//    }
//    return _comment_imageView;
//}

@end
