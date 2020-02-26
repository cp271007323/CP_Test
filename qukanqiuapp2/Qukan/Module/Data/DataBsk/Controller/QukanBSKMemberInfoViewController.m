//
//  QukanBSKMemberInfoViewController.m
//  Qukan
//
//  Created by blank on 2019/12/26.
//  Copyright © 2019 mac. All rights reserved.
//
#define Tag_Seg 0x11
#import "QukanBSKMemberInfoViewController.h"
#import <UIViewController+HBD.h>
#import "QukanApiManager+QukanDataBSK.h"
#import "QukanBSKMemberDetailInfoCell.h"
#import "QukanBSKMemberDetailTCell.h"
#import "QukanBSKMemberDetailDataTopCell.h"
#import "QukanBSKMemberDetailDataBotCell.h"

@interface QukanBSKMemberInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong)UIImageView *icon;
@property (nonatomic, strong)UILabel *name;
@property (nonatomic, strong)UILabel *team;
@property (nonatomic, strong)UILabel *location;
@property (nonatomic, strong)UILabel *prLab;
@property (nonatomic, strong)UIView *segmentLine;
@property (nonatomic, strong)UITableView *dataTableView;
@property (nonatomic, strong)UITableView *infoTableView;
@property (nonatomic, strong)UIScrollView *mScrollView;
@property (nonatomic, strong)QukanBSKDataPlayerDetailModel *infoModel;
@property (nonatomic, assign)BOOL showEmpty_data;
@end

@implementation QukanBSKMemberInfoViewController
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kTableViewCommonBackgroudColor;
    self.hbd_barHidden = 1;
    [self initTopView];
    [self QukanInitTab];
    [self QukanLoadData];
}
- (void)initTopView {
    UIView *topBack = [UIView new];
    [self.view addSubview:topBack];
    [topBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
        make.height.offset(295);
    }];
    topBack.backgroundColor = HEXColor(0x2f2f2f);
    
    UIImageView *igv = [UIImageView new];
    [topBack addSubview:igv];
    [igv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(kStatusBarHeight + 8);
        make.width.offset(11);
        make.height.offset(18);
    }];
    igv.image = kImageNamed(@"返回_白色");
    igv.userInteractionEnabled = 1;
    
    UIButton *backBtn = [UIButton new];
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.offset(20);
        make.width.offset(64);
        make.height.offset(64);
    }];
    [backBtn addTarget:self action:@selector(QukanBackClick) forControlEvents:UIControlEventTouchUpInside];
    
    [topBack addSubview:self.icon];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.mas_equalTo(igv.mas_bottom).offset(16);
        make.width.height.offset(70);
    }];
    
    [topBack addSubview:self.name];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.mas_equalTo(self.icon.mas_bottom).offset(10);
        make.height.offset(22);
    }];
    
    
    UIView *verticleLine1 = [UIView new];
    [topBack addSubview:verticleLine1];
    [verticleLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.icon.mas_left).offset(-45);
        make.height.offset(22);
        make.width.offset(1);
        make.top.mas_equalTo(self.name.mas_bottom).offset(22);
    }];
    verticleLine1.backgroundColor = COLOR_HEX(0xffffff, 0.1);
    
    UIView *verticleLine2 = [UIView new];
    [topBack addSubview:verticleLine2];
    [verticleLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.icon.mas_right).offset(45);
        make.height.offset(22);
        make.width.offset(1);
        make.top.mas_equalTo(self.name.mas_bottom).offset(22);
    }];
    verticleLine2.backgroundColor = COLOR_HEX(0xffffff, 0.1);
    
    [topBack addSubview:self.team];
    [self.team mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(verticleLine1.mas_right).offset(4);
        make.right.mas_equalTo(verticleLine2.mas_left).offset(-4);
        make.centerY.mas_equalTo(verticleLine1.mas_centerY).offset(0);
        make.height.offset(44);
    }];
    
    [topBack addSubview:self.location];
    [self.location mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(verticleLine1.mas_left).offset(-22);
        make.centerY.mas_equalTo(verticleLine1.mas_centerY).offset(0);
        make.height.offset(20);
    }];
    
    [topBack addSubview:self.prLab];
    [self.prLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(verticleLine2.mas_right).offset(22);
        make.centerY.mas_equalTo(verticleLine2.mas_centerY).offset(0);
        make.height.offset(20);
    }];
    
    UIView *segmentView = [UIView new];
    [topBack addSubview:segmentView];
    [segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.offset(46);
    }];
    segmentView.backgroundColor = COLOR_HEX(0x000000, 0.1);
    CGFloat width = 60;
    CGFloat blank = (kScreenWidth - 170 - 120);
    NSArray *titles = @[@"数据",@"资料"];
    for (int i = 0;i < titles.count;i++) {
        UIButton *btn = [UIButton new];
        [segmentView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(85 + i *(width + blank));
            make.width.offset(width);
            make.bottom.top.offset(0);
        }];
        btn.tag = Tag_Seg + i;
        btn.selected = i == 0 ? 1 : 0;
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        [btn addTarget:self action:@selector(QukanSegClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:kThemeColor forState:UIControlStateSelected];
        [btn setTitleColor:HEXColor(0xB5B5B5) forState:UIControlStateNormal];
    }
    [segmentView addSubview:self.segmentLine];
    self.segmentLine.frame = CGRectMake(85, 42, width, 4);
    
}
- (void)QukanInitTab {
    [self.view addSubview:self.mScrollView];
    self.mScrollView.frame = CGRectMake(0, 295, kScreenWidth, kScreenHeight - 295);
    [self.mScrollView addSubview:self.dataTableView];
    [self.mScrollView addSubview:self.infoTableView];
    self.dataTableView.frame = CGRectMake(0, 0, kScreenWidth, self.mScrollView.height-kSafeAreaBottomHeight);
    self.infoTableView.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, self.mScrollView.height-kSafeAreaBottomHeight);
    
}
- (void)QukanLoadData {
    KShowHUD
    [[[kApiManager QukanSelectPlayerDetailWith:self.pid] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        self.infoModel = [QukanBSKDataPlayerDetailModel modelWithDictionary:x];
        [self setTopData];
        KHideHUD
        self.showEmpty_data = self.infoModel.seasonAvgData.count == 0;
        [self.infoTableView reloadData];
        [self.dataTableView reloadData];
    } error:^(NSError * _Nullable error) {
        KHideHUD
        self.showEmpty_data = 1;
    }];
}
- (void)setTopData {
    self.team.text = self.playerTeam;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:self.infoModel.photo] placeholderImage:kImageNamed(@"Player_defaultAvatar")];
    self.location.text = self.infoModel.place;
    self.name.text = self.infoModel.nameJ;
    self.prLab.text = self.infoModel.salary.length ? FormatString(@"%@万美元",self.infoModel.salary) : @"---";;
}
- (void)QukanBackClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)QukanSegClick:(UIButton *)sender {
    NSArray *btns = @[(UIButton *)[self.view viewWithTag:Tag_Seg],(UIButton *)[self.view viewWithTag:Tag_Seg + 1]];
    for (UIButton *btn in btns) {
        btn.selected = 0;
    }
    sender.selected = 1;
    [self.mScrollView setContentOffset:CGPointMake(kScreenWidth * (sender.tag -Tag_Seg), 0) animated:YES];
    UITableView *tableView = nil;
    tableView = sender.tag == Tag_Seg ? self.dataTableView : self.infoTableView;
    [tableView reloadData];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat width = 60;
    CGFloat blank = (kScreenWidth - 170 - 120);
    int i = self.mScrollView.contentOffset.x/kScreenWidth;
    
    NSArray *btns = @[(UIButton *)[self.view viewWithTag:Tag_Seg],(UIButton *)[self.view viewWithTag:Tag_Seg + 1]];
    for (UIButton *btn in btns) {
        btn.selected = btn.tag == i + Tag_Seg ? 1 : 0;
    }
    self.segmentLine.frame = CGRectMake(85+self.mScrollView.contentOffset.x/kScreenWidth * (blank + width), 42, width, 4);
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.infoTableView) {
        if (indexPath.section == 0) {
            return 420;
        } else {
            return 50;
        }
    } else {
        if (indexPath.section == 0) {
            return 35 + 25 * 2;
        } else {
            return 35 + 30 * (self.infoModel.careerTechnicData.count + 1);
        }
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return tableView == self.infoTableView ? 2 : 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.infoTableView) {
        return section == 0 ? 1 : self.infoModel.change.count;
    } else {
        return section == 0 ? (self.infoModel.seasonAvgData.count ? 1 : 0) : (self.infoModel.careerTechnicData.count ? 1 : 0);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.infoTableView) {
        if (indexPath.section == 0) {
            QukanBSKMemberDetailInfoCell *infoCell = [tableView dequeueReusableCellWithIdentifier:@"QukanBSKMemberDetailInfoCell"];
            infoCell.model = self.infoModel;
            infoCell.selectionStyle = 0;
            return infoCell;
        } else {
            QukanBSKMemberDetailTCell *transfer = [tableView dequeueReusableCellWithIdentifier:@"QukanBSKMemberDetailTCell"];
            transfer.model = self.infoModel.change[indexPath.row];
            transfer.selectionStyle = 0;
            return transfer;
        }
    } else {
        if (indexPath.section == 0) {
            QukanBSKMemberDetailDataTopCell *top = [tableView dequeueReusableCellWithIdentifier:@"QukanBSKMemberDetailDataTopCell"];
                top.seasonDataArray = self.infoModel.seasonAvgData;
            top.selectionStyle = 0;
            return top;
        } else {
            QukanBSKMemberDetailDataBotCell *bot = [tableView dequeueReusableCellWithIdentifier:@"QukanBSKMemberDetailDataBotCell"];
                bot.careerTechnicDataArray = self.infoModel.careerTechnicData;
            bot.selectionStyle = 0;
            return bot;
        }
    }
}
#pragma mark ===================== DZNEmptyDataSetSource ==================================
// 占位图提示文本
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *description = @"暂无数据";
    return [[NSAttributedString alloc] initWithString:description attributes:@{NSFontAttributeName : kFont16,NSForegroundColorAttributeName : [UIColor grayColor]}];
}
// 占位图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *imageName = @"Qukan_Null_Data";
    return [UIImage imageNamed:imageName];
}
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return self.showEmpty_data;
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [UIImageView new];
        _icon.layer.cornerRadius = 35;
        _icon.layer.masksToBounds = 1;
        _icon.backgroundColor = kCommonWhiteColor;
        _icon.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _icon;
}
- (UILabel *)name {
    if (!_name) {
        _name = [UILabel new];
        _name.textColor = kCommonWhiteColor;
        _name.font = kFont16;
        _name.textAlignment = NSTextAlignmentCenter;
    }
    return _name;
}

- (UILabel *)location {
    if (!_location) {
        _location = [UILabel new];
        _location.textColor = kCommonWhiteColor;
        _location.font = kFont14;
        _location.textAlignment = NSTextAlignmentRight;
    }
    return _location;
}
- (UILabel *)team {
    if (!_team) {
        _team = [UILabel new];
        _team.textColor = kCommonWhiteColor;
        _team.font = kFont14;
        _team.textAlignment = NSTextAlignmentCenter;
        _team.numberOfLines = 0;
    }
    return _team;
}
- (UILabel *)prLab {
    if (!_prLab) {
        _prLab = [UILabel new];
        _prLab.font = kFont14;
        _prLab.textColor = kCommonWhiteColor;
        _prLab.textAlignment = NSTextAlignmentLeft;
    }
    return _prLab;
}
- (UIScrollView *)mScrollView {
    if (!_mScrollView) {
        _mScrollView = [UIScrollView new];
        _mScrollView.contentSize = CGSizeMake(kScreenWidth * 2, 0);
        _mScrollView.delegate = self;
        _mScrollView.pagingEnabled = 1;
        _mScrollView.backgroundColor = kTableViewCommonBackgroudColor;
    }
    return _mScrollView;
}
- (UITableView *)dataTableView {
    if (!_dataTableView) {
        _dataTableView = [UITableView new];
        _dataTableView.showsVerticalScrollIndicator = 0;
        _dataTableView.separatorStyle = 0;
        _dataTableView.delegate = self;
        _dataTableView.dataSource = self;
        _dataTableView.backgroundColor = kTableViewCommonBackgroudColor;
        [_dataTableView registerClass:[QukanBSKMemberDetailDataTopCell class] forCellReuseIdentifier:@"QukanBSKMemberDetailDataTopCell"];
        [_dataTableView registerClass:[QukanBSKMemberDetailDataBotCell class] forCellReuseIdentifier:@"QukanBSKMemberDetailDataBotCell"];
        _dataTableView.emptyDataSetSource = self;
        _dataTableView.emptyDataSetDelegate = self;
    }
    return _dataTableView;
}
- (UITableView *)infoTableView {
    if (!_infoTableView) {
        _infoTableView = [UITableView new];
        _infoTableView.showsVerticalScrollIndicator = 0;
        _infoTableView.separatorStyle = 0;
        _infoTableView.delegate = self;
        _infoTableView.dataSource = self;
        _infoTableView.backgroundColor = kTableViewCommonBackgroudColor;
        [_infoTableView registerClass:[QukanBSKMemberDetailTCell class] forCellReuseIdentifier:@"QukanBSKMemberDetailTCell"];
        [_infoTableView registerClass:[QukanBSKMemberDetailInfoCell class] forCellReuseIdentifier:@"QukanBSKMemberDetailInfoCell"];
    }
    return _infoTableView;
}
- (UIView *)segmentLine {
    if (!_segmentLine) {
        _segmentLine = [UIView new];
        _segmentLine.backgroundColor = kThemeColor;
    }
    return _segmentLine;
}
- (QukanBSKDataPlayerDetailModel *)infoModel {
    if (!_infoModel) {
        _infoModel = [QukanBSKDataPlayerDetailModel new];
    }
    return _infoModel;
}

@end
