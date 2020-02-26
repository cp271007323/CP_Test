//
//  QukanTabAnimationCell.h
//  Qukan
//
//  Created by leo on 2020/1/4.
//  Copyright © 2020 mac. All rights reserved.
//


#import "QukanTabAnimationCell.h"

@interface QukanTabAnimationCell ()

@property (nonatomic,strong) UIImageView *gameImg;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *timeLab;
@property (nonatomic,strong) UIButton *statusBtn;

@end

@implementation QukanTabAnimationCell

+ (CGFloat)cellHeight {
    return 90;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    //布局
    self.gameImg.frame = CGRectMake(15, 35, kScreenWidth - 30, (self.frame.size.height-45));

    self.titleLab.frame = CGRectMake(15, 5, 150, 28);
//    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.gameImg.mas_right).mas_offset(15);
//        make.top.mas_offset(10);
//        make.right.mas_equalTo(self).mas_offset(-20);
//    }];
    
//    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.titleLab);
//        make.top.mas_equalTo(self.titleLab.mas_bottom).mas_offset(5);
//        make.right.mas_equalTo(self).mas_offset(-40);
//    }];
//
//    [self.statusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.gameImg.mas_right).mas_offset(15);
//        make.top.mas_equalTo(self.timeLab.mas_bottom).mas_offset(10);
//        make.width.mas_offset(70);
//        make.height.mas_offset(20);
//    }];
//    self.statusBtn.layer.cornerRadius = 5;
}

#pragma mark - Initize Methods

- (void)initUI {
    
    {
        UIImageView *iv = [[UIImageView alloc] init];
        iv.contentMode = UIViewContentModeScaleAspectFill;
        iv.layer.masksToBounds = YES;
        
        self.gameImg = iv;
        [self addSubview:iv];
    }
    
    {
        UILabel *lab = [[UILabel alloc]init];
        [lab setFont:kFont15];
        [lab setTextColor:kCommonBlackColor];
        
        self.titleLab = lab;
        [self addSubview:lab];
    }
    
    {
        UILabel *lab = [[UILabel alloc]init];
        [lab setFont:kFont15];
        
        self.timeLab = lab;
        [self addSubview:lab];
    }
    
    {
        UIButton *btn = [[UIButton alloc]init];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn.titleLabel setFont:kFont15];
        
        self.statusBtn = btn;
        [self addSubview:btn];
    }
}

@end
