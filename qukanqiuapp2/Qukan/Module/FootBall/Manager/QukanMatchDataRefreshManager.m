//
//  QukanMatchDataRefreshManager.m
//  Qukan
//
//  Created by leo on 2019/10/11.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanMatchDataRefreshManager.h"

// 本地保存比赛数据模型
#import "QukanMatchInfoModel.h"

// 比赛即时数据模型(每5秒从后台请求到的数据模型)
#import "QukanMatchImmediatelyDataModel.h"

// 进球或者红牌的提示
#import "QukanRedCardGoalTipsView.h"

// 播放提示音  以及震动手机提示
#import <AudioToolbox/AudioToolbox.h>

#import "QukanApiManager+Competition.h"  // 即时获取关注数据

#define testLog NO

@interface QukanMatchDataRefreshManager ()

// 当前已经获取到的即时的足球比赛
@property(nonatomic, strong) NSMutableArray <QukanMatchInfoContentModel *>  * arr_jishiNeedRefreshList;
// 当前已经获取到的热门正在打的足球比赛
@property(nonatomic, strong) NSMutableArray <QukanMatchInfoContentModel *>  * arr_remengNeedRefreshList;
// 当前已经获取到的赛程的足球比赛
@property(nonatomic, strong) NSMutableArray <QukanMatchInfoContentModel *>  * arr_saichengNeedRefreshList;
// 当前已经获取到的关注的足球比赛
@property(nonatomic, strong) NSMutableArray <QukanMatchInfoContentModel *>  * arr_guangzhuNeedRefreshList;


// 当前已经获取到的所有的正在打的比赛列表   此列表用于判断是否需要提示进球
@property(nonatomic, strong) NSMutableArray <QukanMatchInfoContentModel *>  * arr_allNeedRefreshList;
// 所有已经存储的比赛的id数组
@property(nonatomic, strong) NSMutableArray <NSNumber *>  * arr_allNeedRefreshMatchId;

// 所有从服务器请求到最新状态的比赛
@property(nonatomic, strong) NSMutableArray <QukanMatchImmediatelyDataModel *>  * arr_allSeverImmediateMatch;

// 用于控制每5秒刷新一次的定时器
@property (strong, nonatomic) NSTimer *timer_5s;

// 判断定时器是否在使用
@property (assign, nonatomic ) BOOL  is_timeIng;


@end


@implementation QukanMatchDataRefreshManager

// 单例初始化
+ (instancetype)sharedQukanMatchDataRefreshManager {
    static dispatch_once_t onceToken;
    static QukanMatchDataRefreshManager *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
        instance.is_timeIng = NO;
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.is_timeIng = NO;
        
        // 初始化时监听是否进入后台状态, 若其进入后台状态  停止定时器
        // 除非此单例销毁  则会一直监听下去
        @weakify(self);
        [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * notification) {
            @strongify(self);
            if (testLog) DEBUGLog(@"macthData  程序进入后台  暂停请求");
            
            // 定时暂停
            [self pauseTimer];
        }];
        
        // app进入前台继续监听
        [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationDidBecomeActiveNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * notification) {
            
            @strongify(self);
            // 开始把所有的数据全部删除  然后再开始请求  不然可能一次有很多进球信息进入
            [self.arr_allSeverImmediateMatch removeAllObjects];
            [self.arr_jishiNeedRefreshList removeAllObjects];
            [self.arr_guangzhuNeedRefreshList removeAllObjects];
            [self.arr_allNeedRefreshList removeAllObjects];
            [self.arr_saichengNeedRefreshList removeAllObjects];
            [self.arr_remengNeedRefreshList removeAllObjects];
            
            
        }];
        
    }
    return self;
}

#pragma mark ===================== network ==================================

- (void)initFollowMatch {
    @weakify(self)
    //登录判断
    if (!kUserManager.isLogin) {//未登录
        [self.arr_guangzhuNeedRefreshList removeAllObjects];
        return;
    }
    
    [[[kApiManager QukanAttention_Find_attention] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        //处理
//        [self dataSourceDealWithModel:x];
    } error:^(NSError * _Nullable error) {
    }];
}
//
//- (void)dataSourceDealWithModel:(id)response {
//    // 移除数据刷新工具中对应的模型
//    NSMutableArray *nowArr = [NSMutableArray new];
//    for (NSArray *modelarr in self.datas) {
//        for (QukanMatchInfoContentModel *model1 in modelarr) {
//            if (model1.state >= 1 && model1.state <= 4) {
//                [nowArr addObject:model1];
//            }
//        }
//    }
//    [[QukanMatchDataRefreshManager sharedQukanMatchDataRefreshManager] listRemoveAllData:nowArr andType:3];
//    [self.datas removeAllObjects];
//
//    NSArray *array = (NSArray *)response;
//    NSMutableArray *tempArray = [NSMutableArray array];
//
//    for (NSDictionary  *obj in array) {
//        NSMutableDictionary *indexDict = [NSMutableDictionary dictionary];
//        [indexDict setObject:obj[@"isAttention"] forKey:@"isAttention"];
//        [indexDict setObject:obj[@"matchId"] forKey:@"match_id"];
//        [indexDict setObject:obj[@"bfZqLeague"][@"gb"] forKey:@"league_name"];
//        [indexDict setObject:obj[@"matchTime"] forKey:@"match_time"];
//        [indexDict setObject:obj[@"passTime"] forKey:@"pass_time"];
//        [indexDict setObject:obj[@"bc1"] forKey:@"bc1"];
//        [indexDict setObject:obj[@"bc2"] forKey:@"bc2"];
//        [indexDict setObject:obj[@"corner1"] forKey:@"corner1"];
//        [indexDict setObject:obj[@"corner2"] forKey:@"corner2"];
//        [indexDict setObject:obj[@"bfZqTeamHome"][@"g"] forKey:@"home_name"];
//        [indexDict setObject:obj[@"bfZqTeamAway"][@"gs"] forKey:@"away_name"];
//        [indexDict setObject:obj[@"homeScore"] forKey:@"home_score"];
//        [indexDict setObject:obj[@"awayScore"] forKey:@"away_score"];
//        [indexDict setObject:obj[@"order1"] forKey:@"order1"];
//        [indexDict setObject:obj[@"order2"] forKey:@"order2"];
//        [indexDict setObject:obj[@"red1"] forKey:@"red1"];
//        [indexDict setObject:obj[@"red2"] forKey:@"red2"];
//        [indexDict setObject:obj[@"yellow1"] forKey:@"yellow1"];
//        [indexDict setObject:obj[@"yellow2"] forKey:@"yellow2"];
//        [indexDict setObject:obj[@"bfZqTeamHome"][@"flag"] forKey:@"flag1"];
//        [indexDict setObject:obj[@"bfZqTeamAway"][@"flags"] forKey:@"flag2"];
//        [indexDict setObject:obj[@"state"] forKey:@"state"];
//        [indexDict setObject:obj[@"stateDesb"] forKey:@"start_time"];
//        [indexDict setObject:obj[@"gqLive"] forKey:@"gqLive"];
//        [indexDict setObject:obj[@"dLive"] forKey:@"dLive"];
//        [tempArray addObject:indexDict];
//    }
//
//    NSArray *tempModelArray = [NSArray modelArrayWithClass:[QukanMatchInfoContentModel class] json:tempArray];
//    self.allModels = tempModelArray;
//
//    self.times = [tempModelArray.rac_sequence map:^id _Nullable(QukanMatchInfoContentModel *  _Nullable value) {
//        NSString *time = value.match_time.length > 10 ? [value.match_time substringToIndex:10] : value.match_time;
//        return time;
//    }].array.rac_sequence.distinctUntilChanged.array;
//    self.times = (NSMutableArray *)[[self.times reverseObjectEnumerator] allObjects];
//
//    NSArray *datas = [self.times.rac_sequence map:^id _Nullable(NSString *  _Nullable value) {
//        NSArray *filters = [tempModelArray.rac_sequence filter:^BOOL(QukanMatchInfoContentModel *  _Nullable infoModel) {
//            NSString *time = infoModel.match_time.length > 10 ? [infoModel.match_time substringToIndex:10] : infoModel.match_time;
//            return [value isEqualToString:time];
//        }].array;
//        return filters;
//    }].array;
//
//    [self.datas addObjectsFromArray:datas];
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.Qukan_myTableView.mj_header endRefreshing];
//    });
//
//    for (NSArray *modelarr in self.datas) {
//        for (QukanMatchInfoContentModel *model1 in modelarr) {
//            if (model1.state >= 1 && model1.state <= 4) {
//                [[QukanMatchDataRefreshManager sharedQukanMatchDataRefreshManager] addNeedRefreshData:model1 andType:3];
//            }
//        }
//    }
//
//    [self.Qukan_myTableView reloadData];
//}
//
//




- (void)queryDataFromSevers {
    if (testLog) DEBUGLog(@"macthData正在请求数据");
    // 获取全部正在打的比赛的数据
    [QukanNetworkTool Qukan_GET:@"v3/bf-zq-match/real-time-data" parameters:nil success:^(NSDictionary *response) {
        if ([response[@"status"] integerValue]==200) {
            if ([response[@"data"] isKindOfClass:[NSArray class]]) {
                // 移除本地存储的所有服务器数据
                [self.arr_allSeverImmediateMatch removeAllObjects];
                for (NSDictionary *dic in response[@"data"]) {
                    QukanMatchImmediatelyDataModel *model = [QukanMatchImmediatelyDataModel modelWithDictionary:dic];
                    [self.arr_allSeverImmediateMatch addObject:model];
                }
                
                [self determineIfPromptIsNeeded];
                [self refreshAllChildVC];
            } else {
                if (testLog) DEBUGLog(@"macthData服务器返回错误");
            }
        }
    } failure:^(NSError *error) {
        if (testLog) DEBUGLog(@"macthData数据请求失败");
    }];
}

#pragma mark ===================== function ==================================
// 判断列表数据是否需要刷新
- (void)refreshAllChildVC {
    
    for (int i = 0; i < 4; i ++) {
        // 分别取出四个数组里面全部数据  一一对比
        if ([self getDataArrWithType:i].count) {  // 若该列表没有数据  则不需要进入
            for (QukanMatchImmediatelyDataModel *model_sever in self.arr_allSeverImmediateMatch) {
                for (QukanMatchInfoContentModel *model_local in [self getDataArrWithType:i]) {
                    if (model_sever.match_id == model_local.match_id) {
                        
                       
                        // 更新红牌数据
                        if (model_local.red1 < model_sever.red1 || model_local.red2 < model_sever.red2) {
                            model_local.red1 = model_sever.red1;
                            model_local.red2 = model_sever.red2;
                        }
                        
                        // 更新进球数据
                        if (model_local.home_score < model_sever.home_score || model_local.away_score < model_sever.away_score) {
                            model_local.home_score = model_sever.home_score;
                            model_local.away_score = model_sever.away_score;
                        }
                        
                        // 更新时间
                        if (model_local.pass_time != model_sever.pass_time) {
                            model_local.pass_time = model_sever.pass_time;
                        }
                        
                        // 为了实时监听比赛状态 更新状态
                        if (model_local.state != model_sever.state) {
                            model_local.state = model_sever.state;
                        }
                        
                    }
                }
            }
        }
    }
}

// 判断是否需要弹出进球提示
- (void)determineIfPromptIsNeeded {
    if (testLog) DEBUGLog(@"macthData 开始判断是否需要弹提示");
    
    // 需要进球提示的范围  1 全部  2 关注的比赛  3 全部不需要
    NSString *RangeTips_Shock = [[NSUserDefaults standardUserDefaults] objectForKey:Qukan_RangeTips_Shock_Key];
    if ([RangeTips_Shock isEqualToString:@"3"]) {
        return;
    }
    
    // 红牌提示数组
    NSMutableArray *redkaChangeArr = [NSMutableArray new];
    // 进球提示数组
    NSMutableArray *goalChangeArr = [NSMutableArray new];
    
    for (QukanMatchImmediatelyDataModel *model_sever in self.arr_allSeverImmediateMatch) {
        // 如果不是显示全部的比赛  则只需要遍历已关注的比赛
        for (QukanMatchInfoContentModel *model_local in [RangeTips_Shock isEqualToString:@"1"]?self.arr_allNeedRefreshList:self.arr_guangzhuNeedRefreshList) {
            if (model_sever.match_id == model_local.match_id) {
                // 若红牌数不一样  则加入已改变的数组
                if (model_local.red1 < model_sever.red1 || model_local.red2 < model_sever.red2) {
                    model_local.red1 = model_sever.red1;
                    model_local.red2 = model_sever.red2;
                    [redkaChangeArr addObject:model_local];
                }

                // 若得分发生变化  则加入进球提示数组
                if (model_local.home_score < model_sever.home_score || model_local.away_score < model_sever.away_score) {
                    model_local.home_score = model_sever.home_score;
                    model_local.away_score = model_sever.away_score;
                    [goalChangeArr addObject:model_local];
                }
            }
        }
    }
    
    //若红牌数量改变  或者进球数量改变
    if (redkaChangeArr.count > 0 || goalChangeArr.count > 0) {
        [self showGoalTipsWithRedkaChangeArr:redkaChangeArr andGoldChangeArr:goalChangeArr];
    }else {
        if (testLog) DEBUGLog(@"macthData 数据没有变化  不需要提示");
    }
}

// 弹出进球或者红牌提示
- (void)showGoalTipsWithRedkaChangeArr:(NSMutableArray *)redkaChangeArr andGoldChangeArr:(NSMutableArray *)goalChangeArr {
    if (testLog) DEBUGLog(@"macthData 开始展示提示");
    
    // 进球提示音
    BOOL goalTipsVoice = [[[NSUserDefaults standardUserDefaults] objectForKey:Qukan_GoalTips_Voice_Key] isEqualToString:@"1"];
    // 进球震动效果
    BOOL goalTipsShock = [[[NSUserDefaults standardUserDefaults] objectForKey:Qukan_GoalTips_Shock_Key] isEqualToString:@"1"];
    // 红牌提示音
    BOOL redkaTipsVoice = [[[NSUserDefaults standardUserDefaults] objectForKey:Qukan_RedkaTips_Voice_Key] isEqualToString:@"1"];
    // 红牌震动效果
    BOOL redkaTipsShock = [[[NSUserDefaults standardUserDefaults] objectForKey:Qukan_RedkaTips_Shock_Key] isEqualToString:@"1"];
    
    int i = 0;
    // 展示进球提示
    for (QukanMatchInfoContentModel *model in goalChangeArr) {
        [self showTipsInWindowWithModel:model andIndex:i andType:1];
        
        if (goalTipsVoice) [self playVoice];
        if (goalTipsShock) [self shockPhone];
        
        i++;
        if (i > 4) return;
    }
    
    // 展示红牌提示
    for (QukanMatchInfoContentModel *model in redkaChangeArr) {
        [self showTipsInWindowWithModel:model andIndex:i andType:0];
        if (redkaTipsVoice) [self playVoice];
        if (redkaTipsShock) [self shockPhone];
        
        i++;
        if (i > 4) return;
    }
}

// 在window上显示进球提示
- (void)showTipsInWindowWithModel:(QukanMatchInfoContentModel *)matchMode andIndex:(NSInteger)index andType:(NSInteger)tipType {
    QukanRedCardGoalTipsView *v = [QukanRedCardGoalTipsView Qukan_initWithXib];
    [v Qukan_setData:matchMode isGoalTips:tipType];
    
    UIWindow *window = [[UIApplication sharedApplication] delegate].window;
    [window addSubview:v];
    [window bringSubviewToFront:v];
    
    [v mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(window).mas_offset(20.0);
        make.right.equalTo(window).mas_offset(-20.0);
        make.height.mas_equalTo(80.0);
        make.bottom.mas_equalTo(window.mas_bottom).mas_offset(- index * 85.0 - kBottomBarHeight - 20);
    }];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3 animations:^{
            v.alpha = 0.0;
        } completion:^(BOOL finished) {
            [v removeFromSuperview];
        }];
    });
}


// 播放提示声音
- (void)playVoice {
    SystemSoundID soundID;
    //NSBundle来返回音频文件路径
    NSString *soundFile = [[NSBundle mainBundle] pathForResource:@"Qukan_GoalTips" ofType:@"wav"];
    //建立SystemSoundID对象，但是这里要传地址(加&符号)。 第一个参数需要一个CFURLRef类型的url参数，要新建一个NSString来做桥接转换(bridge)，而这个NSString的值，就是上面的音频文件路径
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:soundFile], &soundID);
    //播放提示音 带震动
    AudioServicesPlaySystemSound(soundID);
}

// 震动手机
- (void)shockPhone {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

#pragma mark ===================== 本地属性数据操作 ==================================
/**添加需要刷新的数组*/
- (void)addNeedRefreshData:(QukanMatchInfoContentModel *)nowMatchModel andType:(NSInteger)type {
    if (!nowMatchModel) {
        return;
    }
    
    // 添加新模型
    [[self getDataArrWithType:type] addObject:nowMatchModel];
    
    // 处理所有数据的列表
    self.arr_allNeedRefreshList = [NSMutableArray new];
    self.arr_allNeedRefreshMatchId = [NSMutableArray new];
    for (int i = 0; i < 4; i ++) {
        // 分别取出四个数组里面全部数据  一一对比
        if ([self getDataArrWithType:i].count) {  // 若该列表没有数据  则不需要进入
            for (QukanMatchInfoContentModel *model_local in [self getDataArrWithType:i]) {
                if (![self.arr_allNeedRefreshMatchId containsObject:@(model_local.match_id)]) {
                    QukanMatchInfoContentModel *m = [model_local copy];
                    [self.arr_allNeedRefreshList addObject:m];
                    [self.arr_allNeedRefreshMatchId addObject:@(model_local.match_id)];
                }
            }
        }
    }
    
    if (testLog) DEBUGLog(@"macthData添加数据  当前需要存储正在比赛的个数为:%zd", self.arr_allNeedRefreshList.count);
    // 本地已有正在打的比赛  开启定时器
    if (self.arr_allNeedRefreshList.count > 0) {
        [self startTimer];
    }
}

/**用户刷新列表或者重新请求数据时 把列表里的数据删除*/
- (void)listRemoveAllData:(NSArray< QukanMatchInfoContentModel *> *)nowMatchList andType:(NSInteger)type {
    if (!nowMatchList.count || ![self getDataArrWithType:type].count) {
        return;
    }
    
    // 处理特定的数据的列表
    for (QukanMatchInfoContentModel *model in nowMatchList) {
        for (QukanMatchInfoContentModel *model1 in [self getDataArrWithType:type]) {
            if (model.match_id == model1.match_id) {
                [[self getDataArrWithType:type] removeObject:model1];
                if (testLog) DEBUGLog(@"macthData 第%zd个数组移除数据  当前需要存储正在比赛的个数为:%zd", type,[self getDataArrWithType:type].count);
                break;
            }
        }
    }
    
    // 处理所有数据的列表
    self.arr_allNeedRefreshList = [NSMutableArray new];
    self.arr_allNeedRefreshMatchId = [NSMutableArray new];
    for (int i = 0; i < 4; i ++) {
        // 分别取出四个数组里面全部数据  一一对比
        if ([self getDataArrWithType:i].count) {  // 若该列表没有数据  则不需要进入
            for (QukanMatchInfoContentModel *model_local in [self getDataArrWithType:i]) {
                if (![self.arr_allNeedRefreshMatchId containsObject:@(model_local.match_id)]) {
                    QukanMatchInfoContentModel *m = [model_local copy];
                    [self.arr_allNeedRefreshList addObject:m];
                    [self.arr_allNeedRefreshMatchId addObject:@(model_local.match_id)];
                }
            }
        }
    }
    
    // 若本地已经没有正在打的比赛了  暂停定时器
    if (self.arr_allNeedRefreshList.count == 0) {
        [self pauseTimer];
    }
}


// 根据type返回某个列表的数据源
- (NSMutableArray *)getDataArrWithType:(NSInteger)type {
    switch (type) {
            case 0:
                return self.arr_remengNeedRefreshList;
            break;
            case 1:
                return self.arr_jishiNeedRefreshList;
            break;
            case 2:
                return self.arr_saichengNeedRefreshList;
            break;
            case 3:
                return self.arr_guangzhuNeedRefreshList;
            break;
            case 4:
                return self.arr_allNeedRefreshList;
            break;
        default:
            break;
    }
    return nil;
}




#pragma mark ===================== 定时器 ==================================
// 开启定时器
- (void)startTimer {
    if (self.is_timeIng || self.arr_allNeedRefreshList.count == 0) return;
    self.is_timeIng = YES;
    if (testLog) DEBUGLog(@"macthData 定时器开始  开始请求");
    [self.timer_5s setFireDate:[NSDate distantPast]];
}

// 暂停定时器
- (void)pauseTimer {
    self.is_timeIng = NO;
    if (testLog) DEBUGLog(@"macthData 定时器停止  中断请求");
    [self.timer_5s setFireDate:[NSDate distantFuture]];
}




#pragma mark ===================== lazy ==================================

// 即时正在打的比赛
- (NSMutableArray<QukanMatchInfoContentModel *> *)arr_jishiNeedRefreshList {
    if (!_arr_jishiNeedRefreshList) {
        _arr_jishiNeedRefreshList = [NSMutableArray new];
    }
    return _arr_jishiNeedRefreshList;
}

// 热门正在打的比赛
- (NSMutableArray<QukanMatchInfoContentModel *> *)arr_remengNeedRefreshList {
    if (!_arr_remengNeedRefreshList) {
        _arr_remengNeedRefreshList = [NSMutableArray new];
    }
    return _arr_remengNeedRefreshList;
}

// 赛程正在打的比赛
- (NSMutableArray<QukanMatchInfoContentModel *> *)arr_saichengNeedRefreshList {
    if (!_arr_saichengNeedRefreshList) {
        _arr_saichengNeedRefreshList = [NSMutableArray new];
    }
    return _arr_saichengNeedRefreshList;
}

// 关注正在打的比赛
- (NSMutableArray<QukanMatchInfoContentModel *> *)arr_guangzhuNeedRefreshList {
    if (!_arr_guangzhuNeedRefreshList) {
        _arr_guangzhuNeedRefreshList = [NSMutableArray new];
    }
    return _arr_guangzhuNeedRefreshList;
}


// 获取到所有需要刷新的数据
- (NSMutableArray<QukanMatchInfoContentModel *> *)arr_allNeedRefreshList {
    if (!_arr_allNeedRefreshList) {
        _arr_allNeedRefreshList = [NSMutableArray new];
    }
    return _arr_allNeedRefreshList;
}


- (NSMutableArray<QukanMatchImmediatelyDataModel *> *)arr_allSeverImmediateMatch {
    if (!_arr_allSeverImmediateMatch) {
        _arr_allSeverImmediateMatch = [NSMutableArray new];
    }
    return _arr_allSeverImmediateMatch;
}

- (NSTimer *)timer_5s {
    if (!_timer_5s) {
        _timer_5s = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(queryDataFromSevers) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer_5s forMode:NSRunLoopCommonModes];
    }
    return _timer_5s;
}

- (NSMutableArray<NSNumber *> *)arr_allNeedRefreshMatchId {
    if (!_arr_allNeedRefreshMatchId) {
        _arr_allNeedRefreshMatchId = [NSMutableArray new];
    }
    return _arr_allNeedRefreshMatchId;
}

@end
