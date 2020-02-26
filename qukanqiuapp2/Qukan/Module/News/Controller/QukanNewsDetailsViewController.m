//
//  QukanNewsDetailsViewController.m
//  Qukan
//
//  Created by Kody on 2019/7/17.
//  Copyright © 2019 wukang sports. All rights reserved.
//

#import "QukanNewsDetailsViewController.h"
#import "QukanNewsDetailsTableViewCell.h"

#import "QukanNewsDetalisHeaderView.h"
#import "QukanNullDataView.h"
#import "QukanLXKeyBoard.h"
//#import "QukanBoilingPointDetailCommentView.h"
#import "QukanNewsComentView.h"
#import "QukanApiManager+PersonCenter.h"

#import "QukanNewsDetailsCommentViewController.h"
#import "QukanApiManager+News.h"
#import "QukanNewsChannelModel.h"
#import "ZFUtilities.h"
#import "QukanXLChannelControl.h"
#import <UIViewController+HBD.h>
#import "ZFPlayerControlView.h"
#import <ZFPlayer/ZFAVPlayerManager.h>

#import <IQKeyboardManager/IQKeyboardManager.h>


#import "QukanScreenLiveLineView.h"


@interface QukanNewsDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) UILabel                            *comment_label;
@property(nonatomic, strong) UILabel                            *division_label;

@property(nonatomic, strong) UIView                             *Qukan_VideoHeaderView;
@property (nonatomic, strong) ZFPlayerControlView               *controlView;
@property(nonatomic, strong) UIView                             *statusMaskView; // 竖屏播放视频时状态栏遮罩
@property (nonatomic, strong) UIImageView                       *containerView;
@property(nonatomic, strong) UIImageView                        *shareImageView;
@property(nonatomic, strong) UIButton                           *detailsBackButton;
@property(nonatomic, strong) UIButton                           *playBtn;
@property(nonatomic, strong) UIButton                           *rePlayButton;
@property(nonatomic, strong) UIButton                           *newestButton;
@property(nonatomic, strong) UIButton                           *hotestButton;

/**<#注释#>*/
@property(nonatomic, strong) UIButton   * rightBtn;

@property(nonatomic, strong) QukanNewsDetalisHeaderView         *Qukan_NewsHeaderView;
@property(nonatomic, strong) UITableView                        *Qukan_NewsTableView;
@property(nonatomic, strong) WKWebView                          *Qukan_NewsWebView;
@property (nonatomic,strong) QukanLXKeyBoard                         *Qukan_Keyboard;
//@property (nonatomic, strong)QukanBoilingPointDetailCommentView *Qukan_ComentView;
@property(nonatomic, strong) QukanNewsComentView                *Qukan_FooterView;
@property(nonatomic, strong) QukanShareView                     *Qukan_ShareView;

@property(nonatomic, strong) NSMutableArray                     *Qukan_NewsDataArray;
@property(nonatomic, strong) NSArray                            *Qukan_TestArray;

@property(nonatomic, copy) NSArray<QukanNewsChannelModel *>     *channelItems;
@property(nonatomic, copy) NSArray<QukanNewsChannelModel *>     *enableChannelItems;
@property(nonatomic, copy) NSArray<QukanNewsChannelModel *>     *disableChannelItems;

@property(nonatomic, copy) NSString                             *weburlStr;
@property(nonatomic, assign) NSInteger                          sortType;
@property(nonatomic, assign) NSInteger                          QukanCommentType;
@property(nonatomic, assign) NSInteger                          page;
@property(nonatomic, assign) CGFloat                            headerHight;

@property(nonatomic, assign) BOOL                               isUse;
@property(nonatomic, assign) BOOL                               isPushIn;
@end

@implementation QukanNewsDetailsViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.player && self.controlView) {
        if (self.player.currentPlayerManager.playState == ZFPlayerPlayStatePaused) {
            if (self.player.currentTime > 3) {
                [self.player.currentPlayerManager play];
            } else {
                [self.player.currentPlayerManager reloadPlayer];
            }
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (!self.navigationController) {
        if (self.videoVCPopCallback) {
            self.videoVCPopCallback();
        }
    } else {
        [self.player.currentPlayerManager pause];
    }
    
    if (self.detailsVcGoBack) {
        self.detailsVcGoBack();
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    //其他方法在判断中添加
    [self creatPlayerWithNull];
    
//    [self Qukan_setNavBarButtonItem];
    [self interFace];
    
    
    DEBUGLog(@"---------%@",self.videoNews);
    @weakify(self)
    [[[kNotificationCenter rac_addObserverForName:kFilterCommentNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable notify) {
        @strongify(self)
        if ([notify.object isKindOfClass:[BlockUserObject class]]) {
            @synchronized (self.Qukan_NewsDataArray) {
                BlockUserObject *obj = notify.object;
                NSString *commentId = obj.extCommentId;
                id remove = nil;
                for (QukanNewsCommentModel *model in self.Qukan_NewsDataArray) {
                    if (model.newsId == commentId.integerValue) {
                        remove = model;
                        break;
                    }
                }
                if (!remove) {
                    return;
                }
                
                [self.Qukan_NewsDataArray removeObject:remove];
                [self.Qukan_NewsTableView reloadData];
            }
            
            [self.view showTip:@"将减少类似的评论"];
        }
    }];
    
    [[[kNotificationCenter rac_addObserverForName:kFilterUserNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable notify) {
        @strongify(self)
        if ([notify.object isKindOfClass:[BlockUserObject class]]) {
            @synchronized (self.Qukan_NewsDataArray) {
                BlockUserObject *obj = notify.object;
                NSString *userId = obj.userId;
                NSMutableArray* keepDatas = [NSMutableArray array];
                for (QukanNewsCommentModel *model in self.Qukan_NewsDataArray) {
                    if (model.userId != userId.integerValue) {
                        [keepDatas addObject:model];
                    }
                }
                [self.Qukan_NewsDataArray removeAllObjects];
                [self.Qukan_NewsDataArray addObjectsFromArray:keepDatas];
                
                [self.Qukan_NewsTableView reloadData];
            }
            
            [self.view showTip:@"将减少类似的评论"];
        }
    }];
    
    // 需要转屏通知
    [[[kNotificationCenter rac_addObserverForName:Qukan_needRotatScreen_notificationName object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        [self.player enterFullScreen:NO animated:YES];
    }];
}

- (void)setNavRightView {
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitleColor:kThemeColor forState:UIControlStateNormal];
    rightBtn.layer.cornerRadius = 2;
    rightBtn.layer.masksToBounds = YES;
    rightBtn.layer.borderColor = kThemeColor.CGColor;
    rightBtn.layer.borderWidth = 1;
    [rightBtn setTitle:FormatString(@"%ld评论",self.videoNews.commentNum) forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(0.0, 0.0, 73.0, 22.0);
    rightBtn.titleLabel.font = kFont12;

    _rightBtn = rightBtn;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)creatPlayerWithNull {
    if (!self.player && self.videoNews.topicNewsType == QukanNewsType_video) {
        self.isPushIn = YES;
        ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
        
        self.player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:self.containerView];
        
        self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
            [UIViewController attemptRotationToDeviceOrientation];
        };
        self.player.controlView = self.controlView;
        self.player.shouldAutoPlay = YES;
        self.player.playerDisapperaPercent = 1.0;
        self.player.stopWhileNotVisible = NO;
        self.controlView.hideBackButton = NO;
        self.player.forceDeviceOrientation = YES;
        self.player.allowOrentitaionRotation = YES;
        
        self.player.assetURL = [NSURL URLWithString:self.videoNews.videoUrl];
        
        @weakify(self);
        self.controlView.backBtnClickCallback = ^{
            @strongify(self)
            [self.player stop];
            [self.navigationController popViewControllerAnimated:YES];
        };
        
        self.controlView.landScapeControlView.backBtnClickCallback = ^{
            @strongify(self)
            [self.player stop];
        };
        
        self.controlView.retryBtnClickCallback = ^{
            @strongify(self)
            if (self.player.assetURL) {
                [self.player playTheIndex:0];
            }
        };
        
        self.controlView.landScapeControlView.shareBtnClickCallback = ^{
            @strongify(self)
            [self Qukan_addShareView];
        };
        
        self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
            @strongify(self)
            for (UIView *view  in self.controlView.subviews) {
                if ([view isKindOfClass:[QukanShareView class]]) {
                    [view removeFromSuperview];
                }
            }
        };
        
    }
}


- (void)Qukan_addShareView {
    [kUMShareManager Qukan_showShareViewWithMainModel:self.videoNews Type:shareScreenTypeLand superView:self.player.controlView];
}


- (void)dealloc {
    NSLog(@"QukanNewsDetailsViewController === dealloc");
}

- (void)Qukan_setNavBarButtonItem{
    if (self.videoNews.newType == 1) {
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightBtn addTarget:self
                     action:@selector(rightBtnClickEvent:)
           forControlEvents:UIControlEventTouchUpInside];
        [rightBtn setImage:kImageNamed(@"Qukan_news_more") forState:UIControlStateNormal];
        rightBtn.frame = CGRectMake(0.0, 0.0, 50.0, 44.0);
        rightBtn.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
        self.navigationItem.rightBarButtonItem = rightItem;
        
        self.navigationItem.leftBarButtonItem = nil;
        rightBtn.hidden = YES;
    }
}

- (void)interFace {
    self.view.backgroundColor = kCommentBackgroudColor;
    self.navigationItem.title = AppName;
//    self.hbd_barHidden = YES;
    _page = 1;
    _sortType = 1;
    self.isUse = YES;
    self.Qukan_NewsDataArray = [NSMutableArray arrayWithCapacity:0];
    
    [self judgeVideoOrNews];
}

- (void)judgeVideoOrNews {
    @weakify(self)
    if (self.videoNews.newType == 1) {//新闻
        self.edgesForExtendedLayout = UIRectEdgeNone;
        [self setNavRightView];
        [self.view addSubview:self.division_label];
        [self.division_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.left.offset(0);
            make.height.offset(8);
        }];
        
        self.Qukan_NewsHeaderView.QukanNews_GetHightBlock = ^(CGFloat hight) {
            @strongify(self)
            [self addTableView];
            [self Qukan_refreshData];
            [self Qukan_NewsRead];
            [self Qukan_NewsComment];
            self.Qukan_NewsHeaderView.frame = CGRectMake(0, 8, kScreenWidth - 20, hight);
            self.Qukan_NewsWebView.frame = CGRectMake(0, 8, kScreenWidth - 20, hight);
            self.Qukan_NewsTableView.tableHeaderView = self.Qukan_NewsHeaderView;
            [self.view bringSubviewToFront:self.Qukan_Keyboard];
            [self.Qukan_NewsTableView reloadData];
        };
        [self Qukan_userReadAdd];
    } else if (self.videoNews.newType == 2) {//视频
        self.view.backgroundColor = kViewControllerBackgroundColor;
        self.hbd_barHidden = YES;
        
        [self.Qukan_VideoHeaderView addSubview:self.statusMaskView];
        [self.Qukan_VideoHeaderView addSubview:self.containerView];
        [self.containerView addSubview:self.playBtn];
        [self.player addPlayerViewToContainerView:self.containerView];
        [self.containerView addSubview:self.detailsBackButton];
        self.detailsBackButton.hidden = YES;
        
        self.player.playerPlayStateChanged = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, ZFPlayerPlaybackState playState) {
            @strongify(self)
            if (playState == ZFPlayerPlayStatePlayStopped) {
                self.detailsBackButton.hidden = NO;
            } else {
                self.detailsBackButton.hidden = YES;
            }
        };
        
        self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
               @strongify(self)
               [self setNeedsStatusBarAppearanceUpdate];
               [UIViewController attemptRotationToDeviceOrientation];
            
            for (UIView *view  in self.controlView.subviews) {
                if ([view isKindOfClass:[QukanShareView class]]) {
                    [view removeFromSuperview];
                }
            }
            
            for (UIView *view in self.controlView.subviews) {
                if ([view isKindOfClass:[QukanScreenLiveLineView class]]) {
                    [view removeFromSuperview];
                }
            }
               
               //键盘消失呢
               [self.view endEditing:YES];
           };
        
        [self addTableView];
        [self Qukan_refreshData];
        [self Qukan_NewsRead];
        [self Qukan_NewsComment];
    }
    
    
    self.Qukan_FooterView.putBlock = ^(NSInteger type) {
        @strongify(self)
        self.Qukan_Keyboard.placeholder = @"输入评论...";
        self.QukanCommentType = 0;
        [self.Qukan_Keyboard becomeFirstResponder];
    };
    
    self.Qukan_FooterView.addShareViewBlock = ^{
        @strongify(self)
        [self addShareView];
    };
    
    self.Qukan_FooterView.addCommentViewBlock = ^{
        @strongify(self)
        QukanNewsDetailsCommentViewController *vc = [[QukanNewsDetailsCommentViewController alloc] init];
        vc.videoNews = self.videoNews;
        vc.commentVcBlock = ^{
            [self.player.currentPlayerManager play];
        };
        [self.player.currentPlayerManager pause];
        [self.navigationController pushViewController:vc animated:YES];
    };
}



- (void)addTableView {
    if (self.videoNews.newType == 1) {
        self.Qukan_NewsTableView.tableHeaderView = self.Qukan_NewsHeaderView;
        self.Qukan_NewsTableView.mj_footer.hidden = YES;
        [self.Qukan_NewsTableView reloadData];
    } else if (self.videoNews.newType == 2) {
        [self.Qukan_NewsTableView reloadData];
    }
}

#pragma mark ===================== Notification ==================================


#pragma mark ===================== Public Methods =======================
- (void)addNewestAndHotestButtonAddView:(UIView *)view addType:(NSInteger)newsType {
    NSArray *titleArray = @[@"全部",@"热门"];
    CGFloat buttonW = 50;
    for (int i = 0 ; i < 2; i ++) {
        UIButton *buttton = [[UIButton alloc] initWithFrame:CGRectMake(buttonW * i, 10, buttonW, 40)];
        if (newsType == 2) {//视频的时候
            buttton.frame = CGRectMake(buttonW * i, 40 + _headerHight, buttonW, 40);
        }
        [buttton setTitle:titleArray[i] forState:UIControlStateNormal];
        [view addSubview:buttton];
        [buttton addTarget:self action:@selector(buttonCilck:) forControlEvents:UIControlEventTouchUpInside];
        buttton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [buttton setTitleColor:kCommonTextColor forState:UIControlStateNormal];
        [buttton setTitleColor:kThemeColor forState:UIControlStateSelected];
        
        UILabel *hotLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, 20, 8)];
        hotLabel.text = @"HOT";
        hotLabel.textColor = [UIColor whiteColor];
        hotLabel.textAlignment = NSTextAlignmentCenter;
        hotLabel.backgroundColor = kThemeColor;
        hotLabel.font = [UIFont systemFontOfSize:6];
        hotLabel.layer.cornerRadius = 4;
        hotLabel.layer.masksToBounds = YES;
        [buttton addSubview:hotLabel];
        
        if (_sortType == 1) {
            if (i == 0) {
                buttton.selected = YES;
                _newestButton = buttton;
                hotLabel.hidden = YES;
            } else {
                buttton.selected = NO;
                _hotestButton = buttton;
            }
        } else if (_sortType == 2) {
            if (i == 0) {
                buttton.selected = NO;
                _newestButton = buttton;
                hotLabel.hidden = YES;
            } else {
                buttton.selected = YES;
                _hotestButton = buttton;
            }
        }
        buttton.tag = i;
    }
}

- (void)addLineLabelAddView:(UIView *)view  {
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, view.height - 3, 30, 2)];
    if (_sortType == 1) {
        lineLabel.frame = CGRectMake(10, view.height - 3, 30, 2);
    } else if (_sortType == 2) {
        lineLabel.frame = CGRectMake(10 + 50, view.height - 3, 30, 2);
    }
    lineLabel.backgroundColor = kThemeColor;
    [view addSubview:lineLabel];
}

- (void)addShareView {
    [kUMShareManager Qukan_showShareViewWithMainModel:self.videoNews Type:shareScreenTypePort superView:kwindowLast];
}

#pragma mark ===================== NetWork ==================================

- (void)Qukan_userReadAdd {
    if (self.videoNews.newType == QukanNewsType_web) {
        @weakify(self)
        [[[kApiManager QukanUserReadAddWithSourceId:self.videoNews.nid WithSourceType:self.videoNews.newType WithStopTime:0] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            KHideHUD
        } error:^(NSError * _Nullable error) {
        }];
    }
}

- (void)Qukan_NewsRead {
    @weakify(self)
    [[[kApiManager QukannewsReadNumWithNewsId:[NSString stringWithFormat:@"%ld",self.videoNews.nid]] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.videoNews.readNum = self.videoNews.readNum + 1;
    } error:^(NSError * _Nullable error) {
    }];
}

- (void)Qukan_NewsComment {
    @weakify(self)
    [[[kApiManager QukancommentSearchCountWithSourceId:self.videoNews.nid addSourceType:1] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.videoNews.commentNum = [x integerValue];
    } error:^(NSError * _Nullable error) {
    }];
}


- (void)Qukan_refreshData {
    self.page = 1;
    [self Qukan_requestData];
}

- (void)Qukan_requestData {
    @weakify(self)
    [[[kApiManager QukancommentSearchWithsourceId:self.videoNews.nid addsourceType:1 addSortType:_sortType addcurrent:_page addsize:10] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self dataSourceDealWith:x];
    } error:^(NSError * _Nullable error) {
        [self.Qukan_NewsTableView.mj_header endRefreshing];
    }];
}

- (void)Qukan_requestListMore {
    self.page ++;
    [self Qukan_requestData];
}

- (void)Qukan_CommentAdd:(NSString *)text {
    @weakify(self)
    [[[kApiManager QukancommentAddWithsourceId:self.videoNews.nid addsourceType:1 addCommentContent:text] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.page = 1;
        self.videoNews.commentNum = self.videoNews.commentNum + 1;
        self.comment_label.text = FormatString(@"%ld评论",self.videoNews.commentNum);
        [self.rightBtn setTitle:FormatString(@"%ld评论",self.videoNews.commentNum) forState:UIControlStateNormal];
        [self Qukan_refreshData];
        [SVProgressHUD showSuccessWithStatus:@"发表成功"];
        [kNotificationCenter postNotificationName:@"Qukan_Nsnotition_CommentNumberChange" object:nil];
    } error:^(NSError * _Nullable error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}


- (void)Qukan_netWorkClickRetry {
    [QukanFailureView Qukan_hideWithView:self.view];
    [self.Qukan_NewsWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.weburlStr ?:self.weburlStr]]];
}


- (void)dataSourceDealWith:(id)response {
    NSArray *array = (NSArray *)response[@"records"];
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        QukanNewsCommentModel *model = [QukanNewsCommentModel modelWithDictionary:dict];
        if (![[QukanFilterManager sharedInstance] isFilteredComment:model.userId]) {
            [modelArray addObject:model];
        }
    }
    
    if (self.page == 1 || self.Qukan_NewsDataArray.count == 0) {
        self.Qukan_NewsDataArray = [NSMutableArray array];
        [self.Qukan_NewsTableView.mj_header endRefreshing];
    }
    //过滤
    for (QukanNewsCommentModel *model in modelArray) {
        if (![[QukanFilterManager sharedInstance] isFilteredComment:model.newsId] && (![[QukanFilterManager sharedInstance] isBlockedUser:model.userId])) {
            [self.Qukan_NewsDataArray addObject:model];
        }
    }

    self.page += 0;
    
    self.Qukan_NewsTableView.mj_footer.hidden = self.Qukan_NewsDataArray.count == 0;
    if (modelArray.count < 10) {
        [self.Qukan_NewsTableView.mj_footer endRefreshingWithNoMoreData];
    }else {
        [self.Qukan_NewsTableView.mj_footer endRefreshing];
    }
    self.Qukan_NewsTableView.mj_footer.hidden = self.Qukan_NewsDataArray.count == 0;
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
    if (self.videoNews.newType == 1 && self.Qukan_NewsDataArray.count > 0) {
        return self.Qukan_NewsDataArray.count > 0 ? 50 : 0;
    } else if (self.videoNews.newType == 2){
        return self.Qukan_NewsDataArray.count > 0 ? 80 + _headerHight :  80 + _headerHight;
    } else {
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    QukanNewsCommentModel *model = self.Qukan_NewsDataArray[indexPath.row];
    CGFloat cellHight = [model.commentContent heightForFont:kFont14 width:kScreenWidth - 33];
    return cellHight + 75;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.videoNews.newType == 1) {
        if (self.Qukan_NewsDataArray.count > 0) {
            UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, _headerHight + 50)];
            headView.backgroundColor = [UIColor whiteColor];
            
            //
            UIButton *lineButton = [UIButton buttonWithType:UIButtonTypeCustom];
            lineButton.frame = CGRectMake(0, 0, kScreenWidth, 10);
            lineButton.backgroundColor = RGBA(242, 242, 242, 1);
            [headView addSubview:lineButton];
            
            [self addNewestAndHotestButtonAddView:headView addType:self.videoNews.newType];
            [self addLineLabelAddView:headView];
            
            return headView;
        } else {
            return nil;
        }
    } else {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, _headerHight + 80)];
        headView.backgroundColor = [UIColor whiteColor];
        //添加标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, kScreenWidth - 20, 30)];
        titleLabel.text = self.videoNews.title;
        titleLabel.textColor = kCommonBlackColor;
        titleLabel.font = kFont15;
        [headView addSubview:titleLabel];
        titleLabel.numberOfLines = 0;
        [titleLabel sizeToFit];
        CGSize size = [titleLabel sizeThatFits:CGSizeMake(kScreenWidth - 20, MAXFLOAT)];
        _headerHight = size.height;
        
        CGFloat readW = floor([[NSString stringWithFormat:@"%ld阅",self.videoNews.readNum] widthForFont:kFont12]);
        CGFloat commentW = floor([[NSString stringWithFormat:@"%ld评",self.videoNews.commentNum] widthForFont:kFont12]);
        //添加阅读量和评论数
        UILabel *readLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(titleLabel.frame) + 10, readW + 5, 20)];
        readLabel.text = [NSString stringWithFormat:@"%ld阅",self.videoNews.readNum];
        readLabel.textColor = [UIColor lightGrayColor];
        readLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
        readLabel.font = kFont12;
        readLabel.textAlignment = NSTextAlignmentCenter;
        [headView addSubview:readLabel];
        
        UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(readLabel.frame) + 8, CGRectGetMaxY(titleLabel.frame) + 10, commentW + 5, 20)];
        commentLabel.text = [NSString stringWithFormat:@"%ld评",self.videoNews.commentNum];
        commentLabel.textColor = [UIColor lightGrayColor];
        commentLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
        commentLabel.font = kFont12;
        commentLabel.textAlignment = NSTextAlignmentCenter;
        [headView addSubview:commentLabel];
        
        //
        [self addNewestAndHotestButtonAddView:headView addType:self.videoNews.newType];
        
        headView.layer.shadowColor = kCommonBlackColor.CGColor;
        headView.layer.shadowOpacity = 0.2f;
        headView.layer.shadowRadius = 4.0f;
        headView.layer.shadowOffset = CGSizeMake(0,0);//Defaults to (0, -3). Animatable.
        
        return headView;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellStr = @"QukanNewsDetailsTableViewCell";
    QukanNewsDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    QukanNewsCommentModel *model = self.Qukan_NewsDataArray[indexPath.row];
    [cell Qukan_SetNewsDetailsWith:model];
    @weakify(self)
    cell.QukanNewsDetails_didSeleLivesBlock = ^{
        @strongify(self)
        [self Qukan_requestData];
    };
    return cell;
}

#pragma mark ===================== Actions ============================

-(void)rightBtnClickEvent:(UIButton *)sender{
    NSArray *enables = [self.enableChannelItems.rac_sequence map:^id _Nullable(QukanNewsChannelModel * _Nullable value) {
        return value.channelName;
    }].array;
    
    NSArray *disables = [self.disableChannelItems.rac_sequence map:^id _Nullable(QukanNewsChannelModel * _Nullable value) {
        return value.channelName;
    }].array;
//    @weakify(self)
    [[QukanXLChannelControl shareControl] showChannelViewWithEnabledTitles:enables disabledTitles:disables finish:^(NSArray *enabledTitles, NSArray *disabledTitles) {
//        @strongify(self)
        //        NSMutableArray *temp = [NSMutableArray array];
        //        [self.channelItems enumerateObjectsUsingBlock:^(QukanNewsChannelModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //            NSInteger index = [enabledTitles indexOfObject:obj.channelName];
        //            if (index != NSNotFound) {
        //                obj.sort = index;
        //                [temp addObject:obj];
        //            }
        //        }];
    }];
}

- (void)playClick:(UIButton *)sender {
    if (self.videoVCPlayCallback) {
        self.videoVCPlayCallback();
    }
    [self.player addPlayerViewToContainerView:self.containerView];
}

- (void)buttonCilck:(UIButton *)button {
    if (button.tag == 0) {//最新
        _newestButton.selected = YES;
        _hotestButton.selected = NO;
        _sortType = 1;
        _page = 1;
        [self Qukan_requestData];
    } else {//热门
        _newestButton.selected = NO;
        _hotestButton.selected = YES;
        _sortType = 2;
        _page = 1;
        [self Qukan_requestData];
    }
}

#pragma mark ===================== Rotation ==================================
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

- (BOOL)shouldAutorotate {
    return self.player.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.player.isFullScreen && self.player.orientationObserver.fullScreenMode == ZFFullScreenModeLandscape) {
        return UIInterfaceOrientationMaskLandscape;
    }
    return UIInterfaceOrientationMaskPortrait;
}


#pragma mark ===================== Getters =================================

- (UILabel *)comment_label {
    if (!_comment_label) {
        _comment_label = UILabel.new;
        _comment_label.layer.cornerRadius = 2;
        _comment_label.layer.masksToBounds = YES;
        _comment_label.layer.borderWidth = 1.0f;
        _comment_label.layer.borderColor = kThemeColor.CGColor;
        _comment_label.backgroundColor = kCommonWhiteColor;
        _comment_label.textColor = kThemeColor;
        _comment_label.font = kFont12;
        _comment_label.textAlignment = NSTextAlignmentCenter;
        _comment_label.text = FormatString(@"%ld评论",self.videoNews.commentNum);
    }
    return _comment_label;
}

- (UILabel *)division_label {
    if (!_division_label) {
        _division_label = UILabel.new;
        _division_label.backgroundColor = kSecondTableViewBackgroudColor;
    }
    return _division_label;
}

- (UIView *)Qukan_VideoHeaderView {
    if (!_Qukan_VideoHeaderView) {
        _Qukan_VideoHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth / 16 * 9 + 38)];
        if (!isIPhoneXSeries()) {
            _Qukan_VideoHeaderView.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth / 16 * 9 + 18);
        }
        [self.view addSubview:_Qukan_VideoHeaderView];
        _Qukan_VideoHeaderView.backgroundColor = [UIColor whiteColor];
    }
    return _Qukan_VideoHeaderView;
}


- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
        _controlView.hideBackButton = YES;
        _controlView.prepareShowLoading = YES;
//        @weakify(self)
        //        _controlView.retryBtnClickCallback = ^{
        //            @strongify(self)
        //            [self zf_playTheVideoAtIndexPath:self.tableView.zf_playingIndexPath];
        //        };
    }
    return _controlView;
}

- (UIButton *)detailsBackButton {
    if (!_detailsBackButton) {
        _detailsBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _detailsBackButton.frame = CGRectMake(0, 0, 60, 40);
        [_detailsBackButton setImage:kImageNamed(@"Qukan_Play_Back") forState:UIControlStateNormal];
        _detailsBackButton.backgroundColor = [UIColor clearColor];
        @weakify(self);
        [[_detailsBackButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    return _detailsBackButton;
}

- (UIImageView *)containerView {
    if (!_containerView) {
        _containerView = [UIImageView new];
        [_containerView sd_setImageWithURL:[NSURL URLWithString:self.videoNews.imageUrl] placeholderImage:[UIImage imageWithColor:RGB(0, 0, 0)]];
    }
    return _containerView;
}

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[ZFUtilities imageNamed:@"new_allPlay_44x44_"] forState:UIControlStateNormal];
        //        [_playBtn setTitle:@"重播" forState:UIControlStateNormal];
        //        _playBtn.titleLabel.font = kFont15;
        //        _playBtn.backgroundColor = [UIColor lightGrayColor];
        [_playBtn addTarget:self action:@selector(playClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

- (UIButton *)rePlayButton {
    if (!_rePlayButton) {
        _rePlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rePlayButton.backgroundColor = [UIColor redColor];
    }
    return _rePlayButton;
}

- (UIView *)statusMaskView {
    if (!_statusMaskView) {
        _statusMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kTopBarHeight)];
        _statusMaskView.backgroundColor = RGBA(0, 0, 0, 0.9);
    }
    
    return _statusMaskView;
}


- (QukanNewsDetalisHeaderView *)Qukan_NewsHeaderView {
    if (!_Qukan_NewsHeaderView) {
        _Qukan_NewsHeaderView = [[QukanNewsDetalisHeaderView alloc] initWithFrame:CGRectMake(0, 8, kScreenWidth, 200) withDict:self.videoNews];
        _Qukan_NewsHeaderView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_Qukan_NewsHeaderView];
    }
    return _Qukan_NewsHeaderView;
}

- (UITableView *)Qukan_NewsTableView {
    
    extern CGFloat tabBarHeight;
    
    if (!_Qukan_NewsTableView) {
        _Qukan_NewsTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _Qukan_NewsTableView.backgroundColor = [UIColor clearColor];
        _Qukan_NewsTableView.delegate = self;
        _Qukan_NewsTableView.dataSource = self;
        [self.view addSubview:_Qukan_NewsTableView];
        _Qukan_NewsTableView.estimatedSectionHeaderHeight = 0;
        _Qukan_NewsTableView.estimatedSectionFooterHeight = 0;
        _Qukan_NewsTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        _Qukan_NewsTableView.rowHeight = SCALING_RATIO(80);
        //        _Qukan_myTableView.rowHeight = UITableViewAutomaticDimension;
        
        _Qukan_NewsTableView.showsVerticalScrollIndicator = NO;
        _Qukan_NewsTableView.tableFooterView = [UIView new];
        [_Qukan_NewsTableView registerClass:[QukanNewsDetailsTableViewCell class] forCellReuseIdentifier:@"QukanNewsDetailsTableViewCell"];
        _Qukan_NewsTableView.mj_header = [QukanHomeRefreshHeader headerWithRefreshingTarget:self
                                                                           refreshingAction:@selector(Qukan_refreshData)];
        _Qukan_NewsTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(Qukan_requestListMore)];
        
        [_Qukan_NewsTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (self.videoNews.newType == 1) {
                make.top.equalTo(self.view).offset(10);
            } else if (self.videoNews.newType == 2) {
                if (isIPhoneXSeries()) {
                    make.top.equalTo(self.view).offset(kScreenWidth / 16 * 9 + 38);
                } else {
                    make.top.equalTo(self.view).offset(kScreenWidth / 16 * 9 + 18);
                }
            }
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
            self.QukanCommentType = 0;
        };
    }
    return _Qukan_Keyboard;
}

- (QukanNewsComentView *)Qukan_FooterView {
    if (!_Qukan_FooterView) {
        _Qukan_FooterView = [[QukanNewsComentView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) withType:CommentView_NewsDetails withModel:self.videoNews];
        [self.view addSubview:_Qukan_FooterView];
        [_Qukan_FooterView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.height.mas_equalTo(isIPhoneXSeries()?74.0:49.0);
        }];
    }
    return _Qukan_FooterView;
}

- (UIImageView *)shareImageView {
    if (!_shareImageView) {
        _shareImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        [_shareImageView sd_setImageWithURL:[NSURL URLWithString:self.videoNews.imageUrl] placeholderImage:kImageNamed(@"Qukan_placeholder")];
    }
    return _shareImageView;
}

#pragma mark ===================== Layout =======================
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGFloat x = 0;
    CGFloat y = kStatusBarHeight;
    CGFloat w = CGRectGetWidth(self.view.frame);
    CGFloat h = w*9/16;
    self.containerView.frame = CGRectMake(x, y, w, h);
    
    w = 44;
    h = w;
    x = (CGRectGetWidth(self.containerView.frame)-w)/2;
    y = (CGRectGetHeight(self.containerView.frame)-h)/2;
    self.playBtn.frame = CGRectMake(x, y, w, h);
    
    self.playBtn.layer.cornerRadius = w / 2;
    self.playBtn.layer.masksToBounds = YES;
}


@end
