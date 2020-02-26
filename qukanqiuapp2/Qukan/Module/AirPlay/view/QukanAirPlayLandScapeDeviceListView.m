//
//  QukanAirPlayLandScapeDeviceListView.m
//  dxMovie-ios
//
//  Created by james on 2019/6/7.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanAirPlayLandScapeDeviceListView.h"
#import "QukanAirPlayManager.h"
#import "LBLelinkService+Extension.h"
#import "SDAutoLayout.h"
#import "QukanCommonWebViewController.h"

@interface LandScapeDeviceCell : UITableViewCell
@property (nonatomic,strong) UILabel *deviceLabel;
@property (nonatomic,strong) UILabel *statusLabel;
@property (nonatomic,strong) UIImageView *icon;
@property (nonatomic,weak) LBLelinkService *model;
@property (nonatomic,copy) void(^clickBlock)(void);
@end
@implementation LandScapeDeviceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Qukan_blackTvIcon"]];
        [self addSubview:_icon];
        _icon.sd_layout.leftSpaceToView(self, 15).centerYEqualToView(self).widthIs(16).heightIs(13);
        
        
        
        
        _deviceLabel = [UILabel new];
        _deviceLabel.font = kFont15;
        _deviceLabel.textColor = kCommonWhiteColor;
        [self addSubview:_deviceLabel];
        _deviceLabel.sd_layout.leftSpaceToView(_icon, 10).centerYEqualToView(self).heightIs(16);
        [_deviceLabel setSingleLineAutoResizeWithMaxWidth:280 * 0.6];
        
        _statusLabel = [UILabel new];
        _statusLabel.font = kFont12;
        _statusLabel.textColor = kTextGrayColor;
        [self addSubview:_statusLabel];
        _statusLabel.sd_layout.leftSpaceToView(_deviceLabel, 15).centerYEqualToView(self).heightIs(13);
        [_statusLabel setSingleLineAutoResizeWithMaxWidth:0];
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [self addGestureRecognizer:tap];
        @weakify(self)
        [tap.rac_gestureSignal subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
         @strongify(self)
            if (self.clickBlock) {
                self.clickBlock();
            }
            
        }];
        
        
    }
    return self;
}
-(void)setModel:(LBLelinkService *)model{
    _model = model;
    _deviceLabel.text = model.lelinkServiceName;
    if (model.status == isConnecting) {
        self.statusLabel.text = @"连接中";
    }else if (model.status == isConnected){
        self.statusLabel.text = @"已连接";
    }else if(model.status == connectFail) {
        self.statusLabel.text = @"连接失败";
    }else{
        self.statusLabel.text = @"";
    }
    
}
@end

@interface QukanAirPlayLandScapeDeviceListView()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UIView *containerView;
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSArray <LBLelinkService *>*devices;
@property (nonatomic,strong) UILabel *currentDeviceLabel;
@property (nonatomic,strong) UIView *noDeviceView;

@end
@implementation QukanAirPlayLandScapeDeviceListView

+ (void)showInView:(UIView *)superView{
    [QukanAirPlayManager.sharedManager startSearchDevice];
    
    QukanAirPlayLandScapeDeviceListView *view = [[QukanAirPlayLandScapeDeviceListView alloc] init];
    [superView addSubview:view];
    view.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    [view updateLayout];
    
    
}
- (instancetype)init
{
    self = [super init];
    if (self) {

        
        [self setupContainerView];
        _devices = QukanAirPlayManager.sharedManager.devices;
        _containerView = [self setupContainerView];
        [self addSubview:_containerView];
        _containerView.sd_layout.topSpaceToView(self, 0).bottomSpaceToView(self, 0).widthIs(280).rightSpaceToView(self, -280);
        [_containerView updateLayout];
        _containerView.sd_layout.rightSpaceToView(self, 0);
        [UIView animateWithDuration:0.2 animations:^{
            [self.containerView updateLayout];
        }];
        //屏蔽滑动和点击事件
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] init];
        [self addGestureRecognizer:pan];
        [[pan rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            
        }];
        
        UITapGestureRecognizer *doulbeTap = [[UITapGestureRecognizer alloc ]init];
        doulbeTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doulbeTap];
        [[doulbeTap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            
        }];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        @weakify(self)
        [tap.rac_gestureSignal subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
         @strongify(self)
            [self dismiss];
        }];
        
        
        [[RACObserve(QukanAirPlayManager.sharedManager, devices) takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            self.devices = x;
            [self.tableView reloadData];
            
        }];
        
        LBLelinkService *current = [QukanAirPlayManager.sharedManager getCurrentConnectedDevice];
        if (current) {
            self.currentDeviceLabel.text = [NSString stringWithFormat:@"当前: %@",current.lelinkServiceName];
        }
        //        QukanAirPlayManager.sharedManager.connectedStatusChangeBlock = ^{
        //            @strongify(self)
        //            [self.tableView reloadData];
        //         LBLelinkService *current = [QukanAirPlayManager.sharedManager getCurrentConnectedDevice];
        //            if (current) {
        //                self.currentDeviceLabel.text = [NSString stringWithFormat:@"当前: %@",current.lelinkServiceName];
        //            }else{
        //                self.currentDeviceLabel.text = @"";
        //            }
        //
        //
        //
        //        };
        
        [[QukanAirPlayManager.sharedManager.connectedStatusChangeSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            [self.tableView reloadData];
            LBLelinkService *current = [QukanAirPlayManager.sharedManager getCurrentConnectedDevice];
            if (current) {
                self.currentDeviceLabel.text = [NSString stringWithFormat:@"当前: %@",current.lelinkServiceName];
            }else{
                self.currentDeviceLabel.text = @"";
            }
        }];
        
        [[QukanAirPlayManager.sharedManager.deviceOrientationChangeSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            [self dismiss];
            
        }];
        [[QukanAirPlayManager.sharedManager.disConnectSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            [self dismiss];
        }];
        
        [[[RACObserve(QukanAirPlayManager.sharedManager, currentConnectedDevice) takeUntil:self.rac_willDeallocSignal] skip:1] subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            if (QukanAirPlayManager.sharedManager.currentConnectedDevice) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self dismiss];
                });
                
            }
            
            
        }];
        
        [RACObserve(self, self.devices) subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            if (self.devices.count) {
                self.tableView.hidden = NO;
                self.noDeviceView.hidden = YES;
            }else{
                self.tableView.hidden = YES;
                self.noDeviceView.hidden = NO;
            }
//            self.tableView.hidden = YES;
//            self.noDeviceView.hidden = NO;
            
        }];
        
        
        
    }
    return self;
}
- (UIView *)setupNoDeviceView{
    UIView *view = [[UIView alloc] init];
//    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label1 = [UILabel new];
    label1.font = kFont15;
    label1.textColor = kCommonWhiteColor;
    [view addSubview:label1];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.sd_layout.leftSpaceToView(view, 15).rightSpaceToView(view, 15).topSpaceToView(view, 45).heightIs(15);
    
    
    UILabel *label2 = [UILabel new];
    label2.font = kFont12;
    label2.textColor = kTextGrayColor;
    [view addSubview:label2];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.sd_layout.leftSpaceToView(view, 15).rightSpaceToView(view, 15).topSpaceToView(label1, 20).heightIs(12);
    
    AFNetworkReachabilityManager *reachability = [AFNetworkReachabilityManager sharedManager];
    [reachability startMonitoring];
    
    [reachability setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
            label1.text = @"没有找到可投屏的设备";
            label2.text = @"请检查可投屏设备是否连接当前WIFI";
        }else{
            label1.text = @"当前使用运营商网络,暂时不能投屏";
            label2.text = @"请将手机和电视/盒子链接同一个WIFI";
        }
    }];
    
//    AFNetworkReachabilityManager *reachability = [AFNetworkReachabilityManager managerForDomain:@"www.apple.com"];
//    AFNetworkReachabilityStatus internetStatus = [reachability networkReachabilityStatus];
//    if (internetStatus == AFNetworkReachabilityStatusReachableViaWiFi) {
//        label1.text = @"没有找到可投屏的设备";
//        label2.text = @"请检查可投屏设备是否连接当前WIFI";
//    }else{
//        label1.text = @"当前使用运营商网络,暂时不能投屏";
//        label2.text = @"请将手机和电视/盒子链接同一个WIFI";
//    }
    
    return view;
}
- (UIView *)setupContainerView{
    UIView *container = [[UIView alloc] init];
    container.backgroundColor = HEXColor(0x2C2C2C);
    
    UIView *topView = [self setupTopView];
    [container addSubview:topView];
    topView.sd_layout.leftSpaceToView(container, 0).topSpaceToView(container, 0).rightSpaceToView(container, 0).heightIs(45);
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [container addSubview:_tableView];
    _tableView.backgroundColor = UIColor.clearColor;
    _tableView.sd_layout.leftSpaceToView(container, 0).topSpaceToView(topView, 0).rightSpaceToView(container, 0).bottomSpaceToView(container, 0);
    UILabel *header = [UILabel new];
    header.font = kFont12;
    header.textColor = HEXColor(0x999990);
    header.text = @"    选择设备:";
    header.frame = CGRectMake(0, 0, kScreenWidth, 46);
    _tableView.tableHeaderView = header;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:LandScapeDeviceCell.class forCellReuseIdentifier:@"cell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    
    _noDeviceView = [self setupNoDeviceView];
    [container addSubview:_noDeviceView];
    _noDeviceView.sd_layout.leftSpaceToView(container, 0).topSpaceToView(topView, 0).rightSpaceToView(container, 0).bottomSpaceToView(container, 0);
    
    
    
    
    return container;
}

- (UIView *)setupTopView{
    UIView *view = [[UIView alloc] init];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [view addSubview:btn];
    btn.sd_layout.rightSpaceToView(view, 0).topSpaceToView(view, 0).bottomSpaceToView(view, 0).widthIs(80);
    [btn setTitle:@"投屏贴士" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn setTitleColor:HEXColor(0x2799F9) forState:UIControlStateNormal];
    @weakify(self)
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self dismiss];
        
//       UIInterfaceOrientation fromOrientation = [UIApplication sharedApplication].statusBarOrientation;
       [[NSNotificationCenter defaultCenter] postNotificationName:Qukan_DeviceShouldRotate object:nil];
        QukanCommonWebViewController *vc = [[QukanCommonWebViewController alloc] init];
//        NSString *a = @"rwlb"; NSString *f = @"test"; NSString *b = @"204206"; NSString *c = @".cn/screening";
        vc.url = kUMShareManager.screenStr;
        vc.isPresentPush = YES;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [UIApplication.sharedApplication.delegate.window.rootViewController presentViewController:nav animated:YES completion:nil];

//        vc.dismissHandle = ^{ //恢复之前的横屏方向
////          @strongify(self)
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"RotateRecover" object:@(fromOrientation)];
//        };
        
        
        
        
    }];
    
    
    _currentDeviceLabel = [UILabel new];
    _currentDeviceLabel.font = kFont12;
    _currentDeviceLabel.textColor = HEXColor(0x999990);
    _currentDeviceLabel.hidden = YES;
    [view addSubview:_currentDeviceLabel];
    _currentDeviceLabel.sd_layout.leftSpaceToView(view, 15).topSpaceToView(view, 0).bottomSpaceToView(view, 0).rightSpaceToView(btn, 0);
    //    _currentDeviceLabel.text = @"---";
    
    UIView *separator = [[UIView alloc] init];
    [view addSubview:separator];
    separator.sd_layout.leftSpaceToView(view, 0).bottomSpaceToView(view, 0).rightSpaceToView(view, 0).heightIs(1);
    separator.backgroundColor = HEXColor(0x393939);
    
    
    return view;
}

- (void)dismiss{
    self.containerView.sd_layout.rightSpaceToView(self, -280);
    [UIView animateWithDuration:0.2 animations:^{
        [self.containerView updateLayout];
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
   
    if (touch.view == self) {
        return YES;
    }else{
        return NO;
    }
    
    
    
}
#pragma mark =========tabelViewDelegate===============

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 46;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _devices.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    LandScapeDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    LBLelinkService *model = _devices[indexPath.row];
    cell.model = model;
    
    @weakify(self)
    cell.clickBlock = ^{
     @strongify(self)
        [self cellClickWithIndex:indexPath.row];
        
    };
    
    return cell;
}


- (void)cellClickWithIndex:(NSInteger)index{
    LBLelinkService *device = _devices[index];

#warning test 第二句是测试
      [QukanAirPlayManager.sharedManager Qukan_connectWithDevice:device];
    
//    [QukanAirPlayManager.sharedManager.showAirPlayControlViewSubject sendNext:nil];
    
}
- (void)dealloc
{
    
}
@end
