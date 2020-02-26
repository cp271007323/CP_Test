//
//  QukanNewFriendsCell.m
//  Qukan
//
//  Created by Mac on 2020/2/22.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanNewFriendsCell.h"
#import <SDAutoLayout/SDAutoLayout.h>

@interface QukanNewFriendsCell ()

@property (nonatomic , strong) UIView *line;

@end

@implementation QukanNewFriendsCell

#pragma mark - set



#pragma mark - Life
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = [UIFont boldSystemFontOfSize:14];
        self.detailTextLabel.font = kFont12;
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
    self.imageView.backgroundColor =kRandomColor;
    
    [self.contentView addSubview:self.acceptBtn];
    
    self.acceptBtn.sd_layout
    .centerYEqualToView(self.contentView)
    .rightSpaceToView(self.contentView, 15);
    [self.acceptBtn setupAutoSizeWithHorizontalPadding:10 buttonHeight:25];
    [self.acceptBtn setSd_cornerRadiusFromHeightRatio:@.5];
    
    self.textLabel.sd_layout
    .topEqualToView(self.imageView)
    .leftSpaceToView(self.imageView, 10)
    .rightSpaceToView(self.acceptBtn, 10)
    .heightRatioToView(self.imageView, .5);
    
    self.detailTextLabel.sd_layout
    .topSpaceToView(self.textLabel, 0)
    .leftSpaceToView(self.imageView, 10)
    .rightSpaceToView(self.acceptBtn, 10)
    .heightRatioToView(self.imageView, .5);
    
    [self.contentView addSubview:self.line];
    self.line.sd_layout
    .bottomEqualToView(self.contentView)
    .leftSpaceToView(self.contentView, 15)
    .rightEqualToView(self.contentView)
    .heightIs(.5);
    
}

#pragma mark - Public


#pragma mark - get
+ (NSString *)identifier
{
    return NSStringFromClass(self);
}

- (UIButton *)acceptBtn
{
    if (_acceptBtn == nil) {
        _acceptBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_acceptBtn setTitle:@"接受" forState:UIControlStateNormal];
        _acceptBtn.backgroundColor = HEXColor(0xE9474F);
        _acceptBtn.titleLabel.font = kFont12; 
    }
    return _acceptBtn;
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
