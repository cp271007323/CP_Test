//
//  QukanGroupSetterViewController.m
//  Qukan
//
//  Created by Mac on 2020/2/24.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanGroupSetterViewController.h"
#import "QukanChatMemberReportViewController.h" //举报
#import "QukanChatSearchRecordViewController.h" //查找聊天记录
#import "QukanGroupSetterNoticeViewController.h"//群公告
#import "QukanGroupEditGroupNameViewController.h"//修改群名称
#import "QukanGroupEditInGroupNicknameViewController.h"//修改群聊昵称
#import "QukanGroupAllMembersViewController.h"  //全部群成员
#import "QukanChatBlackListViewController.h"    //黑名单
#import "QukanGroupRemoveMembersViewController.h"//移除成员
#import "QukanGroupAddMembersViewController.h"   //添加成员

#import "QukanNormalPopUpView.h"    //弹框

#import "QukanAllMemberCell.h"      //群成员

@interface QukanGroupSetterViewController ()<
UITableViewDelegate,
UITableViewDataSource,
AllMembersViewDelegate>

@property (nonatomic , strong) UITableView *tableView;

@property (nonatomic , strong) NSArray<NSArray<NSString *> *> *dataSource;

/// 虚拟成员
@property (nonatomic , strong) NSArray<NSString *> *members;

/// 删除按钮
@property (nonatomic , strong) UIButton *delBtn;

@end

@implementation QukanGroupSetterViewController

#pragma mark - set



#pragma mark - Life
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"群聊信息";
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
    [[self.delBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        QukanNormalPopUpView *view = [QukanNormalPopUpView coverView];
        view.title = @"探球宝典";
        view.content = @"确定要退出改群组吗?";
        [view showCoverView];
        [[view.submitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            
        }];
    }];
}

#pragma mark - Public



#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        QukanAllMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:QukanAllMemberCell.identifier];
        cell.allMemberView.isGroup = YES;
        cell.members = self.members;
        cell.allMemberView.cpDelegate = self;
        return cell;
    }
    else
    {
        //群聊信息
        if (indexPath.section == 0)
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell_Value1"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell_Value1"];
                cell.detailTextLabel.numberOfLines = 1;
            }
            
        
            //群聊名称/群聊昵称
            if (indexPath.row == 0 || indexPath.row == 2)
            {
                cell.detailTextLabel.text = @"未设置";
            }
            //群内公告  多行切换，根据内容选择cell模式
            else if (indexPath.row == 1)
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellStyleSubtitle"];
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCellStyleSubtitle"];
                    cell.detailTextLabel.numberOfLines = 0;
                }
                
                cell.detailTextLabel.text = @"我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我我";
            }
            
            cell.textLabel.text = self.dataSource[indexPath.section][indexPath.row];
            cell.textLabel.textColor = CPColor(@"222222");
            cell.textLabel.font = CPFont_Light(15);
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            cell.detailTextLabel.textColor = CPColor(@"#666666");
            cell.detailTextLabel.numberOfLines = 0;
            
            return cell;
        }
        else
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class)];
            cell.textLabel.text = self.dataSource[indexPath.section][indexPath.row];
            cell.textLabel.textColor = CPColor(@"222222");
            cell.textLabel.font = CPFont_Light(15);
            cell.accessoryView = nil;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            //消息免打扰
            if (indexPath.section == 2 && indexPath.row == 0)
            {
                UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, CPAuto(50), CPAuto(30))];
                cell.accessoryView = switchView;
                switchView.onTintColor = CPColor(@"#E9474F");
                [[[switchView rac_newOnChannel] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(NSNumber * _Nullable x) {
                    NSLog(@">>>>>>>>>>");
                }];
            }
            return cell;
        }
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0)
    {
        //群聊名称
        if (indexPath.row == 0)
        {
            QukanChatBlackListViewController *vc = [QukanChatBlackListViewController new];
//            QukanGroupEditGroupNameViewController *vc = [QukanGroupEditGroupNameViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
        //群公告
        else if (indexPath.row == 1)
        {
            QukanGroupSetterNoticeViewController *vc = [QukanGroupSetterNoticeViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
        //群聊昵称
        else if (indexPath.row == 2)
        {
            QukanGroupEditInGroupNicknameViewController *vc = [QukanGroupEditInGroupNicknameViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if (indexPath.section == 2)
    {
        //查找聊天记录
        if (indexPath.row == 1)
        {
            QukanChatSearchRecordViewController *vc = [QukanChatSearchRecordViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
        //清空聊天记录
        else if (indexPath.row == 2)
        {
            QukanNormalPopUpView *view = [QukanNormalPopUpView coverView];
            view.title = @"探球宝典";
            view.content = @"是否确定情况所有聊天记录?";
            [view showCoverView];
            [[view.submitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
                
            }];
        }
    }
    //举报
    else if (indexPath.section == 3)
    {
        QukanChatMemberReportViewController *vc = [QukanChatMemberReportViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
    NSLog(@">>");
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return [tableView cellHeightForIndexPath:indexPath model:self.members keyPath:@"members" cellClass:QukanAllMemberCell.class contentViewWidth:CPScreenWidth()];
    }
    return UITableViewAutomaticDimension;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return  10;
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

#pragma mark - AllMembersViewDelegate
- (void)allMembersViewForLookAllMembers:(AllMembersView *)allmembersView
{
    QukanGroupAllMembersViewController *vc = [QukanGroupAllMembersViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)allMembersViewWithAdd:(AllMembersView *)allmembersView
{
    NSLog(@"++++");
    QukanGroupAddMembersViewController *vc = [QukanGroupAddMembersViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)allMembersViewWithRemove:(AllMembersView *)allmembersView
{
    NSLog(@"----");
    QukanGroupRemoveMembersViewController *vc = [QukanGroupRemoveMembersViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)allMembersView:(AllMembersView *)allmembersView didSelector:(NSString *)model
{
    NSLog(@"didSelector");
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
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.estimatedRowHeight = 50;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.separatorColor = HEXColor(0xEEEEEE);
        _tableView.backgroundColor = HEXColor(0xF0F0F0);
        _tableView.tintColor = HEXColor(0x444444);
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
        [_tableView registerClass:[QukanAllMemberCell class] forCellReuseIdentifier:QukanAllMemberCell.identifier];
        _tableView.tableFooterView = self.delBtn;
    }
    return _tableView;
}

- (NSArray<NSArray<NSString *> *> *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = @[@[@"群聊名称",@"群内公告",@"群聊昵称"],@[@""],@[@"消息免打扰",@"查找聊天记录",@"清空聊天记录"],@[@"举报"]];
    }
    return _dataSource;
}

- (NSArray<NSString *> *)members
{
    NSMutableArray<NSString *> *arr = [NSMutableArray array];
    for (NSInteger i = 0; i < 50; i++) {
        [arr addObject:CPIString(i)];
    }
    return arr;
}

- (UIButton *)delBtn
{
    if (_delBtn == nil) {
        _delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _delBtn.frame = CGRectMake(0, 0, CPScreenWidth(), CPAuto(50));
        [_delBtn setTitle:@"退出群组" forState:UIControlStateNormal];
        [_delBtn setTitleColor:CPColor(@"#E9474F") forState:UIControlStateNormal];
        _delBtn.titleLabel.font = CPFont_Regular(15);
        _delBtn.backgroundColor = UIColor.whiteColor;
    }
    return _delBtn;
}


@end
