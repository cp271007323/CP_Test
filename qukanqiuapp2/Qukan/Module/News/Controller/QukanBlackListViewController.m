//
//  QukanBlackListViewController.m
//  Qukan
//
//  Created by pfc on 2019/8/4.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanBlackListViewController.h"
//#import "QukanBoilingPointTableViewModel_3.h"

@interface QukanBlackListViewController ()<UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *datas;

@end

@implementation QukanBlackListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的黑名单";
    
    self.datas = [QukanFilterManager sharedInstance].blockedList;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    
    _tableView.emptyDataSetSource = self;
    _tableView.emptyDataSetDelegate = self;
    
    _tableView.dataSource = self;
    _tableView.rowHeight = 54;
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [UIView new];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    BlockUserObject* model = self.datas[indexPath.row];
    cell.textLabel.text = model.userName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BlockUserObject* model = self.datas[indexPath.row];

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"移出黑名单" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[QukanFilterManager sharedInstance]unBlockUser:model.userId];
        self.datas = [[QukanFilterManager sharedInstance] blockedList];
        [self.tableView reloadData];
    }];
    
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    [alertController addAction:action2];
    [alertController addAction:action3];
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - DZNEmptyDataSetSource
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    UIFont *font = [UIFont boldSystemFontOfSize:14];
    NSString *description = @"暂无数据";
    return [[NSAttributedString alloc] initWithString:description attributes:@{NSFontAttributeName : font,NSForegroundColorAttributeName : [UIColor grayColor]}];
}
//
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *imageName = @"Qukan_Null_Data";
    return [UIImage imageNamed:imageName];
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    
    return YES;
}

#pragma mark - DZNEmptyDataSetDelegate

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}


@end
