
//
//  QukanBasetDetailDataListCell.m
//  Qukan
//
//  Created by leo on 2020/1/3.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanBasetDetailDataListCell.h"


@interface QukanBasetDetailDataListCell ()

/**左边lab*/
@property(nonatomic, strong) UILabel   * QukanLeftData_lab;
/**右边lab*/
@property(nonatomic, strong) UILabel   * QukanRightData_lab;
/**中间lab*/
@property(nonatomic, strong) UILabel   * QukanCenterData_lab;

/**<#注释#>*/
@property(nonatomic, strong) UIView   * QukanBottomLine_view;

@end

@implementation QukanBasetDetailDataListCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark ===================== initUI ==================================
- (void)initUI {
    [self.contentView addSubview:self.QukanCenterData_lab];
    [self.QukanCenterData_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.QukanLeftData_lab];
    [self.QukanLeftData_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.centerX.equalTo(self.mas_centerX).multipliedBy(0.5);
    }];
    
    [self.contentView addSubview:self.QukanRightData_lab];
    [self.QukanRightData_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.centerX.equalTo(self.mas_centerX).multipliedBy(1.5);
    }];
    
    [self.contentView addSubview:self.QukanBottomLine_view];
    [self.QukanBottomLine_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.equalTo(@(0.5));
    }];
}


#pragma mark ===================== pubulic function ==================================
- (void)fullCellWithLeftData:(NSString *)LeftData centerStr:(NSString *)centerStr rightData:(NSString *)rightData{
    self.QukanLeftData_lab.text = LeftData;
    self.QukanCenterData_lab.text = centerStr;
    self.QukanRightData_lab.text = rightData;
}

#pragma mark ===================== lazy ==================================
- (UILabel *)QukanLeftData_lab {
    if (!_QukanLeftData_lab) {
        _QukanLeftData_lab = [UILabel new];
        _QukanLeftData_lab.textAlignment = NSTextAlignmentCenter;
        _QukanLeftData_lab.text = @"---";
        _QukanLeftData_lab.textColor = kCommonTextColor;
        _QukanLeftData_lab.font = kFont12;
    }
    return _QukanLeftData_lab;
}
- (UILabel *)QukanRightData_lab {
    if (!_QukanRightData_lab) {
        _QukanRightData_lab = [UILabel new];
        _QukanRightData_lab.textAlignment = NSTextAlignmentCenter;
        _QukanRightData_lab.text = @"---";
        _QukanRightData_lab.textColor = kCommonTextColor;
        _QukanRightData_lab.font = kFont12;
    }
    return _QukanRightData_lab;
}
- (UILabel *)QukanCenterData_lab {
    if (!_QukanCenterData_lab) {
        _QukanCenterData_lab = [UILabel new];
        _QukanCenterData_lab.textAlignment = NSTextAlignmentCenter;
        _QukanCenterData_lab.text = @"---";
        _QukanCenterData_lab.textColor = kTextGrayColor;
        _QukanCenterData_lab.font = kFont12;
    }
    return _QukanCenterData_lab;
}

- (UIView *)QukanBottomLine_view {
    if (!_QukanBottomLine_view) {
        _QukanBottomLine_view = [UIView new];
        _QukanBottomLine_view.backgroundColor = HEXColor(0xE3E2E2);
    }
    return _QukanBottomLine_view;
}


@end
