#import <UIKit/UIKit.h>
@interface QukanInfoCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIImageView *rightImageView;
@property (nonatomic, weak) IBOutlet UIImageView *headImageView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UISwitch *mySwitch;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelRight;
@property (nonatomic, copy) void(^Qukan_switchBlock)(void);
@end
