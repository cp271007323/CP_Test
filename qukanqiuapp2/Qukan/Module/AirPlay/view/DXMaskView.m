//
//  QukanAirPlayDeviceListView.m
//  dxMovie-ios
//
//  Created by james on 2019/6/4.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "DXMaskView.h"
#import "SDAutoLayout.h"

@interface DXMaskView()
@property (nonatomic,strong) UIView *containerView;
@property (nonatomic,assign) CGFloat containerHeight;


@end
@implementation DXMaskView
- (instancetype)initWithContainer:(UIView *)container containerHeight:(CGFloat)height
{
    self = [super init];
    if (self) {
        _containerView = container;
        _containerHeight = height;
        [self addSubview:_containerView];
        _containerView.sd_layout.leftSpaceToView(self, 0).rightSpaceToView(self, 0).bottomSpaceToView(self,-_containerHeight).heightIs(_containerHeight);
        [_containerView updateLayout];
        self.containerView.sd_layout.leftSpaceToView(self, 0).bottomSpaceToView(self, 0).rightSpaceToView(self, 0).heightIs(_containerHeight);
        [UIView animateWithDuration:0.2 animations:^{
            [self.containerView updateLayout];
        }];
        
        
    }
    return self;
}
+ (void)showWithContainer:(UIView *)container containerHeight:(CGFloat)height{
    DXMaskView *view = [[DXMaskView alloc] initWithContainer:container containerHeight:height];
    view.backgroundColor = [kCommonBlackColor colorWithAlphaComponent:0];
    UIWindow *window = UIApplication.sharedApplication.delegate.window;
    [window addSubview:view];
    view.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    [view updateLayout];
    [UIView animateWithDuration:0.2 animations:^{
       view.backgroundColor = [kCommonBlackColor colorWithAlphaComponent:0.5];
    }];
   
    
}
- (void)dismiss{
    UIView *container = nil;
    if ([self isMemberOfClass:DXMaskView.class]) {
        container = self.containerView;
        DXMaskView *aview = (DXMaskView *)container;
        [aview dismiss];
        return;
    }else{
        container = self;
    }
    
    container.sd_layout.bottomSpaceToView(container.superview,-container.height);
    [UIView animateWithDuration:0.2 animations:^{
       self.superview.backgroundColor = [kCommonBlackColor colorWithAlphaComponent:0];
        [container updateLayout];
    } completion:^(BOOL finished) {
        [container.superview removeFromSuperview];
    }]; 
}



- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismiss];
}

@end
