//
//  QukanDataBSKViewController.h
//  Qukan
//
//  Created by blank on 2019/12/25.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanDataBSKViewController : UIViewController<JXCategoryListContentViewDelegate>

// 父控制器的导航控制器
@property(nonatomic, strong)UINavigationController *navgationVC;

- (void)hideFilterView:(BOOL)hidden;
@property (nonatomic, strong)UIView *navTop;
@property (nonatomic, strong)UIScrollView *scrollView;
- (void)QukanLoadLeagues;
@end

NS_ASSUME_NONNULL_END
