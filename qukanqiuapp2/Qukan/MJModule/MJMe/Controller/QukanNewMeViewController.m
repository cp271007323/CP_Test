#import "QukanNewMeViewController.h"
#import "QukanNewMeCell.h"
//#import "QukanAppDelegate.h"

//#import "QukanPhoneLoginViewController.h"
#import "QukanInfoViewController.h"
#import "QukanFeedbackViewController.h"
#import "QukanAboutViewController.h"
//#import "QukanTarBarViewController.h"
#import "QukanWebViewController.h"
#import "QukanRootSetupViewController.h"
#import "QukanFollowMainVC.h"
#import <WebKit/WebKit.h>
//#import <SDWebImage/SDImageCache.h>
#import <HBDNavigationController.h>
//#import "QukanBoilingPointTableView1Controller.h"b

#import "QukanApiManager+BasketBall.h"
#import "QukanApiManager+Competition.h"

#import <HBDNavigationBar/UIViewController+HBD.h>
#import "QukanYBArchiveUtil.h"
#import "QukanSet1VC.h"
//#import <SDWebImage/UIButton+WebCache.h>
#import "QukanApiManager+Mine.h"

//#import "QukanNewsDetailsViewController.h"
#import "QukanSystemMessageViewController.h"

#import "QukanChatViewController.h"

@interface QukanNewMeViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *Qukan_myTableView;

@property (nonatomic, strong) NSMutableArray *Qukan_dataArray;
@property (nonatomic, strong) NSDictionary   *Qukan_myDict;

@property(nonatomic, strong) UIView *headerView;
@property(nonatomic, strong) UIButton *nickBtn;
@property(nonatomic, strong) UIButton *headIcon; // 头像
@property(nonatomic, strong) UILabel  *Qukan_MyFocusOnLabel;
@property(nonatomic, strong) UILabel  *messLabel;
// 未读消息数量
@property(nonatomic, copy) NSString   *str_unReadMessage;

@property(nonatomic, strong) UILabel *lab_messageCount;

/**<#说明#>*/
@property(nonatomic, assign) NSInteger    followCount;

@end
@implementation QukanNewMeViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
#pragma mark ===================== Life Cycle ==================================
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = HEXColor(0xf7f7f7);
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],
                                                                      NSForegroundColorAttributeName:HEXColor(0x1A88D9)}];
    self.navigationItem.title = @"个人中心";
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.hbd_barHidden = YES;
    
    [[[kNotificationCenter rac_addObserverForName:kUserDidLogoutNotification object:nil]
      takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        [self refreshDataWith:nil];
    }];
    
    [[[kNotificationCenter rac_addObserverForName:kUserDidLoginNotification object:nil]
      takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        [self refreshDataWith:nil];
    }];
    
    self.Qukan_myTableView.tableHeaderView = self.headerView;
    
//    [self Qukan_requestData];
    
}



- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self refreshDataWith:nil];
    [self Qukan_requestData];
    
    [[QukanIMChatManager sharedInstance] resetChatInfo];
    
    // 获取用户未读消息
//    [self Qukan_queryNoReadMessage];
}

#pragma mark  ---- NetWork
- (void)Qukan_requestData {
    @weakify(self)
//    //    KShowHUD
//    [[[kApiManager QukanMyFollow] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
//        @strongify(self)
//        KHideHUD
//        //处理
//        [self dataSourceDealWith:x];
//    } error:^(NSError * _Nullable error) {
//
//    }];
    
    
    if (![kUserManager isLogin]) {
        self.Qukan_MyFocusOnLabel.text = @"0";
        return;
    }
    self.followCount = 0;
    [[[kApiManager QukanChaXunPKList] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        
        if ([x isKindOfClass:[NSDictionary class]]) {
            
            
            
            NSDictionary *dic = (NSDictionary *)x;
            NSArray *arrayValue = [x allValues];
            
            for (NSArray *arr in arrayValue) {
                self.followCount += arr.count;
            }
        }
        
        [[[kApiManager QukanAttention_Find_attention] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            if ([x isKindOfClass:[NSArray class]]) {
                NSArray *arr1 = x;
                self.followCount += arr1.count;
                
                self.Qukan_MyFocusOnLabel.text =[NSString stringWithFormat:@"%zd",self.followCount];
            }
        } error:^(NSError * _Nullable error) {
        }];
    } error:^(NSError * _Nullable error) {
    }];
}


- (void)Qukan_queryNoReadMessage {
    @weakify(self)
    [[[kApiManager QukanNoReadMessageWithUserId:[NSString stringWithFormat:@"%ld",kUserManager.user.userId]] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        DEBUGLog(@"%@",x);
        NSInteger num_systemNum = [[x objectForKey:@"count"] integerValue];
        
        NSString *unReadNumberStr = [NSString stringWithFormat:@"unReadNumber%zd",[QukanUserManager sharedInstance].user.userId];
        //
        //        NSInteger nuReadNum = [[kUserDefaults objectForKey:unReadNumberStr] integerValue];
        //
        //        // 未读消息数量
        //        if (nuReadNum > 0) {
        //            num_systemNum += nuReadNum;
        //        }
        
        self.str_unReadMessage = [NSString stringWithFormat:@"%@",unReadNumberStr];
        
        self.messLabel.text = [NSString stringWithFormat:@"%zd",num_systemNum];
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        KHideHUD
        self.str_unReadMessage = @"0";
        [self.Qukan_myTableView reloadData];
    }];
}

- (void)dataSourceDealWith:(id)response {
    _Qukan_myDict = (NSDictionary *)response;
//    _Qukan_MyFocusOnLabel.text = [NSString stringWithFormat:@"%ld", kUserManager.followQukanCount];
}


#pragma mark ===================== Layout ====================================

- (UIView *)headerView {
    if (!_headerView) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 124+283+44)];
        view.backgroundColor = [UIColor clearColor];
        _headerView = view;
        
        UIImageView *backIgv = [UIImageView new];
        [view addSubview:backIgv];
        [backIgv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.offset(0);
            make.height.offset(240);
        }];
        backIgv.image = kImageNamed(@"Qukan_mine_bg");

        
        UIButton *headIcon = [UIButton buttonWithType:UIButtonTypeCustom];
        _headIcon = headIcon;
        
        headIcon.layer.cornerRadius = 30;
        headIcon.layer.masksToBounds = YES;
        [headIcon setImage:kImageNamed(@"Qukan_mineHeadIcon") forState:UIControlStateNormal];
        [backIgv addSubview:headIcon];
        [headIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.offset(0);
            make.width.height.offset(60);
            make.top.offset(79);
        }];
        @weakify(self)
        [[headIcon rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [self jumpToUserInfoOrLogin];
        }];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        NSString *title = kUserManager.isLogin ? kUserManager.user.nickname : @"登录/注册";
        [btn setTitle:title forState:UIControlStateNormal];
        UIColor *color = kCommonWhiteColor;
        [btn setTitleColor:color forState:UIControlStateNormal];
        [view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.offset(0);
            make.top.mas_equalTo(headIcon.mas_bottom).offset(10);
            make.height.offset(28);
        }];
        _nickBtn = btn;
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [self jumpToUserInfoOrLogin];
        }];
        
        UIView *segment = [self segmentView];
        [view addSubview:segment];
        
        UIView *viewBot = [[UIView alloc]initWithFrame:CGRectMake(0, 283+44, kScreenWidth, 124)];
        [view addSubview:viewBot];
        viewBot.backgroundColor = kCommonWhiteColor;
        UILabel *helpLab = [UILabel new];
        [viewBot addSubview:helpLab];
        [helpLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.top.offset(18);
            make.height.offset(20);
        }];
        helpLab.text = @"帮助";
        helpLab.font = [UIFont boldSystemFontOfSize:14];
        helpLab.textColor = kCommonTextColor;
        
        UIImageView *icon1 = [UIImageView new];
        [viewBot addSubview:icon1];
        [icon1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(29);
            make.top.mas_equalTo(helpLab.mas_bottom).offset(14);
            make.width.offset(21);
            make.height.offset(25);
        }];
        icon1.image = kImageNamed(@"Qukan_new_lxkf");
        UILabel *label1 = [UILabel new];
        [viewBot addSubview:label1];
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(icon1.mas_centerX).offset(0);
            make.top.mas_equalTo(icon1.mas_bottom).offset(5);
            make.height.offset(17);
        }];
        label1.text = @"联系客服";
        label1.textColor = kCommonTextColor;
        label1.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
        label1.textAlignment = NSTextAlignmentCenter;
        
        UIButton *lxkfBtn = [UIButton new];
        [viewBot addSubview:lxkfBtn];
        [lxkfBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(label1.mas_left).offset(0);
            make.right.mas_equalTo(label1.mas_right).offset(0);
            make.bottom.mas_equalTo(label1.mas_bottom).offset(0);
            make.top.mas_equalTo(icon1.mas_top).offset(0);
        }];
        [lxkfBtn addTarget:self action:@selector(QukanLxkfClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *icon2 = [UIImageView new];
        [viewBot addSubview:icon2];
        [icon2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(113);
            make.top.mas_equalTo(helpLab.mas_bottom).offset(14);
            make.width.offset(25);
            make.height.offset(25);
        }];
        icon2.image = kImageNamed(@"Qukan_new_sssz");
        UILabel *label2 = [UILabel new];
        [viewBot addSubview:label2];
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(icon2.mas_centerX).offset(0);
            make.top.mas_equalTo(icon2.mas_bottom).offset(5);
            make.height.offset(17);
        }];
        label2.text = @"赛事设置";
        label2.textColor = kCommonTextColor;
        label2.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
        label2.textAlignment = NSTextAlignmentCenter;
        UIButton *ssszBtn = [UIButton new];
        [viewBot addSubview:ssszBtn];
        [ssszBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(label2.mas_left).offset(0);
            make.right.mas_equalTo(label2.mas_right).offset(0);
            make.bottom.mas_equalTo(label2.mas_bottom).offset(0);
            make.top.mas_equalTo(icon2.mas_top).offset(0);
        }];
        [ssszBtn addTarget:self action:@selector(QukanMatchSetClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _headerView;
}
- (void)QukanLxkfClick {
    kGuardLogin
   QukanChatViewController *vc = [[QukanChatViewController alloc] initWithUserId:CustomerServiceID headUrl:@""];
    vc.hidesBottomBarWhenPushed = 1;
    [self.navigationController pushViewController:vc animated:1];
}
- (void)QukanMatchSetClick {
    kGuardLogin
    QukanRootSetupViewController *vc = QukanRootSetupViewController.new;
    vc.hidesBottomBarWhenPushed = YES;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:NULL];

}
- (UIView *)segmentView {
    CGFloat width = kScreenWidth-30;
    CGFloat itemWidth = width/2.0;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15, 193, width, 124)];
    view.backgroundColor = [UIColor whiteColor];
    
    NSArray *titles = @[@"赛事关注",@"消息通知"];
    NSArray *subtitles = @[@"",@""];
    for (int i = 0; i < 2; i++) {
        UIView *itemView = [self itemViewWithSize:CGSizeMake(itemWidth, 124) title:titles[i] subTitle:subtitles[i] tag:200+i];
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemViewTap:)];
        [itemView addGestureRecognizer:ges];
        itemView.left += itemWidth*i;
        itemView.top = 0;
        [view addSubview:itemView];
    }
    
    return view;
}

- (UIView *)itemViewWithSize:(CGSize)size
                       title:(NSString *)title
                    subTitle:(NSString *)subTitle
                         tag:(NSInteger)tag {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    view.backgroundColor = [UIColor clearColor];
    view.tag = tag;
    
    UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 41, size.width, 28)];
    lab1.text = subTitle;
    lab1.textAlignment = NSTextAlignmentCenter;
    lab1.textColor = kCommonBlackColor;
    lab1.font = [UIFont boldSystemFontOfSize:20];
    lab1.tag = 100 + tag;
    [view addSubview:lab1];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, lab1.bottom+5, size.width, 17)];
    lab.text = title;
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = kCommonBlackColor;
    lab.font = kFont12;
    [view addSubview:lab];
    
    if (tag == 200) {
        _Qukan_MyFocusOnLabel = lab1;
    } else if (tag == 201) {
        _messLabel = lab1;
    }
    
    return view;
}

#pragma mark ===================== 手势 ==================================

- (void)itemViewTap:(UITapGestureRecognizer *)gesture {
    if (gesture.view.tag == 200) { // 比赛
        kGuardLogin
        
        QukanFollowMainVC *vc = [QukanFollowMainVC new];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else { // 消息通知
        kGuardLogin
        QukanSystemMessageViewController *vc = [[QukanSystemMessageViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark ===================== Private Methods =========================

- (void)refreshDataWith:(NSDictionary *)dic {
    [self.Qukan_dataArray removeAllObjects];
    
    BOOL isLogin = kUserManager.isLogin;
    NSMutableArray *section1 = [NSMutableArray array];
    NSDictionary *dict4 = @{@"ImageName": isLogin ? @"Qukan_new_yjfk" : @"Qukan_new_yjfk",@"Content":@"意见反馈"};
    NSDictionary *dict6 = @{@"ImageName": isLogin ? @"Qukan_new_ysxy" : @"Qukan_new_ysxy",@"Content":@"隐私协议"};
    NSDictionary *dict5 = @{@"ImageName": isLogin ? @"Qukan_new_gywm" : @"Qukan_new_gywm",@"Content":@"关于我们"};
    NSDictionary *dict7 = @{@"ImageName": isLogin ? @"Qukan_new_sz" : @"Qukan_new_sz",@"Content":@"设置"};
    [section1 addObjectsFromArray:@[dict4,dict6,dict5,dict7]];
    
    NSMutableArray *section2 = [NSMutableArray array];
    NSDictionary *dict9 = @{@"ImageName": isLogin ? @"Qukan_new_sssz" : @"Qukan_new_sssz",@"Content":@"赛事设置"};
    NSDictionary *dict8 = @{@"ImageName": isLogin ? @"Qukan_new_lxkf" : @"Qukan_new_lxkf",@"Content":@"联系客服"};
    [section2 addObjectsFromArray:@[dict8,dict9]];
    
    [self.Qukan_dataArray addObject:section2];
    [self.Qukan_dataArray addObject:section1];
    
    
//    NSString *s1 = dic ? [dic stringValueForKey:@"userAttentCount" default:@"0"] : @"0";
//    if (isLogin && !dic) {
//        NSArray *followArray = [QukanYBArchiveUtil getObjectsForFlag:@"关注列表"
//                                               withFilePathName:Qukan_Follow_File_Name_Key];
//        s1 = [NSString stringWithFormat:@"%ld", followArray.count];
//    }
//    UILabel *lab = [self.view viewWithTag:300];
//    lab.text = s1;
    
    NSString *s2 = dic ? [dic stringValueForKey:@"topicAttentCount" default:0] : [NSString stringWithFormat:@"%ld", kUserManager.followQukanCount];
    UILabel *lab1 = [self.view viewWithTag:301];
    lab1.text = s2;
    
    NSString *title = isLogin ? (kUserManager.user.nickname.length ? kUserManager.user.nickname : @"外星人") : @"登录/注册";
    [_nickBtn setTitle:title forState:UIControlStateNormal];
    UIColor *color = kCommonWhiteColor;
    [_nickBtn setTitleColor:color forState:UIControlStateNormal];
    NSString *headUrl = kUserManager.user.avatorId.length ? kUserManager.user.avatorId : @"";
    [_headIcon sd_setImageWithURL:[NSURL URLWithString:headUrl] forState:UIControlStateNormal placeholderImage:kImageNamed(@"Qukan_user_DefaultAvatar")];
    
    [self.Qukan_myTableView reloadData];
}

#pragma mark ===================== Actions ============================

- (void)jumpToUserInfoOrLogin {
    kGuardLogin
    
    QukanInfoViewController *vc = [[QukanInfoViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.Qukan_dataArray.count ? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.Qukan_dataArray[1] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *v = [UIView new];
    v.backgroundColor = [UIColor clearColor];
    return v;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QukanNewMeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QukanNewMeCell"];
    NSDictionary *dict = self.Qukan_dataArray[1][indexPath.row];
    cell.contentLabel.text = dict[@"Content"];
    cell.iconImagView.image = kImageNamed(dict[@"ImageName"]);
    [cell setArrow];
    if ([dict[@"Content"] isEqualToString:@"联系客服"]) {
        if (self.str_unReadMessage.integerValue > 0) {
            cell.lab_unReadNum.hidden = NO;
            cell.view_redPoint.hidden = NO;
            
            cell.lab_unReadNum.text = [NSString stringWithFormat:@"%@条未读消息",self.str_unReadMessage];
        }else {
            cell.lab_unReadNum.hidden = YES;
            cell.view_redPoint.hidden = YES;
        }
    }else {
        cell.lab_unReadNum.hidden = YES;
        cell.view_redPoint.hidden = YES;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *dict = self.Qukan_dataArray[1][indexPath.row];
    NSString *menuTitle = dict[@"Content"];
    BOOL isLogin = kUserManager.isLogin;
    if (!isLogin && ![menuTitle isEqualToString:@"我的收藏"] && ![menuTitle isEqualToString:@"意见反馈"] && ![menuTitle isEqualToString:@"关于我们"] && ![menuTitle isEqualToString:@"清除缓存"] && ![menuTitle isEqualToString:@"隐私协议"] && ![menuTitle isEqualToString:@"赛事设置"] && ![menuTitle isEqualToString:@"赛事关注"]) {
        kGuardLogin
        return;
    }
    
    UIViewController *vc = nil;
    if ([menuTitle isEqualToString:@"清除缓存"]) {
        [self deleteCache]; return;
    }else if ([menuTitle isEqualToString:@"个人资料"]) {
        vc =[[QukanInfoViewController alloc] init];
    }else if ([menuTitle isEqualToString:@"隐私协议"]) {
        NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
        QukanWebViewController *webVc = [[QukanWebViewController alloc] init];
        webVc.navigationItem.title = [NSString stringWithFormat:@"%@隐私协议", infoDict[@"CFBundleDisplayName"]];
        webVc.Qukan_requestUrl = Qukan_Privacy_Url;
        vc = webVc;
    }else if ([menuTitle isEqualToString:@"意见反馈"]) {
        kGuardLogin
        vc = [[QukanFeedbackViewController alloc] init];
    } else if ([menuTitle isEqualToString:@"关于我们"]) {
        vc = [[QukanAboutViewController alloc] init];
    } else if ([menuTitle isEqualToString:@"赛事设置"]) {
        vc = [[QukanRootSetupViewController alloc] init];
    } else if ([menuTitle isEqualToString:@"设置"]) {
        vc = [[QukanSet1VC  alloc] init];
    }else if ([menuTitle isEqualToString:@"联系客服"]) {
        vc = [[QukanChatViewController alloc] initWithUserId:CustomerServiceID headUrl:@""];
    }
    
    vc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

- (void)deleteCache {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"你确定要清除缓存吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消"
                                                      style:UIAlertActionStyleCancel
                                                    handler:^(UIAlertAction *action) {}];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确认"
                                                      style:UIAlertActionStyleDestructive
                                                    handler:^(UIAlertAction *action) {
                                                        if (@available(iOS 9.0, *)) {
                                                            NSSet*websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
                                                            NSDate*dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
                                                            [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes
                                                                                                       modifiedSince:dateFrom
                                                                                                   completionHandler:^{
                                                                                                   }];
                                                        } else {
                                                            NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES)objectAtIndex:0];
                                                            NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
                                                            NSError*errors;
                                                            [[NSFileManager defaultManager]removeItemAtPath:cookiesFolderPath
                                                                                                      error:&errors];
                                                        }
                                                        [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
                                                        [[SDImageCache sharedImageCache] clearMemory];
                                                        [SVProgressHUD showSuccessWithStatus:@"缓存清除成功"];
                                                    }];
    [alertController addAction:action1];
    [alertController addAction:action2];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alertController animated:YES completion:nil];
    });
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    // 圆角弧度半径
//    CGFloat cornerRadius = 6.f;
//    // 设置cell的背景色为透明，如果不设置这个的话，则原来的背景色不会被覆盖
//    cell.backgroundColor = UIColor.clearColor;
//
//    // 创建一个shapeLayer
//    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
//    CAShapeLayer *backgroundLayer = [[CAShapeLayer alloc] init]; //显示选中
//    // 创建一个可变的图像Path句柄，该路径用于保存绘图信息
//    CGMutablePathRef pathRef = CGPathCreateMutable();
//    // 获取cell的size
//    // 第一个参数,是整个 cell 的 bounds, 第二个参数是距左右两端的距离,第三个参数是距上下两端的距离
//    CGRect bounds = CGRectInset(cell.bounds, 16, 0);
//
//    // CGRectGetMinY：返回对象顶点坐标
//    // CGRectGetMaxY：返回对象底点坐标
//    // CGRectGetMinX：返回对象左边缘坐标
//    // CGRectGetMaxX：返回对象右边缘坐标
//    // CGRectGetMidX: 返回对象中心点的X坐标
//    // CGRectGetMidY: 返回对象中心点的Y坐标
//
//    // 这里要判断分组列表中的第一行，每组section的第一行，每组section的中间行
//
//    // CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
//    if (indexPath.row == 0) {
//        // 初始起点为cell的左下角坐标
//        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
//        // 起始坐标为左下角，设为p，（CGRectGetMinX(bounds), CGRectGetMinY(bounds)）为左上角的点，设为p1(x1,y1)，(CGRectGetMidX(bounds), CGRectGetMinY(bounds))为顶部中点的点，设为p2(x2,y2)。然后连接p1和p2为一条直线l1，连接初始点p到p1成一条直线l，则在两条直线相交处绘制弧度为r的圆角。
//        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
//        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
//        // 终点坐标为右下角坐标点，把绘图信息都放到路径中去,根据这些路径就构成了一块区域了
//        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
//        CGPathCloseSubpath(pathRef);
//
//    } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
//        // 初始起点为cell的左上角坐标
//        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
//        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
//        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
//        // 添加一条直线，终点坐标为右下角坐标点并放到路径中去
//        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
//    } else {
//        // 添加cell的rectangle信息到path中（不包括圆角）
//        //        layer.strokeColor = HEXColor(0xEEEEEE).CGColor;
//        CGPathAddRect(pathRef, nil, bounds);
//    }
//    // 把已经绘制好的可变图像路径赋值给图层，然后图层根据这图像path进行图像渲染render
//    layer.path = pathRef;
//    backgroundLayer.path = pathRef;
//    // 注意：但凡通过Quartz2D中带有creat/copy/retain方法创建出来的值都必须要释放
//    CFRelease(pathRef);
//    // 按照shape layer的path填充颜色，类似于渲染render
//    //     layer.fillColor = [UIColor colorWithWhite:1.f alpha:0.8f].CGColor;
//    layer.fillColor = [UIColor whiteColor].CGColor;
//
//
//    // view大小与cell一致
//    UIView *roundView = [[UIView alloc] initWithFrame:bounds];
//    // 添加自定义圆角后的图层到roundView中
//    [roundView.layer insertSublayer:layer atIndex:0];
//    roundView.backgroundColor = UIColor.clearColor;
//    // cell的背景view
//    cell.backgroundView = roundView;
//
//    // 以上方法存在缺陷当点击cell时还是出现cell方形效果，因此还需要添加以下方法
//    // 如果你 cell 已经取消选中状态的话,那以下方法是不需要的.
//    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:bounds];
//    backgroundLayer.fillColor = HEXColor(0xF0F2F5).CGColor;
//    [selectedBackgroundView.layer insertSublayer:backgroundLayer atIndex:0];
//    selectedBackgroundView.backgroundColor = UIColor.clearColor;
//    cell.selectedBackgroundView = selectedBackgroundView;
//}

#pragma mark ===================== Getters =================================
- (UITableView *)Qukan_myTableView {
    if (!_Qukan_myTableView) {
        _Qukan_myTableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                          style:UITableViewStylePlain];
        _Qukan_myTableView.backgroundColor = HEXColor(0xf7f7f7);
//        _Qukan_myTableView.bounces = NO;
        _Qukan_myTableView.contentInset = UIEdgeInsetsMake(-kTopBarHeight, 0, 0, 0);
        _Qukan_myTableView.delegate = self;
        _Qukan_myTableView.dataSource = self;
        [self.view addSubview:_Qukan_myTableView];
        _Qukan_myTableView.showsVerticalScrollIndicator = NO;
        _Qukan_myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _Qukan_myTableView.tableFooterView = [UIView new];
        
        [_Qukan_myTableView registerNib:[UINib nibWithNibName:@"QukanNewMeCell" bundle:nil] forCellReuseIdentifier:@"QukanNewMeCell"];
        [_Qukan_myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _Qukan_myTableView;
}

- (NSMutableArray *)Qukan_dataArray {
    
    if (!_Qukan_dataArray) {
        
        _Qukan_dataArray = NSMutableArray.array;
    }
    
    return _Qukan_dataArray;
}

@end
