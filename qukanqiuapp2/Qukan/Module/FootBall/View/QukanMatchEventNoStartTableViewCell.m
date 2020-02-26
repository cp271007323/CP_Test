//
//  QukanMatchEventNoStartTableViewCell.m
//  Qukan
//
//  Created by Kody on 2019/12/28.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanMatchEventNoStartTableViewCell.h"

@interface QukanMatchEventNoStartTableViewCell ()

@property(nonatomic, strong) UIImageView *noStart_imageView;
@property(nonatomic, strong) UILabel *noStart_label;

@end

@implementation QukanMatchEventNoStartTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
        self.selectionStyle = 0;
    }
    return self;
}

- (void)initUI {
    [self.contentView addSubview:self.noStart_imageView];
    [self.noStart_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.noStart_label];
    [self.noStart_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10);
        make.left.offset(10);
        make.top.mas_equalTo(self.noStart_imageView.mas_bottom).offset(20);
    }];
}

#pragma mark ===================== Getters =================================

- (UIImageView *)noStart_imageView {
    if (!_noStart_imageView) {
        _noStart_imageView = UIImageView.new;
        _noStart_imageView.image = kImageNamed(@"Foot_noStart");
    }
    return _noStart_imageView;
}

- (UILabel *)noStart_label {
    if (!_noStart_label) {
        _noStart_label = UILabel.new;
        _noStart_label.font = kFont16;
        _noStart_label.textColor = kTextGrayColor;
        _noStart_label.text = @"比赛未开始....";
        _noStart_label.textAlignment = NSTextAlignmentCenter;
    }
    return _noStart_label;
}

@end
