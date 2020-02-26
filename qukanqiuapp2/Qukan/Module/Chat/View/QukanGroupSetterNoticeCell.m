//
//  QukanGroupSetterNoticeCell.m
//  Qukan
//
//  Created by Mac on 2020/2/24.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanGroupSetterNoticeCell.h"

@interface QukanGroupSetterNoticeCell ()

@property (nonatomic , strong) UIView *backView;

@property (nonatomic , strong) UIImageView *headImageView;

@property (nonatomic , strong) UILabel *nicknameLab;

@property (nonatomic , strong) UILabel *timeLab;

@property (nonatomic , strong) UILabel *note1Lab;

@property (nonatomic , strong) UILabel *note2Lab;

@property (nonatomic , strong) UILabel *note3Lab;

@property (nonatomic , strong) UILabel *note4Lab;

@property (nonatomic , strong) UILabel *note5Lab;

@property (nonatomic , strong) UILabel *note6Lab;

@end

@implementation QukanGroupSetterNoticeCell

#pragma mark - set
- (void)setModel:(NSString *)model
{
    _model = model;
}


#pragma mark - Life
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupInitLayoutForQukanGroupSetterNoticeCell];
        [self setupInitBindingForQukanGroupSetterNoticeCell];
    }
    return self;
}


#pragma mark - Private
- (void)setupInitLayoutForQukanGroupSetterNoticeCell
{
    [self.contentView addSubview:self.backView];
    [self.backView sd_addSubviews:@[self.headImageView,self.nicknameLab,self.timeLab,self.note1Lab,self.note2Lab,self.note3Lab,self.note4Lab,self.note5Lab,self.note6Lab]];
    
    self.backView.sd_layout
    .topSpaceToView(self.contentView, 0)
    .leftSpaceToView(self.contentView, CPAuto(15))
    .rightSpaceToView(self.contentView, CPAuto(15));
    
    self.headImageView.sd_layout
    .topSpaceToView(self.backView, CPAuto(15))
    .leftSpaceToView(self.backView, CPAuto(15))
    .widthIs(CPAuto(40))
    .heightEqualToWidth();
    [self.headImageView setSd_cornerRadiusFromHeightRatio:@.5];
    
    self.timeLab.sd_layout
    .centerYEqualToView(self.headImageView)
    .rightSpaceToView(self.backView, CPAuto(15))
    .autoHeightRatio(0);
    [self.timeLab setSingleLineAutoResizeWithMaxWidth:200];
    
    self.nicknameLab.sd_layout
    .centerYEqualToView(self.headImageView)
    .leftSpaceToView(self.headImageView, CPAuto(10))
    .heightIs(CPAuto(30))
    .rightSpaceToView(self.timeLab, CPAuto(10));
    
    self.note1Lab.sd_layout
    .topSpaceToView(self.headImageView, CPAuto(10))
    .leftSpaceToView(self.backView, CPAuto(15))
    .rightSpaceToView(self.backView, CPAuto(15))
    .autoHeightRatio(0);
    
    self.note2Lab.sd_layout
    .topSpaceToView(self.note1Lab, CPAuto(10))
    .leftSpaceToView(self.backView, CPAuto(15))
    .rightSpaceToView(self.backView, CPAuto(15))
    .autoHeightRatio(0);
    
    self.note3Lab.sd_layout
    .topSpaceToView(self.note2Lab, CPAuto(10))
    .leftSpaceToView(self.backView, CPAuto(15))
    .rightSpaceToView(self.backView, CPAuto(15))
    .autoHeightRatio(0);
    
    self.note4Lab.sd_layout
    .topSpaceToView(self.note3Lab, CPAuto(10))
    .leftSpaceToView(self.backView, CPAuto(15))
    .rightSpaceToView(self.backView, CPAuto(15))
    .autoHeightRatio(0);
    
    self.note5Lab.sd_layout
    .topSpaceToView(self.note4Lab, CPAuto(10))
    .leftSpaceToView(self.backView, CPAuto(15))
    .rightSpaceToView(self.backView, CPAuto(15))
    .autoHeightRatio(0);
    
    self.note6Lab.sd_layout
    .topSpaceToView(self.note5Lab, CPAuto(10))
    .leftSpaceToView(self.backView, CPAuto(15))
    .rightSpaceToView(self.backView, CPAuto(15))
    .autoHeightRatio(0);
    
    [self.backView setupAutoHeightWithBottomView:self.note6Lab bottomMargin:CPAuto(15)];
    
    [self setupAutoHeightWithBottomView:self.backView bottomMargin:0];
    [self.backView setSd_cornerRadius:@4];
}

- (void)setupInitBindingForQukanGroupSetterNoticeCell
{
    
}

#pragma mark - Public


#pragma mark - get
+ (NSString *)identifier
{
    return NSStringFromClass(self);
}

- (UIView *)backView
{
    if (_backView == nil) {
        _backView = [UIView new];
        _backView.backgroundColor = UIColor.whiteColor;
    }
    return _backView;
}

- (UIImageView *)headImageView
{
    if (_headImageView == nil) {
        _headImageView = [UIImageView new];
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headImageView.backgroundColor = CPRandomColor();
    }
    return _headImageView;
}

- (UILabel *)nicknameLab
{
    if (_nicknameLab == nil) {
        _nicknameLab = [UILabel new];
        _nicknameLab.textColor = CPColor(@"333333");
        _nicknameLab.font = CPFont_Medium(16);
        _nicknameLab.text = @"XXXXXXXXX";
    }
    return _nicknameLab;
}

- (UILabel *)timeLab
{
    if (_timeLab == nil) {
        _timeLab = [UILabel new];
        _timeLab.textColor = CPColor(@"999999");
        _timeLab.font = CPFont_Regular(12);
        _timeLab.text = @"XXXXXXXXX";
    }
    return _timeLab;
}

- (UILabel *)note1Lab
{
    if (_note1Lab == nil) {
        _note1Lab = [UILabel new];
        _note1Lab.textColor = CPColor(@"333333");
        _note1Lab.font = CPFont_Regular(14);
        _note1Lab.text = @"XXXXXXXXX";
    }
    return _note1Lab;
}

- (UILabel *)note2Lab
{
    if (_note2Lab == nil) {
        _note2Lab = [UILabel new];
        _note2Lab.textColor = CPColor(@"333333");
        _note2Lab.font = CPFont_Regular(14);
        _note2Lab.text = @"XXXXXXXXX";
    }
    return _note2Lab;
}

- (UILabel *)note3Lab
{
    if (_note3Lab == nil) {
        _note3Lab = [UILabel new];
        _note3Lab.textColor = CPColor(@"333333");
        _note3Lab.font = CPFont_Regular(14);
        _note3Lab.text = @"XXXXXXXXX";
    }
    return _note3Lab;
}

- (UILabel *)note4Lab
{
    if (_note4Lab == nil) {
        _note4Lab = [UILabel new];
        _note4Lab.textColor = CPColor(@"333333");
        _note4Lab.font = CPFont_Regular(14);
        _note4Lab.text = @"XXXXXXXXX";
    }
    return _note4Lab;
}

- (UILabel *)note5Lab
{
    if (_note5Lab == nil) {
        _note5Lab = [UILabel new];
        _note5Lab.textColor = CPColor(@"333333");
        _note5Lab.font = CPFont_Regular(14);
        _note5Lab.text = @"XXXXXXXXX";
    }
    return _note5Lab;
}

- (UILabel *)note6Lab
{
    if (_note6Lab == nil) {
        _note6Lab = [UILabel new];
        _note6Lab.textColor = CPColor(@"333333");
        _note6Lab.font = CPFont_Regular(14);
        _note6Lab.text = @"XXXXXXXXX";
    }
    return _note6Lab;
}

@end
