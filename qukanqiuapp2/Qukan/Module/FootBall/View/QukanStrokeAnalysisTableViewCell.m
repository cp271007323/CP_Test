//
//  QukanStrokeAnalysisTableViewCell.m
//  Qukan
//
//  Created by Kody on 2019/12/27.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanStrokeAnalysisTableViewCell.h"

@interface QukanStrokeAnalysisTableViewCell ()

@property(nonatomic, strong) UILabel *homeTeamNumber_label;
@property(nonatomic, strong) UILabel *guestTeamNumber_label;
@property(nonatomic, strong) UILabel *type_label;
@property(nonatomic, strong) UILabel *homeTeamAll_label;
@property(nonatomic, strong) UILabel *guestTeamAll_label;
@property(nonatomic, strong) UILabel *homeTeamColor_label;
@property(nonatomic, strong) UILabel *guestTeamColor_label;

@end

@implementation QukanStrokeAnalysisTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
        self.selectionStyle = 0;
    }
    return self;
}

- (void)initUI {
    [self.contentView addSubview:self.homeTeamNumber_label];
    [self.homeTeamNumber_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(8);
        make.left.offset(8);
        make.width.offset(29);
        make.height.offset(15);
    }];
    
    [self.contentView addSubview:self.guestTeamNumber_label];
    [self.guestTeamNumber_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.height.mas_equalTo(self.homeTeamNumber_label);
        make.right.offset(-8);
    }];
    
    [self.contentView addSubview:self.type_label];
    [self.type_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(80);
        make.top.height.mas_equalTo(self.homeTeamNumber_label);
        make.centerX.mas_equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.homeTeamAll_label];
    [self.homeTeamAll_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.mas_equalTo(self.homeTeamNumber_label);
        make.left.mas_equalTo(self.homeTeamNumber_label.mas_right).offset(8);
        make.right.mas_equalTo(self.type_label.mas_left).offset(-3);
    }];
    
    [self.contentView addSubview:self.guestTeamAll_label];
    [self.guestTeamAll_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.mas_equalTo(self.homeTeamNumber_label);
        make.left.mas_equalTo(self.type_label.mas_right).offset(3);
        make.right.mas_equalTo(self.guestTeamNumber_label.mas_left).offset(-3);
    }];
    
    [self.homeTeamAll_label addSubview:self.homeTeamColor_label];
    [self.homeTeamColor_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.offset(0);
        make.width.offset(0);
    }];
    
    [self.guestTeamAll_label addSubview:self.guestTeamColor_label];
    [self.guestTeamColor_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.offset(0);
        make.width.offset(0);
    }];
}

#pragma mark ===================== Public Methods =======================

//设置足球哦
- (void)setFootDataWithArray:(NSArray *)array {
    if (!array || array.count==0) {
       self.type_label.text = @"";
       self.homeTeamNumber_label.text = @"";
       self.guestTeamNumber_label.text = @"";
       return;
   }
   if (array.count>=1) {
       self.type_label.text = [NSString stringWithFormat:@"%@", array[0]];
   } else {
       self.type_label.text = @"";
   }
   if (array.count>=2) {
       self.homeTeamNumber_label.text = [NSString stringWithFormat:@"%@", array[1]];
       if ([self isRatioWithText:self.type_label.text]) {
           float num = [array[1] floatValue] * 100;
           self.homeTeamNumber_label.text = [NSString stringWithFormat:@"%.0f%%", num];
       }
   } else {
       self.homeTeamNumber_label.text = @"";
   }
   if (array.count>=3) {
       self.guestTeamNumber_label.text = [NSString stringWithFormat:@"%@", array[2]];
       if ([self isRatioWithText:self.type_label.text]) {
           float num = [array[1] floatValue] * 100;
           self.guestTeamNumber_label.text = [NSString stringWithFormat:@"%.0f%%", num];
       }
   } else {
       self.guestTeamNumber_label.text = @"";
   }
    
    if (array.count >= 4) {
        CGFloat bl = [[array objectAtIndex:3] doubleValue];
//        if (bl < 0.5) {
//            self.homeTeamColor_label.backgroundColor = kTextGrayColor;
//        }
        self.homeTeamColor_label.backgroundColor = bl < 0.5? kTextGrayColor : kThemeColor;
        [self.homeTeamColor_label mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.offset(0);
            make.width.mas_equalTo(self.homeTeamAll_label.mas_width).multipliedBy(bl);
        }];
    }
    
    if (array.count >= 5) {
        CGFloat bl = [[array objectAtIndex:4] doubleValue];
//        if (bl > 0.5) {
//            self.guestTeamColor_label.backgroundColor = kThemeColor;
//        }
        self.guestTeamColor_label.backgroundColor = bl < 0.5? kTextGrayColor:kThemeColor;

        [self.guestTeamColor_label mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.offset(0);
            make.width.mas_equalTo(self.guestTeamAll_label.mas_width).multipliedBy(bl);
        }];
    }
}

-(BOOL)isRatioWithText:(NSString *)text {
    return ([text isEqualToString:@"控球时间"]
            || [text isEqualToString:@"半场控球"]
            || [text isEqualToString:@"传球成功率"]
            || [text isEqualToString:@"控球率"]
            || [text isEqualToString:@"半场控球率"]
            || [text containsString:@"率"]);
}


//设置篮球
- (void)setBasketDataWithIndex:(NSInteger)index {

    self.type_label.text = [self.titles objectAtIndex:index];
    if (index == 0) {//命中率
        float guest_shoot_rate = [self guestShootRate];
        float home_shoot_rate = [self homeShootRate];
        [self setBasketDataAndSubViewsWithGuestData:guest_shoot_rate * 100 withHomeData:home_shoot_rate * 100];
    } else if (index == 1) {//三分命中
        float guest_three_minhit = [self guestThreeminHit];
        float home_three_minhit = [self homeThreeminHit];
        [self setBasketDataWithGuestData:guest_three_minhit withHomeData:home_three_minhit];
    } else if (index == 2) {//助攻
       float guest_help_attack = [self guestHelpAttack];
       float home_help_attack =  [self homeHelpAttack];
        [self setBasketDataWithGuestData:guest_help_attack withHomeData:home_help_attack];
    } else if (index == 3) {//篮板
        float guest_backboard = [self guestBackboard];
        float home_backboard =  [self homeBackboard];
         [self setBasketDataWithGuestData:guest_backboard withHomeData:home_backboard];
    } else if (index == 4) {//前板
        float guest_attack = [self guestAttack];
        float home_attack =  [self homeAttack];
         [self setBasketDataWithGuestData:guest_attack withHomeData:home_attack];
    } else if (index == 5) {//后板
        float guest_defend = [self guestDefend];
        float home_defend =  [self homeDefend];
         [self setBasketDataWithGuestData:guest_defend withHomeData:home_defend];
    } else if (index == 6) {//抢断
        float guest_rob = [self guestRob];
        float home_rob =  [self homeRob];
         [self setBasketDataWithGuestData:guest_rob withHomeData:home_rob];
    } else if (index == 7) {//失误
        float guest_misPlay = [self guestMisPlay];
        float home_misPlay =  [self homeMisPlay];
         [self setBasketDataWithGuestData:guest_misPlay withHomeData:home_misPlay];
    } else if (index == 8) {//罚球
       float guest_hit = [self guestPunishballHit];
       float home_hit =  [self homePunishballHit];
        [self setBasketDataWithGuestData:guest_hit withHomeData:home_hit];
    } else if (index == 9) {//犯规
       float guest_foul = [self guestFoul];
       float home_foul =  [self homeFoul];
        [self setBasketDataWithGuestData:guest_foul withHomeData:home_foul];
    }  else if (index == 10) {//盖帽
       float guest_cover = [self guestCover];
       float home_cover =  [self homeCover];
       [self setBasketDataWithGuestData:guest_cover withHomeData:home_cover];
    }
}

- (void)setBasketDataAndSubViewsWithGuestData:(float)guestFloat withHomeData:(float)homeFloat {

    self.homeTeamNumber_label.text = FormatString(@"%.0lf%%",guestFloat);
    [self.homeTeamColor_label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.offset(0);
        make.width.mas_equalTo(self.homeTeamAll_label.mas_width).multipliedBy(guestFloat > 1 ? guestFloat / 100 : guestFloat);
    }];
    
    self.guestTeamNumber_label.text = FormatString(@"%.0lf%%",homeFloat);
    [self.guestTeamColor_label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.offset(0);
        make.width.mas_equalTo(self.guestTeamAll_label.mas_width).multipliedBy(homeFloat > 1 ? homeFloat / 100 : homeFloat);
    }];
}

- (void)setBasketDataWithGuestData:(float)guestFloat withHomeData:(float)homeFloat {
    self.homeTeamNumber_label.text = FormatString(@"%.0lf",guestFloat);
    float allNumber = guestFloat + homeFloat;
    allNumber = allNumber == 0 ? 1 : allNumber;
    CGFloat guest_rote = allNumber == 0 ? 0 : (CGFloat)guestFloat / (CGFloat) allNumber;
    [self.homeTeamColor_label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.offset(0);
        make.width.mas_equalTo(self.homeTeamAll_label.mas_width).multipliedBy(guest_rote);
    }];
    
    self.guestTeamNumber_label.text = FormatString(@"%.0lf",homeFloat);
    CGFloat home_rote = allNumber == 0 ? 0 : (CGFloat)homeFloat / (CGFloat)allNumber;
    [self.guestTeamColor_label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.offset(0);
        make.width.mas_equalTo(self.guestTeamAll_label.mas_width).multipliedBy(home_rote);
    }];
}

#pragma mark ===================== DataDeal ==================================

- (float)guestShootRate {
    //命中率
    //客队数据处理
    if (!self.guestList.count) {
        return 0;
    }
    NSArray *guestHasShoot = [[self.guestList.rac_sequence filter:^BOOL(QukanHomeAndGuestPlayerListModel *model) {
        return ![model.shoot isEqualToString:@"0"];
    }] array];
    if (guestHasShoot == nil) {
        return 0;
    }
    float guestShootHitSum = [self getSumFor:guestHasShoot keyPath:@"@sum.shootHit"];
    float guestShootSum = [self getSumFor:guestHasShoot keyPath:@"@sum.shoot"];
    float guestShootRate = guestShootSum == 0 ? 0 : guestShootHitSum/guestShootSum;
    return guestShootRate;
}

- (float)homeShootRate {
    //命中率
    //主队数据处理
    if (!self.homeList.count) {
        return 0;
    }
    NSArray *homeHasShoot = [[self.homeList.rac_sequence filter:^BOOL(QukanHomeAndGuestPlayerListModel *model) {
        return ![model.shoot isEqualToString:@"0"];
    }] array];
    if (homeHasShoot == nil) {
        return 0;
    }
    float homeShootHitSum = [self getSumFor:homeHasShoot keyPath:@"@sum.shootHit"];
    float homeShootSum = [self getSumFor:homeHasShoot keyPath:@"@sum.shoot"];
    float homeShootRate = homeShootSum == 0 ? 0 : homeShootHitSum/homeShootSum;
    return homeShootRate;
}

- (float)guestThreeminHit {
    //客队三分命中总数
    if (!self.guestList.count) {
        return 0;
    }
   // float sum = [[self.guestList valueForKeyPath:@"@sum.threeminHit"] floatValue];
    float sum = [self getSumFor:self.guestList keyPath:@"@sum.threeminHit"];
    if (self.guestList == nil) {
        return 0;
    }
    return sum;
}
- (float)homeThreeminHit {
    //主队三分命中总数
    if (!self.homeList.count) {
        return 0;
    }
   // float sum = [[self.homeList valueForKeyPath:@"@sum.threeminHit"] floatValue];
    float sum = [self getSumFor:self.homeList keyPath:@"@sum.threeminHit"];
    if (self.homeList == nil) {
        return 0;
    }
    return sum;
}
- (float)guestHelpAttack {
    //客队助攻总数
    if (!self.guestList.count) {
        return 0;
    }
   // float sum = [[self.guestList valueForKeyPath:@"@sum.helpAttack"] floatValue];
    float sum = [self getSumFor:self.guestList keyPath:@"@sum.helpAttack"];
    if (self.guestList == nil) {
        return 0;
    }
    return sum;
}
- (float)homeHelpAttack {
    //主队助攻总数
    if (!self.homeList.count) {
        return 0;
    }
//    float sum = [[self.homeList valueForKeyPath:@"@sum.helpAttack"] floatValue];
    float sum = [self getSumFor:self.homeList keyPath:@"@sum.helpAttack"];
    if (self.homeList == nil) {
        return 0;
    }
    return sum;
}
- (float)guestBackboard {
    //客队篮板总数
    if (!self.guestList.count) {
        return 0;
    }
   // float sum1 = [[self.guestList valueForKeyPath:@"@sum.attack"] floatValue];
    float sum1 = [self getSumFor:self.guestList keyPath:@"@sum.attack"];
//    float sum2 = [[self.guestList valueForKeyPath:@"@sum.defend"] floatValue];
    float sum2 = [self getSumFor:self.guestList keyPath:@"@sum.defend"];
    if (self.guestList == nil) {
        return 0;
    }
    return sum1 + sum2;
}
- (float)homeBackboard {
    //主队篮板总数
    if (!self.homeList.count) {
        return 0;
    }
//    float sum1 = [[self.homeList valueForKeyPath:@"@sum.attack"] floatValue];
    float sum1 = [self getSumFor:self.homeList keyPath:@"@sum.attack"];
//    float sum2 = [[self.homeList valueForKeyPath:@"@sum.defend"] floatValue];
    float sum2 = [self getSumFor:self.homeList keyPath:@"@sum.defend"];
    if (self.homeList == nil) {
        return 0;
    }
    return sum1 + sum2;
}
- (float)guestAttack {
    //客队进攻篮板总数
    if (!self.guestList.count) {
        return 0;
    }
//    float sum = [[self.guestList valueForKeyPath:@"@sum.attack"] floatValue];
    float sum = [self getSumFor:self.guestList keyPath:@"@sum.attack"];
    if (self.guestList == nil) {
        return 0;
    }
    return sum;
}
- (float)homeAttack {
    //主队进攻篮板总数
    if (!self.homeList.count) {
        return 0;
    }
//    float sum = [[self.homeList valueForKeyPath:@"@sum.attack"] floatValue];
    float sum = [self getSumFor:self.homeList keyPath:@"@sum.attack"];
    if (self.homeList == nil) {
        return 0;
    }
    return sum;
}
- (float)guestDefend {
    //客队防守篮板总数
    if (!self.guestList.count) {
        return 0;
    }
//    float sum = [[self.guestList valueForKeyPath:@"@sum.defend"] floatValue];
    float sum = [self getSumFor:self.guestList keyPath:@"@sum.defend"];
    if (self.guestList == nil) {
        return 0;
    }
    return sum;
}
- (float)homeDefend {
    //主队防守篮板总数
    if (!self.homeList.count) {
        return 0;
    }
//    float sum = [[self.homeList valueForKeyPath:@"@sum.defend"] floatValue];
    float sum = [self getSumFor:self.homeList keyPath:@"@sum.defend"];
    if (self.homeList == nil) {
        return 0;
    }
    return sum;
}
- (float)guestRob {
    //客队抢断总数
    if (!self.guestList.count) {
        return 0;
    }
//    float sum = [[self.guestList valueForKeyPath:@"@sum.rob"] floatValue];
    float sum = [self getSumFor:self.guestList keyPath:@"@sum.rob"];
    if (self.guestList == nil) {
        return 0;
    }
    return sum;
}
- (float)homeRob {
    //主队抢断总数
    if (!self.homeList.count) {
        return 0;
    }
//    float sum = [[self.homeList valueForKeyPath:@"@sum.rob"] floatValue];
    float sum = [self getSumFor:self.homeList keyPath:@"@sum.rob"];
    if (self.homeList == nil) {
        return 0;
    }
    return sum;
}
- (float)guestMisPlay {
    //客队失误总数
    if (!self.guestList.count) {
        return 0;
    }
//    float sum = [[self.guestList valueForKeyPath:@"@sum.misPlay"] floatValue];
    float sum = [self getSumFor:self.guestList keyPath:@"@sum.misPlay"];
    if (self.guestList == nil) {
        return 0;
    }
    return sum;
}
- (float)homeMisPlay {
    //主队失误总数
    if (!self.homeList.count) {
        return 0;
    }
    float sum = [self getSumFor:self.homeList keyPath:@"@sum.misPlay"];
//    float sum = [[self.homeList valueForKeyPath:@"@sum.misPlay"] floatValue];
    if (self.homeList == nil) {
        return 0;
    }
    return sum;
}
- (float)guestPunishballHit {
    //客队罚球命中总数
    if (!self.guestList.count) {
        return 0;
    }
//    float sum = [[self.guestList valueForKeyPath:@"@sum.punishballHit"] floatValue];
    float sum = [self getSumFor:self.guestList keyPath:@"@sum.punishballHit"];
    if (self.guestList == nil) {
        return 0;
    }
    return sum;
}
- (float)homePunishballHit {
    //主队罚球命中总数
    if (!self.homeList.count) {
        return 0;
    }
//    float sum = [[self.homeList valueForKeyPath:@"@sum.punishballHit"] floatValue];
    float sum = [self getSumFor:self.homeList keyPath:@"@sum.punishballHit"];
    if (self.homeList == nil) {
        return 0;
    }
    return sum;
}

- (float)guestFoul {
    //客队犯规总数
    if (!self.guestList.count) {
        return 0;
    }
//    float sum = [[self.guestList valueForKeyPath:@"@sum.foul"] floatValue];
    float sum = [self getSumFor:self.guestList keyPath:@"@sum.foul"];
    if (self.guestList == nil) {
        return 0;
    }
    return sum;
}
- (float)homeFoul {
    //主队犯规总数
    if (!self.homeList.count) {
        return 0;
    }
//    float sum = [[self.homeList valueForKeyPath:@"@sum.foul"] floatValue];
    float sum = [self getSumFor:self.homeList keyPath:@"@sum.foul"];
    if (self.homeList == nil) {
        return 0;
    }
    return sum;
}

- (float)guestCover {
    //客队盖帽总数
    if (!self.guestList.count) {
        return 0;
    }
//    float sum = [[self.guestList valueForKeyPath:@"@sum.cover"] floatValue];
    float sum = [self getSumFor:self.guestList keyPath:@"@sum.cover"];
    if (self.guestList == nil) {
        return 0;
    }
    return sum;
}
- (float)homeCover {
    //主队盖帽总数
    if (!self.homeList.count) {
        return 0;
    }
//    float sum = [[self.homeList valueForKeyPath:@"@sum.cover"] floatValue];
    float sum = [self getSumFor:self.homeList keyPath:@"@sum.cover"];
    if (self.homeList == nil) {
        return 0;
    }
    return sum;
}

- (float)getSumFor:(NSArray *)array keyPath:(NSString *)keyPath {
    NSNumber *sum = [array valueForKeyPath:keyPath];
    if ([sum isKindOfClass:[NSNull class]]) {
        return 0;
    }
    return isnan([sum floatValue]) ? 0 : [sum floatValue];
}

#pragma mark ===================== Getters =================================

- (UILabel *)homeTeamNumber_label {
    if (!_homeTeamNumber_label) {
        _homeTeamNumber_label = UILabel.new;
        _homeTeamNumber_label.textColor = kCommonDarkGrayColor;
        _homeTeamNumber_label.font = kFont12;
        _homeTeamNumber_label.textAlignment = NSTextAlignmentRight;
    }
    return _homeTeamNumber_label;
}

- (UILabel *)guestTeamNumber_label {
    if (!_guestTeamNumber_label) {
        _guestTeamNumber_label = UILabel.new;
        _guestTeamNumber_label.textColor = kCommonDarkGrayColor;
        _guestTeamNumber_label.font = kFont12;
    }
    return _guestTeamNumber_label;
}

- (UILabel *)type_label {
    if (!_type_label) {
        _type_label = UILabel.new;
        _type_label.font = kFont12;
        _type_label.textColor = kCommonDarkGrayColor;
        _type_label.textAlignment = NSTextAlignmentCenter;
    }
    return _type_label;
}

- (UILabel *)homeTeamAll_label {
    if (!_homeTeamAll_label) {
        _homeTeamAll_label = UILabel.new;
        _homeTeamAll_label.backgroundColor = HEXColor(0xD8D8D8);
    }
    return _homeTeamAll_label;
}

- (UILabel *)guestTeamAll_label {
    if (!_guestTeamAll_label) {
        _guestTeamAll_label = UILabel.new;
        _guestTeamAll_label.backgroundColor = HEXColor(0xD8D8D8);
    }
    return _guestTeamAll_label;
}

- (UILabel *)homeTeamColor_label {
    if (!_homeTeamColor_label) {
        _homeTeamColor_label = UILabel.new;
        _homeTeamColor_label.backgroundColor = kThemeColor;
    }
    return _homeTeamColor_label;
}

- (UILabel *)guestTeamColor_label {
    if (!_guestTeamColor_label) {
        _guestTeamColor_label = UILabel.new;
        _guestTeamColor_label.backgroundColor = kTextGrayColor;
    }
    return _guestTeamColor_label;
}

@end
