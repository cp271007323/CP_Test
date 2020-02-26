//
//  QukanFriendsBaseInfoHeadCell.m
//  Qukan
//
//  Created by Mac on 2020/2/23.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanFriendsBaseInfoHeadCell.h"

@interface QukanFriendsBaseInfoHeadCell ()

@property (nonatomic , strong) UIView *line;

@end

@implementation QukanFriendsBaseInfoHeadCell

#pragma mark - set



#pragma mark - Life
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = [UIFont boldSystemFontOfSize:18];
        self.detailTextLabel.font = kFont14;
        self.detailTextLabel.textColor = CPColor(@"#666666");
    }
    return self;
}


#pragma mark - Private
- (void)layoutSubviews
{
    [self.contentView addSubview:self.line];
    
    self.imageView.sd_layout
    .centerYEqualToView(self.contentView)
    .leftSpaceToView(self.contentView, 15)
    .widthIs(50)
    .heightEqualToWidth();
    [self.imageView setSd_cornerRadiusFromWidthRatio:@.5];
    self.imageView.backgroundColor =kRandomColor;
    
    self.textLabel.sd_layout
    .topEqualToView(self.imageView)
    .leftSpaceToView(self.imageView, 10)
    .rightSpaceToView(self.contentView, 10)
    .heightRatioToView(self.imageView, .5);
    
    self.detailTextLabel.sd_layout
    .topSpaceToView(self.textLabel, 5)
    .leftSpaceToView(self.imageView, 10)
    .rightSpaceToView(self.contentView, 10)
    .heightRatioToView(self.imageView, .5);
    
    self.line.sd_layout
    .bottomEqualToView(self.contentView)
    .heightIs(.5)
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView);
    
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
