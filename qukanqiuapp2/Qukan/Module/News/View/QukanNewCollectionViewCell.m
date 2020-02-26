//
//  QukanNewCollectionViewCell.m
//  Qukan
//
//  Created by Jeff on 2020/2/15.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanNewCollectionViewCell.h"

@implementation QukanNewCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView = imgView;
        [self addSubview:imgView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _imageView.frame = self.bounds;
}

@end
