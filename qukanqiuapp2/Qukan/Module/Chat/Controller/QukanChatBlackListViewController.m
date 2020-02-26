//
//  QukanChatBlackListViewController.m
//  Qukan
//
//  Created by Mac on 2020/2/24.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanChatBlackListViewController.h"

#import "QukanChatMemberCell.h"

@interface QukanChatBlackListViewController ()<
UITableViewDelegate,
UITableViewDataSource>

@property (nonatomic , strong) UITableView *tableView;

@property (nonatomic , strong) NSArray<NSString *> *tableHeadTitles;

@property (nonatomic , strong) UISearchController *searchController;

@end

@implementation QukanChatBlackListViewController

#pragma mark - set



#pragma mark - Life
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"屏蔽名单";
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.tableHeadTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QukanChatMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:QukanChatMemberCell.identifier];
    cell.textLabel.text = @"111111";
    
    UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [delBtn setTitle:@"移除" forState:UIControlStateNormal];
    delBtn.titleLabel.font = CPFont_Regular(14);
    [delBtn setTitleColor:CPColor(@"#E9474F") forState:UIControlStateNormal];
    delBtn.frame = CGRectMake(0, 0, 50, 40);
    cell.accessoryView = delBtn;
    [[[delBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"移除");
    }];
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return  0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 29;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.tableHeadTitles[section];
}

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView;
{
    return self.tableHeadTitles;
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
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.separatorColor = HEXColor(0xEEEEEE);
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundColor = HEXColor(0xF0F0F0);
        _tableView.tintColor = HEXColor(0x444444);
        _tableView.tableHeaderView = self.searchController.searchBar;
        [_tableView registerClass:[QukanChatMemberCell class] forCellReuseIdentifier:QukanChatMemberCell.identifier];
    }
    return _tableView;
}

- (NSArray<NSString *> *)tableHeadTitles
{
    if (_tableHeadTitles == nil) {
        _tableHeadTitles = @[@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n"];
    }
    return _tableHeadTitles;
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
//        _searchController.searchResultsUpdater = vc;
    //   改变系统自带的“cancel”为“取消”
        [self.searchController.searchBar setValue:@"取消" forKey:@"cancelButtonText"];
        
    }
    return _searchController;
}


@end
