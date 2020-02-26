//
//  QukanBoilingPointChildVC.h
//  Qukan
//
//  Created by leo on 2019/10/3.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, boilingPointListType) {
    boilingPointListTypeRecommended = 0,   //推荐
    boilingPointListTypeDynamic,   // 动态
};

NS_ASSUME_NONNULL_BEGIN

@interface QukanBoilingPointListVC : UIViewController <JXCategoryListContainerViewDelegate>

/**控制器的类型  0 推荐  1 动态*/
@property(nonatomic, assign) boilingPointListType   type_vcList;

/**控制器的父视图导航控制器  用于跳转*/
@property(nonatomic, strong) UINavigationController   * nav_superVC;

@end

NS_ASSUME_NONNULL_END
