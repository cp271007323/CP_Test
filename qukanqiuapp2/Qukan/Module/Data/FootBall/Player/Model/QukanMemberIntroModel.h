//
//  QukanMemberIntroModel.h
//  Qukan
//
//  Created by Charlie on 2020/1/2.
//  Copyright © 2020 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*
 endDateContract    string    合同到期时间
 endTime    string    转会结束时间
 money    double    转会价格
 place    double    在原队位置
 teamId    int    转出球队ID
 teamName    string    转出球队名称
 teamNowId    int    转入球队ID
 teamNowName    string    转入球队名称
 transferTime    string    转会时间
 type    string    【转会类型】直接返回文本，包括5种：完全所有、租借、自由转会、租借结束、共同所有
 zhSeason    string    转会赛季
 */

@interface QukanPlayerTRecordModel : NSObject

@property (nonatomic, copy)NSString *endDateContract;
@property (nonatomic, copy)NSString *endTime;
//@property (nonatomic, copy)NSString *money;
@property (nonatomic, copy)NSString *place;

@property (nonatomic, copy)NSString *teamId;
@property (nonatomic, copy)NSString *teamName;
@property (nonatomic, copy)NSString *teamNowId;
@property (nonatomic, copy)NSString *teamNowName;

@property (nonatomic, copy)NSString *tTime;
@property (nonatomic, copy)NSString *type;
@property (nonatomic, copy)NSString *zhSeason;


@end

/*
birthday    string    生日
country    string    国家
feet    string    惯用脚
health    string    健康状况
nameE    string    球员英文名
nameF    string    球员繁体名
nameJ    string    球员简体名
number    int    球衣号码
photo    string    头像
place    string    位置
playerId    int    球员id
tallness    double    球员身高
value    double    身价 单位：万欧元
weight    double    球员体重
*/

@interface QukanMemberIntroModel : NSObject

@property (nonatomic, copy)NSString *birthday;
@property (nonatomic, copy)NSString *country;
@property (nonatomic, copy)NSString *feet;
@property (nonatomic, copy)NSString *health;

@property (nonatomic, copy)NSString *nameE;
@property (nonatomic, copy)NSString *nameF;
@property (nonatomic, copy)NSString *nameJ;
@property (nonatomic, copy)NSString *number;

@property (nonatomic, copy)NSString *photo;
@property (nonatomic, copy)NSString *place;
@property (nonatomic, copy)NSString *playerId;
@property (nonatomic, copy)NSString *tallness;

@property (nonatomic, copy)NSString *value;
@property (nonatomic, copy)NSString *weight;

@property (nonatomic, copy)NSArray <QukanPlayerTRecordModel *> *tRecords;
@end

NS_ASSUME_NONNULL_END
