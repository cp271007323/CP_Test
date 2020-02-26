//
//  QukanFTAnalysisHomeVC.h
//  Qukan
//
//  Created by Charlie on 2019/12/25.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanFTAnalysisHomeVC : UIViewController<JXCategoryListContentViewDelegate>

// 父控制器的导航控制器
@property(nonatomic, strong)UINavigationController *navgationVC;

- (void)hideFilterView;
@end

NS_ASSUME_NONNULL_END
