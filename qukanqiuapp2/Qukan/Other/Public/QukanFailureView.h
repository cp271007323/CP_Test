#import <UIKit/UIKit.h>

@interface QukanFailureView : UIView

@property (nonatomic, copy) void(^Qukan_didBlock)(void);

+ (void)Qukan_showWithView:(UIView *)view
             centerY:(CGFloat)centerY
               block:(void(^)(void))block;

+ (void)Qukan_showWithView:(UIView *)view
                   Y:(CGFloat)Y
                 top:(CGFloat)top
               block:(void(^)(void))block;

+ (void)Qukan_hideWithView:(UIView *)view;

+ (QukanFailureView *)topic_showWithView:(UIView *)view
                                       Y:(CGFloat)Y
                                     top:(CGFloat)top
                                   block:(void(^)(void))block;

+ (QukanFailureView *)topic_showWithView:(UIView *)view
                                 centerY:(CGFloat)centerY
                                   block:(void(^)(void))block;

@end
