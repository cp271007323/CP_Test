//
//  QukanXLChannelHeaderView.m
//  QukanXLChannelControlDemo
//
//  Created by MengXianLiang on 2017/3/3.
//  Copyright © 2017年 MengXianLiang. All rights reserved.
//

#import "QukanXLChannelHeader.h"

@interface QukanXLChannelHeader ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *subtitleLabel;

@end

@implementation QukanXLChannelHeader

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}

-(void)buildUI
{
    CGFloat marginX = 15.0f;
    
//    CGFloat labelWidth = (self.bounds.size.width - 2*marginX)/2.0f;
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX, 0, 70, self.bounds.size.height)];
    self.titleLabel.textColor = kCommonBlackColor;
    self.titleLabel.textColor = kCommonDarkGrayColor;
    self.titleLabel.font = kSystemFont(15);
    [self addSubview:self.titleLabel];
    
    self.subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame), 0, 140, self.bounds.size.height)];
    self.subtitleLabel.textColor = kTextGrayColor;
//    self.subtitleLabel.textAlignment = NSTextAlignmentRight;
    self.subtitleLabel.font = [UIFont systemFontOfSize:10.0f];
    [self addSubview:self.subtitleLabel];
    

}

-(void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
}

-(void)setSubTitle:(NSString *)subTitle
{
    _subTitle = subTitle;
    self.subtitleLabel.text = subTitle;
}



@end
