//
//  QukanScreenLiveLineView.m
//  Qukan
//
//  Created by Kody on 2019/8/19.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanScreenLiveLineView.h"
#import "QukanHomeModels.h"

#define selfTableViewWidth 218
#define selfHeaderHight 40
#define selfFooterHight 40


@interface selfTableview : UITableView

@end


@implementation selfTableview

@end



@interface QukanScreenLiveLineView ()<UITableViewDelegate,UITableViewDataSource>


@property(nonatomic, strong) UIView      *shareView;
@property(nonatomic, strong) UIView      *backView;
@property(nonatomic, strong) UIButton    *refreshButton;

@property(nonatomic, strong) QukanHomeModels *adModel;

@end

@implementation QukanScreenLiveLineView

- (instancetype)initWithFrame:(CGRect)frame WithDatas:(NSArray *)datas withAds:(NSArray *)ads; {
    self = [super initWithFrame:frame];
    self.datas = datas;
    self.ads = ads;
    [self addBackView];
    [self addTableView];
    return self;
}




- (void)addBackView {
    [kwindowLast addSubview:self];
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - selfTableViewWidth, kScreenHeight)];
    backView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [self addSubview:backView];
    self.backView = backView;

     UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disappearTap:)];
     [backView addGestureRecognizer:ges];
    
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(none)];
    singleTapGesture.numberOfTapsRequired =1;
    singleTapGesture.numberOfTouchesRequired  =1;
    [self addGestureRecognizer:singleTapGesture];
    
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(none)];
    doubleTapGesture.numberOfTapsRequired =2;
    doubleTapGesture.numberOfTouchesRequired =1;
    [self addGestureRecognizer:doubleTapGesture];
    
}

// 添加手势  解决手势穿透问题
- (void)none {}
#pragma mark ===================== UITableView ==================================

- (void)addTableView {
    _tableView = [[selfTableview alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.userInteractionEnabled = YES;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.6];
    _tableView.rowHeight = 50;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.scrollEnabled = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_tableView];
    _tableView.tableFooterView = [UIView new];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self);
        make.bottom.mas_equalTo(self.bottom).offset(0);
        make.width.offset(218);
    }];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:HEXColor(0x666666) forState:UIControlStateNormal];
    cancelButton.layer.cornerRadius = 20;
    cancelButton.layer.masksToBounds = YES;
    cancelButton.layer.borderColor = HEXColor(0x666666).CGColor;
    cancelButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    [self addSubview:cancelButton];
    @weakify(self)
    [[cancelButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self disappearTap:nil];
    }];

    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-10);
        make.bottom.mas_equalTo(self.bottom).offset(-10);
        make.height.offset(40);
        make.width.offset(200);
    }];
}


#pragma mark ===================== UITableViewDataSource ==================================

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count + self.ads.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return selfHeaderHight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, selfHeaderHight)];
    headerView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    [self addHeaderSub:headerView];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    UIImageView *accessoryImgView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"Qukan_player_arrows"] imageWithColor:kCommonWhiteColor]];
    cell.accessoryView = accessoryImgView;
    cell.backgroundColor = UIColor.clearColor;
    
    if (indexPath.row < self.datas.count) {
        QukanLiveLineModel *indexModel = [self.datas objectAtIndex:indexPath.row];
        cell.textLabel.text = indexModel.liveName;
        cell.textLabel.font = kFont15;
        cell.textLabel.textColor = kCommonWhiteColor;
    } else {
        int rac = arc4random() % self.ads.count;
        QukanHomeModels *adModel = [self.ads objectAtIndex:rac];
        cell.textLabel.text = adModel.title;
        cell.textLabel.font = kFont15;
        cell.textLabel.textColor = UIColor.redColor;
        self.adModel = adModel;
    }
    
    UIButton *cellButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cellButton.frame = cell.bounds;
    cellButton.backgroundColor = UIColor.clearColor;
    [cell addSubview:cellButton];
    @weakify(self)
    [[cellButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self disappearTap:nil];
        [self cellDidSeleCilckWithIndex:indexPath.row];
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark ===================== addSubView ==================================

- (void)addHeaderSub:(UIView *)view {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, view.height)];
    titleLabel.text = @"请选择直播来源";
    titleLabel.textColor = kCommonWhiteColor;
    titleLabel.font = kFont12;
    [view addSubview:titleLabel];

    UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshButton setTitle:@" 刷新" forState:UIControlStateNormal];
    [refreshButton setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
    refreshButton.titleLabel.font = kFont12;
    CGFloat offset = isIPhoneXSeries() ? 100 : 70;
    refreshButton.frame = CGRectMake(self.tableView.width - offset, 0, 60, selfHeaderHight);
    [refreshButton setImage:[kImageNamed(@"Qukan_liveLineRefresh") imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [refreshButton setAdjustsImageWhenHighlighted:NO];
    [view addSubview:refreshButton];
    refreshButton.backgroundColor = UIColor.clearColor;
    _refreshButton = refreshButton;
    @weakify(self)
    [[refreshButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        if (self.refreshBolck) {
            [self animationWithButton:refreshButton];
            self.refreshBolck();
        }
    }];
}


#pragma mark ===================== Actions ============================

- (void)disappearTap:(UITapGestureRecognizer *)gesture {
    self.backView.backgroundColor = UIColor.clearColor;
    [UIView animateWithDuration:0.5f animations:^{
        self.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight);
    } completion:^(BOOL finished) {
        [self removeAllSubviews];
        [self removeFromSuperview];
    }];
}

#pragma mark ===================== animation ==================================

- (void)animationWithButton:(UIButton *)button {
    [UIView animateWithDuration:0.5 animations:^{
        button.imageView.transform = CGAffineTransformMakeRotation(M_PI);
    }];
    CABasicAnimation *animation = [ CABasicAnimation animationWithKeyPath: @"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    //围绕Z轴旋转，垂直与屏幕
    animation.toValue = [ NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI/2.0, 0.0, 0.0, 1.0) ];
    animation.duration = 0.1;
    //旋转效果累计，先转180度，接着再旋转180度，从而实现360旋转
    animation.cumulative = YES;
    animation.repeatCount = MAXFLOAT;
    [button.imageView.layer addAnimation:animation forKey:@"refresh"];
}

#pragma mark ===================== Public Methods =======================

- (void)cellDidSeleCilckWithIndex:(NSInteger)index {
    if (self.ads.count) {
           if (index == self.datas.count) {
               if (self.cellDidSeleAdBolck) {
                   self.cellDidSeleAdBolck(self.adModel);
               }
           } else {
               QukanLiveLineModel *indexModel = [self.datas objectAtIndex:index];
               if (self.cellDidSeleLiveBolck) {
                   self.cellDidSeleLiveBolck(indexModel);
               }
           }
       } else {
           QukanLiveLineModel *indexModel = [self.datas objectAtIndex:index];
           if (self.cellDidSeleLiveBolck) {
               self.cellDidSeleLiveBolck(indexModel);
           }
       }
}

@end
