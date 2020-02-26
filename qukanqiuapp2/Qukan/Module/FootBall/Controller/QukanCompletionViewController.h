#import "QukanViewController.h"
#import <JXCategoryView/JXCategoryListContainerView.h>

@interface QukanCompletionViewController : QukanViewController<JXCategoryListContentViewDelegate>

/**筛选列表的id*/
@property (nonatomic, strong) NSString *Qukan_leagueIds;
/**当前选中的日期*/
@property (nonatomic, assign) NSInteger Qukan_fixDays;
/**父视图的导航控制器*/
@property(nonatomic, weak) UINavigationController *navController;




- (void)resetLegueidsWithLegueids:(NSString *)legueids;

@end
