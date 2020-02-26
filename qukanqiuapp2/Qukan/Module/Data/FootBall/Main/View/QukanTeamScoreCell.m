//
//  QukanTeamScoreCell.m
//  Qukan
//
//  Created by Charlie on 2019/12/25.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanTeamScoreCell.h"

@implementation QukanTeamScoreCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self layoutViews];
    }
    return self;
}

- (void)layoutViews{
    [self.contentView addSubview:_label_1 = [UILabel new]];
    [self.contentView addSubview:_flagV = [UIImageView new]];
    [self.contentView addSubview:_label_2 = [UILabel new]];
    [self.contentView addSubview:_label_3 = [UILabel new]];
    [self.contentView addSubview:_label_4 = [UILabel new]];
    [self.contentView addSubview:_label_5 = [UILabel new]];
    [self.contentView addSubview:_label_6 = [UILabel new]];
    [self.contentView addSubview:_label_7 = [UILabel new]];
    [self.contentView addSubview:_label_8 = [UILabel new]];
    [self.contentView addSubview:_upGradeLabel = [UILabel new]];
    
    
    
    [_label_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(20);
        make.centerY.mas_equalTo(0);
    }];
    _label_1.text = @"2";
    _label_1.font = kFont12;
    _label_1.textColor = kCommonWhiteColor;
    
    [_flagV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.label_1.mas_right).offset(10);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(24);
    }];
    
    _flagV.backgroundColor = RGBSAMECOLOR(210);
    
    [_label_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.flagV.mas_right).offset(5);
        make.right.mas_equalTo(self.label_3.mas_left).offset(3);
        make.centerY.mas_equalTo(0);
    }];
    _label_2.text = @"恒大";
    _label_2.font = kFont12;
    _label_2.textColor = kCommonWhiteColor;
    
    [_label_8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(48);
    }];
    
    _label_8.text = @"8";
    _label_8.font = kFont12;
    _label_8.textColor = kCommonWhiteColor;
    _label_8.textAlignment = NSTextAlignmentCenter;
    
    [_label_7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.label_8.mas_left).offset(-5);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(18);
        
    }];
    _label_7.text = @"7";
    _label_7.font = kFont12;
    _label_7.textColor = kCommonWhiteColor;
    _label_7.textAlignment = NSTextAlignmentCenter;
    
    [_label_6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.label_7.mas_left).offset(-5);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(18);
        
    }];
    _label_6.text = @"6";
    _label_6.font = kFont12;
    _label_6.textColor = kCommonWhiteColor;
    _label_6.textAlignment = NSTextAlignmentCenter;
    
    [_label_5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.label_6.mas_left).offset(-5);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(18);
        
    }];
    _label_5.text = @"5";
    _label_5.font = kFont12;
    _label_5.textColor = kCommonWhiteColor;
    _label_5.textAlignment = NSTextAlignmentCenter;
    
    [_label_4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.label_5.mas_left).offset(-5);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(28);
        
    }];
    _label_4.text = @"4";
    _label_4.font = kFont12;
    _label_4.textColor = kCommonWhiteColor;
    _label_4.textAlignment = NSTextAlignmentCenter;
    
    
    [_label_3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.label_4.mas_left).offset(-5);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(28);
    }];
    _label_3.text = @"巴萨罗那";
    _label_3.font = kFont12;
    _label_3.textColor = kCommonWhiteColor;
    _label_3.textAlignment = NSTextAlignmentCenter;
    
    
    [_upGradeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(14);
    }];
    _upGradeLabel.text = @"";
    _upGradeLabel.font = kSystemFont(9);
    _upGradeLabel.textColor = kCommonWhiteColor;
    _upGradeLabel.textAlignment = NSTextAlignmentCenter;
    _upGradeLabel.backgroundColor = HEXColor(0x9F7400);

    UIView*cutLine = [UIView new];
    cutLine.backgroundColor = HEXColor(0x27313C);
    [self.contentView addSubview:cutLine];
    [cutLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    _cutLine = cutLine;
}

- (void)setModel:(QukanTeamScoreModel*)model{
    _label_1.text = model.sort;
    _label_2.text = model.g;
    _label_3.text = model.jifen;
    _label_4.text = model.scene;
    _label_5.text = model.win;
    _label_6.text = model.flat;
    _label_7.text = model.negative;
    _label_8.text = FormatString(@"%@/%@", model.haveTo, model.lose);
    [_flagV sd_setImageWithURL:[NSURL URLWithString:model.flag] placeholderImage:kImageNamed(@"ft_default_flag")];
}


@end
