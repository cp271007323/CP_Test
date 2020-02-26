//
//  QukanFootTool.m
//  Qukan
//
//  Created by Jeff on 2020/2/9.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanFootTool.h"
#import "QukanMatchInfoModel.h"
#import "QukanFTMatchScheduleModel.h"

@implementation QukanFootTool

+ (QukanFootMatchState)getFootballMatchStateForFlag:(NSInteger)matchFlag {
    switch (matchFlag) {
        case 0:
            return QukanFootMatchStateNoStart;
            break;
        case 1:
        case 2:
        case 3:
        case 4:
            return QukanFootMatchStateMathcing;
            break;
        case -1:
            return QukanFootMatchStateEnded;
            
        default:
            return QukanFootMatchStateOther;
            break;
    }
}

+ (QukanMatchInfoContentModel*)createWithModel:(QukanFTMatchScheduleModel *)orgModel {
    QukanMatchInfoContentModel* resultModel = [QukanMatchInfoContentModel new];
    
    resultModel.match_id = orgModel.match_id.intValue;
    resultModel.away_id = orgModel.away_id;
    resultModel.home_id = orgModel.home_id;
    resultModel.league_name = orgModel.league_name;
    resultModel.match_time = orgModel.match_time;
    resultModel.pass_time = orgModel.pass_time;
    resultModel.bc1 = orgModel.bc1.intValue;
    resultModel.bc2 = orgModel.bc2.intValue;
    resultModel.corner1 = orgModel.corner1.intValue;
    resultModel.corner2 = orgModel.corner2.intValue;
    resultModel.home_name = orgModel.home_name;
    resultModel.away_name = orgModel.away_name;
    resultModel.home_score = orgModel.home_score.intValue;
    resultModel.away_score = orgModel.away_score.intValue;
    resultModel.order1 = orgModel.order1;
    resultModel.order2 = orgModel.order2;
    resultModel.red1 = orgModel.red1.intValue;
    resultModel.red2 = orgModel.red2.intValue;
    resultModel.yellow1 = orgModel.yellow1.intValue;
    resultModel.yellow2 = orgModel.yellow2.intValue;
    
    resultModel.flag1 = orgModel.flag1;
    resultModel.flag2 = orgModel.flag2;
    
    resultModel.state = [orgModel state].intValue;
    resultModel.start_time = orgModel.start_time;
    resultModel.season = orgModel.season;
    resultModel.league_id = orgModel.league_id;
    
    return resultModel;
}

@end
