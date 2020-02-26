//
//  QukanGDataTableViewCell.m
//  Qukan
//
//  Created by Kody on 2019/8/8.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanHotGTableViewCell.h"

@interface QukanHotGTableViewCell ()

@property(nonatomic, strong) UIImageView         *gImageView;

@end

@implementation QukanHotGTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    if (self) {
        [self.contentView addSubview:self.gImageView];
    }
    return self;
}

#pragma mark ===================== Set Data ==================================
- (void)Qukan_setDataWith:(QukanHomeModels *)model {
    [self.gImageView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:kImageNamed(@"Qukan_placeholder")];
}

#pragma mark ===================== Getters =================================
- (UIImageView *)gImageView {
    if (!_gImageView) {
        _gImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 68)];
        _gImageView.layer.cornerRadius = 0;
        _gImageView.layer.masksToBounds = YES;
//        _gImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _gImageView;
}

@end
