//
//  ZFLandScapeControlView.m
//  ZFPlayer
//
// Copyright (c) 2016年 任子丰 ( http://github.com/renzifeng )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "ZFLandScapeControlView.h"

#import "ZFUtilities.h"

#import "QukanShareView.h"
@interface ZFLandScapeControlView () <ZFSliderViewDelegate>
/// 顶部工具栏
@property (nonatomic, strong) UIView *topToolView;
/// 返回按钮
@property (nonatomic, strong) UIButton *backBtn;
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 投屏
@property (nonatomic, strong) UIButton *airPlayBtn;
/// 底部工具栏
@property (nonatomic, strong) UIView *bottomToolView;
/// 播放或暂停按钮
@property (nonatomic, strong) UIButton *playOrPauseBtn;
/// 播放或暂停按钮
@property (nonatomic, strong) UIButton *refreshAgainBtn;
/// 更换路线
@property (nonatomic, strong) UIButton *changeLineButton;
/// 播放的当前时间 
@property (nonatomic, strong) UILabel *currentTimeLabel;
/// 滑杆
@property (nonatomic, strong) ZFSliderView *slider;
/// 视频总时间
@property (nonatomic, strong) UILabel  *totalTimeLabel;
///分享按钮
@property (nonatomic, strong) UIButton *shareButton;
///小按钮
@property (nonatomic, strong) UIButton *smallFullButton;

/// 锁定屏幕按钮
@property (nonatomic, strong) UIButton *lockBtn;
/// 添加选择路线的视图
@property (nonatomic, strong) UIView   *allLiveLineView;
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, strong) NSArray  *liveArray;
@property(nonatomic, strong) QukanShareView *Qukan_ShareView;


///刷洗按钮
@property(nonatomic, strong) UIButton  *headRefreshButton;

@end

@implementation ZFLandScapeControlView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.topToolView];
        [self.topToolView addSubview:self.backBtn];
        [self.topToolView addSubview:self.titleLabel];
        [self.topToolView addSubview:self.airPlayBtn];
        [self addSubview:self.bottomToolView];
        [self.bottomToolView addSubview:self.playOrPauseBtn];
        [self.bottomToolView addSubview:self.refreshAgainBtn];
        [self.bottomToolView addSubview:self.changeLineButton];
        [self.bottomToolView addSubview:self.currentTimeLabel];
        
        [self.bottomToolView addSubview:self.slider];
        [self.bottomToolView addSubview:self.totalTimeLabel];
       
        if (self.stytleForLive) {//直播
             [self.topToolView addSubview:self.shareButton];
        } else {//视频
             [self.bottomToolView addSubview:self.shareButton];
        }
        [self.bottomToolView addSubview:self.smallFullButton];
        [self addSubview:self.lockBtn];
        
        [self addSubview:self.allLiveLineView];
        
        // 设置子控件的响应事件
        [self makeSubViewsAction];
        [self resetControlView];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:Qukan_AddLiveLineView_NotificationName object:nil];
    
        /// statusBarFrame changed
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(layOutControllerViews) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat min_x = 0;
    CGFloat min_y = 0;
    CGFloat min_w = 0;
    CGFloat min_h = 0;
    CGFloat min_view_w = self.bounds.size.width;
    CGFloat min_view_h = self.bounds.size.height;
    
    CGFloat min_margin = 9;
    
    min_x = 0;
    min_y = 0;
    min_w = min_view_w;
    min_h = iPhoneX ? 50 : 50;
    self.topToolView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = (iPhoneX && self.player.orientationObserver.fullScreenMode == ZFFullScreenModeLandscape) ? 40: 10;
    min_y = (iPhoneX && self.player.orientationObserver.fullScreenMode == ZFFullScreenModeLandscape) ? 15: (iPhoneX ? 10 : 10);
    min_w = 50;
    min_h = 50;
    self.backBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = self.backBtn.right + 5;
    min_y = 0;
    min_w = min_view_w - min_x - 15 ;
    min_h = 30;
    self.titleLabel.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.titleLabel.centerY = self.backBtn.centerY;
    
    min_h = 73;
    min_h = iPhoneX ? 100 : 73;
    min_x = 0;
    min_y = min_view_h - min_h;
    min_w = min_view_w;
    self.bottomToolView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    
    min_x = (iPhoneX && self.player.orientationObserver.fullScreenMode == ZFFullScreenModeLandscape) ? 44: 15;
    min_y = 32;
    min_w = 30;
    min_h = 30;
    self.playOrPauseBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = self.playOrPauseBtn.right + 10;
    min_y = 32;
    min_w = 43;
    min_h = 30;
    self.refreshAgainBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.refreshAgainBtn.hidden = !self.stytleForLive;
    
    min_x = self.refreshAgainBtn.right + 10;
    min_y = 32;
    min_w = 83;
    min_h = 25;
    self.changeLineButton.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.changeLineButton.hidden = !self.stytleForLive;
    
    min_x = self.playOrPauseBtn.right + 4;
    min_y = 0;
    min_w = 62;
    min_h = 30;
    self.currentTimeLabel.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.currentTimeLabel.centerY = self.playOrPauseBtn.centerY;
    
    min_w = 62;
    min_x = self.bottomToolView.width - min_w - ((iPhoneX && self.player.orientationObserver.fullScreenMode == ZFFullScreenModeLandscape) ? 44: min_margin);
    min_x = self.stytleForLive ?  min_x : min_x - 100;
    min_y = 0;
    min_h = 30;
    self.totalTimeLabel.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.totalTimeLabel.centerY = self.playOrPauseBtn.centerY;
    
    min_x = self.currentTimeLabel.right + 4;
    min_y = 0;
    min_w = self.totalTimeLabel.left - min_x - 4;
    min_h = 30;
    self.slider.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.slider.centerY = self.playOrPauseBtn.centerY;
    
    if (self.stytleForLive) {
        min_x = isIPhoneXSeries() ? kScreenWidth - 80 : kScreenWidth - 50;
        min_y = 5;
        min_w = 50;
        min_h = 50;
        self.shareButton.frame = CGRectMake(min_x, min_y, min_w, min_h);
        self.shareButton.centerY = self.backBtn.centerY;
        [self.topToolView addSubview:self.shareButton];
    } else {
        min_x = self.totalTimeLabel.right + 4;
        min_y = 5;
        min_w = 50;
        min_h = 50;
//        self.shareButton.backgroundColor = UIColor.redColor;
        self.shareButton.frame = CGRectMake(min_x, min_y, min_w, min_h);
        self.shareButton.centerY = self.totalTimeLabel.centerY;
        [self.bottomToolView addSubview:self.shareButton];
    }
    
    min_x = isIPhoneXSeries() ? kScreenWidth - 90 : kScreenWidth - 60;
    min_y = 0;
    min_w = 40;
    min_h = 60;
    self.smallFullButton.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.smallFullButton.centerY = self.playOrPauseBtn.centerY;
    
    min_x = isIPhoneXSeries() ? kScreenWidth - 130 : kScreenWidth - 100;
    min_y = 5;
    min_w = 50;
    min_h = 50;
    self.airPlayBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.airPlayBtn.centerY = self.shareButton.centerY;
    self.airPlayBtn.hidden = !self.stytleForLive;
    
    int a = [QukanTool Qukan_xuan:kQukan10];
    if (a == 0) {
        self.airPlayBtn.hidden = YES;
    }
    
    min_x = (iPhoneX && self.player.orientationObserver.fullScreenMode == ZFFullScreenModeLandscape) ? 50: 18;
    min_y = 0;
    min_w = 40;
    min_h = 40;
    self.lockBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.lockBtn.centerY = self.centerY;
    
    min_h = kScreenWidth;
    min_x = kScreenWidth - SCALING_RATIO(100);
    min_y = 0;
    min_w = SCALING_RATIO(100);
    self.allLiveLineView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.allLiveLineView.hidden = YES;
    
    
    if (!self.isShow) {
        self.topToolView.top = -self.topToolView.height;
        self.bottomToolView.top = self.height;
    } else {
        if (self.player.isLockedScreen) {
            self.topToolView.top = -self.topToolView.height;
            self.bottomToolView.top = self.height;
        } else {
            self.topToolView.top = 0;
            self.bottomToolView.top = self.height - self.bottomToolView.height;
        }
    }
}

- (void)makeSubViewsAction {
    [self.backBtn addTarget:self action:@selector(backBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.airPlayBtn addTarget:self action:@selector(airPlayBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.playOrPauseBtn addTarget:self action:@selector(playPauseButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.refreshAgainBtn addTarget:self action:@selector(refreshAgainButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.changeLineButton addTarget:self action:@selector(changeLineButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.lockBtn addTarget:self action:@selector(lockButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.shareButton addTarget:self action:@selector(shareButtonCilckAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.smallFullButton addTarget:self action:@selector(smallFullButtonCilckAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)layOutControllerViews {
    [self layoutIfNeeded];
    [self setNeedsLayout];
}

#pragma mark - ZFSliderViewDelegate

- (void)sliderTouchBegan:(float)value {
    self.slider.isdragging = YES;
}

- (void)sliderTouchEnded:(float)value {
    if (self.player.totalTime > 0) {
        @weakify(self)
        [self.player seekToTime:self.player.totalTime*value completionHandler:^(BOOL finished) {
            @strongify(self)
            if (finished) {
                self.slider.isdragging = NO;
            }
        }];
        if (self.seekToPlay) {
            [self.player.currentPlayerManager play];
        }
    } else {
        self.slider.isdragging = NO;
    }
    if (self.sliderValueChanged) self.sliderValueChanged(value);
}

- (void)sliderValueChanged:(float)value {
    if (self.player.totalTime == 0) {
        self.slider.value = 0;
        return;
    }
    self.slider.isdragging = YES;
    NSString *currentTimeString = [ZFUtilities convertTimeSecond:self.player.totalTime*value];
    self.currentTimeLabel.text = currentTimeString;
    if (self.sliderValueChanging) self.sliderValueChanging(value,self.slider.isForward);
}

- (void)sliderTapped:(float)value {
    if (self.player.totalTime > 0) {
        self.slider.isdragging = YES;
        @weakify(self)
        [self.player seekToTime:self.player.totalTime*value completionHandler:^(BOOL finished) {
            @strongify(self)
            if (finished) {
                self.slider.isdragging = NO;
                [self.player.currentPlayerManager play];
            }
        }];
    } else {
        self.slider.isdragging = NO;
        self.slider.value = 0;
    }
}

#pragma mark -

/// 重置ControlView
- (void)resetControlView {
    self.slider.value                = 0;
    self.slider.bufferValue          = 0;
    self.currentTimeLabel.text       = @"00:00";
    self.totalTimeLabel.text         = @"00:00";
    self.backgroundColor             = [UIColor clearColor];
    self.playOrPauseBtn.selected     = YES;
    self.titleLabel.text             = @"";
    self.topToolView.alpha           = 1;
    self.bottomToolView.alpha        = 1;
    self.isShow                      = NO;
}

- (void)showControlView {
    self.lockBtn.alpha               = 1;
    self.isShow                      = YES;
    if (self.player.isLockedScreen) {
        self.topToolView.top        = -self.topToolView.height;
        self.bottomToolView.top     = self.height;
    } else {
        self.topToolView.top        = 0;
        self.bottomToolView.top     = self.height - self.bottomToolView.height;
    }
    self.lockBtn.left             = iPhoneX ? 50: 18;
    
    self.player.statusBarHidden      = NO;
    if (self.player.isLockedScreen) {
        self.topToolView.alpha       = 0;
        self.bottomToolView.alpha    = 0;
    } else {
        self.topToolView.alpha       = 1;
        self.bottomToolView.alpha    = 1;
    }
    
//    //判断是否为直播
//    self.lockBtn.left             = iPhoneX ? 70: 18;
}

- (void)hideControlView {
    self.isShow                      = NO;
    self.topToolView.top            = -self.topToolView.height;
    self.bottomToolView.top         = self.height;
    self.lockBtn.left             = iPhoneX ? -82: -47;
    self.player.statusBarHidden      = YES;
    self.topToolView.alpha           = 0;
    self.bottomToolView.alpha        = 0;
    self.lockBtn.alpha               = 0;
    
//    //判断直播
//    self.lockBtn.left             = iPhoneX ? -70: -47;
    
}

- (BOOL)shouldResponseGestureWithPoint:(CGPoint)point withGestureType:(ZFPlayerGestureType)type touch:(nonnull UITouch *)touch {
    
    //自己修改（后续需进行判断调整）
//    if (point.top < 100 && point.x > kScreenWidth - 100) {
//        return NO;
//    }//自己修改（后续需进行判断调整）
    self.allLiveLineView.hidden = YES;
    CGRect sliderRect = [self.bottomToolView convertRect:self.slider.frame toView:self];
    if (CGRectContainsPoint(sliderRect, point)) {
        return NO;
    }
    if (self.player.isLockedScreen && type != ZFPlayerGestureTypeSingleTap) { // 锁定屏幕方向后只相应tap手势
        return NO;
    }
    return YES;
}

- (void)videoPlayer:(ZFPlayerController *)videoPlayer presentationSizeChanged:(CGSize)size {
    self.lockBtn.hidden = self.player.orientationObserver.fullScreenMode == ZFFullScreenModePortrait;
}

- (void)videoPlayer:(ZFPlayerController *)videoPlayer currentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime {
    if (!self.slider.isdragging) {
        NSString *currentTimeString = [ZFUtilities convertTimeSecond:currentTime];
        self.currentTimeLabel.text = currentTimeString;
        NSString *totalTimeString = [ZFUtilities convertTimeSecond:totalTime];
        self.totalTimeLabel.text = totalTimeString;
        self.slider.value = videoPlayer.progress;
    }
}

- (void)videoPlayer:(ZFPlayerController *)videoPlayer bufferTime:(NSTimeInterval)bufferTime {
    self.slider.bufferValue = videoPlayer.bufferProgress;
}

- (void)showTitle:(NSString *)title fullScreenMode:(ZFFullScreenMode)fullScreenMode {
    self.titleLabel.text = title;
    self.player.orientationObserver.fullScreenMode = fullScreenMode;
    self.lockBtn.hidden = fullScreenMode == ZFFullScreenModePortrait;
}

/// 调节播放进度slider和当前时间更新
- (void)sliderValueChanged:(CGFloat)value currentTimeString:(NSString *)timeString {
    self.slider.value = value;
    self.currentTimeLabel.text = timeString;
    self.slider.isdragging = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.slider.sliderBtn.transform = CGAffineTransformMakeScale(1.2, 1.2);
    }];
}

/// 滑杆结束滑动
- (void)sliderChangeEnded {
    self.slider.isdragging = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.slider.sliderBtn.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark - action

- (void)backBtnClickAction:(UIButton *)sender {
    self.lockBtn.selected = NO;
    self.player.lockedScreen = NO;
    self.lockBtn.selected = NO;
    if (self.player.orientationObserver.supportInterfaceOrientation & ZFInterfaceOrientationMaskPortrait) {
        [self.player enterFullScreen:NO animated:YES];
    }
    if (self.backBtnClickCallback) {
        self.backBtnClickCallback();
    }
}

- (void)airPlayBtnClickAction:(UIButton *)sender {
    if (self.isCanAir) {
        if (self.airPlayBtnClickCallback) {
            self.airPlayBtnClickCallback();
        }
        return;
    }
    self.lockBtn.selected = NO;
    self.player.lockedScreen = NO;
    self.lockBtn.selected = NO;
    
    if (self.airPlayBtnClickCallback) {
        self.airPlayBtnClickCallback();
    }
}

- (void)playPauseButtonClickAction:(UIButton *)sender {
    [self playOrPause];
}

- (void)refreshAgainButtonClickAction:(UIButton *)sender {
    if (self.refreshBtnClickCallback) {
        self.refreshBtnClickCallback();
    }
}

- (void)changeLineButtonClickAction:(UIButton *)sender {
    [self changeLineButtonPause];
}

- (void)shareButtonCilckAction:(UIButton *)sender {
    if (self.shareBtnClickCallback) {
        self.shareBtnClickCallback();
    }
}

- (void)smallFullButtonCilckAction:(UIButton *)sender {
    self.lockBtn.selected = NO;
    self.player.lockedScreen = NO;
    self.lockBtn.selected = NO;
    if (self.player.orientationObserver.supportInterfaceOrientation & ZFInterfaceOrientationMaskPortrait) {
        [self.player enterFullScreen:NO animated:YES];
    }
    
    [QukanTool Qukan_interfaceOrientation:UIInterfaceOrientationPortrait];
}

/// 根据当前播放状态取反
- (void)playOrPause {
    self.playOrPauseBtn.selected = !self.playOrPauseBtn.isSelected;
    self.playOrPauseBtn.isSelected? [self.player.currentPlayerManager play]: [self.player.currentPlayerManager pause];
}

- (void)changeLineButtonPause {
    if (self.changeLineBtnClickCallback) {
        self.changeLineBtnClickCallback();
    }
}

- (void)playBtnSelectedState:(BOOL)selected {
    self.playOrPauseBtn.selected = selected;
}

- (void)lockButtonClickAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.player.lockedScreen = sender.selected;
}


- (void)indexButtonCilck:(UIButton *)button {
     [[NSNotificationCenter defaultCenter] postNotificationName:Qukan_ChangeLine_NotificationName object:[NSString stringWithFormat:@"%ld",button.tag]];
}

- (void)cancleButtonCilck {
    self.allLiveLineView.hidden = YES;
}


- (void)indexLabelTap:(UIGestureRecognizer *)tap {
     [[NSNotificationCenter defaultCenter] postNotificationName:Qukan_ChangeLine_NotificationName object:[NSString stringWithFormat:@"%ld",tap.view.tag]];
}

#pragma mark - getter

- (UIView *)topToolView {
    if (!_topToolView) {
        _topToolView = [[UIView alloc] init];
//        UIImage *image = ZFPlayer_Image(@"ZFPlayer_topAndShadow@3x");
         UIImage *image = ZFPlayer_Image(@"ZFPlayer_top_shadow");
        _topToolView.layer.contents = (id)image.CGImage;
    }
    return _topToolView;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:kImageNamed(@"Qukan_Play_Back") forState:UIControlStateNormal];
    }
    return _backBtn;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:15.0];
    }
    return _titleLabel;
}

- (UIButton *)airPlayBtn {
    if (!_airPlayBtn) {
        _airPlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_airPlayBtn addTarget:self action:@selector(onAirPlayBtn) forControlEvents:UIControlEventTouchUpInside];
        [_airPlayBtn setImage:kImageNamed(@"Qukan_videoput") forState:UIControlStateNormal];
    }
    return _airPlayBtn;
}


- (UIView *)bottomToolView {
    if (!_bottomToolView) {
        _bottomToolView = [[UIView alloc] init];
//        UIImage *image = ZFPlayer_Image(@"ZFPlayer_topAndShadow@3x");
        UIImage *image = ZFPlayer_Image(@"ZFPlayer_bottom_shadow");
        _bottomToolView.layer.contents = (id)image.CGImage;
    }
    return _bottomToolView;
}

- (UIButton *)playOrPauseBtn {
    if (!_playOrPauseBtn) {
        _playOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playOrPauseBtn setImage:kImageNamed(@"Qukan_player_pasue") forState:UIControlStateNormal];
        [_playOrPauseBtn setImage:kImageNamed(@"Qukan_player_star") forState:UIControlStateSelected];
    }
    return _playOrPauseBtn;
}

- (UIButton *)refreshAgainBtn {
    if (!_refreshAgainBtn) {
        _refreshAgainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_refreshAgainBtn setImage:[kImageNamed(@"Qukan_player_refresh") imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        _refreshAgainBtn.backgroundColor = [UIColor clearColor];
    }
    return _refreshAgainBtn;
}

- (UIButton *)changeLineButton {
    if (!_changeLineButton) {
        _changeLineButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changeLineButton setTitle:@"更换线路" forState:UIControlStateNormal];
        _changeLineButton.layer.cornerRadius = 3;
        _changeLineButton.layer.masksToBounds = YES;
        _changeLineButton.layer.borderWidth = 1;
        _changeLineButton.titleLabel.font = kSystemFont(15);
        _changeLineButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _changeLineButton.userInteractionEnabled = YES;
        _changeLineButton.hidden = !self.stytleForLive;
    }
    return _changeLineButton;
}

- (UILabel *)currentTimeLabel {
    if (!_currentTimeLabel) {
        _currentTimeLabel = [[UILabel alloc] init];
        _currentTimeLabel.textColor = [UIColor whiteColor];
        _currentTimeLabel.font = [UIFont systemFontOfSize:14.0f];
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _currentTimeLabel;
}

- (ZFSliderView *)slider {
    if (!_slider) {
        _slider = [[ZFSliderView alloc] init];
        _slider.delegate = self;
        _slider.maximumTrackTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.8];
        _slider.bufferTrackTintColor  = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        _slider.minimumTrackTintColor = [UIColor whiteColor];
        [_slider setThumbImage:ZFPlayer_Image(@"ZFPlayer_slider") forState:UIControlStateNormal];
        _slider.sliderHeight = 2;
    }
    return _slider;
}

- (UIButton *)shareButton {
    if (!_shareButton) {
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_shareButton setTitle:@"分享" forState:UIControlStateNormal];
        [_shareButton setImage:kImageNamed(@"Qukan_player_share") forState:UIControlStateNormal];
        [_shareButton setTitleColor:kCommonBlackColor forState:UIControlStateNormal];
        _shareButton.hidden = self.stytleForLive;
    }
    return _shareButton;
}

- (UIButton *)smallFullButton {
    if (!_smallFullButton) {
        _smallFullButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_smallFullButton setImage:kImageNamed(@"Qukan_player_small") forState:UIControlStateNormal];
    }
    return _smallFullButton;
}

- (UILabel *)totalTimeLabel {
    if (!_totalTimeLabel) {
        _totalTimeLabel = [[UILabel alloc] init];
        _totalTimeLabel.textColor = [UIColor whiteColor];
        _totalTimeLabel.font = [UIFont systemFontOfSize:14.0f];
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _totalTimeLabel;
}

- (UIButton *)lockBtn {
    if (!_lockBtn) {
        _lockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lockBtn setImage:ZFPlayer_Image(@"ZFPlayer_unlock-nor") forState:UIControlStateNormal];
        [_lockBtn setImage:ZFPlayer_Image(@"ZFPlayer_lock-nor") forState:UIControlStateSelected];
    }
    return _lockBtn;
}

- (UIView *)allLiveLineView {
    if (!_allLiveLineView) {
        _allLiveLineView = [[UIView alloc] init];
        _allLiveLineView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
        [[NSNotificationCenter defaultCenter] postNotificationName:Qukan_AddLiveLineView_NotificationName object:nil];
    }
    return _allLiveLineView;
}


@end
