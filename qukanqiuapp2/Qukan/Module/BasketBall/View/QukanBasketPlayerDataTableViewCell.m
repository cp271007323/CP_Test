//
//  QukanBasketPlayerDataTableViewCell.m
//  Qukan
//
//  Created by Kody on 2020/1/2.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanBasketPlayerDataTableViewCell.h"
//默认柱状图的高度
#define imageLabelHight 50

@interface QukanBasketPlayerDataTableViewCell ()

@property(nonatomic, strong) UIImageView *left_header_imageView;
@property(nonatomic, strong) UILabel *left_number_label;
@property(nonatomic, strong) UILabel *left_name_label;
@property(nonatomic, strong) UILabel *left_line_label;
@property(nonatomic, strong) UILabel *left_image_label;//柱状图

@property(nonatomic, strong) UIImageView *right_header_imageView;
@property(nonatomic, strong) UILabel *right_number_label;
@property(nonatomic, strong) UILabel *right_name_label;
@property(nonatomic, strong) UILabel *right_line_label;
@property(nonatomic, strong) UILabel *right_image_label;//柱状图

@property(nonatomic, strong) UILabel *type_label;

@end

@implementation QukanBasketPlayerDataTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    [self.contentView addSubview:self.left_header_imageView];
    [self.left_header_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(27);
        make.width.height.offset(40);
        make.top.offset(12);
    }];
    
    [self.contentView addSubview:self.left_line_label];
    [self.left_line_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.mas_equalTo(self.left_header_imageView.mas_bottom).offset(5);
        make.right.mas_equalTo(self.contentView.mas_centerX).offset(-2);
        make.height.offset(1);
    }];
    
    [self.contentView addSubview:self.left_number_label];
    [self.left_number_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.left_header_imageView.mas_right).offset(18);
        make.top.mas_equalTo(self.left_header_imageView);
    }];
    
    [self.contentView addSubview:self.left_name_label];
    [self.left_name_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.left_line_label);
        make.top.mas_equalTo(self.left_line_label.mas_bottom).offset(4);
    }];
    
    [self.contentView addSubview:self.left_image_label];
    [self.left_image_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(20);
        make.bottom.mas_equalTo(self.left_line_label.mas_top).offset(1);
        make.right.mas_equalTo(self.left_line_label);
        make.height.offset(30);
    }];
    
    [self.contentView addSubview:self.right_image_label];
    [self.right_image_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.left_image_label.mas_right).offset(2);
        make.width.bottom.mas_equalTo(self.left_image_label);
        make.height.offset(20);
    }];
    
    [self.contentView addSubview:self.right_header_imageView];
    [self.right_header_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-27);
        make.top.width.height.mas_equalTo(self.left_header_imageView);
    }];
    
    [self.contentView addSubview:self.right_line_label];
    [self.right_line_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.top.height.mas_equalTo(self.left_line_label);
        make.left.mas_equalTo(self.contentView.mas_centerX).offset(2);
    }];
    
    [self.contentView addSubview:self.right_number_label];
    [self.right_number_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.right_header_imageView.mas_left).offset(-18);
        make.top.mas_equalTo(self.left_header_imageView);
    }];
    
    [self.contentView addSubview:self.right_name_label];
    [self.right_name_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.left_name_label);
        make.right.mas_equalTo(self.right_line_label);
    }];
    
    [self.contentView addSubview:self.type_label];
    [self.type_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.left_name_label);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
    }];
}

- (void)setHomePlayerModel:(QukanHomeAndGuestPlayerListModel *)homePlayerModel guestPlayerModel:(QukanHomeAndGuestPlayerListModel *)guestPlayerModel indexPathRow:(NSInteger)indexPathRow midTitle:(NSString *)midTitle {
    
    if (!homePlayerModel || !guestPlayerModel) {
        return;
    }
    
    //客队
    [self.left_header_imageView sd_setImageWithURL:[NSURL URLWithString:guestPlayerModel.photo?guestPlayerModel.photo:@""] placeholderImage:kImageNamed(@"BaksetBall_chat_placehold")];
    //主队
    [self.right_header_imageView sd_setImageWithURL:[NSURL URLWithString:homePlayerModel.photo?homePlayerModel.photo:@""] placeholderImage:kImageNamed(@"BaksetBall_chat_placehold")];
    //客队
    self.left_number_label.text = guestPlayerModel.number;
    self.left_name_label.text = guestPlayerModel.player;
    //主队
    self.right_name_label.text = homePlayerModel.player;
    self.right_number_label.text = homePlayerModel.number;
    self.type_label.text = midTitle;
    //@[@"得分",@"篮板",@"助攻",@"抢断",@"盖帽"];
    if (indexPathRow == 0) {
        //客队
        if (guestPlayerModel) {
            self.left_number_label.text = guestPlayerModel.score;
        }
        //主队
        if (homePlayerModel) {
            self.right_number_label.text = homePlayerModel.score;
        }
    
        [self getImageLabelHightWithGuestNumber:guestPlayerModel.score.integerValue withHomeNumber:homePlayerModel.score.integerValue withRole:1];
        [self getImageLabelHightWithGuestNumber:guestPlayerModel.score.integerValue withHomeNumber:homePlayerModel.score.integerValue withRole:2];
        
    } else if (indexPathRow == 1) {
        if (guestPlayerModel) {
            self.left_number_label.text = [NSString stringWithFormat:@"%ld",guestPlayerModel.attack.integerValue+guestPlayerModel.defend.integerValue];
            [self getImageLabelHightWithGuestNumber:guestPlayerModel.attack.integerValue + guestPlayerModel.defend.integerValue withHomeNumber:homePlayerModel.attack.integerValue + homePlayerModel.defend.integerValue withRole:1];
        }
        if (homePlayerModel) {
            self.right_number_label.text = [NSString stringWithFormat:@"%ld",homePlayerModel.attack.integerValue+homePlayerModel.defend.integerValue];
             [self getImageLabelHightWithGuestNumber:guestPlayerModel.attack.integerValue + guestPlayerModel.defend.integerValue withHomeNumber:homePlayerModel.attack.integerValue + homePlayerModel.defend.integerValue withRole:2];
        }
    } else if (indexPathRow == 2) {
        if (guestPlayerModel) {
            self.left_number_label.text = guestPlayerModel.helpAttack;
            [self getImageLabelHightWithGuestNumber:guestPlayerModel.helpAttack.integerValue withHomeNumber:homePlayerModel.helpAttack.integerValue withRole:1];
        }
        if (homePlayerModel) {
            self.right_number_label.text = homePlayerModel.helpAttack;
            [self getImageLabelHightWithGuestNumber:guestPlayerModel.helpAttack.integerValue withHomeNumber:homePlayerModel.helpAttack.integerValue withRole:2];
        }
    } else if (indexPathRow == 3) {
        if (guestPlayerModel) {
            self.left_number_label.text = guestPlayerModel.rob;
            [self getImageLabelHightWithGuestNumber:guestPlayerModel.rob.integerValue withHomeNumber:homePlayerModel.rob.integerValue withRole:1];
        }
        if (homePlayerModel) {
            self.right_number_label.text = homePlayerModel.rob;
            [self getImageLabelHightWithGuestNumber:guestPlayerModel.rob.integerValue withHomeNumber:homePlayerModel.rob.integerValue withRole:2];
        }
    } else if (indexPathRow == 4) {
        if (guestPlayerModel) {
            self.left_number_label.text = guestPlayerModel.cover;
            [self getImageLabelHightWithGuestNumber:guestPlayerModel.cover.integerValue withHomeNumber:homePlayerModel.cover.integerValue withRole:1];
        }
        if (homePlayerModel) {
            self.right_number_label.text = homePlayerModel.cover;
            [self getImageLabelHightWithGuestNumber:guestPlayerModel.cover.integerValue withHomeNumber:homePlayerModel.cover.integerValue withRole:2];
        }
    }
}

#pragma mark ===================== Public Methods =======================
//计算柱状图的方法
- (void)getImageLabelHightWithGuestNumber:(NSInteger)guestNumber withHomeNumber:(NSInteger)homeNumber withRole:(NSInteger)role { // 1 为guest 2 为home
    NSInteger allNumber = homeNumber + guestNumber;
    if (role == 1) {//guest
        CGFloat left_per = ((CGFloat)guestNumber /  (CGFloat) allNumber);
        CGFloat left_hight;
        if (left_per >= 0.5f) {
            left_hight = imageLabelHight;
        } else {
            left_hight = (CGFloat)guestNumber / (CGFloat)homeNumber * imageLabelHight;
            left_hight = isnan(left_hight) ? 5 : left_hight;
        }
        
        [self.left_image_label mas_remakeConstraints:^(MASConstraintMaker *make) {
           make.width.offset(20);
           make.bottom.mas_equalTo(self.left_line_label.mas_top).offset(1);
           make.right.mas_equalTo(self.left_line_label.mas_right).offset(0);
           make.height.offset(left_hight);
        }];
    } else {
        CGFloat right_per = ((CGFloat)(homeNumber) /  (CGFloat) allNumber);
        CGFloat right_hight;
        if (right_per >= 0.5f) {
            right_hight = imageLabelHight;
        } else {
            right_hight = (CGFloat)homeNumber / (CGFloat)guestNumber * imageLabelHight;
            right_hight = isnan(right_hight) ? 5 : right_hight;
        }
        
        [self.right_image_label mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.left_image_label.mas_right).offset(2);
            make.width.bottom.mas_equalTo(self.left_image_label);
            make.height.offset(right_hight);
        }];
    }
}

- (void)left_header_imageView_cilck {
    if (self.playerCilckBlock) {
        self.playerCilckBlock(1);
    }
}

- (void)right_header_imageView_cilck {
    if (self.playerCilckBlock) {
        self.playerCilckBlock(2);
    }
}

#pragma mark ===================== Getters =================================

- (UIImageView *)left_header_imageView {
    if (!_left_header_imageView) {
        _left_header_imageView = UIImageView.new;
        _left_header_imageView.contentMode = 2;
        _left_header_imageView.clipsToBounds = YES;
        _left_header_imageView.layer.cornerRadius = 20;
        _left_header_imageView.layer.masksToBounds = YES;
        _left_header_imageView.userInteractionEnabled = YES;
        _left_header_imageView.layer.borderWidth = 1;
        _left_header_imageView.layer.borderColor = kThemeColor.CGColor;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(left_header_imageView_cilck)];
        [_left_header_imageView addGestureRecognizer:tap];
    }
    return _left_header_imageView;
}

- (UILabel *)left_number_label {
    if (!_left_number_label) {
        _left_number_label = UILabel.new;
        _left_number_label.font = kFont18;
        _left_number_label.textColor = kThemeColor;
    }
    return _left_number_label;
}

- (UILabel *)left_name_label {
    if (!_left_name_label) {
        _left_name_label = UILabel.new;
        _left_name_label.font = kFont12;
        _left_name_label.textColor = kCommonTextColor;
    }
    return _left_name_label;
}

- (UILabel *)left_line_label {
    if (!_left_line_label) {
        _left_line_label = UILabel.new;
        _left_line_label.backgroundColor = kThemeColor;
    }
    return _left_line_label;
}

- (UILabel *)left_image_label {
    if (!_left_image_label) {
        _left_image_label = UILabel.new;
        _left_image_label.backgroundColor = kThemeColor;
    }
    return _left_image_label;
}

- (UILabel *)right_image_label {
    if (!_right_image_label) {
        _right_image_label = UILabel.new;
        _right_image_label.backgroundColor = HEXColor(0x00B24E);
    }
    return _right_image_label;
}

- (UIImageView *)right_header_imageView {
    if (!_right_header_imageView) {
        _right_header_imageView = UIImageView.new;
        _right_header_imageView.contentMode = 2;
        _right_header_imageView.clipsToBounds = YES;
        _right_header_imageView.layer.cornerRadius = 20;
        _right_header_imageView.layer.masksToBounds = YES;
        _right_header_imageView.layer.borderWidth = 1;
        _right_header_imageView.layer.borderColor = HEXColor(0x00B24E).CGColor;
        _right_header_imageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(right_header_imageView_cilck)];
        [_right_header_imageView addGestureRecognizer:tap];
    }
    return _right_header_imageView;
}

- (UILabel *)right_line_label {
    if (!_right_line_label) {
        _right_line_label = UILabel.new;
        _right_line_label.backgroundColor = HEXColor(0x18AB3A);
    }
    return _right_line_label;
}

- (UILabel *)right_number_label {
    if (!_right_number_label) {
        _right_number_label = UILabel.new;
        _right_number_label.textColor = HEXColor(0x00B24E);
        _right_number_label.font = kFont18;
    }
    return _right_number_label;
}

- (UILabel *)right_name_label {
    if (!_right_name_label) {
        _right_name_label = UILabel.new;
        _right_name_label.textColor = kCommonTextColor;
        _right_name_label.font = kFont12;
        _right_name_label.textAlignment = NSTextAlignmentRight;
    }
    return _right_name_label;
}

- (UILabel *)type_label {
    if (!_type_label) {
        _type_label = UILabel.new;
        _type_label.textColor = kCommonTextColor;
        _type_label.textAlignment = NSTextAlignmentCenter;
        _type_label.font = kFont12;
    }
    return _type_label;
}

@end
