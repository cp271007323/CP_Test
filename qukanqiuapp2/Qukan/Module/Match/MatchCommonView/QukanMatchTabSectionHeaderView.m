//
//  QukanMatchTabSectionHeaderView.m
//  Qukan
//
//  Created by leo on 2019/12/26.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanMatchTabSectionHeaderView.h"
#import "QukanSharpBgView.h"

@interface QukanMatchTabSectionHeaderView ()

/**标题lab*/
@property(nonatomic, strong) UILabel   * lab_contentTitle;

/**灰色背景view*/
@property(nonatomic, strong) QukanSharpBgView   * view_bg;
/**白色背景*/
@property(nonatomic, strong) UIView   * view_WhirtBg;

/**同赛事按钮*/
@property(nonatomic, strong) UIButton   * btn_sameMatch;
/**同主客按钮*/
@property(nonatomic, strong) UIButton   * btn_sameTeam;

/***/
@property(nonatomic, strong) UIView   * view_bgRight;
/**少按钮*/
@property(nonatomic, strong) UIButton   * btn_less;
/**多按钮*/
@property(nonatomic, strong) UIButton   * btn_more;
/**按钮父视图*/
@property(nonatomic, strong) UIView   * view_btnSuper;

@end

@implementation QukanMatchTabSectionHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)initUI {
    
    [self addSubview:self.view_WhirtBg];
    [self.view_WhirtBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self addSubview:self.view_bgRight];
    [self.view_bgRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.bottom.equalTo(self).offset(-10);
        make.left.right.equalTo(self);
    }];
    
    [self.view_bgRight addSubview:self.view_btnSuper];
    [self.view_btnSuper mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view_bgRight);
        make.right.equalTo(self).offset(-14);
        make.width.equalTo(@(100));
        make.height.equalTo(@(23));
    }];
    
    [self.view_btnSuper addSubview:self.btn_less];
    [self.btn_less mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.view_btnSuper);
        make.right.equalTo(self.view_btnSuper.mas_centerX);
    }];
    
    [self.view_btnSuper addSubview:self.btn_more];
    [self.btn_more mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.view_btnSuper);
        make.left.equalTo(self.view_btnSuper.mas_centerX);
    }];
    
    
    [self addSubview:self.view_bg];
    [self.view_bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self).offset(10);
        make.height.equalTo(@(36));
        make.width.equalTo(@(143));
    }];
    
    [self.view_bg addSubview:self.lab_contentTitle];
    [self.lab_contentTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view_bg);
        make.left.equalTo(self.view_bg).offset(15);
    }];
    
    [self.view_bg addSubview:self.btn_sameMatch];
    [self.btn_sameMatch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view_bg);
        make.left.equalTo(self.lab_contentTitle.mas_right).offset(25);
        make.size.mas_equalTo(CGSizeMake(51, 23));
    }];
    
    
    [self.view_bg addSubview:self.btn_sameTeam];
    [self.btn_sameTeam mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view_bg);
        make.left.equalTo(self.btn_sameMatch.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(51, 23));
    }];
    
    
}

#pragma mark ===================== public function ==================================
- (void)fullHeaderWithTitle:(NSString *)titleStr {
    self.btn_sameTeam.hidden = YES;
    self.btn_sameMatch.hidden = YES;
    
    self.view_bgRight.hidden = YES;
    self.lab_contentTitle.text = titleStr;
    if ([titleStr isEqualToString:@"球队状况"]||[titleStr isEqualToString:@"历史交战"] || [titleStr isEqualToString:@"技术统计"] || [titleStr isEqualToString:@"重要事件"]) {
        [self.view_bg mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.offset(102);
        }];
    } else if ([titleStr isEqualToString:@"场均数据对比"]) {
        [self.view_bg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.offset(102);
    }];
        
    }
        
}

- (void)fullShowBtnHeaderWithTitle:(NSString *)titleStr sameMatch:(BOOL)sameMatch sameTeam:(BOOL)sameTeam type:(NSInteger)type andMaxCount:(NSInteger)maxCount{
    self.btn_sameTeam.hidden = NO;
    self.btn_sameMatch.hidden = NO;
    self.lab_contentTitle.text = titleStr;
    self.view_bgRight.hidden = NO;
    
    self.btn_sameTeam.selected = sameTeam;
    self.btn_sameMatch.selected = sameMatch;
    
    if (type == 1) {
        [self.btn_less setTitle:@"近6场" forState:UIControlStateNormal];
        [self.btn_more setTitle:@"近12场" forState:UIControlStateNormal];
        
        self.btn_less.selected = maxCount == 6;
        self.btn_more.selected = maxCount != 6;
    }else {
        [self.btn_less setTitle:@"近10场" forState:UIControlStateNormal];
        [self.btn_more setTitle:@"近20场" forState:UIControlStateNormal];
        
        self.btn_less.selected = maxCount == 10;
        self.btn_more.selected = maxCount != 10;
    }
    
    [self.view_bg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.offset(192);
    }];
}

#pragma mark ===================== action ==================================

// 同赛事点击
- (void)btn_sameMatchClick{
    self.btn_sameMatch.selected = !self.btn_sameMatch.selected;
    if (self.sameMatchBlock) {
        self.sameMatchBlock(self.btn_sameMatch.selected);
    }
}

// 同主客点击
- (void)btn_sameTeamClick {
    self.btn_sameTeam.selected = !self.btn_sameTeam.selected;
    if (self.sameTeamBlock) {
        self.sameTeamBlock(self.btn_sameTeam.selected);
    }
}

// 右边按钮点击
- (void )btn_moreClick {
    if (self.btn_more.selected) {
        return;
    }
    
    self.btn_more.selected = !self.btn_more.selected;
    self.btn_less.selected = !self.btn_less.selected;
    
    if (self.moreBlock) {
        self.moreBlock();
    }
}

// 左边按钮点击
- (void )btn_lessClick {
    if (self.btn_less.selected) {
        return;
    }
    
    self.btn_less.selected = !self.btn_less.selected;
    self.btn_more.selected = !self.btn_more.selected;
    
    if (self.lessBlock) {
        self.lessBlock();
    }
}

#pragma mark ===================== Setters =====================================

- (void)setView_bg_color:(UIColor *)view_bg_color {
    self.view_bg.color_fullC = view_bg_color;
}

- (void)setView_WhirtBg_color:(UIColor *)view_WhirtBg_color {
    self.view_WhirtBg.backgroundColor = view_WhirtBg_color;
}


#pragma mark ===================== lazy ==================================
- (UILabel *)lab_contentTitle {
    if (!_lab_contentTitle) {
        _lab_contentTitle = [UILabel new];
        _lab_contentTitle.font = [UIFont boldSystemFontOfSize:12];
        _lab_contentTitle.textColor = kCommonTextColor;
    }
    return _lab_contentTitle;
}

- (QukanSharpBgView *)view_bg {
    if (!_view_bg) {
        _view_bg = [[QukanSharpBgView alloc] initWithFrame:CGRectMake(0, 0, 20, 10) type:QukanSharpBgViewTypeRightTop AndOffset:10 andFullColor:HEXColor(0xe8e8e8)];
//        _view_bg.backgroundColor = kCommonWhiteColor;
    }
    return _view_bg;
}

- (UIView *)view_WhirtBg {
    if (!_view_WhirtBg) {
        _view_WhirtBg = [UIView new];
        _view_WhirtBg.backgroundColor = kCommonWhiteColor;
    }
    return _view_WhirtBg;
}


- (UIButton *)btn_sameTeam {
    if (!_btn_sameTeam) {
        _btn_sameTeam = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn_sameTeam setBackgroundImage:[UIImage imageWithColor:kCommonWhiteColor] forState:UIControlStateNormal];
        [_btn_sameTeam setBackgroundImage:[UIImage imageWithColor:kThemeColor] forState:UIControlStateSelected];
        
        _btn_sameTeam.layer.masksToBounds = YES;
        _btn_sameTeam.layer.cornerRadius = 11.5;
        
        [_btn_sameTeam setTitleColor:kCommonTextColor forState:UIControlStateNormal];
        [_btn_sameTeam setTitleColor:kCommonWhiteColor forState:UIControlStateSelected];
        
        _btn_sameTeam.titleLabel.font = kFont12;
        [_btn_sameTeam setTitle:@"同主客" forState:UIControlStateNormal];
        
        [_btn_sameTeam addTarget:self action:@selector(btn_sameTeamClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn_sameTeam;
}

- (UIButton *)btn_sameMatch {
    if (!_btn_sameMatch) {
        _btn_sameMatch = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn_sameMatch setBackgroundImage:[UIImage imageWithColor:kCommonWhiteColor] forState:UIControlStateNormal];
        [_btn_sameMatch setBackgroundImage:[UIImage imageWithColor:kThemeColor] forState:UIControlStateSelected];
        
        _btn_sameMatch.layer.masksToBounds = YES;
        _btn_sameMatch.layer.cornerRadius = 11.5;
        
        [_btn_sameMatch setTitleColor:kCommonTextColor forState:UIControlStateNormal];
        [_btn_sameMatch setTitleColor:kCommonWhiteColor forState:UIControlStateSelected];
        
        _btn_sameMatch.titleLabel.font = kFont12;
        [_btn_sameMatch setTitle:@"同赛事" forState:UIControlStateNormal];
        
        [_btn_sameMatch addTarget:self action:@selector(btn_sameMatchClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _btn_sameMatch;
}

- (UIView *)view_bgRight {
    if (!_view_bgRight) {
        _view_bgRight = [UIView new];
        _view_bgRight.backgroundColor = HEXColor(0xe8e8e8);
    }
    return _view_bgRight;
}


- (UIView *)view_btnSuper {
    if (!_view_btnSuper) {
        _view_btnSuper = [UIView new];
        
        _view_btnSuper.layer.masksToBounds = YES;
        _view_btnSuper.layer.cornerRadius = 11.5;
    }
    return _view_btnSuper;
}

- (UIButton *)btn_more {
    if (!_btn_more) {
        _btn_more = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn_more setBackgroundImage:[UIImage imageWithColor:kCommonWhiteColor] forState:UIControlStateNormal];
        [_btn_more setBackgroundImage:[UIImage imageWithColor:kThemeColor] forState:UIControlStateSelected];
        [_btn_more setTitleColor:kTextGrayColor forState:UIControlStateNormal];
        [_btn_more setTitleColor:kCommonTextColor forState:UIControlStateSelected];
        
        _btn_more.titleLabel.font = kFont12;
        
        [_btn_more addTarget:self action:@selector(btn_moreClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn_more;
}

- (UIButton *)btn_less {
    if (!_btn_less) {
        _btn_less = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn_less setBackgroundImage:[UIImage imageWithColor:kCommonWhiteColor] forState:UIControlStateNormal];
        [_btn_less setBackgroundImage:[UIImage imageWithColor:kThemeColor] forState:UIControlStateSelected];
        
        _btn_less.selected = YES;
        [_btn_less setTitleColor:kTextGrayColor forState:UIControlStateNormal];
        [_btn_less setTitleColor:kCommonTextColor forState:UIControlStateSelected];
        
        _btn_less.titleLabel.font = kFont12;
        [_btn_less addTarget:self action:@selector(btn_lessClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn_less;
}

@end
