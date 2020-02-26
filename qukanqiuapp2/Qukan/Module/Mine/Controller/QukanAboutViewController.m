#import "QukanAboutViewController.h"

@interface QukanAboutViewController ()
@property (nonatomic, weak) IBOutlet UIImageView *logoImageView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *versionLabel;
@end
@implementation QukanAboutViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"关于我们";
    self.logoImageView.layer.masksToBounds = YES;
    self.logoImageView.layer.cornerRadius = 20.0;
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    self.nameLabel.text = infoDict[@"CFBundleDisplayName"];
    self.versionLabel.text = [NSString stringWithFormat:@"当前版本 V%@", infoDict[@"CFBundleShortVersionString"]];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
@end
