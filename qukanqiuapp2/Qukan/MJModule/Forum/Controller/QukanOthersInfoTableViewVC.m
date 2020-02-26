//
//  OthersInfoTableViewVC.m
//  Qukan
//
//  Created by Charlie on 2019/10/15.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanOthersInfoTableViewVC.h"
#import "QukanOthersCommentHeader.h"
#import "QukanBolingPointListModel.h"
#import "QukanBolingPointListCell.h"
#import "QukanBolingPointDetailVC.h"
#import "QukanApiManager+Boiling.h"
#import "QukanChatViewController.h"

@interface QukanOthersInfoTableViewVC ()<QukanBolingPointListCellDelegate>

@property(strong, nonatomic) QukanOthersCommentHeader* headerView;
@property(strong, nonatomic) QukanBolingPointListModel* otherModel;

@property(strong, nonatomic) NSMutableArray<QukanBolingPointListModel*>* datas;

@property(assign, nonatomic) NSInteger pageIndex; //当前请求的第几页评论页

@end

@implementation QukanOthersInfoTableViewVC

-(instancetype)initWithModel:(QukanBolingPointListModel*)model{
    if(self = [super init]){
        self.otherModel = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.datas = @[].mutableCopy;
    UITableView* tableView = [[UITableView alloc]initWithFrame:self.tableView.frame style:UITableViewStyleGrouped];
    self.tableView = tableView;

    self.tableView.tableHeaderView = self.headerView;
    [self.tableView registerNib:[UINib nibWithNibName:@"QukanBolingPointListCell" bundle:nil] forCellReuseIdentifier:@"QukanBolingPointListCellID"];
    self.title = @"他的主页";

    [self requestCommentList];
    @weakify(self)
    
//    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        // 进入刷新状态后会自动调用这个block
//    }];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        self.pageIndex = 1;
        [self.tableView.mj_footer resetNoMoreData];
        [self requestCommentList];

    }];
    
    self.tableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        @strongify(self)
        self.pageIndex ++;
        [self requestCommentList];

    }];
//    self.tableView.mj_footer.hidden = YES;

    [self.tableView.mj_header beginRefreshing];
}


#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70 + 80 * screenScales + 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *v = [UIView new];
    v.backgroundColor = [UIColor clearColor];
    return v;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QukanBolingPointListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QukanBolingPointListCellID"];
    
    [cell fullCellWithModel:self.datas[indexPath.section]];
    // 传过去这个视图  用于展示图片预览
    cell.vc_parent = self;
    [cell hideReportBtn:YES];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section > self.datas.count) {
        [self.view showTip:@"数据错误"];
        return;
    }
    
    QukanBolingPointListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    // 跳转详情
    QukanBolingPointDetailVC *vc = [QukanBolingPointDetailVC new];
    vc.hidesBottomBarWhenPushed = YES;
    QukanBolingPointListModel* model = self.datas[indexPath.section];

    model.user_follow = self.otherModel.user_follow;
    vc.model_main = model;
    // 模型信息发生改变
    @weakify(self);
    vc.modelInfoChange = ^{
        @strongify(self);
        [cell fullCellWithModel:self.datas[indexPath.section]];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ===================== QukanBolingPointListCellDelegate ==================================

// 列表点赞
- (void)zanAction:(NSIndexPath *)indexPath andBtn:(UIButton *)btn{
    kGuardLogin
    QukanBolingPointListModel *model = self.datas[indexPath.section];
    NSString *flag = (model.is_like == 1)?@"0":@"1";
    KShowHUD
    [[[kApiManager QukanClickPraiseWithId:[NSNumber numberWithInteger:model.Id] addFlag:flag] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        KHideHUD
        model.is_like = (model.is_like == 0)?1:0;
        btn.selected = !btn.selected;
    } error:^(NSError * _Nullable error) {
        KHideHUD
        [self.view showTip:error.localizedDescription];
    }];
}

// 列表举报
- (void)jubaoAction:(QukanBolingPointListModel *)model {
    
}

// 列表收藏
- (void)collectionAction:(NSIndexPath *)indexPath andBtn:(UIButton *)btn{
    kGuardLogin
    KShowHUD
    QukanBolingPointListModel *model = self.datas[indexPath.section];
    NSString *operation = model.user_follow?@"N":@"Y";
    [[[kApiManager QukanusersFollowWithToUserId:[NSNumber numberWithInteger:model.user_id] addOperation:operation] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        KHideHUD
        model.user_follow = (model.user_follow == 0)?1:0;
        btn.selected = !btn.selected;
    } error:^(NSError * _Nullable error) {
        KHideHUD
        [self.view showTip:error.localizedDescription];
    }];
}

- (void)QukanBolingPointListCellBtnClick:(NSInteger)type andCell:(QukanBolingPointListCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    switch (type) {
        case 0:  // 点赞
            [self zanAction:indexPath andBtn:cell.btn_zan];
            break;
        case 1:  // 举报
            [self jubaoAction:self.datas[indexPath.section]];
            break;
        case 2:  // 收藏
            [self collectionAction:indexPath andBtn:cell.btn_like];
            break;
        case 3:  // 详情
        {

        }
            break;
            
        default:
            break;
    }
}

#pragma mark ------------getter-----------

- (QukanOthersCommentHeader*)headerView{
    if(!_headerView){
        _headerView = [[QukanOthersCommentHeader alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth* 14.0/25) andModel:self.otherModel];
        [self.view addSubview:_headerView];
        @weakify(self)

        _headerView.subscribeBtnClick = ^(QukanBolingPointListModel* model) {
            @strongify(self)
            KShowHUD
            NSString *operation = model.user_follow?@"N":@"Y";
            [[[kApiManager QukanusersFollowWithToUserId:[NSNumber numberWithInteger:model.user_id] addOperation:operation] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
                KHideHUD
                [[NSNotificationCenter defaultCenter] postNotificationName:Qukan_Follow_NotificationName object:nil];
                model.user_follow = (model.user_follow == 0)?1:0;
                [self.headerView updateUI];
            } error:^(NSError * _Nullable error) {
                KHideHUD
                [self.view showTip:error.localizedDescription];
            }];
        };
        _headerView.chatBtnClick = ^(QukanBolingPointListModel* model){
            BOOL chatAva = 1;//[QukanTool Qukan_xuan:k7];
            if(chatAva){
                @strongify(self)
                //私聊用户
                [self makeConversationWithUser:model];
            }
        };
        _headerView.blockBtnClick = ^(QukanBolingPointListModel* model) {
            @strongify(self)
            if(![[QukanFilterManager sharedInstance] isBlockedUser:model.user_id]){
                BlockUserObject*obj = [BlockUserObject new];
                obj.userId = @(model.user_id).stringValue;
                obj.userName = model.username;
                obj.userAvatarUrl = model.user_icon;
                
                [[QukanFilterManager sharedInstance] blockUser:obj];
            }else{
                [[QukanFilterManager sharedInstance] unBlockUser:model.user_id];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kFilterUserNotification object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        };
    }
    return _headerView;
}

#pragma mark ------------private method-----------
- (void)makeConversationWithUser:(QukanBolingPointListModel*)model{
    kGuardLogin
    QukanChatViewController *vc = [[QukanChatViewController alloc] initWithUserId:model.user_id headUrl:model.user_icon];
    vc.hidesBottomBarWhenPushed = YES;
    [vc setChatName:model.username];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)requestCommentList{
    @weakify(self)
    [[[kApiManager QukankanGetDynamicsListUserId:self.otherModel.user_id pageIndex:_pageIndex] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        if([self.tableView.mj_header isRefreshing]){
            [self.tableView.mj_header endRefreshing];
        }
        if([self.tableView.mj_footer isRefreshing]){
            [self.tableView.mj_footer endRefreshing];
        }
        
        @strongify(self)
        if([[x objectForKey:@"curPage"] integerValue] == [[x objectForKey:@"totalPage"] integerValue]){
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        if(self.pageIndex == 1){
            [self.datas removeAllObjects];      //下拉刷新
        }
        NSArray *listArray = [x objectForKey:@"list"];
        for (NSDictionary *dict in listArray) {
            QukanBolingPointListModel *model = [QukanBolingPointListModel  modelWithDictionary:dict];
            if (![[QukanFilterManager sharedInstance] isBlockedUser:model.user_id] &&
                ![[QukanFilterManager sharedInstance] isFilteredComment:model.Id]) {
                [self.datas addObject:model];
            }
        }
        [self.tableView reloadData];
        
    } error:^(NSError * _Nullable error) {
        
        if([self.tableView.mj_header isRefreshing]){
            [self.tableView.mj_header endRefreshing];
        }
        if([self.tableView.mj_footer isRefreshing]){
            [self.tableView.mj_footer endRefreshing];
        }
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void) headerViewTopViewTarget:(NSInteger)tag{
    
}
@end
