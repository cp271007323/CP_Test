//
//  QukanMatchDetailDataQDZJCell.m
//  Qukan
//
//  Created by leo on 2019/12/31.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanMatchDetailDataQDZJHeaderCell.h"

@interface QukanMatchDetailDataQDZJHeaderCell ()

/**时间lab*/
@property(nonatomic, strong) UILabel   * lab_time;



/**比分*/
@property(nonatomic, strong) UILabel   * lab_bifeng;

/**让球*/
@property(nonatomic, strong) UILabel   * lab_rangqiu;

/**大小*/
@property(nonatomic, strong) UILabel   * lab_daxiao;

@end


@implementation QukanMatchDetailDataQDZJHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = HEXColor(0xEAEAEA);
        [self initUI];
    }
    return self;
}

- (void)initUI {
    // 长的是短的2倍
    CGFloat scale = 2;
    // 求出最短的距离
    CGFloat minWidth = kScreenWidth / (scale +  scale + scale + scale);
    
    [self.contentView addSubview:self.lab_time];
    [self.lab_time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView);
        make.width.equalTo(@(scale * minWidth));
    }];
    
    [self.contentView addSubview:self.lab_homeName];
    [self.lab_homeName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lab_time.mas_right);
        make.top.bottom.equalTo(self.contentView);
        make.width.equalTo(@(scale * minWidth));
    }];
    
    [self.contentView addSubview:self.lab_bifeng];
    [self.lab_bifeng mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.lab_homeName.mas_right);
        make.width.equalTo(@(scale * minWidth));
    }];
    
   
    [self.contentView addSubview:self.lab_awayName];
    [self.lab_awayName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lab_bifeng.mas_right);
        make.top.bottom.equalTo(self.contentView);
        make.width.equalTo(@(scale * minWidth));
    }];
    
//    [self.contentView addSubview:self.lab_rangqiu];
//    [self.lab_rangqiu mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.equalTo(self.contentView);
//        make.left.equalTo(self.lab_awayName.mas_right);
//        make.width.equalTo(@(minWidth));
//    }];
//
//
//    [self.contentView addSubview:self.lab_daxiao];
//    [self.lab_daxiao mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.equalTo(self.contentView);
//        make.left.equalTo(self.lab_rangqiu.mas_right);
//        make.width.equalTo(@(minWidth));
//    }];
}


- (void)setLabWithLab:(UILabel *)lab {
    lab.font = kFont10;
    lab.textColor = kTextGrayColor;
}

#pragma mark ===================== lazy ==================================
- (UILabel *)lab_time {
    if (!_lab_time) {
        _lab_time = [UILabel new];
        _lab_time.textAlignment = NSTextAlignmentCenter;
        _lab_time.text = @"日期赛事";
        [self setLabWithLab:_lab_time];
    }
    return _lab_time;
}


- (UILabel *)lab_homeName {
    if (!_lab_homeName) {
        _lab_homeName = [UILabel new];
        _lab_homeName.textAlignment = NSTextAlignmentCenter;
        _lab_homeName.text = @"主队";
         [self setLabWithLab:_lab_homeName];
    }
    return _lab_homeName;
}


- (UILabel *)lab_bifeng {
    if (!_lab_bifeng) {
        _lab_bifeng = [UILabel new];
        _lab_bifeng.textAlignment = NSTextAlignmentCenter;
        _lab_bifeng.text = @"比分";
         [self setLabWithLab:_lab_bifeng];
    }
    return _lab_bifeng;
}

- (UILabel *)lab_awayName {
    if (!_lab_awayName) {
        _lab_awayName = [UILabel new];
        _lab_awayName.textAlignment = NSTextAlignmentCenter;
        _lab_awayName.text = @"客队";
         [self setLabWithLab:_lab_awayName];
    }
    return _lab_awayName;
}


- (UILabel *)lab_rangqiu {
    if (!_lab_rangqiu) {
        _lab_rangqiu = [UILabel new];
        _lab_rangqiu.textAlignment = NSTextAlignmentCenter;
        _lab_rangqiu.text = @"让球";
         [self setLabWithLab:_lab_rangqiu];
    }
    return _lab_rangqiu;
}

- (UILabel *)lab_daxiao {
    if (!_lab_daxiao) {
        _lab_daxiao = [UILabel new];
        _lab_daxiao.textAlignment = NSTextAlignmentCenter;
        _lab_daxiao.text = @"大小";
         [self setLabWithLab:_lab_daxiao];
    }
    return _lab_daxiao;
}

@end
