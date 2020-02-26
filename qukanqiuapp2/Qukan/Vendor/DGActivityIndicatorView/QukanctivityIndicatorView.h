//
//  QukanctivityIndicatorView.h
//  DGActivityIndicatorExample
//
//  Created by Danil Gontovnik on 5/23/15.
//  Copyright (c) 2015 Danil Gontovnik. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, QukanctivityIndicatorAnimationType) {
    QukanctivityIndicatorAnimationTypeNineDots,
    QukanctivityIndicatorAnimationTypeTriplePulse,
    QukanctivityIndicatorAnimationTypeFiveDots,
    QukanctivityIndicatorAnimationTypeRotatingSquares,
    QukanctivityIndicatorAnimationTypeDoubleBounce,
    QukanctivityIndicatorAnimationTypeTwoDots,
    QukanctivityIndicatorAnimationTypeThreeDots,
    QukanctivityIndicatorAnimationTypeBallPulse,
    QukanctivityIndicatorAnimationTypeBallClipRotate,
    QukanctivityIndicatorAnimationTypeBallClipRotatePulse,
    QukanctivityIndicatorAnimationTypeBallClipRotateMultiple,
    QukanctivityIndicatorAnimationTypeBallRotate,
    QukanctivityIndicatorAnimationTypeBallZigZag,
    QukanctivityIndicatorAnimationTypeBallZigZagDeflect,
    QukanctivityIndicatorAnimationTypeBallTrianglePath,
    QukanctivityIndicatorAnimationTypeBallScale,
    QukanctivityIndicatorAnimationTypeLineScale,
    QukanctivityIndicatorAnimationTypeLineScaleParty,
    QukanctivityIndicatorAnimationTypeBallScaleMultiple,
    QukanctivityIndicatorAnimationTypeBallPulseSync,
    QukanctivityIndicatorAnimationTypeBallBeat,
    QukanctivityIndicatorAnimationTypeLineScalePulseOut,
    QukanctivityIndicatorAnimationTypeLineScalePulseOutRapid,
    QukanctivityIndicatorAnimationTypeBallScaleRipple,
    QukanctivityIndicatorAnimationTypeBallScaleRippleMultiple,
    QukanctivityIndicatorAnimationTypeTriangleSkewSpin,
    QukanctivityIndicatorAnimationTypeBallGridBeat,
    QukanctivityIndicatorAnimationTypeBallGridPulse,
    QukanctivityIndicatorAnimationTypeRotatingSandglass,
    QukanctivityIndicatorAnimationTypeRotatingTrigons,
    QukanctivityIndicatorAnimationTypeTripleRings,
    QukanctivityIndicatorAnimationTypeCookieTerminator,
    QukanctivityIndicatorAnimationTypeBallSpinFadeLoader
};

@interface QukanctivityIndicatorView : UIView

- (id)initWithType:(QukanctivityIndicatorAnimationType)type;
- (id)initWithType:(QukanctivityIndicatorAnimationType)type tintColor:(UIColor *)tintColor;
- (id)initWithType:(QukanctivityIndicatorAnimationType)type tintColor:(UIColor *)tintColor size:(CGFloat)size;

@property (nonatomic) QukanctivityIndicatorAnimationType type;
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic) CGFloat size;

@property (nonatomic, readonly) BOOL animating;

- (void)startAnimating;
- (void)stopAnimating;

@end
