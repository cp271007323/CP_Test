//
//  QukanBSKDetailInfoCell.m
//  Qukan
//
//  Created by blank on 2019/12/26.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanBSKDetailInfoCell.h"

@interface QukanBSKDetailInfoCell()

@property (nonatomic, strong)UILabel *area;
@property (nonatomic, strong)UILabel *homeGround;
@property (nonatomic, strong)UILabel *time;
@property (nonatomic, strong)UILabel *homeCoach;
@property (nonatomic, strong)UILabel *championEvent;
@property (nonatomic, strong)UILabel *championTimes;
@property (nonatomic, strong)UILabel *introduce;
@end
@implementation QukanBSKDetailInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIView *grayView1 = [UIView new];
        [self.contentView addSubview:grayView1];
        [grayView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.offset(0);
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
        lab1.text = @"球队资料";
        lab1.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
        lab1.textColor = kCommonTextColor;
        
        UIView *whiteView1 = [UIView new];
        [self.contentView addSubview:whiteView1];
        [whiteView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.top.mas_equalTo(grayView1.mas_bottom).offset(0);
            make.height.offset(200);
        }];
        whiteView1.backgroundColor = kCommonWhiteColor;
        
        NSArray *titles = @[@"国家地区",@"球队主场",@"成立时间",@"主教练"];
        for (int i = 0;i < titles.count;i++) {
            UIView *backView = [UIView new];
            [whiteView1 addSubview:backView];
            [backView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.offset(0);
                make.height.offset(50);
                make.top.offset(i*50);
            }];
            
            if (i <titles.count - 1) {
                UIView *botLine = [UIView new];
                [backView addSubview:botLine];
                [botLine mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.bottom.offset(0);
                    make.height.offset(0.5);
                }];
                botLine.backgroundColor = HEXColor(0xE3E2E2);
            }
            
            UILabel *lab = [UILabel new];
            [backView addSubview:lab];
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(15);
                make.height.offset(20);
                make.width.offset(56);
                make.centerY.offset(0);
            }];
            lab.textColor = kTextGrayColor;
            lab.font = kFont14;
            lab.text = titles[i];
            
            UILabel *contentLab = [UILabel new];
            [backView addSubview:contentLab];
            [contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(100);
                make.height.offset(20);
                make.centerY.offset(0);
            }];
            contentLab.textColor = kCommonTextColor;
            contentLab.font = kFont14;
            if (i == 0) {
                self.area = contentLab;
            } else if (i == 1) {
                self.homeGround = contentLab;
            } else if (i == 2) {
                self.time = contentLab;
            } else {
                self.homeCoach = contentLab;
            }
        }
        
        UIView *grayView2 = [UIView new];
        [self.contentView addSubview:grayView2];
        [grayView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.top.mas_equalTo(whiteView1.mas_bottom).offset(0);
            make.height.offset(35);
        }];
        grayView2.backgroundColor = kTableViewCommonBackgroudColor;
        
        NSArray *titles1 = @[@"夺冠赛事",@"夺冠次数"];
        for (int i = 0;i<titles1.count;i++) {
            UILabel *lab = [UILabel new];
            [grayView2 addSubview:lab];
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                if (i == 0) {
                    make.left.offset(15);
                } else {
                    make.centerX.offset(0);
                }
                make.width.offset(48);
                make.height.offset(17);
                make.centerY.offset(0);
            }];
            lab.text = titles1[i];
            lab.textAlignment = i == 0 ? NSTextAlignmentLeft : NSTextAlignmentCenter;
            lab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
            lab.textColor = kCommonTextColor;
        }
        UIView *whiteView2 = [UIView new];
        [self.contentView addSubview:whiteView2];
        [whiteView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.top.mas_equalTo(grayView2.mas_bottom).offset(0);
            make.height.offset(50);
        }];
        whiteView2.backgroundColor = kCommonWhiteColor;
        
        self.championEvent = [UILabel new];
        [whiteView2 addSubview:self.championEvent];
        [self.championEvent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.height.offset(20);
            make.centerY.offset(0);
        }];
        self.championEvent.textColor = kTextGrayColor;
        self.championEvent.font = kFont14;
        
        self.championTimes = [UILabel new];
        [whiteView2 addSubview:self.championTimes];
        [self.championTimes mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.offset(0);
            make.centerY.offset(0);
            make.height.offset(20);
        }];
        self.championTimes.textAlignment = NSTextAlignmentCenter;
        self.championTimes.textColor = kCommonTextColor;
        self.championTimes.font = kFont14;
        
        UIView *grayView3 = [UIView new];
        [self.contentView addSubview:grayView3];
        [grayView3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.top.mas_equalTo(whiteView2.mas_bottom).offset(0);
            make.height.offset(35);
        }];
        grayView3.backgroundColor = kTableViewCommonBackgroudColor;
        
        UILabel *lab3 = [UILabel new];
        [grayView3 addSubview:lab3];
        [lab3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.height.offset(17);
            make.centerY.offset(0);
        }];
        lab3.text = @"球队介绍";
        lab3.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
        lab3.textColor = kCommonTextColor;
        
        UIView *whiteBot = [UIView new];
        [self.contentView addSubview:whiteBot];
        [whiteBot mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.offset(0);
            make.top.mas_equalTo(grayView3.mas_bottom).offset(0);
        }];
        whiteBot.backgroundColor = kCommonWhiteColor;
        
        self.introduce = [UILabel new];
        [whiteBot addSubview:self.introduce];
        [self.introduce mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.top.offset(10);
            make.right.offset(-15);
        }];
         self.introduce.numberOfLines = 0;
         self.introduce.font = kFont12;
         self.introduce.textColor = kCommonTextColor;
        self.introduce.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return self;
}
- (void)setModel:(QukanBSKDataTeamDetailModel *)model {
    _model = model;
    self.area.text = model.city.length ? model.city : @"--";
    self.homeGround.text = model.gymnasium.length ? model.gymnasium : @"--";
    self.time.text = model.joinYear.length ? model.joinYear : @"--";
    self.homeCoach.text = model.drillMaster.length ? model.drillMaster : @"--";
    self.championEvent.text = model.championship.length ? model.championship : @"--";
    self.championTimes.text = model.championNums.length ? model.championNums : @"--";
    model.introduce = [model.introduce stringByReplacingOccurrencesOfString:@"?" withString:@""];
    self.introduce.text = model.introduce;
}
@end
