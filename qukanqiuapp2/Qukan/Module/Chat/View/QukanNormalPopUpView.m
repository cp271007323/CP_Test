//
//  QukanNormalPopUpView.m
//  Qukan
//
//  Created by Mac on 2020/2/23.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanNormalPopUpView.h"

@interface QukanNormalPopUpView ()

@end

@implementation QukanNormalPopUpView


#pragma mark - set
- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLab.text = title;
    [self.titleLab updateLayout];
}

- (void)setContent:(NSString *)content
{
    _content = content;
    self.contentLab.text = content;
    [self.contentLab updateLayout];
}


#pragma mark - Life
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupInitLayoutForQukanNormalPopUpView];
        [self setupInitBindingForQukanNormalPopUpView];
    }
    return self;
}

#pragma mark - Private
- (void)setupInitLayoutForQukanNormalPopUpView
{
    [self.backView sd_addSubviews:@[self.titleLab,self.contentLab,self.cancleBtn,self.submitBtn]];
    
    self.backView.sd_layout
    .widthIs(CPAuto(310));
    
    self.titleLab.sd_layout
    .topSpaceToView(self.backView, CPAuto(32))
    .leftSpaceToView(self.backView, CPAuto(30))
    .rightSpaceToView(self.backView, CPAuto(30))
    .autoHeightRatio(0);
    
    self.contentLab.sd_layout
    .topSpaceToView(self.titleLab, CPAuto(20))
    .centerXEqualToView(self.backView)
    .autoHeightRatio(0);
    [self.contentLab setSingleLineAutoResizeWithMaxWidth:CPAuto(280)];
    
    self.cancleBtn.sd_layout
    .topSpaceToView(self.contentLab, CPAuto(30))
    .leftSpaceToView(self.backView, CPAuto(15))
    .widthIs(CPAuto(135))
    .heightIs(CPAuto(40));
    [self.cancleBtn setSd_cornerRadiusFromHeightRatio:@.5];
    
    self.submitBtn.sd_layout
    .topSpaceToView(self.contentLab, CPAuto(30))
    .rightSpaceToView(self.backView, CPAuto(15))
    .widthIs(CPAuto(135))
    .heightIs(CPAuto(40));
    [self.submitBtn setSd_cornerRadiusFromHeightRatio:@.5];
    
    [self.backView setSd_cornerRadius:@8];
    [self.backView setupAutoHeightWithBottomView:self.submitBtn bottomMargin:CPAuto(30)];
}

- (void)setupInitBindingForQukanNormalPopUpView
{
    @weakify(self)
    [[[self.cancleBtn rac_signalForControlEvents:UIControlEventTouchUpInside] merge:[self.submitBtn rac_signalForControlEvents:UIControlEventTouchUpInside]] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self dissCoverView];
    }];
}

#pragma mark - Public



#pragma mark - get
- (UILabel *)titleLab
{
    if (_titleLab == nil) {
        _titleLab = [UILabel new];
        _titleLab.textColor = CPColor(@"000000");
        _titleLab.font = CPFont_Medium(16);
        _titleLab.text = @"探求宝典";
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

- (UILabel *)contentLab
{
    if (_contentLab == nil) {
        _contentLab = [UILabel new];
        _contentLab.textColor = CPColor(@"000000");
        _contentLab.font = CPFont_Regular(15);
        _contentLab.text = @"";
    }
    return _contentLab;
}


- (UIButton *)submitBtn
{
    if (_submitBtn == nil) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_submitBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _submitBtn.backgroundColor = CPColor(@"#E9474F");
        _submitBtn.titleLabel.font = CPFont_Regular(16);
    }
    return _submitBtn;
}

- (UIButton *)cancleBtn
{
    if (_cancleBtn == nil) {
        _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancleBtn setTitleColor:CPColor(@"#333333") forState:UIControlStateNormal];
        _cancleBtn.backgroundColor = CPColor(@"#F5F5F5");
        _cancleBtn.titleLabel.font = CPFont_Regular(16);
    }
    return _cancleBtn;
}


@end
