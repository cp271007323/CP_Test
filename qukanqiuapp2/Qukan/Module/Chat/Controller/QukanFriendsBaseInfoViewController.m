//
//  QukanFriendsBaseInfoViewController.m
//  Qukan
//
//  Created by Mac on 2020/2/23.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanFriendsBaseInfoViewController.h"
#import "QukanChatMemberReportViewController.h"     //举报
#import "QukanChatMemberEditRemarksViewController.h"//设置备注名
#import "QukanFriendsSetterViewController.h"        //单聊聊天设置

#import "QukanFriendsBaseInfoHeadCell.h"

@interface QukanFriendsBaseInfoViewController ()<
UITableViewDelegate,
UITableViewDataSource>

@property (nonatomic , strong) UITableView *tableView;

@property (nonatomic , strong) UIView *bottomView;

@property (nonatomic , strong) UIButton *submitBtn;

@end

@implementation QukanFriendsBaseInfoViewController

#pragma mark - set



#pragma mark - Life
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"基本信息";
    self.view.backgroundColor = CPColor(@"#F0F0F0");
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? 2 : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //用户头像
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        QukanFriendsBaseInfoHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:QukanFriendsBaseInfoHeadCell.identifier];
        cell.textLabel.text = @"名字";
        cell.detailTextLabel.text = @"ID:123897";
        
        return cell;
    }
    //备注名、举报
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class)];
        cell.textLabel.text = indexPath.section == 0 ? @"备注名" : @"举报";
        cell.textLabel.font = kFont15;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.section == 0 && indexPath.row == 0) ? 81 : 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1)
    {
        QukanChatMemberReportViewController *vc = [QukanChatMemberReportViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.section == 0 && indexPath.row == 1)
    {
        QukanChatMemberEditRemarksViewController *vc = [QukanChatMemberEditRemarksViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.section == 0 && indexPath.row == 0)
    {
        QukanFriendsSetterViewController *vc = [QukanFriendsSetterViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return  0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0 ? 0.01 : 10;
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
        _tableView.separatorColor = CPLineColor();
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundColor = CPColor(@"#F0F0F0");
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
        [_tableView registerClass:[QukanFriendsBaseInfoHeadCell class] forCellReuseIdentifier:QukanFriendsBaseInfoHeadCell.identifier];
        _tableView.tableFooterView = self.bottomView;
    }
    return _tableView;
}

- (UIView *)bottomView
{
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CPScreenWidth(), 95)];
        _bottomView.backgroundColor = UIColor.clearColor;
        
        [_bottomView addSubview:self.submitBtn];
        self.submitBtn.sd_layout
        .bottomEqualToView(_bottomView)
        .leftSpaceToView(_bottomView, 15)
        .rightSpaceToView(_bottomView, 15)
        .heightIs(44);
        [self.submitBtn setSd_cornerRadiusFromHeightRatio:@.5];
    }
    return _bottomView;
}

- (UIButton *)submitBtn
{
    if (_submitBtn == nil) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitBtn setTitle:@"加好友" forState:UIControlStateNormal];
        _submitBtn.titleLabel.font = kFont16;
        _submitBtn.backgroundColor = CPColor(@"#E9474F");
    }
    return _submitBtn;
}

@end
