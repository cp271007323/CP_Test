//
//  QukanMatchDetailJSTJModel.h
//  Qukan
//
//  Created by leo on 2019/12/31.
//  Copyright © 2019 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface QukanMatchDetailJSTJDetailModel : NSObject

/**得*/
@property(nonatomic, copy) NSString   * haveTo;
/**失*/
@property(nonatomic, copy) NSString   * lose;
/**排名*/
@property(nonatomic, copy) NSString   * sort;
/**胜率*/
@property(nonatomic, assign) long   succesRage;
/**净*/
@property(nonatomic, copy) NSString   * bare;

/**胜*/
@property(nonatomic, copy) NSString   * win;
/**赛*/
@property(nonatomic, copy) NSString   * scene;
/**负*/
@property(nonatomic, copy) NSString   * negative;
/**积分*/
@property(nonatomic, copy) NSString   * jifen;
/**平*/
@property(nonatomic, copy) NSString   * flat;

@end


@interface QukanMatchDetailJSTJModel : NSObject

/**总*/
@property(nonatomic, strong) QukanMatchDetailJSTJDetailModel   * totalScores;
/**球队id*/
@property(nonatomic, assign) NSInteger    teamId;
/**主*/
@property(nonatomic, strong) QukanMatchDetailJSTJDetailModel   * homeScores;
/**客*/
@property(nonatomic, strong) QukanMatchDetailJSTJDetailModel   * awayScores;
/**联赛id*/
@property(nonatomic, assign) NSInteger    leagueId;


@end




NS_ASSUME_NONNULL_END
