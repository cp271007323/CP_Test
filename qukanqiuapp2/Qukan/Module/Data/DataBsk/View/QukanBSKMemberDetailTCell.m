//
//  QukanBSKMemberDetailTCell.m
//  Qukan
//
//  Created by blank on 2020/1/3.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanBSKMemberDetailTCell.h"
@interface QukanBSKMemberDetailTCell()
@property (nonatomic, strong)UILabel *transferSeason;
@property (nonatomic, strong)UILabel *tTime;
@property (nonatomic, strong)UILabel *fromTeam;
@property (nonatomic, strong)UILabel *toTeam;
@property (nonatomic, strong)UIView *line;
@end
@implementation QukanBSKMemberDetailTCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CGFloat width = 48;
        CGFloat blank = (kScreenWidth - 30 - 48 * 4)/3;
        for (int i = 0;i < 4;i++) {
            UILabel *lab = [UILabel new];
            [self.contentView addSubview:lab];
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.offset(0);
                make.top.bottom.offset(0);
                make.left.offset(15+i*(width+blank));
                if (i == 2) {
                    make.right.offset(-5-width-15);
                }
                if (i == 3) {
                    make.right.offset(-5);
                }
            }];
            lab.textColor = kCommonTextColor;
            lab.font = kFont12;
            if (i == 0) {
                self.transferSeason = lab;
            } else if (i == 1) {
                self.tTime = lab;
            } else if (i == 2) {
                self.fromTeam = lab;
                self.fromTeam.numberOfLines = 0;
            } else if (i == 3) {
                self.toTeam = lab;
                self.toTeam.numberOfLines = 0;
            }
        }
        self.line = [UIView new];
        [self.contentView addSubview:self.line];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.offset(0);
            make.height.offset(0.5);
        }];
        self.line.backgroundColor = HEXColor(0xE3E2E2);
    }
    return self;
}
- (void)setModel:(QukanChangeModel *)model {
    self.transferSeason.text = model.zhSeason.length ? model.zhSeason : @"--";
    self.tTime.text = model.tTime.length ? model.tTime : @"--";
    self.fromTeam.text = model.team.length ? model.team : @"--";
    self.toTeam.text = model.teamNow.length ? model.teamNow : @"--";
}
@end
