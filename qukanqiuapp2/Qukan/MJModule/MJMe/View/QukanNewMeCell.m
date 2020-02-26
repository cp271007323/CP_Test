//
//  QukanNewMeCell.m
//  Qukan
//
//  Created by mac on 2018/11/18.
//  Copyright © 2018 Ningbo Suda. All rights reserved.
//

#import "QukanNewMeCell.h"

@implementation QukanNewMeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.layer.masksToBounds = YES;
//    self.layer.cornerRadius = 5.0;
//    self.layer.borderColor = [UIColor colorWithRed:15/255.0 green:14/255.0 blue:61/255.0 alpha:1.0].CGColor;
//    self.layer.borderWidth = 0.3;
////    self.contentView.layer.shadowOffset = CGSizeMake(3, 3);
////    self.contentView.layer.shadowOpacity = 0.8;
////    self.contentView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
////    self.contentView.layer.shadowRadius = 3;
//    UIView *view_bg = [[UIView alloc]init];
//    view_bg.backgroundColor = [UIColor colorWithRed:232/255.0 green:245/255.0 blue:248/255.0 alpha:1];
//    view_bg.frame = CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen]bounds])-20.0, 45.0);
//    self.selectedBackgroundView = view_bg;
//    [view_bg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.selectedBackgroundView);
//    }];
    
    self.view_redPoint.layer.cornerRadius = 3;
    
    UIView *botLine = [UIView new];
    [self.contentView addSubview:botLine];
    [botLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.offset(0.5);
    }];
    botLine.backgroundColor = HEXColor(0xECEEF3);
    
    self.contentLabel.font = kFont14;

}
- (void)setArrow {
    UIImageView *icon = [UIImageView new];
    [self.contentView addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.right.offset(-15);
        make.height.offset(10);
        make.width.offset(5);
    }];
    icon.image = kImageNamed(@"Qukan_new_right");
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
