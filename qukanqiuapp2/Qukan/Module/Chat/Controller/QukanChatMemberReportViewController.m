//
//  QukanChatMemberReportViewController.m
//  Qukan
//
//  Created by Mac on 2020/2/23.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanChatMemberReportViewController.h"
#import "QukanNormalPopUpView.h"

@interface QukanChatMemberReportViewController ()<
UITableViewDelegate,
UITableViewDataSource>

@property (nonatomic , strong) UITableView *tableView;

@property (nonatomic , strong) NSArray<NSString *> *dataSource;

@end

@implementation QukanChatMemberReportViewController

#pragma mark - set



#pragma mark - Life
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"举报";
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
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class)];
    cell.textLabel.text = self.dataSource[indexPath.row];
    cell.textLabel.font = kFont15;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    QukanNormalPopUpView *view = [QukanNormalPopUpView coverView];
    view.title = @"探球宝典";
    view.content = @"是否确定提交举报信息?";
    [view showCoverView];
    [[view.submitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
    }];
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
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorColor = CPLineColor();
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundColor = CPColor(@"#F0F0F0");
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
    }
    return _tableView;
}

- (NSArray<NSString *> *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = @[@"发布不适当的内容对我造成骚扰",
                        @"发布色情内容对我进行骚扰",
                        @"发布违法违禁内容对我进行骚扰",
                        @"发布赌博内容对我进行骚扰",
                        @"发布其他违规内容对我造成骚扰",
                        @"账号存在欺诈行为",
                        @"此账号可能被盗用了",
                        @"账号存在侵权行为"];
    }
    return _dataSource;
}

@end
