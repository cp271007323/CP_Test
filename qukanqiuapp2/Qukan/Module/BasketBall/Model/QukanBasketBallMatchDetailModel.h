
#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,MatchStatus) {
    NoOpenMatchStatus,
    InMatchStatus,
    EndMatchStatus,
    UnusualMatchStatus
};
@class QukanHomeAndGuestPlayerListModel;
@class QukanMatchLiveModel;
@interface QukanBasketBallMatchDetailModel : NSObject
- (MatchStatus)getMatchStatus;
@property (nonatomic, copy)NSString *awayScore2;//客队第二节得分
@property (nonatomic, copy)NSString *startTime;//开赛时间,已处理
@property (nonatomic, copy)NSString *awayLogo;//客队对标
@property (nonatomic, copy)NSString *guestTeamId;//客队id
@property (nonatomic, copy)NSString *homeScore3;//主队三节得分
@property (nonatomic, copy)NSString *guestExceed;//客队最多领先分数
@property (nonatomic, copy)NSString *guestFast;//客队快攻得分
@property (nonatomic, copy)NSString *homeScore1;//主队一节得分
@property (nonatomic, copy)NSString *homeInside;//主队内线得分
@property (nonatomic, copy)NSString *guestTwoAttack;//客队二次进攻【主队二次进攻】该数据目前不更新
@property (nonatomic, copy)NSString *homeScore;//主队得分
@property (nonatomic, copy)NSString *guestInside;//客队内线得分
@property (nonatomic, copy)NSString *homeFast;//主队快攻得分
@property (nonatomic, copy)NSString *costTime;//比赛耗时【比赛耗时】单位：分钟
@property (nonatomic, copy)NSString *awayScore3;//客队三节得分
@property (nonatomic, copy)NSString *homeLogo;//主队对标
@property (nonatomic, copy)NSString *homeTeamId;//主队id
@property (nonatomic, copy)NSString *homeTeam;//主队名
@property (nonatomic, copy)NSString *guestTotalMis;//客队总失误
@property (nonatomic, copy)NSString *cdnM3u8Url;//直播地址
@property (nonatomic, copy)NSString *status;//状态
@property (nonatomic, copy)NSString *awayScore1;//客队一节得分
@property (nonatomic, copy)NSString *totalMis;//主队总失误
@property (nonatomic, copy)NSString *leagueName;//联赛名称
@property (nonatomic, copy)NSString *homeScore4;//主队四节得分
@property (nonatomic, copy)NSString *remainTime;//小节剩余时间
@property (nonatomic, copy)NSString *twoAttack;//主队二次进攻【主队二次进攻】该数据目前不更新
@property (nonatomic, copy)NSString *scheduleId;//比赛id
@property (nonatomic, copy)NSString *matchId;//比赛id
@property (nonatomic, copy)NSString *homeScore2;//主队二节得分
@property (nonatomic, copy)NSString *liveType;//直播线路类别,1:播放器高清直播 2:第三方高清直播 3:动画直播 7:广告
@property (nonatomic, copy)NSString *guestScore;//客队得分
@property (nonatomic, copy)NSString *homeOtScore;//主队加时得分
@property (nonatomic, copy)NSString *matchTime;//比赛时间
@property (nonatomic, copy)NSString *homeExceed;//主队最多领先分数
@property (nonatomic, copy)NSString *awayOtScore;//客队加时得分
@property (nonatomic, copy)NSString *liveName;//直播线路名称
@property (nonatomic, copy)NSString *awayScore4;//客队四节得分
@property (nonatomic, copy)NSString *guestTeam;//客队名
/**是否有技术统计,True:有技术统计，空则无技术统计*/
@property(nonatomic, copy) NSString   *statistics;
@property (nonatomic, copy)NSString *phpAdvId;//广告id
@property (nonatomic, copy)NSArray <QukanHomeAndGuestPlayerListModel *> *guestPlayerList;
@property (nonatomic, copy)NSArray <QukanHomeAndGuestPlayerListModel *> *homePlayerList;
@property (nonatomic, copy)NSArray *matchLive;
@property(nonatomic, copy) NSString *animationUrl;
@property (nonatomic, copy)NSString *xtype;//类型:联赛-1,杯赛-2


@end
@interface QukanMatchLiveModel:NSObject
@property (nonatomic, copy)NSString *liveType;//直播线路类别,1:播放器高清直播 2:第三方高清直播 3:动画直播 7:广告
@property (nonatomic, copy)NSString *liveName;//直播名称
@property (nonatomic, copy)NSString *cdnM3u8Url;//直播url
@end

@interface QukanHomeAndGuestPlayerListModel : NSObject
@property (nonatomic, copy)NSString *attack;//进攻篮板
@property (nonatomic, copy)NSString *cover;//盖帽
@property (nonatomic, copy)NSString *defend;//防守篮板
@property (nonatomic, copy)NSString *foul;//犯规
@property (nonatomic, copy)NSString *helpAttack;//助攻
@property (nonatomic, copy)NSString *location;//位置【位置】首发有位置数据，如中锋、后卫等；替补无数据
@property (nonatomic, copy)NSString *misPlay;//失误
@property (nonatomic, copy)NSString *onFloor;//是否在场上【是否在场上】True/False
@property (nonatomic, copy)NSString *photo;//个人照片
@property (nonatomic, copy)NSString *playTime;//商场时间
@property (nonatomic, copy)NSString *player;//球员名
@property (nonatomic, copy)NSString *playerId;//球员id
@property (nonatomic, copy)NSString *punishball;//罚球
@property (nonatomic, copy)NSString *punishballHit;//罚球命中
@property (nonatomic, copy)NSString *rob;//抢断
@property (nonatomic, copy)NSString *scheduleId;//比赛id
@property (nonatomic, copy)NSString *score;//得分
@property (nonatomic, copy)NSString *shoot;//投篮数
@property (nonatomic, copy)NSString *shootHit;//投篮命中
@property (nonatomic, copy)NSString *teamId;//球队id
@property (nonatomic, copy)NSString *threemin;//三分
@property (nonatomic, copy)NSString *threeminHit;//三分命中
@property (nonatomic, copy)NSString *number;//球员球衣号码


//辅助属性
@property (nonatomic, copy)NSString *locationString;//是否首发
@property (nonatomic, copy)NSString *shootString;//投篮命中  2/14
@property (nonatomic, copy)NSString *threeScoreString;//三分命中  2/15
@property (nonatomic, copy)NSString *freeThrowString;//罚球命中 1/15
@property (nonatomic, copy)NSString *backboardString;//篮板数 进攻+防守篮板

@end
