//
//  QukanBoilingPointChildVC.m
//  Qukan
//
//  Created by leo on 2019/10/3.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanBoilingPointListVC.h"
// 列表cell
#import "QukanBolingPointListCell.h"
// 列表模型
#import "QukanBolingPointListModel.h"
// 空视图
// API接口
#import "QukanApiManager+Boiling.h"
// 推荐列表时的头部
#import "QukanBolingPointHeaderView.h"
// 详情界面
#import "QukanBolingPointDetailVC.h"
// 没有登录时显示的视图   只有动态界面未登录时展示
#import "QukanNotLoginView.h"

// 点击头像时查看其他用户
#import "QukanOthersInfoTableViewVC.h"

@interface QukanBoilingPointListVC () <UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource, QukanBolingPointListCellDelegate>

/**tab*/
@property (nonatomic, strong)UITableView *view_tab;
/**数据源*/
@property (nonatomic, strong)NSMutableArray<QukanBolingPointListModel *>  *arr_source;
// 当前的页数
@property(nonatomic,assign)int currentPage;

/**tab头*/
@property(nonatomic, strong) QukanBolingPointHeaderView   * view_tabHeader;



@end

@implementation QukanBoilingPointListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
    [self addRefresh];
    
    // 若是推荐  获取热门信息
    if (self.type_vcList == boilingPointListTypeRecommended) {
        [self getHeaderData];
    }
    
    // 给他个登录通知
    @weakify(self);
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:kUserDidLoginNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        
        [QukanNotLoginView hideWithWiew:self.view];
        self.currentPage = 1;
        [self queryDataFromSever];
    }];
    
    // 给他个退出登录通知
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:kUserDidLogoutNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        // 未登录状态的处理方法
        [self noLoginAction];
    }];
    
    // 拉黑用户
    [[[kNotificationCenter rac_addObserverForName:kFilterUserNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        if ([x.object isKindOfClass:[BlockUserObject class]]) {
            BlockUserObject*obj = x.object;
            [self removeDataWithUserId:obj.userId.integerValue];
        }
    }];
    
    // 举报评论
    [[[kNotificationCenter rac_addObserverForName:kFilterCommentNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        if ([x.object isKindOfClass:[BlockUserObject class]]) {
            BlockUserObject*obj = x.object;
            [self removeDataWithCommentId:obj.extCommentId.integerValue];
        }
    }];
}

#pragma mark - function
- (void)initUI {
    [self.view_tab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
}

- (void)addRefresh {
    @weakify(self);
    self.view_tab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.currentPage = 1;
        [self queryDataFromSever];
    }];
    
    if (self.type_vcList == boilingPointListTypeDynamic && ![kUserManager isLogin]) {
        [QukanNotLoginView showWithView:self.view];
    }else {
        self.currentPage = 1;
        [self queryDataFromSever];
    }
}

- (void)addRefreshFoot {
    //重新添加 刷新底部控件
    self.view_tab.mj_footer = nil;
    self.view_tab.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.currentPage ++;
        [self queryDataFromSever];
    }];
}

- (void)noLoginAction {
    if (self.type_vcList == boilingPointListTypeDynamic && ![kUserManager isLogin]) {
        [QukanNotLoginView showWithView:self.view];
    }
}

#pragma mark ===================== function ==================================

- (void)setTabHeaderWithModel:(QukanBolingPointListModel *)model {
    if (model) {
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
        [header addSubview:self.view_tabHeader];
        [self.view_tabHeader mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.equalTo(header);
            make.width.equalTo(@(kScreenWidth));
        }];
        
        [self.view_tabHeader fullData:model];
        self.view_tab.tableHeaderView = header;
    }else {
        self.view_tab.tableHeaderView = nil;
    }
}


#pragma mark ===================== Private Methods =========================

//- (void)removeData:(QukanBolingPointListModel *)model {
//    @synchronized (self.arr_source) {
//        id remove = nil;
//        for (QukanBolingPointListModel *data in self.arr_source) {
//            if (data.filterUserId == model.filterUserId) {
//                remove = data;
//            }
//        }
//        [self.arr_source removeObject:remove];
//        [self.view_tab reloadData];
//    }
//
//    [self.view showTip:@"将减少类似的内容推荐"];
//}

- (void)removeDataWithUserId:(NSInteger)userId {
    @synchronized (self.arr_source) {
        NSMutableArray* removeArray = @[].mutableCopy;
        for (QukanBolingPointListModel *data in self.arr_source) {
            if (data.user_id == userId) {
                [removeArray addObject:data];
            }
        }
        if(removeArray.count){
            [self.arr_source removeObjectsInArray:removeArray];
            [self.view_tab reloadData];
        }
    }
    
    [self.view showTip:@"将减少类似的内容推荐"];
}

- (void)removeDataWithCommentId:(NSInteger)commentId {
    @synchronized (self.arr_source) {
        id remove = nil;
        for (QukanBolingPointListModel *data in self.arr_source) {
            if (data.filterId == commentId) {
                remove = data;
                break;
                
            }
        }
        [self.arr_source removeObject:remove];
        [self.view_tab reloadData];
    }
    
    [self.view showTip:@"将减少类似的内容推荐"];
}

#pragma mark - network
// 获取顶部热门沸点
- (void)getHeaderData {
    [QukanNetworkTool Qukan_GET:@"v3/posts/postTop" parameters:nil success:^(NSDictionary *response) {
        if ([response isKindOfClass:[NSDictionary class]]) {
            if ([response[@"data"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = (NSDictionary *)response[@"data"];
                QukanBolingPointListModel *model = [QukanBolingPointListModel modelWithDictionary:dict];
                [self setTabHeaderWithModel:model];
            }else {
                [self setTabHeaderWithModel:nil];
            }
        }else {
            [self setTabHeaderWithModel:nil];
        }
    } failure:^(NSError *error) {
        [self setTabHeaderWithModel:nil];
        [self.view showTip:error.localizedDescription];
    }];
}


// 获取列表信息
- (void)queryDataFromSever {
    @weakify(self)
    KShowHUD
    NSString *listType = @"3";
    if (self.type_vcList == boilingPointListTypeDynamic) {
        listType = @"4";
    }
    
    [[[kApiManager QukanDynamicsWithType:listType addPage_no:[NSNumber numberWithInteger:self.currentPage] addPage_size:@"20"] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        KHideHUD
        [self.view_tab.mj_header endRefreshing];
       
        if ([x objectForKey:@"list"]) {
            if ([[x objectForKey:@"list"] isKindOfClass:[NSArray class]]) {
                NSArray *arr = [x objectForKey:@"list"];
                if (arr.count < 20) {
                    [self addRefreshFoot];
                    [self.view_tab.mj_footer endRefreshingWithNoMoreData];
                }else {
                    [self addRefreshFoot];
                    [self.view_tab.mj_footer endRefreshing];
                }
                [self processSeversDataWith:x];
            }else {
                self.view_tab.mj_footer = nil;
                [self.view showTip:@"数据解析错误"];
            }
        }else {
            self.view_tab.mj_footer = nil;
            [self.view showTip:@"数据解析错误"];
        }
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        KHideHUD
        [self.view_tab.mj_header endRefreshing];
        self.view_tab.mj_footer = nil;
    }];
}

// 列表返回数据处理
- (void)processSeversDataWith:(id)x {
    if (self.currentPage == 1) {
        [self.arr_source removeAllObjects];
    }
    
    for (NSDictionary *dic in [x objectForKey:@"list"]) {
        QukanBolingPointListModel *model = [QukanBolingPointListModel modelWithDictionary:dic];
        
        model.filterUserId = model.user_id;
        model.filterName = model.username;
        model.filterId = model.Id;
        
        // 若他不是在被屏蔽的列表中  则加入数组
        if (![[QukanFilterManager sharedInstance] isFilteredComment:model.Id] &&
            ![[QukanFilterManager sharedInstance] isBlockedUser:model.user_id]) {
            
             [self.arr_source addObject:model];
        }
    }
    
    [self.view_tab reloadData];
}

// 列表点赞
- (void)zanAction:(NSIndexPath *)indexPath andBtn:(UIButton *)btn{
    QukanBolingPointListModel *model = self.arr_source[indexPath.section];
    NSString *flag = (model.is_like == 1)?@"0":@"1";
    KShowHUD
    [[[kApiManager QukanClickPraiseWithId:[NSNumber numberWithInteger:model.Id] addFlag:flag] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        KHideHUD
        model.is_like = (model.is_like == 0)?1:0;
        if (model.is_like == 1) {
            model.like_count = model.like_count + 1;
        } else {
            model.like_count = model.like_count - 1;
        }
        btn.selected = !btn.selected;
    } error:^(NSError * _Nullable error) {
        KHideHUD
        [self.view showTip:error.localizedDescription];
    }];
}

// 列表举报
- (void)jubaoAction:(QukanBolingPointListModel *)model {
    
    BlockUserObject* userObj = [BlockUserObject new];
    userObj.userId = @(model.user_id).stringValue;
    userObj.userAvatarUrl = model.user_icon;
    userObj.userName = model.username;
    userObj.extCommentId = @(model.Id).stringValue;
    [[QukanFilterManager sharedInstance] showFilterViewWithObject:userObj filterType:QukanFilterTypeUserOrComment];


}

// 列表收藏
- (void)collectionAction:(NSIndexPath *)indexPath andBtn:(UIButton *)btn{
    KShowHUD
    QukanBolingPointListModel *model = self.arr_source[indexPath.section];
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

#pragma mark ===================== <JXCategoryListContainerViewDelegate> ==================================

- (UIView *)listView{
    return self.view;
}


#pragma mark - tabviewd代理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QukanBolingPointListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QukanBolingPointListCellID"];

    [cell fullCellWithModel:self.arr_source[indexPath.section]];
    // 传过去这个视图  用于展示图片预览
    cell.vc_parent = self;
    cell.delegate = self;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.arr_source.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70 + 80 * screenScales + 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
   return 0.001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *header = [UIView new];
    header.backgroundColor = kCommentBackgroudColor;
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
   return [UIView new];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section > self.arr_source.count) {
        [self.view showTip:@"数据错误"];
        return;
    }
    
    QukanBolingPointListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    // 跳转详情
    QukanBolingPointDetailVC *vc = [QukanBolingPointDetailVC new];
    vc.hidesBottomBarWhenPushed = YES;
    vc.model_main = self.arr_source[indexPath.section];
    // 模型信息发生改变
    @weakify(self);
    vc.modelInfoChange = ^{
        @strongify(self);
        [cell fullCellWithModel:self.arr_source[indexPath.section]];
    };
    [self.nav_superVC pushViewController:vc animated:YES];
}


#pragma mark ===================== QukanBolingPointListCellDelegate ==================================

- (void)QukanBolingPointListCellBtnClick:(NSInteger)type andCell:(QukanBolingPointListCell *)cell {
    NSIndexPath *indexPath = [self.view_tab indexPathForCell:cell];
    kGuardLogin
    switch (type) {
        case 0:  // 点赞
            [self zanAction:indexPath andBtn:cell.btn_zan];
            break;
        case 1:  // 举报
            [self jubaoAction:self.arr_source[indexPath.section]];
            break;
        case 2:  // 收藏
            [self collectionAction:indexPath andBtn:cell.btn_like];
            break;
        case 3:  // 详情
          
            {
                BOOL chatAva = 1;//[QukanTool Qukan_xuan:k7];
                if(chatAva){
                    QukanBolingPointListModel*model = self.arr_source[indexPath.section];
                    QukanOthersInfoTableViewVC* vc = [[QukanOthersInfoTableViewVC alloc]initWithModel:model];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.nav_superVC pushViewController:vc animated:YES];
                    
                }
            }
            break;
            
        default:
            break;
    }
}

#pragma mark - DZNEmptyDataSetDelegate,DZNEmptyDataSetSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"Qukan_Null_Data"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无数据";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: kCommonDarkGrayColor};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return self.view_tab.tableHeaderView.frame.size.height / 2;
}


- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return kCommentBackgroudColor;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

#pragma mark - lazy
- (UITableView *)view_tab {
    if (!_view_tab) {
        _view_tab = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        _view_tab.delegate = self;
        _view_tab.dataSource = self;
        
        _view_tab.emptyDataSetDelegate = self;
        _view_tab.emptyDataSetSource = self;
        
        _view_tab.showsVerticalScrollIndicator = NO;
        _view_tab.showsHorizontalScrollIndicator = NO;
        
        _view_tab.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_view_tab registerNib:[UINib nibWithNibName:@"QukanBolingPointListCell" bundle:nil] forCellReuseIdentifier:@"QukanBolingPointListCellID"];
        
        [self.view addSubview:_view_tab];
    }
    return _view_tab;
}

- (QukanBolingPointHeaderView *)view_tabHeader {
    if (!_view_tabHeader) {
        _view_tabHeader = [QukanBolingPointHeaderView Qukan_initWithXib];
    }
    return _view_tabHeader;
}

- (NSMutableArray<QukanBolingPointListModel *> *)arr_source {
    if (!_arr_source) {
        _arr_source = [NSMutableArray new];
    }
    return _arr_source;
}
@end


