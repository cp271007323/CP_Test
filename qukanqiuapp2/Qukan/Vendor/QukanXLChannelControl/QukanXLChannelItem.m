//
//  QukanXLChannelItem.m
//  QukanXLChannelControlDemo
//
//  Created by MengXianLiang on 2017/3/3.
//  Copyright © 2017年 MengXianLiang. All rights reserved.
//

#import "QukanXLChannelItem.h"

@interface QukanXLChannelItem ()

@property (nonatomic, strong) UILabel *textLabel;
@property(nonatomic, strong) UIImageView *imgView;
@property(nonatomic, strong) UIButton *addOrLessenButton;

@property (nonatomic, strong) CAShapeLayer *borderLayer;

@end

@implementation QukanXLChannelItem

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

-(void)initUI
{
    self.userInteractionEnabled = true;
//    self.layer.cornerRadius = 13.0f;
//    self.layer.borderWidth = 1.0f;
//    self.layer.borderColor = HEXColor(0xeeeeee).CGColor;
    self.backgroundColor = [self backgroundColor];
    self.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.bounds];
    _imgView = imgView;
    imgView.layer.cornerRadius = 6.0f;
    imgView.layer.borderWidth = 1.0f;
    imgView.layer.borderColor = HEXColor(0xeeeeee).CGColor;
    imgView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:imgView];

    self.textLabel = [UILabel new];
    self.textLabel.frame = self.bounds;
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.textColor = [self textColor];
    self.textLabel.adjustsFontSizeToFitWidth = true;
    self.textLabel.userInteractionEnabled = true;
    self.textLabel.font = kFont12;
    self.textLabel.textColor = kTextGrayColor;
    [self.contentView addSubview:self.textLabel];
    
    self.addOrLessenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addOrLessenButton.alpha = 1.0;
    self.addOrLessenButton.frame = CGRectMake(67, -8, 20, 20);
    self.addOrLessenButton.userInteractionEnabled = NO;
//    [self.addOrLessenButton setImage:kImageNamed(@"Qukan_less") forState:UIControlStateNormal];
    [self.contentView addSubview:self.addOrLessenButton];
    
    [self addBorderLayer];
}

- (void)setBottomPart:(BOOL)bottomPart {
    _bottomPart = bottomPart;
    
//    UIImage *image = bottomPart ? kImageNamed(@"Qukan_add") : kImageNamed(@"Qukan_less");
//    [self.addOrLessenButton setImage:image forState:UIControlStateNormal];
}

-(void)addBorderLayer{
    self.borderLayer = [CAShapeLayer layer];
    self.borderLayer.bounds = self.bounds;
    self.borderLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    self.borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.borderLayer.bounds cornerRadius:self.imgView.layer.cornerRadius].CGPath;
    self.borderLayer.lineWidth = 1;
    self.borderLayer.lineDashPattern = @[@5, @3];
    self.borderLayer.fillColor = [UIColor clearColor].CGColor;
    self.borderLayer.strokeColor = [self backgroundColor].CGColor;
    [self.imgView.layer addSublayer:self.borderLayer];
    self.borderLayer.hidden = true;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.frame = self.bounds;
    self.imgView.frame = self.bounds;
}

#pragma mark -
#pragma mark 配置方法

-(UIColor*)backgroundColor{
    return [UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1];
}

-(UIColor*)textColor{
    return [UIColor colorWithRed:40/255.0f green:40/255.0f blue:40/255.0f alpha:1];
}

-(UIColor*)lightTextColor{
    return [UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1];
}

#pragma mark -
#pragma mark Setter

-(void)setTitle:(NSString *)title
{
    _title = title;
    self.textLabel.text = title;
}

-(void)setIsMoving:(BOOL)isMoving
{
    _isMoving = isMoving;
    if (_isMoving) {
        self.backgroundColor = [UIColor clearColor];
        self.borderLayer.hidden = false;
    }else{
        self.backgroundColor = [UIColor clearColor];
        self.borderLayer.hidden = true;
    }
}

-(void)setIsFixed:(BOOL)isFixed{
    _isFixed = isFixed;
    _addOrLessenButton.hidden = isFixed;
    if (isFixed) {
        self.textLabel.textColor = [self lightTextColor];
    }else{
        self.textLabel.textColor = [self textColor];
    }
}

@end
