//
//  QukanCustomTabbar.h
//  Qukan
//
//  Created by leo on 2020/1/9.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QukanCustomTabItemModel.h"

@class QukanCustomTabbar;

@protocol QukanCustomTabbarDelegate <NSObject>

// 单次选中某个下标
- (void)QukanCustomTabbar:(QukanCustomTabbar *_Nullable)tabbar selectIndex:(NSInteger)index;
// 已经在此下标了 再次选中该下标
- (void)QukanCustomTabbar:(QukanCustomTabbar *_Nullable)tabbar selectIndexAgain:(NSInteger)index;
// 双击该下标
- (void)QukanCustomTabbar:(QukanCustomTabbar *_Nullable)tabbar selectIndexDouble:(NSInteger)index;


@end

NS_ASSUME_NONNULL_BEGIN

@interface QukanCustomTabbar : UIView

// 当前选中的 TabBar下标
@property (nonatomic, assign) NSInteger selectIndex;

// TabbarItems集合  必须设置
@property (nonatomic, strong) NSArray <QukanCustomTabItemModel *> *tabBarItems;

// 代理
@property (nonatomic, weak) id <QukanCustomTabbarDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
