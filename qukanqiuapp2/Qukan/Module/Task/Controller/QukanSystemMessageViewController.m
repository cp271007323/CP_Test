//
//  QukanSystemMessageViewController.m
//  Qukan
//
//  Created by Kody on 2019/8/14.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanSystemMessageViewController.h"
#import "QukanMessageDetailCell.h"
#import "QukanMessageModel.h"
#import "QukanApiManager+PersonCenter.h"
#import "QukanNullDataView.h"


@interface QukanSystemMessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) UITableView                          *tableView;

@property(nonatomic, strong) NSMutableArray <QukanMessageModel *> *datas;

@property(nonatomic, assign) NSInteger                             page;

@end

@implementation QukanSystemMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self interFace];
    [self addTableView];
    
}

- (void)interFace {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"系统消息";
    
    self.datas = @[].mutableCopy;
    self.page = 1;
    [self Qukan_refreshData];
}

#pragma mark ===================== SubViews ==================================
- (void)addTableView {
    [self.tableView reloadData];
}

#pragma mark ===================== UITableViewDataSoucre ==================================


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    QukanMessageModel *model = self.datas[indexPath.row];
    NSString *htmlString = model.content;
    NSMutableAttributedString * nameText = [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes: nil error:nil];
    CGSize attSize = [nameText boundingRectWithSize:CGSizeMake(kScreenWidth - 140, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    
    
    return attSize.height + 20 < 70 ? 70 : attSize.height + 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QukanMessageDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QukanMessageDetailCell class])];
    QukanMessageModel *model = self.datas[indexPath.row];
    
    [cell fullcellWithModel:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark ===================== NetWork ==================================

- (void)Qukan_refreshData {
    self.page = 1;
    NSString *nowStr = [self getNowTimeStr];
    [self Qukan_gcUserNoticeSelectNoticeWithCursor:nowStr];
}

- (void)Qukan_requestListMore {
    self.page ++;
    QukanMessageModel *messageModel = self.datas.lastObject;
    [self Qukan_gcUserNoticeSelectNoticeWithCursor:messageModel.createTime];
}

- (void)Qukan_gcUserNoticeSelectNoticeWithCursor:(NSString *)cursor {
    @weakify(self)
    KShowHUD
    [[[kApiManager QukanGcUserNoticeSelectNoticeWithCursor:cursor WithPagingSize:10] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        KHideHUD
        [self dataSourceWith:x];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        KHideHUD
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (!self.datas.count) {
            [self showEmptyTip];
        }
    }];
}

- (void)dataSourceWith:(id)response {
    NSArray *array = (NSArray *)response;
    NSArray *temp = [NSArray modelArrayWithClass:[QukanMessageModel class] json:array];
    self.page == 1 ? self.datas = (NSMutableArray *)temp : [self.datas addObjectsFromArray:temp];
    
    self.tableView.mj_footer.hidden = temp.count < 10 ? YES : NO;
    [self.tableView reloadData];
    if (!self.datas.count) {
        self.tableView.mj_footer.hidden = YES;
        [self showEmptyTip];
        return;
    }
    
    if (self.page == 1) {
        // 把请求到的第一个未读消息设置为最后手的通知
        [kUserDefaults setObject:self.datas.firstObject.content forKey:@"UserLastNotification"];
        [kUserDefaults setObject:self.datas.firstObject.createTime forKey:@"LastNotificstionTime"];
    }
}

#pragma mark ===================== Public Methods =======================

- (NSString *)getNowTimeStr {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *nowDate = [NSDate date];
    NSString *nowStr = [dateFormatter stringFromDate:nowDate];
    return nowStr;
}

- (void)showEmptyTip {
    [QukanNullDataView Qukan_showWithView:self.view
                         contentImageView:@"Qukan_Null_Data"
                                  content:@"暂无数据~"];
    [self.view bringSubviewToFront:self.tableView];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


#pragma mark ===================== Getters =================================

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[QukanMessageDetailCell class] forCellReuseIdentifier:NSStringFromClass([QukanMessageDetailCell class])];
        
        _tableView.mj_header = [QukanHomeRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(Qukan_refreshData)];
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(Qukan_requestListMore)];
        
        
        _tableView.backgroundColor = kCommentBackgroudColor;
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _tableView;
}

@end
