#import "QukanMatchInfoModel.h"
#import "QukanYBArchiveUtilHeader.h"
@implementation QukanMatchInfoModel
@end
@implementation QukanMatchInfoContentModel
YB_IMPLEMENTATION_CODE_WITH_CODER
- (instancetype)initQukan_WithDict:(NSDictionary *)dict {
    if (self=[super init]) {
        _isFollow = NO;
        _isAttention = dict[@"isAttention"]?:@"";
        _contentType = [dict[@"contentType"] integerValue];
        _redTips = [dict[@"redTips"] integerValue];
        _goalTips = [dict[@"goalTips"] integerValue];
        _match_id = [dict[@"match_id"] integerValue];
        _league_name = dict[@"league_name"]?:@"";
        _match_time = dict[@"match_time"]?:@"";
        _pass_time = dict[@"pass_time"]?:@"";
        _bc1 = [dict[@"bc1"] integerValue];
        _bc2 = [dict[@"bc2"] integerValue];
        _corner1 = [dict[@"corner1"] integerValue];
        _corner2 = [dict[@"corner2"] integerValue];
        _home_name = dict[@"home_name"]?:@"";
        _away_name = dict[@"away_name"]?:@"";
        _home_score = [dict[@"home_score"] integerValue];
        _away_score = [dict[@"away_score"] integerValue];
        _order1 = dict[@"order1"]?:@"";
        _order2 = dict[@"order2"]?:@"";
        _ajilv = dict[@"ajilv"]?:@"";
        _dxjilv = dict[@"dxjilv"]?:@"";
        _red1 = [dict[@"red1"] integerValue];
        _red2 = [dict[@"red2"] integerValue];
        _yellow1 = [dict[@"yellow1"] integerValue];
        _yellow2 = [dict[@"yellow2"] integerValue];
        _flag1 = dict[@"flag1"]?:@"";
        _flag2 = dict[@"flag2"]?:@"";
        _state = [dict[@"state"] integerValue];
        _start_time = dict[@"start_time"]?:@"";
        _gqLive = dict[@"gqLive"]?:@"";
        _dLive = dict[@"dLive"]?:@"";
        _home_id = dict[@"home_id"]?:@"";
        _away_id = dict[@"away_id"]?:@"";
        _league_id = dict[@"league_id"]?:@"";
        _season = dict[@"season"]?:@"";
    }
    return self;
}
- (instancetype)copyWithZone:(NSZone *)zone {
    QukanMatchInfoContentModel *obj = [[QukanMatchInfoContentModel alloc] init];
    if (obj) {
        obj.isFollow = self.isFollow;
        obj.isAttention = self.isAttention;
        obj.contentType = self.contentType;
        obj.redTips = self.redTips;
        obj.goalTips = self.goalTips;
        obj.match_id = self.match_id;
        obj.league_name = [self.league_name copyWithZone:zone];
        obj.match_time = [self.match_time copyWithZone:zone];
        obj.pass_time = [self.pass_time copyWithZone:zone];
        obj.bc1 = self.bc1;
        obj.bc2 = self.bc2;
        obj.corner1 = self.corner1;
        obj.corner2 = self.corner2;
        obj.home_name = [self.home_name copyWithZone:zone];
        obj.away_name = [self.away_name copyWithZone:zone];
        obj.home_score = self.home_score;
        obj.away_score = self.away_score;
        obj.order1 = [self.order1 copyWithZone:zone];
        obj.order2 = [self.order2 copyWithZone:zone];
        obj.ajilv = [self.ajilv copyWithZone:zone];
        obj.dxjilv = [self.dxjilv copyWithZone:zone];
        obj.red1 = self.red1;
        obj.red2 = self.red2;
        obj.yellow1 = self.yellow1;
        obj.yellow2 = self.yellow2;
        obj.flag1 = [self.flag1 copyWithZone:zone];
        obj.flag2 = [self.flag2 copyWithZone:zone];
        obj.state = self.state;
        obj.start_time = [self.start_time copyWithZone:zone];
        obj.gqLive = [self.gqLive copyWithZone:zone];
        obj.dLive = [self.dLive copyWithZone:zone];
    }
    return obj;
}
@end
