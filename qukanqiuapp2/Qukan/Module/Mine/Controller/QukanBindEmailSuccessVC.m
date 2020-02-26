//
//  QukanBindEmailSuccessVC.m
//  Topic
//
//  Created by leo on 2019/9/9.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanBindEmailSuccessVC.h"
#import "QukanBindEmailVC.h"

@interface QukanBindEmailSuccessVC ()
@property (weak, nonatomic) IBOutlet UILabel *lab_emialTex;
@property (weak, nonatomic) IBOutlet UIButton *btn_goback;

@end

@implementation QukanBindEmailSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [self.btn_goback setBackgroundImage:[UIImage imageWithColor:kThemeColor] forState:UIControlStateNormal];
    
    self.title = @"已绑定邮箱";
    self.lab_emialTex.text = [NSString stringWithFormat:@"已绑定邮箱%@",self.str_email];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (IBAction)btn_rebindClick:(id)sender {
    QukanBindEmailVC *vc = [QukanBindEmailVC new];
    
    [self.navigationController pushViewController:vc animated:YES];
    NSMutableArray *marr = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    for (UIViewController *vc in marr) {
        if (vc == self) {
            [marr removeObject:vc];
            break;//break一定要加，不加有时候有bug
        }
    }
    self.navigationController.viewControllers = marr;
    
}

@end
