//
//  QukanBtSclassHotModel.h
//  Qukan
//
//  Created by blank on 2019/12/27.
//  Copyright © 2019 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanBtSclassHotModel : NSObject
@property (nonatomic, copy)NSString *sclassId;
@property (nonatomic, copy)NSString *xshort;
@property (nonatomic, copy)NSString *gb;
@property (nonatomic, copy)NSString *xtype;
@property (nonatomic, copy)NSString *currMatchSeason;
@property (nonatomic, copy)NSString *countryId;
@property (nonatomic, copy)NSString *country;
@property (nonatomic, copy)NSString *sclassKind;
@property (nonatomic, copy)NSString *sclassTime;
@property (nonatomic, copy)NSString *logo;

@property (nonatomic, assign)BOOL selected;
@end


@interface QukanEventTypeModel : NSObject
@property (nonatomic, copy)NSString *kindName;
@property (nonatomic, copy)NSString *matchKind;

@end

@interface QukanDataBSKParamsModel : NSObject
@property (nonatomic, copy)NSString *matchKind;
@property (nonatomic, copy)NSString *kindName;
@property (nonatomic, copy)NSString *sclassId;
@property (nonatomic, copy)NSString *season;
@property (nonatomic, copy)NSString *month;

@property (nonatomic, copy)NSString *allianceId;
@property (nonatomic, copy)NSString *allianceName;

@property (nonatomic, copy)NSString *sclassKind;
@property (nonatomic, copy)NSString *currMatchSeason;
@end

@interface QukanDataAllianceModel : NSObject
@property (nonatomic, copy)NSString *allianceId;
@property (nonatomic, copy)NSString *allianceName;
@end
NS_ASSUME_NONNULL_END
