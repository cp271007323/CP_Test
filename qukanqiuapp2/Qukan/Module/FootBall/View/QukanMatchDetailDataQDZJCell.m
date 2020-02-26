//
//  QukanMatchDetailDataQDZJCell.m
//  Qukan
//
//  Created by leo on 2019/12/30.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanMatchDetailDataQDZJCell.h"
#import "QukanMatchDetailHistoryModel.h"
#import "QukanBasketDetailDataModel.h"
#import "QukanNSDate+Time.h"


@interface QukanMatchDetailDataQDZJCell ()

/**时间lab*/
@property(nonatomic, strong) UILabel   * lab_time;
/**联赛lab*/
@property(nonatomic, strong) UILabel   * lab_league;

/**主队lab*/
@property(nonatomic, strong) UILabel   * lab_homeName;

/**客队lab*/
@property(nonatomic, strong) UILabel   * lab_awayName;

/**比分1*/
@property(nonatomic, strong) UILabel   * lab_bifengTop;

/**比分2*/
@property(nonatomic, strong) UILabel   * lab_bifengBottom;

///**让球1*/
//@property(nonatomic, strong) UILabel   * lab_rangqiuTop;
///**让球2*/
//@property(nonatomic, strong) UILabel   * lab_rangqiuBottom;
//
///**大小1*/
//@property(nonatomic, strong) UILabel   * lab_daxiaoTop;
///**大小2*/
//@property(nonatomic, strong) UILabel   * lab_daxiaoBottom;



@end


@implementation QukanMatchDetailDataQDZJCell

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
    CGFloat scale = 2;
    // 求出最短的距离
    CGFloat minWidth = kScreenWidth / (scale +  scale + scale + scale);
    
    [self.contentView addSubview:self.lab_time];
    [self.lab_time mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView.mas_centerY);
        make.height.equalTo(@(20));
        make.width.equalTo(@(scale * minWidth));
    }];
    
    [self.contentView addSubview:self.lab_league];
    [self.lab_league mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.lab_time);
        make.width.equalTo(self.lab_time.mas_width);
        make.height.equalTo(self.lab_time.mas_height);
    }];

    [self.contentView addSubview:self.lab_homeName];
    [self.lab_homeName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lab_league.mas_right);
        make.top.bottom.equalTo(self.contentView);
        make.width.equalTo(@(scale * minWidth));
    }];

    [self.contentView addSubview:self.lab_bifengTop];
    [self.lab_bifengTop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lab_homeName.mas_right);
        make.width.equalTo(@(scale * minWidth));
//        make.centerY.equalTo(self.lab_time);
        make.centerY.equalTo(self.lab_time.mas_centerY).offset(-6);
    }];

    [self.contentView addSubview:self.lab_bifengBottom];
    [self.lab_bifengBottom mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.lab_league);
        make.centerY.equalTo(self.lab_league.mas_centerY).offset(-6);
        make.centerX.equalTo(self.lab_bifengTop);
        make.width.equalTo(@(56));
        make.height.equalTo(@(20));
    }];

    [self.contentView addSubview:self.lab_awayName];
    [self.lab_awayName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lab_bifengTop.mas_right);
        make.top.bottom.equalTo(self.contentView);
        make.width.equalTo(@(scale * minWidth));
    }];

//    [self.contentView addSubview:self.lab_rangqiuTop];
//    [self.lab_rangqiuTop mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentView);
//        make.left.equalTo(self.lab_awayName.mas_right);
//        make.width.equalTo(@(minWidth));
//    }];
//
//    [self.contentView addSubview:self.lab_rangqiuBottom];
//    [self.lab_rangqiuBottom mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.lab_rangqiuTop.mas_bottom);
//        make.left.equalTo(self.lab_rangqiuTop);
//        make.bottom.equalTo(self.contentView);
//        make.width.equalTo(self.lab_rangqiuTop.mas_width);
//        make.height.equalTo(self.lab_rangqiuTop.mas_height);
//    }];
//
//    [self.contentView addSubview:self.lab_daxiaoTop];
//    [self.lab_daxiaoTop mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentView);
//        make.left.equalTo(self.lab_rangqiuBottom.mas_right);
//        make.width.equalTo(@(minWidth));
//    }];
//
//    [self.contentView addSubview:self.lab_daxiaoBottom];
//    [self.lab_daxiaoBottom mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.lab_daxiaoTop.mas_bottom);
//        make.left.equalTo(self.lab_daxiaoTop);
//        make.bottom.equalTo(self.contentView);
//        make.width.equalTo(self.lab_daxiaoTop.mas_width);
//        make.height.equalTo(self.lab_daxiaoTop.mas_height);
//    }];
}

#pragma mark ===================== function ==================================
// 足球数据赋值
- (void)fullCellWithModel:(QukanMatchDetailHistoryModel *)model andIndex:(NSInteger)index homeName:(NSString *)homeName {
    self.contentView.backgroundColor = index % 2 != 0?kCommonWhiteColor : HEXColor(0xFAFAFA);
    
    NSDate *date = [NSDate dateFromFomate:model.startTime formate:kTimeDetail_Format];
    NSString *timeStr = [NSDate stringFromFomate:date formate:@"YYYY-MM-dd"];
    
    
    self.lab_time.text = timeStr;
    
    self.lab_league.text = model.leagueName;
    
    self.lab_awayName.text = model.awayName;
    self.lab_homeName.text = model.homeName;
    
    self.lab_bifengTop.text = [NSString stringWithFormat:@"%zd-%zd",model.bc1,model.bc2];
    self.lab_bifengBottom.text = [NSString stringWithFormat:@"%zd-%zd",model.homeScore,model.awayScore];
 
    
    self.lab_homeName.font = model.selectTeamIsHomeTeam?[UIFont boldSystemFontOfSize:12]:[UIFont systemFontOfSize:12];
    self.lab_awayName.font = model.selectTeamIsHomeTeam?[UIFont systemFontOfSize:12]:[UIFont boldSystemFontOfSize:12];
    
     if ([model.homeName isEqualToString:homeName]) {
           if (model.homeScore > model.awayScore) {
               self.lab_bifengBottom.backgroundColor = HEXColor(0xFE5C61);
           }else if (model.homeScore < model.awayScore) {
               self.lab_bifengBottom.backgroundColor = HEXColor(0x56A3EA);
           }else {
               self.lab_bifengBottom.backgroundColor = HEXColor(0x18AB3A);
           }
       }else {
           if (model.homeScore > model.awayScore) {
               self.lab_bifengBottom.backgroundColor = HEXColor(0x56A3EA);
           }else if (model.homeScore < model.awayScore) {
               self.lab_bifengBottom.backgroundColor = HEXColor(0xFE5C61);
           }else {
               self.lab_bifengBottom.backgroundColor = HEXColor(0x18AB3A);
           }
       }
}

// 篮球数据赋值
- (void)fullCellWithBasketModel:(QukanBasketDetailHisFightData *)model andIndex:(NSInteger)index {
    self.contentView.backgroundColor = index % 2 != 0?kCommonWhiteColor : HEXColor(0xFAFAFA);
    
    self.lab_time.text = model.startDate;
    self.lab_league.text = model.leagueName;
    
    self.lab_awayName.text = model.homeName;
    self.lab_homeName.text = model.awayName;
    
    self.lab_bifengTop.text = [NSString stringWithFormat:@"%zd-%zd",model.awayHalfScore,model.homeHalfScore];
    self.lab_bifengBottom.text = [NSString stringWithFormat:@"%zd-%zd",model.awayFullScore,model.homeFullScore];
    
    
    self.lab_homeName.font = model.selectTeamIsHomeTeam?[UIFont systemFontOfSize:12]:[UIFont boldSystemFontOfSize:12];
    self.lab_awayName.font = model.selectTeamIsHomeTeam?[UIFont boldSystemFontOfSize:12]:[UIFont systemFontOfSize:12];
    
    if (model.winState == 1) {
        self.lab_bifengBottom.backgroundColor = HEXColor(0xF12B2B);
    }else if (model.winState == 2) {
        self.lab_bifengBottom.backgroundColor = HEXColor(0xF34A6F1);
    }else {
        self.lab_bifengBottom.backgroundColor = HEXColor(0x18AB3A);
    }
}

#pragma mark ===================== lazy ==================================
- (UILabel *)lab_time {
    if (!_lab_time) {
        _lab_time = [UILabel new];
        _lab_time.textAlignment = NSTextAlignmentCenter;
        _lab_time.text = @"--";
        _lab_time.font = [UIFont systemFontOfSize:10];
    }
    return _lab_time;
}

- (UILabel *)lab_league {
    if (!_lab_league) {
        _lab_league = [UILabel new];
        _lab_league.textAlignment = NSTextAlignmentCenter;
        _lab_league.text = @"--";
        _lab_league.font = [UIFont systemFontOfSize:10];
    }
    return _lab_league;
}

- (UILabel *)lab_homeName {
    if (!_lab_homeName) {
        _lab_homeName = [UILabel new];
        _lab_homeName.textAlignment = NSTextAlignmentCenter;
        _lab_homeName.text = @"--";
        _lab_homeName.font = [UIFont systemFontOfSize:12];
        
    }
    return _lab_homeName;
}

- (UILabel *)lab_awayName {
    if (!_lab_awayName) {
        _lab_awayName = [UILabel new];
        _lab_awayName.textAlignment = NSTextAlignmentCenter;
        _lab_awayName.text = @"--";
        _lab_awayName.font = [UIFont systemFontOfSize:12];
    }
    return _lab_awayName;
}

- (UILabel *)lab_bifengTop {
    if (!_lab_bifengTop) {
        _lab_bifengTop = [UILabel new];
        _lab_bifengTop.textAlignment = NSTextAlignmentCenter;
        _lab_bifengTop.text = @"--";
        _lab_bifengTop.textColor = kTextGrayColor;
        _lab_bifengTop.font = [UIFont systemFontOfSize:10];
    }
    return _lab_bifengTop;
}

- (UILabel *)lab_bifengBottom {
    if (!_lab_bifengBottom) {
        _lab_bifengBottom = [UILabel new];
        _lab_bifengBottom.textAlignment = NSTextAlignmentCenter;
        _lab_bifengBottom.text = @"--";
        _lab_bifengBottom.textColor = kCommonWhiteColor;
        _lab_bifengBottom.layer.masksToBounds = YES;
        _lab_bifengBottom.layer.cornerRadius = 10;
        _lab_bifengBottom.backgroundColor = HEXColor(0xF12B2B);
        _lab_bifengBottom.font = [UIFont systemFontOfSize:12];
    }
    return _lab_bifengBottom;
}
//- (UILabel *)lab_rangqiuTop {
//    if (!_lab_rangqiuTop) {
//        _lab_rangqiuTop = [UILabel new];
//        _lab_rangqiuTop.textAlignment = NSTextAlignmentCenter;
//        _lab_rangqiuTop.text = @"--";
//    }
//    return _lab_rangqiuTop;
//}
//- (UILabel *)lab_rangqiuBottom {
//    if (!_lab_rangqiuBottom) {
//        _lab_rangqiuBottom = [UILabel new];
//        _lab_rangqiuBottom.textAlignment = NSTextAlignmentCenter;
//        _lab_rangqiuBottom.text = @"--";
//    }
//    return _lab_rangqiuBottom;
//}
//- (UILabel *)lab_daxiaoTop {
//    if (!_lab_daxiaoTop) {
//        _lab_daxiaoTop = [UILabel new];
//        _lab_daxiaoTop.textAlignment = NSTextAlignmentCenter;
//        _lab_daxiaoTop.text = @"--";
//    }
//    return _lab_daxiaoTop;
//}
//- (UILabel *)lab_daxiaoBottom {
//    if (!_lab_daxiaoBottom) {
//        _lab_daxiaoBottom = [UILabel new];
//        _lab_daxiaoBottom.textAlignment = NSTextAlignmentCenter;
//        _lab_daxiaoBottom.text = @"--";
//    }
//    return _lab_daxiaoBottom;
//}

@end
