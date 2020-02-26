//
//  QukanLiveLinePopUpView.m
//  Qukan
//
//  Created by Kody on 2019/10/22.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanLiveLinePopUpView.h"
#import "QukanLiveLineModel.h"
#import "QukanHomeModels.h"

#import "QukanUIViewController+Ext.h"

#define kQukanLiveLinePopUpViewRowHeight 50


@interface QukanLiveLinePopUpView ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UIButton   * refreshButton;

@property(nonatomic, strong) UIView    * headerView;
@property(nonatomic, strong) UILabel   * lab_title;

@property(nonatomic, strong) UIView     *clearView;


@property(nonatomic, strong) UITableView   * tabView;

@property(nonatomic, strong) QukanHomeModels   * admodel_main;


@property(nonatomic, strong) UIView   * view_content;

@property(nonatomic, strong) UIButton   *cancleButton;

@property(nonatomic, strong) NSArray  <QukanLiveLineModel *>    *datas;

@property(nonatomic, strong) NSArray  <QukanHomeModels *>      *ads;

@property(nonatomic, assign) NSInteger cellNumber;

@end

@implementation QukanLiveLinePopUpView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.clearColor;
    }
    return self;
}


- (void)dealloc {
    NSLog(@"QukanLiveLinePopUpView ==== 释放");
}

#pragma mark ===================== 初始化刷新数据 ==================================
- (void)showWithBeginData:(NSArray  <QukanLiveLineModel *> *)datas andAds:(NSArray  <QukanHomeModels *> *)ads {
    _datas = datas;
    self.ads = ads;
    
    [self initUI];
    UIViewController *currentVC = [UIViewController visibleViewController];
    [currentVC.view addSubview: self];
    
    [UIView animateWithDuration:0.3f animations:^{
        CGRect frame = self.view_content.frame;
        frame.origin.y = frame.origin.y - frame.size.height;
        self.view_content.frame = frame;
        self.backgroundColor = COLOR_HEX(0x000000, 0.5);
    } completion:^(BOOL finished) {
        
    }];
}


#pragma mark ===================== 移除 ==================================
- (void)removeSelf {
    [UIView animateWithDuration:0.3f animations:^{
        CGRect frame = self.view_content.frame;
        frame.origin.y = kScreenHeight;
        self.view_content.frame = frame;
        self.backgroundColor = UIColor.clearColor;
    } completion:^(BOOL finished) {
        [self removeAllSubviews];
        [self removeFromSuperview];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(QukanLiveLinePopUpViewRereaseView)]) {
            [self.delegate QukanLiveLinePopUpViewRereaseView];
        }
    }];
}

#pragma mark ===================== 布局UI ==================================
- (void)initUI {
    [self addSubview:self.view_content];
    CGFloat h = 80 + kSafeAreaBottomHeight + kQukanLiveLinePopUpViewRowHeight * (self.datas.count + self.ads.count);
    self.view_content.frame = CGRectMake(0, kScreenHeight, kScreenWidth, h);
    
    [self.view_content addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view_content);
        make.height.equalTo(@(40));
    }];
    
    
    [self.headerView addSubview:self.lab_title];
    [self.lab_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headerView);
        make.left.equalTo(self.headerView).offset(15);
    }];
    
    
    [self.headerView addSubview:self.refreshButton];
    [self.refreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headerView);
        make.right.equalTo(self.headerView).offset(-15);
        
    }];
    
    [self.view_content addSubview:self.tabView];
    [self.tabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view_content);
        make.bottom.equalTo(self.view_content);
        make.top.equalTo(self.headerView.mas_bottom);
    }];
    
    [self addSubview:self.clearView];
    [self.clearView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(self.headerView.mas_top);
    }];
    
    [self addtabFooterView];
}

#pragma mark ===================== action ==================================
- (void)btn_refreshClick {
    [self animationWithButton:self.refreshButton];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(QukanLiveLinePopUpViewBtn_refreshClick)]) {
        [self.delegate QukanLiveLinePopUpViewBtn_refreshClick];
    }
}

- (void)chooseLiveLineWithModel:(id)model {
    if (self.delegate && [self.delegate respondsToSelector:@selector(QukanLiveLinePopUpViewchooseCompletWithModel:)]) {
        [self.delegate QukanLiveLinePopUpViewchooseCompletWithModel:model];
    }
    
    [self removeSelf];
}

#pragma mark ===================== Public Methods =======================

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier :cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.row < self.datas.count) {
        cell.textLabel.text = self.datas[indexPath.row].liveName;
        cell.textLabel.font = kFont15;
        cell.textLabel.textColor = kCommonBlackColor;
        return cell;
    } else if (self.admodel_main && indexPath.row == self.cellNumber - 1){
        cell.textLabel.text = self.admodel_main.title;
        cell.textLabel.font = kFont15;
        cell.textLabel.textColor = UIColor.redColor;
        return cell;
    } else {
        cell.textLabel.text = self.datas[indexPath.row].liveName;
        cell.textLabel.font = kFont15;
        return cell;
    }
    
    
    return [UITableViewCell new];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.cellNumber = self.datas.count + (self.ads.count > 0 ? 1 : 0);
    return self.datas.count + (self.ads.count > 0 ? 1 : 0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kQukanLiveLinePopUpViewRowHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.datas.count) {
        [self chooseLiveLineWithModel:self.datas[indexPath.row]];
    } else if(self.admodel_main){
        [self chooseLiveLineWithModel:self.admodel_main];
    }
}

#pragma mark ===================== function ==================================

- (void)addtabFooterView {
    UIView *foot = [UIView new];
    
    foot.backgroundColor = kCommonWhiteColor;
    foot.frame = CGRectMake(0, 0, kScreenWidth, 40 + kSafeAreaBottomHeight);
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancleButton setTitleColor:kCommonBlackColor forState:UIControlStateNormal];
    cancleButton.titleLabel.font = kFont15;
    [cancleButton addTarget:self action:@selector(removeSelf) forControlEvents:UIControlEventTouchUpInside];
    
    [foot addSubview:cancleButton];
    _cancleButton = cancleButton;
    
    [foot addSubview:self.cancleButton];
    [self.cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(foot);
        make.height.equalTo(@(40));
    }];
    
    self.tabView.tableFooterView = foot;
}


#pragma mark ===================== animation ==================================

- (void)animationWithButton:(UIButton *)button {
    
    CABasicAnimation *animation = [ CABasicAnimation animationWithKeyPath: @"transform.rotation.z"];
    animation.toValue = [NSNumber numberWithFloat:0.f];
    animation.fromValue= [NSNumber numberWithFloat: M_PI *2];
    animation.duration = 0.4;
    animation.autoreverses = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount = MAXFLOAT;
    [button.imageView.layer addAnimation:animation forKey:@"circles"];
}

#pragma mark ===================== 外部接口链接 ==================================
/**刷新直播数据源*/
- (void)refreshWithDatas:(NSArray  <QukanLiveLineModel *> *)datas{
    
    self.datas = datas;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.refreshButton.imageView.layer removeAnimationForKey:@"circles"];
        [self reFreshSeleView];
    });
}

/**刷新广告数据源*/
- (void)refreshWithAds:(NSArray  <QukanHomeModels *> *)datas{
    self.ads= datas;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.refreshButton.imageView.layer removeAnimationForKey:@"circles"];
        [self reFreshSeleView];
    });
    
}

- (void)reFreshSeleView {
    CGFloat h = 80 + kSafeAreaBottomHeight + kQukanLiveLinePopUpViewRowHeight * (self.datas.count + (self.ads.count > 0?1:0));
    CGRect frame = self.view_content.frame;
    frame.size.height = h;
    frame.origin.y = kScreenHeight - h;
    self.view_content.frame = frame;
    
    [self.tabView reloadData];
}



#pragma mark ===================== getter ==================================
- (void)setDatas:(NSArray<QukanLiveLineModel *> *)datas {
    if (_datas == datas) {
        return;
    }
    _datas = datas;
}

- (void)setAds:(NSArray<QukanHomeModels *> *)ads {
    if (_ads == ads) {
        return;
    }
    _ads = ads;
    
    if (ads.count == 0) {
        self.admodel_main = nil;
        return;
    }
    
    int rac = arc4random() % ads.count;
    QukanHomeModels *adModel = [ads objectAtIndex:rac];
    self.admodel_main = adModel;
}

#pragma mark ===================== lazy ==================================
- (UITableView *)tabView {
    if (!_tabView) {
        _tabView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tabView.delegate = self;
        _tabView.dataSource = self;
        
        
        _tabView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    }
    return _tabView;
}


- (UIView *)clearView {
    if (!_clearView) {
        _clearView = [UIView new];
        _clearView.backgroundColor = UIColor.clearColor;
        _clearView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeSelf)];
        [_clearView addGestureRecognizer:tap];
    }
    return _clearView;
}


- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [UIView new];
        _headerView.backgroundColor = kCommentBackgroudColor;
    }
    return _headerView;
}


- (UILabel *)lab_title {
    if (!_lab_title) {
        _lab_title = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 40)];
        _lab_title.text = @"请选择直播来源";
        _lab_title.textColor = kTextGrayColor;
        _lab_title.font = kFont12;
    }
    return _lab_title;
}

- (UIButton *)refreshButton {
    if (!_refreshButton) {
        _refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_refreshButton setTitle:@" 刷新" forState:UIControlStateNormal];
        [_refreshButton setTitleColor:HEXColor(0x666666) forState:UIControlStateNormal];
        _refreshButton.titleLabel.font = kFont12;
        _refreshButton.frame = CGRectMake(kScreenWidth - 80, 7, 70, 20);
        [_refreshButton setImage:[UIImage imageNamed:@"Qukan_envent_refresh"] forState:UIControlStateNormal];
        [_refreshButton setAdjustsImageWhenHighlighted:NO];
        [_refreshButton addTarget:self action:@selector(btn_refreshClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _refreshButton;
}

- (UIView *)view_content {
    if (!_view_content) {
        _view_content = [UIView new];
        _view_content.backgroundColor = COLOR_HEX(0x000000, 0.5);
    }
    return _view_content;
}
@end
