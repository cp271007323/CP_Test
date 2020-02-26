//
//  QukanFootTool.h
//  Qukan
//
//  Created by Jeff on 2020/2/9.
//  Copyright © 2020 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
@class QukanMatchInfoContentModel, QukanFTMatchScheduleModel;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, QukanFootMatchState) {
    QukanFootMatchStateNoStart,
    QukanFootMatchStateMathcing,
    QukanFootMatchStateEnded,
    QukanFootMatchStateOther
};

@interface QukanFootTool : NSObject

+ (QukanFootMatchState)getFootballMatchStateForFlag:(NSInteger)matchFlag;

+ (QukanMatchInfoContentModel*)createWithModel:(QukanFTMatchScheduleModel *)orgModel;

@end

NS_ASSUME_NONNULL_END
