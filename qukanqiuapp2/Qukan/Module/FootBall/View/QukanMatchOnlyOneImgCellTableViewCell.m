//
//  QukanMatchOnlyOneImgCellTableViewCell.m
//  Qukan
//
//  Created by leo on 2019/9/2.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanMatchOnlyOneImgCellTableViewCell.h"

@implementation QukanMatchOnlyOneImgCellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
        self.selectionStyle = 0;
    }
    return self;
}

- (void)initUI {
    
    [self.img_main mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self.view_top mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.width.equalTo(@(2));
        make.bottom.equalTo(self.img_main.mas_top).offset(-7);
        make.centerX.equalTo(self.contentView);
    }];
    
    [self.view_topBall mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view_top.mas_bottom);
        make.centerX.equalTo(self.view_top);
        make.size.mas_equalTo(CGSizeMake(10, 10));
    }];
    
    [self.view_bottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.img_main.mas_bottom).offset(7);
        make.width.equalTo(@(2));
        make.bottom.equalTo(self.contentView);
        make.centerX.equalTo(self.contentView);
    }];
    
    [self.view_bottomBall mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view_bottom.mas_top);
        make.centerX.equalTo(self.view_top);
        make.size.mas_equalTo(CGSizeMake(10, 10));
    }];
}


- (void)fullCellWithState:(NSString *)state {
    self.view_bottom.hidden = self.view_bottomBall.hidden = ![state isEqualToString:@"1"];
    self.view_top.hidden = self.view_topBall.hidden = !self.view_bottom.hidden;
    self.img_main.image = self.view_bottom.hidden?kImageNamed(@"bisaikaishi"):kImageNamed(@"Qukan_chuisao");
}

- (UIImageView *)img_main {
    if (!_img_main) {
        _img_main = [[UIImageView alloc] initWithImage:kImageNamed(@"Qukan_chuisao")];
        _img_main.contentMode = UIViewContentModeCenter;
        _img_main.layer.borderColor = HEXColor(0x666666).CGColor;
        _img_main.layer.borderWidth = 0.0;
        
        [self.contentView addSubview:_img_main];
    }
    return _img_main;
}

- (UIView *)view_top {
    if (!_view_top) {
        _view_top = [UIView new];
        _view_top.backgroundColor = kThemeColor;
        [self.contentView addSubview:_view_top];
    }
    return _view_top;
}

- (UIView *)view_bottom {
    if (!_view_bottom) {
        _view_bottom = [UIView new];
        _view_bottom.backgroundColor = kThemeColor;
        [self.contentView addSubview:_view_bottom];
    }
    return _view_bottom;
}

- (UIView *)view_topBall {
    if (!_view_topBall) {
        _view_topBall = [UIView new];
        _view_topBall.backgroundColor = kThemeColor;
        _view_topBall.layer.masksToBounds = YES;
        _view_topBall.layer.cornerRadius = 5;
        [self.contentView addSubview:_view_topBall];
    }
    return _view_topBall;
}

- (UIView *)view_bottomBall {
    if (!_view_bottomBall) {
        _view_bottomBall = [UIView new];
        _view_bottomBall.backgroundColor = kThemeColor;
        _view_bottomBall.layer.masksToBounds = YES;
        _view_bottomBall.layer.cornerRadius = 5;
        [self.contentView addSubview:_view_bottomBall];
    }
    return _view_bottomBall;
}
@end
