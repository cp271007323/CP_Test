//
//  CollectionViewHeaderView.m
//  Linkage
//
//  Created by LeeJay on 16/8/22.
//  Copyright © 2016年 LeeJay. All rights reserved.
//  代码下载地址https://github.com/leejayID/Linkage

#import "QukanFilterCollectionViewHeaderView.h"

@implementation QukanFilterCollectionViewHeaderView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = HEXColor(0xFAF9F9);
        UIView *lineV = [UIView new];
        [self addSubview:lineV];
        [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.height.offset(0.5);
            make.right.offset(-15);
            make.top.offset(0);
        }];
        lineV.backgroundColor = HEXColor(0xD5D5D5);
        self.line = lineV;
        
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(15, 24, 150,17)];
        [self addSubview:self.title];
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.centerY.offset(0);
            make.height.offset(17);
        }];
        self.title.font = kFont12;
        self.title.textAlignment = NSTextAlignmentLeft;
    }
    return self;
}

@end
