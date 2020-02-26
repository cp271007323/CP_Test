//
//  QukanBasketBallMatchModel.h
//  Qukan
//
//  Created by leo on 2019/9/3.
//  Copyright © 2019 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@class QukanBasketBallMatchLiveModel;


@interface QukanBasketBallMatchModel : NSObject

/**比赛ID*/
@property (copy, nonatomic)  NSString *matchId;
/**动画直播标识*/
@property (copy, nonatomic)  NSString *animatedLive;
/**视频直播标识*/
@property (copy, nonatomic)  NSString *videoLive;
/**客队名称*/
@property (copy, nonatomic)  NSString *awayName;
/**客队对标*/
@property (copy, nonatomic)  NSString *awayLogo;
/**主队名称*/
@property (copy, nonatomic)  NSString *homeName;
/**主队对标*/
@property (copy, nonatomic)  NSString *homeLogo;
/**联赛名称*/
@property (copy, nonatomic)  NSString *leagueName;
/**主队总得分*/
@property (copy, nonatomic)  NSString *homeScore;
/**主队一节得分*/
@property (copy, nonatomic)  NSString *homeScore1;
/**主队二节得分*/
@property (copy, nonatomic)  NSString *homeScore2;
/**主队三节得分*/
@property (copy, nonatomic)  NSString *homeScore3;
/**主队四节得分*/
@property (copy, nonatomic)  NSString *homeScore4;
/**主队加时得分*/
@property (copy, nonatomic)  NSString *homeOtScore;
/**客队总得分*/
@property (copy, nonatomic)  NSString *awayScore;
/**客队一节得分*/
@property (copy, nonatomic)  NSString *awayScore1;
/**客队二节得分*/
@property (copy, nonatomic)  NSString *awayScore2;
/**客队三节得分*/
@property (copy, nonatomic)  NSString *awayScore3;
/**客队四节得分*/
@property (copy, nonatomic)  NSString *awayScore4;
/**客队加时得分*/
@property (copy, nonatomic)  NSString *awayOtScore;
/**比赛动态时间*/
@property (copy, nonatomic)  NSString *remainTime;
/**是否关注*/
@property (copy, nonatomic)  NSString *attention;
/**状态：0:未开赛，1:一节，2:二节，3:三节，4:四节，5:1’OT，6:2’OT，7:3’OT，-1:完场, -2:待定，-3:中断，-4:取消，-5:推迟，50:中场*/
@property (assign, nonatomic)  int status;
/**开赛时间*/
@property (copy, nonatomic)  NSString *startTime;
/**赛事数量*/
@property (copy, nonatomic)  NSString *countz;
/**联赛ID*/
@property (copy, nonatomic)  NSString *sclassId;

/**直播地址*/
@property(nonatomic, copy) NSString   *cdnM3u8Url;

/**是否有技术统计,True:有技术统计，空则无技术统计*/
@property(nonatomic, copy) NSString   *statistics;
/**直播地址数组*/
@property(nonatomic, strong) NSArray<QukanBasketBallMatchLiveModel*>   *matchLive;

@property(nonatomic, copy) NSString   *dLive;

@property(nonatomic, copy) NSString   *matchTime;

@end



@interface QukanBasketBallMatchLiveModel : NSObject

/**直播名字*/
@property (copy, nonatomic)  NSString *liveName;
/**动画直播地址*/
@property (copy, nonatomic)  NSString *cdnM3u8Url;
/**视频样式*/
@property (copy, nonatomic)  NSString *liveType;

@end



NS_ASSUME_NONNULL_END
