//
//  QukanNewsDetailsCommentViewController.m
//  Qukan
//
//  Created by Kody on 2019/7/20.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanNewsDetailsCommentViewController.h"
#import "QukanNewsDetailsTableViewCell.h"
#import "QukanNewsModel.h"
#import "QukanApiManager+News.h"
#import "QukanNullDataView.h"
#import "QukanLXKeyBoard.h"

#import <IQKeyboardManager/IQKeyboardManager.h>
#import "QukanNewsComentView.h"

@interface QukanNewsDetailsCommentViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property(nonatomic, strong) UITableView                        *Qukan_NewsTableView;
@property (nonatomic,strong) QukanLXKeyBoard                         *Qukan_Keyboard;
@property(nonatomic, strong) QukanNewsComentView                *Qukan_FooterView;
@property(nonatomic, strong) UIButton                           *newestButton;
@property(nonatomic, strong) UIButton                           *hotestButton;

@property(nonatomic, strong) NSMutableArray                     *Qukan_NewsDataArray;

@property(nonatomic, assign) NSInteger                          page;
@property(nonatomic, assign) NSInteger                          sortType;
@property(nonatomic, assign) CGFloat                            headerHight;

@end

@implementation QukanNewsDetailsCommentViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    self.commentVcBlock();
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self interFace];
    [self addTableView];
    [self Qukan_refreshData];
}

- (void)interFace {
    self.view.backgroundColor = kViewControllerBackgroundColor;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = AppName;
    self.Qukan_NewsDataArray = [NSMutableArray array];
    self.page = 1;
    self.sortType = 1;
}

- (void)addTableView {
    [self.Qukan_NewsTableView reloadData];
    
    @weakify(self)
    self.Qukan_FooterView.putBlock = ^(NSInteger type) {
        @strongify(self)
        self.Qukan_Keyboard.placeholder = @"输入评论...";
        [self.Qukan_Keyboard becomeFirstResponder];
    };
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark ===================== NetWork ==================================

- (void)Qukan_refreshData {
    self.page = 1;
    [self Qukan_requestData];
}

- (void)Qukan_requestData {
    @weakify(self)
    [[[kApiManager QukancommentSearchWithsourceId:self.videoNews.nid addsourceType:1 addSortType:self.sortType addcurrent:_page addsize:10] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self dataSourceDealWith:x];
    } error:^(NSError * _Nullable error) {
        [self.Qukan_NewsTableView.mj_header endRefreshing];
    }];
}

- (void)Qukan_requestListMore {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.page ++;
        [self Qukan_requestData];
    });
}
- (void)Qukan_CommentAdd:(NSString *)text {
    @weakify(self)
    [[[kApiManager QukancommentAddWithsourceId:self.videoNews.nid addsourceType:1 addCommentContent:text] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.page = 1;
        self.videoNews.commentNum = self.videoNews.commentNum + 1;
        [self Qukan_refreshData];
        [SVProgressHUD showSuccessWithStatus:@"发表成功"];
    } error:^(NSError * _Nullable error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}


- (void)Qukan_netWorkClickRetry {
    [QukanFailureView Qukan_hideWithView:self.view];
}

- (void)dataSourceDealWith:(id)response {
    NSArray *array = (NSArray *)response[@"records"];
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        QukanNewsCommentModel *model = [QukanNewsCommentModel modelWithDictionary:dict];
        [modelArray addObject:model];
    }
    
    if (self.page == 1 || self.Qukan_NewsDataArray.count == 0) {
        [self.Qukan_NewsTableView.mj_header endRefreshing];
    }
    
    NSMutableArray* keepDatas = [NSMutableArray array];
    for (QukanNewsCommentModel *model in modelArray) {
        if (![[QukanFilterManager sharedInstance] isFilteredComment:model.newsId] && !([[QukanFilterManager sharedInstance] isBlockedUser:model.userId])) {
            [keepDatas addObject:model];
        }
    }
    
    [self.Qukan_NewsDataArray removeAllObjects];
    [self.Qukan_NewsDataArray addObjectsFromArray:keepDatas];
    
    self.page += 0;
    
    self.Qukan_NewsTableView.mj_footer.hidden = self.Qukan_NewsDataArray.count == 0;
    if (modelArray.count < 10) {
        [self.Qukan_NewsTableView.mj_footer endRefreshingWithNoMoreData];
    }else {
        [self.Qukan_NewsTableView.mj_footer endRefreshing];
    }
    
    if (self.Qukan_NewsDataArray.count == 0) {
    } else {
        [QukanNullDataView Qukan_hideWithView:self.view];
    }
    [self.Qukan_NewsTableView reloadData];
}


#pragma mark ===================== UITableViewDataSource, UITableViewDelegate =================================

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.Qukan_NewsDataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
   return self.Qukan_NewsDataArray.count ? 30 : 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    QukanNewsCommentModel *model = self.Qukan_NewsDataArray[indexPath.row];
    CGFloat cellHight = [model.commentContent heightForFont:kFont14 width:kScreenWidth - 33];
    return cellHight + 75;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,30)];
    headView.backgroundColor = [UIColor whiteColor];
    
    UILabel *sub_label = [[UILabel alloc] initWithFrame:CGRectZero];
    sub_label.backgroundColor = kThemeColor;
    [headView addSubview:sub_label];
    [sub_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(4);
        make.height.offset(15);
        make.left.offset(15);
        make.centerY.mas_equalTo(headView);
    }];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
    title.text = @"全部评论";
    title.textColor = kCommonTextColor;
    title.font = [UIFont boldSystemFontOfSize:16];
    [headView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(sub_label.mas_right).offset(6);
        make.centerY.mas_equalTo(sub_label);
    }];
  
    return headView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellStr = @"QukanNewsDetailsTableViewCell";
    QukanNewsDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    QukanNewsCommentModel *model = self.Qukan_NewsDataArray[indexPath.row];
    [cell Qukan_SetNewsDetailsWith:model];
    @weakify(self)
    cell.QukanNewsDetails_didSeleLivesBlock = ^{
        @strongify(self)
        [self Qukan_refreshData];
    };
    return cell;
}

#pragma mark ===================== DZNEmptyDataSetSource ==================================

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSString *description = @"还没有评论，赶紧去评论吧~";
    return [[NSAttributedString alloc] initWithString:description attributes:@{NSFontAttributeName : kFont16,NSForegroundColorAttributeName : [UIColor grayColor]}];
}
//
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *imageName = @"Qukan_Null_Data";
    return [UIImage imageNamed:imageName];
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    [self Qukan_refreshData];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return RGBA(238, 238, 238, 1);
}

#pragma mark - DZNEmptyDataSetDelegate

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}


#pragma mark ===================== Getters =================================
- (UITableView *)Qukan_NewsTableView {
    
    extern CGFloat tabBarHeight;
    
    if (!_Qukan_NewsTableView) {
        _Qukan_NewsTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _Qukan_NewsTableView.backgroundColor = [UIColor clearColor];
        _Qukan_NewsTableView.delegate = self;
        _Qukan_NewsTableView.dataSource = self;
        _Qukan_NewsTableView.emptyDataSetSource = self;
        _Qukan_NewsTableView.emptyDataSetDelegate = self;
        [self.view addSubview:_Qukan_NewsTableView];
        _Qukan_NewsTableView.estimatedSectionHeaderHeight = 0;
        _Qukan_NewsTableView.estimatedSectionFooterHeight = 0;
        
        _Qukan_NewsTableView.rowHeight = SCALING_RATIO(80);
        //        _Qukan_myTableView.rowHeight = UITableViewAutomaticDimension;
        
        _Qukan_NewsTableView.showsVerticalScrollIndicator = NO;
        _Qukan_NewsTableView.tableFooterView = [UIView new];
        [_Qukan_NewsTableView registerClass:[QukanNewsDetailsTableViewCell class] forCellReuseIdentifier:@"QukanNewsDetailsTableViewCell"];
        _Qukan_NewsTableView.mj_header = [QukanHomeRefreshHeader headerWithRefreshingTarget:self
                                                                           refreshingAction:@selector(Qukan_refreshData)];
        _Qukan_NewsTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(Qukan_requestListMore)];
        
        [_Qukan_NewsTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(10);
            make.left.equalTo(self.view).offset(0);
            make.right.equalTo(self.view).offset(0);
            make.bottom.equalTo(self.view).mas_offset(isIPhoneXSeries()?-74.0:-49.0);
        }];
        [self.view layoutIfNeeded];
    }
    return _Qukan_NewsTableView;
}


- (QukanLXKeyBoard *)Qukan_Keyboard {
    if (!_Qukan_Keyboard) {
        _Qukan_Keyboard =[[QukanLXKeyBoard alloc]initWithFrame:CGRectZero];
        _Qukan_Keyboard.backgroundColor =[UIColor whiteColor];
        _Qukan_Keyboard.maxLine = 3;
        _Qukan_Keyboard.font = [UIFont systemFontOfSize:14];
        _Qukan_Keyboard.topOrBottomEdge = 15;
        [_Qukan_Keyboard beginUpdateUI];
        [self.view addSubview:_Qukan_Keyboard];
        _Qukan_Keyboard.placeholder = @"输入评论...";
        
        @weakify(self)
        _Qukan_Keyboard.sendBlock = ^(NSString *text) {
            @strongify(self)
            [self.Qukan_Keyboard endEditing];
            [self.Qukan_Keyboard clearText];
            if (text.length>0) {
                [self Qukan_CommentAdd:text];
            }
            self.Qukan_Keyboard.placeholder = @"输入评论...";
        };
    }
    return _Qukan_Keyboard;
}

- (QukanNewsComentView *)Qukan_FooterView {
    if (!_Qukan_FooterView) {
        _Qukan_FooterView = [[QukanNewsComentView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) withType:CommentView_NewsDetails_Details];
        [self.view addSubview:_Qukan_FooterView];
        [_Qukan_FooterView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.height.mas_equalTo(isIPhoneXSeries()?74.0:49.0);
        }];
    }
    return _Qukan_FooterView;
}



@end
