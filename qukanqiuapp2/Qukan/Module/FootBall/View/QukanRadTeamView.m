//
//  QukanRadTeamView.m
//  Qukan
//
//  Created by leo on 2019/9/2.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanRadTeamView.h"

@implementation QukanRadTeamView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    float x = rect.origin.x;
    float y = rect.origin.y;
    float w = rect.size.width;
    float h = rect.size.height;
    NSLog(@"%.2f,%.2f,%.2f, %.2f",x,y,w,h);
    
    // 一个不透明类型的Quartz 2D绘画环境,相当于一个画布,你可以在上面任意绘画
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 画笔线的颜色
    CGContextSetRGBStrokeColor(context,1,0,0,0);
    // 线的宽度
    CGContextSetLineWidth(context, 1.0);
    // 填充颜色
    UIColor *fullColor = kThemeColor;
    CGContextSetFillColorWithColor(context, fullColor.CGColor);
    // 绘制路径
    CGContextMoveToPoint(context,x,y);
    CGContextAddLineToPoint(context,w-10,y);
    CGContextAddLineToPoint(context,w,h);
    CGContextAddLineToPoint(context,x,h);
    CGContextAddLineToPoint(context,x,y);
    // 绘制路径加填充
    CGContextDrawPath(context, kCGPathFillStroke);
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setBackgroundColor:[UIColor clearColor]];
    [self setUserInteractionEnabled:NO];
}

@end
