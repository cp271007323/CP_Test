//
//  QukanSharpBgView.h
//  Qukan
//
//  Created by leo on 2019/12/26.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,QukanSharpBgViewType) {
    QukanSharpBgViewTypeRightBottom = 0,
    QukanSharpBgViewTypeLeftBottom,
    QukanSharpBgViewTypeRightTop,
    QukanSharpBgViewTypeLeftTop,
    QukanSharpBgViewTypeLeftBottomAndRightBottom,
    QukanSharpBgViewTypeLeftBottomAndRightTop,
};


NS_ASSUME_NONNULL_BEGIN

@interface QukanSharpBgView : UIView

/**类型*/
@property(nonatomic, assign) QukanSharpBgViewType   type;
/**角度偏移量*/
@property(nonatomic, assign) CGFloat   float_offset;
/**填充颜色*/
@property(nonatomic, strong) UIColor   *color_fullC;


/**
 初始化

 @param frame 范围- 一定要设置大于你需要切角的frame  否则无法正常显示
 @param type 设置尖角类型  可以自己加类型  目前只分了 以上五种我用到的
 @param offset 尖角的偏移量   越大越尖
 @param fullColor 填充背景色
 @return
 */
- (instancetype)initWithFrame:(CGRect)frame type:(QukanSharpBgViewType)type AndOffset:(CGFloat)offset andFullColor:(UIColor *)fullColor;

@end

NS_ASSUME_NONNULL_END
