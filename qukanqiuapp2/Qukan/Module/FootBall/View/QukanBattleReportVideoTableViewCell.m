//
//  QukanBattleReportVideoTableViewCell.m
//  Qukan
//
//  Created by Kody on 2019/12/26.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanBattleReportVideoTableViewCell.h"

@interface QukanBattleReportVideoTableViewCell ()

@property(nonatomic, strong) QukanNewsModel *model;
@property(nonatomic, strong) UIImageView *news_imageView;
@property(nonatomic, strong) UIButton *play_btn;
@property(nonatomic, strong) UILabel *title_label;
@property (nonatomic, strong) UIView *effectView;
@property (nonatomic, strong) UIView *fullMaskView;
@property(nonatomic, strong) UIImageView *coverImageView;

@end

@implementation QukanBattleReportVideoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
        self.selectionStyle = 0;
    }
    return self;
}

- (void)initUI {
    
    [self.contentView addSubview:self.news_imageView];
    [self.news_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(20);
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(170);
    }];
    
    [self.contentView addSubview:self.coverImageView];
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(20);
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(170);
    }];
    
    [self.coverImageView addSubview:self.play_btn];
    [self.play_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(50);
        make.center.mas_equalTo(self.news_imageView);
    }];
    
    [self.contentView addSubview:self.title_label];
    [self.title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.news_imageView);
        make.top.mas_equalTo(self.news_imageView.mas_bottom).offset(10);
        make.right.offset(-15);
    }];
}

#pragma mark ===================== Public Methods =======================

- (void)setDataWithModel:(QukanNewsModel *)model {
    self.model = model;
    [self.news_imageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:kImageNamed(@"Qukan_play_background")];
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:kImageNamed(@"Qukan_play_background")];
    self.title_label.text = @"热刺2-1绝杀曼联，重回欧战区";
}

- (void)setNormalMode {
    self.fullMaskView.hidden = YES;
    self.title_label.textColor = kCommonBlackColor;
//    self.nickNameLabel.textColor = kCommonWhiteColor;
    self.contentView.backgroundColor = HEXColor(0xF0F2F5);
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

//static CGAffineTransform affineTransformMakeShear(CGFloat xShear, CGFloat yShear) {
//    return CGAffineTransformMake(1, yShear, xShear, 1, 0, 0);
//}

#pragma mark ===================== Getters =================================

- (UIImageView *)news_imageView {
    if (!_news_imageView) {
        _news_imageView = UIImageView.new;
        _news_imageView.contentMode = 2;
        _news_imageView.clipsToBounds = YES;
        _news_imageView.userInteractionEnabled = YES;
    }
    return _news_imageView;
}

- (UIButton *)play_btn {
    if (!_play_btn) {
        _play_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_play_btn setImage:kImageNamed(@"Qukan_news_play") forState:UIControlStateNormal];
        @weakify(self)
        [[_play_btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            if (self.playBtnCilckBlock) {
                self.playBtnCilckBlock(self.model);
            }
        }];
    }
    return _play_btn;
}

- (UILabel *)title_label {
    if (!_title_label) {
        _title_label = UILabel.new;
        _title_label.textColor = kCommonTextColor;
        _title_label.font = kFont16;
    }
    return _title_label;
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

- (UIView *)fullMaskView {
    if (!_fullMaskView) {
        _fullMaskView = [UIView new];
        _fullMaskView.backgroundColor = [kCommonBlackColor colorWithAlphaComponent:0.8];
        _fullMaskView.userInteractionEnabled = NO;
    }
    return _fullMaskView;
}

- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.userInteractionEnabled = YES;
        _coverImageView.tag = 10086;
        _coverImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _coverImageView;
}

@end
