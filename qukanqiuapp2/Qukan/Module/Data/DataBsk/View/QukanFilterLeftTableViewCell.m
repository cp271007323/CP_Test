//
//  LeftTableViewCell.m
//  Linkage
//
//  Created by LeeJay on 16/8/22.
//  Copyright © 2016年 LeeJay. All rights reserved.
//  代码下载地址https://github.com/leejayID/Linkage

#import "QukanFilterLeftTableViewCell.h"

#define defaultColor rgba(253, 212, 49, 1)

@interface QukanFilterLeftTableViewCell ()

@property (nonatomic, strong) UIView *yellowView;

@end

@implementation QukanFilterLeftTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.contentView.backgroundColor = kCommonWhiteColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.name = [UILabel new];
        [self.contentView addSubview:self.name];
        [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(5);
            make.right.offset(-5);
            make.top.bottom.offset(0);
        }];
        self.name.numberOfLines = 0;
        self.name.textAlignment = NSTextAlignmentCenter;
        self.name.textColor = kCommonTextColor;
        self.name.font = kFont14;

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state

    self.contentView.backgroundColor = selected ? HEXColor(0xFAF9F9) : kCommonWhiteColor;
    self.highlighted = selected;
    self.name.font = selected ? [UIFont fontWithName:@"PingFangSC-Semibold" size:14] : kFont14;
}

@end
