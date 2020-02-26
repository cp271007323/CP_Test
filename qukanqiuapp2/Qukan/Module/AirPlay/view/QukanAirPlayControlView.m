//
//  QukanAirPlayControlView.m
//  dxMovie-ios
//
//  Created by james on 2019/6/4.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanAirPlayControlView.h"
#import "QukanAirPlayManager.h"
#import "QukanAirPlayDeviceListView.h"
#import "QukanAirPlayLandscapeQualityListView.h"
#import "QukanAirPlayLandscapeTermView.h"
#import "QukanAirPlayLandScapeDeviceListView.h"
#import "ZFUtilities.h"
#import "QukanAirPlayStatusView.h"
#import "QukanAirPlayControlBtnContainerView.h"
//#import "ZFFastView.h"
#import "SDAutoLayout.h"

@interface QukanAirPlayControlView ()<UIGestureRecognizerDelegate>
@property (nonatomic,strong) UIImageView *airPlayingImageView;
@property (nonatomic,strong) UIButton *backBtn;
@property (nonatomic,strong) QukanAirPlayStatusView *statusView;
@property (nonatomic,strong) UIButton *muteBtn;
@property (nonatomic,strong) UIButton *voicePlusBtn;
@property (nonatomic,strong) UIButton *voiceDecreaseBtn;
@property (nonatomic,strong) UIButton *playOrPauseBtn;
@property (nonatomic,strong) UILabel *currentTimeLabel;
@property (nonatomic,strong) UIButton *termBtn;
@property (nonatomic,strong) UIButton *qualityBtn;
@property (nonatomic,strong) UILabel *totalTimeLabel;
@property (nonatomic,strong) UISlider *slider;
@property (nonatomic,strong) UIButton *fullScreenBtn;
@property (nonatomic,strong) UIView *voiceSeparator;
@property (nonatomic,assign) BOOL isDraging;
@property (nonatomic,assign) NSInteger totalTime;
@property (nonatomic,strong) UIButton *airPlayBtn;
@property (nonatomic,strong) QukanAirPlayControlBtnContainerView *btnContainer;
//@property (nonatomic,strong) ZFFastView *fastView;
@end
@implementation QukanAirPlayControlView

- (instancetype)init
{
    self = [super init];
    if (self) {
  
        //屏蔽滑动和点击事件
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] init];
        [self addGestureRecognizer:pan];
        [[pan rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {

        }];
        pan.delegate = self;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {

        }];
        UITapGestureRecognizer *doulbeTap = [[UITapGestureRecognizer alloc ]init];
        doulbeTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doulbeTap];
        [[doulbeTap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {

        }];
        
        @weakify(self)
        [[QukanAirPlayManager.sharedManager.playStatusSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
         @strongify(self)
            LBLelinkPlayStatus playStatus = [x integerValue];
            if (playStatus == LBLelinkPlayStatusPlaying) {
                self.playOrPauseBtn.selected = NO;
            }else{
                self.playOrPauseBtn.selected = YES;
            }
  
        }];
        
        [[QukanAirPlayManager.sharedManager.playTimeChangeSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(LBLelinkProgressInfo * _Nullable x) {
            @strongify(self)
            
            NSInteger currentTime = x.currentTime;
            NSInteger totalTime = x.duration;
            self.totalTime = totalTime;
            self.totalTimeLabel.text = [ZFUtilities convertTimeSecond:totalTime];
            if (!self.isDraging) {
                self.currentTimeLabel.text = [ZFUtilities convertTimeSecond:currentTime];
                if (totalTime) {
                    self.slider.value = (CGFloat)currentTime / (CGFloat)totalTime;
                }
            }
 
        }];
        
        [[RACObserve(QukanAirPlayManager.sharedManager, currentPlayStatus) takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
           @strongify(self)
            if (QukanAirPlayManager.sharedManager.currentPlayStatus == LBLelinkPlayStatusCommpleted) {
                self.slider.value = 0;
               self.currentTimeLabel.text = @"00:00";
                self.totalTimeLabel.text = @"00:00";
            }
            
            
        }];
        
        
        [self setupUI];
        [self setData];
       
        
        
    }
    return self;
}
- (void)setupUI{
    self.hidden = YES;
    @weakify(self)

    UIImageView *backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Qukan_airplayBackImage"]];
    [self addSubview:backImageView];
    backImageView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    backImageView.contentMode = UIViewContentModeScaleAspectFill;
    backImageView.clipsToBounds = YES;
    
    _airPlayingImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Qukan_ScreenOf"]];
    [self addSubview:_airPlayingImageView];
    _airPlayingImageView.sd_layout.topSpaceToView(self, 0).centerXEqualToView(self).widthIs(400).heightIs(175);
    
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_backBtn];
    [_backBtn setImage:[UIImage imageNamed:@"backImage"] forState:UIControlStateNormal];
    _backBtn.sd_layout.leftSpaceToView(self, 40).topSpaceToView(self, 5).widthIs(50).heightIs(50);
    [_backBtn addTarget:self action:@selector(deviceShouldRotate) forControlEvents:UIControlEventTouchUpInside];
    
   
    

    
    _statusView = [[QukanAirPlayStatusView alloc] init];
    [_airPlayingImageView addSubview:_statusView];
    _statusView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    
    _muteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_muteBtn];
    [_muteBtn addTarget:self action:@selector(handleMuteBtn) forControlEvents:UIControlEventTouchUpInside];
    _muteBtn.sd_layout.rightSpaceToView(self, 50).centerYEqualToView(self).widthIs(35).heightIs(33);
    _muteBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [_muteBtn setImage:[UIImage imageNamed:@"Qukan_voidRemove"] forState:UIControlStateNormal];
    [_muteBtn setBackgroundImage:[UIImage imageWithColor:HEXColor(0x676565)] forState:UIControlStateNormal];
    
    
    _airPlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_airPlayBtn];
    [_airPlayBtn setImage:[UIImage imageNamed:@"Qukan_landScapeAirPlayIcon"] forState:UIControlStateNormal];
    _airPlayBtn.sd_layout.centerXEqualToView(_muteBtn).centerYEqualToView(_backBtn).widthIs(30).heightIs(30);
    [_airPlayBtn addTarget:self action:@selector(handleAirPlayBtn) forControlEvents:UIControlEventTouchUpInside];
    
    
    _voicePlusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_voicePlusBtn];
    _voicePlusBtn.sd_layout.rightEqualToView(_muteBtn).bottomSpaceToView(_muteBtn, 0).widthIs(35).heightIs(33);
    [_voicePlusBtn setImage:[UIImage imageNamed:@"Qukan_volumeAdd"] forState:UIControlStateNormal];
    [_voicePlusBtn setBackgroundImage:[UIImage imageNamed:@"Qukan_volumeAddBg"] forState:UIControlStateNormal];
    [_voicePlusBtn addTarget:self action:@selector(handleVoicePlusBtn) forControlEvents:UIControlEventTouchUpInside];
    _voiceSeparator = [[UIView alloc] init];
    [_voicePlusBtn addSubview:_voiceSeparator];
    _voiceSeparator.backgroundColor = HEXColor(0x868585);
    _voiceSeparator.sd_layout.leftSpaceToView(_voicePlusBtn, 7).rightSpaceToView(_voicePlusBtn, 7).bottomSpaceToView(_voicePlusBtn, 0).heightIs(1);
    
    
    _voiceDecreaseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_voiceDecreaseBtn];
    _voiceDecreaseBtn.sd_layout.rightEqualToView(_muteBtn).topSpaceToView(_muteBtn, 0).widthIs(35).heightIs(33);
    [_voiceDecreaseBtn addTarget:self action:@selector(handleVoiceDecreaseBtn) forControlEvents:UIControlEventTouchUpInside];
    [_voiceDecreaseBtn setImage:[UIImage imageNamed:@"Qukan_volumeLess"] forState:UIControlStateNormal];
    [_voiceDecreaseBtn setBackgroundImage:[UIImage imageNamed:@"Qukan_volumeLessBg"] forState:UIControlStateNormal];
    UIView *separator = [[UIView alloc] init];
    [_voiceDecreaseBtn addSubview:separator];
    separator.backgroundColor = HEXColor(0x868585);
    separator.sd_layout.leftSpaceToView(_voiceDecreaseBtn, 7).rightSpaceToView(_voiceDecreaseBtn, 7).topSpaceToView(_voiceDecreaseBtn, 0).heightIs(1);
    
    
    _playOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_playOrPauseBtn];
    _playOrPauseBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 2, 0);
    _playOrPauseBtn.sd_layout.leftSpaceToView(self, 30).bottomSpaceToView(self, 20).widthIs(30).heightIs(30);
    [_playOrPauseBtn addTarget:self action:@selector(handlePlayOrPauseBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [_playOrPauseBtn setImage:[UIImage imageNamed:@"播放2"] forState:UIControlStateNormal];
    [_playOrPauseBtn setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateSelected];
    
    _currentTimeLabel = [UILabel new];
    _currentTimeLabel.font = kFont12;
    _currentTimeLabel.textColor = [UIColor whiteColor];
    [self addSubview:_currentTimeLabel];
    _currentTimeLabel.sd_layout.leftSpaceToView(_playOrPauseBtn, 5).centerYEqualToView(_playOrPauseBtn).heightIs(12).widthIs(60);
    _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
    _currentTimeLabel.text = @"00:00";
    
    _termBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self addSubview:_termBtn];
    _termBtn.sd_layout.centerXEqualToView(_muteBtn).centerYEqualToView(_playOrPauseBtn).widthIs(35).heightIs(30);
    [_termBtn setTitle:@"选集" forState:UIControlStateNormal];
    [_termBtn setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
    _termBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_termBtn addTarget:self action:@selector(handleTermBtn) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    _qualityBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self addSubview:_qualityBtn];
    _qualityBtn.sd_layout.rightSpaceToView(_termBtn, 25).centerYEqualToView(_playOrPauseBtn).widthIs(35).heightIs(30);
    [_qualityBtn setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
    _qualityBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_qualityBtn addTarget:self action:@selector(handleQualityBtn) forControlEvents:UIControlEventTouchUpInside];
    
    _totalTimeLabel = [UILabel new];
    _totalTimeLabel.font = kFont12;
    _totalTimeLabel.textColor = [UIColor whiteColor];
    _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_totalTimeLabel];
    _totalTimeLabel.sd_layout.rightSpaceToView(_qualityBtn, 25).centerYEqualToView(_playOrPauseBtn).heightIs(12).widthIs(60);
    _totalTimeLabel.text = @"00:00";
    
    _fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_fullScreenBtn];
    _fullScreenBtn.sd_layout.rightSpaceToView(self, 8).centerYEqualToView(_playOrPauseBtn).heightIs(30).widthIs(30);
    [_fullScreenBtn setImage:[UIImage imageNamed:@"全屏"] forState:UIControlStateNormal];
    [_fullScreenBtn addTarget:self action:@selector(deviceShouldRotate) forControlEvents:UIControlEventTouchUpInside];
    
    _slider = [[UISlider alloc] init];
    [self addSubview:_slider];
    _slider.sd_layout.leftSpaceToView(_currentTimeLabel, 5).rightSpaceToView(_totalTimeLabel, 5).centerYEqualToView(_playOrPauseBtn).heightIs(20);
    [_slider setMinimumTrackTintColor:kCommonWhiteColor];
//    [_slider setMaximumTrackTintColor:[UIColor colorWithHexString:@"868585"]];
    
    [_slider setThumbImage:[UIImage imageNamed:@"Qukan_thumbImage"] forState:UIControlStateNormal];
    [_slider setThumbImage:[UIImage imageNamed:@"Qukan_thumbImage"] forState:UIControlStateHighlighted];
    
    [_slider addTarget:self action:@selector(sliderBeginDragingAction:) forControlEvents:UIControlEventTouchDown];
    [_slider addTarget:self action:@selector(sliderEndDragingAction:) forControlEvents:UIControlEventTouchUpInside];
    [_slider addTarget:self action:@selector(sliderDragingOutAction:) forControlEvents:UIControlEventTouchUpOutside];
    [_slider addTarget:self action:@selector(sliderValueChangedAction:) forControlEvents:UIControlEventValueChanged];
   
    _btnContainer = [[QukanAirPlayControlBtnContainerView alloc] init];
    [self addSubview:_btnContainer];
    _btnContainer.sd_layout.centerXEqualToView(self).bottomSpaceToView(_slider, 30).heightIs(35);
    
//    _fastView = [[ZFFastView alloc] init];
//    [self addSubview:_fastView];
//    _fastView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    
    [[QukanAirPlayManager.sharedManager.deviceOrientationChangeSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
       @strongify(self)
        [self setupLayoutWithOrientation:x];
        
    }];
    
    [self setupLayoutWithOrientation:[QukanAirPlayManager.sharedManager getCurrentOrientation]];
    ;
}

- (void)setupLayoutWithOrientation:(NSString *)orientation{

    if ([orientation  isEqualToString:KDeviceIsPortrait]) {
        _backBtn.hidden = YES;
        _airPlayBtn.hidden = YES;
        _airPlayingImageView.sd_layout.widthIs(212).heightIs(98);

        _muteBtn.sd_layout.rightSpaceToView(self, 15).heightIs(0);
        _playOrPauseBtn.sd_layout.leftSpaceToView(self, 5).bottomSpaceToView(self, 5);
        _fullScreenBtn.hidden = NO;
        _qualityBtn.hidden = YES;
        _termBtn.hidden = YES;
        _totalTimeLabel.sd_layout.rightSpaceToView(_qualityBtn, -77);
        

         _btnContainer.sd_layout.bottomSpaceToView(_slider, 30).heightIs(30);
        
        [_voiceDecreaseBtn setImage:[UIImage imageNamed:@"Qukan_volumeLess"] forState:UIControlStateNormal];
        [_voicePlusBtn setImage:[UIImage imageNamed:@"Qukan_volumeAdd"] forState:UIControlStateNormal];
        _voiceSeparator.hidden = YES;
        
    }else{
       _backBtn.hidden = NO;
        _airPlayBtn.hidden = NO;
         _airPlayingImageView.sd_layout.widthIs(400).heightIs(175);
        _muteBtn.sd_layout.rightSpaceToView(self, 50).heightIs(33);
        _playOrPauseBtn.sd_layout.leftSpaceToView(self, 45).bottomSpaceToView(self, 20);
         _fullScreenBtn.hidden = YES;
        _qualityBtn.hidden = NO;
        
        
//        if (QukanAirPlayManager.sharedManager.movieDetailRes.movieInfo.movieSubsets.count>1) {
//            _termBtn.hidden = NO;
//        }else{
//            _termBtn.hidden = YES;
//        }
  
        _totalTimeLabel.sd_layout.rightSpaceToView(_qualityBtn, 25);

        _btnContainer.sd_layout.bottomSpaceToView(_slider, 65).heightIs(30);
        [_voiceDecreaseBtn setImage:[UIImage imageNamed:@"Qukan_voidLoss"] forState:UIControlStateNormal];
        [_voicePlusBtn setImage:[UIImage imageNamed:@"Qukan_voidAdd"] forState:UIControlStateNormal];
        _voiceSeparator.hidden = NO;
    }
 
//    if (QukanAirPlayManager.sharedManager.isFromCacheFinishedPage) {
//        _termBtn.hidden = YES;
//        _qualityBtn.hidden = YES;
//    }
    
    [self layoutSubviews];

}
- (void)setData{

    @weakify(self)
    
    [[QukanAirPlayManager.sharedManager.showAirPlayControlViewSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.hidden = NO;
        
//        NSString *title = QukanAirPlayManager.sharedManager.selectedPlayInfo.videoFormatName;
//        [self.qualityBtn setTitle:@"高清" forState:UIControlStateNormal];
      }];

    
    [[QukanAirPlayManager.sharedManager.disConnectSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
       @strongify(self)
        self.hidden = YES;
    }];
    
    
}

- (void)handleAirPlayBtn{

    if ([QukanAirPlayManager.sharedManager.getCurrentOrientation isEqualToString:KDeviceIsPortrait]) {
        [QukanAirPlayDeviceListView show];
    }else{
        [QukanAirPlayLandScapeDeviceListView showInView:self.superview];
    }



}

- (void)handleQualityBtn{
    [QukanAirPlayLandscapeQualityListView showInView:self];
    
}
- (void)handleTermBtn{
    [QukanAirPlayLandscapeTermView showInView:self];

}

- (void)deviceShouldRotate{

      [[NSNotificationCenter defaultCenter] postNotificationName:Qukan_DeviceShouldRotate object:nil];


}
- (void)handleVoicePlusBtn{
    
    [QukanAirPlayManager.sharedManager Qukan_voicePlus];
}

- (void)handleVoiceDecreaseBtn{
    [QukanAirPlayManager.sharedManager Qukan_voiceDecrease];
    
}
- (void)handleMuteBtn{
    [QukanAirPlayManager.sharedManager Qukan_mute];
}

- (void)handlePlayOrPauseBtn{
     [QukanAirPlayManager.sharedManager Qukan_playOrPause];

}


#pragma mark slider actions

-(void)sliderBeginDragingAction:(UISlider *)sender{
    _isDraging = YES;
}
- (void)sliderEndDragingAction:(UISlider *)sender{
    _isDraging = NO;    
    NSInteger currentTime = sender.value * _totalTime;
    [QukanAirPlayManager.sharedManager Qukan_seekToTime:currentTime];
    
}
- (void)sliderDragingOutAction:(UISlider *)sender{
    _isDraging = NO;
    NSInteger currentTime = sender.value * _totalTime;
    [QukanAirPlayManager.sharedManager Qukan_seekToTime:currentTime];
}
- (void)sliderValueChangedAction:(UISlider *)sender{
//    NSInteger currentTime = sender.value * _totalTime;
//    _currentTimeLabel.text = [ZFUtilities convertTimeSecond:currentTime];
//    self.fastView.hidden = NO;
//    [self.fastView setValue:sender.value totalDuration:self.totalTime];
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideFastView) object:nil];
//     [self performSelector:@selector(hideFastView) withObject:nil afterDelay:0.5];
}
- (void)hideFastView {
//    [UIView animateWithDuration:0.4 animations:^{
//        //        self.fastView.transform = CGAffineTransformIdentity;
//        self.fastView.alpha = 0;
//    } completion:^(BOOL finished) {
//        self.fastView.hidden = YES;
//        self.fastView.alpha = 1;
//    }];
//    //    self.fastView.hidden = YES;
}
#pragma mark====== gestureDelegate
//解决UISlider的touchUpInSide和touchUpOutSide方法在界面有其他手势的情况下小范围拖动无效问题
-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {
    if ([touch.view isKindOfClass:UISlider.class]) {
        return NO;
    }else{
        return YES;
    }
 
}

@end
