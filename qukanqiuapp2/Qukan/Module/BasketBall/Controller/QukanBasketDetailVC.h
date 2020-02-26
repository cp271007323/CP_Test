//
//  QukanBasketDetailVC.h
//  Qukan
//
//  Created by leo on 2019/9/3.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanViewController.h"


@class QukanBasketBallMatchModel;

@class QukanBasketBallMatchDetailModel;
NS_ASSUME_NONNULL_BEGIN

@interface QukanBasketDetailVC : QukanViewController

@property(nonatomic, strong, readonly) QukanBasketBallMatchDetailModel *detailModel;

@property (nonatomic, strong) QukanBasketBallMatchModel  *Qukan_model;
@property (nonatomic, strong) NSString *matchId;

@end

NS_ASSUME_NONNULL_END
