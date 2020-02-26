// 项目tabbar
#import "QukanTarBarViewController.h"
// hbd 导航栏管理器
#import <HBDNavigationBar/HBDNavigationController.h>
// app代理
#import "QukanAppDelegate.h"
// 网络加载失败视图
// 聊天工具
// 模块数据模型
#import "QukanXuanModel.h"
// 缓存数据
// 获取域名工具
#import "QukanGetHostTool.h"
// 错误提示的view
#import "QukanErrorCommentView.h"
// 代理扩展  用于处理通知事件
#import "QukanAppDelegate+Push.h"
// 发送请求
#import "QukanApiManager+Competition.h"

#pragma mark ===================== 控制器 ==================================
// 比赛主视图
#import "QukanMatchMainController.h"
// 新闻vc
#import "QukanNewsViewController.h"
// 个人中心
#import "QukanNewMeViewController.h"
#import "QukanPersonCenterViewController.h"
// 话题vc
//#import "QukanBoilingPointTableView1Controller.h"
// 任务vc
#import "QukanDailyVC.h"
// 沸点vc
//#import "QukanBoilingPointVC.h"

//聊天列表
#import "QukanChatListViewController.h"

#import <NSObject+RACKVOWrapper.h>
// 会话
//#import "QukanSessionListVC.h"
// 球友
//#import "QukanBallFriendsViewController.h"
// 球队
//#import "QukanBallTeamVC.h"




#import "QukanDataMainViewController.h"

@interface QukanTarBarViewController ()<UITabBarControllerDelegate, QukanCustomTabbarDelegate>

// 登录失效等状态提示
@property(nonatomic, strong) QukanErrorCommentView   * view_errorTip;

@end

@implementation QukanTarBarViewController


#pragma mark ===================== 生命周期 ==================================
- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    [UITabBar appearance].translucent = NO;
    
    NSString *str = Qukan_BaseURL;
    if (str.length == 0) {
        [kUserDefaults setObject:@"http://api2.jinribifenjiekou.com" forKey:Qukan_locationHostUrl];
    }
    
    kAppManager.appstoreUpdate = ![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"whatsapp://"]] && ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]] || [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]);
#if DEBUG
    kAppManager.appstoreUpdate = 1;
#endif
    [self getHostIfDontHave];
    
    // 给他个登录失效通知
    @weakify(self);
    
    [self.tabBar rac_observeKeyPath:@"frame" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld observer:nil block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
        @strongify(self);
        NSLog(@"%@",change[@"old"]);
        
        CGRect rectNew = [change[@"new"] CGRectValue];
        CGRect rectold = [change[@"old"] CGRectValue];
        
        if (rectNew.size.height != rectold.size.height) {
            if (rectNew.size.height > rectold.size.height) {
                self.tabBar.frame = rectNew;
            }else {
                self.tabBar.frame = rectold;
            }
        }
    }];

    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:kUserLoginUnvalidNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        // 未登录状态的处理方法
        [self userLoginUnValidWithRsp:(NSDictionary *)x.object];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"内存超出负载");
}

// 控制器释放  可是好像tabbar 不可能释放。。。。
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark ===================== network ==================================

- (void)getHostIfDontHave{
    
    if (!kAppManager.appstoreUpdate) {
        [self initControllers];
    }
    
    @weakify(self);
    if([[QukanGetHostTool sharedQukanGetHostTool] hasValidHost]) {
        [self buildView];
    }else {
        // 本地根本没有域名  直接请求域名
        KShowHUD
        [[QukanGetHostTool sharedQukanGetHostTool] getValideApiWithCompletBlock:^(NSString * _Nonnull validHost) {
            @strongify(self);
            KHideHUD
            dispatch_async(dispatch_get_main_queue(), ^{
                if (validHost) {  //如果获取到了有效的域名
                    [QukanGetHostTool sharedQukanGetHostTool].isQueryData = NO;
                    [self buildView];
                }else {  // 若未能获取到有效域名  直接显示请求失败界面、、
                    [QukanGetHostTool sharedQukanGetHostTool].isQueryData = NO;
                    
                    if (kAppManager.appstoreUpdate) {
                        [QukanFailureView Qukan_showWithView:self.view Y:0 top:-kSafeAreaBottomHeight block:^{
                            [QukanFailureView Qukan_hideWithView:self.view];
                            [self getHostIfDontHave];
                        }];
                        
                        if (self.view_errorTip.superview) {
                            [self.view bringSubviewToFront:self.view_errorTip];
                        }
                    }
                }
            });
        }];
    }
}

- (void)buildView {
    if (kAppManager.appstoreUpdate) {
        [kAdManager setup];
    }
    
    @weakify(self)
    KShowHUD
    [[[kApiManager QukanXuan] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSDictionary *  _Nullable x) {
        @strongify(self)
        KHideHUD
        NSMutableArray *xuans = [NSMutableArray new];
        if ([x isKindOfClass:[NSArray class]] && x.count) {
            for (NSDictionary *dic in x) {
                QukanXuanModel *m = [QukanXuanModel modelWithDictionary:dic];
                [xuans addObject:m];
            }
            
            //缓存图片或者更新缓存图片
            [kCacheManager QukancacheXuanDataWithDatas:xuans];
        } else if ([x isKindOfClass:[NSArray class]]) {
            [kCacheManager QukancacheXuanDataWithDatas:xuans];
        }

        int a = [QukanTool Qukan_xuan:kQukan7];
#if DEBUG
        a = 1;
#endif
        if (a == 1) {
            [self getStStatus];
        }else {
            [self initControllers];
        }
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        KHideHUD
        if (kAppManager.appstoreUpdate) {
            [QukanFailureView Qukan_showWithView:self.view Y:0 top:-kSafeAreaBottomHeight block:^{
                [QukanFailureView Qukan_hideWithView:self.view];
                [self getHostIfDontHave];
            }];
            
            if (self.view_errorTip.superview) {
                [self.view bringSubviewToFront:self.view_errorTip];
            }
        }
    }];
}
- (void)getStStatus {
    @weakify(self)
    KShowHUD
    [[[kApiManager QukanStStatus] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        KHideHUD
        QukanPersonModel *model = [QukanPersonModel modelWithJSON:x];
        [kCacheManager QukancacheStStatus:model];  
        dispatch_async(dispatch_get_main_queue(), ^{
            if (kAppManager.appstoreUpdate) {
                [self initControllers];
            }
        });
    } error:^(NSError * _Nullable error) {
        //@strongify(self)
        KHideHUD
        if (kAppManager.appstoreUpdate) {
            [QukanFailureView Qukan_showWithView:self.view Y:0 top:-kSafeAreaBottomHeight block:^{
                [QukanFailureView Qukan_hideWithView:self.view];
                [self getStStatus];
            }];
        }
    }];
}

#pragma mark ===================== 设置控制器 ==================================

- (void)initControllers {
  
    // 初始化默认UI
    [[UIManager sharedInstance] setupUI];
    [[AppManager sharedInstance] appSetup];
    
    int b = [QukanTool Qukan_xuan:kQukan4];
    int c = [QukanTool Qukan_xuan:kQukan7];
//    b = c = 0;
    
    NSMutableArray *arr_title = [NSMutableArray new];
    NSMutableArray *arr_image = [NSMutableArray new];
    NSMutableArray *arr_image2 = [NSMutableArray new];
    NSMutableArray *arr_childVc = [NSMutableArray new];
    
//    QukanBallFriendsViewController *bfVC = [[QukanBallFriendsViewController alloc] init];
//    HBDNavigationController *bfVCNav = [[HBDNavigationController alloc] initWithRootViewController:bfVC];
//    [arr_title addObject:@"球友"];
//    [arr_image addObject:@"Qukan_match_none"];
//    [arr_image2 addObject:@"Qukan_match"];
//    [arr_childVc addObject:bfVCNav];
    
//    QukanSessionListVC *vc0 = [[QukanSessionListVC alloc] init];
//    HBDNavigationController *nav0 = [[HBDNavigationController alloc] initWithRootViewController:vc0];
//    [arr_title addObject:@"会话"];
//    [arr_image addObject:@"Qukan_match_none"];
//    [arr_image2 addObject:@"Qukan_match"];
//    [arr_childVc addObject:nav0];
    
    /**第1个item*/
    QukanMatchMainController *vc1 = [[QukanMatchMainController alloc] init];
    HBDNavigationController *nav1 = [[HBDNavigationController alloc] initWithRootViewController:vc1];
    [arr_title addObject:@"比赛"];
    [arr_image addObject:@"tab_sy_nor"];
    [arr_image2 addObject:@"tab_sy_sel"];
    [arr_childVc addObject:nav1];
    
    /**第2个item*/
    QukanNewsViewController *vc2 = [[QukanNewsViewController alloc] init];
    HBDNavigationController *nav2 = [[HBDNavigationController alloc] initWithRootViewController:vc2];
    [arr_title addObject:@"资讯"];
    [arr_image addObject:@"tab_news_nor"];
    [arr_image2 addObject:@"tab_news_sel"];
    [arr_childVc addObject:nav2];
    
    QukanChatListViewController *vcData = [[QukanChatListViewController alloc] init];
    HBDNavigationController *navData = [[HBDNavigationController alloc] initWithRootViewController:vcData];
    [arr_title addObject:@"侃球"];
    [arr_image addObject:@"tab_data_nor"];
    [arr_image2 addObject:@"tab_data_sel"];
    [arr_childVc addObject:navData];
    
//    QukanDataMainViewController *vcData = [[QukanDataMainViewController alloc] init];
//    HBDNavigationController *navData = [[HBDNavigationController alloc] initWithRootViewController:vcData];
//    [arr_title addObject:@"数据"];
//    [arr_image addObject:@"tab_data_nor"];
//    [arr_image2 addObject:@"tab_data_sel"];
//    [arr_childVc addObject:navData];
    
    /**第3个item*/
    if (b == 0 || !kAppManager.appstoreUpdate) {
//        QukanBoilingPointTableView1Controller *vc4 = [[QukanBoilingPointTableView1Controller alloc] init];
//        HBDNavigationController *nav4 = [[HBDNavigationController alloc] initWithRootViewController:vc4];
//        [arr_title addObject:@"话题"];
//        [arr_image addObject:@"Qukan_topic_none"];
//        [arr_image2 addObject:@"Qukan_topic"];
//        [arr_childVc addObject:nav4];

        
//        QukanBallTeamVC *vc4 = [[QukanBallTeamVC alloc] init];
//        HBDNavigationController *nav4 = [[HBDNavigationController alloc] initWithRootViewController:vc4];
//        [arr_title addObject:@"话题"];
//        [arr_image addObject:@"Qukan_topic_none"];
//        [arr_image2 addObject:@"Qukan_topic"];
//        [arr_childVc addObject:nav4];
        
    }else {
        QukanDailyVC *vc7 = [[QukanDailyVC alloc] init];
        HBDNavigationController *nav7 = [[HBDNavigationController alloc] initWithRootViewController:vc7];
        [arr_title addObject:[NSString stringWithFormat:@"%@",[kCacheManager QukangetStStatus].caseNum]];
        [arr_image addObject:@"tab_ren_nor"];
        [arr_image2 addObject:@"tab_ren_sel"];
        [arr_childVc addObject:nav7];
    }
    
    /**第4个item*/
    if (b == 0 || !kAppManager.appstoreUpdate) {
//        QukanBoilingPointVC *vc5 = [[QukanBoilingPointVC alloc] init];
//        HBDNavigationController *nav5 = [[HBDNavigationController alloc] initWithRootViewController:vc5];
//        [arr_title addObject:@"沸点"];
//        [arr_image addObject:@"Qukan_data_none"];
//        [arr_image2 addObject:@"Qukan_data"];
//        [arr_childVc addObject:nav5];
    }
        
    /**第5个item*/
    if (c == 0 || !kAppManager.appstoreUpdate) {
        QukanNewMeViewController *vc6 = [[QukanNewMeViewController alloc] init];
        HBDNavigationController *nav6 = [[HBDNavigationController alloc] initWithRootViewController:vc6];
        [arr_title addObject:@"我的"];
        [arr_image addObject:@"tab_me_nor"];
        [arr_image2 addObject:@"tab_me_sel"];
        [arr_childVc addObject:nav6];
    } else {
        QukanPersonCenterViewController *vc3 = [[QukanPersonCenterViewController alloc] init];
        HBDNavigationController *nav3 = [[HBDNavigationController alloc] initWithRootViewController:vc3];
        [arr_title addObject:@"我的"];
        [arr_image addObject:@"tab_me_nor"];
        [arr_image2 addObject:@"tab_me_sel"];
        [arr_childVc addObject:nav3];
    }
    
    self.viewControllers = arr_childVc;
    
    NSMutableArray<QukanCustomTabItemModel *> *itemModelArr = [NSMutableArray new];
    for (int i=0; i<arr_childVc.count; i++) {
//        UIViewController *vc = self.viewControllers[i];
//        [self Qukan_addChildViewControler:vc title:arr_title[i] imageNamed:arr_image[i] selectedNamed:arr_image2[i]];
        
        QukanCustomTabItemModel *model = [QukanCustomTabItemModel new];
        model.selectImgName = arr_image2[i];
        model.mormalImgName = arr_image[i];
        model.itemTitle = arr_title[i];
        model.normalColor = kTextGrayColor;
        model.selectColor = kThemeColor;
        [itemModelArr addObject:model];
    }
    
    self.customTabbar = [[QukanCustomTabbar alloc] initWithFrame:self.tabBar.bounds];
    self.customTabbar.tabBarItems = itemModelArr;
    self.customTabbar.delegate = self;
    [self.tabBar addSubview:self.customTabbar];
    
//    self.tabBar.translucent = NO;
//    [self.view setNeedsLayout];
    
    // 如果根据推送点击进入  则e根据推送内容跳转界面
    [self handlePushMessage]; 
}

// 如果根据推送点击进入  则e根据推送内容跳转界面
- (void)handlePushMessage {
    NSDictionary *dictionary = [kUserDefaults objectForKey:@"kRemoteNotificationDataKey"];
    NSDictionary *localDict = [kUserDefaults objectForKey:@"kLocalNotificationDataKey"];
    if (dictionary) {
        QukanAppDelegate *delegate = (QukanAppDelegate *)kAppDelegate;
        [delegate QukanJumpNotificationWith:dictionary];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [kUserDefaults removeObjectForKey:@"kRemoteNotificationDataKey"];
        });
        
    }
    if (localDict) {
        QukanAppDelegate *delegate = (QukanAppDelegate *)kAppDelegate;
        [delegate QukanLocalNotificationJump:localDict[@"matchType"] matchId:localDict[@"matchId"]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [kUserDefaults removeObjectForKey:@"kLocalNotificationDataKey"];
        });
        
    }
}



//-(void)Qukan_addChildViewControler:(UIViewController *)controller
//                             title:(NSString *)title
//                        imageNamed:(NSString *)imageNamed
//                     selectedNamed:(NSString *)selectedNamed {
//    controller.title = title;
//    controller.tabBarItem.image = [[[UIImage imageNamed:imageNamed] imageWithColor: HEXColor(0xBFB5BF)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//
//
//    controller.tabBarItem.selectedImage = [[UIImage imageNamed:selectedNamed]
//                                           imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    [controller.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:HEXColor(0x777777),
//                                                    NSFontAttributeName:[UIFont systemFontOfSize:11]}
//                                         forState:UIControlStateNormal];
//    [controller.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:kCommonDarkGrayColor,
//                                                    NSFontAttributeName:[UIFont systemFontOfSize:11]}
//                                         forState:UIControlStateSelected];
//    [controller.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -2)];
//   if (@available(iOS 13, *)) {
//       self.tabBar.tintColor = kCommonDarkGrayColor;
//   }
    
    
   
    
//}


// 用户登录失效处理
- (void)userLoginUnValidWithRsp:(NSDictionary *)rsp {
    //701    token过期
    //700    token验证失败
    //702    签名验证失败
    //703    您的账号在其它地方登录
    //800    你的设备违反操作，已经被拉黑
    //801    您所在的暂不支持该APP
    //810    你的账号违反操作，已经被拉黑
    
    // 获取到错误码  这里的错误码只能为 700 701 702 703 800 801
    int code = [rsp intValueForKey:kJsonCodeField default:-1];
    // TODO: 登录失效处理
    if (code == 701 || code == 702 || code == 700) {
        if (code != 700) {
            NSString *message = [rsp objectForKey:kJsonMsgField];
            message = message == nil ? @"空数据" : message;
            [SVProgressHUD showErrorWithStatus:message];
        }
        [kUserManager logOut];
        return;
    }
    
    if (code == 703) { // 您的账号在其它地方登录
        if (self.view_errorTip.superview) {  // 如果错误界面有父视图  直接ruturn
            return;
        }
        
        [self.view addSubview:self.view_errorTip];
        [self.view_errorTip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        [self.view_errorTip fullViewWithTitle:[rsp objectForKey:kJsonMsgField] BtnTitle:@"" BtnClickBlock:^{
            NSLog(@"anniu dianji");
        } showClose:YES];
        
        [kUserManager logOut];
        [kNotificationCenter postNotificationName:kUserDidLogoutNotification object:nil];
        
        if (self.viewControllers.count) {
            self.selectedIndex = self.viewControllers.count - 1;
        }
        
        return;
    }
    
    if (code == 800 || code == 801 || code == 810) {  // 用户设备被拉黑了
        if (self.view_errorTip.superview) {  // 如果错误界面有父视图  直接ruturn
            return;
        }
        
        [self.view addSubview:self.view_errorTip];
        [self.view_errorTip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        NSString *ten = [rsp objectForKey:kJsonMsgField];
        NSRange range = [ten rangeOfString:@"QQ"];
        NSString *message = [ten substringToIndex:range.location];
        NSString *qq = [ten substringWithRange:NSMakeRange(range.location, ten.length - range.location)];
        
        [self.view_errorTip fullViewWithTitle:message BtnTitle:qq BtnClickBlock:^{
            NSLog(@"anniu dianji");
        } showClose:YES];
        
        [kUserManager logOut];
        [kNotificationCenter postNotificationName:kUserDidLogoutNotification object:nil];
        
        if (self.viewControllers.count) {
            self.selectedIndex = self.viewControllers.count - 1;
        }
        
        return;
    }
    
}

//#pragma mark ===================== UITabBarControllerDelegate ==================================
//// tab切换代理  用于控制播放器暂停播放
//- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
//    for (UINavigationController *nav in self.viewControllers) {
//        QukanNewsViewController *newsVC = (QukanNewsViewController *)nav.viewControllers.firstObject;
//        if ([newsVC isKindOfClass:[QukanNewsViewController class]]) {
//            [newsVC stopVideoPlayIfneed];
//        }
//    }
//    
//}


#pragma mark ===================== QukanCustomTabbarDelegate ==================================
// 单次选中某个下标
- (void)QukanCustomTabbar:(QukanCustomTabbar *_Nullable)tabbar selectIndex:(NSInteger)index{
    self.selectedIndex = index;
    
    for (UINavigationController *nav in self.viewControllers) {
        QukanNewsViewController *newsVC = (QukanNewsViewController *)nav.viewControllers.firstObject;
        if ([newsVC isKindOfClass:[QukanNewsViewController class]]) {
            [newsVC stopVideoPlayIfneed];
        }
    }
}
// 已经在此下标了 再次选中该下标
- (void)QukanCustomTabbar:(QukanCustomTabbar *_Nullable)tabbar selectIndexAgain:(NSInteger)index{
    NSLog(@"agin %zd ===",index);
    UIViewController *baseViewController = ((UINavigationController *)self.selectedViewController).topViewController;
    if ([baseViewController isKindOfClass:[QukanMatchMainController class]]) {    //是否是比赛
        [(QukanMatchMainController *)baseViewController reloadMainMatchVC];
    }
    if ([baseViewController isKindOfClass:[QukanNewsViewController class]]) {    //是否是新闻
        //3.刷新列表
        [(QukanNewsViewController *)baseViewController refreshCurrentNewsList];
    }
    if ([baseViewController isKindOfClass:[QukanDailyVC class]]) {    //是否是任务
        //3.刷新列表
//        [(QukanDailyVC *)baseViewController refreshShowList];

    }
    
}
// 双击该下标
- (void)QukanCustomTabbar:(QukanCustomTabbar *_Nullable)tabbar selectIndexDouble:(NSInteger)index{
    NSLog(@"Double %zd ===",index);
     UIViewController *baseViewController = ((UINavigationController *)self.selectedViewController).topViewController;
    if ([baseViewController isKindOfClass:[QukanMatchMainController class]]) {    //是否是比赛
        [(QukanMatchMainController *)baseViewController changeMainMatchVc];
    }
}

#pragma mark ===================== lazy ==================================
// 懒加载登录失效弹出视图
- (QukanErrorCommentView *)view_errorTip
{
    if (!_view_errorTip) {
        _view_errorTip = [QukanErrorCommentView Qukan_initWithXib];
    }
    return _view_errorTip;
}

@end
