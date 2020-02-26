#import "QukanBoilingPointTableView1Controller.h"
#import "QukanBoilingPointTableView1Cell.h"

#import "QukanBoilingPointTableViewModel_1.h"
#import <UIViewController+HBD.h>

#import "QukanAppDelegate.h"
#import "QukanNullDataView.h"

#import "QukanApiManager+Boiling.h"

#import "QukanThemeMainVC.h"

@interface QukanBoilingPointTableView1Controller ()<UITableViewDelegate, UITableViewDataSource>  {
    CGFloat _gradientProgress;
}

@property (nonatomic, strong) UITableView *Qukan_myTableView;
//@property (nonatomic, strong) QukanBoilingPointHeaderView *myHeaderView;

@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) NSMutableArray *Qukan_dataArray_0;
@property (nonatomic, strong) NSMutableArray *Qukan_dataArray_1;
@property (nonatomic, strong) NSMutableArray *Qukan_dataArray_2;

@end

@implementation QukanBoilingPointTableView1Controller

- (void)loadView {
//    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.view = self.Qukan_myTableView;
}

- (UITableView *)Qukan_myTableView {
    
    if (!_Qukan_myTableView) {
        _Qukan_myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _Qukan_myTableView.backgroundColor = kCommentBackgroudColor;
        _Qukan_myTableView.delegate = self;
        _Qukan_myTableView.dataSource = self;
        _Qukan_myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _Qukan_myTableView.tableFooterView = [UIView new];
        if (@available(iOS 11,*)) {
            _Qukan_myTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }

        [_Qukan_myTableView registerNib:[UINib nibWithNibName:@"QukanBoilingPointTableView1Cell" bundle:nil] forCellReuseIdentifier:@"QukanBoilingPointTableView1Cell"];

    }
    return _Qukan_myTableView;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (NSMutableArray *)Qukan_dataArray_0 {
    if (!_Qukan_dataArray_0) {
        _Qukan_dataArray_0 = [[NSMutableArray alloc] init];
    }
    return _Qukan_dataArray_0;
}

- (NSMutableArray *)Qukan_dataArray_1 {
    if (!_Qukan_dataArray_1) {
        _Qukan_dataArray_1 = [[NSMutableArray alloc] init];
    }
    return _Qukan_dataArray_1;
}

- (NSMutableArray *)Qukan_dataArray_2 {
    if (!_Qukan_dataArray_2) {
        _Qukan_dataArray_2 = [[NSMutableArray alloc] init];
    }
    return _Qukan_dataArray_2;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[QukanTool Qukan_createImageWithColor:[UIColor colorWithRed:232/255.0 green:245/255.0 blue:248/255.0 alpha:1.0]]];

    [self.Qukan_myTableView reloadData];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"话题";
    
    UIImage *headerImage = [UIImage imageNamed:@"Qukan_sunset"];
    _headerView = [[UIImageView alloc] initWithImage:headerImage];
    _headerView.clipsToBounds = YES;
    _headerView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view insertSubview:_headerView aboveSubview:self.Qukan_myTableView];
    
    self.hbd_barAlpha = 0.0;
    self.hbd_barStyle = UIBarStyleBlack;
    self.hbd_tintColor = kCommonWhiteColor;
    self.hbd_titleTextAttributes = @{ NSForegroundColorAttributeName: [kCommonWhiteColor colorWithAlphaComponent:0.0] };
    
    [self Qukan_refreshData];
    
    [RACObserve(self, Qukan_dataArray_0) subscribeNext:^(id x) {
        kUserManager.followQukanCount = [x count];
    }];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setFollowData:)
                                                 name:@"QukanBoilingPointDetailFollowNotificationName"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(Qukan_refreshData)
                                                 name:Qukan_Recommend_Follow_NotificationName
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(Qukan_refreshData)
                                                 name:kUserDidLogoutNotification object:nil];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],
                                                                      NSForegroundColorAttributeName:HEXColor(0x1A88D9)}];
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    UITableView *tableView = self.Qukan_myTableView;
    UIImageView *headerView = self.headerView;

    CGFloat width = CGRectGetWidth(self.view.bounds);
    UIImage *headerImage = headerView.image;
    CGFloat imageHeight = headerImage.size.height / headerImage.size.width * width;
    CGRect headerFrame = headerView.frame;
    
    if (tableView.contentInset.top == 0) {
        UIEdgeInsets inset = UIEdgeInsetsZero;
        if (@available(iOS 11,*)) {
            inset.bottom = self.view.safeAreaInsets.bottom;
        }
        tableView.scrollIndicatorInsets = inset;
        inset.top = imageHeight;
        tableView.contentInset = inset;
        tableView.contentOffset = CGPointMake(0, -inset.top);
    }
    
    if (CGRectGetHeight(headerFrame) != imageHeight) {
        headerView.frame = [self headerImageFrame];
    }
}

- (CGRect) headerImageFrame {
    UITableView *tableView = self.Qukan_myTableView;
    UIImageView *headerView = self.headerView;
    
    CGFloat width = CGRectGetWidth(self.view.bounds);
    UIImage *headerImage = headerView.image;
    CGFloat imageHeight = headerImage.size.height / headerImage.size.width * width;
    
    CGFloat contentOffsetY = tableView.contentOffset.y + tableView.contentInset.top;
    if (contentOffsetY < 0) {
        imageHeight += -contentOffsetY;
    }
    
    CGRect headerFrame = self.view.bounds;
    if (contentOffsetY > 0) {
        headerFrame.origin.y -= contentOffsetY;
    }
    headerFrame.size.height = imageHeight;
    
    return headerFrame;
}

- (void)setFollowData:(NSNotification *)noti {
    NSDictionary *dict = noti.object;
    NSInteger type = [dict[@"Type"] integerValue];
    if (type==1) { return;}
    NSLog(@"dict: %@", dict);
    NSInteger infoId = [dict[@"InfoId"] integerValue];
    NSInteger isFollow = [dict[@"IsFollow"] integerValue];
    for (QukanBoilingPointTableViewModel_1 *model in self.Qukan_dataArray_0) {
        if (model.infoId==infoId) {
            model.is_follow = isFollow;
        }
    }
    for (QukanBoilingPointTableViewModel_1 *model in self.Qukan_dataArray_1) {
        if (model.infoId==infoId) {
            model.is_follow = isFollow;
        }
    }
    [self setData];
}

- (void)setData {
    [self.Qukan_dataArray_0 enumerateObjectsUsingBlock:^(QukanBoilingPointTableViewModel_1 *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.is_follow==0) {
            [self.Qukan_dataArray_1 addObject:obj];
            [[self mutableArrayValueForKey:@"Qukan_dataArray_0"] removeObjectAtIndex:idx];
        }
    }];
    [self.Qukan_dataArray_1 enumerateObjectsUsingBlock:^(QukanBoilingPointTableViewModel_1 *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.is_follow==1) {
            [[self mutableArrayValueForKey:@"Qukan_dataArray_0"] addObject:obj];
            [self.Qukan_dataArray_1 removeObjectAtIndex:idx];
        }
    }];
   [self.Qukan_myTableView reloadData];
}

//- (void)requstNormal {
//    [QukanNetworkTool Qukan_GET:@"v3/posts/random-topic" parameters:nil success:^(NSDictionary *response) {
//        //        [self.Qukan_myTableView.mj_header endRefreshing];
//        if ([response isKindOfClass:[NSDictionary class]]) {
//            [self.Qukan_dataArray_2 removeAllObjects];
//            if ([response[@"data"] isKindOfClass:[NSDictionary class]]) {
//                NSDictionary *dict = (NSDictionary *)response[@"data"];
//                QukanBoilingPointTableViewModel_1 *model = [[QukanBoilingPointTableViewModel_1 alloc] initWithDict:dict];
//                [self.Qukan_dataArray_2 addObject:model];
//            }
//        }
//
//        [self.Qukan_myTableView reloadData];
//    } failure:^(NSError *error) {
//
//    }];
//}

- (void)Qukan_headerData {
    
//    @weakify(self)
//
//    [[[kApiManager QukanfindBfZqMatchAdWithType:@"6"] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
//        @strongify(self)
//         NSInteger adOn = [x integerValueForKey:@"onOff" default:0];
//         if (!adOn) {
//             [self requstNormal];
//         }else {
//             QukanBoilingPointTableViewModel_1 *model = [[QukanBoilingPointTableViewModel_1 alloc] init];
//             model.turn_url = x[@"turnUrl"];
//             model.on_off = adOn;
//             model.image_url = x[@"imageUrl"];
//             [self.Qukan_dataArray_2 addObject:model];
//         }
//     } error:^(NSError * _Nullable error) {
//         @strongify(self)
//         [self requstNormal];
//     }];
}
- (void)Qukan_refreshData {
    
//    [self Qukan_headerData];
    
    @weakify(self)
    KShowHUD
    [[[kApiManager QukanLabel] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        KHideHUD
//        self.Qukan_myTableView.tableHeaderView = self.headerView;
        [self dataSourceDealWith:x];
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        self.Qukan_myTableView.tableHeaderView = nil;
        [self.Qukan_myTableView reloadData];
    }];
}

- (void)dataSourceDealWith:(id)response {
    [[self mutableArrayValueForKey:@"Qukan_dataArray_0"] removeAllObjects];
    [self.Qukan_dataArray_1 removeAllObjects];
    NSArray *data = (NSArray *)response;
    for (NSDictionary *dict in data) {
        NSInteger is_follow = [dict[@"is_follow"] integerValue];
        QukanBoilingPointTableViewModel_1 *model = [[QukanBoilingPointTableViewModel_1 alloc] initWithDict:dict];
        if (is_follow==1) {
            [[self mutableArrayValueForKey:@"Qukan_dataArray_0"] addObject:model];
        } else {
            [self.Qukan_dataArray_1 addObject:model];
        }
    }
    
    if (self.Qukan_dataArray_0.count==0 && self.Qukan_dataArray_1.count==0) {
        
        [QukanNullDataView Qukan_showWithView:self.view
                             contentImageView:@"Qukan_Null_Data"
                                      content:@"暂无数据"
                                          top:0];
        
        [self.view bringSubviewToFront:self.Qukan_myTableView];
    } else {
        [QukanFailureView Qukan_hideWithView:self.view];
        [QukanNullDataView Qukan_hideWithView:self.view];
    }
    [self.Qukan_myTableView reloadData];
}

- (void)Qukan_netWorkClickRetry {
    [QukanFailureView Qukan_hideWithView:self.view];
    [self.Qukan_myTableView.mj_header beginRefreshing];
}
#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return section==0?self.Qukan_dataArray_0.count:self.Qukan_dataArray_1.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==0) {
        return self.Qukan_dataArray_0.count==0?0.0:50.0;
    }
    return self.Qukan_dataArray_1.count==0?0.0:50.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *v = [UIView new];
    v.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = section==0?@"    我关注的话题":@"    更多话题";
    titleLabel.textColor = kCommonBlackColor;
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [v addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(v);
    }];
    
    if (section==0 && self.Qukan_dataArray_0.count==0) {
        v.hidden = YES;
    } else {
        v.hidden = NO;
    }
    return v;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QukanBoilingPointTableView1Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"QukanBoilingPointTableView1Cell"];
    QukanBoilingPointTableViewModel_1 *model = nil;
    if (indexPath.section==0) {
        model = self.Qukan_dataArray_0[indexPath.row];
    } else {
        model = self.Qukan_dataArray_1[indexPath.row];
    }
    [cell setData:model];
    @weakify(self)
    cell.followBlock = ^(int tag) {
        @strongify(self)
        if (tag == 1) {
            [[self mutableArrayValueForKey:@"Qukan_dataArray_0"] addObject:model];
            [self.Qukan_dataArray_1 removeObjectAtIndex:indexPath.row];
            [self.Qukan_myTableView reloadData];
        } else {
            [[self mutableArrayValueForKey:@"Qukan_dataArray_0"] removeObject:model];
            [self.Qukan_dataArray_1 insertObject:model atIndex:indexPath.row];
            [self.Qukan_myTableView reloadData];
        }
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QukanBoilingPointTableViewModel_1 *model = nil;
    if (indexPath.section==0) {
        model = self.Qukan_dataArray_0[indexPath.row];
    } else {
        model = self.Qukan_dataArray_1[indexPath.row];
    }
    QukanThemeMainVC *vc = [QukanThemeMainVC new];
    vc.model_main = model;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
//    ListRefreshViewController *vc = [[ListRefreshViewController alloc] init];
//    vc.model = model;
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat headerHeight = CGRectGetHeight(self.headerView.frame);
    if (@available(iOS 11,*)) {
        headerHeight -= self.view.safeAreaInsets.top;
    } else {
        headerHeight -= [self.topLayoutGuide length];
    }
    
    CGFloat progress = scrollView.contentOffset.y + scrollView.contentInset.top;
    CGFloat gradientProgress = MIN(1, MAX(0, progress  / headerHeight));
    gradientProgress = gradientProgress * gradientProgress * gradientProgress * gradientProgress;
    if (gradientProgress != _gradientProgress) {
        _gradientProgress = gradientProgress;
        if (_gradientProgress < 0.1) {
            self.hbd_barStyle = UIBarStyleBlack;
            self.hbd_tintColor = kCommonWhiteColor;
            self.hbd_titleTextAttributes = @{ NSForegroundColorAttributeName: [kCommonBlackColor colorWithAlphaComponent:0] };
        } else {
            self.hbd_barStyle = UIBarStyleDefault;
            self.hbd_tintColor = kCommonBlackColor;
            self.hbd_titleTextAttributes = @{ NSForegroundColorAttributeName: [kCommonWhiteColor colorWithAlphaComponent:_gradientProgress] };
        }
        
        self.hbd_barAlpha = _gradientProgress;
        [self hbd_setNeedsUpdateNavigationBar];
    }
    self.headerView.frame = [self headerImageFrame];
}

@end

