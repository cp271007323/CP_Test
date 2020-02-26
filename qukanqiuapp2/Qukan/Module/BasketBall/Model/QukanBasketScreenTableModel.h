//
//  QukanBasketScreenTableModel.h
//  Qukan
//
//  Created by leo on 2019/9/12.
//  Copyright © 2019 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanBasketScreenTableModel : NSObject


@property(nonatomic, assign) NSInteger    countz;
@property(nonatomic, copy)  NSString   * leagueName;
@property(nonatomic, assign) NSInteger    sclassId;
@property(nonatomic, assign) BOOL  selected;

@end

NS_ASSUME_NONNULL_END
