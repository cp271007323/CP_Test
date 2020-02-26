//
//  QukanctivityIndicatorView.m
//  DGActivityIndicatorExample
//
//  Created by Danil Gontovnik on 5/23/15.
//  Copyright (c) 2015 Danil Gontovnik. All rights reserved.
//

#import "QukanctivityIndicatorNineDotsAnimation.h"
#import "QukanctivityIndicatorTriplePulseAnimation.h"
#import "QukanctivityIndicatorFiveDotsAnimation.h"
#import "QukanctivityIndicatorRotatingSquaresAnimation.h"
#import "QukanctivityIndicatorDoubleBounceAnimation.h"
#import "QukanctivityIndicatorTwoDotsAnimation.h"
#import "QukanctivityIndicatorThreeDotsAnimation.h"
#import "QukanctivityIndicatorBallPulseAnimation.h"
#import "QukanctivityIndicatorBallClipRotateAnimation.h"
#import "QukanctivityIndicatorBallClipRotatePulseAnimation.h"
#import "QukanctivityIndicatorBallClipRotateMultipleAnimation.h"
#import "QukanctivityIndicatorBallRotateAnimation.h"
#import "QukanctivityIndicatorBallZigZagAnimation.h"
#import "QukanctivityIndicatorBallZigZagDeflectAnimation.h"
#import "QukanctivityIndicatorBallTrianglePathAnimation.h"
#import "QukanctivityIndicatorBallScaleAnimation.h"
#import "QukanctivityIndicatorLineScaleAnimation.h"
#import "QukanctivityIndicatorLineScalePartyAnimation.h"
#import "QukanctivityIndicatorBallScaleMultipleAnimation.h"
#import "QukanctivityIndicatorBallPulseSyncAnimation.h"
#import "QukanctivityIndicatorBallBeatAnimation.h"
#import "QukanctivityIndicatorLineScalePulseOutAnimation.h"
#import "QukanctivityIndicatorLineScalePulseOutRapidAnimation.h"
#import "QukanctivityIndicatorBallScaleRippleAnimation.h"
#import "QukanctivityIndicatorBallScaleRippleMultipleAnimation.h"
#import "QukanctivityIndicatorTriangleSkewSpinAnimation.h"
#import "QukanctivityIndicatorBallGridBeatAnimation.h"
#import "QukanctivityIndicatorBallGridPulseAnimation.h"
#import "QukanctivityIndicatorRotatingSandglassAnimation.h"
#import "QukanctivityIndicatorRotatingTrigonAnimation.h"
#import "QukanctivityIndicatorTripleRingsAnimation.h"
#import "QukanctivityIndicatorCookieTerminatorAnimation.h"
#import "QukanctivityIndicatorBallSpinFadeLoader.h"

static const CGFloat kDGActivityIndicatorDefaultSize = 40.0f;

@interface QukanctivityIndicatorView () {
    CALayer *_animationLayer;
}

@end

@implementation QukanctivityIndicatorView

#pragma mark -
#pragma mark Constructors

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _tintColor = [UIColor whiteColor];
        _size = kDGActivityIndicatorDefaultSize;
        [self commonInit];
    }
    return self;
}

- (id)initWithType:(QukanctivityIndicatorAnimationType)type {
    return [self initWithType:type tintColor:[UIColor whiteColor] size:kDGActivityIndicatorDefaultSize];
}

- (id)initWithType:(QukanctivityIndicatorAnimationType)type tintColor:(UIColor *)tintColor {
    return [self initWithType:type tintColor:tintColor size:kDGActivityIndicatorDefaultSize];
}

- (id)initWithType:(QukanctivityIndicatorAnimationType)type tintColor:(UIColor *)tintColor size:(CGFloat)size {
    self = [super init];
    if (self) {
        _type = type;
        _size = size;
        _tintColor = tintColor;
        [self commonInit];
    }
    return self;
}

#pragma mark -
#pragma mark Methods

- (void)commonInit {
    self.userInteractionEnabled = NO;
    self.hidden = YES;
    
    _animationLayer = [[CALayer alloc] init];
    [self.layer addSublayer:_animationLayer];

    [self setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
}

- (void)setupAnimation {
    _animationLayer.sublayers = nil;
    
    id<QukanctivityIndicatorAnimationProtocol> animation = [QukanctivityIndicatorView activityIndicatorAnimationForAnimationType:_type];
    
    if ([animation respondsToSelector:@selector(setupAnimationInLayer:withSize:tintColor:)]) {
        [animation setupAnimationInLayer:_animationLayer withSize:CGSizeMake(_size, _size) tintColor:_tintColor];
        _animationLayer.speed = 0.0f;
    }
}

- (void)startAnimating {
    if (!_animationLayer.sublayers) {
        [self setupAnimation];
    }
    self.hidden = NO;
    _animationLayer.speed = 1.0f;
    _animating = YES;
}

- (void)stopAnimating {
    _animationLayer.speed = 0.0f;
    _animating = NO;
    self.hidden = YES;
}

#pragma mark -
#pragma mark Setters

- (void)setType:(QukanctivityIndicatorAnimationType)type {
    if (_type != type) {
        _type = type;
        
        [self setupAnimation];
    }
}

- (void)setSize:(CGFloat)size {
    if (_size != size) {
        _size = size;
        
        [self setupAnimation];
        [self invalidateIntrinsicContentSize];
    }
}

- (void)setTintColor:(UIColor *)tintColor {
    if (![_tintColor isEqual:tintColor]) {
        _tintColor = tintColor;
        [self setupAnimation];
    }
}

#pragma mark -
#pragma mark Getters

+ (id<QukanctivityIndicatorAnimationProtocol>)activityIndicatorAnimationForAnimationType:(QukanctivityIndicatorAnimationType)type {
    switch (type) {
        case QukanctivityIndicatorAnimationTypeNineDots:
            return [[QukanctivityIndicatorNineDotsAnimation alloc] init];
        case QukanctivityIndicatorAnimationTypeTriplePulse:
            return [[QukanctivityIndicatorTriplePulseAnimation alloc] init];
        case QukanctivityIndicatorAnimationTypeFiveDots:
            return [[QukanctivityIndicatorFiveDotsAnimation alloc] init];
        case QukanctivityIndicatorAnimationTypeRotatingSquares:
            return [[QukanctivityIndicatorRotatingSquaresAnimation alloc] init];
        case QukanctivityIndicatorAnimationTypeDoubleBounce:
            return [[QukanctivityIndicatorDoubleBounceAnimation alloc] init];
        case QukanctivityIndicatorAnimationTypeTwoDots:
            return [[QukanctivityIndicatorTwoDotsAnimation alloc] init];
        case QukanctivityIndicatorAnimationTypeThreeDots:
            return [[QukanctivityIndicatorThreeDotsAnimation alloc] init];
        case QukanctivityIndicatorAnimationTypeBallPulse:
            return [[QukanctivityIndicatorBallPulseAnimation alloc] init];
        case QukanctivityIndicatorAnimationTypeBallClipRotate:
            return [[QukanctivityIndicatorBallClipRotateAnimation alloc] init];
        case QukanctivityIndicatorAnimationTypeBallClipRotatePulse:
            return [[QukanctivityIndicatorBallClipRotatePulseAnimation alloc] init];
        case QukanctivityIndicatorAnimationTypeBallClipRotateMultiple:
            return [[QukanctivityIndicatorBallClipRotateMultipleAnimation alloc] init];
        case QukanctivityIndicatorAnimationTypeBallRotate:
            return [[QukanctivityIndicatorBallRotateAnimation alloc] init];
        case QukanctivityIndicatorAnimationTypeBallZigZag:
            return [[QukanctivityIndicatorBallZigZagAnimation alloc] init];
        case QukanctivityIndicatorAnimationTypeBallZigZagDeflect:
            return [[QukanctivityIndicatorBallZigZagDeflectAnimation alloc] init];
        case QukanctivityIndicatorAnimationTypeBallTrianglePath:
            return [[QukanctivityIndicatorBallTrianglePathAnimation alloc] init];
        case QukanctivityIndicatorAnimationTypeBallScale:
            return [[QukanctivityIndicatorBallScaleAnimation alloc] init];
        case QukanctivityIndicatorAnimationTypeLineScale:
            return [[QukanctivityIndicatorLineScaleAnimation alloc] init];
        case QukanctivityIndicatorAnimationTypeLineScaleParty:
            return [[QukanctivityIndicatorLineScalePartyAnimation alloc] init];
        case QukanctivityIndicatorAnimationTypeBallScaleMultiple:
            return [[QukanctivityIndicatorBallScaleMultipleAnimation alloc] init];
        case QukanctivityIndicatorAnimationTypeBallPulseSync:
            return [[QukanctivityIndicatorBallPulseSyncAnimation alloc] init];
        case QukanctivityIndicatorAnimationTypeBallBeat:
            return [[QukanctivityIndicatorBallBeatAnimation alloc] init];
        case QukanctivityIndicatorAnimationTypeLineScalePulseOut:
            return [[QukanctivityIndicatorLineScalePulseOutAnimation alloc] init];
        case QukanctivityIndicatorAnimationTypeLineScalePulseOutRapid:
            return [[QukanctivityIndicatorLineScalePulseOutRapidAnimation alloc] init];
        case QukanctivityIndicatorAnimationTypeBallScaleRipple:
            return [[QukanctivityIndicatorBallScaleRippleAnimation alloc] init];
        case QukanctivityIndicatorAnimationTypeBallScaleRippleMultiple:
            return [[QukanctivityIndicatorBallScaleRippleMultipleAnimation alloc] init];
        case QukanctivityIndicatorAnimationTypeTriangleSkewSpin:
            return [[QukanctivityIndicatorTriangleSkewSpinAnimation alloc] init];
        case QukanctivityIndicatorAnimationTypeBallGridBeat:
            return [[QukanctivityIndicatorBallGridBeatAnimation alloc] init];
        case QukanctivityIndicatorAnimationTypeBallGridPulse:
            return [[QukanctivityIndicatorBallGridPulseAnimation alloc] init];
        case QukanctivityIndicatorAnimationTypeRotatingSandglass:
            return [[QukanctivityIndicatorRotatingSandglassAnimation alloc]init];
        case QukanctivityIndicatorAnimationTypeRotatingTrigons:
            return [[QukanctivityIndicatorRotatingTrigonAnimation alloc]init];
        case QukanctivityIndicatorAnimationTypeTripleRings:
            return [[QukanctivityIndicatorTripleRingsAnimation alloc]init];
        case QukanctivityIndicatorAnimationTypeCookieTerminator:
            return [[QukanctivityIndicatorCookieTerminatorAnimation alloc]init];
        case QukanctivityIndicatorAnimationTypeBallSpinFadeLoader:
            return [[QukanctivityIndicatorBallSpinFadeLoader alloc] init];
    }
    return nil;
}

#pragma mark -
#pragma mark Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _animationLayer.frame = self.bounds;

    BOOL animating = _animating;

    if (animating)
        [self stopAnimating];

    [self setupAnimation];

    if (animating)
        [self startAnimating];
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(_size, _size);
}

@end
