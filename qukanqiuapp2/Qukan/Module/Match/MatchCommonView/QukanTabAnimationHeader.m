//
//  QukanTabAnimationHeader.m
//  Qukan
//
//  Created by leo on 2020/1/4.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanTabAnimationHeader.h"

@interface QukanTabAnimationHeader ()

/***/
@property(nonatomic, strong) UIView   * Qukan_view1;
/***/
@property(nonatomic, strong) UIView   * Qukan_view2;

@end


@implementation QukanTabAnimationHeader

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    [self addSubview:self.Qukan_view1];
    [self addSubview:self.Qukan_view2];
    [self.Qukan_view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self).offset(10);
        make.size.mas_equalTo(CGSizeMake(240, 36));
    }];
    
    [self.Qukan_view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(100, 36));
    }];
}


- (UIView *)Qukan_view1 {
    if (!_Qukan_view1) {
        _Qukan_view1 = [UIView new];
    }
    return _Qukan_view1;
}

- (UIView *)Qukan_view2 {
    if (!_Qukan_view2) {
        _Qukan_view2 = [UIView new];
    }
    return _Qukan_view2;
}

@end
