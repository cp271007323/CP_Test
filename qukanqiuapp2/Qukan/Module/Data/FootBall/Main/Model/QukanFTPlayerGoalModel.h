//
//  QukanFTPlayerGoalModel.h
//  Qukan
//
//  Created by Charlie on 2019/12/29.
//  Copyright © 2019 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/*
 "teamName": "塔勒瑞斯",
 "playerName": "",
 "teamId": 5113,
 "photo": "",
 "playerId": 152389,
 "goals": 8
 */

@interface QukanFTPlayerGoalModel : NSObject


@property(nonatomic,strong) NSString* teamName;
@property(nonatomic,strong) NSString* playerName;
@property(nonatomic,strong) NSString* teamId;
@property(nonatomic,strong) NSString* photo;
@property(nonatomic,strong) NSString* playerId;
@property(nonatomic,strong) NSString* leagueId;
@property(nonatomic,assign) NSInteger goals;

@property(nonatomic,strong) NSString* season;


@end

NS_ASSUME_NONNULL_END
