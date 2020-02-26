//
//  QukanBSKMemberDetailDataBotCell.m
//  Qukan
//
//  Created by blank on 2020/1/4.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanBSKMemberDetailDataBotCell.h"
#import  "QukanJHGridView.h"
@interface QukanBSKMemberDetailDataBotCell()<JHGridViewDelegate>
@property (nonatomic, strong)UILabel *season;
@property (nonatomic, strong)UILabel *teamName;
@property (nonatomic, strong)UILabel *joinTime;
@property (nonatomic, strong)UILabel *playTime;
@property (nonatomic, strong)UILabel *rebound;
@property (nonatomic, strong)UILabel *helpAttack;
@property (nonatomic, strong)UILabel *rob;
@property (nonatomic, strong)UILabel *cover;
@property (nonatomic, strong)UILabel *score;
@property(nonatomic,readwrite,strong)QukanJHGridView *gridView;
@end
@implementation QukanBSKMemberDetailDataBotCell

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
        lab.text = @"职业生涯常规赛总数据";
        lab.textColor = kCommonTextColor;
        lab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
        [self.contentView addSubview:self.gridView];
    }
    return self;
}
- (void)setCareerTechnicDataArray:(NSArray<CareerTechnicData *> *)careerTechnicDataArray {
    _careerTechnicDataArray = careerTechnicDataArray;
    self.gridView.frame = CGRectMake(0,35,kScreenWidth,_careerTechnicDataArray.count * 30 + 30);
    NSArray *titles = @[@"年份",@"球队",@"上场",@"时间",@"篮板",@"助攻",@"抢断",@"盖帽",@"得分"];
    NSArray *tags = @[@"season",@"teamName",@"joinTime",@"playTime",@"rebound",@"helpAttack",@"rob",@"cover",@"score"];
    [self.gridView setTitles:titles andObjects:_careerTechnicDataArray withTags:tags];
}
- (QukanJHGridView *)gridView{
    if (!_gridView) {
        _gridView = [QukanJHGridView new];
        _gridView.delegate = self;
    }
    return _gridView;
}
#pragma mark ===================== gridViewDelegate ==================================

- (void)didSelectRowAtGridIndex:(GridIndex)gridIndex {
    NSLog(@"selected at\ncol:%ld -- row:%ld", gridIndex.col, gridIndex.row);
}

- (BOOL)isTitleFixed{
    return YES;
}

- (CGFloat)widthForColAtIndex:(long)index {
    return 50;
}

- (CGFloat)heightForTitles {
    return 30;
}
- (CGFloat)heightForRowAtIndex:(long)index {
    return 30;
}

- (UIColor *)backgroundColorForTitleAtIndex:(long)index {
    return HEXColor(0xFFFCF4);
}
- (UIColor *)botLineBackgroundColor {
    return HEXColor(0xE3E2E2);
}
- (UIColor *)backgroundColorForGridAtGridIndex:(GridIndex)gridIndex {
    if (gridIndex.row %2 == 0) {
        return kCommonWhiteColor;
    } else {
        return HEXColor(0xF9F9F9);
    }
}
- (UIColor *)textColorForTitleAtIndex:(long)index {
    return kTextGrayColor;
}

- (UIColor *)textColorForGridAtGridIndex:(GridIndex)gridIndex {
    return kCommonTextColor;
}

- (UIFont *)fontForTitleAtIndex:(long)index {
    return kFont10;
}

- (UIFont *)fontForGridAtGridIndex:(GridIndex)gridIndex {
    return kSystemFont(12);
}
@end
