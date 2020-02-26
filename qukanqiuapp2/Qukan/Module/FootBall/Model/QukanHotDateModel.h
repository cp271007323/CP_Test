//
//  QukanHotDateModel.h
//  Qukan
//
//  Created by Kody on 2019/6/27.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QukanHotModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QukanHotDateModel : NSObject

@property (nonatomic, assign)BOOL      *isShow;
@property (nonatomic, copy) NSString *dateStr;
@property (nonatomic, copy) QukanHotModel *hotModel;



@end

NS_ASSUME_NONNULL_END
