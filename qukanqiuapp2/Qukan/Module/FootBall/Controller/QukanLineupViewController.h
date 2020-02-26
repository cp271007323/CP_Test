#import "QukanViewController.h"
#import "QukanMatchInfoModel.h"

@class QukanHomeModels;
@interface QukanLineupViewController : QukanViewController<JXPagerViewListViewDelegate>
@property (nonatomic, assign) NSInteger Qukan_matchId;
@property (nonatomic, strong) QukanMatchInfoContentModel *Qukan_model;
@property (nonatomic, copy) void(^lineUpVcBolck)(QukanHomeModels *model);
@end
