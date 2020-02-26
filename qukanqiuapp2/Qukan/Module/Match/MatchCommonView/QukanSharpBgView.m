//
//  QukanSharpBgView.m
//  Qukan
//
//  Created by leo on 2019/12/26.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanSharpBgView.h"


@interface QukanSharpBgView ()


@end

@implementation QukanSharpBgView

- (instancetype)initWithFrame:(CGRect)frame type:(QukanSharpBgViewType)type AndOffset:(CGFloat)offset andFullColor:(nonnull UIColor *)fullColor{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.clearColor;
        
        _type = type;
        _float_offset = offset;
        _color_fullC = fullColor;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    float x = rect.origin.x;
    float y = rect.origin.y;
    float w = rect.size.width;
    float h = rect.size.height;
    NSLog(@"%.2f,%.2f,%.2f, %.2f",x,y,w,h);
    
    float x1 = x;
    float y1 = y;
    float x2 = w;
    float y2 = y;
    float x3 = w;
    float y3 = h;
    float x4 = x;
    float y4 = h;
    
    
    if (self.type == QukanSharpBgViewTypeLeftBottom || self.type == QukanSharpBgViewTypeLeftBottomAndRightBottom || self.type == QukanSharpBgViewTypeLeftBottomAndRightTop) {
        x1 = x + self.float_offset;
    }
       
   if (self.type == QukanSharpBgViewTypeRightBottom || self.type == QukanSharpBgViewTypeLeftBottomAndRightBottom) {
       x2 = w - self.float_offset;
    }
    
    
    if (self.type == QukanSharpBgViewTypeLeftTop ) {
        x4 = x + self.float_offset;
    }
    
    if (self.type == QukanSharpBgViewTypeRightTop || self.type == QukanSharpBgViewTypeLeftBottomAndRightTop) {
        x3 = w - self.float_offset;
    }
    
   
    
    
    // 获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 画笔线的颜色
    CGContextSetRGBStrokeColor(context,1,0,0,0);
    // 线的宽度
    CGContextSetLineWidth(context, 1.0);
    // 填充颜色
    UIColor *fullColor = self.color_fullC;
    CGContextSetFillColorWithColor(context, fullColor.CGColor);

    // 绘制路径
    CGContextMoveToPoint(context,x1,y1);
    CGContextAddLineToPoint(context,x2,y2);
    CGContextAddLineToPoint(context,x3,y3);
    CGContextAddLineToPoint(context,x4,y4);
    CGContextAddLineToPoint(context,x1,y1);
    
    // 绘制路径加填充
    CGContextDrawPath(context, kCGPathFillStroke);
    
}


- (void)setFloat_offset:(CGFloat)float_offset {
    _float_offset = float_offset;
    [self setNeedsDisplay];
}

- (void)setColor_fullC:(UIColor *)color_fullC {
    _color_fullC = color_fullC;
    [self setNeedsDisplay];
}


- (void)setType:(QukanSharpBgViewType)type {
    _type = type;
    [self setNeedsDisplay];
}

@end
