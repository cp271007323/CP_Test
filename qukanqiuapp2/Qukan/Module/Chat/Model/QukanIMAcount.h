//
//  QukanIMAcount.h
//  Qukan
//
//  Created by pfc on 2019/8/15.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanIMAcount : NSObject

@property(nonatomic, copy) NSString *fromAccid;
@property(nonatomic, copy) NSString *token;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *toAccid;

@end

NS_ASSUME_NONNULL_END
