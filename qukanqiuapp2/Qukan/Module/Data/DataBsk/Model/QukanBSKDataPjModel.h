//
//  QukanBSKDataPjModel.h
//  Qukan
//
//  Created by blank on 2019/12/29.
//  Copyright © 2019 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanBSKDataPjModel : NSObject
@property (nonatomic, copy)NSString *sclassId;
@property (nonatomic, copy)NSString *league;

@property (nonatomic, copy)NSString *teamId;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *matchSeason;

@property (nonatomic, copy)NSString *homeWin;
@property (nonatomic, copy)NSString *homeLoss;
@property (nonatomic, copy)NSString *awayWin;

@property (nonatomic, copy)NSString *awayLoss;
@property (nonatomic, copy)NSString *winScale;
@property (nonatomic, copy)NSString *state;

@property (nonatomic, copy)NSString *homeOrder;
@property (nonatomic, copy)NSString *awayOrder;
@property (nonatomic, copy)NSString *totalOrder;

@property (nonatomic, copy)NSString *homeScore;
@property (nonatomic, copy)NSString *homeLossScore;
@property (nonatomic, copy)NSString *awayScore;

@property (nonatomic, copy)NSString *awayLossScore;
@property (nonatomic, copy)NSString *near10Win;
@property (nonatomic, copy)NSString *near10Loss;

@property (nonatomic, copy)NSString *logo;
@end


NS_ASSUME_NONNULL_END
