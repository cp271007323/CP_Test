//
//  QukanBasketDetailDataModel.h
//  Qukan
//
//  Created by leo on 2020/1/5.
//  Copyright © 2020 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanBasketDetailChangjunData : NSObject

/**球队id*/
@property(nonatomic, assign) NSInteger    teamId;

/**球队全称*/
@property(nonatomic, copy) NSString   * gb;
/**球队简称*/
@property(nonatomic, copy) NSString   * xshort;
/**球队logo*/
@property(nonatomic, copy) NSString   * logo;


/**场均篮板*/
@property(nonatomic, copy) NSString   * rebound;
/**场均助攻*/
@property(nonatomic, copy) NSString   * helpAttack;
/**场均抢断*/
@property(nonatomic, copy) NSString   * rob;
/**场均盖帽*/
@property(nonatomic, copy) NSString   * cover;
/**场均得分*/
@property(nonatomic, copy) NSString   * score;

/**投篮命中率*/
@property(nonatomic, copy) NSString   * shootScale;
/**3分球命中率*/
@property(nonatomic, copy) NSString   * threeminScale;
/**罚球命中率*/
@property(nonatomic, copy) NSString   * punishballScale;

@end


@interface QukanBasketDetailSaijiData : NSObject

/**球队id*/
@property(nonatomic, assign) NSInteger    teamId;
/**比赛分区id（见备注附图-2）*/
@property(nonatomic, assign) NSInteger    location;
/**球队ID分区排名*/
@property(nonatomic, assign) NSInteger    totalOrder;
/**胜率*/
@property(nonatomic, copy) NSString    *winScale;
/**连胜状态（正连胜负连输）*/
@property(nonatomic, assign) NSInteger    state;


/**近10场赢得场数*/
@property(nonatomic, assign) NSInteger    near10Win;
/**近10场输的场数*/
@property(nonatomic, assign) NSInteger    near10Loss;
/**主场赢的场数*/
@property(nonatomic, assign) NSInteger    homeWin;
/**主场输的场数*/
@property(nonatomic, assign) NSInteger    homeLoss;

/**客场赢的场数*/
@property(nonatomic, assign) NSInteger    awayWin;
/**客场输的场数*/
@property(nonatomic, assign) NSInteger    awayLoss;
@end

@interface QukanBasketDetailHisFightData : NSObject

/**开赛日期*/
@property(nonatomic, copy) NSString   * startDate;
/**开赛时间*/
@property(nonatomic, copy) NSString   * startTime;
/**赛事名称*/
@property(nonatomic, copy) NSString   * leagueName;
/**主队名称*/
@property(nonatomic, copy) NSString   * homeName;
/**客队名称*/
@property(nonatomic, copy) NSString   * awayName;

/**主队id*/
@property(nonatomic, assign) NSInteger    homeId;
/**主队全场得分*/
@property(nonatomic, assign) NSInteger    homeFullScore;
/**主队半场得分*/
@property(nonatomic, assign) NSInteger    homeHalfScore;
/**客队id*/
@property(nonatomic, assign) NSInteger    awayId;
/**客队全场得分*/
@property(nonatomic, assign) NSInteger    awayFullScore;

/**客队半场得分*/
@property(nonatomic, assign) NSInteger    awayHalfScore;
/**让球*/
@property(nonatomic, assign) NSInteger    giveWay;
/**大*/
@property(nonatomic, assign) NSInteger    over;
/**小*/
@property(nonatomic, assign) NSInteger    under;

/**该主队是否是本场比赛主队*/
@property(nonatomic, assign) BOOL    selectTeamIsHomeTeam;
/**主队胜利状态  1：赢 2：输 3：平*/
@property(nonatomic, assign) NSInteger  winState;

@end

@interface QukanBasketDetailDataModel : NSObject

/**主队赛季战绩*/
@property(nonatomic, strong) QukanBasketDetailSaijiData   * homeTeamRankData;
/**客队赛季战绩*/
@property(nonatomic, strong) QukanBasketDetailSaijiData   * awayTeamRankData;

/**主队赛季场均数据*/
@property(nonatomic, strong) QukanBasketDetailChangjunData   * homeTeamAvgData;

/**客队赛季场均数据*/
@property(nonatomic, strong) QukanBasketDetailChangjunData   * awayTeamAvgData;

/**主客队历史交战*/
@property(nonatomic, strong) NSArray<QukanBasketDetailHisFightData *>   * teamHisFightData;

/**主队近10场比赛*/
@property(nonatomic, strong) NSArray<QukanBasketDetailHisFightData *>   * homeRecentFightData;

/**客队近10场比赛*/
@property(nonatomic, strong) NSArray<QukanBasketDetailHisFightData *>   * awayRecentFightData;


/**<#说明#>*/
@property(nonatomic, copy) NSString   * awayLogo;
/**<#说明#>*/
@property(nonatomic, copy) NSString   * awayXshort;
/**<#说明#>*/
@property(nonatomic, copy) NSString   * awayId;
/**<#说明#>*/
@property(nonatomic, copy) NSString   * awayGb;

/**<#说明#>*/
@property(nonatomic, copy) NSString   * homeLogo;
/**<#说明#>*/
@property(nonatomic, copy) NSString   * homeXshort;
/**<#说明#>*/
@property(nonatomic, copy) NSString   * homeId;
/**<#说明#>*/
@property(nonatomic, copy) NSString   * homeGb;

@end

NS_ASSUME_NONNULL_END
