//
//  QukanChatListViewController.m
//  Qukan
//
//  Created by Mac on 2020/2/22.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanChatListViewController.h"
#import "QukanChatSearchViewController.h" //搜索页
#import "QukanChatContactsListViewController.h" //通讯录
#import "QukanChatAddFriendsViewController.h"   //添加好友
//弹窗
#import "CPPrompt.h"
#import "QukanChatJurisdictionView.h"

#import "QukanChatListCell.h"

#import <SDAutoLayout/SDAutoLayout.h>

@interface QukanChatListViewController ()<
UITableViewDelegate,
UITableViewDataSource>

@property (nonatomic , strong) UITableView *tableView;

@property (nonatomic , strong) UISearchController *searchController;
 

@end

@implementation QukanChatListViewController

#pragma mark - set



#pragma mark - Life
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = @"侃球";
    [self setupInitLayoutForHBHomeViewController];
    [self setupInitBindingForHBHomeViewController];
}

#pragma mark - Private
- (void)setupInitLayoutForHBHomeViewController
{
    [self qukan_setNavBarRightButtonItem];
    
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
}

- (void)setupInitBindingForHBHomeViewController
{
    //权限提示  暂无查看权限
//    QukanChatJurisdictionView *view = [QukanChatJurisdictionView coverView];
//    [[view.jurisdictionBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
//        NSLog(@"查看权限");
//    }];
//    [[view.submitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
//        NSLog(@"知道了");
//        [view dissCoverView];
//    }];
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [view showCoverView];
//    });
}

///导航栏右侧按钮
- (void)qukan_setNavBarRightButtonItem
{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn addTarget:self action:@selector(otherAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setImage:kImageNamed(@"nav_Filter") forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(0.0, 0.0, 40, 40.0);
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)otherAction:(UIButton *)sender
{
    //配置属性
    CPPromptBoxOption *option = [CPPromptBoxOption promptBoxOptionWithClipView:sender];
    option.separatorColor = HEXColor(0x444444);
    option.radiu = 5;
    option.width = 85;
    //初始化
    CPPromptBoxView *PromptBoxView = [CPPromptBoxView promptBoxViewWithOption:option];
    
    //添加数据
    [PromptBoxView addTitles:@[@" 通讯录",@" 添加好友"] images:nil didSelector:^(NSIndexPath *indexPath) {
        //点击回调
        NSLog(@"%@",indexPath);
        //通讯录
        if (indexPath.row == 0)
        {
            QukanChatContactsListViewController *vc = [QukanChatContactsListViewController new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        //添加好友
        else if (indexPath.row == 1)
        {
            QukanChatAddFriendsViewController *vc = [QukanChatAddFriendsViewController new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } cancleSelector:^{
        //取消回调
        NSLog(@">>>>>>");
        
    }];
    
    //显示
    [PromptBoxView showPrompt];
}

#pragma mark - Public

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QukanChatListCell *cell = [tableView dequeueReusableCellWithIdentifier:QukanChatListCell.identifier];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return  0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_11_0

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

#endif

#pragma mark - get
-(UITableView *)tableView
{
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.separatorColor = HEXColor(0xEEEEEE);
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableHeaderView = self.searchController.searchBar;
        _tableView.backgroundColor = HEXColor(0xF0F0F0);
        [_tableView registerClass:[QukanChatListCell class] forCellReuseIdentifier:QukanChatListCell.identifier];
    }
    return _tableView;
}

- (UISearchController *)searchController
{
    if(_searchController == nil)
    {
        QukanChatSearchViewController *vc = [QukanChatSearchViewController new];
        _searchController = [[UISearchController alloc] initWithSearchResultsController:vc];
        _searchController.view.backgroundColor = UIColor.whiteColor;
        _searchController.searchBar.placeholder = @"搜索聊天记录";
        _searchController.searchBar.backgroundColor = UIColor.whiteColor;
        _searchController.searchBar.backgroundImage = [UIImage new];
        [_searchController.searchBar setImage:kImageNamed(@"Qukan_News_search") forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        
        //光标颜色和取消按钮的颜色
        [_searchController.searchBar setTintColor:UIColor.greenColor];
        
        @weakify(self)
        [[RACObserve(_searchController.searchBar.searchTextField, frame) skip:1] subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            self.searchController.searchBar.searchTextField.layer.cornerRadius = self.searchController.searchBar.searchTextField.height_sd * .5;
            self.searchController.searchBar.searchTextField.clipsToBounds = YES;
            self.searchController.searchBar.searchTextField.backgroundColor = HEXColor(0xF5F5F5);
        }];
        
    //    searchResultsUpdater协议代理
        _searchController.searchResultsUpdater = vc;
    //   改变系统自带的“cancel”为“取消”
        [self.searchController.searchBar setValue:@"取消" forKey:@"cancelButtonText"];
        
    }
    return _searchController;
}


@end
