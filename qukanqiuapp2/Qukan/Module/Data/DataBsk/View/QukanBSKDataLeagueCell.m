//
//  QukanDataLeagueCell.m
//  Qukan
//
//  Created by blank on 2019/12/26.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanBSKDataLeagueCell.h"
@interface QukanBSKDataLeagueCell()
@property (nonatomic, strong)UILabel *leagueName;
@end
@implementation QukanBSKDataLeagueCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.leagueName];
        [self.leagueName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset(0);
            make.left.offset(0);
            make.right.offset(0);
            make.height.offset(22);
        }];
        [self.contentView addSubview:self.angleIgv];
        [self.angleIgv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.offset(0);
            make.width.offset(14);
            make.height.offset(5);
            make.bottom.offset(0);
        }];
    }
    return self;
}

- (void)setModel:(QukanBtSclassHotModel *)model {
    _model = model;
    self.leagueName.text = model.xshort;
    self.angleIgv.hidden = !model.selected;
    self.leagueName.textColor = model.selected ? kThemeColor : kCommonTextColor;
}

- (UILabel *)leagueName {
    if (!_leagueName) {
        _leagueName = [UILabel new];
        _leagueName.font = kFont14;
        _leagueName.textAlignment = NSTextAlignmentCenter;
        _leagueName.textColor = kCommonTextColor;
    }
    return _leagueName;
}
- (UIImageView *)angleIgv {
    if (!_angleIgv) {
        _angleIgv = [UIImageView new];
        _angleIgv.image = kImageNamed(@"kqds_data_sel");
    }
    return _angleIgv;
}
@end
