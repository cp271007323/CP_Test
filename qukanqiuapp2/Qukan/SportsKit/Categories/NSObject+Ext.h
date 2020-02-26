//
//  NSObject+Ext.h
//  Qukan
//
//  Created by Jeff on 2020/1/8.
//  Copyright © 2020 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Ext)

+ (NSArray<NSString *> *)QukanGetPropertiesArray;

///（因为项目所有Model属性统一添加前缀Qukan) 所以使用YYModel映射时，要把前缀截掉，以获取Model属性和服务器字段的映射
//+ (NSMutableDictionary *)QukanGetModelCustomMapDictionary;

@end

NS_ASSUME_NONNULL_END
