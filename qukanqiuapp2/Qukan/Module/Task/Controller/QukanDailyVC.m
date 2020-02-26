//
//  QukanDailyVC.m
//  Qukan
//
//  Created by leo on 2020/1/7.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanDailyVC.h"
#import <UIViewController+HBD.h>

// 视图
#import "QukanDailyHeaderView.h"  // 头部视图
#import "QukanDailyListCell.h"  // cell

// 控制器
#import "QukanNewsViewController.h"  // 新闻控制器  跳转到新闻
#import "QukanInfoViewController.h"   // 个人中心界面去绑定邮箱
#import "QukanShareCenterViewController.h"  // 分享中心  用于分享

// 模型
#import "QukanTModel.h" // 任务模型
#import "QukanActionModel.h"  // 头部视图任务模型

// api
#import "QukanApiManager+PersonCenter.h"
#import "QukanApiManager+Mine.h"

#import "QukanAppDelegate.h"

@interface QukanDailyVC () <UITableViewDelegate, UITableViewDataSource,QukanDailyListCellDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

/**主tab*/
@property(nonatomic, strong) UITableView   * QukanView_tab;
/**主tabheader*/
@property(nonatomic, strong) QukanDailyHeaderView   * QukanTabHeader_view;
/**滑动程度*/
@property(nonatomic, assign) CGFloat    gradientProgress;

/**每日任务数据*/
@property(nonatomic, strong) NSMutableArray   * QukanDaliyList_arr;
/**新手任务数据*/
@property(nonatomic, strong) NSMutableArray   * QukanNewUserList_arr;

@property(nonatomic, assign) BOOL      QukanShouldShowEmpty_bool;

/**tab滑动的背景色*/
@property(nonatomic, strong) UIView   * QukanBlack_view;

@end

@implementation QukanDailyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kCommentBackgroudColor;
    
    
    self.hbd_barAlpha = 0.001f;
    self.hbd_titleTextAttributes = @{ NSForegroundColorAttributeName: kCommonWhiteColor};
    self.navigationItem.title = [NSString stringWithFormat:@"每日%@",[kCacheManager QukangetStStatus].caseNum];
    
    [self QukanInitUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self QukanGetDaliy];  // 获取每日任务
    [self QukanGetNewUserTask];  // 获取新手任务
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)QukanInitUI {
//    [self QukanSetNavBarButtonItem];
    
    [self.view addSubview:self.QukanView_tab];
    [self.QukanView_tab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self.view addSubview:self.QukanBlack_view];
    self.QukanBlack_view.frame = CGRectMake(0, 0, kScreenWidth, 0);
}


//// 设置右边按钮
//- (void)QukanSetNavBarButtonItem{
//    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [rightBtn addTarget:self action:@selector(rightBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
//
//    [rightBtn setTitleColor:kCommonWhiteColor
//                   forState:UIControlStateNormal];
//    [rightBtn setTitle:@"等级规则" forState:UIControlStateNormal];
//
//    rightBtn.layer.masksToBounds = YES;
//    rightBtn.layer.cornerRadius = 4;
//    rightBtn.layer.borderColor = kCommonWhiteColor.CGColor;
//    rightBtn.layer.borderWidth = 0.8f;
//
//    rightBtn.titleLabel.font = kFont12;
//    rightBtn.frame = CGRectMake(0.0, 0.0, 60.0, 20.0);
//
//    UIView *v = [UIView new];
//    v.frame = CGRectMake(0, 0, 60, 44);
//    v.backgroundColor = UIColor.clearColor;
//    [v addSubview:rightBtn];
//    rightBtn.centerY = v.centerY;
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:v];
//    self.navigationItem.rightBarButtonItem = rightItem;
//}



#pragma mark ===================== network ==================================
- (void)QukanGetDaliy {  // 获取每日任务
    @weakify(self)
    if (!self.QukanDaliyList_arr.count) {
        KShowHUD;
    }
    [[[kApiManager QukanSportQuery] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        KHideHUD;
        self.QukanShouldShowEmpty_bool = YES;
        if ([x isKindOfClass:[NSDictionary class]]) {
            [self dataSourceWith:x];
        }else {
            NSLog(@"数据处理错误");
            kShowTip(@"数据错误");
        }
    } error:^(NSError * _Nullable error) {
        NSLog(@"网络处理错误");
        self.QukanShouldShowEmpty_bool = YES;
        @strongify(self)
        KHideHUD;
        kShowTip(@"网络错误");
        [self.QukanView_tab reloadData];
    }];
}

- (void)QukanGetNewUserTask{  // 获取新手任务
    @weakify(self)
    [[[kApiManager QukanNewUserList] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.QukanShouldShowEmpty_bool = YES;
        if ([x isKindOfClass:[NSDictionary class]]) {
            [self newUserWith:x];
        }else {
            NSLog(@"数据处理错误");
        }
    } error:^(NSError * _Nullable error) {
        NSLog(@"网络处理错误");
        self.QukanShouldShowEmpty_bool = YES;
        @strongify(self)
        KHideHUD;
        kShowTip(@"网络错误");
        [self.QukanView_tab reloadData];
    }];
}

// headerView领取奖励
- (void)QukanUserGetJLWithActionModel:(QukanActionModel *)model {
    if (model.status != 1 || model.pageNumber == 0) { kShowTip(@"操作失败，请稍后再试") return;}
    
    if (model.type2 == QukanReType_age) {   //hongbao
        [self headerViewLinquHBWithActionMode:model];
    }
    
    if (model.type2 == QukanLiveType_Point) { // jifen
        [self headerViewLinquJFWithActionMode:model];
    }
}

// 头部领取红包
- (void)headerViewLinquHBWithActionMode:(QukanActionModel *)model {
    KShowHUD;
    @weakify(self)
    [[[kApiManager QukanGcUserReadList:model.pageNumber WithRecordId:model.tRecordId] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        KHideHUD;
        [self.view showTip:@"领取成功"];
        model.status=2;
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        KHideHUD;
    }];
}

// 头部领取积分
- (void)headerViewLinquJFWithActionMode:(QukanActionModel *)model {
    KShowHUD;
    @weakify(self)
    [[[kApiManager QukanFocusNum:[NSString stringWithFormat:@"%.0ld",(long)model.pageNumber] WithRecordId:model.tRecordId] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        KHideHUD;
        [self.view showTip:@"领取成功"];
        model.status=2;
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        KHideHUD;
    }];
}

// 底部每日任务领取奖励
- (void)QukanUserGetJLWithRenModel:(QukanTModel *)model {
    if (model.status == 2) { return;}
    double rewardNumber = model.pageNumber;
    long taskRecordId = model.tRecordId;
    
    if (rewardNumber == 0) {
        return;
    }
    KShowHUD;
    @weakify(self)
    [[[kApiManager QukanFocusNum:[NSString stringWithFormat:@"%.0f",rewardNumber] WithRecordId:taskRecordId] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        KHideHUD;
        [self.view showTip:@"领取成功"];
        
        model.status = 2;
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        KHideHUD;
        
        [self.view showTip:@"领取失败，请检查您的网络"];
    }];
}


#pragma mark ===================== 数据处理 ==================================
- (void)dataSourceWith:(id)response {
    NSDictionary *dict = [NSDictionary dictionary];
    if ([response isKindOfClass:[NSDictionary class]]) {
        dict = response;
    } else return;
    
    [self.QukanDaliyList_arr removeAllObjects];
    
    QukanTModel *publish_commentModel;
    if ([[dict objectForKey:@"publish_comment"] isKindOfClass:[NSDictionary class]]) {
        publish_commentModel = [QukanTModel modelWithDictionary:dict[@"publish_comment"]];
    }
    if (publish_commentModel) {
        [self.QukanDaliyList_arr addObject:publish_commentModel];
    }
    
    QukanTModel *comment_likeModel;
    if ([[dict objectForKey:@"comment_like"] isKindOfClass:[NSDictionary class]]) {
        comment_likeModel = [QukanTModel modelWithDictionary:dict[@"comment_like"]];
    }
    if (comment_likeModel) {
        [self.QukanDaliyList_arr addObject:comment_likeModel];
    }
    QukanTModel *comment_hotModel;
    if ([[dict objectForKey:@"comment_hot"] isKindOfClass:[NSDictionary class]]) {
        comment_hotModel = [QukanTModel modelWithDictionary:dict[@"comment_hot"]];
    }
    if (comment_hotModel) {
        [self.QukanDaliyList_arr addObject:comment_hotModel];
    }
    
    QukanTModel *read_newsModel;
    if ([[dict objectForKey:@"read_news"] isKindOfClass:[NSDictionary class]]) {
        read_newsModel = [QukanTModel modelWithDictionary:dict[@"read_news"]];
    }
    if (read_newsModel) {
        [self.QukanDaliyList_arr addObject:read_newsModel];
    }
    
    QukanTModel *watch_liveModel;
    if ([[dict objectForKey:@"watch_live"] isKindOfClass:[NSDictionary class]]) {
        watch_liveModel = [QukanTModel modelWithDictionary:dict[@"watch_live"]];
    }
    if (watch_liveModel) {
        [self.QukanDaliyList_arr addObject:watch_liveModel];
    }
    
    QukanTModel *day_shareModel;
    if ([[dict objectForKey:@"day_share"] isKindOfClass:[NSDictionary class]]) {
        day_shareModel = [QukanTModel modelWithDictionary:dict[@"day_share"]];
    }
    if (day_shareModel) {
        [self.QukanDaliyList_arr addObject:day_shareModel];
    }
    
    
    if ([[dict objectForKey:@"watch_live"] isKindOfClass:[NSDictionary class]]) {
        QukanTModel *watch_match = [QukanTModel modelWithDictionary:dict[@"watch_match"]];
         [self.QukanTabHeader_view fullBottomViewWithModel:watch_match];
    }

    if ([[dict objectForKey:@"invite_friend"] isKindOfClass:[NSDictionary class]]) {
        QukanTModel *invite_friend = [QukanTModel modelWithDictionary:dict[@"invite_friend"]];
         [self.QukanTabHeader_view fullCenterViewWithModel:invite_friend];
    }

    [self.QukanView_tab reloadData];
}

- (void)newUserWith:(id)response {
    [self.QukanNewUserList_arr removeAllObjects];
    if (![response objectForKey:@"bing_email"]) {
        [self.QukanView_tab reloadData];
        return;
    }
    QukanTModel *model_bind = [QukanTModel modelWithDictionary:response[@"bing_email"]];
    [self.QukanNewUserList_arr addObject:model_bind];
    if (self.QukanDaliyList_arr.count > 0) {
        [self.QukanView_tab reloadData];
    }
}


#pragma mark ========================== UITableViewDelegate, UITableViewDataSource ==========================
// 返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QukanDailyListCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%zdQukanDailyListCell",indexPath.row]];
    if (!cell) {
        cell = [[QukanDailyListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"%zdQukanDailyListCell",indexPath.row]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.delegate = self;
    if (indexPath.section == 0) {
        [cell fullCellWithModel:self.QukanNewUserList_arr[indexPath.row]];
    }
    if (indexPath.section == 1) {
        [cell fullCellWithModel:self.QukanDaliyList_arr[indexPath.row]];
    }
    
    return cell;
}
// 每个cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    QukanTModel *model = nil;
    if (indexPath.section == 0) {
        model = self.QukanNewUserList_arr[indexPath.row];
    }
    if (indexPath.section == 1) {
        model = self.QukanDaliyList_arr[indexPath.row];
    }
    if (model) {
        NSString *descr = model.descr;
        NSArray *descr_array = [descr componentsSeparatedByString:@"（注："];
        if (descr_array.count > 1) {
            return 70;
        }else {
            return 58;
        }
    }
    
    return 58;
}
// 每个section的cell的数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.QukanNewUserList_arr.count;
    }else {
        return self.QukanDaliyList_arr.count;
    }
}
// tab的section的数量
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
// section的头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}
// section头部的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}
// section的尾部的View
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}
//section尾部的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

#pragma mark ===================== cellDelegate ==================================
- (void)QukanDailyListCellQukanNoLinqu_btnClick:(QukanDailyListCell *)cell {  // 未领取按钮点击
    NSIndexPath *indexPath = [self.QukanView_tab indexPathForCell:cell];
    QukanTModel *model = nil;
    if (indexPath.section == 0) {
        model = self.QukanNewUserList_arr[indexPath.row];
    }
    if (indexPath.section == 1) {
        model = self.QukanDaliyList_arr[indexPath.row];
    }
    if (model) {
        [self QukanUserGetJLWithRenModel:model];
    }
}

- (void)QukanDailyListCellQukanNoComplet_btnClick:(QukanDailyListCell *)cell {
    NSIndexPath *indexPath = [self.QukanView_tab indexPathForCell:cell];
    kGuardLogin;
    if (indexPath.section == 0 ) {
        [self jumpToBindEmailVC];
        return;
    }
    [self QukanSelectNewsVC];
}

- (void)QukanSelectNewsVC {
    QukanAppDelegate *appdelegate = (QukanAppDelegate *)[[UIApplication sharedApplication] delegate];
    QukanTarBarViewController *tarbar = appdelegate.tarBar;
    
    __block NSInteger index = 0;
    [tarbar.childViewControllers enumerateObjectsUsingBlock:^(UINavigationController *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIViewController *indexVc = obj.childViewControllers.firstObject;
        if ([indexVc isKindOfClass:[QukanNewsViewController class]]) {
            index = idx;
        }
    }];
    tarbar.customTabbar.selectIndex = index;
}


- (void)jumpToBindEmailVC{
    QukanInfoViewController *vc = [QukanInfoViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark ===================== scroller ==================================
// 主滑动视图滑动代理  用于处理导航栏颜色改变
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y < 0) {
        CGRect frame = self.QukanBlack_view.frame;
        frame.size.height = - scrollView.contentOffset.y;
        self.QukanBlack_view.frame = frame;
    }
    
    CGFloat progress = scrollView.contentOffset.y + scrollView.contentInset.top;
    CGFloat gradientProgress = MIN(1, MAX(0, progress  / 150));
    gradientProgress = gradientProgress * gradientProgress * gradientProgress * gradientProgress;
    if (gradientProgress != self.gradientProgress) {
        self.gradientProgress = gradientProgress;
        if (self.gradientProgress < 0.1) {
            self.hbd_barStyle = UIBarStyleDefault;
            self.hbd_tintColor = kCommonWhiteColor;
        } else {
            self.hbd_barStyle = UIBarStyleDefault;
            self.hbd_tintColor = kCommonWhiteColor;
        }
        
        self.hbd_barAlpha = self.gradientProgress;
        [self hbd_setNeedsUpdateNavigationBar];
    }
 
}


#pragma mark ===================== DZNEmptyDataSetSource ==================================
// 占位图提示文本
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *description = @"暂无数据";
    return [[NSAttributedString alloc] initWithString:description attributes:@{NSFontAttributeName : kFont16,NSForegroundColorAttributeName : [UIColor grayColor]}];
}
// 占位图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *imageName = @"Qukan_Null_Data";
    return [UIImage imageNamed:imageName];
}
// 占位图点击效果
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    [self QukanGetDaliy];  // 获取每日任务
    [self QukanGetNewUserTask];  // 获取新手任务
}
// 占位图背景颜色
- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return self.view.backgroundColor;
}

#pragma mark ===================== DZNEmptyDataSetDelegate ==================================
// 占位图是否能滑动
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}
// 占位图是否能点击
- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    return YES;
}
// 占位图是否需要展示
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return self.QukanShouldShowEmpty_bool;;
}

- (void)emptyDataSetWillAppear:(UIScrollView *)scrollView {
    self.QukanTabHeader_view.hidden = YES;
}

- (void)emptyDataSetWillDisappear:(UIScrollView *)scrollView {
    self.QukanTabHeader_view.hidden = NO;
}

#pragma mark ===================== lazy ==================================

- (UITableView *)QukanView_tab {
    if (!_QukanView_tab) {
        _QukanView_tab = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _QukanView_tab.backgroundColor = kCommentBackgroudColor;
        
        _QukanView_tab.contentInset = UIEdgeInsetsMake(-kTopBarHeight, 0, 20, 0);
        
        _QukanView_tab.delegate = self;
        _QukanView_tab.dataSource = self;
        
        _QukanView_tab.emptyDataSetSource = self;
        _QukanView_tab.emptyDataSetDelegate = self;
        
        _QukanView_tab.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        
        _QukanView_tab.tableHeaderView = self.QukanTabHeader_view;
        
    }
    return _QukanView_tab;
}

- (QukanDailyHeaderView *)QukanTabHeader_view {
    if (!_QukanTabHeader_view) {
        _QukanTabHeader_view = [[QukanDailyHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 190 + kStatusBarHeight + 277 + 20 + 25 + 185 - 118)];
        
        @weakify(self);
        [[[_QukanTabHeader_view rac_signalForSelector:@selector(linquActionWithActionModel:)] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(RACTuple * _Nullable x) {
            @strongify(self);
            kGuardLogin;
            if ([x.first isKindOfClass:[QukanActionModel class]]) {
                [self QukanUserGetJLWithActionModel:(QukanActionModel *)x.first];
            }
        }];
        
        [[[_QukanTabHeader_view rac_signalForSelector:@selector(YQBtnClick)] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(RACTuple * _Nullable x) {
            @strongify(self);
            kGuardLogin;
            QukanShareCenterViewController *vc = [QukanShareCenterViewController new];
            [vc setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:vc animated:YES];

        }];
    }
    return _QukanTabHeader_view;
}

- (NSMutableArray *)QukanDaliyList_arr {
    if (!_QukanDaliyList_arr) {
        _QukanDaliyList_arr = [NSMutableArray new];
    }
    return _QukanDaliyList_arr;
}

- (NSMutableArray *)QukanNewUserList_arr {
    if (!_QukanNewUserList_arr) {
        _QukanNewUserList_arr = [NSMutableArray new];
    }
    return _QukanNewUserList_arr;
}


-(UIView *)QukanBlack_view {
    if (!_QukanBlack_view) {
        _QukanBlack_view = [UIView new];
        _QukanBlack_view.backgroundColor = kThemeColor;
    }
    return _QukanBlack_view;
}

@end
