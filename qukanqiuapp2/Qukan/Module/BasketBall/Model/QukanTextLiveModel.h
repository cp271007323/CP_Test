//
//  QukanTextLiveModel.h
//  Qukan
//
//  Created by leo on 2019/12/18.
//  Copyright © 2019 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanTextLiveModel : NSObject

/**文字内容序号*/
@property(nonatomic, copy) NSString   * textId;
/**记录ID*/
@property(nonatomic, copy) NSString   * recordId;
/**主客标志,3:中立，1:主队信息，2:客队信息*/
@property(nonatomic, copy) NSString   * xtype;
/**直播内容*/
@property(nonatomic, copy) NSString   * content;
/**状态,0:未开赛，1:一节，2:二节，3:三节，4:四节，5:1’OT，6:2’OT，7:3’OT，-1:完场, -2:待定，-3:中断，-4:取消，-5:推迟，50:中场*/
@property(nonatomic, copy) NSString   * status;

/**小节剩余时间*/
@property(nonatomic, copy) NSString   * remainTime;
/**主队得分*/
@property(nonatomic, copy) NSString   * homeScore;
/**客队得分*/
@property(nonatomic, copy) NSString   * awayScore;

/**此消息发送的时间*/
@property (nonatomic,assign)  NSTimeInterval msgTime;

@end

NS_ASSUME_NONNULL_END
