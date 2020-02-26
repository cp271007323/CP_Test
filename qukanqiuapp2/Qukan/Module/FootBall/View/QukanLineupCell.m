#import "QukanLineupCell.h"
@interface QukanLineupCell()
@end
@implementation QukanLineupCell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.numberLabel_1.layer.masksToBounds = YES;
    self.numberLabel_2.layer.masksToBounds = YES;
    self.numberLabel_1.layer.cornerRadius = 12.0;
    self.numberLabel_2.layer.cornerRadius = 12.0;
}
@end
