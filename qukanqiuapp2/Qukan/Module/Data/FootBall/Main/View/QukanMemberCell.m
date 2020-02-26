//
//  QukanMemberCell.m
//  Qukan
//
//  Created by Charlie on 2019/12/25.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanMemberCell.h"

@implementation QukanMemberCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self layoutViews];
    }
    return self;
}

- (void)layoutViews{
    [self.contentView addSubview:_label_1 = [UILabel new]];
    [self.contentView addSubview:_avatarImgV = [UIImageView new]];
    [self.contentView addSubview:_label_2 = [UILabel new]];
    [self.contentView addSubview:_label_3 = [UILabel new]];
    [self.contentView addSubview:_label_4 = [UILabel new]];
    
    [_label_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(20);
        
    }];
    _label_1.text = @"2";
    _label_1.font = kFont12;
    _label_1.textColor = kCommonWhiteColor;
    
    [_avatarImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.label_1.mas_right).offset(8);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(24);
    }];
    _avatarImgV.contentMode = UIViewContentModeScaleAspectFit;
    _avatarImgV.layer.cornerRadius = 12;
    _avatarImgV.layer.masksToBounds = YES;
    _avatarImgV.backgroundColor = UIColor.lightGrayColor;
    
    [_label_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avatarImgV.mas_right).offset(8);
        make.centerY.mas_equalTo(0);
//        make.width.mas_equalTo(130);
        make.right.mas_equalTo(self.label_3.mas_left).offset(-3);

    }];
    _label_2.text = @"梅西梅西梅西梅西梅西梅西梅";
    _label_2.font = kFont12;
    _label_2.textColor = kCommonWhiteColor;
    _label_2.textAlignment = NSTextAlignmentLeft;
    
    [_label_4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-8);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(22);
    }];
    _label_4.text = @"22";
    _label_4.font = kFont12;
    _label_4.textColor = kCommonWhiteColor;
    _label_4.textAlignment = NSTextAlignmentCenter;
//    _label_4.backgroundColor = UIColor.redColor;

    [_label_3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.label_4.mas_left).offset(-8);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(120);
    }];
    _label_3.text = @"巴萨罗那巴萨罗那巴萨";
    _label_3.font = kFont12;
    _label_3.textColor = kCommonWhiteColor;
    _label_3.textAlignment = NSTextAlignmentCenter;
//    _label_3.backgroundColor = UIColor.redColor;

    UIView*cutLine = [UIView new];
    cutLine.backgroundColor = HEXColor(0x27313C);
    [self.contentView addSubview:cutLine];
    [cutLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(QukanFTPlayerGoalModel*)model{
    _label_2.text = model.playerName;
    _label_3.text = model.teamName;
    _label_4.text = @(model.goals).stringValue;
    
    [_avatarImgV sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:kImageNamed(@"Player_defaultAvatar")];

}

@end
