#import "QukanScreenCell.h"
#import "QukanScreenTableModel.h"
#import "QukanBasketScreenTableModel.h"
@interface QukanScreenCell()
@property (nonatomic, weak) IBOutlet UILabel *contentLabel;
@end
@implementation QukanScreenCell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 3.0;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 0.5;
}

- (void)Qukan_setData:(QukanScreenTableModel *)model {
    if (model.isSelected) {
        self.layer.borderColor = kThemeColor.CGColor;
        self.backgroundColor = kThemeColor;
        self.contentLabel.textColor = [UIColor whiteColor];
    } else {
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.backgroundColor = [UIColor clearColor];
        self.contentLabel.textColor = HEXColor(0x666666);
    }
    self.contentLabel.text = [NSString stringWithFormat:@"%@[%ld]", model.gbShort, model.matchCount];
}


- (void)Qukan_setBasketData:(QukanBasketScreenTableModel *)model {
    if (model.selected) {
        self.layer.borderColor = kThemeColor.CGColor;
        self.backgroundColor = kThemeColor;
        self.contentLabel.textColor = [UIColor whiteColor];
    } else {
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.backgroundColor = [UIColor clearColor];
        self.contentLabel.textColor = HEXColor(0x666666);
    }
    self.contentLabel.text = [NSString stringWithFormat:@"%@[%ld]", model.leagueName, model.countz];
}
@end
