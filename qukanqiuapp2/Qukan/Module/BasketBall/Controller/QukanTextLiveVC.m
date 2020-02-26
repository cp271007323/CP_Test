//
//  QukanTextLiveVC.m
//  Qukan
//
//  Created by leo on 2019/12/18.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanTextLiveVC.h"
//manager

#import <YYKit/YYKit.h>
// view
#import "QukanTextLiveCell.h"
#import "QukanApiManager+Competition.h"
#import "QukanTextLiveHeaderView.h"
#import "QukanBasketTool.h"

// model
#import "QukanBasketBallMatchModel.h"
#import "QukanTextLiveModel.h"

// 每次拉取的数据的条数
#define Qukan_getMsgNumberOneTime 15

@interface QukanTextLiveVC ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate,NIMChatManagerDelegate, QukanNodeDidClick>

// 列表页
@property(nonatomic, strong) UITableView   * tab_view;
// 数据源
@property(nonatomic, strong) NSMutableArray<NSMutableArray <QukanTextLiveModel *>  *>   * arr_source;
/**背景*/
@property(nonatomic, strong) UIView   * view_background;

/**当前的tab是否处于上方需要滑动*/
@property(nonatomic, assign) BOOL   BOOL_scrollViewContentAtTop;

// im相关
@property(nonatomic, copy) NSString *chatRoomToken;
@property(nonatomic, copy) NSString *roomId;
@property(nonatomic, copy) NSString *accid; // 网易云账号

/**是否需要展示空白页标记*/
@property(nonatomic, assign) BOOL   bool_shouldShowEmpty;

/**空白页展示文本*/
@property(nonatomic, copy) NSString   * str_emptyContent;

@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);

@end

@implementation QukanTextLiveVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"文字直播";
    [self initUI];
    
    // 设置不展示占位图
    self.bool_shouldShowEmpty = NO;
    
    // 只有已完结和正在打的比赛才需要加载直播聊天  否则直接显示空白页
    if (self.model_main.status > 0 || self.model_main.status == -1) {
        [[NIMSDK sharedSDK].chatManager addDelegate:self];
        [self getRoomAccessInfo];
        [self addRefresh];
        self.str_emptyContent = @"暂无文字直播";
    }else {  // 忽略了未开赛突然进入比赛的情况。。。 不做考虑
        self.bool_shouldShowEmpty = YES;
        self.str_emptyContent = @"暂无文字直播";
        [self.tab_view reloadData];
    }
}

- (void)dealloc{
    [[NIMSDK sharedSDK].chatManager removeDelegate:self];
    [[NIMSDK sharedSDK].chatroomManager exitChatroom:self.roomId completion:^(NSError * _Nullable error) {
    }];
}

#pragma mark ===================== initUI ==================================
- (void)initUI {
    [self.view addSubview:self.tab_view];
    [self.tab_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)addRefresh {
    @weakify(self)
//    self.tab_view.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        @strongify(self)
//        self.bool_shouldShowEmpty = NO;
//        [self.tab_view reloadEmptyDataSet];
//        [self pullHistoryMessage];
//    }];
    self.tab_view.mj_header = [QukanHomeRefreshHeader headerWithRefreshingTarget:self
                                                                refreshingAction:@selector(requestDataFromSever)];
    self.tab_view.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        @strongify(self)
        [self pullMoreMessage];
    }];
}
- (void)requestDataFromSever {
    self.bool_shouldShowEmpty = NO;
    [self.tab_view reloadEmptyDataSet];
    [self pullHistoryMessage];
}
- (void)loadView {
    self.view = [[UIView alloc] init];
}

#pragma mark ===================== network ==================================
/// 获取房间信息
- (void)getRoomAccessInfo {
    [self getRoomAddress];
    if (!self.model_main) {
        [SVProgressHUD showErrorWithStatus:@"数据解析错误"];
        return;
    }
    
    @weakify(self)
    KShowHUD;
    NSInteger matchid = self.model_main.matchId.integerValue ? self.model_main.matchId.integerValue : self.matchId.integerValue ;
    [[kApiManager Qukan_getTokenForType:5 matchId: matchid] subscribeNext:^(NSDictionary *  _Nullable x) {
        @strongify(self)
        
        self.roomId = [x stringValueForKey:@"roomid" default:nil];
        self.chatRoomToken = [x stringValueForKey:@"token" default:nil];
        self.accid = [x stringValueForKey:@"accid" default:nil];
        [self connectRoom];
    } error:^(NSError * _Nullable error) {
        KHideHUD
        // 连接房间失败
        NSString *str = [NSString stringWithFormat:@"获取房间信息失败：%@", error];
        [SVProgressHUD showErrorWithStatus:str];
        self.bool_shouldShowEmpty = YES;
        [self.tab_view reloadData];
    }];
}

/// 获取房间地址
- (void)getRoomAddress {
    @weakify(self)
    [NIMChatroomIndependentMode registerRequestChatroomAddressesHandler:^(NSString * _Nonnull roomId, NIMRequestChatroomAddressesCallback  _Nonnull callback) {
        @strongify(self)
        [[kApiManager Qukan_getListAddre:self.roomId andType:5] subscribeNext:^(id  _Nullable x) {
            callback(nil, x);
        } error:^(NSError * _Nullable error) {
            KHideHUD
            callback(error, nil);
        }];
    }];
}

/// 连接房间
- (void)connectRoom {
    // 无需发言  不需展示其他信息  所以不需要设置任何其他字段
    NIMChatroomEnterRequest *request = [[NIMChatroomEnterRequest alloc] init];
    request.roomId = self.roomId;
    
    // 以独立模式连接聊天室  必须不能登录IM   所以进入时必须退出IM
    NIMChatroomIndependentMode *independentModel = [NIMChatroomIndependentMode new];
    independentModel.token = self.chatRoomToken;
    request.mode = independentModel;
    
    @weakify(self)
    [[[NIMSDK sharedSDK] chatroomManager] enterChatroom:request completion:^(NSError *error,NIMChatroom *chatroom,NIMChatroomMember *me) {
         @strongify(self)
         if (error == nil) {
             if (self.arr_source.count == 0) {  // 拉取历史记录
                 [self pullHistoryMessage];
             }
         }
         else {
             // 连接房间失败  失败则显示未开放
             KHideHUD
             self.bool_shouldShowEmpty = YES;
             [self.tab_view reloadData];
         }
     }];
}

/// 拉取历史聊天记录
- (void)pullHistoryMessage {
    NIMHistoryMessageSearchOption *option = [[NIMHistoryMessageSearchOption alloc] init];
    option.startTime = 0;
    option.limit = Qukan_getMsgNumberOneTime;
    
    // 拉取历时记录时把数据清空
    [self.arr_source removeAllObjects];
    
    @weakify(self)
    [[NIMSDK sharedSDK].chatroomManager fetchMessageHistory:self.roomId option:option result:^(NSError *error, NSArray *messages) {
        @strongify(self)
        KHideHUD
        [self.tab_view.mj_header endRefreshing];
        self.bool_shouldShowEmpty = YES;
        if (messages.count > 0) {
             self.view_background.hidden = NO;
            [self insetArrToSelfSourceArr:[NSMutableArray arrayWithArray:messages] andMoreOrNews:NO];
            
            if (messages.count < Qukan_getMsgNumberOneTime) {
                [self.tab_view.mj_footer endRefreshingWithNoMoreData];
            }else {
                self.tab_view.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                    @strongify(self)
                    [self pullMoreMessage];
                }];
            }
        }else {
            NSLog(@"没有历史记录");
        }
        
        [self.tab_view reloadData];
    }];
}

// 获取更多记录
- (void)pullMoreMessage {
    NIMHistoryMessageSearchOption *option = [[NIMHistoryMessageSearchOption alloc] init];
    // 开始时间设置为 最后一条数据的消息时间 （-1 为了避免最后一条数据被加载）
    option.startTime = self.arr_source.lastObject.lastObject.msgTime - 1;
    option.limit = Qukan_getMsgNumberOneTime;
    option.order = NIMMessageSearchOrderDesc;
    
    @weakify(self)
    [[NIMSDK sharedSDK].chatroomManager fetchMessageHistory:self.roomId option:option result:^(NSError *error, NSArray *messages) {
        @strongify(self)
        if (messages.count > 0) {
            [self insetArrToSelfSourceArr:[NSMutableArray arrayWithArray:messages] andMoreOrNews:YES];
            
            if (messages.count < Qukan_getMsgNumberOneTime) {
                [self.tab_view.mj_footer endRefreshingWithNoMoreData];
            }else {
                [self.tab_view.mj_footer endRefreshing];
            }
        }else {
            [self.tab_view.mj_footer endRefreshingWithNoMoreData];
            NSLog(@"没有记录");
        }
        
        [self.tab_view reloadData];
    }];
}

- (QukanTextLiveModel *)getTextLiveModelFromMessage:(NIMMessage *)msg {
    if (msg.text.length > 0) {
        QukanTextLiveModel *m = [QukanTextLiveModel modelWithJSON:msg.text];
        m.msgTime = msg.timestamp;
        return m;
    }
    return nil;
}



/**
 往数据源里面插入数据

 @param arrM_msgs 需要插入的信息数组
 @param isMore 是否是加载更多时插入的数据
 */
- (void)insetArrToSelfSourceArr:(NSMutableArray<NIMMessage *> *)arrM_msgs andMoreOrNews:(BOOL)isMore{
    BOOL bool_haveNoData = self.arr_source.count == 0;
    
    // 把所有的消息数据转化为本地的文字直播模型
    NSMutableArray<QukanTextLiveModel *> *arr_textLive = [NSMutableArray new];
    for (NIMMessage *msg in arrM_msgs) {
        QukanTextLiveModel *model = [self getTextLiveModelFromMessage:msg];
        if (model) {
          [arr_textLive addObject:model];
        }
    }
    
    // 把这些模型根据recordId排序
    NSArray *resultArr = [arr_textLive sortedArrayUsingComparator:^NSComparisonResult(QukanTextLiveModel* obj1, QukanTextLiveModel  *obj2) {
        NSComparisonResult result = [obj1.recordId compare:obj2.recordId];
         if (isMore) {
             return result == NSOrderedAscending;  // 降序
         }else {
             return result == NSOrderedDescending; // 升序
         }
    }];
    
    
    // 把所有数据添加上去
    for (QukanTextLiveModel *m in resultArr) {
        BOOL bool_haveThisState = NO;   // 是否有当前的分组
        for (NSMutableArray<QukanTextLiveModel *> *liveMarr in self.arr_source) {  // 遍历所有本地数组
            if ([liveMarr.firstObject.status isEqualToString:m.status]) {
                bool_haveThisState = YES;
                if (isMore) {
                    [liveMarr addObject:m];
                }else {
                    [liveMarr insertObject:m atIndex:0];
                }
                break;
            }
        }
        if (!bool_haveThisState) {
            NSMutableArray<QukanTextLiveModel *> *arr_current = [NSMutableArray new];
            [arr_current addObject:m];
            [self.arr_source addObject:arr_current];
        }
    }
    
    // 章节数组根据state来排序
    NSArray *resultArr1 = [self.arr_source sortedArrayUsingComparator:^NSComparisonResult(NSMutableArray <QukanTextLiveModel *>* obj1, NSMutableArray <QukanTextLiveModel *>* obj2) {
        NSComparisonResult result = [obj1.firstObject.status compare:obj2.firstObject.status];
//        return result == NSOrderedDescending; // 升序
        return result == NSOrderedAscending;  // 降序
    }];
    
    self.arr_source = resultArr1.mutableCopy;
    
    if (bool_haveNoData) [self.tab_view reloadData];
}

// 根据信息判断信息所在的位置
- (NSMutableArray<NSIndexPath *> *)getSelfMsgIndexsFromMeeages:(NSMutableArray<NIMMessage *> *)arrM_msg {
    NSMutableArray *arrM = [NSMutableArray new];
    for (int i = 0; i < arrM_msg.count; i ++) {
        for (int j = 0; j < self.arr_source.count; j++) {
            for (int k = 0; k < self.arr_source[j].count; k ++) {
                QukanTextLiveModel *model = [self getTextLiveModelFromMessage:arrM_msg[i]];
                if ([self.arr_source[j][k].recordId isEqualToString:model.recordId]) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:k inSection:j];
                    [arrM addObject:indexPath];
                    break;
                }
            }
        }
    }
    return arrM;
}


#pragma mark ===================== JXCategoryListContainerViewDelegate ==================================

- (UIView *)listView{
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.tab_view;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback ?: self.scrollCallback(self.tab_view);
}


#pragma mark  ===================== Table view data source  ==========================================

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.arr_source.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arr_source[section].count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QukanTextLiveCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QukanTextLiveCellID"];
    if (!cell) {
        cell = [[QukanTextLiveCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QukanTextLiveCellID"];
    }
    
    [cell fullCellWithModel:self.arr_source[indexPath.section][indexPath.row] andmatchModel:self.model_main];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    QukanTextLiveModel *m = self.arr_source[indexPath.section][indexPath.row];
    CGFloat conetnW = 0;
    if ([m.xtype isEqualToString:@"3"]) {  // 若非主客队信息
        conetnW = kScreenWidth - 75;
    }else {
        conetnW = kScreenWidth - 125;
    }
    CGFloat h = [m.content heightForFont:kFont14 width:conetnW];
    
    return 53 + h;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    QukanTextLiveHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"QukanTextLiveHeaderViewID"];
    if(!header){
        header = [[QukanTextLiveHeaderView alloc] initWithReuseIdentifier:@"QukanTextLiveHeaderViewID"];
        header.delegate = self;
    }
    QukanTextLiveModel *m = self.arr_source[section].firstObject;
    NSString *text = [NSString stringWithFormat:@"   %@ %@-%@  ",[[QukanBasketTool sharedInstance] qukan_getStateStrFromState:m.status.integerValue], m.awayScore,m.homeScore];
    [header.lab_content setTitle:text forState:UIControlStateNormal];
    
    header.backgroundColor = UIColor.clearColor;
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return UIView.new;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if ([view isMemberOfClass:[QukanTextLiveHeaderView class]]) {
        ((UITableViewHeaderFooterView *)view).backgroundView.backgroundColor = [UIColor clearColor];
    }
}

#pragma mark ===================== NIMChatManagerDelegate ==================================

/**
 *  收到消息回调
 *
 *  @param messages 消息列表,内部为NIMMessage
 */
- (void)onRecvMessages:(NSArray<NIMMessage *> *)messages {
    // 篮球文字直播以5_开头  筛选出来  避免错误数据
    NSArray *filterMessage = [messages.rac_sequence filter:^BOOL(NIMMessage *  _Nullable value) {
        return  [value.from containsString:@"5_"];
    }].array;
    
    if (filterMessage.count > 0) {
        // 必须在前面判断是否处于顶部  否则后面插入cell的时候会contentoffset变化
        BOOL isTop = [self BOOL_scrollViewContentAtTop];
        // 记录之前的contentsize 和contentoffset
        CGSize beforeContentSize = self.tab_view.contentSize;
        CGPoint beforeContentOffset = self.tab_view.contentOffset;
        
        [UIView setAnimationsEnabled:NO];
        [self.tab_view beginUpdates];
        
        NSInteger beforCount = self.arr_source.count;
        // 将模型全部插入数据源中
        [self insetArrToSelfSourceArr:[NSMutableArray arrayWithArray:filterMessage] andMoreOrNews:NO];
        
        NSMutableArray *indexPaths = [self getSelfMsgIndexsFromMeeages:filterMessage.mutableCopy];
        if (self.arr_source.count != beforCount) {
            [self.tab_view insertSection:0 withRowAnimation:UITableViewRowAnimationNone];
        }else {
            [self.tab_view insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
        }
        
        [self.tab_view endUpdates];
        [UIView setAnimationsEnabled:YES];
        
        // 插入数据后得到之后的contensize和contentoffset
        CGSize afterContentSize = self.tab_view.contentSize;
        CGPoint afterContentOffset = self.tab_view.contentOffset;
        
        // 获取到tableview应当滑到的位置 然后设置  这样就像根本没有滑动一样
        CGPoint newContentOffset = CGPointMake(afterContentOffset.x, beforeContentOffset.y + (afterContentSize.height - beforeContentSize.height));
        [self.tab_view setContentOffset:newContentOffset animated:NO];
        
        // 每次收到数据后刷新头部视图
        [self refreshHeader];
        
        // 若当前处于顶部  则需要自动往下滑
        if (isTop) [self gotoTopRow:YES];
    }
}

- (void)refreshHeader {
    QukanTextLiveHeaderView *header = (QukanTextLiveHeaderView *)[self.tab_view headerViewForSection:0];
    if(!header){
        return;
    }
    QukanTextLiveModel *m = self.arr_source[0].firstObject;

    NSString *text = [NSString stringWithFormat:@"   %@ %@-%@  ",[[QukanBasketTool sharedInstance] qukan_getStateStrFromState:m.status.integerValue], m.awayScore,m.homeScore];
    [header.lab_content setTitle:text forState:UIControlStateNormal];

    self.model_main.homeScore = m.homeScore;
    self.model_main.awayScore = m.awayScore;
    self.model_main.status = m.status.intValue;
    self.model_main.remainTime = m.remainTime;
}

- (void)gotoTopRow:(BOOL)animated {
    dispatch_block_t scrollTopBlock = ^ {
        [self.tab_view scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:animated];
    };
    if (animated) {
        //when use `estimatedRowHeight` and `scrollToRowAtIndexPath` at the same time, there are some issue.
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            scrollTopBlock();
        });
    } else {
        scrollTopBlock();
    }
}

#pragma mark ===================== DZNEmptyDataSetSource ==================================
// 占位图提示文本
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *description = self.str_emptyContent;
    return [[NSAttributedString alloc] initWithString:description attributes:@{NSFontAttributeName : kFont16,NSForegroundColorAttributeName : [UIColor grayColor]}];
}
// 占位图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *imageName = @"nodata_basketBall";
    return [UIImage imageNamed:imageName];
}
// 占位图点击效果
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    //    [self Qukan_requestData];
//    [self.Qukan_myTableView.mj_header beginRefreshing];
    
    self.bool_shouldShowEmpty = NO;
    [self.tab_view reloadEmptyDataSet];
    
    [self getRoomAccessInfo];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return kCommentBackgroudColor;
}

//- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
//    return -kScreenWidth*(212/375.0) / 2;
//}

#pragma mark ===================== DZNEmptyDataSetDelegate ==================================
// 占位图是否能滑动
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}
// 占位图是否能点击
- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    return YES;
}
// 占位图是否需要展示
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return self.bool_shouldShowEmpty;
}

- (void)emptyDataSetWillAppear:(UIScrollView *)scrollView {
    self.view_background.hidden = YES;
}

- (void)emptyDataSetWillDisappear:(UIScrollView *)scrollView {
    self.view_background.hidden = NO;
}

#pragma mark ===================== getter ==================================
- (UITableView *)tab_view {
    if (!_tab_view) {
        
        _tab_view = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _tab_view.emptyDataSetSource = self;
        _tab_view.emptyDataSetDelegate = self;
        
        _tab_view.dataSource = self;
        _tab_view.delegate = self;
        
        _tab_view.backgroundColor = kCommonWhiteColor;
        _tab_view.backgroundView = self.view_background;
        
        _tab_view.estimatedRowHeight = 0.0f;
        _tab_view.estimatedSectionFooterHeight = 0.0f;
        _tab_view.estimatedSectionHeaderHeight = 0.0f;
        
        [_tab_view registerClass:[QukanTextLiveCell class] forCellReuseIdentifier:@"QukanTextLiveCellID"];
        [_tab_view setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
    }
    return _tab_view;
}

- (NSMutableArray<NSMutableArray <QukanTextLiveModel *>  *> *)arr_source {
    if (!_arr_source) {
        _arr_source = [NSMutableArray new];
    }
    return _arr_source;
}

- (UIView *)view_background {
    if (!_view_background) {
        _view_background = [UIView new];
        UIView *view_line = [UIView new];
        _view_background.hidden = YES;
        view_line.backgroundColor = HEXColor(0xe3e3e3);
        [_view_background addSubview:view_line];
        [view_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view_background).offset(25);
            make.top.bottom.equalTo(self.view_background);
            make.width.equalTo(@(1));
        }];
    }
    return _view_background;
}


- (BOOL)BOOL_scrollViewContentAtTop {
    CGFloat height = 15;
    return self.tab_view.contentOffset.y <= height;
}

#pragma mark ===================== delegate ==================================

- (void)QukanNodeDidClick:(UIButton *)btn {
    [self gotoTopRow:YES];
}



@end
