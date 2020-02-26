//
//  QukanBattlefieldReportViewController.h
//  Qukan
//
//  Created by Kody on 2019/12/26.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QukanMatchInfoModel.h"
#import "JXPagerListRefreshView.h"

NS_ASSUME_NONNULL_BEGIN

@interface QukanBattlefieldReportViewController : UIViewController <JXPagerViewListViewDelegate>

@property(nonatomic, strong) UINavigationController *navigation_vc;
@property (nonatomic, assign) NSInteger Qukan_matchId;
@property (nonatomic, strong) QukanMatchInfoContentModel *Qukan_model;
@property (nonatomic, copy) void(^battleReportVcBolck)(QukanHomeModels *model);
@property(nonatomic, copy) void (^cellCilckBolck)(QukanNewsModel *model);
@property (nonatomic, assign) NSInteger phpAdvId;

- (void)stopVideoPlayIfneed;

@end

NS_ASSUME_NONNULL_END
