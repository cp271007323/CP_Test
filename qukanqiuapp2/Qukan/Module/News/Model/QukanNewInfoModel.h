//
//  QukanNewInfoModel.h
//  Qukan
//
//  Created by Jeff on 2019/11/27.
//  Copyright © 2019 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanNewInfoModel : NSObject

@property(nonatomic, copy) NSString *imageName;
@property(nonatomic, copy) NSString *desc;
@property(nonatomic, copy) NSString *nId;
@property(nonatomic, copy) NSString *typeID;
@property(nonatomic, copy) NSString *skipId;
@property(nonatomic, copy) NSString *newsLink;

@end

NS_ASSUME_NONNULL_END
