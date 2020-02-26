//
//  QukanScheduleCell.m
//  Qukan
//
//  Created by Charlie on 2019/12/25.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanScheduleCell.h"

@interface QukanScheduleCell()
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *hostNameLabel;
@property (strong, nonatomic) UIImageView *hostFlagImgV;
@property (strong, nonatomic) UILabel *scoreLabel;
@property (strong, nonatomic) UIImageView *guestFlagImgV;
@property (strong, nonatomic) UILabel *guestNameLabel;

@property(nonatomic,strong) QukanFTMatchScheduleModel* model;
@end

@implementation QukanScheduleCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self layoutViews];
    }
    return self;
}

- (void)layoutViews{
    [self.contentView addSubview:_timeLabel = [UILabel new]];
    [self.contentView addSubview:_hostFlagImgV = [UIImageView new]];
    [self.contentView addSubview:_guestFlagImgV = [UIImageView new]];
    [self.contentView addSubview:_hostNameLabel = [UILabel new]];
    [self.contentView addSubview:_guestNameLabel = [UILabel new]];
    [self.contentView addSubview:_scoreLabel = [UILabel new]];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.right.mas_equalTo(self.hostNameLabel.mas_left).offset(-1);
        make.centerY.mas_equalTo(0);
    }];
    _timeLabel.text = @"01-02 12:30";
    _timeLabel.font = kFont11;
    _timeLabel.textColor = HEXColor(0x626D7E);
    
    [_guestNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(100);
        make.right.mas_equalTo(-5);
        make.centerY.mas_equalTo(0);
    }];
    _guestNameLabel.text = @"北京人和";
    _guestNameLabel.font = kFont11;
    _guestNameLabel.textColor = kCommonWhiteColor;
//    _guestNameLabel.numberOfLines = 0;
//    _guestNameLabel.backgroundColor = UIColor.redColor;

    [_guestFlagImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.guestNameLabel.mas_left).offset(-5);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(20);
        
    }];
    _guestFlagImgV.backgroundColor = RGBSAMECOLOR(245);
    
    [_scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.guestFlagImgV.mas_left).offset(-5);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(28);
        
    }];
    _scoreLabel.text = @"10:10";
    _scoreLabel.font = kFont12;
    _scoreLabel.textColor = kCommonWhiteColor;
    _scoreLabel.textAlignment = NSTextAlignmentCenter;

    [_hostFlagImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.scoreLabel.mas_left).offset(-5);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(20);
        
    }];
    _hostFlagImgV.backgroundColor = RGBSAMECOLOR(245);
   
    [_hostNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.hostFlagImgV.mas_left).offset(-5);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(100);
        
    }];
    _hostNameLabel.text = @"大连一方";
    _hostNameLabel.font = kFont11;
    _hostNameLabel.textColor = kCommonWhiteColor;
    _hostNameLabel.textAlignment = NSTextAlignmentRight;
//    _hostNameLabel.numberOfLines = 0;

    
    UIView*cutLine = [UIView new];
    cutLine.backgroundColor = HEXColor(0x27313C);
    [self.contentView addSubview:cutLine];
    [cutLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)setModel:(QukanFTMatchScheduleModel*)model{
    _model = model;
    self.timeLabel.text = [model.start_time substringWithRange:NSMakeRange(5, 11)];
    self.hostNameLabel.text = model.home_name;
    [self.hostFlagImgV sd_setImageWithURL:[NSURL URLWithString:model.flag1] placeholderImage:kImageNamed(@"ft_default_flag")];
    if([model.state intValue] == 0){
        self.scoreLabel.text = @"VS";
    }else{
        self.scoreLabel.text = FormatString(@"%@:%@",model.home_score,model.away_score);
    }
    [self.guestFlagImgV sd_setImageWithURL:[NSURL URLWithString:model.flag2] placeholderImage:kImageNamed(@"ft_default_flag")];
    self.guestNameLabel.text = model.away_name;
    
}

@end
