//
//  QukanListDetailViewController.m
//  Qukan
//
//  Created by hello on 2019/8/22.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanListDetailViewController.h"
#import "QukanReadDetailCell.h"
#import "QukanWithDetailsViewController.h"
#import "QukanApiManager+PersonCenter.h"
#import "QukanNullDataView.h"

@interface QukanListDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) NSMutableArray *datas;
@property(nonatomic, strong) NSArray <QukanListModel *>    *arrModel;
/**页码*/
@property (assign, nonatomic)  NSInteger Current;
@end

@implementation QukanListDetailViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    KHideHUD
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = FormatString(@"%@记录",kStStatus.pageNum);
    [self setUI];
    
    @weakify(self)
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        self.Current = 1;
        [self QukanSelectDate];
    }];
    
    self.myTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        @strongify(self)
        self.Current++;
        [self QukanSelectDate];
    }];
    
    [self.myTableView.mj_header beginRefreshing];
    
}

#pragma mark -初始化视图
-(void)setUI{
    self.datas = [NSMutableArray array];
    self.view.backgroundColor = HEXColor(0xF9F9F9);
    self.myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.myTableView.backgroundColor = HEXColor(0xF9F9F9);
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.estimatedRowHeight = 0;
    [self.myTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.myTableView];
    [self.myTableView registerNib:[UINib nibWithNibName:@"QukanReadDetailCell" bundle:nil] forCellReuseIdentifier:@"QukanReadDetailCell"];
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark -tableView代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QukanReadDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QukanReadDetailCell"];
    QukanListModel *model = self.datas[indexPath.row];
    [cell setmaiType:FormatString(@"%@%@",kStStatus.name,kStStatus.numberDay) labmai:model.amount image:model.status.integerValue labTime:model.createdDate];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 186;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *array = [NSMutableArray array];
    QukanWithDetailsViewController *vc = [QukanWithDetailsViewController new];
    QukanListModel *model = self.datas[indexPath.row];
    vc.model = model;
    //    createdDate 提交时间
    //    updateDate 更新时间
    //    checkDate 验证时间
    //    doneDate 完成时间
    if (model.createdDate) {
        [array addObject:@{@"title":@"申请时间",@"content":model.createdDate}];
    }
    
    if (model.checkDate) {
        [array addObject:@{@"title":FormatString(@"%@时间",kStStatus.phone),@"content":model.checkDate}];
    }
    
    if (model.updateDate && model.status.integerValue != 2) {
        [array addObject:@{@"title":@"退回时间",@"content":model.updateDate}];
    }
    
    if (model.doneDate) {
        [array addObject:@{@"title":@"发放时间",@"content":model.doneDate}];
    }
    if (model.error && model.status.integerValue == 3) {
        [array addObject:@{@"title":FormatString(@"%@说明",kStStatus.pageNum),@"content":model.error}];
    }else{
        [array addObject:@{@"title":FormatString(@"%@说明",kStStatus.pageNum),@"content":model.descr}];
    }
    
    vc.arrModel = array;
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *v = [UIView new];
    v.backgroundColor = HEXColor(0xF9F9F9);
    return v;
}

- (void)showEmptyTip {
    [QukanNullDataView Qukan_showWithView:self.view
                         contentImageView:@"Qukan_Null_Data"
                                  content:FormatString(@"暂无%@记录",kStStatus.pageNum)
                                      top:0];
    //    [self.view bringSubviewToFront:self.refreshBtn];
}


#pragma mark ===================== NetWork ==================================

- (void)QukanSelectDate {
    @weakify(self)
    KShowHUD
    [[[kApiManager QukanreadListWithCurrent:self.Current size:10] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        
        @strongify(self)
        KHideHUD
        if (self.Current == 1) {
            [self.datas removeAllObjects];
        }
        self.arrModel = [NSArray modelArrayWithClass:[QukanListModel class] json:x[@"records"]];
        [self.datas addObjectsFromArray:self.arrModel];
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
        
        [self.myTableView reloadData];
        if (self.datas.count == 0) {
            [self showEmptyTip];
        } else {
            [QukanNullDataView Qukan_hideWithView:self.view];
        }
        
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        KHideHUD
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        
        
    }];
}


@end
