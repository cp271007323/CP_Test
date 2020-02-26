#import "QukanHintRangeViewController.h"

@interface QukanHintRangeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView_1;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView_2;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView_3;
@property (nonatomic, strong) NSString *type;
@end
@implementation QukanHintRangeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"提示范围";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIButton *btn = [self.view viewWithTag:100];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 3.0;
    btn.backgroundColor = kThemeColor;
//    UIImage *image_1 = [UIImage imageNamed:@"ico_check_select"];
//    UIImage *image_2 = [UIImage imageNamed:@"ico_check_select"];
//    UIImage *image_1_1 = [image_1 imageWithColor:kThemeColor];
//    UIImage *image_2_2 = [image_2 imageWithColor:kThemeColor];
    self.type = [[NSUserDefaults standardUserDefaults] objectForKey:Qukan_RangeTips_Shock_Key];
    if ([self.type isEqualToString:@"1"]) {
        self.selectedImageView_1.hidden = NO;
        self.selectedImageView_2.hidden = YES;
        self.selectedImageView_3.hidden = YES;
    } else if ([self.type isEqualToString:@"2"]) {
        self.selectedImageView_1.hidden = YES;
        self.selectedImageView_2.hidden = NO;
        self.selectedImageView_3.hidden = YES;
    } else {
        self.selectedImageView_1.hidden = YES;
        self.selectedImageView_2.hidden = YES;
        self.selectedImageView_3.hidden = NO;
    }
    for (int i=1; i<4; i++) {
        UIView *v = [self.view viewWithTag:i*10];
        UITapGestureRecognizer *tapGesturRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [v addGestureRecognizer:tapGesturRecognizer];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


- (void)tapAction:(UITapGestureRecognizer *)tap {
//    UIImage *image_1 = [UIImage imageNamed:@"ico_check_select"];
//    UIImage *image_2 = [UIImage imageNamed:@"ico_check_select"];
//    UIImage *image_1_1 = [image_1 imageWithColor:kThemeColor];
//    UIImage *image_2_2 = [image_2 imageWithColor:kThemeColor];
    if (tap.view.tag==10) {
        self.type = @"1";
        self.selectedImageView_1.hidden = NO;
        self.selectedImageView_2.hidden = YES;
        self.selectedImageView_3.hidden = YES;
    } else if (tap.view.tag==20) {
        self.type = @"2";
        self.selectedImageView_1.hidden = YES;
        self.selectedImageView_2.hidden = NO;
        self.selectedImageView_3.hidden = YES;
    } else {
        self.type = @"3";
        self.selectedImageView_1.hidden = YES;
        self.selectedImageView_2.hidden = YES;
        self.selectedImageView_3.hidden = NO;
    }
    [[NSUserDefaults standardUserDefaults] setObject:self.type forKey:Qukan_RangeTips_Shock_Key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
- (IBAction)sureButtonClicked:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:self.type forKey:Qukan_RangeTips_Shock_Key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
