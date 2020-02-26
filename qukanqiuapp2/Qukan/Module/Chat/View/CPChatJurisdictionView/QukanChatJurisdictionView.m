//
//  QukanChatJurisdictionView.m
//  Qukan
//
//  Created by Mac on 2020/2/22.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanChatJurisdictionView.h"

@interface QukanChatJurisdictionView ()

@end

@implementation QukanChatJurisdictionView


#pragma mark - set



#pragma mark - Life
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupInitLayoutForQukanChatJurisdictionView];
        [self setupInitBindingForQukanChatJurisdictionView];
    }
    return self;
}

#pragma mark - Private
- (void)setupInitLayoutForQukanChatJurisdictionView
{
    [self.backView sd_addSubviews:@[self.titleLab,self.jurisdictionBtn,self.submitBtn]];
    
    self.backView.sd_layout
    .widthIs(CPAuto(310));
    
    self.titleLab.sd_layout
    .topSpaceToView(self.backView, CPAuto(32))
    .leftSpaceToView(self.backView, CPAuto(30))
    .rightSpaceToView(self.backView, CPAuto(30))
    .autoHeightRatio(0);
    
    self.jurisdictionBtn.sd_layout
    .topSpaceToView(self.titleLab, CPAuto(20))
    .centerXEqualToView(self.backView);
    [self.jurisdictionBtn setupAutoSizeWithHorizontalPadding:0 buttonHeight:CPAuto(30)];
    
    self.submitBtn.sd_layout
    .topSpaceToView(self.jurisdictionBtn, CPAuto(30))
    .leftSpaceToView(self.backView, CPAuto(17))
    .rightSpaceToView(self.backView, CPAuto(17))
    .heightIs(CPAuto(40));
    [self.submitBtn setSd_cornerRadiusFromHeightRatio:@.5];
    
    [self.backView setupAutoHeightWithBottomView:self.submitBtn bottomMargin:CPAuto(30)];
    [self.backView setSd_cornerRadius:@20];
    
}

- (void)setupInitBindingForQukanChatJurisdictionView
{
    
}

#pragma mark - Public



#pragma mark - get
- (UILabel *)titleLab
{
    if (_titleLab == nil) {
        _titleLab = [UILabel new];
        _titleLab.textColor = CPColor(@"000000");
        _titleLab.font = CPFont_Regular(15);
        _titleLab.text = @"很抱歉，暂无查看权限";
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

- (UIButton *)jurisdictionBtn
{
    if (_jurisdictionBtn == nil) {
        _jurisdictionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_jurisdictionBtn setTitle:@"如何获得权限＞" forState:UIControlStateNormal];
        [_jurisdictionBtn setTitleColor:CPColor(@"#0063FF") forState:UIControlStateNormal];
        _jurisdictionBtn.titleLabel.font = CPFont_Regular(15);
    }
    return _jurisdictionBtn;
}

- (UIButton *)submitBtn
{
    if (_submitBtn == nil) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitBtn setTitle:@"我知道了" forState:UIControlStateNormal];
        [_submitBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _submitBtn.backgroundColor = CPColor(@"#E9474F");
        _submitBtn.titleLabel.font = CPFont_Regular(16);
    }
    return _submitBtn;
}

@end
