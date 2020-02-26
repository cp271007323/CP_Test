//
//  QukanMatchDataModel.h
//  Qukan
//
//  Created by leo on 2019/10/11.
//  Copyright © 2019 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanMatchImmediatelyDataModel : NSObject

/**主队得分*/
@property(nonatomic, assign) NSInteger   home_score;
/**客队得分*/
@property(nonatomic, assign) NSInteger    away_score;
/** */
@property(nonatomic, copy) NSString   * bc1;
/** */
@property(nonatomic, copy) NSString   * bc2;


/** */
@property(nonatomic, copy) NSString   * corner1;
/** */
@property(nonatomic, copy) NSString   * corner2;
/**比赛id*/
@property(nonatomic, assign) NSInteger  match_id;
/**历时时间*/
@property(nonatomic, copy) NSString   * pass_time;


/**主队红牌哦*/
@property(nonatomic, assign) NSInteger   red1;
/**客队红牌*/
@property(nonatomic, assign) NSInteger    red2;
/**比赛状态*/
@property(nonatomic, assign) NSInteger    state;
/**主队黄牌*/
@property(nonatomic, assign) NSInteger    yellow1;
/**客队黄牌*/
@property(nonatomic, assign) NSInteger    yellow2;
@end

NS_ASSUME_NONNULL_END
