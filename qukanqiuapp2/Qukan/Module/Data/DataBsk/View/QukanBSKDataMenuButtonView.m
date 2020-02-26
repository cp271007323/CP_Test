//
//  QukanBSKDataMenuButtonView.m
//  Qukan
//
//  Created by blank on 2020/1/1.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanBSKDataMenuButtonView.h"

@implementation QukanBSKDataMenuButtonView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.contentLab = [UILabel new];
        [self addSubview:self.contentLab];
        [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.centerY.offset(0);
            make.height.offset(12);
        }];
        
        self.arrow = [UIImageView new];
        [self addSubview:self.arrow];
        [self.arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentLab.mas_right).offset(2);
            make.width.height.offset(10);
            make.centerY.offset(0);
        }];
        self.arrow.image = kImageNamed(@"kqds_data_under");
        
        self.contentLab.textColor = HEXColor(0x929CAD);
        self.contentLab.font = kFont11;
        
        self.btn = [UIButton new];
        [self addSubview:self.btn];
        [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.offset(0);
        }];
    }
    return self;
}
- (void)setContent:(NSString *)content {
    self.contentLab.text = content;
    self.arrow.hidden = self.btn.hidden = !content.length;
}
@end
