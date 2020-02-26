//
//  CollectionViewCell.m
//  Linkage
//
//  Created by LeeJay on 16/8/22.
//  Copyright © 2016年 LeeJay. All rights reserved.
//  代码下载地址https://github.com/leejayID/Linkage

#import "QukanFilterCollectionViewCell.h"

@interface QukanFilterCollectionViewCell ()



@end

@implementation QukanFilterCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.contentView.backgroundColor = HEXColor(0xFAF9F9);
        
        self.imageV = [UIImageView new];
        [self.contentView addSubview:self.imageV];
        [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.mas_equalTo(self.name.mas_top).offset(-15);
            make.width.height.offset(40);
            make.center.offset(0);
        }];
        self.imageV.layer.cornerRadius = 20;
        self.imageV.layer.masksToBounds = 1;
        self.imageV.contentMode = UIViewContentModeScaleAspectFit;
        
        
        self.name = UILabel.new;
        [self.contentView addSubview:self.name];
        [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.offset(0);
            make.bottom.mas_equalTo(-5);
//            make.left.offset(5);
//            make.right.offset(-5);
        }];
        self.name.font = kFont12;
        self.name.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}


@end
