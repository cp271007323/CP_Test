//
//  QukanTextLiveVC.h
//  Qukan
//
//  Created by leo on 2019/12/18.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QukanBasketBallMatchModel;
NS_ASSUME_NONNULL_BEGIN

@interface QukanTextLiveVC : UIViewController<JXPagerViewListViewDelegate>

/**比赛主模型*/
@property(nonatomic, strong) QukanBasketBallMatchModel *model_main;
@property(nonatomic, copy) NSString *matchId;


@end

NS_ASSUME_NONNULL_END
