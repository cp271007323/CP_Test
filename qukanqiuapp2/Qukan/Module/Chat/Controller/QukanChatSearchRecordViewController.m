//
//  QukanChatSearchRecordViewController.m
//  Qukan
//
//  Created by Mac on 2020/2/23.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanChatSearchRecordViewController.h"

@interface QukanChatSearchRecordViewController ()<
UITableViewDelegate,
UITableViewDataSource>

@property (nonatomic , strong) UITableView *tableView;

@property (nonatomic , strong) UISearchController *searchController;

@end

@implementation QukanChatSearchRecordViewController

#pragma mark - set



#pragma mark - Life
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"查找聊天记录";
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


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableView.class)];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72;
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
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
    }
    return _tableView;
}

- (UISearchController *)searchController
{
    if(_searchController == nil)
    {
        //此处的[UIViewController new]  详细可以查看 QukanChatListViewController.m 的使用
        UIViewController *vc = [UIViewController new];
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
//        _searchController.searchResultsUpdater = vc;    //一定要注意这里，代理一定要实现，否则会奔溃
    //   改变系统自带的“cancel”为“取消”
        [self.searchController.searchBar setValue:@"取消" forKey:@"cancelButtonText"];
        
    }
    return _searchController;
}

@end
