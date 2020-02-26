#import "QukanViewController.h"



@interface QukanImmediateViewController : QukanViewController<JXCategoryListContentViewDelegate>

/**父视图的导航栏*/
@property(nonatomic, weak) UINavigationController *navController;
/**列表筛选的id*/
@property (nonatomic, strong) NSString *Qukan_leagueIds;


/**筛选刷新界面*/
- (void)resetLegueidsWithLegueids:(NSString *)legueids;

@end
