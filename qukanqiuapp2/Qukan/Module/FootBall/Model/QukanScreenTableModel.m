#import "QukanScreenTableModel.h"
@implementation QukanScreenTableModel
- (instancetype)initQukan_WithDict:(NSDictionary *)dict {
    if (self=[super init]) {
        _isSelected = NO;
        _gbShort = dict[@"leagueName"]?:@"";
        _leagueId = [NSString stringWithFormat:@"%@", dict[@"leagueId"]?:@""];
        _matchCount = [dict[@"matchCount"] integerValue];
    }
    return self;
}

- (NSString *)description {
    return self.gbShort;
}
@end
