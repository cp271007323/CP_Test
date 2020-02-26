//
//  NSString+YBCodec.h
//  Aa
//
//  Created by Aalto on 2018/11/20.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Extras)

/**
 *  判断对象 / 数组是否为空
 *  为空返回 YES
 *  不为空返回 NO
 */
+(BOOL)isEmptyStr:(NSString *)value;


+ (NSMutableAttributedString *)getAttributeStrWithString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
