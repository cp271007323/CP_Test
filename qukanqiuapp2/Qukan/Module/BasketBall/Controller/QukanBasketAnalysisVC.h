//
//  QukanBasketAnalysisVC.h
//  Qukan
//
//  Created by leo on 2019/9/3.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanViewController.h"

#import "QukanBasketBallMatchDetailModel.h"
@class QukanHomeModels;

NS_ASSUME_NONNULL_BEGIN



@interface QukanBasketAnalysisVC : UIViewController <JXPagerViewListViewDelegate>

@property(nonatomic, copy) NSString   *matchId;
@property (nonatomic, copy) void(^analysisVc_didBolck)(QukanHomeModels *model);
@property(nonatomic, strong) UINavigationController *navgation_vc;

- (void)setData;
@end

NS_ASSUME_NONNULL_END
