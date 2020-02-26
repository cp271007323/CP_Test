//
//  QukanGroupSetterNoticeViewController.m
//  Qukan
//
//  Created by Mac on 2020/2/24.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanGroupSetterNoticeViewController.h"
#import "QukanGroupPostNoticeViewController.h"  //发布公告

#import "QukanGroupSetterNoticeCell.h"

@interface QukanGroupSetterNoticeViewController ()<
UITableViewDelegate,
UITableViewDataSource>

@property (nonatomic , strong) UITableView *tableView;

@end

@implementation QukanGroupSetterNoticeViewController

#pragma mark - set



#pragma mark - Life
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"群公告信息";
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

///导航栏右侧按钮
- (void)qukan_setNavBarRightButtonItem
{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"发布" forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(0.0, 0.0, 40, 40.0);
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    [[rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"发布");
        QukanGroupPostNoticeViewController *vc = [QukanGroupPostNoticeViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

#pragma mark - Public

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QukanGroupSetterNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:QukanGroupSetterNoticeCell.identifier];
    cell.model = @"";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView cellHeightForIndexPath:indexPath model:@"" keyPath:@"model" cellClass:QukanGroupSetterNoticeCell.class contentViewWidth:CPScreenWidth()];
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
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = HEXColor(0xF0F0F0);
        [_tableView registerClass:[QukanGroupSetterNoticeCell class] forCellReuseIdentifier:QukanGroupSetterNoticeCell.identifier];
    }
    return _tableView;
}
 

@end
