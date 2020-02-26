//
//  QukanTeamScoreModel.h
//  Qukan
//
//  Created by Charlie on 2019/12/27.
//  Copyright © 2019 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*
 "flag": "http://zq.win007.com/Image/team/images/20180925152237.png",
 "haveTo": 89,
 "g": "巴塞罗那",
 "lose": 23,
 "sort": 1,
 "scene": 35,
 "negative": 0,
 "leagueId": 31,
 "flat": 9,
 "teamId": 84,
 "jifen": 87,
 "color": "#ffff00",
 "promotion": "争冠附加"
 "win": 26
 */

@interface QukanTeamScoreModel : NSObject

@property(nonatomic,strong) NSString* flag;
@property(nonatomic,strong) NSString* haveTo;
@property(nonatomic,strong) NSString* g;
@property(nonatomic,strong) NSString* lose;
@property(nonatomic,strong) NSString* sort;
@property(nonatomic,strong) NSString* scene;
@property(nonatomic,strong) NSString* negative;
@property(nonatomic,strong) NSString* leagueId;
@property(nonatomic,strong) NSString* flat;
@property(nonatomic,strong) NSString* teamId;
@property(nonatomic,strong) NSString* jifen;
@property(nonatomic,strong) NSString* color;
@property(nonatomic,strong) NSString* promotion;
@property(nonatomic,strong) NSString* win;

@property(nonatomic,strong) NSString* groupN;
@property(nonatomic,strong) NSString* groupX;



@property(nonatomic,strong) NSString* season;


@end

NS_ASSUME_NONNULL_END
