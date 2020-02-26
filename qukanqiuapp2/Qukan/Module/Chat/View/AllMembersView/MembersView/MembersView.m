//
//  MembersView.m
//  ixcode
//
//  Created by Mac on 2019/11/13.
//  Copyright © 2019 macmac. All rights reserved.
//

#import "MembersView.h"

@interface MembersView ()

@property (nonatomic , strong) UILabel *noteLab;

@end

@implementation MembersView


#pragma mark - set
- (void)setIsGroup:(BOOL)isGroup
{
    self.noteLab.hidden = !isGroup;
}


#pragma mark - Life
+ (instancetype)membersView
{
    MembersView *view = [MembersView buttonWithType:UIButtonTypeCustom];
    return view;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupInitLayoutForMembersView];
        [self setupInitBindingForMembersView];
    }
    return self;
}

#pragma mark - Private
- (void)setupInitLayoutForMembersView
{
    
}

- (void)setupInitBindingForMembersView
{
    
}

#pragma mark - System
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.sd_layout
    .topSpaceToView(self, CPAuto(5))
    .leftSpaceToView(self, CPAuto(5))
    .rightSpaceToView(self, CPAuto(5))
    .heightEqualToWidth();
    [self.imageView setSd_cornerRadiusFromHeightRatio:@.5];
    self.imageView.layer.borderWidth = 1;
    self.imageView.clipsToBounds = YES;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.backgroundColor = CPRandomColor();
    
    self.titleLabel.sd_layout
    .topSpaceToView(self.imageView, CPAuto(5))
    .leftEqualToView(self)
    .rightEqualToView(self)
    .heightIs(CPAuto(20));
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.titleLabel.font = CPFont_Regular(12);
    self.titleLabel.textColor = CPColor(@"#666666");
    
}

- (void)drawRect:(CGRect)rect
{
    
}

#pragma mark - Public



#pragma mark - get


@end
