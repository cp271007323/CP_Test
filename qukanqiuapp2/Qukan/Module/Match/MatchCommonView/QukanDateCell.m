#import "QukanDateCell.h"
#import "QukanDateModel.h"
@interface QukanDateCell()
@property (weak, nonatomic) IBOutlet UILabel *label_1;
@property (weak, nonatomic) IBOutlet UILabel *label_2;
@property (weak, nonatomic) IBOutlet UIView *sep;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (nonatomic, strong)UIView *circleBackView;
@end
@implementation QukanDateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _sep.backgroundColor = UIColor.clearColor;
    self.backgroundColor = HEXColor(0xe8e8e8);
    self.label_1.textColor = HEXColor(0x4C5162);
    self.label_1.font = kFont14;
    self.label_2.textColor =  kCommonTextColor;
    self.label_2.font = kFont10;
    self.backView.backgroundColor = UIColor.clearColor;
    self.backView.layer.cornerRadius = 4;
    self.backView.layer.masksToBounds = 1;
    
    self.circleBackView = [UIView new];
    [self.backView insertSubview:self.circleBackView belowSubview:self.label_2];
    [self.circleBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.label_2.mas_centerY).offset(0);
        make.centerX.offset(0);
        make.width.height.offset(24);
    }];
    self.circleBackView.backgroundColor = UIColor.clearColor;
    self.circleBackView.layer.cornerRadius = 12;
    self.circleBackView.layer.masksToBounds = 1;
    
    
}

- (void)Qukan_setData:(QukanDateModel *)model {
    if (![model.date isEqualToString:@"今"]) {
        model.date = [model.date stringByReplacingOccurrencesOfString:@"-" withString:@"月"];
    }
    if ([model.date isEqualToString:@"今"]) {
        self.label_2.text = model.date;
    } else {
        if (model.date.length > 5) {
            self.label_2.text = FormatString(@"%@日",[model.date substringFromIndex:5]);
        }
    }
    self.label_1.text = model.week;
    if (model.isSelected) {
        self.backView.backgroundColor = kThemeColor;
        self.label_1.textColor = kCommonWhiteColor;
        self.label_2.textColor = kCommonWhiteColor;
    } else {
        self.backView.backgroundColor = UIColor.clearColor;
        self.label_1.textColor = HEXColor(0x4C5162);
        self.label_2.textColor = kCommonTextColor;
    }
    if ([model.date isEqualToString:@"今"]) {
        self.circleBackView.backgroundColor = kThemeColor;
        self.label_2.textColor = kCommonWhiteColor;
        self.label_2.font = kFont12;
    } else {
        self.label_2.font = kFont10;
        self.circleBackView.backgroundColor = UIColor.clearColor;
    }
}

- (void)setShowSep:(BOOL)showSep  {
    _showSep = showSep;
    _sep.hidden = !showSep;
}
@end
