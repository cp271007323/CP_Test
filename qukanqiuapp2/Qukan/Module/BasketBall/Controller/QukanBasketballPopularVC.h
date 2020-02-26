//
//  QukanBasketballPopularVC.h
//  Qukan
//
//  Created by hello on 2019/9/4.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface QukanBasketballPopularVC : UIViewController<JXCategoryListContentViewDelegate>

// 设置跳转导航栏
@property(nonatomic, weak) UINavigationController *navController;

/**是否需要重新定位*/
@property(nonatomic, assign) BOOL   shouldRelocation;
@end

NS_ASSUME_NONNULL_END
