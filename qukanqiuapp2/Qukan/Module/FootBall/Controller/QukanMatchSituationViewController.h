#import "QukanViewController.h"
#import "QukanMatchInfoModel.h"
#import "JXPagerListRefreshView.h"

@class QukanHomeModels;
@interface QukanMatchSituationViewController : QukanViewController<JXPagerViewListViewDelegate>
@property (nonatomic, assign) NSInteger Qukan_matchId;
@property (nonatomic, strong) QukanMatchInfoContentModel *Qukan_model;
@property (nonatomic, copy) void(^matchSituationVcBolck)(QukanHomeModels *model);
@property(nonatomic, copy) void (^refreshEndBolck)(void);
@property (nonatomic, assign) NSInteger phpAdvId;

- (void)Qukan_refreshData;

@end
