//
//  QukanBSKDetailPlayerCell.m
//  Qukan
//
//  Created by blank on 2019/12/26.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanBSKDetailPlayerCell.h"
@interface QukanBSKDetailPlayerCell()
@property (nonatomic, strong)UIImageView *icon;
@property (nonatomic, strong)UILabel *name;
@property (nonatomic, strong)UILabel *number;
@property (nonatomic, strong)UILabel *location;
@property (nonatomic, strong)UILabel *height;
@property (nonatomic, strong)UILabel *weight;
@property (nonatomic, strong)UILabel *prLab;
@end
@implementation QukanBSKDetailPlayerCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.icon];
        [self.contentView addSubview:self.name];
        [self.contentView addSubview:self.number];
        [self.contentView addSubview:self.location];
        [self.contentView addSubview:self.height];
        [self.contentView addSubview:self.weight];
        [self.contentView addSubview:self.prLab];
        CGFloat leftMargin = 170;
        CGFloat width =( kScreenWidth - 170 -14)/4;
        [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(14);
            make.height.width.offset(45);
            make.centerY.offset(0);
        }];

        [self.number mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.icon.mas_bottom).offset(0);
            make.height.offset(20);
            make.left.mas_equalTo(self.icon.mas_right).offset(5);
        }];
        for (int i = 0;i<4;i++) {
            UILabel *lab = [UILabel new];
            [self.contentView addSubview:lab];
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(leftMargin+i*width);
                make.width.offset(width);
                make.top.bottom.offset(0);
            }];
            lab.font = kFont12;
            lab.textColor = kCommonTextColor;
            lab.textAlignment = NSTextAlignmentCenter;
            if (i == 0) {
                self.location = lab;
            } else if (i == 1){
                self.height = lab;
            } else if (i == 2){
                self.weight = lab;
            } else if (i == 3){
                self.prLab = lab;
            }
            
        }
        [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.icon.mas_top).offset(4);
            make.height.offset(20);
            make.right.mas_equalTo(self.location.mas_left).offset(-2);
            make.left.mas_equalTo(self.icon.mas_right).offset(5);
        }];
        UIView *botLine = [UIView new];
        [self.contentView addSubview:botLine];
        [botLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.offset(0);
            make.height.offset(0.5);
        }];
        botLine.backgroundColor = HEXColor(0xE3E2E2);
        
    }
    return self;
}
- (void)setRightLabsHidden:(BOOL)hidden {
    [self.name mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.icon.mas_right).offset(5);
        make.height.offset(20);
        if (hidden == YES) {
            make.centerY.offset(0);
        } else {
            make.top.mas_equalTo(self.icon.mas_top).offset(4);
            make.right.mas_equalTo(self.location.mas_left).offset(-2);
        }
    }];
    self.location.hidden = self.height.hidden = self.prLab.hidden = self.weight.hidden = self.number.hidden = hidden;
}
- (void)setModel:(QukanPlayerList *)model {
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:kImageNamed(@"Player_defaultAvatar")];
    self.name.text = model.nameJ.length ? model.nameJ : @"--";
    self.number.text = model.number.length ? model.number : @"--";
    self.location.text = model.place.length ? model.place : @"--";
    self.height.text = model.tallness.length ? model.tallness : @"--";
    self.weight.text = model.weight.length ? model.weight : @"--";
    if (model.salary.length) {
        if (model.salary.integerValue == 0) {
            self.prLab.text = @"--";
        } else {
            self.prLab.text = FormatString(@"%@万",model.salary);
        }
    } else {
        self.prLab.text = @"--";
    }
}
- (UIImageView *)icon {
    if (!_icon) {
        _icon = [UIImageView new];
        _icon.layer.cornerRadius = 22.5;
        _icon.contentMode = UIViewContentModeScaleAspectFit;
        _icon.layer.masksToBounds = 1;
        _icon.backgroundColor = kCommonWhiteColor;
    }
    return _icon;
}
- (UILabel *)name {
    if (!_name) {
        _name = [UILabel new];
        _name.textColor = kCommonTextColor;
        _name.font = kFont12;
        _name.numberOfLines = 0;
    }
    return _name;
}
- (UILabel *)number {
    if (!_number) {
        _number = [UILabel new];
        _number.font = kFont12;
        _number.textColor = kCommonTextColor;
    }
    return _number;
}
- (UILabel *)location {
    if (!_location) {
        _location = [UILabel new];
    }
    return _location;
}
- (UILabel *)height {
    if (!_height) {
        _height = [UILabel new];
    }
    return _height;
}
- (UILabel *)weight {
    if (!_weight) {
        _weight = [UILabel new];
    }
    return _weight;
}
- (UILabel *)prLab {
    if (!_prLab) {
        _prLab = [UILabel new];
    }
    return _prLab;
}
@end
