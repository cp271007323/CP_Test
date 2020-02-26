//
//  QukanBSKMemberDetailInfoCell.m
//  Qukan
//
//  Created by blank on 2020/1/3.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanBSKMemberDetailInfoCell.h"
@interface QukanBSKMemberDetailInfoCell()
@property (nonatomic, strong)UILabel *EnName;
@property (nonatomic, strong)UILabel *weight;
@property (nonatomic, strong)UILabel *birthday;
@property (nonatomic, strong)UILabel *number;
@property (nonatomic, strong)UILabel *height;
@property (nonatomic, strong)UILabel *college;
@property (nonatomic, strong)UILabel *years;
@property (nonatomic, strong)UIView *botView;
@end
@implementation QukanBSKMemberDetailInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = kTableViewCommonBackgroudColor;
        UIView *grayView1 = [UIView new];
        [self.contentView addSubview:grayView1];
        [grayView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.offset(0);
            make.height.offset(35);
        }];
        grayView1.backgroundColor = kTableViewCommonBackgroudColor;
        
        UILabel *lab1 = [UILabel new];
        [grayView1 addSubview:lab1];
        [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.height.offset(17);
            make.centerY.offset(0);
        }];
        lab1.text = @"基本资料";
        lab1.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
        lab1.textColor = kCommonTextColor;
        
        NSArray *titles = @[@"英文名",@"体重",@"生日",@"球衣号码",@"身高",@"毕业院校",@"NBA球龄"];
        for (int i = 0;i<titles.count;i++) {
            UIView *whiteV = [UIView new];
            [self.contentView addSubview:whiteV];
            [whiteV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.offset(0);
                make.top.mas_equalTo(grayView1.mas_bottom).offset(i*50);
                make.height.offset(50);
            }];
            whiteV.backgroundColor = kCommonWhiteColor;
            if (i < titles.count - 1) {
                UIView *line = [UIView new];
                [whiteV addSubview:line];
                [line mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.bottom.offset(0);
                    make.height.offset(0.5);
                }];
                line.backgroundColor = HEXColor(0xE3E2E2);
            }
            UILabel *leftLab = [UILabel new];
            [whiteV addSubview:leftLab];
            [leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(15);
                make.centerY.offset(0);
                make.height.offset(20);
            }];
            leftLab.text = titles[i];
            leftLab.textColor = kTextGrayColor;
            leftLab.font = kFont14;
            
            UILabel *contentLab = [UILabel new];
            [whiteV addSubview:contentLab];
            [contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(120);
                make.height.offset(20);
                make.right.offset(-15);
                make.centerY.offset(0);
            }];
            contentLab.textColor = kCommonTextColor;
            contentLab.font = kFont14;
            if (i == 0) {
                self.EnName = contentLab;
            } else if (i == 1) {
                self.weight = contentLab;
            } else if (i == 2) {
                self.birthday = contentLab;
            } else if (i == 3) {
                self.number = contentLab;
            } else if (i == 4) {
                self.height = contentLab;
            } else if (i == 5) {
                self.college = contentLab;
            } else if (i == 6) {
                self.years = contentLab;
            }
        }
        UIView *grayView2 = [UIView new];
        [self.contentView addSubview:grayView2];
        [grayView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.top.mas_equalTo(self.years.mas_bottom).offset(15);
            make.height.offset(35);
        }];
        grayView2.backgroundColor = kTableViewCommonBackgroudColor;
        
        CGFloat width = 48;
        CGFloat blank = (kScreenWidth - 30 - 48 * 4)/3;
        NSArray *titles1 = @[@"转会赛季",@"转会时间",@"转出球队",@"转入球队"];
        for (int i = 0;i<titles1.count;i++) {
            UILabel *lab = [UILabel new];
            [grayView2 addSubview:lab];
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.offset(0);
                make.height.offset(17);
                make.left.offset(15+i*(width+blank));
            }];
            lab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
            lab.textColor = kCommonTextColor;
            lab.text = titles1[i];
        }
        self.botView = grayView2;
        
    }
    return self;
}
- (void)setModel:(QukanBSKDataPlayerDetailModel *)model {
    self.EnName.text = model.nameE.length ? model.nameE : @"--";
    self.weight.text = FormatString(@"%@kg",model.weight.length ? model.weight : @"--");
    self.birthday.text = model.birthday.length ? model.birthday : @"--";
    self.number.text = model.number.length ? model.number : @"--";
    self.height.text = FormatString(@"%@cm",model.tallness.length ? model.tallness : @"--");
    self.college.text = model.college.length ? model.college : @"--";
    self.years.text = model.nbaAge.length ? model.nbaAge : @"--";
    self.botView.hidden = !model.change.count;
}
@end
