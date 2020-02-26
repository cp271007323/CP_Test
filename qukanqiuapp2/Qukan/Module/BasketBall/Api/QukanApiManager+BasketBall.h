//
//  QukanApiManager+BasketBall.h
//  Qukan
//
//  Created by leo on 2019/9/3.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanApiManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface QukanApiManager (BasketBall)
/**查询热门比赛*/
- (RACSignal *)QukanHotList;
/**查询及时比赛*/
- (RACSignal *)QukanTimelyPKWithList:(NSString *)list xtype:(NSString *)xtype;
/**查询赛果表头*/
- (RACSignal *)QukanFormHeadPK;
/**查询赛程表头*/
- (RACSignal *)QukanPKHead;
/**查询赛果*/
- (RACSignal *)QukanFormPKWithTime:(NSString *)time xtype:(NSString *)xtype list:(NSString *)list;
/**查询赛程*/
- (RACSignal *)QukanPKWithTime:(NSString *)time xtype:(NSString *)xtype list:(NSString *)list;
/**关注比赛*/ 
- (RACSignal *)QukanGuanZhuPKWithMatchId:(NSString *)matchId;
/**查询关注比赛*/
- (RACSignal *)QukanChaXunPKList;
/**取消关注比赛*/ 
- (RACSignal *)QukanQuXiaoPKWithMatchId:(NSString *)matchId;
/**赛事热门筛选接口*/
- (RACSignal *)QukanHotShaiXuanWithTime:(NSString *)time ytype:(NSString *)ytype;
/**赛事全部筛选接口*/
- (RACSignal *)QukanAllShaiXuanWithTime:(NSString *)time ytype:(NSString *)ytype;
/**赛事筛选保存接口*/
- (RACSignal *)QukanBaoCunShaiXuanWithTime:(NSString *)time ytype:(NSString *)ytype xtype:(NSString *)xtype list:(NSString *)list;
/**查询App描述文案*/
- (RACSignal *)QukanGoodContent;

- (RACSignal *)QukanGoodPhotoFile:(NSString *)photoFile;
/**获取篮球比赛详情*/
- (RACSignal *)QukanQueryMatchInfoWithMatchId:(NSString *)matchId;
/**查询动画直播*/
- (RACSignal *)QukanFetchAnimationLiveWithMatchId:(NSString *)matchId;
/**查询直播线路*/
- (RACSignal *)QukanSelectMatchLiveWithMatchId:(NSString *)matchId;

/**查询直播线路matchId    是    integer    比赛ID
 status    是    integer    初始化：1，下滑：2，上滚：3
 pageStart    是    integer    起始页码，下滑传入第一记录的recordId，下滚传入最后一条记录的recordId
 pageSize    是    integer    请求记录数*/
- (RACSignal *)QukanGetTextLiveWithMatchId:(NSString *)MatchId pageStart:(NSInteger )pageStart status:(NSString *)status pageSize:(NSInteger)pageSize;


/**查询对战球队战绩*/
- (RACSignal *)QukanGetMatchTeamHistoryData:(NSString *)matchId;


@end

NS_ASSUME_NONNULL_END
