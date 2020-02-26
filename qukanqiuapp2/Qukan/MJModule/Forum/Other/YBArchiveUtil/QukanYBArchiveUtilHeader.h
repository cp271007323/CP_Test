#ifndef QukanYBArchiveUtilHeader_h
#define QukanYBArchiveUtilHeader_h
#pragma mark - 头文件引用
#import <Foundation/Foundation.h>
#import "QukanYBArchiveUtil.h"
#import "QukanYBAutoArchive.h"
#import "QukanYBArchiveTool.h"
#import <objc/runtime.h>
#pragma mark - 实现归档解档的宏
#define YB_IMPLEMENTATION_CODE_WITH_CODER \
- (void)encodeWithCoder:(NSCoder *)aCoder { \
    NSArray * properNames = [self properNames]; \
    for (NSString * properName in properNames) { \
        id value = [self valueForKey:properName]; \
        if (value && properName) { \
            [aCoder encodeObject:value forKey:properName]; \
        } \
    } \
} \
 \
- (instancetype)initWithCoder:(NSCoder *)aDecoder { \
    if (self = [super init]) { \
        NSArray * properNames = [self properNames]; \
        for (NSString * properName in properNames) { \
            id value = [aDecoder decodeObjectForKey:properName]; \
            if (value && properName) { \
                [self setValue:value forKey:properName]; \
            } \
        } \
    } \
    return self; \
} \
 \
- (NSArray<NSString*>*)properNames { \
    unsigned int count; \
    Ivar * ivarList = class_copyIvarList([self class], &count); \
    NSMutableArray * propers = [NSMutableArray array]; \
    for (int i = 0; i<count; i++) { \
        Ivar ivar = ivarList[i]; \
        NSString *name = [NSString stringWithUTF8String:ivar_getName(ivar)];\
        NSString * key = [name substringFromIndex:1]; \
        [propers addObject:key]; \
    } \
    return propers; \
}
#pragma mark - C函数的extern
#if defined __cplusplus
extern "C" {
#endif
    int YBIsInDebugger(void);
#if defined __cplusplus
};
#endif
#pragma mark - 实现自定义断言的宏
extern BOOL YBDebugAssertionsShouldBreak;
#if defined(DEBUG)
#if TARGET_IPHONE_SIMULATOR
#define YBDASSERT(xx) { if (!(xx)) { YBDPRINT(@"YBDASSERT failed: %s", #xx); \
if (YBDebugAssertionsShouldBreak && YBIsInDebugger()) { __asm__("int $3\n" : : ); } } \
} ((void)0)
#else
#define YBDASSERT(xx) { if (!(xx)) { YBDPRINT(@"YBDASSERT failed: %s", #xx); \
if (YBDebugAssertionsShouldBreak && YBIsInDebugger()) { raise(SIGTRAP); } } \
} ((void)0)
#endif 
#else
#define YBDASSERT(xx) ((void)0)
#endif 
#pragma mark - 其他
#endif 
