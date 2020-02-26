#import "QukanMatchSituationViewController.h"
#import "QukanMatchSituationEventHeaderView.h"
#import "QukanMatchSituationEventCell.h"
#import "QukanGDataView.h"
#import "QukanApiManager+info.h"

#import "QukanApiManager+Competition.h"
#import "QukanMatchOnlyOneImgCellTableViewCell.h"
// 赛况

//新cell
#import "QukanStrokeAnalysisTableViewCell.h"

#import "QukanMatchTabSectionHeaderView.h"
//比赛未开始的提示cell
#import "QukanMatchEventNoStartTableViewCell.h"
//技术统计的h战队信息cell
#import "QukanAnalysisHeaderTableViewCell.h"

@interface QukanMatchSituationViewController ()<UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UITableView                 *Qukan_myTableView;
@property (nonatomic, strong) NSMutableArray              *Qukan_statisticsArray;
@property (nonatomic, strong) NSMutableArray              *Qukan_eventArray;
@property (nonatomic, strong) QukanGDataView         *Qukan_gView;
@property (nonatomic, strong) QukanHomeModels            *model;

// 用于滑动回调
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);

@end

@implementation QukanMatchSituationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getADId];
    self.Qukan_myTableView.mj_header = [QukanHomeRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(Qukan_refreshData)];
    KShowHUD;
    [self Qukan_refreshData];
    
    @weakify(self)
    [RACObserve(self.Qukan_model, state) subscribeNext:^(id x) {
        @strongify(self)
        if (self.Qukan_model.state == 1) {//从未开始变成开始
            [self Qukan_refreshData];
        }
    }];

}

- (void)loadView {
    [super loadView];
    self.view = [[UIView alloc] init];
}

- (BOOL)shouldAutorotate {  // 控制转屏
    return  YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)getADId {
    @weakify(self)
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [[[kApiManager QukanFetchMachId:[NSString stringWithFormat:@"%ld",self.Qukan_model.match_id]] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        
        if ([x isKindOfClass:[NSDictionary class]]) {
            if ([[x allKeys] containsObject:@"phpAdvId"]) {
            NSInteger phpAdvId = [x intValueForKey:@"phpAdvId" default:0];
            
            [userDefaults setObject:@(phpAdvId) forKey:@"phpAdvId"];
            [userDefaults synchronize];
            
            [self Qukan_newsChannelHomepWithAd:phpAdvId];
            } else {
                [userDefaults removeObjectForKey:@"phpAdvId"];
                [self qukanAD];
            }
        }
    } error:^(NSError * _Nullable error) {
        [userDefaults removeObjectForKey:@"phpAdvId"];
        [self qukanAD];
    }];
}
#pragma mark ===================== NetWork ==================================
- (void)Qukan_refreshData {
    @weakify(self)
    [[[kApiManager QukanMatchFindAllByMatchIdWithMatchId:[NSString stringWithFormat:@"%ld", self.Qukan_matchId]] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        [self.Qukan_myTableView.mj_header endRefreshing];
        @strongify(self)
        KHideHUD
        if (self.refreshEndBolck) {
            self.refreshEndBolck();
        }
        [self dataSourceDealWith:x];
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        KHideHUD
        [self.Qukan_myTableView.mj_header endRefreshing];
        if (self.Qukan_statisticsArray.count==0) {
            [QukanFailureView Qukan_showWithView:self.view centerY:-180.0  block:^{
                [self Qukan_netWorkClickRetry];
            }];
        }
    }];
}
- (void)qukanAD {
    @weakify(self)
    [[[kApiManager QukanInfoWithType:24] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self dataSourceWith:x];
        
    }];
}
- (void)dataSourceDealWith:(id)response {
    NSArray *bfZqEvents = (NSArray *)response[@"bfZqEvents"];
    [self.Qukan_eventArray removeAllObjects];
    for (NSDictionary *a in bfZqEvents) {
        @autoreleasepool {
            [self.Qukan_eventArray addObject:a];
        }
    }

    self.Qukan_eventArray = [NSMutableArray arrayWithArray:[self.Qukan_eventArray sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *dic1, NSDictionary *dic2) {
        NSComparisonResult result = [@([[dic2 objectForKey:@"time"] integerValue]) compare:@([[dic1 objectForKey:@"time"] integerValue])];
        return result;
    }]];
    
    self.Qukan_eventArray = (NSMutableArray *) [[self.Qukan_eventArray reverseObjectEnumerator] allObjects];
    
    NSDictionary *bfZqTechnic = (NSDictionary *)response[@"bfZqTechnic"];
    if ([bfZqTechnic[@"detailList"] isKindOfClass:[NSArray class]]) {
        NSArray *detailList = (NSArray *)bfZqTechnic[@"detailList"];
        [self.Qukan_statisticsArray removeAllObjects];
        for (NSArray *a in detailList) {
            @autoreleasepool {
                [self.Qukan_statisticsArray addObject:a];
            }
        }
    }
    
    [self.Qukan_myTableView reloadData];
    
}

- (void)Qukan_netWorkClickRetry {
    [QukanFailureView Qukan_hideWithView:self.view];
    [self.Qukan_myTableView.mj_header beginRefreshing];
}

- (void)Qukan_newsChannelHomepWithAd:(NSInteger)adId {
    @weakify(self)
    [[[kApiManager QukanInfoWithType:41 withid:adId] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self dataSourceWith:x];
    } error:^(NSError * _Nullable error) {
        
        
    }];
    
    
}

- (void)dataSourceWith:(id)response {
    NSArray *array = (NSArray *)response;
    if (!array.count) {return;}
    for (NSDictionary *dict in array) {
        QukanHomeModels *model = [QukanHomeModels modelWithDictionary:dict];
        self.model = model;
    }
    [self setShowView];
}

#pragma mark ===================== Public Methods =======================
- (void)setShowView {

    if (!self.model) return;
    [self.Qukan_gView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.equalTo(@(68));
    }];
    [self.Qukan_myTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.Qukan_gView.mas_bottom);
        make.bottom.left.right.equalTo(self.view);
    }];
    
    //设置ad
    [self.Qukan_gView Qukan_setAdvWithModel:self.model];
    @weakify(self)
    self.Qukan_gView.dataImageView_didBlock = ^{
        @strongify(self)
        if (self.matchSituationVcBolck) {
            self.matchSituationVcBolck(self.model);
        }
    };
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.Qukan_statisticsArray.count) {
        return 2;
    } else {
        return 1;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return (self.Qukan_model.state == 1 || self.Qukan_model.state == 2 || self.Qukan_model.state == 3 || self.Qukan_model.state == 4 || self.Qukan_model.state == -1) ? self.Qukan_eventArray.count + 2 : 1;
    } else {
        return self.Qukan_statisticsArray.count ? self.Qukan_statisticsArray.count + 1 : 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.Qukan_model.state == 0) {
            return 180;
        }else {
            if (indexPath.row == self.Qukan_eventArray.count + 1 || indexPath.row == 0) {
                return 70;
            }else {
                NSDictionary *dict = self.Qukan_eventArray[indexPath.row - 1];
                NSInteger haFlag = [dict[@"haFlag"] integerValue];
                NSInteger type = 0;
                if (![dict[@"type"] isEqualToString:@"<null>"]) {
                    type = [dict[@"type"] integerValue];
                }
                NSString *content = @"";
                
                if (haFlag==1) {
                    content = dict[@"playerName"]?:@"";
                } else {
                    content = dict[@"playerName"]?:@"";
                }
                
                CGFloat contenH = [content heightForFont:[UIFont systemFontOfSize:12] width:(kScreenWidth / 2 ) - 82];
                return contenH + 40;
            }
        }
    }
    return indexPath.section == 1 && indexPath.row == 0 ? 50: 31.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 56;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 70;
    } else {
        return 0.01;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    QukanMatchTabSectionHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"QukanMatchTabSectionHeaderViewID"];
    if(!header){
        header = [[QukanMatchTabSectionHeaderView alloc] initWithReuseIdentifier:@"QukanMatchTabSectionHeaderViewID"];
    }
    
    NSMutableArray *arr = NSMutableArray.new;
    [arr addObject:@"重要事件"];
    if (self.Qukan_statisticsArray.count) {
        [arr addObject:@"技术统计"];
    }
    arr.count > section ? [header fullHeaderWithTitle:arr[section]] : nil;
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        QukanMatchSituationEventHeaderView *headerView = [QukanMatchSituationEventHeaderView Qukan_initWithXib];
        return headerView;
    }
    return [UIView new];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.Qukan_model.state == 0) {//未开赛
            QukanMatchEventNoStartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QukanMatchEventNoStartTableViewCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else {//已经开赛或者结束
            if (indexPath.row == self.Qukan_eventArray.count + 1 || indexPath.row == 0) {
                QukanMatchOnlyOneImgCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QukanMatchOnlyOneImgCellTableViewCellID"];
                [cell fullCellWithState:indexPath.row == 0?@"1":@"2"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
           
            QukanMatchSituationEventCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QukanMatchSituationEventCell"];
            NSDictionary *dict = self.Qukan_eventArray[indexPath.row - 1];
             cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell Qukan_setData:dict];
            return cell;
        }
      } else {
          if (indexPath.section == 1 && indexPath.row == 0) {
              QukanAnalysisHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QukanAnalysisHeaderTableViewCell"];
              cell.selectionStyle = UITableViewCellSelectionStyleNone;
              [cell setFootDataWithModel:self.Qukan_model];
              return cell;
          } else {
              QukanStrokeAnalysisTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QukanStrokeAnalysisTableViewCell"];
              NSArray *array = self.Qukan_statisticsArray[indexPath.row - 1];
              cell.selectionStyle = UITableViewCellSelectionStyleNone;
              [cell setFootDataWithArray:array];
              return cell;
          }
      }
}

#pragma mark - DZNEmptyDataSetSource
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *description = @"暂无数据";
    return [[NSAttributedString alloc] initWithString:description attributes:@{NSFontAttributeName : kFont16,NSForegroundColorAttributeName : [UIColor grayColor]}];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *imageName = @"nodate_footBall";
    return [UIImage imageNamed:imageName];
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    KShowHUD
    [self Qukan_refreshData];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return kCommentBackgroudColor;
}

//- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
//    return -kScreenWidth*(212/375.0) / 2;
//}

#pragma mark - DZNEmptyDataSetDelegate
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

#pragma mark ===================== JXCategoryListContainerViewDelegate ==================================
- (UIView *)listView{
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.Qukan_myTableView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback ?: self.scrollCallback(self.Qukan_myTableView);
}



#pragma mark - lazy
- (UIView *)Qukan_gView {
    if (!_Qukan_gView) {
        _Qukan_gView = [[QukanGDataView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
        [self.view addSubview:_Qukan_gView];
    }
    return _Qukan_gView;
}

- (UITableView *)Qukan_myTableView {
    if (!_Qukan_myTableView) {
        _Qukan_myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _Qukan_myTableView.backgroundColor = kCommentBackgroudColor;
        _Qukan_myTableView.delegate = self;
        _Qukan_myTableView.dataSource = self;
        _Qukan_myTableView.emptyDataSetSource = self;
        _Qukan_myTableView.emptyDataSetDelegate = self;
        _Qukan_myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_Qukan_myTableView];
        
        _Qukan_myTableView.tableFooterView = [UIView new];
        [_Qukan_myTableView registerNib:[UINib nibWithNibName:@"QukanMatchSituationEventCell" bundle:nil] forCellReuseIdentifier:@"QukanMatchSituationEventCell"];
        [_Qukan_myTableView registerNib:[UINib nibWithNibName:@"QukanMatchSituationEventCell2" bundle:nil] forCellReuseIdentifier:@"QukanMatchSituationEventCell2"];
//        [_Qukan_myTableView registerNib:[UINib nibWithNibName:@"QukanMatchSituationStatisticsCell" bundle:nil] forCellReuseIdentifier:@"QukanMatchSituationStatisticsCell"];
        
        [_Qukan_myTableView registerClass:[QukanStrokeAnalysisTableViewCell class] forCellReuseIdentifier:@"QukanStrokeAnalysisTableViewCell"];
        [_Qukan_myTableView registerClass:[QukanMatchEventNoStartTableViewCell class] forCellReuseIdentifier:@"QukanMatchEventNoStartTableViewCell"];
        
        
        [_Qukan_myTableView registerClass:[QukanMatchOnlyOneImgCellTableViewCell class] forCellReuseIdentifier:@"QukanMatchOnlyOneImgCellTableViewCellID"];
        
        [_Qukan_myTableView registerClass:[QukanAnalysisHeaderTableViewCell class] forCellReuseIdentifier:@"QukanAnalysisHeaderTableViewCell"];
        
        [_Qukan_myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self.view);
        }];
    }
    return _Qukan_myTableView;
}

- (NSMutableArray *)Qukan_eventArray {
    if (!_Qukan_eventArray) {
        _Qukan_eventArray = [[NSMutableArray alloc] init];
    }
    return _Qukan_eventArray;
}
- (NSMutableArray *)Qukan_statisticsArray {
    if (!_Qukan_statisticsArray) {
        _Qukan_statisticsArray = [[NSMutableArray alloc] init];
    }
    return _Qukan_statisticsArray;
}

@end
