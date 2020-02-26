//
//  DXAirPlayDeviceContainerView.m
//  dxMovie-ios
//
//  Created by james on 2019/6/4.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanAirPlayDeviceListView.h"
#import <AFNetworkReachabilityManager.h>
//#import "DxMovieWebViewController.h"
//#import "DxMovieNavigationController.h"
#import "SDAutoLayout.h"
#import "QukanCommonWebViewController.h"

@interface DeviceCell : UITableViewCell
@property (nonatomic,strong) UILabel *deviceLabel;
@property (nonatomic,strong) UILabel *statusLabel;
@property (nonatomic,strong) UIImageView *icon;
@property (nonatomic,weak) LBLelinkService *model;
@end

@implementation DeviceCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Qukan_tvIcon"]];
        [self.contentView addSubview:_icon];
        _icon.sd_layout.leftSpaceToView(self.contentView, 15).centerYEqualToView(self.contentView).widthIs(16).heightIs(13);
        
        _deviceLabel = [UILabel new];
        _deviceLabel.font = kFont15;
        _deviceLabel.textColor = kCommonDarkGrayColor;
        [self.contentView addSubview:_deviceLabel];
        _deviceLabel.sd_layout.leftSpaceToView(_icon, 10).centerYEqualToView(self.contentView).heightIs(18);
        [_deviceLabel setSingleLineAutoResizeWithMaxWidth:kScreenWidth * 0.6];
//        _deviceLabel.text = @"小米tv333";
        
        _statusLabel = [UILabel new];
        _statusLabel.font = kFont12;
        _statusLabel.textColor = HEXColor(0x999990);
        [self.contentView addSubview:_statusLabel];
        _statusLabel.sd_layout.leftSpaceToView(_deviceLabel, 15).centerYEqualToView(self.contentView).heightIs(15).widthIs(60);
//        _statusLabel.text = @"连接中...";
        
        
    }
    return self;
}
- (void)setModel:(LBLelinkService *)model{
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
//    NSLog(@"%@",model.status);
}

@end

@interface QukanAirPlayDeviceListView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray <LBLelinkService *>*devices;
@property (nonatomic,strong) UILabel *currentDeviceLabel;
@property (nonatomic,strong) UIView *noDeviceView;
@end
@implementation QukanAirPlayDeviceListView
+ (void)show{
    [QukanAirPlayManager.sharedManager startSearchDevice];
    
    QukanAirPlayDeviceListView *container = [[QukanAirPlayDeviceListView alloc] init];
    [self showWithContainer:container containerHeight:280+kSafeAreaBottomHeight];
}

- (void)dismiss {
    [super dismiss];
    [QukanAirPlayManager.sharedManager stopSearchDevice];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UIView *topView = [self setupTopView];
        [self addSubview:topView];
        topView.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 0).rightSpaceToView(self, 0).heightIs(46);
        
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [self addSubview:closeBtn];
        [closeBtn setTitle:@"取消" forState:UIControlStateNormal];
        [closeBtn setTitleColor:HEXColor(0x999990) forState:UIControlStateNormal];
        closeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        closeBtn.sd_layout.leftSpaceToView(self, 0).bottomSpaceToView(self, kSafeAreaBottomHeight).rightSpaceToView(self, 0).heightIs(50);
        UIView *sep1 = [[UIView alloc] init];
        [closeBtn addSubview:sep1];
        sep1.backgroundColor = kTableViewCommonBackgroudColor;
        sep1.sd_layout.leftSpaceToView(closeBtn, 0).topSpaceToView(closeBtn, 0).rightSpaceToView(closeBtn, 0).heightIs(1);
        @weakify(self);
        [[closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
         @strongify(self)
            
            [self dismiss];
        }];
        
        _noDeviceView = [self setupNoDeviceView];
        [self addSubview:_noDeviceView];
        _noDeviceView.sd_layout.leftSpaceToView(self, 0).topSpaceToView(topView, 0).rightSpaceToView(self, 0).bottomSpaceToView(closeBtn, 0);
        
   
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self addSubview:_tableView];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.sd_layout.leftSpaceToView(self, 0).topSpaceToView(topView, 0).rightSpaceToView(self, 0).bottomSpaceToView(closeBtn, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[DeviceCell class] forCellReuseIdentifier:@"cell"];
        UILabel *header = [UILabel new];
        header.font = kFont12;
        header.textColor = HEXColor(0x999990);
        header.text = @"    选择设备:";
        header.frame = CGRectMake(0, 0, kScreenWidth, 46);
        _tableView.tableHeaderView = header;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        self.devices = QukanAirPlayManager.sharedManager.devices;
        [_tableView reloadData];
     
        [[RACObserve(QukanAirPlayManager.sharedManager, devices) takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
           @strongify(self)
            self.devices = x;
            [self.tableView reloadData];
    
        }];
        
        LBLelinkService *current = [QukanAirPlayManager.sharedManager getCurrentConnectedDevice];
        if (current) {
            self.currentDeviceLabel.text = [NSString stringWithFormat:@"当前: %@",current.lelinkServiceName];
        }

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
            
            
            
        }];
        
        
    }
    return self;
}

- (UIView *)setupNoDeviceView{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label1 = [UILabel new];
    label1.font = kFont15;
    label1.textColor = kCommonDarkGrayColor;
    [view addSubview:label1];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.sd_layout.leftSpaceToView(view, 15).rightSpaceToView(view, 15).centerYEqualToView(view).offset(-15).heightIs(15);
    
    
    UILabel *label2 = [UILabel new];
    label2.font = kFont12;
    label2.textColor = kTextGrayColor;
    [view addSubview:label2];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.sd_layout.leftSpaceToView(view, 15).rightSpaceToView(view, 15).centerYEqualToView(view).offset(15).heightIs(12);
    
    
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
    
    return view;
}

- (void)dealloc{
    
}
- (UIView *)setupTopView{
    UIView *view = [[UIView alloc] init];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [view addSubview:btn];
    btn.sd_layout.rightSpaceToView(view, 0).topSpaceToView(view, 0).bottomSpaceToView(view, 0).widthIs(80);
    [btn setTitle:@"投屏贴士" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn setTitleColor:HEXColor(0x3476EF) forState:UIControlStateNormal];
    @weakify(self)
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self dismiss];
        QukanCommonWebViewController *vc = [[QukanCommonWebViewController alloc] init];
//        NSString *a = @"rwlb"; NSString *f = @"test"; NSString *b = @"204206"; NSString *c = @".cn/screening";
        vc.url = kUMShareManager.screenStr;

        vc.isPresentPush = YES;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [UIApplication.sharedApplication.delegate.window.rootViewController presentViewController:nav animated:YES completion:nil];
    
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
    separator.backgroundColor = kTableViewCommonBackgroudColor;
    
    
    return view;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

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
    DeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    LBLelinkService *model = _devices[indexPath.row];
    cell.model = model;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LBLelinkService *device = _devices[indexPath.row];
    
    [QukanAirPlayManager.sharedManager Qukan_connectWithDevice:device];
    
//   [QukanAirPlayManager.sharedManager.showAirPlayControlViewSubject sendNext:nil];
    
}







@end
