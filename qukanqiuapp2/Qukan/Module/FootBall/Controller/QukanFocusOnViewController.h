#import "QukanViewController.h"
#import <JXCategoryView/JXCategoryListContainerView.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanFocusOnViewController : QukanViewController<JXCategoryListContentViewDelegate>


// 父视图的导航控制器  用于跳转
@property(nonatomic, weak) UINavigationController *navController;

@end

NS_ASSUME_NONNULL_END

