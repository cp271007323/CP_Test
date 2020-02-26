//
//  QukanPersonCenterViewController.m
//  Qukan
//
//  Created by Kody on 2019/8/17.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanPersonCenterViewController.h"
#import "QukanNewMeCell.h"
#import "QukanAppDelegate.h"

#import "QukanInfoViewController.h"
#import "QukanFeedbackViewController.h"

#import "QukanFollowMainVC.h"

#import <HBDNavigationBar/UIViewController+HBD.h>
#import "QukanYBArchiveUtil.h"
#import "QukanSettingViewController.h"
#import "QukanApiManager+Mine.h"
#import "QukanApiManager+PersonCenter.h"

#import "QukanMessageViewController.h"
#import "QukanPersonalCenterHeaderView.h"
#import "QukanPersonDetailViewController.h"
#import "QukanBGViewController.h"
#import "QukanShareCenterViewController.h"

#import "QukanBgModel.h"


#import "QukanPersonalCenterNavView.h"

@interface QukanPersonCenterViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView                  *Qukan_myTableView;

@property (nonatomic, strong) NSMutableArray               *Qukan_dataArray;
@property (nonatomic, strong) NSDictionary                 *Qukan_myDict;

@property(nonatomic, strong) QukanPersonalCenterHeaderView *HeaderView;
@property(nonatomic, strong) UIButton                      *nickBtn;
@property(nonatomic, strong) UIButton                      *headIcon;
@property(nonatomic, strong) UILabel                       *Qukan_MyFocusOnLabel;
@property(nonatomic, strong) UILabel                       *messLabel;

@property(nonatomic, strong) UILabel                       *lab_customInfo;

//存放图片的数组
@property(nonatomic, strong) NSMutableArray *images;

//存放title的数组
@property(nonatomic, strong) NSMutableArray *titles;

// 未读消息数量
@property(nonatomic, copy) NSString   * str_unReadMessage;
/**
 用户佩戴的徽章标识
 */
@property(nonatomic, strong) NSString        *badgePDStr;
/**
 徽章列表
 */
@property(nonatomic, strong) NSArray <QukanBgModel *> *datas;

/**虚拟导航栏*/
@property(nonatomic, strong) QukanPersonalCenterNavView   * QukanCunstonNav_view;

/**<#注释#>*/
@property(nonatomic, strong) MASConstraint   * QukanCenterBottom_constraint;

/**tab滑动的背景色*/
@property(nonatomic, strong) UIView   * QukanBlack_view;

@end

@implementation QukanPersonCenterViewController

#pragma mark ===================== Life Cycle ==================================
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.hbd_barHidden = YES;
    self.view.backgroundColor = kCommentBackgroudColor;
    
    self.images = @[].mutableCopy;
    self.titles = @[].mutableCopy;
    
    [self setData];
    [self initUI];
   
    [self addNotification];

    if ([QukanTool Qukan_xuan:kQukan1] == 1) {
        // 获取客服信息
        [self Qukan_getCutInfo];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self refreshDataWith:nil];
    // 刷新导航栏
    [self.QukanCunstonNav_view freshSubView];
    
    [[QukanIMChatManager sharedInstance] resetChatInfo];
    
    // 获取用户未读消息
    [self Qukan_queryNoReadMessage];
    
    [self queryUserInfo];
    [self.HeaderView freshUserHeaderTopView];
    
    if (!kUserManager.isLogin) {
        NSString *str = FormatString(@"首次%@%@", kGetImageType(15),kGetImageType(16));
        [self.HeaderView freshUserHeaderMidViewWithArr:@[@"0",@"0",str]];
        return;
    }
    //获取用户积分信息
    [self Qukan_selectScoreRed];
    //获取用户徽章信息
    [self Qukan_gcUserBadgeSelectBadge];
    
}

#pragma mark ===================== initUI ==================================
- (void)initUI {
    
    self.Qukan_myTableView.tableHeaderView = self.HeaderView;
    
    [self.view addSubview:self.lab_customInfo];
    [self.lab_customInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        self.QukanCenterBottom_constraint = make.bottom.equalTo(self.view).offset(35);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(35));
    }];
    
    [self.view addSubview:self.Qukan_myTableView];
    [self.Qukan_myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.lab_customInfo.mas_top);
    }];
    
    [self.view addSubview:self.QukanCunstonNav_view];
    [self.QukanCunstonNav_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@(kTopBarHeight));
    }];
    
    
    [self.view addSubview:self.QukanBlack_view];
    self.QukanBlack_view.frame = CGRectMake(0, 0, kScreenWidth, 0);
}

#pragma mark ===================== NetWork ==================================
- (void)queryUserInfo {
    @weakify(self)
    [[[kApiManager QukangcuserFindUserById:[NSString stringWithFormat:@"%zd",kUserManager.user.userId]] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        KHideHUD
        //处理
        [self Qukan_loginSuccessSaveWithData:x];
    } error:^(NSError * _Nullable error) {
        
    }];
}

- (void)Qukan_loginSuccessSaveWithData:(NSDictionary *)dict {
    QukanUserModel *model = kUserManager.user;
    model.avatorId = [dict objectForKey:@"avatorId"];
    model.nickname = [dict objectForKey:@"nickname"];
    [kUserManager setUserData:model];
//    [self.HeaderView setUserInfo:model];
}



- (void)Qukan_requestData {
    @weakify(self)
    //    KShowHUD
    [[[kApiManager QukanMyFollow] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        KHideHUD
        //处理
        [self dataSourceDealWith:x];
    } error:^(NSError * _Nullable error) {
        
    }];
}

- (void)Qukan_selectScoreRed {
    @weakify(self)
    [[[kApiManager QukanSelectDate] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if ([x isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = x;
            [self.HeaderView freshUserHeaderMidViewWithArr:@[[NSString stringWithFormat:@"%@",[dic objectForKey:kGetImageType(13)]],[NSString stringWithFormat:@"%@",[dic objectForKey:kGetImageType(12)]],[NSString stringWithFormat:@"%@",[dic objectForKey:@"tpTime"]]]];
        }
    } error:^(NSError * _Nullable error) {
    }];
}

// 获取客服信息
- (void)Qukan_getCutInfo {
    @weakify(self);
    [[[kApiManager QukangcuserData:@"center_cust_qq"] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
       @strongify(self)
        
        [self setCustomInfo:x];
        
    } error:^(NSError * _Nullable error) {
        DEBUGLog(@"获取客服信息错误");
    }];
}

- (void)Qukan_queryNoReadMessage {
    @weakify(self)
    [[[kApiManager QukanNoReadMessageWithUserId:[NSString stringWithFormat:@"%ld",kUserManager.user.userId]] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        DEBUGLog(@"%@",x);
        NSInteger num_systemNum = [[x objectForKey:@"count"] integerValue];
        
        NSString *unReadNumberStr = [NSString stringWithFormat:@"unReadNumber%zd",[QukanUserManager sharedInstance].user.userId];
        
        NSInteger nuReadNum = [[kUserDefaults objectForKey:unReadNumberStr] integerValue];
        
        // 未读消息数量
        if (nuReadNum > 0) {
            num_systemNum += nuReadNum;
        }
        
        self.str_unReadMessage = [NSString stringWithFormat:@"%zd",num_systemNum];
        [self.Qukan_myTableView reloadData];
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        KHideHUD
        self.str_unReadMessage = @"0";
        [self.Qukan_myTableView reloadData];
    }];
}



#pragma mark 获取用户的徽章列表与佩戴的徽章信息
- (void)Qukan_gcUserBadgeSelectBadge {
    @weakify(self)
    [[[kApiManager QukanGcUserHeadImage] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        KHideHUD
        NSDictionary *xDict = NSDictionary.new;
        if ([x isKindOfClass:[NSDictionary class]]) {
            xDict = (NSDictionary *)x;
            if (!xDict.allKeys.count) {self.HeaderView.BadgeBtn.hidden = YES;return;}
        }
        NSArray *xArray = NSArray.new;
        if ([x isKindOfClass:[NSArray class]]) {
            xArray = (NSArray *)x;
            if (!xArray.count) {return;}
        }
        
        if(![x[0][@"badgePd"] isKindOfClass:[NSNull class]]){
            self.badgePDStr = x[0][@"badgePd"];
            self.HeaderView.BadgeBtn.hidden = NO;
        }else{
            self.HeaderView.BadgeBtn.hidden = YES;
        }
        [self Qukan_gcUserBadgeSelectParmList];
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        KHideHUD
    }];
}


#pragma mark - 获取徽章列表
- (void)Qukan_gcUserBadgeSelectParmList {
    @weakify(self)
    [[[kApiManager QukanGcUserSelectParmList] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        DEBUGLog(@"%@",x);
        [self dataSourceWith:x];
        
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        KHideHUD
    }];
}


- (void)dataSourceWith:(id)response {
    NSArray *array = (NSArray *)response;
    if (!array.count) {return;}
    self.datas = [NSArray modelArrayWithClass:[QukanBgModel class] json:array];
    [self setUserHeadBadge];
    
}

#pragma mark 设置头部徽章
-(void)setUserHeadBadge{
   __block UIImage *image;
    NSInteger tag = 0;
    for (QukanBgModel *model in self.datas) {
        if ([model.code isEqualToString:self.badgePDStr]) {
            if ([model.name isEqualToString:@"初出茅庐"]) {
                tag = 63;
            }else if ([model.name isEqualToString:@"疯狂球迷"]){
                tag = 43;
            }else if ([model.name isEqualToString:@"神评达人"]){
                tag = 37;
            }else if ([model.name isEqualToString:@"球场指挥官"]){
                tag = 33;
            }else if ([model.name isEqualToString:[NSString stringWithFormat:@"%@达人",[kCacheManager QukangetStStatus].caseNum]]){
                tag = 83;
            }else if ([model.name isEqualToString:FormatString(@"%@大虾",kStStatus.pageSize)]){
                tag = 23;
            } else {
                tag = 0;
                image = nil;
            }
        }
    }
    [self.HeaderView.BadgeBtn sd_setImageWithURL:[QukanTool Qukan_getImageStr:[NSString stringWithFormat:@"%ld",tag]] forState:UIControlStateNormal];
}


#pragma mark - 设置客服信息
- (void)setCustomInfo:(NSArray *)arr {
    for (NSDictionary *dic in arr) {
        if ([[dic objectForKey:@"val"] isEqualToString:@"center_cust_qq"]) {
            self.lab_customInfo.text = [dic objectForKey:@"content"];
            self.lab_customInfo.hidden = NO;
            
            self.QukanCenterBottom_constraint.offset(0);
        }
    }
}

#pragma mark ===================== privet function ==================================
- (void)setHotChatLink:(NSDictionary *)dic {
    if (![dic isKindOfClass:[NSDictionary class]]) {
        // 数据请求错误
        return;
    }
    if ([dic objectForKey:@"fiery_group"]) {
        NSDictionary *contentDic = [dic objectForKey:@"fiery_group"];
        NSString *url = [[contentDic objectForKey:@"group_url"] objectForKey:@"name"];
         BOOL isExsit = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]];
        if(isExsit) {
             NSLog(@"App %@ installed", url);
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
    }
    
}

- (void)addNotification {
    @weakify(self)
    [[[kNotificationCenter rac_addObserverForName:kUserDidLogoutNotification object:nil]
      takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        [self refreshDataWith:nil];
        [self.QukanCunstonNav_view freshSubView];
    }];
    
    [[[kNotificationCenter rac_addObserverForName:kUserDidLoginNotification object:nil]
      takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        [self refreshDataWith:nil];
        [self.QukanCunstonNav_view freshSubView];
    }];
}



- (void)dataSourceDealWith:(id)response {
//    [self.HeaderView setUserInformationWith:response];
}



#pragma mark ===================== Private Methods =========================

- (void)setData {

//    int k5 = [QukanTool Qukan_xuan:kQukan5];
    int k9 = [QukanTool Qukan_xuan:kQukan9];
    int k8 = [QukanTool Qukan_xuan:kQukan8];
    QukanPersonModel *model = [kCacheManager QukangetStStatus];
    NSString *tagName = FormatString(@"%@%@", model.email, model.pageNum);
    if (k9 == 1) { [self.images addObject:@"user_center_hbjl"];[self.titles addObject:@"火爆交流群"];};
    [self.images addObject:@"user_center_gz"];[self.titles addObject:@"关注赛事"];
    [self.images addObject:@"user_center_hzhan"];[self.titles addObject:@"成就徽章"];
    if (k8 == 1) { [self.images addObject:@"user_center_dh"];[self.titles addObject:tagName];};
    [self.images addObject:@"feadback"];[self.titles addObject:@"意见反馈"];
    [self.images addObject:@"user_center_noti"];[self.titles addObject:@"通知与客服"];
    
    [self.Qukan_myTableView reloadData];
}

- (void)refreshDataWith:(NSDictionary *)dic {
    [self.Qukan_dataArray removeAllObjects];
    
    BOOL isLogin = kUserManager.isLogin;
    NSMutableArray *section1 = [NSMutableArray array];
    NSDictionary *dict3 = @{@"ImageName": isLogin ? @"Qukan_ballFriendShare" : @"Qukan_ballFriendShare",@"Content":@"球友分享"};
    NSDictionary *dict4 = @{@"ImageName": isLogin ? @"Qukan_feedback" : @"Qukan_feedback",@"Content":@"意见反馈"};
    [section1 addObjectsFromArray:@[dict3, dict4]];
    
    NSMutableArray *section2 = [NSMutableArray array];
    NSDictionary *dict9 = @{@"ImageName": isLogin ? @"Qukan_serviceAndNotification" : @"Qukan_serviceAndNotification",@"Content":@"通知与客服"};
    NSDictionary *dict7 = @{@"ImageName": isLogin ? @"Qukan_systemSet" : @"Qukan_systemSet",@"Content":@"系统设置"};
    [section2 addObjectsFromArray:@[dict9, dict7]];
    
    [self.Qukan_dataArray addObjectsFromArray:section1];
    [self.Qukan_dataArray addObjectsFromArray:section2];
    
    NSString *s1 = dic ? [dic stringValueForKey:@"userAttentCount" default:@"0"] : @"0";
    if (isLogin && !dic) {
        NSArray *followArray = [QukanYBArchiveUtil getObjectsForFlag:@"关注列表"
                                               withFilePathName:Qukan_Follow_File_Name_Key];
        s1 = [NSString stringWithFormat:@"%ld", followArray.count];
    }
    UILabel *lab = [self.view viewWithTag:300];
    lab.text = s1;
    
    NSString *s2 = dic ? [dic stringValueForKey:@"topicAttentCount" default:0] : [NSString stringWithFormat:@"%ld", kUserManager.followQukanCount];
    UILabel *lab1 = [self.view viewWithTag:301];
    lab1.text = s2;
    
    NSString *title = isLogin ? (kUserManager.user.nickname.length ? kUserManager.user.nickname : @"外星人") : @"登录/注册";
    [_nickBtn setTitle:title forState:UIControlStateNormal];
    UIColor *color = kUserManager.isLogin ? kCommonBlackColor : kThemeColor;
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

- (void)headerViewTopViewTarget:(NSInteger)tag {
    kGuardLogin
    QukanInfoViewController *vc = [[QukanInfoViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)headerViewMidViewTarget:(NSInteger)tag {
    kGuardLogin
    UIViewController *vc = [[QukanPersonDetailViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)headerViewBottomViewTarget:(NSInteger)tag {
    
//    UIViewController *vc = nil;
//    switch (tag) {
//        case 0:
//            vc = [[QukanFollowMainVC alloc] init];
//            break;
//        case 1:
//            vc = [[QukanDailyShowViewController alloc] init];
//            break;
//        case 2:
//            vc = [[QukanBGViewController alloc] init];
//            break;
//        case 3:
//            vc = [[QukanPersonDetailViewController alloc] init];
//            break;
//        case 4:
////            vc = [[QukanGoodViewController alloc] init];
//            [self jumpToHotChatRoom];
//            break;
//        case 5:
//            vc = [[QukanGoodViewController alloc] init];
//            break;
//        default:
//            break;
//    }
//    [vc setHidesBottomBarWhenPushed:YES];
//    [self.navigationController pushViewController:vc animated:YES];
    
    kGuardLogin
    
    QukanShareCenterViewController *vc = [QukanShareCenterViewController new];
    [vc setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)jumpToHotChatRoom {
    @weakify(self);
    KShowHUD
    [[[kApiManager QukanAppGetConfig] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        
        KHideHUD
        @strongify(self)
        [self setHotChatLink:x];
        
    } error:^(NSError * _Nullable error) {
        DEBUGLog(@"获取客服信息错误");
    }];
}


#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
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
    cell.contentLabel.text = [self.titles objectAtIndex:indexPath.row];
    
    if ([[self.images objectAtIndex:indexPath.row] isEqualToString:@"user_center_hzhan"]) {
        [cell.iconImagView sd_setImageWithURL:[QukanTool Qukan_getImageStr:@"user_center_hzhan"]];
    }else if ([[self.images objectAtIndex:indexPath.row] isEqualToString:@"user_center_dh"])  {
        [cell.iconImagView sd_setImageWithURL:[QukanTool Qukan_getImageStr:@"user_center_dh"]];
    }else {
        cell.iconImagView.image = kImageNamed([self.images objectAtIndex:indexPath.row]);
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if ([[self.titles objectAtIndex:indexPath.row] isEqualToString:@"通知与客服"]) {
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    QukanPersonModel *model = [kCacheManager QukangetStStatus];
    NSString *tagName = FormatString(@"%@%@", model.email, model.pageNum);

    NSString *menuTitle = [self.titles objectAtIndex:indexPath.row];
    BOOL isLogin = kUserManager.isLogin;
    if (!isLogin && ([menuTitle isEqualToString:@"火爆交流群"] || [menuTitle isEqualToString:@"关注赛事"] || [menuTitle isEqualToString:@"成就徽章"] || [menuTitle isEqualToString:tagName] || [menuTitle isEqualToString:@"意见反馈"] || [menuTitle isEqualToString:@"通知与客服"])) {
        kGuardLogin
        return;
    }
    
    UIViewController *vc = nil;
    if ([menuTitle isEqualToString:@"火爆交流群"]) {
        [self jumpToHotChatRoom];
        return;
    }else if ([menuTitle isEqualToString:@"关注赛事"]) {
        vc = QukanFollowMainVC.new;
    }else if ([menuTitle isEqualToString:@"成就徽章"]) {
        vc = QukanBGViewController.new;
    } else if ([menuTitle isEqualToString:tagName]) {
        vc = QukanPersonDetailViewController.new;
    } else if ([menuTitle isEqualToString:@"意见反馈"]) {
        vc = QukanFeedbackViewController.new;
    } else if ([menuTitle isEqualToString:@"通知与客服"]) {
        vc = [[QukanMessageViewController alloc] init];
    }
    
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.y < 0) {
        CGRect frame = self.QukanBlack_view.frame;
        frame.size.height = - scrollView.contentOffset.y;
        self.QukanBlack_view.frame = frame;
    }
    
    if ([scrollView isEqual:self.Qukan_myTableView]) {
        if (scrollView.contentOffset.y > 100) {
            [self.QukanCunstonNav_view showContentView];
        }else {
            [self.QukanCunstonNav_view hideContentView];
        }
    }
}

#pragma mark ===================== Getters =================================

- (QukanPersonalCenterHeaderView *)HeaderView {
    if (!_HeaderView) {
        
        _HeaderView = [[QukanPersonalCenterHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 280 * screenScales  + 30 + 25 +  86 + 10 )];
        
        if ([QukanTool Qukan_xuan:kQukan10] == 0) {
            _HeaderView.frame = CGRectMake(0, 0, kScreenWidth, 280 * screenScales + 25 +  86 + 10 );
        }
        
        @weakify(self)
        self.HeaderView.topViewDidSele = ^(NSInteger tag) {
            @strongify(self)
            [self headerViewTopViewTarget:tag];
        };
        self.HeaderView.bottomViewDidSele = ^(NSInteger tag) {
            @strongify(self)
            [self headerViewBottomViewTarget:tag];
        };
    }
    return _HeaderView;
}

- (UITableView *)Qukan_myTableView {
    if (!_Qukan_myTableView) {
        _Qukan_myTableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                          style:UITableViewStylePlain];
        _Qukan_myTableView.contentInset = UIEdgeInsetsMake(-kTopBarHeight, 0, 0, 0);
        _Qukan_myTableView.delegate = self;
        _Qukan_myTableView.dataSource = self;
        _Qukan_myTableView.showsVerticalScrollIndicator = NO;
        _Qukan_myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _Qukan_myTableView.tableFooterView = [UIView new];
        
        _Qukan_myTableView.backgroundColor = kCommentBackgroudColor;
        
        _Qukan_myTableView.separatorInset = UIEdgeInsetsMake(0,20, 0, 0);
        _Qukan_myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
        _Qukan_myTableView.separatorColor = kCommentBackgroudColor;
        
        [_Qukan_myTableView registerNib:[UINib nibWithNibName:@"QukanNewMeCell" bundle:nil] forCellReuseIdentifier:@"QukanNewMeCell"];
      
    }
    return _Qukan_myTableView;
}

- (NSMutableArray *)Qukan_dataArray {
    if (!_Qukan_dataArray) {
        _Qukan_dataArray = NSMutableArray.array;
    }
    return _Qukan_dataArray;
}

- (UILabel *)lab_customInfo {
    if (!_lab_customInfo) {
        _lab_customInfo = [[UILabel alloc] initWithFrame:CGRectZero];
        
        _lab_customInfo.font = kFont11;
        _lab_customInfo.text = @"";
        _lab_customInfo.textAlignment = NSTextAlignmentCenter;
        _lab_customInfo.textColor = kTextGrayColor;
        
        _lab_customInfo.hidden = YES;
    }
    return _lab_customInfo;
}

- (QukanPersonalCenterNavView *)QukanCunstonNav_view {
    if (!_QukanCunstonNav_view) {
        _QukanCunstonNav_view = [[QukanPersonalCenterNavView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kTopBarHeight)];
        
        @weakify(self);
        [[[_QukanCunstonNav_view rac_signalForSelector:@selector(setBtnClick)] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(RACTuple * _Nullable x) {
            @strongify(self);
            kGuardLogin;
            QukanSettingViewController *vc = [QukanSettingViewController new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }];
        
        [[[_QukanCunstonNav_view rac_signalForSelector:@selector(headerOrNickClickAction)] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(RACTuple * _Nullable x) {
            @strongify(self);
            [self headerViewTopViewTarget:1];
        }];
        
    }
    return _QukanCunstonNav_view;
}

-(UIView *)QukanBlack_view {
    if (!_QukanBlack_view) {
        _QukanBlack_view = [UIView new];
        _QukanBlack_view.backgroundColor = kCommonTextColor;
    }
    return _QukanBlack_view;
}

@end
