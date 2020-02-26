#import "QukanLineupViewController.h"
#import "QukanLineupCell.h"
#import "QukanLineupHeaderView.h"
#import "QukanGDataView.h"
#import "QukanApiManager+info.h"

#import "QukanApiManager+Competition.h"
#import "QukanMatchTabSectionHeaderView.h"

// 阵容
@interface QukanLineupViewController ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UITableView                 *Qukan_myTableView;
@property (nonatomic, strong) UILabel                     *Qukan_remindLabel;
@property (nonatomic, strong) QukanLineupHeaderView       *Qukan_headerView;
@property (nonatomic, strong) NSMutableArray              *Qukan_homeBackupArray;
@property (nonatomic, strong) NSMutableArray              *Qukan_awayBackupArray;
@property (nonatomic, strong) QukanGDataView         *Qukan_gView;
@property (nonatomic, strong) QukanHomeModels            *model;
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@end

@implementation QukanLineupViewController

- (UIView *)Qukan_gView {
    if (!_Qukan_gView) {
        _Qukan_gView = [[QukanGDataView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
        [self.view addSubview:_Qukan_gView];
        
        [_Qukan_gView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.height.mas_equalTo(68);
        }];
    }
    return _Qukan_gView;
}


- (UITableView *)Qukan_myTableView {
    if (!_Qukan_myTableView) {
        _Qukan_myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _Qukan_myTableView.backgroundColor = kCommentBackgroudColor;
        _Qukan_myTableView.delegate = self;
        _Qukan_myTableView.dataSource = self;
        _Qukan_myTableView.emptyDataSetDelegate = self;
        _Qukan_myTableView.emptyDataSetSource = self;
        [self.view addSubview:_Qukan_myTableView];
        _Qukan_myTableView.showsVerticalScrollIndicator = NO;
        
        _Qukan_myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _Qukan_myTableView.tableFooterView = [UIView new];
        [_Qukan_myTableView registerNib:[UINib nibWithNibName:@"QukanLineupCell" bundle:nil] forCellReuseIdentifier:@"QukanLineupCell"];
        [_Qukan_myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(0);
            make.left.right.bottom.equalTo(self.view);
        }];
    }
    return _Qukan_myTableView;
}

- (QukanLineupHeaderView *)Qukan_headerView {
    if (!_Qukan_headerView) {
        _Qukan_headerView = [QukanLineupHeaderView Qukan_initWithXib];
        _Qukan_headerView.str_homeName = self.Qukan_model.home_name;
        _Qukan_headerView.str_awayName = self.Qukan_model.away_name;
        _Qukan_headerView.frame = CGRectMake(0.0, 0.0, kScreenWidth, 1040);
    }
    return _Qukan_headerView;
}
- (NSMutableArray *)Qukan_homeBackupArray {
    if (!_Qukan_homeBackupArray) {
        _Qukan_homeBackupArray = [[NSMutableArray alloc] init];
    }
    return _Qukan_homeBackupArray;
}
- (NSMutableArray *)Qukan_awayBackupArray {
    if (!_Qukan_awayBackupArray) {
        _Qukan_awayBackupArray = [[NSMutableArray alloc] init];
    }
    return _Qukan_awayBackupArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kCommentBackgroudColor;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults stringForKey:@"phpAdvId"].length) {
        NSInteger phpAdvId = [[userDefaults objectForKey:@"phpAdvId"] integerValue];
       [self Qukan_newsChannelHomepWithAd:phpAdvId];
    } else {
        [self qukanAD];
    }
    self.Qukan_myTableView.mj_header = [QukanHomeRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(Qukan_refreshData)];
//    [self.Qukan_myTableView.mj_header beginRefreshing];
    KShowHUD
    [self Qukan_refreshData];
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

- (void)Qukan_refreshData {
    @weakify(self)
//    KShowHUD
    [[[kApiManager QukanMatchFindLineupByMatchIdWithMatchId:[NSString stringWithFormat:@"%ld", self.Qukan_matchId]] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        [self.Qukan_myTableView.mj_header endRefreshing];
        @strongify(self)
        KHideHUD
        [self dataSourceDealWith:x];
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        KHideHUD
        [self.Qukan_myTableView.mj_header endRefreshing];
        [self.Qukan_myTableView reloadData];
        [self qukanAD];
    }];
}
- (void)qukanAD {
    @weakify(self)
    [[[kApiManager QukanInfoWithType:23] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self dataSourceWith:x];
        
    }];
}
- (void)dataSourceDealWith:(id)response {
    
    [self.Qukan_homeBackupArray removeAllObjects];
    NSDictionary *dict = [NSDictionary dictionary];
    if ([response isKindOfClass:[NSDictionary class]]) {
        dict = response;
    } else {
        return;
    }
    NSArray *homeBackupList = [NSArray array];

    if ([[dict objectForKey:@"homeBackupList"] isKindOfClass:[NSArray class]]) {
        homeBackupList = [dict objectForKey:@"homeBackupList"];
    }
   
    [self.Qukan_homeBackupArray addObjectsFromArray:homeBackupList];
    
    [self.Qukan_awayBackupArray removeAllObjects];
    NSArray *awayBackupList = [NSArray array];
    if ([[dict objectForKey:@"awayBackupList"] isKindOfClass:[NSArray class]]) {
        awayBackupList = [dict objectForKey:@"awayBackupList"];
    }
    [self.Qukan_awayBackupArray addObjectsFromArray:awayBackupList];
    
    [self.Qukan_headerView Qukan_setData:response];
    
    
    if (self.Qukan_homeBackupArray.count > 0) {
        self.Qukan_myTableView.tableHeaderView = self.Qukan_headerView;
    }else {
        self.Qukan_myTableView.tableHeaderView = nil;
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
        if (self.lineUpVcBolck) {
            self.lineUpVcBolck(self.model);
        }
    };
}


#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.Qukan_homeBackupArray.count==0 && self.Qukan_awayBackupArray.count==0) {
        return 0;
    }
    if (self.Qukan_homeBackupArray.count<self.Qukan_awayBackupArray.count) {
        return self.Qukan_awayBackupArray.count+1;
    } else {
        return self.Qukan_homeBackupArray.count+1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 47.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.Qukan_homeBackupArray.count==0 && self.Qukan_awayBackupArray.count==0) {
        return 0.0f;
    }
    
    return 56.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
   
    QukanMatchTabSectionHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"QukanMatchTabSectionHeaderViewID"];
    if(!header){
        header = [[QukanMatchTabSectionHeaderView alloc] initWithReuseIdentifier:@"QukanMatchTabSectionHeaderViewID"];
    }
    
    [header fullHeaderWithTitle:@"替补阵容"];
    return header;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QukanLineupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QukanLineupCell"];
    if (indexPath.row==0) {
        cell.logoImageView_1.hidden = NO;
        cell.logoImageView_2.hidden = NO;
        cell.numberLabel_1.hidden = YES;
        cell.numberLabel_2.hidden = YES;
        cell.nameLabel_1.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        cell.nameLabel_2.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        [cell.logoImageView_1 sd_setImageWithURL:[NSURL URLWithString:self.Qukan_model.flag1] placeholderImage:[UIImage imageNamed:@"Qukan_placeholder"]];
        [cell.logoImageView_2 sd_setImageWithURL:[NSURL URLWithString:self.Qukan_model.flag2] placeholderImage:[UIImage imageNamed:@"Qukan_placeholder"]];
        cell.nameLabel_1.text = self.Qukan_model.home_name;
        cell.nameLabel_2.text = self.Qukan_model.away_name;
    } else {
        cell.logoImageView_1.hidden = YES;
        cell.logoImageView_2.hidden = YES;
        cell.numberLabel_1.hidden = NO;
        cell.numberLabel_2.hidden = NO;
        
        cell.numberLabel_2.layer.borderColor = HEXColor(0x2b2b2b).CGColor;
        cell.numberLabel_2.layer.borderWidth = 1;
        
        cell.nameLabel_1.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        cell.nameLabel_2.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        if (indexPath.row<=self.Qukan_homeBackupArray.count) {
            cell.nameLabel_1.hidden = NO;
            cell.numberLabel_1.hidden = NO;
            NSString *infoStr = self.Qukan_homeBackupArray[indexPath.row-1];
            NSArray *infoArray = [infoStr componentsSeparatedByString:@","];
            if (infoArray.count>=4) {
                cell.nameLabel_1.text = infoArray[1];
                cell.numberLabel_1.text = infoArray[3];
            } else {
                cell.nameLabel_1.text = @"";
                cell.numberLabel_1.text = @"";
            }
        } else {
            cell.nameLabel_1.hidden = YES;
            cell.numberLabel_1.hidden = YES;
        }
        if (indexPath.row<=self.Qukan_awayBackupArray.count) {
            cell.nameLabel_2.hidden = NO;
            cell.numberLabel_2.hidden = NO;
            NSString *infoStr = self.Qukan_awayBackupArray[indexPath.row-1];
            NSArray *infoArray = [infoStr componentsSeparatedByString:@","];
            if (infoArray.count>=4) {
                cell.nameLabel_2.text = infoArray[1];
                cell.numberLabel_2.text = infoArray[3];
            } else {
                cell.nameLabel_2.text = @"";
                cell.numberLabel_2.text = @"";
            }
        } else {
            cell.nameLabel_2.hidden = YES;
            cell.numberLabel_2.hidden = YES;
        }
    }
    return cell;
}

#pragma mark - DZNEmptyDataSetSource
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *description = @"暂无数据";
    return [[NSAttributedString alloc] initWithString:description attributes:@{NSFontAttributeName : kFont16,NSForegroundColorAttributeName : [UIColor grayColor]}];
}
//
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


@end
