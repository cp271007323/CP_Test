#import "QukanRedCardGoalTipsView.h"
#import "QukanDetailsViewController.h"
#import "QukanMatchInfoModel.h"
@interface QukanRedCardGoalTipsView()
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel_1;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel_2;
@property (nonatomic, weak) IBOutlet UILabel *contentLabel;
@property (nonatomic, weak) IBOutlet UILabel *homeScoreLabel;
@property (nonatomic, weak) IBOutlet UILabel *awayScoreLabel;
@property (nonatomic, strong) QukanMatchInfoContentModel *Qukan_model;

@end
@implementation QukanRedCardGoalTipsView
- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 8.0;
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Qukan_viewClick)];
    [self addGestureRecognizer:tapGesture];
    self.userInteractionEnabled = NO;
}
- (void)Qukan_setData:(QukanMatchInfoContentModel *)model isGoalTips:(BOOL)isGoalTips {
    self.Qukan_model = model;
    self.timeLabel.text = [NSString stringWithFormat:@"%@'", model.pass_time];
    self.nameLabel_1.text = model.home_name;
    self.nameLabel_2.text = model.away_name;
    self.contentLabel.text = isGoalTips==YES ? @"进球":@"红牌";
    self.homeScoreLabel.text = [NSString stringWithFormat:@"%ld", model.home_score];
    self.awayScoreLabel.text = [NSString stringWithFormat:@"%ld",model.away_score];
//    self.backgroundColor = isGoalTips==YES ? kThemeColor_Alpha(0.85):[UIColor colorWithRed:242/255.0 green:104/255.0 blue:131/255.0 alpha:0.85];
}
- (void)Qukan_viewClick {
    QukanDetailsViewController *vc = [[QukanDetailsViewController alloc] init];
    vc.Qukan_model = [self.Qukan_model copy];
    vc.hidesBottomBarWhenPushed = YES;
//    [[QukanTool Qukan_topViewController].navigationController pushViewController:vc animated:YES];
    // 每次进入详情界面时断开连接
    [[QukanIMChatManager sharedInstance] logOutChat:^(NSError * _Nullable error) {
    }];
    [[QukanTool Qukan_topViewController].navigationController pushViewController:vc animated:YES];
}
@end
