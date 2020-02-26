//
//  QukanChangeTableViewCell.m
//  Qukan
//
//  Created by Kody on 2019/8/14.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanChangeTableViewCell.h"
#import "QukanScreenModel.h"

@interface QukanChangeTableViewCell()

@property(nonatomic, strong) UILabel        *dayLabel;
@property(nonatomic, strong) UILabel        *jLabel;


@end

@implementation QukanChangeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = HEXColor(0x464954);
    if (self) {
        [self addSubViews];
    }
    return self;
}

- (void)addSubViews {
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, self.height - 20)];
    iconImageView.image = [UIImage imageNamed:@"Qukan_screenPrivileges"];
    iconImageView.contentMode = UIViewContentModeCenter;
    iconImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:iconImageView];
    
    UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconImageView.right + 7, 0, kScreenWidth / 2 - iconImageView.right - 7, self.height)];
    dayLabel.text = @"---";
    dayLabel.textColor = [UIColor whiteColor];
    dayLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:dayLabel];
    _dayLabel = dayLabel;
    
    UILabel *jLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 70, self.height / 2 - 10 ,60, 20)];
    jLabel.text = FormatString(@"300%@",kStStatus.duration);
    jLabel.textColor = kThemeColor;
    jLabel.font = [UIFont systemFontOfSize:11];
    jLabel.textAlignment = NSTextAlignmentCenter;
    jLabel.layer.borderWidth = 1;
    jLabel.layer.borderColor = kThemeColor.CGColor;
    jLabel.layer.cornerRadius = jLabel.height / 2;
    jLabel.layer.masksToBounds = YES;
    [self addSubview:jLabel];
    _jLabel = jLabel;
    
}
- (void)Qukan_SetScreenWith:(QukanScreenModel *__nullable)model {
    _dayLabel.text = model.name;
    _jLabel.text = [NSString stringWithFormat:@"%ld%@",model.vals,kStStatus.duration];
}

@end
