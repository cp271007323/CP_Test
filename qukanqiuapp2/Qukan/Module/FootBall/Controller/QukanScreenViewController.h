// 筛选主控制器
#import <UIKit/UIKit.h>

@interface QukanScreenViewController : UIViewController

/**筛选列表的类型 1.即时  2.赛果 3.赛程*/
@property(nonatomic,assign)NSInteger Qukan_type;
/**筛选的联赛id*/
@property(nonatomic,copy)NSString *Qukan_leagueIds;
/**选中的日期*/
@property(nonatomic,assign)NSInteger Qukan_fixDays;
/**是否全部选中*/
@property(nonatomic,assign)BOOL Qukan_all;

/**选择完成回调*/
@property(nonatomic, copy) void(^chooseFinishblock)(NSString *slectId, NSInteger type);

@end
