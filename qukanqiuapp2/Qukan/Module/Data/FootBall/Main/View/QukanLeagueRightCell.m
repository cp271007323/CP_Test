//
//  QukanLeagueRightCell.m
//  Qukan
//
//  Created by leo on 2019/10/30.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanLeagueRightCell.h"
#import "QukanLeagueInfoModel.h"


#define kTeamIconWidth kScaleScreen(50)

@interface QukanLeagueRightCell ()

/**球队图标*/
@property(nonatomic, strong) UIImageView   * img_teamIcon;
/**球队名字*/
@property(nonatomic, strong) UILabel   * lab_teamName;
/**u关注数*/
@property(nonatomic, strong) UILabel   * lab_likeCount;



@end

@implementation QukanLeagueRightCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
       
    }
    return self;
}

- (void)initUI {
    [self.contentView addSubview:self.img_teamIcon];
    [self.img_teamIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(5);
        make.width.height.equalTo(@(kTeamIconWidth));
    }];
    
    [self.contentView addSubview:self.lab_teamName];
    [self.lab_teamName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.img_teamIcon.mas_bottom).offset(5);
    }];
    
    [self.contentView addSubview:self.lab_likeCount];
    [self.lab_likeCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.lab_teamName.mas_bottom).offset(3);
    }];
}


#pragma mark ===================== function ==================================
- (void)fullCellWithModel:(QukanLeagueInfoModel *)model {
    
//    @weakify(self);
//    [[RACObserve(model, count) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
//        @strongify(self);
//        self.lab_likeCount.text = [NSString stringWithFormat:@"%@关注",model.count];
//    }];
//
//    if ([model.teamName isEqualToString:@"山东鲁能"]) {
//
//    }
//
//    NSString *str = model.teamImage;
//    if ([model.teamImage containsString:@".png"]) {
//        str = [NSString stringWithFormat:@"%@.png",[model.teamImage componentsSeparatedByString:@".png"].firstObject];
//    }
//    if ([model.teamImage containsString:@".jpg"]) {
//        str = [NSString stringWithFormat:@"%@.jpg",[model.teamImage componentsSeparatedByString:@".jpg"].firstObject];
//    }
//
//
//    [SDWebImageDownloader.sharedDownloader setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"
//                                 forHTTPHeaderField:@"Accept"];
    [self.img_teamIcon sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:[UIImage imageWithColor:HEXColor(0xeeeeee)]];
    self.lab_teamName.text = model.bigShort;
//    self.lab_likeCount.text = [NSString stringWithFormat:@"%@关注",model.count];
}

#pragma mark ===================== lazy ==================================
- (UIImageView *)img_teamIcon {
    if (!_img_teamIcon) {
        _img_teamIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        
    }
    return _img_teamIcon;
}

- (UILabel *)lab_teamName {
    if (!_lab_teamName) {
        _lab_teamName = [[UILabel alloc] initWithFrame:CGRectZero];
        _lab_teamName.font = kFont12;
        _lab_teamName.textColor = HEXColor(0x3c3d3e);
    }
    return _lab_teamName;
}

- (UILabel *)lab_likeCount {
    if (!_lab_likeCount) {
        _lab_likeCount = [[UILabel alloc] initWithFrame:CGRectZero];
        _lab_likeCount.font = [UIFont systemFontOfSize:9];
        _lab_likeCount.textColor = kTextGrayColor;
    }
    return _lab_likeCount;
}
@end
