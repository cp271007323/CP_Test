//
//  QukanMatchAniAndVideoView.m
//  Qukan
//
//  Created by leo on 2019/12/27.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanMatchAniAndVideoView.h"
#import "QukanMatchInfoModel.h"
#import "QukanSharpBgView.h"
#import "QukanBasketBallMatchDetailModel.h"

#define animationColor kCommonTextColor
#define videoColor kThemeColor

@interface QukanMatchAniAndVideoView ()

@property(nonatomic, strong) UIButton *video_btn;
@property(nonatomic, strong) UIButton *animation_btn;
@property(nonatomic, strong) UILabel *state_label;
@property(nonatomic, strong) QukanSharpBgView *video_view;
@property(nonatomic, strong) QukanSharpBgView *animation_view;
@property(nonatomic, strong) QukanMatchInfoContentModel *footModel;
@property(nonatomic, strong) QukanBasketBallMatchDetailModel *basketModel;
@property(nonatomic, assign) CGRect selfFrame;


/**<#说明#>*/
@property(nonatomic, assign) BOOL    isDetail;

@end

@implementation QukanMatchAniAndVideoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.selfFrame = frame;
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.backgroundColor = kCommonTextColor;
    
    [self addSubview:self.state_label];
    [self.state_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self addSubview:self.animation_view];
    [self.animation_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.offset(0);
        make.right.mas_equalTo(self.mas_centerX).offset(2.5);
    }];
    
    [self addSubview:self.video_view];
    [self.video_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.offset(0);
        make.left.mas_equalTo(self.mas_centerX).offset(-2.5);
    }];
    
    [self addSubview:self.animation_btn];
    [self.animation_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.offset(0);
        make.right.mas_equalTo(self.mas_centerX).offset(-2.5);
    }];
    
    [self addSubview:self.video_btn];
    [self.video_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.offset(0);
        make.left.mas_equalTo(self.mas_centerX).offset(2.5);
    }];
}

#pragma mark ===================== Public Methods =======================

- (void)setDataWithObj:(id)obj {
    self.isDetail = NO;
    if ([obj isKindOfClass:[QukanBasketBallMatchDetailModel class]]) {
        self.basketModel = (QukanBasketBallMatchDetailModel *)obj;
        [self dataIsBasketModelWithModel:self.basketModel];
    } else {
        self.footModel = (QukanMatchInfoContentModel *)obj;
        [self dataIsFootModelWithModel:self.footModel];
    }
}

- (void)setDetailDataWithObj:(id)obj {
    self.hidden = NO;
    self.isDetail = YES;
    
    if ([obj isKindOfClass:[QukanBasketBallMatchDetailModel class]]) {
        self.basketModel = (QukanBasketBallMatchDetailModel *)obj;
        [self dataIsBasketModelWithModel:self.basketModel];
    } else {
        self.footModel = (QukanMatchInfoContentModel *)obj;
        [self dataIsFootModelWithModel:self.footModel];
    }
}

- (void)dataIsFootModelWithModel:(QukanMatchInfoContentModel *)model {
    // 正在打
   BOOL isPlaying = model.state == 1 || model.state == 2 || model.state == 3 || model.state == 4;
   // 推迟
   BOOL isLatePaly = model.state == -14 || model.state == -13 || model.state == -12 || model.state == -11 || model.state == -10;
   // 打完了
   BOOL isOver = model.state == -1;
   // 未开始
   BOOL isNoStart = model.state == 0;
    
   self.video_btn.hidden = self.animation_btn.hidden = (isLatePaly || isOver || isNoStart);
    NSString *statsText;
    if (isLatePaly) {
        statsText = @"推迟";
    } else if (isOver) {
        statsText = @"已结束";
    } else if (isNoStart) {
        statsText = @"未开始";
    }else {
        statsText = @"比赛中";
    }
    BOOL boolQukan3 = [QukanTool Qukan_xuan:kQukan3];
    BOOL isShowVideo = (isPlaying && model.gqLive.integerValue == 1 && boolQukan3) || (self.isDetail && !isOver && boolQukan3);
    BOOL isShowAnimation = (isPlaying && model.dLive.integerValue == 1 && [QukanTool Qukan_xuan:kQukan15]);
    
//    isShowVideo = YES;
//    isShowAnimation = YES;
    self.video_btn.hidden = self.video_view.hidden = !isShowVideo;
    self.animation_btn.hidden = self.animation_view.hidden = !isShowAnimation;
    
    if (isShowVideo && !isShowAnimation) {
        [self.video_btn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }else if (!isShowVideo && isShowAnimation) {
        [self.animation_btn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }else {
        [self.animation_btn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.offset(0);
            make.right.mas_equalTo(self.mas_centerX).offset(-2.5);
        }];
        
        [self.video_btn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.offset(0);
            make.left.mas_equalTo(self.mas_centerX).offset(2.5);
        }];
    }
    
    
    self.state_label.text = statsText;
    [self setNeedsDisplay];
    [self layoutIfNeeded];
}

- (void)dataIsBasketModelWithModel:(QukanBasketBallMatchDetailModel *)model {
    self.video_btn.hidden = [self getBasketModelStats].length ? YES : NO;
    self.animation_btn.hidden = [self getBasketModelStats].length ? YES : NO;
    
    BOOL isPlaying = model.status.intValue > 0;
    // 推迟
    BOOL isLatePaly = model.status.intValue == -2 || model.status.intValue == -3 || model.status.intValue == -4 || model.status.intValue == -5;
    // 打完了
    BOOL isOver = model.status.intValue == -1;
    // 未开始
    BOOL isNoStart = model.status.intValue == 0;
    
    self.video_btn.hidden = self.animation_btn.hidden = (isLatePaly || isOver || isNoStart);
   NSString *statsText;
   if (isLatePaly) {
       statsText = @"推迟";
   } else if (isOver) {
       statsText = @"已结束";
   } else if (isNoStart) {
       statsText = @"未开始";
   }else {
       statsText = @"比赛中";
   }
    
    BOOL boolQukan3 = [QukanTool Qukan_xuan:kQukan14];
    
   BOOL isShowVideo = (isPlaying && model.matchLive.count && boolQukan3) || (self.isDetail && !isOver && boolQukan3);
   BOOL isShowAnimation = (isPlaying && model.animationUrl.length && [QukanTool Qukan_xuan:kQukan16]);


    
   self.video_btn.hidden = self.video_view.hidden = !isShowVideo;
   self.animation_btn.hidden = self.animation_view.hidden = !isShowAnimation;
   
   if (isShowVideo && !isShowAnimation) {
       [self.video_btn mas_remakeConstraints:^(MASConstraintMaker *make) {
           make.edges.equalTo(self);
       }];
   }else if (!isShowVideo && isShowAnimation) {
       [self.animation_btn mas_remakeConstraints:^(MASConstraintMaker *make) {
           make.edges.equalTo(self);
       }];
   }else {
       [self.animation_btn mas_remakeConstraints:^(MASConstraintMaker *make) {
           make.top.left.bottom.offset(0);
           make.right.mas_equalTo(self.mas_centerX).offset(-2.5);
       }];
       
       [self.video_btn mas_remakeConstraints:^(MASConstraintMaker *make) {
           make.top.right.bottom.offset(0);
           make.left.mas_equalTo(self.mas_centerX).offset(2.5);
       }];
   }
   
   
   self.state_label.text = statsText;
    
    [self setNeedsDisplay];
    [self layoutIfNeeded];
    
}

- (NSString *)getFootModelStats {
    if (self.footModel) {
        switch (self.footModel.state) {
            case -1:
                return @"已结束";
                break;
            case 0:
                return @"未开赛";
                break;
            default:
                return nil;
                break;
        }
    } else {
        return nil;
    }
}

- (NSString *)getBasketModelStats {
    if (self.basketModel) {
        switch (self.basketModel.status.intValue) {
            case -1:
                return @"已结束";
                break;
            case 0:
                return @"未开赛";
                break;
            default:
                return nil;
                break;
        }
    } else {
        return nil;
    }
}

#pragma mark ===================== Setters =====================================

- (void)setState_label_color:(UIColor *)state_label_color {
    self.state_label.backgroundColor = state_label_color;
}

- (void)setVideo_btn_color:(UIColor *)video_btn_color {
    self.video_btn.backgroundColor = video_btn_color;
}

- (void)setAnimation_btn_color:(UIColor *)animation_btn_color {
    self.animation_btn.backgroundColor = animation_btn_color;
}

- (void)setCornerRadius_float:(CGFloat)cornerRadius_float {
    self.layer.cornerRadius = cornerRadius_float;
}

- (void)setState_label_font:(UIFont *)state_label_font {
    self.state_label.font = state_label_font;
}

#pragma mark ===================== Getter ==================================

- (UIButton *)animation_btn {
    if (!_animation_btn) {
        _animation_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_animation_btn setTitle:@" 动画" forState:UIControlStateNormal];
        if (self.size.height == 20) {
            _animation_btn.titleLabel.font = kFont10;
            [_animation_btn setImage:kImageNamed(@"list_Animation") forState:UIControlStateNormal];
        }else {
            _animation_btn.titleLabel.font = kFont14;
            [_animation_btn setImage:kImageNamed(@"Qukan_animation") forState:UIControlStateNormal];
        }
        [_animation_btn setBackgroundImage:[UIImage imageWithColor:animationColor] forState:UIControlStateNormal];
        [_animation_btn setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
        
        @weakify(self)
        [[_animation_btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            if (self.animationBtnCilckBolck) {
                self.animationBtnCilckBolck();
            }
        }];
    }
    return _animation_btn;
}

- (UIButton *)video_btn {
    if (!_video_btn) {
        _video_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_video_btn setTitle:@" 视频" forState:UIControlStateNormal];
        if (self.size.height == 20) {
            _video_btn.titleLabel.font = kFont10;
            [_video_btn setImage:kImageNamed(@"list_Video") forState:UIControlStateNormal];
        }else {
            _video_btn.titleLabel.font = kFont14;
            [_video_btn setImage:kImageNamed(@"Qukan_video") forState:UIControlStateNormal];
        }
        [_video_btn setBackgroundImage:[UIImage imageWithColor:videoColor] forState:UIControlStateNormal];
        [_video_btn setTitleColor:kCommonTextColor forState:UIControlStateNormal];
        @weakify(self)
        [[_video_btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            if (self.videoBtnCilckBolck) {
                self.videoBtnCilckBolck();
            }
        }];
    }
    return _video_btn;
}

- (UILabel *)state_label {
    if (!_state_label) {
        _state_label = UILabel.new;
        _state_label.font = kFont14;
        _state_label.textColor = kCommonWhiteColor;
        _state_label.textAlignment = NSTextAlignmentCenter;
    }
    return _state_label;
}

- (QukanSharpBgView *)video_view {
    if (!_video_view) {
        _video_view = [[QukanSharpBgView alloc] initWithFrame:CGRectMake(0, 0, 20, 30) type:QukanSharpBgViewTypeLeftBottom AndOffset:5 andFullColor:videoColor];
    }
    return _video_view;
}

- (QukanSharpBgView *)animation_view {
    if (!_animation_view) {
        _animation_view = [[QukanSharpBgView alloc] initWithFrame:CGRectMake(0, 0, 20, 30) type:QukanSharpBgViewTypeRightTop AndOffset:5 andFullColor:animationColor];
    }
    return _animation_view;
}

@end
