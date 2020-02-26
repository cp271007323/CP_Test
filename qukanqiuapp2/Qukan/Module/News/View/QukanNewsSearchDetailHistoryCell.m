//
//  QukanNewsSearchDetailHistoryCell.m
//  Qukan
//
//  Created by blank on 2020/1/5.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanNewsSearchDetailHistoryCell.h"
@interface QukanNewsSearchDetailHistoryCell()
@property (nonatomic, strong)UIView *backView;
@property (nonatomic, strong)UILabel *content;
@end
@implementation QukanNewsSearchDetailHistoryCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.backView];
        [self.backView addSubview:self.content];
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.offset(0);
        }];
        [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(6);
            make.right.offset(-6);
            make.height.offset(17);
            make.centerY.offset(0);
        }];
    }
    return self;
}
- (void)setContentString:(NSString *)contentString {
    self.content.text = contentString;
}
- (UIView *)backView {
    if (!_backView) {
        _backView = [UIView new];
        _backView.layer.cornerRadius = 4;
        _backView.layer.masksToBounds = 1;
        _backView.layer.borderColor = HEXColor(0xCECECE).CGColor;
        _backView.layer.borderWidth = 0.5;
    }
    return _backView;
}
- (UILabel *)content {
    if (!_content) {
        _content = [UILabel new];
        _content.textColor = kTextGrayColor;
        _content.font = kFont12;
        _content.textAlignment = NSTextAlignmentCenter;
    }
    return _content;
}
@end
