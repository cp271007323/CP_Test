//
//  QukanAirPlayStatusView.m
//  dxMovie-ios
//
//  Created by james on 2019/6/10.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanAirPlayStatusView.h"
#import "QukanAirPlayManager.h"
#import "SDAutoLayout.h"

@interface PlayingView : UIView
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) UILabel *deviceLabel;

@end
@implementation PlayingView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _label = [UILabel new];
        _label.font = [UIFont systemFontOfSize:20];
        _label.textColor = kCommonWhiteColor;
        [self addSubview:_label];
        _label.sd_layout.centerYEqualToView(self).offset(-15).leftSpaceToView(self, 0).rightSpaceToView(self, 0).heightIs(20);
        _label.text = @"投屏中";
        _label.textAlignment = NSTextAlignmentCenter;
        
        _deviceLabel = [UILabel new];
        _deviceLabel.font = kFont12;
        _deviceLabel.textColor = kTextGrayColor;
        [self addSubview:_deviceLabel];
        _deviceLabel.sd_layout.centerYEqualToView(self).offset(15).leftSpaceToView(self, 0).rightSpaceToView(self, 0).heightIs(12);
        _deviceLabel.textAlignment = NSTextAlignmentCenter;
        
        LBLelinkService *device = [QukanAirPlayManager.sharedManager getCurrentConnectedDevice];
        self.deviceLabel.text = device.lelinkServiceName;
        @weakify(self)
        [[QukanAirPlayManager.sharedManager.connectedStatusChangeSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            LBLelinkService *device = [QukanAirPlayManager.sharedManager getCurrentConnectedDevice];
            self.deviceLabel.text = device.lelinkServiceName;
            
        }];
        
        
    }
    return self;
}

@end


@interface QukanAirPlayStatusView()
@property (nonatomic,strong) PlayingView *playingView;

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *statusLabel;
@end
@implementation QukanAirPlayStatusView

- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.backgroundColor = [UIColor orangeColor];
        _playingView = [[PlayingView alloc] init];
        [self addSubview:_playingView];
        _playingView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
        
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
        _imageView.sd_layout.centerYEqualToView(self).offset(-10).centerXEqualToView(self).widthIs(30).heightIs(30);
//        _imageView.image = [UIImage imageNamed:@"连接中断"];
        
        _statusLabel = [UILabel new];
        _statusLabel.font = kFont15;
        _statusLabel.textColor = kTextGrayColor;
        [self addSubview:_statusLabel];
        _statusLabel.sd_layout.topSpaceToView(_imageView, 10).centerXEqualToView(self).heightIs(15).widthIs(150);
        _statusLabel.textAlignment = NSTextAlignmentCenter;
//        _statusLabel.text = @"连接中断";
        
        
        [self setData];
        

        @weakify(self)
        [[RACObserve(QukanAirPlayManager.sharedManager, playStatus) takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
           @strongify(self)
            [self setData];
        }];
        
        
    }
    return self;
}
//DXAirPlayStatusUnkown,// 未知状态   //播放失败 2
//DXAirPlayStatusLoading,// 视频正在加载状态      //投屏中 1
//DXAirPlayStatusPlaying,// 正在播放状态   //投屏中 1
//DXAirPlayStatusPause,// 暂停状态    //投屏中 1
//DXAirPlayStatusStopped,// 退出播放状态  //播放失败 2
//DXAirPlayStatusCommpleted,// 播放完成状态 //播放完毕  3
//DXAirPlayStatusError,// 播放失败 2
//DXAirPlayStatusConnected,//已连接       //投屏中 1
//DXAirPlayStatusDisConnected,//连接断开 //连接中断 4
//DXAirPlayStatusConnecting,//连接中 5
//DXAirPlayStatusConnectError //连接失败  //连接中断 4

- (void)setData{
    QukanAirPlayStatus status = QukanAirPlayManager.sharedManager.playStatus;
    self.playingView.hidden = YES;
    self.imageView.hidden = NO;
    self.statusLabel.hidden = NO;
    if (status == QukanAirPlayStatusLoading||status == QukanAirPlayStatusPlaying||status == QukanAirPlayStatusPause||status ==QukanAirPlayStatusPlaying ){//投屏中
        self.playingView.hidden = NO;
        self.imageView.hidden = YES;
        self.statusLabel.hidden = YES;
 
    }else if(status == QukanAirPlayStatusUnkown ||status == QukanAirPlayStatusError || status == QukanAirPlayStatusStopped){ //播放失败
        _imageView.image = [UIImage imageNamed:@"Qukan_playFail"];
        _statusLabel.text = @"播放失败";
    }else if (status == QukanAirPlayStatusCommpleted){ //播放完毕
        _imageView.image = [UIImage imageNamed:@"播放完毕"];
        _statusLabel.text = @"Qukan_playOver";
    }else if (status == QukanAirPlayStatusDisConnected || status == QukanAirPlayStatusConnectError){//连接中断
        _imageView.image = [UIImage imageNamed:@"Qukan_isOffLine"];
        _statusLabel.text = @"连接中断";
    }else if (status == QukanAirPlayStatusConnecting){ //连接中
        _imageView.image = [UIImage imageNamed:@"Qukan_isOnline"];
        _statusLabel.text = @"连接中...";
    }
  
    
}

@end
