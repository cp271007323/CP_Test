
#import "QukanHotViewController.h"
#import <JXCategoryView/JXCategoryListContainerView.h>
NS_ASSUME_NONNULL_BEGIN

@interface QukanHotViewController : QukanViewController<JXCategoryListContentViewDelegate>

// 父控制器的导航控制器  用于跳转
@property(nonatomic, weak) UINavigationController *navController;

/**是否需要重新定位*/
@property(nonatomic, assign) BOOL   shouldRelocation;
@end

NS_ASSUME_NONNULL_END

