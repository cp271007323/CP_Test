//
//  QukanCustomTabbarItem.m
//  Qukan
//
//  Created by leo on 2020/1/9.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanCustomTabbarItem.h"
#import "QukanCustomTabItemModel.h"


@interface QukanCustomTabbarItem ()

/**选中时的背景图片*/
@property(nonatomic, strong) UIImageView   * QukanSelectBg_img;
/**选中时的图标*/
@property(nonatomic, strong) UIImageView   * QukanSelect_img;
/**默认的图标*/
@property(nonatomic, strong) UIImageView   * QukanNormal_img;
/**下方小标题*/
@property(nonatomic, strong) UILabel   * QukanTitle_lab;

/**主模型*/
@property(nonatomic, strong) QukanCustomTabItemModel   * QukanItem_model;

@end


@implementation QukanCustomTabbarItem


- (instancetype)initWithFrame:(CGRect)frame andTabModel:(nonnull QukanCustomTabItemModel *)model{
    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = UIColor.blueColor;
        [self initUI];
        [self setQukanItem_model:model];
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


-(void)initUI {
    [self addSubview:self.QukanSelectBg_img];
    [self.QukanSelectBg_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.height.equalTo(@(38));
        make.top.equalTo(self).offset(-10);
    }];
    
    [self.QukanSelectBg_img addSubview:self.QukanSelect_img];
    [self.QukanSelect_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.QukanSelectBg_img);
    }];
    
    [self addSubview:self.QukanNormal_img];
    [self.QukanNormal_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(3);
        make.size.mas_equalTo(CGSizeMake(23, 23));
    }];
    
    [self addSubview:self.QukanTitle_lab];
    [self.QukanTitle_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-5);
    }];
}


#pragma mark ===================== kvo 监听 ==================================

- (void)setQukanItem_model:(QukanCustomTabItemModel *)QukanItem_model {
    _QukanItem_model = QukanItem_model;
    
    self.QukanSelect_img.image = kImageNamed(QukanItem_model.selectImgName);
    self.QukanNormal_img.image = kImageNamed(QukanItem_model.mormalImgName);
    self.QukanTitle_lab.text = QukanItem_model.itemTitle;
    
    self.QukanTitle_lab.textColor = QukanItem_model.normalColor;
}



- (void)setQukanIsSelect_bool:(BOOL)QukanIsSelect_bool{
    _QukanIsSelect_bool = QukanIsSelect_bool;
    
    self.QukanSelectBg_img.hidden = !QukanIsSelect_bool;
    self.QukanNormal_img.hidden = QukanIsSelect_bool;
    self.QukanTitle_lab.textColor = QukanIsSelect_bool?self.QukanItem_model.selectColor : self.QukanItem_model.normalColor;
    
    if (_QukanIsSelect_bool) { // 是选中
        [self beginAnimation];
    }
}

- (void)beginAnimation {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"transform.scale";
    animation.values = @[@1.0,@1.3,@0.9,@1.15,@0.95,@1.02,@1.0];
    animation.duration = 0.5;
    animation.calculationMode = kCAAnimationCubic;
    [self.QukanSelectBg_img.layer addAnimation:animation forKey:nil];
}

#pragma mark ===================== lazy ==================================

- (UIImageView *)QukanSelectBg_img {
    if (!_QukanSelectBg_img) {
        _QukanSelectBg_img = [UIImageView new];
        _QukanSelectBg_img.image = kImageNamed(@"tab_bg");
//        _QukanSelectBg_img.layer.shadowColor = kCommonBlackColor.CGColor;
//        _QukanSelectBg_img.layer.shadowOpacity = 0.2f;
//        _QukanSelectBg_img.layer.shadowRadius = 4.f;
//        _QukanSelectBg_img.layer.shadowOffset = CGSizeMake(-0,-3);
    }
    return _QukanSelectBg_img;
}

- (UIImageView *)QukanSelect_img {
    if (!_QukanSelect_img) {
        _QukanSelect_img = [UIImageView new];
    }
    return _QukanSelect_img;
}

- (UIImageView *)QukanNormal_img {
    if (!_QukanNormal_img) {
        _QukanNormal_img = [UIImageView new];
    }
    return _QukanNormal_img;
}

- (UILabel *)QukanTitle_lab {
    if (!_QukanTitle_lab) {
        _QukanTitle_lab = [UILabel new];
        _QukanTitle_lab.font = [UIFont boldSystemFontOfSize:10];
    }
    return _QukanTitle_lab;
}



@end
