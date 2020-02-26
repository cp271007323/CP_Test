#import "QukanMatchSituationStatisticsCell.h"
#import "QukanRadTeamView.h"
@interface QukanMatchSituationStatisticsCell()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UILabel *numberLabel_1;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel_2;

@property (weak, nonatomic) IBOutlet QukanRadTeamView *rightView;

@property (weak, nonatomic) IBOutlet UIView *view_blueV;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *redLineWidth;

@end
@implementation QukanMatchSituationStatisticsCell
- (void)awakeFromNib {
    [super awakeFromNib];
    CALayer *layer = [UIManager createGradientLayerForForSize:CGSizeMake(kScreenWidth - 150, 2) andFromColor:HEXColor(0xD2E4FF) toColor:HEXColor(0x4688E5)];
    layer.frame = CGRectMake(0, 0, kScreenWidth - 150, 5);
    [self.view_blueV.layer addSublayer:layer];
}



- (void)Qukan_setData:(NSArray *)array {
    if (!array || array.count==0) {
        self.contentLabel.text = @"";
        self.numberLabel_1.text = @"";
        self.numberLabel_2.text = @"";
        return;
    }
    if (array.count>=1) {
        self.contentLabel.text = [NSString stringWithFormat:@"%@", array[0]];
    } else {
        self.contentLabel.text = @"";
    }
    if (array.count>=2) {
        self.numberLabel_1.text = [NSString stringWithFormat:@"%@", array[1]];
    } else {
        self.numberLabel_1.text = @"";
    }
    if (array.count>=3) {
        self.numberLabel_2.text = [NSString stringWithFormat:@"%@", array[2]];
    } else {
        self.numberLabel_2.text = @"";
    }
    CGFloat leftValue = 0.0;
    CGFloat rightValue = 0.0;
    if (array.count>=4) {
        CGFloat ratio = [array[3] floatValue];
        leftValue = ratio;
    }
    if (array.count>=5) {
        CGFloat ratio = [array[4] floatValue];
        rightValue = ratio;
    }
    
    if (leftValue > 0 && rightValue > 0) {
        self.redLineWidth.constant = (kScreenWidth - 150) * leftValue / (leftValue + rightValue) + 5;
        [self.rightView layoutIfNeeded];
        [self.rightView setNeedsDisplay];
        
    }else if(leftValue == 0){
        self.redLineWidth.constant = 0;
    }else {
        self.redLineWidth.constant = kScreenWidth - 150;
       
    }
}
@end
