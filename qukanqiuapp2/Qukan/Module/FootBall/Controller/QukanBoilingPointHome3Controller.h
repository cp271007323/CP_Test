//
//  QukanBoilingPointHome3Controller.h
//  Qukan
//
//  Created by mac on 2018/11/30.
//  Copyright © 2018 Ningbo Suda. All rights reserved.
//  赛事页面

#import "QukanViewController.h"


NS_ASSUME_NONNULL_BEGIN
@interface QukanBoilingPointHome3Controller : UIViewController<JXCategoryListContentViewDelegate>

// 父控制器的导航控制器
@property(nonatomic, strong)UINavigationController *navgationVC;
// 父控制器
@property(nonatomic, strong)UIViewController *prentVC;


- (void)reloadSelf;
@end

NS_ASSUME_NONNULL_END
