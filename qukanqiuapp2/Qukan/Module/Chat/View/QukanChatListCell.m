//
//  QukanChatListCell.m
//  Qukan
//
//  Created by Mac on 2020/2/22.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanChatListCell.h"
#import <SDAutoLayout/SDAutoLayout.h>

@interface QukanChatListCell ()

@end

@implementation QukanChatListCell

#pragma mark - set



#pragma mark - Life
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupInitLayoutForQukanChatListCell];
        [self setupInitBindingForQukanChatListCell];
    }
    return self;
}


#pragma mark - Private
- (void)setupInitLayoutForQukanChatListCell
{
    [self.contentView sd_addSubviews:@[self.headImageView,self.nameLab,self.contentLab,self.timeLab,self.roundLab]];
    
    self.headImageView.sd_layout
    .centerYEqualToView(self.contentView)
    .leftSpaceToView(self.contentView, 14)
    .topSpaceToView(self.contentView, 15)
    .bottomSpaceToView(self.contentView, 15)
    .widthEqualToHeight();
    [self.headImageView setSd_cornerRadiusFromWidthRatio:@.5];
    
    self.nameLab.sd_layout
    .topEqualToView(self.headImageView)
    .leftSpaceToView(self.headImageView, 15)
    .heightRatioToView(self.headImageView, .5);
    
    self.contentLab.sd_layout
    .topSpaceToView(self.nameLab, 0)
    .leftSpaceToView(self.headImageView, 15)
    .heightRatioToView(self.headImageView, .5)
    .rightSpaceToView(self.contentView, 15);
    
    self.timeLab.sd_layout
    .centerYEqualToView(self.nameLab)
    .rightSpaceToView(self.contentView, 15)
    .heightIs(20);
    [self.timeLab setSingleLineAutoResizeWithMaxWidth:200];
    [self.timeLab updateLayout];
    
    self.nameLab.sd_layout
    .rightSpaceToView(self.timeLab, 10);
    [self.nameLab updateLayout];
    
    self.roundLab.sd_layout
    .topEqualToView(self.headImageView)
    .rightEqualToView(self.headImageView)
    .widthIs(15)
    .heightEqualToWidth();
    [self.roundLab setSd_cornerRadiusFromWidthRatio:@.5];
}

- (void)setupInitBindingForQukanChatListCell
{
    
}

#pragma mark - Public


#pragma mark - get
+ (NSString *)identifier
{
    return NSStringFromClass(self);
}

- (UIImageView *)headImageView
{
    if (_headImageView == nil) {
        _headImageView = [UIImageView new];
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headImageView.backgroundColor = kRandomColor;
    }
    return _headImageView;
}

- (UILabel *)nameLab
{
    if (_nameLab == nil) {
        _nameLab = [UILabel new];
        _nameLab.textColor = HEXColor(0x333333);
        _nameLab.font = [UIFont boldSystemFontOfSize:14];;
        _nameLab.backgroundColor = UIColor.clearColor;
        _nameLab.text = @"一二三";
    }
    return _nameLab;
}

- (UILabel *)contentLab
{
    if (_contentLab == nil) {
        _contentLab = [UILabel new];
        _contentLab.textColor = HEXColor(0x999999);
        _contentLab.font = kFont13;
        _contentLab.backgroundColor = UIColor.clearColor;
        _contentLab.text = @"一二三是爱打架啦熬到爱神的箭阿拉看时间的卡机来得及啊里的";
    }
    return _contentLab;
}

- (UILabel *)timeLab
{
    if (_timeLab == nil) {
        _timeLab = [UILabel new];
        _timeLab.textColor = HEXColor(0x999999);
        _timeLab.font = kFont11;
        _timeLab.text = @"2020-2-14";
        _timeLab.backgroundColor = UIColor.clearColor;
    }
    return _timeLab;
}


- (UILabel *)roundLab
{
    if (_roundLab == nil) {
        _roundLab = [UILabel new];
        _roundLab.backgroundColor = HEXColor(0xE9474F);
        _roundLab.textColor = UIColor.whiteColor;
        _roundLab.font = kFont10;
        _roundLab.text = @"1";
        _roundLab.textAlignment = NSTextAlignmentCenter;
    }
    return _roundLab;
}

@end
