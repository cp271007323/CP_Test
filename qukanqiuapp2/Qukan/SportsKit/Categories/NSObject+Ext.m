//
//  NSObject+Ext.m
//  Qukan
//
//  Created by Jeff on 2020/1/8.
//  Copyright © 2020 mac. All rights reserved.
//

#import "NSObject+Ext.h"

@protocol QukanModelMap <NSObject>

@optional
/// 自定义属性映射
+ (NSDictionary *)QukanCustomMapProperty;

@end

@implementation NSObject (Ext)

+ (NSArray<NSString *> *)QukanGetPropertiesArray {
    // 获取当前类的所有属性
    unsigned int count;// 记录属性个数
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    // 遍历
    NSMutableArray *mArray = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        // An opaque type that represents an Objective-C declared property.
        // objc_property_t 属性类型
        objc_property_t property = properties[i];
        // 获取属性的名称 C语言字符串
        const char *cName = property_getName(property);
        // 转换为Objective C 字符串
        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
        [mArray addObject:name];
    }
    
    return mArray.copy;
}

#pragma mark - model映射处理，基于YYModel

//+ (NSDictionary *)modelCustomPropertyMapper {
//    NSMutableDictionary *dic = [self QukanGetModelCustomMapDictionary];
//    
//    if ([self respondsToSelector:@selector(QukanCustomMapProperty)]) {
//        NSDictionary *map = [(id<QukanModelMap>)self QukanCustomMapProperty];
//        [map enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
//            [dic setObject:obj forKey:key];
//        }];
//    }
//    
//    return dic;
//}

///（因为项目所有Model属性统一添加前缀Qukan) 所以使用YYModel映射时，要把前缀截掉，以获取Model属性和服务器字段的映射
+ (NSMutableDictionary *)QukanGetModelCustomMapDictionary {
    NSArray *pnames = [self QukanGetPropertiesArray];
    
    NSMutableDictionary *dic = @{}.mutableCopy;
    NSString *prefix = @"Qukan";
    
    for (NSString *name in pnames) {
        if ([name hasPrefix:prefix]) {
            NSRange range = [name rangeOfString:prefix];
            dic[name] = [name substringFromIndex:range.length];
        }else {
            dic[name] = name;
        }
    }
    
    return dic;
}

@end
