//
//  QukanDailyHeaderCenterCell.m
//  Qukan
//
//  Created by leo on 2020/1/7.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanDailyHeaderCenterCell.h"
#import "QukanActionModel.h"

@interface QukanDailyHeaderCenterCell ()

/***/
@property(nonatomic, strong) UILabel   * QukanTop_lab;
/***/
@property(nonatomic, strong) UIImageView   * QukanCenter_img;
/***/
@property(nonatomic, strong) UILabel   * QukanBottom_lab;
/***/
@property(nonatomic, strong) UIButton   * QukanLinqu_btn;



@end


@implementation QukanDailyHeaderCenterCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}


- (void)initUI {
    [self.contentView addSubview:self.QukanTop_lab];
    [self.QukanTop_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(10);
        make.height.equalTo(@(14));
    }];
    
    [self.contentView addSubview:self.QukanCenter_img];
    [self.QukanCenter_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.QukanTop_lab.mas_bottom).offset(8);
        make.size.mas_equalTo(CGSizeMake(21, 25));
    }];
    
    [self.contentView addSubview:self.QukanBottom_lab];
    [self.QukanBottom_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.QukanCenter_img.mas_bottom).offset(11);
    }];
    
    [self.contentView addSubview:self.QukanLinqu_btn];
    [self.QukanLinqu_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.QukanBottom_lab.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(50, 20));
    }];
    
    [self.contentView addSubview:self.QukanArrow_img];
    [self.QukanArrow_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.QukanCenter_img);
        make.right.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(5, 8.5));
    }];
}


#pragma mark ===================== public fuction ==================================
- (void)fullCellWithModel:(QukanActionModel *)model {
    self.QukanTop_lab.text = model.name;
    self.QukanBottom_lab.text =[NSString stringWithFormat:@"%zd元", model.pageNumber];
    
    
    @weakify(self);
    [[RACObserve(model, status) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        NSString *total = [model.name substringWithRange:NSMakeRange(2, model.name.length - 3)];
        if (model.status == 2) {  // 已完成，已领取
            self.QukanLinqu_btn.selected = NO;
            [self.QukanLinqu_btn setTitle:FormatString(@"已%@",kStStatus.age) forState:UIControlStateNormal];
            [self.QukanLinqu_btn setBackgroundImage:[UIImage imageWithColor:HEXColor(0xcccccc)] forState:UIControlStateNormal];
            [self.QukanLinqu_btn setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
        } else if (model.status == 1) {  // 未领取
            self.QukanLinqu_btn.selected = YES;
            [self.QukanLinqu_btn setTitle:FormatString(@"%@",kStStatus.age) forState:UIControlStateNormal];
            [self.QukanLinqu_btn setBackgroundImage:[UIImage imageWithColor:kThemeColor] forState:UIControlStateNormal];
            [self.QukanLinqu_btn setTitleColor:HEXColor(0x9F7B00) forState:UIControlStateNormal];
        }else {  // 未完成
            self.QukanLinqu_btn.selected = NO;
            [self.QukanLinqu_btn setTitle:[NSString stringWithFormat:@"%@/%@",model.progress,total] forState:UIControlStateNormal];
            [self.QukanLinqu_btn setBackgroundImage:[UIImage imageWithColor:HEXColor(0xcccccc)] forState:UIControlStateNormal];
            [self.QukanLinqu_btn setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
        }
    }];
   
}

#pragma mark ===================== action ==================================
- (void)QukanLinqu_BtnClick {
    if (!self.QukanLinqu_btn.selected) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(QukanDailyHeaderCenterCellQukanLinqu_btnClick:)]) {
        [self.delegate QukanDailyHeaderCenterCellQukanLinqu_btnClick:self];
    }
}

#pragma mark ===================== lazy ==================================
-(UILabel *)QukanTop_lab {
    if (!_QukanTop_lab) {
        _QukanTop_lab = [UILabel new];
        _QukanTop_lab.text = @"--";
        _QukanTop_lab.font = [UIFont systemFontOfSize:10];
        _QukanTop_lab.textColor = kCommonBlackColor;
        _QukanTop_lab.alpha = 0.5;
    }
    return _QukanTop_lab;
}

- (UIImageView *)QukanCenter_img {
    if (!_QukanCenter_img) {
        _QukanCenter_img = [UIImageView new];
//        _QukanCenter_img.image = kImageNamed(@"redPoint_icon");
        [_QukanCenter_img sd_setImageWithURL:[QukanTool Qukan_getImageStr:@"redPoint_icon"]];
    }
    return _QukanCenter_img;
}

- (UILabel *)QukanBottom_lab {
    if (!_QukanBottom_lab) {
        _QukanBottom_lab = [UILabel new];
        _QukanBottom_lab.font = [UIFont systemFontOfSize:12];
        _QukanBottom_lab.textColor = kCommonTextColor;
        _QukanBottom_lab.text = @"--";
    }
    return _QukanBottom_lab;
}

- (UIButton *)QukanLinqu_btn {
    if (!_QukanLinqu_btn) {
        _QukanLinqu_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _QukanLinqu_btn.layer.masksToBounds = YES;
        _QukanLinqu_btn.layer.cornerRadius = 10;
        
        _QukanLinqu_btn.titleLabel.font = [UIFont systemFontOfSize:10];
        
        [_QukanLinqu_btn setBackgroundImage:[UIImage imageWithColor:kThemeColor] forState:UIControlStateNormal];
        [_QukanLinqu_btn setTitle:@"领取" forState:UIControlStateNormal];
        [_QukanLinqu_btn addTarget:self action:@selector(QukanLinqu_BtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _QukanLinqu_btn;
}

- (UIImageView *)QukanArrow_img {
    if (!_QukanArrow_img) {
        _QukanArrow_img = [UIImageView new];
        _QukanArrow_img.image = kImageNamed(@"Qukan_tArrow");
    }
    return _QukanArrow_img;
}

@end
