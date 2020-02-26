//
//  QukanBasketBallHomeController.h
//  Qukan
//
//  Created by hello on 2019/9/3.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanBasketBallHomeController : UIViewController<JXCategoryListContentViewDelegate>

@property(nonatomic, strong)UIViewController *prentVC;
@property(nonatomic, strong)UINavigationController *navgationVC;


- (void)refreshListVC;
@end

NS_ASSUME_NONNULL_END
