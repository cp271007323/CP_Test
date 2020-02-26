//
//  QukanMatchDetailHistoryModel.h
//  Qukan
//
//  Created by leo on 2020/1/1.
//  Copyright © 2020 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanMatchDetailHistoryModel : NSObject
/**<#说明#>*/
@property(nonatomic, copy) NSString   * Id;

@property (nonatomic ,copy)   NSString *awayId;
@property (nonatomic ,assign)   NSInteger homeId;
@property (nonatomic, assign) NSInteger matchId;

@property (nonatomic, copy) NSString *leagueName;


@property (nonatomic, assign) NSInteger bc1;
@property (nonatomic, assign) NSInteger bc2;

@property (nonatomic, copy) NSString *homeName;
@property (nonatomic, copy) NSString *awayName;

@property (nonatomic, assign) NSInteger homeScore;
@property (nonatomic, assign) NSInteger awayScore;

@property (nonatomic, copy) NSString *startTime;

/**<#说明#>*/
@property(nonatomic, assign) BOOL   selectTeamIsHomeTeam;


/**主队胜利状态  1：赢 2：输 3：平*/
@property(nonatomic, assign) NSInteger  winState;
/**联赛id*/
@property(nonatomic, copy) NSString   * leagueId;

/**type    int    1历史交战记录 2主队近期交战记录，3客队近期交战记录*/
@property(nonatomic, assign) NSInteger type;
@end

NS_ASSUME_NONNULL_END
