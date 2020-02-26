//
//  QukanBattleReportNewsTableViewCell.m
//  Qukan
//
//  Created by Kody on 2019/12/26.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanBattleReportNewsTableViewCell.h"

@interface QukanBattleReportNewsTableViewCell ()

@property(nonatomic, strong) UILabel *title_label;
@property(nonatomic, strong) UIImageView *news_imageView;
@property(nonatomic, strong) UILabel *read_label;
@property(nonatomic, strong) UIButton *commentBtn;

@end

@implementation QukanBattleReportNewsTableViewCell

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
        make.top.offset(18);
        make.right.offset(-15);
        make.width.offset(139);
        make.height.offset(88);
    }];
    
    [self.contentView addSubview:self.title_label];
    [self.title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(18);
        make.right.mas_equalTo(self.news_imageView.mas_left).offset(-10);
    }];
    
    [self.contentView addSubview:self.read_label];
    [self.read_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.title_label);
        make.bottom.mas_equalTo(self.news_imageView);
        make.height.offset(20);
    }];
    
    [self.contentView addSubview:self.commentBtn];
    [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.read_label.mas_right).offset(20);
        make.bottom.mas_equalTo(self.news_imageView);
        make.height.mas_equalTo(self.read_label);
    }];
}

#pragma mark ===================== Public Methods =======================

- (void)setDataWithModel:(QukanNewsModel *)model {
    self.title_label.text = @"中超讨论：韦世豪能否 扛起国足大旗？";
    [self.news_imageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:kImageNamed(@"Qukan_play_background")];
    self.read_label.text = FormatString(@"%ld阅读",model.readNum);
    [self.commentBtn setTitle:FormatString(@" %ld",model.commentNum) forState:UIControlStateNormal];
}

#pragma mark ===================== Getters =================================

- (UILabel *)title_label {
    if (!_title_label) {
        _title_label = UILabel.new;
        _title_label.numberOfLines = 0;
        _title_label.textColor = HEXColor(0x484848);
        _title_label.font = kFont16;
    }
    return _title_label;
}

- (UIImageView *)news_imageView {
    if (!_news_imageView) {
        _news_imageView = UIImageView.new;
        _news_imageView.contentMode = 2;
        _news_imageView.clipsToBounds = YES;
    }
    return _news_imageView;
}

- (UILabel *)read_label {
    if (!_read_label) {
        _read_label = UILabel.new;
        _read_label.textColor = HEXColor(0x484848);
        _read_label.font = kFont12;
    }
    return _read_label;
}

- (UIButton *)commentBtn {
    if (!_commentBtn) {
        _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentBtn setTitle:@"200" forState:UIControlStateNormal];
        [_commentBtn setTitleColor:HEXColor(0x484848) forState:UIControlStateNormal];
        [_commentBtn setImage:kImageNamed(@"Qukan_match_comment") forState:UIControlStateNormal];
        _commentBtn.titleLabel.font = kFont12;
        [[_commentBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            
        }];
    }
    return _commentBtn;
}

@end
