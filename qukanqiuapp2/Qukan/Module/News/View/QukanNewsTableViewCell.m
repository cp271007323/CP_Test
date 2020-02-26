//
//  QukanNewsTableViewCell.m
//  Qukan
//
//  //  Created by pfc on 2019/7/16.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanNewsTableViewCell.h"

#import "QukanNSString+Extras.h"
@interface QukanNewsTableViewCell ()

@property(nonatomic, strong) UILabel *title_label;
@property(nonatomic, strong) UIImageView *news_imageView;
@property(nonatomic, strong) UILabel *read_label;
@property(nonatomic, strong) UILabel *time_label;
@property(nonatomic, strong) UILabel *commontLabel;
//@property(nonatomic, strong) UIImageView *commentImgV;
@property(nonatomic, strong) UIButton *filterButton;

@property(nonatomic, strong) QukanNewsModel*model;

@end

@implementation QukanNewsTableViewCell

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
        make.top.offset(15);
        make.right.offset(-15);
        make.width.offset(139);
        make.height.offset(88);
    }];
    
    [self.contentView addSubview:self.title_label];
    [self.title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.news_imageView);
        make.left.offset(15);
        make.right.mas_equalTo(self.news_imageView.mas_left).offset(-10);
    }];
    
    [self.contentView addSubview:self.read_label];
    [self.read_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.title_label);
        make.bottom.mas_equalTo(self.news_imageView);
    }];
    
    
    [self.contentView addSubview:self.commontLabel];
    [self.commontLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.read_label.mas_right).offset(5);
        make.width.mas_greaterThanOrEqualTo(20);
        make.height.mas_equalTo(20);
        make.centerY.mas_equalTo(self.read_label);
    }];
    
    [self.contentView addSubview:self.time_label];
    [self.time_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.commontLabel.mas_right).offset(6);
        make.centerY.mas_equalTo(self.read_label);
    }];
    
    [self.contentView addSubview:self.filterButton = [UIButton new]];
    [self.filterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.news_imageView.mas_left).offset(5);
        make.bottom.mas_equalTo(self.contentView);
        make.width.height.mas_equalTo(40);
    }];
    [self.filterButton setImage:[kImageNamed(@"Qukan_news_filter") imageWithColor:HEXColor(0xCCCCCC)] forState:UIControlStateNormal];
    @weakify(self)
    [[self.filterButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        
        [[QukanFilterManager sharedInstance] showFilterViewWithObject:@(self.model.nid).stringValue filterType:QukanFilterTypeNews];

    }];
}

#pragma mark ===================== Public Methods =======================

- (void)setDataWithModel:(QukanNewsModel *)model {
    _model = model;
    self.title_label.text = model.title;
    [self.news_imageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:kImageNamed(@"Qukan_placeholder")];
    self.time_label.text = model.pubTimeBefore;
    self.read_label.text = FormatString(@"%ld阅读",model.readNum);
    self.commontLabel.text = FormatString(@"%ld评",model.commentNum);
    
    if (model.readNum / 100000 > 0) {
        self.read_label.text = @"10W+阅读";
    } else if (model.readNum / 10000 > 0) {
        self.read_label.text = [NSString stringWithFormat:@"%.1fW阅读",(float) model.readNum / (float)10000];
    } else if (model.readNum / 1000 > 0) {
        self.read_label.text = [NSString stringWithFormat:@"%.1fK阅读",(float) model.readNum / (float)1000];
    }
    
    if (model.commentNum / 100000 > 0) {
        _commontLabel.text = @"10W+评";
    } else if (model.commentNum / 10000 > 0) {
        _commontLabel.text = [NSString stringWithFormat:@"%.1fW评",(float) model.commentNum / (float)10000];
    } else if (model.commentNum / 1000 > 0) {
        _commontLabel.text = [NSString stringWithFormat:@"%.1fK评",(float) model.commentNum / (float)1000];
    }
}

- (void)showComment{
//    self.time_label.textColor = HEXColor(0x484848);
//    self.time_label.text = @(_model.commentNum).stringValue;
//    [self.commentImgV mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.read_label.mas_right).offset(18);
//        make.bottom.mas_equalTo(self.read_label);
//        make.height.width.mas_equalTo(12);
//    }];
}
- (void)highLightKeyword:(NSString *)keyword {
    self.title_label.attributedText = [NSString getAttributeStrWithString:self.title_label.text];
}
#pragma mark ===================== Getters =================================

- (UILabel *)title_label {
    if (!_title_label) {
        _title_label = UILabel.new;
        _title_label.textColor = HEXColor(0x484848);
        _title_label.font = kFont16;
        _title_label.numberOfLines = 2;
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
        _read_label.textColor = kTextGrayColor;
        _read_label.font = kFont12;
    }
    return _read_label;
}

- (UILabel *)time_label {
    if (!_time_label) {
        _time_label = UILabel.new;
        _time_label.font = kFont12;
        _time_label.textColor = kTextGrayColor;
    }
    return _time_label;
}

- (UILabel *)commontLabel {
    if (!_commontLabel) {
        _commontLabel = UILabel.new;
        _commontLabel.textColor = kTextGrayColor;
        _commontLabel.font = kFont12;
    }
    return _commontLabel;
}

@end
