//
//  QukanChatSelectorCell.m
//  Qukan
//
//  Created by Mac on 2020/2/24.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanChatSelectorCell.h"

@interface QukanChatSelectorCell ()

@end

@implementation QukanChatSelectorCell

#pragma mark - set



#pragma mark - Life
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupInitLayoutForQukanChatSelectorCell];
        [self setupInitBindingForQukanChatSelectorCell];
        [self lineForLeftSpace:45];
    }
    return self;
}


#pragma mark - Private
- (void)setupInitLayoutForQukanChatSelectorCell
{
    
}

- (void)setupInitBindingForQukanChatSelectorCell
{
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.contentView addSubview:self.selectorBtn];
    
    self.selectorBtn.sd_layout
    .centerYEqualToView(self.contentView)
    .leftSpaceToView(self.contentView, 15)
    .widthIs(20)
    .heightEqualToWidth();
    
    self.imageView.sd_layout
    .leftSpaceToView(self.selectorBtn, 10);
    
}

#pragma mark - Public


#pragma mark - get
+ (NSString *)identifier
{
    return NSStringFromClass(self);
}

- (UIButton *)selectorBtn
{
    if (_selectorBtn == nil) {
        _selectorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectorBtn setBackgroundImage:CPImageName(@"kqds_data_under") forState:UIControlStateNormal];
        [_selectorBtn setBackgroundImage:CPImageName(@"Qukan_circle_sele") forState:UIControlStateSelected];
    }
    return _selectorBtn;
}

@end
