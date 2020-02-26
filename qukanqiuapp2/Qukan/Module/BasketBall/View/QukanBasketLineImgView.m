//
//  QukanBasketLineImgView.m
//  Qukan
//
//  Created by leo on 2019/9/10.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanBasketLineImgView.h"


#define yellowC HEXColor(0xFFBA00)
#define redC HEXColor(0xE82716)

@interface QukanBasketLineImgView ()
@property (nonatomic, assign) CGFloat  xLength;  // x轴的长度
@property (nonatomic, assign) CGFloat  yLength;  // y轴的长度
@property (nonatomic, assign) CGFloat  perXLen ;  // x轴没格的长度
@property (nonatomic, assign) CGFloat  perYlen ;  // y轴没格的长度

@property (nonatomic,strong)  NSMutableArray * yellowDrawDataArr;  // 黄队的数据
@property (nonatomic,strong)  NSMutableArray * redDrawDataArr;  // 红队的数据

@property (nonatomic, assign)  CGFloat  maxValue ;
@property (nonatomic, assign)  CGFloat  maxYValue ;

@end

@implementation QukanBasketLineImgView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];//HEXColor(0x1c2249);
    }
    return self;
}


#pragma mark 开始绘图
-(void)showAnimation{
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    [self configChartXAndYLength];//xy 长度
    [self configChartOrigin]; //坐标原点
    [self configPerXAndPerY];//xy间隔
    [self configValueDataArray]; //将数据转换为点坐标
    
}


#pragma mark  绘制xy轴
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawXAndYLineWithContext:context];
    [self drawTeamName:context]; //将数据转换为点坐标
}


#pragma mark  获取 坐标原点
- (void)configChartOrigin{
    self.chartOrigin = CGPointMake(self.contentInsets.left, self.frame.size.height-self.contentInsets.bottom);
}

#pragma mark  获取 xy的长度
- (void)configChartXAndYLength{
    _xLength = CGRectGetWidth(self.frame)-self.contentInsets.left-self.contentInsets.right;
    _yLength = CGRectGetHeight(self.frame)-self.contentInsets.top-self.contentInsets.bottom;
}

#pragma mark 获取xy上的间隔
- (void)configPerXAndPerY{
    _perXLen = _xLength/(_xLineDataArr.count-1);
    _perYlen = _yLength/(_yLineDataArr.count-1);
}

#pragma mark  将坐标 转换为数据
//-(void)ponitToData:(CGPoint) p{
//    _maxYValue = [[_yLineDataArr valueForKeyPath:@"@max.floatValue"] floatValue];
//    
//    CGFloat x  =  p.x - self.contentInsets.left;
//    CGFloat y = p.y - self.contentInsets.bottom;
//    
//    CGFloat kDate;
//    CGFloat kmoe;
//    
//    kDate = (x / _xLength) * 24;
//    kmoe = _maxYValue - (y / _yLength) * _maxYValue;
//    
//    NSString *dataStr = [NSString stringWithFormat:@"%.0f:00", round(kDate)];
//    NSString *moeStr = [NSString stringWithFormat:@"%.2f", roundf(kmoe*100)/100];
//    if (self.didSelectPointBlock) {
//        self.didSelectPointBlock(dataStr, moeStr);
//    }
//}

#pragma mark  将数据 转换为坐标
- (void)configValueDataArray{
    
    _yellowDrawDataArr = [[NSMutableArray alloc] init];
    _redDrawDataArr = [[NSMutableArray alloc] init];
    CGFloat maxY = [_yLineDataArr.lastObject floatValue] ;
    CGFloat minY = [_yLineDataArr.firstObject floatValue];
    
    for (NSInteger i = 0; i< _yellowValueArr.count; i++) {
        
        CGPoint p = CGPointMake(i*_perXLen+self.chartOrigin.x,
                        self.contentInsets.top + _yLength - ([_yellowValueArr[i] floatValue] - minY) / (maxY - minY)  * _yLength);
        
        NSValue *value = [NSValue valueWithCGPoint:p];
        
        [_yellowDrawDataArr addObject:value];
    }
    
    for (NSInteger i = 0; i< _redValueArr.count; i++) {
        
        CGPoint p = CGPointMake(i*_perXLen+self.chartOrigin.x,
                                self.contentInsets.top + _yLength - ([_redValueArr[i] floatValue] - minY) / (maxY - minY)  * _yLength);
        
        NSValue *value = [NSValue valueWithCGPoint:p];
        
        [_redDrawDataArr addObject:value];
    }
    
    //开始画折线
    if (_yellowDrawDataArr.count > 0) {
        [self drawPathWithDataArr:_yellowDrawDataArr];
    }
    
    if (_redDrawDataArr.count > 0) {
        [self drawPathWithDataArr:_redDrawDataArr];
    }
    
}

- (void)drawTeamName:(CGContextRef)context {
    CGFloat redLen = [self sizeOfStringWithMaxSize:CGSizeMake(CGFLOAT_MAX, 30) textFont:10 aimString:self.str_redTeamName].width;
    [self drawRoundWithContext:context atPoint:CGPointMake(self.contentInsets.left + 5, 10 + 5) withColor:redC];
    [self drawText:self.str_redTeamName andContext:context atPoint:CGPointMake(self.contentInsets.left + 13, 9) WithColor:HEXColor(0x666666) andFontSize:10];
    [self drawRoundWithContext:context atPoint:CGPointMake(self.contentInsets.left + redLen + 30, 15) withColor:yellowC];
    [self drawText:self.str_yellowTeamName andContext:context atPoint:CGPointMake(self.contentInsets.left + redLen + 38, 9) WithColor:HEXColor(0x666666) andFontSize:10];
}

#pragma mark 开始画图
- (void)drawPathWithDataArr:(NSArray *)dataArr{
    UIBezierPath *firstPath = [UIBezierPath bezierPathWithOvalInRect:CGRectZero];
    UIBezierPath *secondPath = [UIBezierPath bezierPath];
    
    
    for (NSInteger i = 0; i<dataArr.count; i++) {
        NSValue *value = dataArr[i];
        CGPoint p = value.CGPointValue;
        if (i==0) {
            [secondPath moveToPoint:CGPointMake(p.x, self.chartOrigin.y)];
            [secondPath addLineToPoint:p];
            [firstPath moveToPoint:p];
        } else {
            [firstPath addLineToPoint:p];
            [secondPath addLineToPoint:p];
        }
        
        if (i==dataArr.count-1) {
            [secondPath addLineToPoint:CGPointMake(p.x, self.chartOrigin.y)];
        }
        
    }
    
    [secondPath closePath];
    //第二、UIBezierPath和CAShapeLayer关联
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = self.bounds;
    shapeLayer.path = firstPath.CGPath;
    
    UIColor *color = yellowC;
    if (dataArr == self.redDrawDataArr) {
        color = redC;

   }
    shapeLayer.strokeColor = color.CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 2;
    
    //第三，动画
    CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
    ani.fromValue = @0;
    ani.toValue = @1;
    ani.duration = 1.0;
    [shapeLayer addAnimation:ani forKey:NSStringFromSelector(@selector(strokeEnd))];
    [self.layer addSublayer:shapeLayer];
    
    @weakify(self)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(ani.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self);
        CAShapeLayer *shaperLay = [CAShapeLayer layer];
        shaperLay.frame = self.bounds;
        shaperLay.path = secondPath.CGPath;
        shaperLay.fillColor = UIColor.blueColor.CGColor;
        shaperLay.strokeColor = UIColor.grayColor.CGColor;
        [self.layer addSublayer:shaperLay];
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = self.bounds;
        
        if (dataArr == self.yellowDrawDataArr) {
            gradientLayer.colors = @[(__bridge id)COLOR_HEX(0xFFBA00, 0.3).CGColor,
                                     (__bridge id)COLOR_HEX(0xFFBA00, 0.25).CGColor,
                                     (__bridge id)COLOR_HEX(0xFFBA00, 0.2).CGColor,
                                     (__bridge id)COLOR_HEX(0xFFBA00, 0.15).CGColor,
                                     (__bridge id)COLOR_HEX(0xFFBA00, 0.1).CGColor,
                                     (__bridge id)COLOR_HEX(0xFFBA00, 0.05).CGColor,
                                     ];
        }else {
            gradientLayer.colors = @[(__bridge id)COLOR_HEX(0xE82716, 0.3).CGColor,
                                     (__bridge id)COLOR_HEX(0xE82716, 0.25).CGColor,
                                     (__bridge id)COLOR_HEX(0xE82716, 0.2).CGColor,
                                     (__bridge id)COLOR_HEX(0xE82716, 0.15).CGColor,
                                     (__bridge id)COLOR_HEX(0xE82716, 0.1).CGColor,
                                     (__bridge id)COLOR_HEX(0xE82716, 0.05).CGColor,
                                     ];

        }
        
        gradientLayer.startPoint = CGPointMake(0,1);
        gradientLayer.endPoint = CGPointMake(1,1);
        
        [self.layer addSublayer:gradientLayer];
        
        gradientLayer.mask = shaperLay;
    });
    
    // 第四  画小圆点
    for (NSInteger i = 0; i<dataArr.count; i++) {
        
        NSValue *value = dataArr[i];
        CGPoint p = value.CGPointValue;
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        CAShapeLayer *pointLayer = [CAShapeLayer layer];
        [path addArcWithCenter:CGPointMake(p.x, p.y) radius:3.5 startAngle:0.0 endAngle:180.0 clockwise:YES];
        pointLayer.path = path.CGPath;
        pointLayer = [CAShapeLayer layer];
        pointLayer.path = path.CGPath;
        if (dataArr == self.yellowDrawDataArr) {
            pointLayer.strokeColor = yellowC.CGColor;
        }else {
            pointLayer.strokeColor = redC.CGColor;
        }
        pointLayer.lineWidth = 2;
        pointLayer.fillColor = [UIColor whiteColor].CGColor;
        [self.layer addSublayer:pointLayer];
    }
}

#pragma mark  绘制xy轴 方法
- (void)drawXAndYLineWithContext:(CGContextRef)context{
    
    //x 轴
//    [self drawLineWithContext:context andStarPoint:self.chartOrigin andEndPoint:CGPointMake(self.contentInsets.left +_xLength, self.chartOrigin.y) andIsDottedLine:NO andColor:HEXColor(0xEEEEEE)];
//
    if (_showYLine) {
        //Y轴
        [self drawLineWithContext:context andStarPoint:self.chartOrigin andEndPoint:CGPointMake(self.chartOrigin.x,self.chartOrigin.y-_yLength) andIsDottedLine:NO andColor:HEXColor(0xEEEEEE)];
    }
    
    if (_xLineDataArr.count>0) {
        CGFloat xPace = _perXLen;
        
        for (NSInteger i = 0; i<_xLineDataArr.count;i++ ) {
            CGPoint p = CGPointMake(i*xPace+self.chartOrigin.x, self.chartOrigin.y);
//            CGFloat len = [self sizeOfStringWithMaxSize:CGSizeMake(CGFLOAT_MAX, 30) textFont:10 aimString:_xLineDataArr[i]].width;
//            [self drawText:[NSString stringWithFormat:@"%@",_xLineDataArr[i]] andContext:context atPoint:CGPointMake(p.x-len/2, p.y+2) WithColor:HEXColor(0xEEEEEE) andFontSize:10];
//
            [self drawLineWithContext:context andStarPoint:p andEndPoint:CGPointMake(p.x,self.contentInsets.top) andIsDottedLine:NO andColor:HEXColor(0xeeeeee)];
            
        }
        
    }
    
    if (_yLineDataArr.count>0) {
        CGFloat yPace = _perYlen;
        for (NSInteger i = 0; i<_yLineDataArr.count; i++) {
            CGPoint p = CGPointMake(self.chartOrigin.x, self.chartOrigin.y - i*yPace);
            
            CGFloat hei = [self sizeOfStringWithMaxSize:CGSizeMake(CGFLOAT_MAX, 30) textFont:10 aimString:_yLineDataArr[i]].height;
            
            if (_showYLevelLine) {
                [self drawLineWithContext:context andStarPoint:p andEndPoint:CGPointMake(self.contentInsets.left+_xLength, p.y) andIsDottedLine:NO andColor:HEXColor(0xeeeeee)];
            }else{
                [self drawLineWithContext:context andStarPoint:p andEndPoint:CGPointMake(p.x+3, p.y) andIsDottedLine:NO andColor:kCommonBlackColor];
            }
            
            [self drawText:[NSString stringWithFormat:@"%@",_yLineDataArr[i]] andContext:context atPoint:CGPointMake(self.size.width - self.contentInsets.right + 5, p.y - hei / 2) WithColor:kTextGrayColor andFontSize:10];
        }
    }
    
    
}

#pragma mark 返回字符串尺寸
- (CGSize)sizeOfStringWithMaxSize:(CGSize)maxSize textFont:(CGFloat)fontSize aimString:(NSString *)aimString{
    return [[NSString stringWithFormat:@"%@",aimString] boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    
}



// 绘制线段
- (void)drawLineWithContext:(CGContextRef )context andStarPoint:(CGPoint )start andEndPoint:(CGPoint)end andIsDottedLine:(BOOL)isDotted andColor:(UIColor *)color{
    // 移动到点
    CGContextMoveToPoint(context, start.x, start.y);
    // 划线
    CGContextAddLineToPoint(context, end.x, end.y);
    CGContextSetLineWidth(context, 0.5);
    [color setStroke];
    if (isDotted) {
        CGFloat ss[] = {1.5,2};
        
        CGContextSetLineDash(context, 0, ss, 2);
        
    } else {
        CGFloat ss[] = {1.5,0};
        
        CGContextSetLineDash(context, 0, ss, 2);
        
    }
    CGContextMoveToPoint(context, end.x, end.y);
    
    CGContextDrawPath(context, kCGPathFillStroke);
}

// 绘制文字
- (void)drawText:(NSString *)text andContext:(CGContextRef )context atPoint:(CGPoint )rect WithColor:(UIColor *)color andFontSize:(CGFloat)fontSize{
    [[NSString stringWithFormat:@"%@",text] drawAtPoint:rect withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSForegroundColorAttributeName:color}];
    [color setFill];
    CGContextDrawPath(context, kCGPathFill);
}

// 画两个小圆
- (void)drawRoundWithContext:(CGContextRef)context atPoint:(CGPoint)rect withColor:(UIColor *)color{
    CGContextAddArc(context, rect.x, rect.y, 5, 0, 2 *M_PI, 0);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextDrawPath(context, kCGPathFill);//绘制填充
}

@end
