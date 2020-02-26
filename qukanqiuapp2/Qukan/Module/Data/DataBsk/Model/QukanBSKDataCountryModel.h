//
//  QukanBSKDataCountryModel.h
//  Qukan
//
//  Created by blank on 2019/12/28.
//  Copyright © 2019 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
@class QukanBtSclassVos;
NS_ASSUME_NONNULL_BEGIN

@interface QukanBSKDataCountryModel : NSObject
@property (nonatomic, copy)NSString *countryId;
@property (nonatomic, copy)NSString *country;
@property (nonatomic, copy)NSMutableArray <QukanBtSclassVos *> *btSclassVos;
@end

@interface QukanBtSclassVos : NSObject
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
@end
NS_ASSUME_NONNULL_END
