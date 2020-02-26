//
//  QukanMatchDetailDataJSTJCell.m
//  Qukan
//
//  Created by leo on 2019/12/30.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanMatchDetailDataJSTJCell.h"

#import "QukanMatchDetailJSTJModel.h"

@interface QukanMatchDetailDataJSTJCell ()

/**全场*/
@property(nonatomic, strong) UILabel   * lab_quanchang;
/**赛*/
@property(nonatomic, strong) UILabel   * lab_sai;
/**胜*/
@property(nonatomic, strong) UILabel   * lab_sheng;
/**平*/
@property(nonatomic, strong) UILabel   * lab_ping;
/**负*/
@property(nonatomic, strong) UILabel   * lab_fu;

/**得*/
@property(nonatomic, strong) UILabel   * lab_de;
/**失*/
@property(nonatomic, strong) UILabel   * lab_shi;
/**净*/
@property(nonatomic, strong) UILabel   * lab_jin;
/**积分*/
@property(nonatomic, strong) UILabel   * lab_jf;
/**排名*/
@property(nonatomic, strong) UILabel   * lab_paiming;
/**胜率*/
@property(nonatomic, strong) UILabel   * lab_shenglv;

@end


@implementation QukanMatchDetailDataJSTJCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}



- (void)initUI {
    // 长的是短的2倍
    CGFloat scale = 1.5;
    // 求出最短的距离
    CGFloat minWidth = kScreenWidth / (scale + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1);
    
    [self.contentView addSubview:self.lab_quanchang];
    [self.lab_quanchang mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.top.bottom.equalTo(self.contentView);
        make.width.equalTo(@(scale * minWidth));
    }];
    
    [self.contentView addSubview:self.lab_sai];
    [self.lab_sai mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lab_quanchang.mas_right);
        make.top.bottom.equalTo(self.contentView);
        make.width.equalTo(@(1 * minWidth));
    }];
    
    [self.contentView addSubview:self.lab_sheng];
    [self.lab_sheng mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lab_sai.mas_right);
        make.top.bottom.equalTo(self.contentView);
        make.width.equalTo(@(1 * minWidth));
    }];
    
    [self.contentView addSubview:self.lab_ping];
    [self.lab_ping mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lab_sheng.mas_right);
        make.top.bottom.equalTo(self.contentView);
        make.width.equalTo(@(1 * minWidth));
    }];
//
    [self.contentView addSubview:self.lab_fu];
    [self.lab_fu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lab_ping.mas_right);
        make.top.bottom.equalTo(self.contentView);
        make.width.equalTo(@(1 * minWidth));
    }];

    [self.contentView addSubview:self.lab_de];
    [self.lab_de mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lab_fu.mas_right);
        make.top.bottom.equalTo(self.contentView);
        make.width.equalTo(@(1 * minWidth));
    }];

    [self.contentView addSubview:self.lab_shi];
    [self.lab_shi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lab_de.mas_right);
        make.top.bottom.equalTo(self.contentView);
        make.width.equalTo(@(1 * minWidth));
    }];

    [self.contentView addSubview:self.lab_jin];
    [self.lab_jin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lab_shi.mas_right);
        make.top.bottom.equalTo(self.contentView);
        make.width.equalTo(@(1 * minWidth));
    }];
    
    [self.contentView addSubview:self.lab_jf];
    [self.lab_jf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lab_jin.mas_right);
        make.top.bottom.equalTo(self.contentView);
        make.width.equalTo(@(1 * minWidth));
    }];

    [self.contentView addSubview:self.lab_paiming];
    [self.lab_paiming mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lab_jf.mas_right);
        make.top.bottom.equalTo(self.contentView);
        make.width.equalTo(@(1 * minWidth));
    }];

    [self.contentView addSubview:self.lab_shenglv];
    [self.lab_shenglv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lab_paiming.mas_right);
        make.top.bottom.equalTo(self.contentView);
        make.width.equalTo(@(1 * minWidth));
    }];
}


- (void)fullCellWithData:(QukanMatchDetailJSTJModel *)model andIndex:(NSInteger)index {
    if (index == 0) {
        self.contentView.backgroundColor = HEXColor(0xEAEAEA);
        NSArray *titleArr = @[@"全场",@"赛",@"胜",@"平",@"负",@"得",@"失",@"净",@"积分",@"排名",@"胜率"];
        for (NSInteger i = 0; i < titleArr.count; i ++) {
            UIView *v =  [self.contentView viewWithTag:10086 + i];
            if ([v isKindOfClass:[UILabel class]]) {
                UILabel *lab = (UILabel *)v;
                lab.text = titleArr[i];
                [self setLabWithLab:lab andType:@"1"];
            }
        }
    }else {
        
        if (index % 2 != 0) {
            self.contentView.backgroundColor = kCommonWhiteColor;
        }else {
            self.contentView.backgroundColor = HEXColor(0xFAFAFA);
        }
        
        QukanMatchDetailJSTJDetailModel *modelD = nil;
        NSString *strD = @"";
        if (index == 1) {
            strD = @"总";
            modelD = model.totalScores;
        }
        if (index == 2) {
            strD = @"主";
            modelD = model.homeScores;
        }
        if (index == 3) {
            strD = @"客";
            modelD = model.awayScores;
        }
        
        if (modelD) {
            NSArray *arr =@[strD,modelD.scene,modelD.win,modelD.flat,modelD.negative,modelD.haveTo,modelD.lose,modelD.bare,modelD.jifen,modelD.sort,[NSString stringWithFormat:@"%.1ld%@",modelD.succesRage,@"%"]];
            for (NSInteger i = 0; i < arr.count; i ++) {
                UIView *v =  [self.contentView viewWithTag:10086 + i];
                if ([v isKindOfClass:[UILabel class]]) {
                    UILabel *lab = (UILabel *)v;
                    lab.text = arr[i];
                    [self setLabWithLab:lab andType:@"2"];
                }
            }
        }
    }
}


- (void)setLabWithLab:(UILabel *)lab andType:(NSString *)type{
    lab.font = kFont12;
    lab.textAlignment = NSTextAlignmentCenter;
    if (![type isEqualToString:@"1"]) {
        lab.textColor = kCommonDarkGrayColor;
    }else {
        lab.textColor = kTextGrayColor;
    }
}


#pragma mark ===================== lazy ==================================

- (UILabel *)lab_quanchang {
    if (!_lab_quanchang) {
        _lab_quanchang = [UILabel new];
        _lab_quanchang.tag = 10086;

    }
    return _lab_quanchang;
}
- (UILabel *)lab_sai {
    if (!_lab_sai) {
        _lab_sai = [UILabel new];
        _lab_sai.tag = 10087;
    }
    return _lab_sai;
}
- (UILabel *)lab_sheng {
    if (!_lab_sheng) {
        _lab_sheng = [UILabel new];
        _lab_sheng.tag = 10088;
    }
    return _lab_sheng;
}
- (UILabel *)lab_ping {
    if (!_lab_ping) {
        _lab_ping = [UILabel new];
        _lab_ping.tag = 10089;
    }
    return _lab_ping;
}
- (UILabel *)lab_fu {
    if (!_lab_fu) {
        _lab_fu = [UILabel new];
        _lab_fu.tag = 10090;
    }
    return _lab_fu;
}
- (UILabel *)lab_de {
    if (!_lab_de) {
        _lab_de = [UILabel new];
        _lab_de.tag = 10091;
    }
    return _lab_de;
}
- (UILabel *)lab_shi {
    if (!_lab_shi) {
        _lab_shi = [UILabel new];
        _lab_shi.tag = 10092;
    }
    return _lab_shi;
}
- (UILabel *)lab_jin {
    if (!_lab_jin) {
        _lab_jin = [UILabel new];
        _lab_jin.tag = 10093;
    }
    return _lab_jin;
}

- (UILabel *)lab_jf {
    if (!_lab_jf) {
        _lab_jf = [UILabel new];
        _lab_jf.tag = 10094;
    }
    return _lab_jf;
}
- (UILabel *)lab_paiming {
    if (!_lab_paiming) {
        _lab_paiming = [UILabel new];
        _lab_paiming.tag = 10095;
    }
    return _lab_paiming;
}
- (UILabel *)lab_shenglv {
    if (!_lab_shenglv) {
        _lab_shenglv = [UILabel new];
        _lab_shenglv.tag = 10096;
    }
    return _lab_shenglv;
}

@end
