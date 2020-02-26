//
//  QukanGDataTableViewCell.m
//  Qukan
//
//  Created by Kody on 2019/8/8.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanGDataTableViewCell.h"
#import "QukanHomeModels.h"

@interface QukanGDataTableViewCell ()

@property(nonatomic, strong) UIImageView      *gImageView;

@end

@implementation QukanGDataTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self) {
        [self.contentView addSubview:self.gImageView];
        
        
        [self.gImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(5);
            make.right.equalTo(self.contentView).offset(-5);
            make.left.equalTo(self.contentView).offset(5);
            make.bottom.equalTo(self.contentView).offset(-5);
        }];
    }
    return self;
}


- (void)Qukan_SetNewsGDataWith:(QukanHomeModels *__nullable)model {
    [self.gImageView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:kImageNamed(@"Qukan_placeholder")];
}


#pragma mark ===================== Getters =================================
- (UIImageView *)gImageView {
    if (!_gImageView) {
        _gImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, self.width - 20, self.height)];
        _gImageView.layer.cornerRadius = 5;
        _gImageView.layer.masksToBounds = YES;
    }
    return _gImageView;
}

@end
