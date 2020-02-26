//
//  QukanMyFriendsViewController.m
//  Qukan
//
//  Created by Mac on 2020/2/22.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanMyFriendsViewController.h"
#import "QukanFriendsBaseInfoViewController.h"  //基本信息

#import "QukanChatMemberCell.h"

#import <SDAutoLayout/SDAutoLayout.h>

#import "QukanApiManager+QukanChatApi.h"

@interface QukanMyFriendsViewController ()<
UITableViewDelegate,
UITableViewDataSource>

@property (nonatomic , strong) UITableView *tableView;

@property (nonatomic , strong) NSArray<NSString *> *tableHeadTitles;

@end

@implementation QukanMyFriendsViewController

#pragma mark - set



#pragma mark - Life
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    [[kApiManager QukanChatFriends] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    } error:^(NSError * _Nullable error) {
        NSLog(@">>>");
    }];
}


#pragma mark - Public



#pragma mark JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}


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
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    QukanFriendsBaseInfoViewController *vc = [QukanFriendsBaseInfoViewController new];
    [self.navigationController pushViewController:vc animated:YES];
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

@end
