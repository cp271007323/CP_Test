#import "QukanAddViewController.h"
#import "QukanBoilingPointTableView1Cell.h"

#import "QukanBoilingPointTableViewModel_1.h"
#import "QukanAppDelegate.h"

#import "QukanApiManager+Boiling.h"

@interface QukanAddViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *Qukan_myTableView;

@property (nonatomic, strong) NSMutableArray *Qukan_dataArray;
@end
@implementation QukanAddViewController
- (UITableView *)Qukan_myTableView {
    if (!_Qukan_myTableView) {
        _Qukan_myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _Qukan_myTableView.backgroundColor = [UIColor clearColor];
        _Qukan_myTableView.delegate = self;
        _Qukan_myTableView.dataSource = self;
        [self.view addSubview:_Qukan_myTableView];

        _Qukan_myTableView.showsVerticalScrollIndicator = NO;
        _Qukan_myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _Qukan_myTableView.tableFooterView = [UIView new];
        _Qukan_myTableView.mj_header = [QukanHomeRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(Qukan_refreshData)];
        
        [_Qukan_myTableView registerNib:[UINib nibWithNibName:@"QukanBoilingPointTableView1Cell" bundle:nil] forCellReuseIdentifier:@"QukanBoilingPointTableView1Cell"];
        [_Qukan_myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.equalTo(self.view);
        }];
    }
    return _Qukan_myTableView;
}
- (NSMutableArray *)Qukan_dataArray {
    if (!_Qukan_dataArray) {
        _Qukan_dataArray = [[NSMutableArray alloc] init];
    }
    return _Qukan_dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加话题";
    [self.Qukan_myTableView.mj_header beginRefreshing];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


- (void)Qukan_refreshData {
    @weakify(self)
    [[[kApiManager QukanLabel] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        [self.Qukan_myTableView.mj_header endRefreshing];
        @strongify(self)
        [self dataSourceDealWith:x];
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        [self.Qukan_myTableView.mj_header endRefreshing];
    }];
}

- (void)dataSourceDealWith:(id)response {
    NSArray *data = (NSArray *)response;
    [self.Qukan_dataArray removeAllObjects];
    
    QukanBoilingPointTableViewModel_1 *defaultModel = [[QukanBoilingPointTableViewModel_1 alloc] init];
    defaultModel.infoId = 0;
    defaultModel.title = @"不添加任何话题";
    [self.Qukan_dataArray addObject:defaultModel];
    
    for (NSDictionary *dict in data) {
        QukanBoilingPointTableViewModel_1 *model = [[QukanBoilingPointTableViewModel_1 alloc] initWithDict:dict];
        [self.Qukan_dataArray addObject:model];
    }
    [self.Qukan_myTableView reloadData];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.Qukan_dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QukanBoilingPointTableView1Cell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QukanBoilingPointTableView1Cell class])];
    QukanBoilingPointTableViewModel_1 *model = self.Qukan_dataArray[indexPath.row];
    if (indexPath.row==0) {
        cell.contentLabel.text = model.title;
        cell.otherLabel.text = @"";
    } else {
        [cell setData:model];
    }
    cell.followButton.hidden = YES;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QukanBoilingPointTableViewModel_1 *model = self.Qukan_dataArray[indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"QukanAddViewController" object:@{@"InfoId":[NSNumber numberWithInteger:model.infoId], @"Title":model.title}];
    [self.navigationController popViewControllerAnimated:YES];

}
@end
