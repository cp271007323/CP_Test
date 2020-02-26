//
//  QukanSettingViewController.m
//  Qukan
//
//  Created by pfc on 2019/6/19.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanSettingViewController.h"
#import <WebKit/WebKit.h>
#import "QukanAboutViewController.h"
#import "QukanAgreementViewController.h"
#import <YYKit/YYKit.h>

@interface QukanSettingViewController ()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UITableView *tableView;

@end

@implementation QukanSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"系统设置";
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    _tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [UIView new];
    _tableView.backgroundColor = kCommentBackgroudColor;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIButton *goOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    goOutButton.frame = CGRectMake(kScreenWidth / 2 - 75, _tableView.centerY - 500, 150, 33);
    goOutButton.layer.cornerRadius = 33 / 2;
    goOutButton.layer.masksToBounds = YES;
    goOutButton.layer.borderWidth = 1.0;
    goOutButton.layer.borderColor = kThemeColor.CGColor;
    goOutButton.titleLabel.font = kFont15;
    [goOutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [goOutButton setTitleColor:kThemeColor forState:UIControlStateNormal];
    goOutButton.backgroundColor = [UIColor clearColor];
    [_tableView addSubview:goOutButton];
    [goOutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(33);
        make.bottom.equalTo(self.view).offset(-100);
        make.centerX.equalTo(self.tableView);
    }];
    @weakify(self);
    [[goOutButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
         [self outLogin];
    }];
}

#pragma mark ===================== UITableViewDataSource, UITableViewDelegate =================================

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"000"];
    cell.textLabel.font = kFont15;
    
    cell.textLabel.textColor = HEXColor(0x343434);
    if (indexPath.section == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row == 0) {
            cell.textLabel.text = @"关于我们";
        }else if (indexPath.row == 1) {
            cell.textLabel.text = @"隐私协议";
        } else  if (indexPath.row == 2) {
            cell.textLabel.text = @"清除缓存";
        }
    }else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.indentationLevel = (kScreenWidth/2-36)/10;
        cell.textLabel.text = @"退出登录";
        cell.textLabel.textColor = [UIColor redColor];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            QukanAboutViewController *vc = [[QukanAboutViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 1){
            QukanAgreementViewController *vc = [[QukanAgreementViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 2) {
            [self deleteCache];
        }
    }
    
    if (indexPath.section == 1) {
        [self outLogin];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}



#pragma mark ===================== Private Methods =========================

- (void)deleteCache {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"你确定要清除缓存吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {}];
    @weakify(self)
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        @strongify(self)
        KShowHUD
//        if (@available(iOS 9.0, *)) {
//            NSSet*websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
//            NSDate*dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
//            [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
//            }];
//        } else {
//            NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES)objectAtIndex:0];
//            NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
//            NSError*errors;
//            [[NSFileManager defaultManager]removeItemAtPath:cookiesFolderPath error:&errors];
//        }
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{

        }];
        
        [self deleteWebCache];
        
        [self performSelector:@selector(showCleanTip) withObject:nil afterDelay:1.5];

    }];
    [alertController addAction:action1];
    [alertController addAction:action2];
//    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alertController animated:YES completion:nil];
//    });
}


- (void)deleteWebCache {
    //allWebsiteDataTypes清除所有缓存
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        
    }];
}


- (void)showCleanTip {
    KHideHUD
    [self.view showTip:@"清除缓存成功"];
}

- (void)outLogin {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"你确定要退出当前账号吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {}];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [kUserManager logOut];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserDidLogoutNotification object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alertController addAction:action1];
    [alertController addAction:action2];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alertController animated:YES completion:nil];
    });
}


- (void)share {

}
@end
