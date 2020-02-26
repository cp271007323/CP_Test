//
//  QukanBolingPointDetailVC.m
//  Qukan
//
//  Created by leo on 2019/10/3.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanBolingPointDetailVC.h"
// 列表cell
#import "QukanBPDetailCommentCell.h"
// 列表模型
#import "QukanBolingPointListModel.h"
// 空视图
// API接口
#import "QukanApiManager+Boiling.h"
// 头部视图
#import "QukanBlingPointDetailHedaerView.h"
// 列表的主模型
#import "QukanBPCommentsModel.h"
// 底部评论框
#import "QukanBPDetailCommentPutInView.h"
// 评论键盘
#import "QukanLXKeyBoard.h"
// 为了控制键盘显示
#import <IQKeyboardManager/IQKeyboardManager.h>
// 举报工具类


@interface QukanBolingPointDetailVC () <UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource, QukanBPDetailCommentCellDelegate>

/**tab*/
@property (nonatomic, strong)UITableView *view_tab;
/**评论数据源*/
@property (nonatomic, strong)NSMutableArray<QukanBPCommentsModel *>  *arr_source;
// 当前的页数
@property(nonatomic,assign)int currentPage;
/**tab头*/
@property(nonatomic, strong) QukanBlingPointDetailHedaerView   * view_tabHeader;
/**底部评论框*/
@property(nonatomic, strong) QukanBPDetailCommentPutInView   * view_bottomComment;

// 评论键盘
@property (nonatomic,strong) QukanLXKeyBoard *keyboard_comment;
@end

@implementation QukanBolingPointDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"话题详情";
    
    [self initUI];
    [self addRefresh];
    
    // 给他个登录通知
    @weakify(self);
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:kUserDidLoginNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        
        [self resetData];
    }];
    
    // 评论举报通知
    [[[kNotificationCenter rac_addObserverForName:kFilterCommentNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        if ([x.object isKindOfClass:[BlockUserObject class]]) {
            [self removeData:x.object];
        }
    }];
    // 拉黑用户通知
    [[[kNotificationCenter rac_addObserverForName:kFilterUserNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        if ([x.object isKindOfClass:[BlockUserObject class]]) {
            [self removeUserComment:x.object];
        }
    }];
    
    // 主贴举报通知
    [[[kNotificationCenter rac_addObserverForName:kFilterNewsNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    IQKeyboardManager *keyboardManager =  [IQKeyboardManager sharedManager];
    keyboardManager.enableAutoToolbar = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    IQKeyboardManager *keyboardManager =  [IQKeyboardManager sharedManager];
    keyboardManager.enableAutoToolbar = YES;
}

- (void)dealloc {
    NSLog(@"话题详情释放 ==================");
}

#pragma mark - function
- (void)initUI {
    
    CGFloat contentHeight = [self.model_main.content heightForFont:[UIFont systemFontOfSize:14] width:kScreenWidth - 30];
    UIView *header = [UIView new];
    header.frame = CGRectMake(0, 0, kScreenWidth, 170 + contentHeight);
    [header addSubview:self.view_tabHeader];
    [self.view_tabHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.equalTo(header);
        make.width.equalTo(@(kScreenWidth));
    }];
    self.view_tab.tableHeaderView = header;
    
    [self.view_tab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view_bottomComment.mas_top);
    }];
    
    [self.view_bottomComment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@(49 + kSafeAreaBottomHeight));
    }];
    
}

- (void)addRefresh {
    @weakify(self);
    self.view_tab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self resetData];
    }];
    
    [self resetData];
}

- (void)resetData {
    self.currentPage = 1;
    [self queryDataFromSever];
}

- (void)addRefreshFooter {
    //重新添加 刷新底部控件
    self.view_tab.mj_footer = nil;
    @weakify(self)
    self.view_tab.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        self.currentPage ++;
        [self queryDataFromSever];
    }];
}

#pragma mark ===================== function ==================================

// 给tab的headerview 赋值
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

// 显示提交成功
- (void)showPublishAlert {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message: FormatString(@"提交成功，请等待%@！",kStStatus.phone) preferredStyle:UIAlertControllerStyleAlert];
   
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    [alertController addAction:action2];
    [self presentViewController:alertController animated:YES completion:nil];
}



#pragma mark - network

// 获取用户评论
- (void)queryDataFromSever {
    KShowHUD
    
    [QukanNetworkTool Qukan_GET:[NSString stringWithFormat:@"v3/comments/%ld", self.model_main.Id] parameters:@{@"type":@"3", @"page_no":[NSNumber numberWithInteger:self.currentPage],@"page_size":@"20"} success:^(NSDictionary *response) {
        KHideHUD
        [self.view_tab.mj_header endRefreshing];
        NSDictionary *x = response[@"data"];
        if ([x objectForKey:@"list"]) {
            if ([[x objectForKey:@"list"] isKindOfClass:[NSArray class]]) {
                [self processSeversDataWith:x];
            }else {
                self.view_tab.mj_footer = nil;
                [self.view showTip:@"数据解析错误"];
            }
        }else {
            self.view_tab.mj_footer = nil;
            [self.view showTip:@"数据解析错误"];
        }
        
    } failure:^(NSError *error) {
        [self.view_tab.mj_header endRefreshing];
    }];
}

// 列表返回数据处理
- (void)processSeversDataWith:(id)x {
    if (self.currentPage == 1) {
        [self.arr_source removeAllObjects];
    }
    
    for (NSDictionary *dic in [x objectForKey:@"list"]) {
        QukanBPCommentsModel *model = [QukanBPCommentsModel modelWithDictionary:dic];
        
        if ([kUserManager isLogin]) {
            for (QukanBPCommentsGreatsModel *m in model.greats) {
                if (m.user_id == kUserManager.user.userId) {
                    model.content.is_like = YES;
                }
            }
        }else {
            model.content.is_like = NO;
        }
        
        model.filterId = model.content.Id;
        model.filterName = model.content.user_name;
        model.filterUserId = model.content.user_id;
        
        // 若他不是在被屏蔽的列表中  则加入数组
        if (![[QukanFilterManager sharedInstance] isFilteredComment:model.content.Id] && !([[QukanFilterManager sharedInstance] isBlockedUser:model.content.user_id])) {
             [self.arr_source addObject:model];
        }
        
        if (model.greats.count < 20) {
            self.view_tab.mj_footer = nil;
        }else {
            [self addRefreshFooter];
            [self.view_tab.mj_footer endRefreshing];
        }
    }
    
    [self.view_tab reloadData];
}

// 评论点赞
- (void)zanAction:(NSIndexPath *)indexPath andBtn:(UIButton *)btn{
    kGuardLogin
    QukanBPCommentsModel *model = self.arr_source[indexPath.row];
    NSString *flag = (model.content.is_like == 1)? @"0":@"1";
    
    [[[kApiManager QukancommentsLikeWithMid:model.content.m_id addInfoId:model.content.Id addFlag:flag] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        model.content.is_like = (model.content.is_like == 1)? 0 : 1;
        if ([flag isEqualToString:@"1"]) {
             model.content.like_count += 1;
        }else {
             model.content.like_count -= 1;
        }
        
        [btn setTitle:[NSString stringWithFormat:@" %zd", model.content.like_count] forState:UIControlStateNormal];
        
        btn.selected = !btn.selected;
    } error:^(NSError * _Nullable error) {
        [self.view showTip:error.localizedDescription];
    }];
}

// 主帖子点赞
- (void)zanMainBP {
    kGuardLogin
    KShowHUD;
    NSString *flag = (self.model_main.is_like == 1)?@"0":@"1";
    [[[kApiManager QukanClickPraiseWithId:[NSNumber numberWithInteger:self.model_main.Id] addFlag:flag] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        KHideHUD
        
        if ([flag isEqualToString:@"1"]) {
            self.model_main.like_count += 1;
            self.model_main.is_like = 1;
        }else {
            self.model_main.like_count -= 1;
            self.model_main.is_like = 0;
        }
        
        [self.view_bottomComment.btn_zan setTitle:[NSString stringWithFormat:@" %zd", self.model_main.like_count] forState:UIControlStateNormal];
        
        self.view_bottomComment.btn_zan.selected = (self.model_main.is_like == 1);
        
        if (self.modelInfoChange) {
            self.modelInfoChange();
        }
        
    } error:^(NSError * _Nullable error) {
        [self.view showTip:error.localizedDescription];
    }];
}


// 主帖子收藏
- (void)collectionActionWithBtn:(UIButton *)btn{
    kGuardLogin
    KShowHUD
    NSString *operation = self.model_main.user_follow?@"N":@"Y";
    [[[kApiManager QukanusersFollowWithToUserId:[NSNumber numberWithInteger:self.model_main.user_id] addOperation:operation] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        KHideHUD
        self.model_main.user_follow = (self.model_main.user_follow == 0)?1:0;
        btn.selected = !btn.selected;
        
        if (self.modelInfoChange) {
            self.modelInfoChange();
        }
    } error:^(NSError * _Nullable error) {
        KHideHUD
        [self.view showTip:error.localizedDescription];
    }];
}

// 主帖子举报
- (void)jubaoMainModelAction {
//      [[QukanFilterManager sharedInstance] showFilterViewWithObject:@(self.model_main.Id).stringValue filterType:QukanFilterTypeUser];
}


// 评论举报
- (void)jubaoComment:(QukanBPCommentsModel *)model {
    kGuardLogin
    BlockUserObject* userObj = [BlockUserObject new];
    userObj.userId = @(model.filterUserId).stringValue;
    userObj.userAvatarUrl = model.content.user_icon;
    userObj.userName = model.content.user_name;
    userObj.extCommentId = @(model.filterId).stringValue;
    [[QukanFilterManager sharedInstance] showFilterViewWithObject:userObj filterType:QukanFilterTypeUserOrComment];
    
//    [[QukanFilterManager sharedInstance] showFilterViewWithObject:@(model.filterId).stringValue filterType: QukanFilterTypeComment];
}


- (void)removeData:(BlockUserObject *)model {
    @synchronized (self.arr_source) {
        //        [self.arr_source removeObject:model];
        id remove = nil;
        for (QukanBPCommentsModel *data in self.arr_source) {
            if (data.content.Id == model.extCommentId.integerValue) {
                remove = data;
            }
        }
        [self.arr_source removeObject:remove];
        [self.view_tab reloadData];
    }
    
    [self.view showTip:@"将减少类似的评论"];
}

- (void)removeUserComment:(BlockUserObject *)model {
    @synchronized (self.arr_source) {
        NSMutableArray* keepDatas = [NSMutableArray array];
        for (QukanBPCommentsModel *data in self.arr_source) {
            if (data.content.user_id != model.userId.integerValue) {
                [keepDatas addObject:data];
            }
        }
        [self.arr_source removeAllObjects];
        [self.arr_source addObjectsFromArray:keepDatas];
        
        [self.view_tab reloadData];
    }
    
    [self.view showTip:@"将减少类似的评论"];
}



#pragma markS - tabviewd代理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QukanBPDetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QukanBPDetailCommentCellID"];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell fullCellWithModel:self.arr_source[indexPath.row]];
    cell.delegate = self;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arr_source.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
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
    kGuardLogin
    if (indexPath.row > self.arr_source.count) {
        [self.view showTip:@"数据错误"];
        return;
    }
    
    QukanBPCommentsModel *model = self.arr_source[indexPath.row];
    self.keyboard_comment.placeholder = [NSString stringWithFormat:@"评论 %@", model.content.user_name];
    [self.keyboard_comment becomeFirstResponder];
    [self.view_tab scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}


#pragma mark ===================== QukanBPDetailCommentCellDelegate ==================================

- (void)QukanBPDetailCommentCellBtnClickType:(NSInteger)type selfCell:(QukanBPDetailCommentCell *)cell {
    NSIndexPath *indexPath = [self.view_tab indexPathForCell:cell];
    
    switch (type) {
        case 0:  // cell点赞
            [self zanAction:indexPath andBtn:cell.btn_zan];
            break;
        case 1:  // cell举报
            [self jubaoComment:self.arr_source[indexPath.row]];
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
    NSString *text = @"当前没有评论哦~";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: kCommonDarkGrayColor};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return self.view_tab.tableHeaderView.frame.size.height / 2;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

#pragma mark - lazy
// 主tab
- (UITableView *)view_tab {
    if (!_view_tab) {
        _view_tab = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        _view_tab.delegate = self;
        _view_tab.dataSource = self;
        
        // 设置空白页显示代理
        _view_tab.emptyDataSetDelegate = self;
        _view_tab.emptyDataSetSource = self;
        
        _view_tab.showsVerticalScrollIndicator = NO;
        _view_tab.showsHorizontalScrollIndicator = NO;
        
        _view_tab.backgroundColor = kCommentBackgroudColor;
        _view_tab.rowHeight = UITableViewAutomaticDimension;
        _view_tab.estimatedRowHeight = 44;
        
        // 滑动隐藏键盘
        _view_tab.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_view_tab registerNib:[UINib nibWithNibName:@"QukanBPDetailCommentCell" bundle:nil] forCellReuseIdentifier:@"QukanBPDetailCommentCellID"];
        
        [self.view addSubview:_view_tab];
    }
    return _view_tab;
}

// tab的头部视图
- (QukanBlingPointDetailHedaerView *)view_tabHeader {
    if (!_view_tabHeader) {
        _view_tabHeader = [QukanBlingPointDetailHedaerView Qukan_initWithXib];
        
        _view_tabHeader.vc_parent = self;
        
        if (self.model_main) {
            [_view_tabHeader fullData:self.model_main];
        }
        
        @weakify(self);
        [[_view_tabHeader rac_signalForSelector:@selector(btn_collectionClick:)] subscribeNext:^(RACTuple * _Nullable x) {
            @strongify(self);
            [self collectionActionWithBtn:self.view_tabHeader.btn_collection];
        }];
        
        [[_view_tabHeader rac_signalForSelector:@selector(btn_jubaoClick:)] subscribeNext:^(RACTuple * _Nullable x) {
            @strongify(self);
            
            [self jubaoMainModelAction];
        }];
    }
    return _view_tabHeader;
}

// 数据源
- (NSMutableArray<QukanBPCommentsModel *> *)arr_source {
    if (!_arr_source) {
        _arr_source = [NSMutableArray new];
    }
    return _arr_source;
}

// 底部评论的视图
- (QukanBPDetailCommentPutInView *)view_bottomComment {
    if (!_view_bottomComment) {
        _view_bottomComment = [QukanBPDetailCommentPutInView Qukan_initWithXib];
        
        _view_bottomComment.btn_zan.selected = (self.model_main.is_like == 1);
        [_view_bottomComment.btn_zan setTitle:[NSString stringWithFormat:@" %zd",self.model_main.like_count] forState:UIControlStateNormal];
        
        @weakify(self);
        // 帖子点赞按钮点击
        [[_view_bottomComment rac_signalForSelector:@selector(btn_zanClick:)] subscribeNext:^(RACTuple * _Nullable x) {
            @strongify(self);
            kGuardLogin
            // 点赞主贴
            [self zanMainBP];
        }];
        
        // 评论点击
        [[_view_bottomComment rac_signalForSelector:@selector(mainViewTap)] subscribeNext:^(RACTuple * _Nullable x) {
            @strongify(self);
            
            kGuardLogin
            self.keyboard_comment.placeholder = @"请输入评论...";
            [self.keyboard_comment becomeFirstResponder];
        }];
        
        [self.view addSubview:_view_bottomComment];
    }
    return _view_bottomComment;
}


- (QukanLXKeyBoard *)keyboard_comment {
    if (!_keyboard_comment) {
        _keyboard_comment =[[QukanLXKeyBoard alloc]initWithFrame:CGRectZero];
        _keyboard_comment.backgroundColor =[UIColor whiteColor];
        _keyboard_comment.maxLine = 3;
        _keyboard_comment.font = [UIFont systemFontOfSize:14];
        _keyboard_comment.topOrBottomEdge = 15;
        [_keyboard_comment beginUpdateUI];
        [self.view addSubview:_keyboard_comment];
        _keyboard_comment.placeholder = @"输入评论...";
        
        @weakify(self);
        _keyboard_comment.sendBlock = ^(NSString *text) {
            @strongify(self);
            [self.keyboard_comment endEditing];
            [self.keyboard_comment clearText];
            
            if (text.length > 0) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [hud hideAnimated:YES afterDelay:1.0f];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self showPublishAlert];
                });
            }
            self.keyboard_comment.placeholder = @"输入评论...";
        };
    }
    return _keyboard_comment;
}


@end



