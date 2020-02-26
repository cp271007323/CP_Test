
#import "QukanHotModel.h"

@implementation QukanHotModel

- (instancetype)initQukan_WithDict:(NSDictionary *)dict {
    if (self=[super init]) {
        _isAttention = dict[@"isAttention"]?:@"";
        _away_id = dict[@"away_id"]?:@"";
        _away_name = dict[@"away_name"]?:@"";
        _league_name = dict[@"league_name"]?:@"";
        _away_score = dict[@"away_score"]?:@"";
        _bc1 = dict[@"bc1"]?:@"";
        _bc2 = dict[@"bc2"]?:@"";
        _corner1 = dict[@"corner1"]?:@"";
        _corner2 = dict[@"corner2"]?:@"";
        _home_id = dict[@"home_id"]?:@"";
        _home_name = dict[@"home_name"]?:@"";
        _home_score = dict[@"home_score"]?:@"";
        _ishot = [NSString stringWithFormat:@"%@", dict[@"ishot"]?:@""];
        _league_id = [NSString stringWithFormat:@"%@", dict[@"league_id"]?:@""];
        _league_name = dict[@"league_name"]?:@"";
        _match_id = [NSString stringWithFormat:@"%@", dict[@"match_id"]?:@""];
        _match_time = dict[@"match_time"]?:@"";
        _order1 = [NSString stringWithFormat:@"%@", dict[@"order1"]?:@""];
        _order2 = [NSString stringWithFormat:@"%@", dict[@"order2"]?:@""];
        _flag1 = [NSString stringWithFormat:@"%@", dict[@"flag1"]?:@""];
        _flag2 = [NSString stringWithFormat:@"%@", dict[@"flag2"]?:@""];
        _pass_time = dict[@"pass_time"]?:@"";
        
        _red1 = [NSString stringWithFormat:@"%@", dict[@"red1"]?:@""];
        _red2 = [NSString stringWithFormat:@"%@", dict[@"red2"]?:@""];
        _start_time = dict[@"start_time"]?:@"";
        
        _state = [NSString stringWithFormat:@"%@", dict[@"state"]?:@""];
        _yellow1 = [NSString stringWithFormat:@"%@", dict[@"yellow1"]?:@""];
        _yellow2 = [NSString stringWithFormat:@"%@", dict[@"yellow2"]?:@""];
        
        _gqLive = dict[@"gqLive"]?:@"";
        _dhLive = dict[@"dhLive"]?:@"";
        
    }
    return self;
}

@end
