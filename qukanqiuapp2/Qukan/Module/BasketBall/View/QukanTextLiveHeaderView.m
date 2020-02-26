//
//  QukanTextLiveHeaderView.m
//  Qukan
//
//  Created by leo on 2019/12/18.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanTextLiveHeaderView.h"

@interface QukanTextLiveHeaderView()


@end


@implementation QukanTextLiveHeaderView

// 构造器
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self initUI];
//        self.contentView.backgroundColor = [UIColor blueColor];
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

    
    [self addSubview:self.lab_content];
    [self.lab_content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(8);
        make.height.equalTo(@(24));
    }];
}


#pragma mark ===================== lazy ==================================
- (UIButton *)lab_content {
    if (!_lab_content) {
        _lab_content = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lab_content setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
        _lab_content.titleLabel.font = kFont12;
        _lab_content.backgroundColor = kThemeColor;
        _lab_content.layer.cornerRadius = 12;
        _lab_content.layer.masksToBounds = YES;

        [_lab_content addTarget:self action:@selector(tapNodeAction) forControlEvents:UIControlEventTouchUpInside];

    }
    return _lab_content;
}

- (void)tapNodeAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(QukanNodeDidClick:)]) {
        [self.delegate QukanNodeDidClick:_lab_content];
    }
}


@end
