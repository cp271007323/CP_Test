//
//  QukanCustomTabbar.m
//  Qukan
//
//  Created by leo on 2020/1/9.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanCustomTabbar.h"
#import "QukanCustomTabbarItem.h"

@interface QukanCustomTabbar ()

/**所有的子item数组*/
@property(nonatomic, strong) NSMutableArray <QukanCustomTabbarItem *>   * QukanSubItems_arr;

/**顶部线条*/
@property(nonatomic, strong) UIView   * QukanLine_view;

/**之前选中的下标*/
@property(nonatomic, assign) NSInteger    QukanBeforSelectIndex_int;

@end

@implementation QukanCustomTabbar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        
        
        [self initUI];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self layoutItems];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark ===================== UI ==================================

- (void)initUI {
    [self addSubview:self.QukanLine_view];
    [self.QukanLine_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self).offset(-0.5);
        make.height.equalTo(@(0.5));
    }];
    
    
    // 隐藏系统的tabbar
    [self hiddenUITabBarButton];
}



// 隐藏系统的tabar
- (void)hiddenUITabBarButton{
    if ([self.superview isKindOfClass:[UITabBar class]]) {
        UITabBar *tabbar = (UITabBar *)self.superview;
        dispatch_queue_t queue  = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), queue, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                for (UIView *btn in tabbar.subviews) {
                    if ([btn isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
                        btn.hidden = YES;
                    }
                }
                [self.superview bringSubviewToFront:self]; // 放置到最前
            });
        });
    }
}

#pragma mark ===================== action ==================================

- (void)itemClick:(QukanCustomTabbarItem *)item {
    self.QukanBeforSelectIndex_int = self.selectIndex;
    self.selectIndex = item.QukanIndex_int;
    
    [self performSelector:@selector(itemOneClick:) withObject:item afterDelay:0.3];
}

- (void)itemOneClick:(QukanCustomTabbarItem *)item {
    if (self.QukanBeforSelectIndex_int == item.QukanIndex_int) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(QukanCustomTabbar:selectIndexAgain:)]) {
            [self.delegate QukanCustomTabbar:self selectIndexAgain:_selectIndex];
        }
    }
}

- (void)itemClickDoubel:(QukanCustomTabbarItem *)item {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(itemOneClick:) object:item];
    
     if (self.selectIndex != item.QukanIndex_int) {  // 若不是未选中的item  直接return掉
         return;
     }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(QukanCustomTabbar:selectIndexDouble:)]) {
        [self.delegate QukanCustomTabbar:self selectIndexDouble:item.QukanIndex_int];
    }
    
}

#pragma mark ===================== setter ==================================
- (void)setSelectIndex:(NSInteger)selectIndex {
    if (_selectIndex == selectIndex) {
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(QukanCustomTabbar:selectIndex:)]) {
        [self.delegate QukanCustomTabbar:self selectIndex:selectIndex];
    }
    
    _selectIndex = selectIndex;
    for (QukanCustomTabbarItem *item in self.QukanSubItems_arr) {
        item.QukanIsSelect_bool = (item.QukanIndex_int == _selectIndex);
    }
}

// 设置items
- (void)setTabBarItems:(NSArray<QukanCustomTabItemModel *> * _Nonnull)tabBarItems {
    _tabBarItems = tabBarItems;
    
    for (QukanCustomTabItemModel *itemModel in tabBarItems) {
        QukanCustomTabbarItem *item = [[QukanCustomTabbarItem alloc] initWithFrame:CGRectZero andTabModel:itemModel]; // 模型转成实例
        
        item.QukanIndex_int = [tabBarItems indexOfObject:itemModel]; // 交付索引
        item.tag = 10086 + item.QukanIndex_int; // 区分Tag
        [item addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchDown];
        [item addTarget:self action:@selector(itemClickDoubel:) forControlEvents:UIControlEventTouchDownRepeat];
        
        item.QukanIsSelect_bool = item.QukanIndex_int == 0;
        [self addSubview:item];
        [self.QukanSubItems_arr addObject:item];
    }
}


- (void)layoutItems {
    CGFloat itemW = kScreenWidth / self.QukanSubItems_arr.count;
    CGFloat itemH = kBottomBarHeight - kSafeAreaBottomHeight;
    for (int i = 0; i < self.QukanSubItems_arr.count; i ++) {
        QukanCustomTabbarItem *item = self.QukanSubItems_arr[i];
        item.frame = CGRectMake(itemW * i, 0, itemW, itemH);
    }
}



#pragma mark ===================== lazy ==================================
- (NSMutableArray<QukanCustomTabbarItem *> *)QukanSubItems_arr {
    if (!_QukanSubItems_arr) {
        _QukanSubItems_arr = [NSMutableArray new];
    }
    return _QukanSubItems_arr;
}


- (UIView *)QukanLine_view {
    if (!_QukanLine_view) {
        _QukanLine_view = [UIView new];
        _QukanLine_view.backgroundColor = kCommonWhiteColor;
        _QukanLine_view.layer.shadowColor = kCommonBlackColor.CGColor;
        _QukanLine_view.layer.shadowOpacity = 0.5f;
        _QukanLine_view.layer.shadowRadius = 4.f;
        _QukanLine_view.layer.shadowOffset = CGSizeMake(0,-3);
    }
    return _QukanLine_view;
}
                


@end
