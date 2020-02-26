#import "QukanLineupHeaderCell.h"
@implementation QukanLineupHeaderCell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.numberLabel.layer.masksToBounds = YES;
    self.numberLabel.layer.cornerRadius = 12.0;
    self.numberLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    self.numberLabel.layer.borderWidth = 1.0;
}
@end
