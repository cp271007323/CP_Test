#import "QukanRootSetupViewController.h"
#import "QukanHintRangeViewController.h"
#import "QukanInfoCell.h"
@interface QukanRootSetupViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *Qukan_myTableView;
@property (nonatomic, strong) NSMutableArray *Qukan_dataArray;
@end
@implementation QukanRootSetupViewController
- (UITableView *)Qukan_myTableView {
    if (!_Qukan_myTableView) {
        _Qukan_myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _Qukan_myTableView.backgroundColor = [UIColor clearColor];
        _Qukan_myTableView.delegate = self;
        _Qukan_myTableView.dataSource = self;
        [self.view addSubview:_Qukan_myTableView];
        _Qukan_myTableView.showsVerticalScrollIndicator = NO;
        _Qukan_myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _Qukan_myTableView.tableFooterView = [UIView new];
        [_Qukan_myTableView registerNib:[UINib nibWithNibName:@"QukanInfoCell" bundle:nil] forCellReuseIdentifier:@"QukanInfoCell"];
//        [_Qukan_myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.bottom.right.equalTo(self.view);
//            make.top.mas_equalTo(isIPhoneXSeries()?88.0:64.0);
//        }];
        [_Qukan_myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.left.equalTo(self.view).mas_offset(10.0);
            make.right.equalTo(self.view).mas_offset(-10.0);
            make.bottom.equalTo(self.view).mas_offset(-10.0);
        }];
    }
    return _Qukan_myTableView;
}
- (NSMutableArray *)Qukan_dataArray {
    if (!_Qukan_dataArray) {
        _Qukan_dataArray = [[NSMutableArray alloc] init];
        NSArray *array1 = @[@{@"Content":@"声音"},
                            @{@"Content":@"震动"},
                            @{@"Content":@"特效"}];
        [_Qukan_dataArray addObject:array1];
        NSArray *array2 = @[@{@"Content":@"声音"},
                            @{@"Content":@"震动"}];
        [_Qukan_dataArray addObject:array2];
        NSArray *array3 = @[@{@"Content":@"全部比赛"}];
        [_Qukan_dataArray addObject:array3];
//        NSArray *array4 = @[@{@"Content":@"是否显示排名"},
//                            @{@"Content":@"是否显示红黄牌"}];
        NSArray *array4 = @[@{@"Content":@"是否显示红黄牌"}];
        
        [_Qukan_dataArray addObject:array4];
        
        NSArray *array5 = @[@{@"Content":@"简体"},
                            @{@"Content":@"繁体"}];
        [_Qukan_dataArray addObject:array5];
    }
    return _Qukan_dataArray;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.Qukan_myTableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"赛事设置";
    [self Qukan_myTableView];

    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:kImageNamed(@"ZFPlayer_closeWatch") style:UIBarButtonItemStylePlain target:self action:@selector(closeSetup)];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)closeSetup {
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)Qukan_setSwitchOnAndOffWithIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0 && indexPath.row==0) {
        NSString *obj = [[NSUserDefaults standardUserDefaults] objectForKey:Qukan_GoalTips_Voice_Key];
        [[NSUserDefaults standardUserDefaults] setObject:[obj isEqualToString:@"1"]?@"2":@"1" forKey:Qukan_GoalTips_Voice_Key];
    } else if (indexPath.section==0 && indexPath.row==1) {
        NSString *obj = [[NSUserDefaults standardUserDefaults] objectForKey:Qukan_GoalTips_Shock_Key];
        [[NSUserDefaults standardUserDefaults] setObject:[obj isEqualToString:@"1"]?@"2":@"1" forKey:Qukan_GoalTips_Shock_Key];
    }
    else if (indexPath.section==1 && indexPath.row==0) {
        NSString *obj = [[NSUserDefaults standardUserDefaults] objectForKey:Qukan_RedkaTips_Voice_Key];
        [[NSUserDefaults standardUserDefaults] setObject:[obj isEqualToString:@"1"]?@"2":@"1" forKey:Qukan_RedkaTips_Voice_Key];
    } else if (indexPath.section==1 && indexPath.row==1) {
        NSString *obj = [[NSUserDefaults standardUserDefaults] objectForKey:Qukan_RedkaTips_Shock_Key];
        [[NSUserDefaults standardUserDefaults] setObject:[obj isEqualToString:@"1"]?@"2":@"1" forKey:Qukan_RedkaTips_Shock_Key];
    }
    else if (indexPath.section==2 && indexPath.row==0) {
        NSString *obj = [[NSUserDefaults standardUserDefaults] objectForKey:Qukan_RangeTips_Shock_Key];
        [[NSUserDefaults standardUserDefaults] setObject:[obj isEqualToString:@"1"]?@"2":@"1" forKey:Qukan_RangeTips_Shock_Key];
    }
    else if (indexPath.section==3 && indexPath.row==0) {
//        NSString *obj = [[NSUserDefaults standardUserDefaults] objectForKey:Qukan_IsShow_Ranking_Key];
//        [[NSUserDefaults standardUserDefaults] setObject:[obj isEqualToString:@"1"]?@"2":@"1" forKey:Qukan_IsShow_Ranking_Key];
        
        NSString *obj = [[NSUserDefaults standardUserDefaults] objectForKey:Qukan_IsShow_RedAndYellowka_Key];
        [[NSUserDefaults standardUserDefaults] setObject:[obj isEqualToString:@"1"]?@"2":@"1" forKey:Qukan_IsShow_RedAndYellowka_Key];
    }
    else {
//        NSString *obj = [[NSUserDefaults standardUserDefaults] objectForKey:Qukan_IsShow_RedAndYellowka_Key];
//        [[NSUserDefaults standardUserDefaults] setObject:[obj isEqualToString:@"1"]?@"2":@"1" forKey:Qukan_IsShow_RedAndYellowka_Key];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}
#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.Qukan_dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = self.Qukan_dataArray[section];
    return array.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section==self.Qukan_dataArray.count-1 ? 24.0:38.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section==self.Qukan_dataArray.count-1 ? 24.0:0.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *v = [UIView new];
    v.backgroundColor = [UIColor clearColor];
    if (section!=self.Qukan_dataArray.count-1) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.frame = CGRectMake(10.0, 0.0, CGRectGetWidth([[UIScreen mainScreen] bounds])-20.0, 38.0);
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = section==0 ? @"进球提示":(section==1 ? @"红牌提示":@"提示范围");
        titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        titleLabel.font = [UIFont systemFontOfSize:16];
        [v addSubview:titleLabel];
    }
    return v;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *v = [UIView new];
    v.backgroundColor = [UIColor clearColor];
    return v;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QukanInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QukanInfoCell"];
    cell.nameLabel.textColor = kCommonBlackColor;
    NSArray *array = self.Qukan_dataArray[indexPath.section];
    NSDictionary *dict = array[indexPath.row];
    NSString *content = dict[@"Content"];
    cell.nameLabel.text = content;
    if (indexPath.section==0 && indexPath.row==0) {
        NSString *GoalTipsVoice = [[NSUserDefaults standardUserDefaults] objectForKey:Qukan_GoalTips_Voice_Key];
        cell.mySwitch.on = [GoalTipsVoice isEqualToString:@"1"] ? YES:NO;
    } else if (indexPath.section==0 && indexPath.row==1) {
        NSString *GoalTipsShock = [[NSUserDefaults standardUserDefaults] objectForKey:Qukan_GoalTips_Shock_Key];
        cell.mySwitch.on = [GoalTipsShock isEqualToString:@"1"] ? YES:NO;
    }
    else if (indexPath.section==1 && indexPath.row==0) {
        NSString *RedkaTipsVoice = [[NSUserDefaults standardUserDefaults] objectForKey:Qukan_RedkaTips_Voice_Key];
        cell.mySwitch.on = [RedkaTipsVoice isEqualToString:@"1"] ? YES:NO;
    } else if (indexPath.section==1 && indexPath.row==1) {
        NSString *RedkaTipsShock = [[NSUserDefaults standardUserDefaults] objectForKey:Qukan_RedkaTips_Shock_Key];
        cell.mySwitch.on = [RedkaTipsShock isEqualToString:@"1"] ? YES:NO;
    }
    else if (indexPath.section==2 && indexPath.row==0) {
        NSString *RangeTipsShock = [[NSUserDefaults standardUserDefaults] objectForKey:Qukan_RangeTips_Shock_Key];
        if ([RangeTipsShock isEqualToString:@"1"]) {
            cell.nameLabel.text = @"全部比赛";
        } else if ([RangeTipsShock isEqualToString:@"2"]) {
            cell.nameLabel.text = @"关注的比赛";
        } else {
            cell.nameLabel.text = @"不提示";
        }
    }
    else if (indexPath.section==3 && indexPath.row==0) {
//        NSString *IsShowRanking = [[NSUserDefaults standardUserDefaults] objectForKey:Qukan_IsShow_Ranking_Key];
//        cell.mySwitch.on = [IsShowRanking isEqualToString:@"1"] ? YES:NO;
        
        NSString *IsShowRedka = [[NSUserDefaults standardUserDefaults] objectForKey:Qukan_IsShow_RedAndYellowka_Key];
        cell.mySwitch.on = [IsShowRedka isEqualToString:@"1"] ? YES:NO;
    }
    else {
//        NSString *IsShowRedka = [[NSUserDefaults standardUserDefaults] objectForKey:Qukan_IsShow_RedAndYellowka_Key];
//        cell.mySwitch.on = [IsShowRedka isEqualToString:@"1"] ? YES:NO;
    }
    @weakify(self)
    cell.Qukan_switchBlock = ^{
        @strongify(self)
        [self Qukan_setSwitchOnAndOffWithIndexPath:indexPath];
    };
    cell.mySwitch.hidden = indexPath.section==2 ? YES:NO;
    cell.rightImageView.hidden = indexPath.section==2 ? NO:YES;
    cell.contentLabel.hidden = YES;
    if (indexPath.section==self.Qukan_dataArray.count-1 && indexPath.row==array.count-1) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0.0, CGRectGetWidth([[UIScreen mainScreen] bounds]), 0.0, 0.0)];
    } else {
        [cell setSeparatorInset:UIEdgeInsetsMake(0.0, 20.0, 0.0, 0.0)];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==2) {
        QukanHintRangeViewController *vc = [[QukanHintRangeViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
