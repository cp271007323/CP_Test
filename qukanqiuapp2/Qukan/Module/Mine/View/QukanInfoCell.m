#import "QukanInfoCell.h"

@implementation QukanInfoCell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 40.0;
    UIImage *image = [UIImage imageNamed:@"Qukan_fx_all"];
    self.rightImageView.image = [image imageWithColor:kThemeColor];
    self.mySwitch.onTintColor = kThemeColor;
}
- (IBAction)switchBtnClicked:(id)sender {
    if (self.Qukan_switchBlock) {
        self.Qukan_switchBlock();
    }
}
@end
