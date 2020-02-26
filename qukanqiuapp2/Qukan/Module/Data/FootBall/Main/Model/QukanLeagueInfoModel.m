//
//  QukanLeagueInfoModel.m
//  Qukan
//
//  Created by Charlie on 2019/12/26.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanLeagueInfoModel.h"

@implementation QukanLeagueInfoModel

+(NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"seasons":[NSString class]};
}

- (void)encodeWithCoder:(NSCoder *)aCoder { [self modelEncodeWithCoder:aCoder]; }
- (id)initWithCoder:(NSCoder *)aDecoder { self = [super init]; return [self modelInitWithCoder:aDecoder]; }

-(NSString *)currMatchSeason{
    NSString* season = _currMatchSeason;
    if(![season containsString:@"-"]){
        return season;
    }
    NSString* showSeason = [NSString stringWithFormat:@"%@/%@",[season substringWithRange:NSMakeRange(2, 2)],[season substringWithRange:NSMakeRange(season.length-2, 2)]];
    return showSeason;
}

-(NSArray<NSString *> *)seasons{
    NSMutableArray* array = [NSMutableArray array];
    for(NSString* season in _seasons){
        if(![season containsString:@"-"]){
            [array addObject:season];
        }else{
            NSString* showSeason = [NSString stringWithFormat:@"%@/%@",[season substringWithRange:NSMakeRange(2, 2)],[season substringWithRange:NSMakeRange(season.length-2, 2)]];
            [array addObject:showSeason];
        }
    }
    if(![array containsObject:self.currMatchSeason]){
        [array addObject:_currMatchSeason];
    }
    
    return array;
}

@end
