#import <Foundation/Foundation.h>
@interface QukanYBArchiveUtil : NSObject
+ (void)setPlistPathName:(NSString*)pathName;
+ (BOOL)saveObject:(id)obj withFilePathName:(NSString *)filePathName;
+ (id)getObjectWithFilePathName:(NSString *)filePathName;
+ (BOOL)removeObjectWithFilePathName:(NSString *)filePathName;
+ (BOOL)saveObjects:(NSArray *)objs forFlag:(NSString*)flag withFilePathName:(NSString *)filePathName;
+ (NSArray *)getObjectsForFlag:(NSString*)flag withFilePathName:(NSString *)filePathName;
+ (BOOL)checkEncodeWithCoder:(id)obj;
@end
