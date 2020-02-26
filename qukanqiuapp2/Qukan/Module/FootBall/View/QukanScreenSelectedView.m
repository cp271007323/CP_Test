#import "QukanScreenSelectedView.h"
@implementation QukanScreenSelectedView
- (void)awakeFromNib {
    [super awakeFromNib];
    UIButton *allBtn = [self viewWithTag:100];
    allBtn.layer.masksToBounds = YES;
    allBtn.layer.cornerRadius = 3.0;
    allBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    allBtn.layer.borderWidth = 0.5;
    [allBtn setTitleColor:[UIColor colorWithRed:147/255.0 green:147/255.0 blue:147/255.0 alpha:1.0] forState:UIControlStateNormal];
    UIButton *reverseBtn = [self viewWithTag:200];
    reverseBtn.layer.masksToBounds = YES;
    reverseBtn.layer.cornerRadius = 3.0;
    reverseBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    reverseBtn.layer.borderWidth = 0.5;
    UIButton *sureBtn = [self viewWithTag:300];
    sureBtn.layer.masksToBounds = YES;
    sureBtn.layer.cornerRadius = 3.0;
    sureBtn.backgroundColor = kThemeColor;
    self.matchCountLabel.textColor = kThemeColor;
}
- (IBAction)buttonClicked:(UIButton *)btn {
    for (int i=1; i<3; i++) {
        UIButton *button = [self viewWithTag:i*100];
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [button setTitleColor:[UIColor colorWithRed:147/255.0 green:147/255.0 blue:147/255.0 alpha:1.0] forState:UIControlStateNormal];
    }
    btn.layer.borderColor = kThemeColor.CGColor;
    [btn setTitleColor:kThemeColor forState:UIControlStateNormal];
    if (self.Qukan_selectedBlick) {
        self.Qukan_selectedBlick(btn.tag==100?1:2);
    }
}
- (IBAction)sureButtonClicked:(UIButton *)btn {
    if (self.Qukan_selectedBlick) {
        self.Qukan_selectedBlick(3);
    }
}

- (void)setSelectAll:(BOOL)selectAll {
    _selectAll = selectAll;
    UIButton *btn = [self viewWithTag:100];
    if (selectAll) {
        btn.layer.borderColor = kThemeColor.CGColor;
        [btn setTitleColor:kThemeColor forState:UIControlStateNormal];
    }else {
        btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [btn setTitleColor:[UIColor colorWithRed:147/255.0 green:147/255.0 blue:147/255.0 alpha:1.0] forState:UIControlStateNormal];
    }
}
@end
