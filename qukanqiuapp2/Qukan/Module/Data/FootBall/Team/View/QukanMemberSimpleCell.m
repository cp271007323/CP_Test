//
//  QukanMemberSimpleCell.m
//  Qukan
//
//  Created by Charlie on 2020/1/3.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanMemberSimpleCell.h"
@interface QukanMemberSimpleCell()

@property(nonatomic,strong) UILabel* coacheNameLabel;


@property(nonatomic,strong) UIImageView* avatarImgV;
@property(nonatomic,strong) UILabel* nameLabel;
@property(nonatomic,strong) UILabel* numberLabel;
@property(nonatomic,strong) UILabel* positionLabel;
@property(nonatomic,strong) UILabel* goalLabel;
@property(nonatomic,strong) UILabel* assistLabel;
@property(nonatomic,strong) UILabel* worthLabel;

@property(nonatomic,strong) NSDictionary* myDic;

@end

@implementation QukanMemberSimpleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self createViews];
    }
    return self;
}

- (void)setDataWithDic:(NSDictionary*)dic{
    _myDic = dic;
    [self.avatarImgV sd_setImageWithURL:[NSURL URLWithString:dic[@"photo"]] placeholderImage:kImageNamed(@"Player_defaultAvatar")];
    if([dic[@"playerPlace"] length] > 0 && [dic[@"playerPlace"] isEqualToString:@"主教练"]){
        self.coacheNameLabel.text = [dic[@"playerName"] length] > 0? dic[@"playerName"]:@"--";
        self.nameLabel.text = @"";
        self.numberLabel.text = @"";
        self.goalLabel.text = @"";
        self.assistLabel.text = @"";
        self.positionLabel.text = @"";
        self.worthLabel.text = @"";
    }else{
        self.coacheNameLabel.text = @"";

        self.nameLabel.text = [dic[@"playerName"] length] > 0? dic[@"playerName"]:@"--";
        NSString* number = [dic[@"playerNumber"] stringValue];
        self.numberLabel.text = [number length]>0? [number stringByAppendingString:@"号"] : @"--";
        self.goalLabel.text = [dic[@"goals"] stringValue];
        self.assistLabel.text = [dic[@"assist"] stringValue];
        self.positionLabel.text = [dic[@"playerPlace"] length] > 0? dic[@"playerPlace"]:@"--";
        
        NSString* worth = dic[@"value"];
        self.worthLabel.text = ([worth length]>0 && worth.intValue > 0)? [worth stringByAppendingString:@"万"] : @"--";
    }
}

- (void) createViews{
    [self.contentView addSubview:_avatarImgV = [UIImageView new]];
    [self.contentView addSubview:_nameLabel = [UILabel new]];
    [self.contentView addSubview:_coacheNameLabel = [UILabel new]];
    
    [self.contentView addSubview:_numberLabel = [UILabel new]];
    [self.contentView addSubview:_positionLabel = [UILabel new]];
    [self.contentView addSubview:_goalLabel = [UILabel new]];
    [self.contentView addSubview:_assistLabel = [UILabel new]];
    [self.contentView addSubview:_worthLabel = [UILabel new]];
     
     
     [_avatarImgV mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.mas_equalTo(15);
         make.centerY.mas_equalTo(0);
         make.width.height.mas_equalTo(45);
     }];
    _avatarImgV.layer.masksToBounds = YES;
    _avatarImgV.layer.cornerRadius = 22.5;
    _avatarImgV.backgroundColor = RGBSAMECOLOR(248);
    _avatarImgV.contentMode = UIViewContentModeScaleAspectFit;

    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avatarImgV.mas_right).offset(7);
        make.top.mas_equalTo(self.avatarImgV).offset(3);
        make.right.mas_equalTo(self.contentView.mas_centerX);
    }];
    _nameLabel.font = kFont14;
    _nameLabel.text = @"韦世豪";
    _nameLabel.textColor = kCommonBlackColor;
    
    [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(3);
    }];
    _numberLabel.font = kFont14;
    _numberLabel.text = @"7号";
    _numberLabel.textColor = kCommonBlackColor;
    
    [_coacheNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avatarImgV.mas_right).offset(7);
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(self.contentView.mas_centerX);
    }];
    _coacheNameLabel.font = kFont14;
    _coacheNameLabel.text = @"";
    _coacheNameLabel.textColor = kCommonBlackColor;
    
    
    [_worthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5);
        make.width.mas_equalTo(70);
        make.centerY.mas_equalTo(0);
    }];
    _worthLabel.textAlignment = NSTextAlignmentCenter;
    _worthLabel.font = kFont12;
    _worthLabel.text = @"10万";
    _worthLabel.textColor = kCommonBlackColor;
    
    
    [_assistLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.worthLabel.mas_left).offset(-8);
        make.width.mas_equalTo(24);
        make.centerY.mas_equalTo(0);
    }];
    _assistLabel.textAlignment = NSTextAlignmentCenter;
    _assistLabel.font = kFont12;
    _assistLabel.text = @"20";
    _assistLabel.textColor = kCommonBlackColor;
//

    [_goalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.assistLabel.mas_left).offset(-8);
        make.width.mas_equalTo(24);
        make.centerY.mas_equalTo(0);
    }];
    _goalLabel.textAlignment = NSTextAlignmentCenter;
    _goalLabel.font = kFont12;
    _goalLabel.text = @"10";
    _goalLabel.textColor = kCommonBlackColor;

//
    [_positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.goalLabel.mas_left).offset(-8);
        make.width.mas_equalTo(36);
        make.centerY.mas_equalTo(0);
    }];
    _positionLabel.textAlignment = NSTextAlignmentCenter;
    _positionLabel.font = kFont12;
    _positionLabel.text = @"前锋";
    _positionLabel.textColor = kCommonBlackColor;
    
//    [_goalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(_positionLabel.right).offset(5);
//        make.width.mas_equalTo(28);
//        make.centerY.mas_equalTo(0);
//    }];
//    _goalLabel.textAlignment = NSTextAlignmentCenter;
//    _goalLabel.font = kFont12;
//    _goalLabel.text = @"10";
//    _goalLabel.textColor = kCommonBlackColor;
//    _goalLabel.backgroundColor = UIColor.greenColor;
    
    UIView* cutline = [UIView new];
    [self.contentView addSubview:cutline];
    [cutline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    cutline.backgroundColor = HEXColor(0xe3e2e2);
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
