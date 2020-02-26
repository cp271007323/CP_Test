#import <UIKit/UIKit.h>

@interface QukanNullDataView : UIView

+ (void)Qukan_showWithView:(UIView *)view
    contentImageView:(NSString *)imageName
             content:(NSString *)content;

+ (void)Qukan_showWithView:(UIView *)view
    contentImageView:(NSString *)imageName
             content:(NSString *)content
                 top:(CGFloat)top;

+ (void)Qukan_hideWithView:(UIView *)view;

+ (QukanNullDataView *)topic_showWithView:(UIView *)view
                         contentImageView:(NSString *)imageName
                                  content:(NSString *)content
                                      top:(CGFloat)top;

+ (QukanNullDataView *)topic_showWithView:(UIView *)view
                         contentImageView:(NSString *)imageName
                                  content:(NSString *)content;
@end
