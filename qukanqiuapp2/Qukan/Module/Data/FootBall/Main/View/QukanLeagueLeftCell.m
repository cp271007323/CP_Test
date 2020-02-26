//
//  QukanLeagueLeftCell.m
//  Qukan
//
//  Created by leo on 2019/10/30.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanLeagueLeftCell.h"

@implementation HighLightLabel

- (void)setHighlighted:(BOOL)highlighted{
    if(highlighted){
        self.font = [UIFont boldSystemFontOfSize:self.font.pointSize];
    }else{
        self.font = [UIFont systemFontOfSize:self.font.pointSize];
    }
}

@end

@interface QukanLeagueLeftCell ()


@end

@implementation QukanLeagueLeftCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    
    self.contentView.backgroundColor = selected ? HEXColor(0xFAF9F9) : [UIColor whiteColor];
    self.highlighted = selected;
    self.lab_teamName.highlighted = selected;
}


#pragma mark ===================== initUI ==================================
- (void)initUI {
    [self.contentView addSubview:self.lab_teamName];
    [self.lab_teamName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView);
    }];
}


#pragma mark ===================== fuction ==================================
- (void)fullCellWithModel:(QukanLeagueInfoModel *)model {
    
//    self.lab_teamName.text = model.bigShort;
    
}

#pragma mark ===================== lazy ==================================
- (UILabel *)lab_teamName {
    if (!_lab_teamName) {
        _lab_teamName = [[HighLightLabel alloc] initWithFrame:CGRectZero];
        _lab_teamName.font = kFont15;
        _lab_teamName.textColor = kCommonTextColor;
//        _lab_teamName.highlightedTextColor = kThemeColor;
    }
    return _lab_teamName;
}

@end
