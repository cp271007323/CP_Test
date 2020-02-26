//
//  QukanAirPlayControlBtnContainerView.m
//  dxMovie-ios
//
//  Created by james on 2019/6/11.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanAirPlayControlBtnContainerView.h"
#import "QukanAirPlayManager.h"
#import "QukanAirPlayQualityListView.h"
#import "QukanAirPlayDeviceListView.h"
#import "QukanAirPlayLandScapeDeviceListView.h"
#import "SDAutoLayout.h"

@interface QukanAirPlayControlBtnContainerView()
@property (nonatomic,strong) NSMutableArray *btnArr;
@property (nonatomic,weak) UIButton *qualityBtn;
@end
@implementation QukanAirPlayControlBtnContainerView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _btnArr = [NSMutableArray array];
        [self setupBtns];
        @weakify(self)
        [[QukanAirPlayManager.sharedManager.deviceOrientationChangeSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            [self setupBtns];
            
        }];
        [[[RACObserve(QukanAirPlayManager.sharedManager, playStatus) delay:0.1] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setupBtns];
                
            });
        }];
        
        
        [[QukanAirPlayManager.sharedManager.showAirPlayControlViewSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
//            @strongify(self)
//            NSString *title = QukanAirPlayManager.sharedManager.selectedPlayInfo.videoFormatName;
//            [self.qualityBtn setTitle:@"高清" forState:UIControlStateNormal];
        }];
        self.qualityBtn.hidden = YES;
        
    }
    return self;
}

- (void)setupBtns{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    [_btnArr removeAllObjects];
    QukanAirPlayStatus status = QukanAirPlayManager.sharedManager.playStatus;
    NSString *orentation = [QukanAirPlayManager.sharedManager getCurrentOrientation];
    CGFloat btnWidth = 73;
    CGFloat btnMargin = 2;
    NSArray *titleArr = nil;
    if (status == QukanAirPlayStatusLoading||status == QukanAirPlayStatusPlaying||status == QukanAirPlayStatusPause||status ==QukanAirPlayStatusPlaying ){//投屏中
        if ([orentation isEqualToString:KDeviceIsPortrait]) {
            titleArr = @[@"换设备",@"退出投屏"];
        }else{
             titleArr = @[@"换设备",@"退出投屏"];
        }
    }else if(status == QukanAirPlayStatusUnkown ||status == QukanAirPlayStatusError || status == QukanAirPlayStatusStopped){ //播放失败
//        if ([orentation isEqualToString:KDeviceIsPortrait]) {
//            titleArr = @[@"高清",@"换设备",@"退出投屏"];
//        }else{
            titleArr = @[@"换设备",@"退出投屏",@"重试"];
//        }
        
    }else if (status == QukanAirPlayStatusCommpleted){ //播放完毕
        titleArr = @[@"换设备",@"退出投屏"];
        
    }else if (status == QukanAirPlayStatusDisConnected || status == QukanAirPlayStatusConnectError){//连接中断
        titleArr = @[@"退出投屏",@"重试"];
        
    }else if (status == QukanAirPlayStatusConnecting){ //连接中
        titleArr = @[@"换设备",@"退出投屏"];
        
    }else {
        titleArr = @[@"换设备",@"退出投屏",@"重试"];
    }
    
    
    for (int i=0; i<titleArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:btn];
        btn.sd_layout.leftSpaceToView(self, (btnWidth + btnMargin) * i).topSpaceToView(self, 0).bottomSpaceToView(self, 0).widthIs(btnWidth);
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:HEXColor(0xF9F9F9) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn addTarget:self action:@selector(handleBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_btnArr addObject:btn];

        if ([btn.titleLabel.text isEqualToString:@"重试"]) {
            [btn setImage:[UIImage imageNamed:@"Qukan_retry"] forState:UIControlStateNormal];
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        }
//        if ([btn.titleLabel.text isEqualToString:@"高清"]) {
//            _qualityBtn = btn;
//        }
        
    }
    
//    NSString *title = QukanAirPlayManager.sharedManager.selectedPlayInfo.videoFormatName;
//    [self.qualityBtn setTitle:@"高清" forState:UIControlStateNormal];
    
    [self setupAutoWidthWithRightView:_btnArr.lastObject rightMargin:0];
    
    [self setupBtnBackGroundImage];
}


- (void)setupBtnBackGroundImage{
    if (_btnArr.count == 1) {
        UIButton *btn = _btnArr.firstObject;
        [btn setBackgroundImage:[UIImage imageWithColor:HEXColor(0x676565)] forState:UIControlStateNormal];
        return;
    }
    
    for (UIButton *btn in _btnArr) {
        if (btn == _btnArr.firstObject) {
            [btn setBackgroundImage:[UIImage imageNamed:@"Qukan_LeftHalf"] forState:UIControlStateNormal];
        }else if (btn == _btnArr.lastObject){
            [btn setBackgroundImage:[UIImage imageNamed:@"Qukan_RightHalf"] forState:UIControlStateNormal];
        }else{
             [btn setBackgroundImage:[UIImage imageWithColor:HEXColor(0x676565)] forState:UIControlStateNormal];
        }

    }
 
}

- (void)handleBtn:(UIButton *)sender{
    
    if (sender == _qualityBtn) {
         [QukanAirPlayQualityListView show];
        
        return;
    }
    
    NSString *title = sender.titleLabel.text;

    if ([title isEqualToString:@"换设备"]) {
        if ([QukanAirPlayManager.sharedManager.getCurrentOrientation isEqualToString:KDeviceIsPortrait]) {
            [QukanAirPlayDeviceListView show];
        }else{
            [QukanAirPlayLandScapeDeviceListView showInView:self.superview.superview];
        }
    }else if ([title isEqualToString:@"退出投屏"]){
        [QukanAirPlayManager.sharedManager Qukan_disConnect];
        [kNotificationCenter postNotificationName:Qukan_AirPlayCancle object:nil];
    }else if ([title isEqualToString:@"重试"]){
       QukanAirPlayStatus status = QukanAirPlayManager.sharedManager.playStatus;
        if(status == QukanAirPlayStatusUnkown ||status == QukanAirPlayStatusError || status == QukanAirPlayStatusStopped){ //播放失败 重试
//            if (QukanAirPlayManager.sharedManager.isFromCacheFinishedPage) {
//                [QukanAirPlayManager.sharedManager playLocalWithLocalItem:QukanAirPlayManager.sharedManager.cacheFinishedItem];
//            }else{
//                [QukanAirPlayManager.sharedManager playWithPlayInfo:QukanAirPlayManager.sharedManager.selectedPlayInfo];
//            }
            [QukanAirPlayManager.sharedManager Qukan_rePlay];
        }else{ //连接中断 重试
            //[QukanAirPlayManager.sharedManager connectWithDevice:QukanAirPlayManager.sharedManager.lastTimeConnectedDevice];
            [QukanAirPlayManager.sharedManager Qukan_reConnect];
        }

    }
 
}
@end
