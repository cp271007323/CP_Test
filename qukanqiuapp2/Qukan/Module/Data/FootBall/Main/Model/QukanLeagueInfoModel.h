//
//  QukanLeagueInfoModel.h
//  Qukan
//
//  Created by Charlie on 2019/12/26.
//  Copyright © 2019 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*
 "areaId": "1",
 "big": "丹麥超級聯賽",
 "bigShort": "丹麥超",
 "color": "#6969e3",
 "country": "丹麦",
 "countryId": 13,
 "currMatchSeason": "2019-2020",
 "currRound": 1,
 "en": "Denmark Superligaen",
 "enShort": "DEN SASL",
 "flagHot": 0,
 "flagMajor": 1,
 "gb": "丹麦超级联赛",
 "gbShort": "丹麦超",
 "leagueId": 7,
 "matchCount": null,
 "subSclass": "联赛",
 "sumRound": 26,
 "seasons": [
 "2017-2018"
 ],
 "type": "1"
 */

@interface QukanLeagueInfoModel : NSObject

@property(nonatomic, copy) NSString    *areaId;
@property(nonatomic, copy) NSString    *big;
@property(nonatomic, copy) NSString    *bigShort;
@property(nonatomic, copy) NSString    *color;
@property(nonatomic, copy) NSString    *country;
@property(nonatomic, copy) NSString    *countryId;
@property(nonatomic, copy) NSString    *currMatchSeason;
@property(nonatomic, assign) NSInteger    currRound;
@property(nonatomic, copy) NSString    *en;
@property(nonatomic, copy) NSString    *enShort;


@property(nonatomic, copy) NSString    *flagHot;
@property(nonatomic, copy) NSString    *flagMajor;
@property(nonatomic, copy) NSString    *gb;
@property(nonatomic, copy) NSString    *gbShort;

@property(nonatomic, copy) NSArray<NSString*>    *seasons;


@property(nonatomic, copy) NSString    *countryLogo;
@property(nonatomic, copy) NSString    *logo;

@property(nonatomic, copy) NSString* leagueId;
@property(nonatomic, copy) NSString* matchCount;
@property(nonatomic, copy) NSString* subSclass;
@property(nonatomic, copy) NSString* sumRound;
@property(nonatomic, copy) NSString* type;
@end

NS_ASSUME_NONNULL_END
