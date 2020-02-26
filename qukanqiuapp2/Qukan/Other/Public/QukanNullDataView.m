#import "QukanNullDataView.h"

@interface QukanNullDataView()
@property (nonatomic, weak) IBOutlet UIImageView *contentImageView;
@property (nonatomic, weak) IBOutlet UILabel *contentLabel;
@end
@implementation QukanNullDataView

+ (void)Qukan_showWithView:(UIView *)view
          contentImageView:(NSString *)imageName
                   content:(NSString *)content {
    
    for (QukanNullDataView *NullDataView in view.subviews) {
        [NullDataView removeFromSuperview];
    }
    
    QukanNullDataView *v = [QukanNullDataView Qukan_initWithXib];
    if (imageName && imageName.length!=0) {
        UIImage *image = [UIImage imageNamed:imageName];
        v.contentImageView.image = image;
    }
    if (content && content.length!=0) {
        v.contentLabel.text = content;
//        v.contentLabel.textColor = kThemeColor;
    }
    [view addSubview:v];
    [v mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
}

+ (void)Qukan_showWithView:(UIView *)view
          contentImageView:(NSString *)imageName
                   content:(NSString *)content
                       top:(CGFloat)top {
    
    for (UIView *NullDataView in view.subviews) {
        if ([NullDataView isKindOfClass:[QukanNullDataView class]]) {
            [NullDataView removeFromSuperview];
        }
    }
    QukanNullDataView *v = [QukanNullDataView Qukan_initWithXib];
    v.backgroundColor = RGBA(238, 238, 238, 1);
    if (imageName && imageName.length!=0) {
        UIImage *image = [UIImage imageNamed:imageName];
        v.contentImageView.image = image;
        v.contentImageView.userInteractionEnabled = YES;
    }
    if (content && content.length!=0) {
        v.contentLabel.text = content;
        v.contentLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    }
    [view addSubview:v];
    [v mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(view);
        make.top.mas_equalTo(top);
    }];
}

+ (QukanNullDataView *)topic_showWithView:(UIView *)view
          contentImageView:(NSString *)imageName
                   content:(NSString *)content {
    
    for (QukanNullDataView *NullDataView in view.subviews) {
        [NullDataView removeFromSuperview];
    }
    
    QukanNullDataView *v = [QukanNullDataView Qukan_initWithXib];
    if (imageName && imageName.length!=0) {
        UIImage *image = [UIImage imageNamed:imageName];
        v.contentImageView.image = [image imageWithColor:kThemeColor_Alpha(0.8)];
    }
    if (content && content.length!=0) {
        v.contentLabel.text = content;
        v.contentLabel.textColor = kThemeColor;
    }
    [view addSubview:v];
    [v mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
    
    return v;
}

+ (QukanNullDataView *)topic_showWithView:(UIView *)view
          contentImageView:(NSString *)imageName
                   content:(NSString *)content
                       top:(CGFloat)top {
    
    for (QukanNullDataView *NullDataView in view.subviews) {
        [NullDataView removeFromSuperview];
    }
    QukanNullDataView *v = [QukanNullDataView Qukan_initWithXib];
    if (imageName && imageName.length!=0) {
        UIImage *image = [UIImage imageNamed:imageName];
        v.contentImageView.image = [image imageWithColor:kThemeColor_Alpha(0.8)];
        v.contentImageView.userInteractionEnabled = YES;
    }
    if (content && content.length!=0) {
        v.contentLabel.text = content;
        v.contentLabel.textColor = kThemeColor;
    }
    [view addSubview:v];
    [v mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(view);
        make.top.mas_equalTo(top);
    }];
    
    return v;
}

+ (void)Qukan_hideWithView:(UIView *)view {
    
    for (UIView *v in view.subviews) {
        if ([v isKindOfClass:[QukanNullDataView class]]) {
            [v removeFromSuperview];
        }
    }
}
@end
