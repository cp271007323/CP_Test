//
//  QukanGroupRemoveMembersViewController.m
//  Qukan
//
//  Created by Mac on 2020/2/24.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanGroupRemoveMembersViewController.h"

#import "QukanChatSelectorCell.h"

@interface QukanGroupRemoveMembersViewController ()<
UITableViewDelegate,
UITableViewDataSource>

@property (nonatomic , strong) UITableView *tableView;

@property (nonatomic , strong) UISearchController *searchController;

@end

@implementation QukanGroupRemoveMembersViewController

#pragma mark - set



#pragma mark - Life
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"删除成员";
    [self qukan_setNavBarRightButtonItem];
    [self setupInitLayoutForHBHomeViewController];
    [self setupInitBindingForHBHomeViewController];
}

#pragma mark - Private
- (void)setupInitLayoutForHBHomeViewController
{
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
}

- (void)setupInitBindingForHBHomeViewController
{
    
}

#pragma mark - Public


///导航栏右侧按钮
- (void)qukan_setNavBarRightButtonItem
{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(0.0, 0.0, 40, 40.0);
    rightBtn.titleLabel.font = CPFont_Regular(14);
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    [[rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"完成");
        
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QukanChatSelectorCell *cell = [tableView dequeueReusableCellWithIdentifier:QukanChatSelectorCell.identifier];
    cell.textLabel.text = @"111111";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QukanChatSelectorCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectorBtn.selected = YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
 
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return  0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
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

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSLog(@"%@",searchController.searchBar.text);
}

#pragma mark - get
-(UITableView *)tableView
{
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 50;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.backgroundColor = HEXColor(0xF0F0F0);
        _tableView.tintColor = HEXColor(0x444444);
        _tableView.tableHeaderView = self.searchController.searchBar;
        [_tableView registerClass:[QukanChatSelectorCell class] forCellReuseIdentifier:QukanChatSelectorCell.identifier];
    }
    return _tableView;
}
 
- (UISearchController *)searchController
{
    if(_searchController == nil)
    {
        UIViewController *vc = [UIViewController new];
        _searchController = [[UISearchController alloc] initWithSearchResultsController:vc];
        _searchController.view.backgroundColor = UIColor.whiteColor;
        _searchController.searchBar.placeholder = @"搜索";
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
        _searchController.searchResultsUpdater = self;
    //   改变系统自带的“cancel”为“取消”
        [self.searchController.searchBar setValue:@"取消" forKey:@"cancelButtonText"];
        
    }
    return _searchController;
}


@end
