//
//  QukanBSKMemberDetailDataTopCell.m
//  Qukan
//
//  Created by blank on 2020/1/4.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanBSKMemberDetailDataTopCell.h"
@interface QukanBSKMemberDetailDataTopCell()
@property (nonatomic, strong)UIView *btnView;
@property (nonatomic, strong)UILabel *playCount;
@property (nonatomic, strong)UILabel *playTime;
@property (nonatomic, strong)UILabel *rebound;
@property (nonatomic, strong)UILabel *helpAttack;
@property (nonatomic, strong)UILabel *rob;
@property (nonatomic, strong)UILabel *cover;
@property (nonatomic, strong)UILabel *score;
@end
@implementation QukanBSKMemberDetailDataTopCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIView *topView = [UIView new];
        [self.contentView addSubview:topView];
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.offset(0);
            make.height.offset(35);
        }];
        topView.backgroundColor = kTableViewCommonBackgroudColor;
        
        UILabel *lab = [UILabel new];
        [topView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.height.offset(17);
            make.centerY.offset(0);
        }];
        lab.text = @"赛季平均数据";
        lab.textColor = kCommonTextColor;
        lab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
        [topView addSubview:self.btnView];
       
        NSArray *titles = @[@"上场次数",@"上场时间",@"篮板",@"助攻",@"抢断",@"盖帽",@"得分"];
        NSArray *margins = @[@(15),@(81),@(148),@(194),@(240),@(287),@(333)];
        NSArray *widths = @[@(40),@(40),@(40),@(40),@(40),@(40),@(40)];
        
        UIView *whiteV = [UIView new];
        [self.contentView addSubview:whiteV];
        [whiteV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.top.offset(35);
            make.height.offset(50);
        }];
        whiteV.backgroundColor = kCommonWhiteColor;
       
        UIView *colorView = [UIView new];
        [whiteV addSubview:colorView];
        [colorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.offset(0);
            make.height.offset(25);
        }];
        colorView.backgroundColor = HEXColor(0xFFFCF4);
        for (int i = 0;i < titles.count;i++) {
            UILabel *lab = [UILabel new];
            [whiteV addSubview:lab];
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(SCALING_RATIO([margins[i] intValue]));
                make.width.offset(SCALING_RATIO([widths[i] intValue]));
                make.height.offset(25);
                make.top.offset(0);
            }];
            lab.textColor = kTextGrayColor;
            lab.font = kFont10;
            lab.textAlignment = NSTextAlignmentCenter;
            lab.text = titles[i];
            
            UILabel *content = [UILabel new];
            [whiteV addSubview:content];
            [content mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(SCALING_RATIO([margins[i] intValue]));
                make.width.offset(SCALING_RATIO([widths[i] intValue]));
                make.height.offset(25);
                make.top.offset(25);
            }];
            content.textColor = kCommonTextColor;
            content.font = kFont10;
            content.textAlignment = NSTextAlignmentCenter;
            if (i == 0) {
                self.playCount = content;
            } else if (i == 1) {
                self.playTime = content;
            } else if (i == 2) {
                self.rebound = content;
            } else if (i == 3) {
                self.helpAttack = content;
            } else if (i == 4) {
                self.rob = content;
            } else if (i == 5) {
                self.cover = content;
            } else if (i == 6) {
                self.score = content;
            }
        }
    }
    return self;
}
// 3- 季前赛  1- 常规赛  2- 季后赛
- (void)setBtns:(NSArray *)seasonArray; {
    for (SeasonAvgData *model in _seasonDataArray) {
        if (model.matchKind.integerValue == 1) {
            model.matchKindName = @"常规赛";
        } else if (model.matchKind.integerValue == 2) {
            model.matchKindName = @"季后赛";
        } else if (model.matchKind.integerValue == 3) {
            model.matchKindName = @"季前赛";
        } else if (model.matchKind.integerValue == -1) {
            model.matchKindName = @"无分类";
        }
    }
    for (UIButton *btn in self.btnView.subviews) {
        [btn removeFromSuperview];
    }

    CGFloat height = 23;
    CGFloat width = 50;
    
    [self.btnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.offset(0);
        make.height.offset(height);
        make.width.offset(width * seasonArray.count);
    }];
    
    for (int i = 0;i < _seasonDataArray.count;i++) {
        SeasonAvgData *model = _seasonDataArray[i];
        UIButton *btn = [UIButton new];
        [self.btnView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(i * width);
            make.height.offset(height);
            make.width.offset(width);
            make.centerY.offset(0);
        }];
        [btn setBackgroundImage:[UIImage imageWithColor:kThemeColor] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageWithColor:kCommonWhiteColor] forState:UIControlStateNormal];
        [btn setTitle:model.matchKindName forState:UIControlStateNormal];
        [btn setTitleColor:kCommonTextColor forState:UIControlStateSelected];
        [btn setTitleColor:kTextGrayColor forState:UIControlStateNormal];
        btn.titleLabel.font = kFont12;
        btn.tag = i;
        btn.selected = i == 0 ? YES : NO;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}
// 3- 季前赛  1- 常规赛  2- 季后赛
- (void)setSeasonDataArray:(NSArray<SeasonAvgData *> *)seasonDataArray {
    _seasonDataArray = seasonDataArray;
    [self setBtns:_seasonDataArray];
    if (seasonDataArray.count == 0) {
        return;
    }
    [self setModel:seasonDataArray[0]];
}

- (void)setModel:(SeasonAvgData *)model {
    self.playCount.text = model.playCount.length ? model.playCount : @"--";
    self.playTime.text = model.playTime.length ? model.playTime : @"--";
    self.rebound.text = model.rebound.length ? model.rebound : @"--";
    self.helpAttack.text = model.helpAttack.length ? model.helpAttack : @"--";
    self.rob.text = model.rob.length ? model.rob :@"--";
    self.cover.text = model.cover.length ? model.cover :@"--";
    self.score.text = model.score.length ? model.score : @"--";
}
- (void)btnClick:(UIButton *)sender {
    for (UIButton *btn in self.btnView.subviews) {
        btn.selected = 0;
    }
    sender.selected = 1;
    [self setModel:_seasonDataArray[sender.tag]];
}

- (UIView *)btnView {
    if (!_btnView) {
        _btnView = [UIView new];
        _btnView.layer.cornerRadius = 11.5;
        _btnView.layer.masksToBounds = 1;
    }
    return _btnView;
}
@end
