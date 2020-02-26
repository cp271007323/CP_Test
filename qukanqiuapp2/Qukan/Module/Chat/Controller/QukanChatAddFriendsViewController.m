//
//  QukanChatAddFriendsViewController.m
//  Qukan
//
//  Created by Mac on 2020/2/22.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanChatAddFriendsViewController.h"
#import "QukanShareCenterViewController.h"
#import "QukanChatAddFriendsHotCell.h"

#import <SDAutoLayout/SDAutoLayout.h>

@interface QukanChatAddFriendsViewController ()<
UITableViewDelegate,
UITableViewDataSource>

@property (nonatomic , strong) UITableView *tableView;

@property (nonatomic , strong) UISearchController *searchController;
 
@property (nonatomic , strong) NSArray<NSString *> *ids;    //热门搜索中高能推荐师 数据源  页面会自动判断是否为空处理显示  有多少个会显示多少个

@end

@implementation QukanChatAddFriendsViewController

#pragma mark - set



#pragma mark - Life
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"添加好友";
    [self setupInitLayoutForHBHomeViewController];
    [self setupInitBindingForHBHomeViewController];
}

#pragma mark - Private
- (void)setupInitLayoutForHBHomeViewController
{
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
    
    self.ids = @[@"123123",@"123123",@"1231238791",@"123123",@"1231238791"];
}

- (void)setupInitBindingForHBHomeViewController
{
    
}

#pragma mark - Public


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? self.ids.count != 0 ? 1 : 0 : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        QukanChatAddFriendsHotCell *cell = [tableView dequeueReusableCellWithIdentifier:QukanChatAddFriendsHotCell.identifier];
        cell.ids = self.ids;
        return cell;
    }
    else
    {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        cell.imageView.image = kImageNamed(@"Qukan_less");
        cell.textLabel.text = @"邀请好友";
        cell.detailTextLabel.text = @"邀请好友得积分，更有红包奖励等着你";
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
        cell.detailTextLabel.font = kFont12;
        cell.detailTextLabel.textColor = HEXColor(0x666666);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1)
    {
        kGuardLogin
        QukanShareCenterViewController *vc = [QukanShareCenterViewController new];
        [vc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [tableView cellHeightForIndexPath:indexPath model:self.ids keyPath:@"ids" cellClass:QukanChatAddFriendsHotCell.class contentViewWidth:kScreenWidth];
    }
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return  section == 0 ? self.ids.count != 0 ? 10 : 0.01 : 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0 ? 40 : 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        view.backgroundColor = UIColor.clearColor;
        UILabel *lab = [UILabel new];
        lab.font = kFont12;
        lab.text = @"为了给您更好的服务体验，只能添加分析师为好友哦";
        lab.textColor = HEXColor(0x999999);
        [view addSubview:lab];
        lab.sd_layout
        .spaceToSuperView(UIEdgeInsetsMake(0, 15, 0, 0));
        return view;
    }
    return [UIView new];
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
        [_tableView registerClass:[QukanChatAddFriendsHotCell class] forCellReuseIdentifier:QukanChatAddFriendsHotCell.identifier];
    }
    return _tableView;
}

- (UISearchController *)searchController
{
    if(_searchController == nil)
    {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:[UIViewController new]];
        _searchController.view.backgroundColor = UIColor.whiteColor;
        _searchController.searchBar.placeholder = @"搜索ID";
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
//        _searchController.searchResultsUpdater = self;
    //   改变系统自带的“cancel”为“取消”
        [self.searchController.searchBar setValue:@"取消" forKey:@"cancelButtonText"];
        
    }
    return _searchController;
}


@end
