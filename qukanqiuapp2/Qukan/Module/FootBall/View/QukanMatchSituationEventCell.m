#import "QukanMatchSituationEventCell.h"
@interface QukanMatchSituationEventCell()
@property (weak, nonatomic) IBOutlet UIImageView *eventImageView_1;
@property (weak, nonatomic) IBOutlet UIImageView *eventImageView_2;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel_1;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel_2;
@property (weak, nonatomic) IBOutlet UIImageView *img_rgihtBg;
@property (weak, nonatomic) IBOutlet UIImageView *img_leftBg;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end
@implementation QukanMatchSituationEventCell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.timeLabel.textColor = kCommonWhiteColor;
    
    self.timeLabel.layer.masksToBounds = YES;
    self.timeLabel.layer.cornerRadius = 12;
}
- (void)Qukan_setData:(NSDictionary *)dict {
    NSInteger haFlag = [dict[@"haFlag"] integerValue];
    NSInteger type = 0;
    if (![dict[@"type"] isEqualToString:@"<null>"]) {
        type = [dict[@"type"] integerValue];
    }
    if (haFlag==1) {
        self.img_leftBg.hidden = NO;
        self.img_rgihtBg.hidden = YES;
        self.eventImageView_1.hidden = NO;
        self.eventImageView_2.hidden = YES;
        self.nameLabel_1.hidden = NO;
        self.nameLabel_2.hidden = YES;
        self.nameLabel_1.text = dict[@"playerName"]?:@"";
        self.eventImageView_1.image = [UIImage imageNamed:[self Qukan_setEventImageNameWithType:type]];
    } else {
        self.img_rgihtBg.hidden = NO;
        self.img_leftBg.hidden = YES;
        self.eventImageView_1.hidden = YES;
        self.eventImageView_2.hidden = NO;
        self.nameLabel_1.hidden = YES;
        self.nameLabel_2.hidden = NO;
        self.nameLabel_2.text = dict[@"playerName"]?:@"";
        self.eventImageView_2.image = [UIImage imageNamed:[self Qukan_setEventImageNameWithType:type]];
    }
    self.timeLabel.text = [NSString stringWithFormat:@"%@'",dict[@"time"]];
}
- (NSString *)Qukan_setEventImageNameWithType:(NSInteger)type {
    switch (type) {
        case 1: return @"Qukan_jinqiu"; break;
        case 2: return @"Qukan_hongpai"; break;
        case 3: return @"Qukan_huangpai"; break;
        case 7: return @"Qukan_dianqiu"; break;
        case 8: return @"Qukan_wulongqiu"; break;
        case 9: return @"Qukan_huanghongpai"; break;
        case 11: return @"Qukan_huanren"; break;
        default: return @""; break;
    }
}
@end
