//
//  QukanMatchAniAndVideoView.h
//  Qukan
//
//  Created by leo on 2019/12/27.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanMatchAniAndVideoView : UIView

@property(nonatomic, strong) UIColor *state_label_color;
@property(nonatomic, strong) UIColor *video_btn_color;
@property(nonatomic, strong) UIColor *animation_btn_color;

@property(nonatomic, assign) CGFloat cornerRadius_float;
@property(nonatomic, strong) UIFont *state_label_font;

@property(nonatomic, copy) void (^videoBtnCilckBolck)(void);
@property(nonatomic, copy) void (^animationBtnCilckBolck)(void);

- (void)setDataWithObj:(id)obj;


- (void)setDetailDataWithObj:(id)obj;
@end

NS_ASSUME_NONNULL_END
