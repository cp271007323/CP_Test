//
//  QukanChatMemberCell.m
//  Qukan
//
//  Created by Mac on 2020/2/22.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanChatMemberCell.h"

#import <SDAutoLayout/SDAutoLayout.h>

@interface QukanChatMemberCell ()

@property (nonatomic , strong) UIView *line;

@end

@implementation QukanChatMemberCell

#pragma mark - set
- (void)lineForLeftSpace:(CGFloat)space
{
    self.line.sd_layout
    .leftSpaceToView(self.contentView, space);
    [self.line updateLayout];
}


#pragma mark - Life
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.line];
        self.line.sd_layout
        .bottomEqualToView(self.contentView)
        .leftSpaceToView(self.contentView, 60)
        .rightEqualToView(self.contentView)
        .heightIs(.5);
    }
    return self;
}


#pragma mark - Private
- (void)layoutSubviews
{   
    self.imageView.sd_layout
    .centerYEqualToView(self.contentView)
    .leftSpaceToView(self.contentView, 15)
    .widthIs(36)
    .heightEqualToWidth();
    [self.imageView setSd_cornerRadiusFromWidthRatio:@.5];
    self.imageView.backgroundColor = kRandomColor;
    
    self.textLabel.sd_layout
    .centerYEqualToView(self.contentView)
    .leftSpaceToView(self.imageView, 10)
    .rightSpaceToView(self.contentView, 20)
    .heightIs(40);
    self.textLabel.font = [UIFont boldSystemFontOfSize:14];
}

#pragma mark - Public


#pragma mark - get
+ (NSString *)identifier
{
    return NSStringFromClass(self);
}

- (UIView *)line
{
    if (_line == nil) {
        _line = [UIView new];
        _line.backgroundColor = CPLineColor();
    }
    return _line;
}

@end
