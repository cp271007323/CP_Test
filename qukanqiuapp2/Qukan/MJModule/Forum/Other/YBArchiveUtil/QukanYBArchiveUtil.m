#import "QukanYBArchiveUtil.h"
#import "QukanYBArchiveUtilHeader.h"
#define DEFAULT_STORE_PATH_KEY @"kYBStorePathKey"
#define DEFAULT_STORE_PATH_NAME @"kYBDefaultPathName"
@implementation QukanYBArchiveUtil
+ (void)setPlistPathName:(NSString *)pathName {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *defaultPathName = [defaults objectForKey:DEFAULT_STORE_PATH_KEY];
    if (defaultPathName) { return; }
    [defaults setObject:(pathName?pathName:DEFAULT_STORE_PATH_NAME) forKey:DEFAULT_STORE_PATH_KEY];
    [defaults synchronize];
}
+ (BOOL)saveObject:(id)obj withFilePathName:(NSString *)filePathName {
    if (![self checkEncodeWithCoder:obj]) {
        YBDPRINT(@"%@ 没有实现encodeWithCoder方法",obj);
        YBDASSERT([self checkEncodeWithCoder:obj]);
        return NO;
    }
    return [NSKeyedArchiver archiveRootObject:obj toFile:[self getFilePathWithFilePathName:filePathName]];
}
+ (id)getObjectWithFilePathName:(NSString *)filePathName {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[self getFilePathWithFilePathName:filePathName]];
}
+ (BOOL)removeObjectWithFilePathName:(NSString *)filePathName {
    if (!filePathName) {
        YBDASSERT(filePathName);
        return NO;
    }
    NSFileManager * fileManager = [NSFileManager defaultManager];
    BOOL exist = [fileManager fileExistsAtPath:[self getFilePathWithFilePathName:filePathName]];
    if (exist) {
        exist =  [fileManager removeItemAtPath:[self getFilePathWithFilePathName:filePathName] error:nil];
    }
    return exist;
}
+ (BOOL)saveObjects:(NSArray *)objs forFlag:(NSString*)flag withFilePathName:(NSString *)filePathName
{
    for (id obj in objs) {
        if (![self checkEncodeWithCoder:obj]) {
            YBDPRINT(@"%@ 没有实现encodeWithCoder方法",obj);
            YBDASSERT([self checkEncodeWithCoder:obj]);
            return NO;
        }
    }
    NSMutableData * data = [[NSMutableData alloc]init];
    NSKeyedArchiver * archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:objs forKey:flag];
    [archiver finishEncoding];
    BOOL success =  [data writeToFile:[self getFilePathWithFilePathName:filePathName] atomically:YES];
    return success;
}
+ (NSArray *)getObjectsForFlag:(NSString*)flag withFilePathName:(NSString *)filePathName
{
    NSData *data = [[NSData alloc] initWithContentsOfFile:[self getFilePathWithFilePathName:filePathName]];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSArray * array = [unarchiver decodeObjectForKey:flag];
    return array;
}
+ (BOOL)checkEncodeWithCoder:(id)obj {
    return ([obj respondsToSelector:@selector(encodeWithCoder:)]);
}
+ (NSString*)getFilePathWithFilePathName:(NSString *)filePathName
{
    NSString *path = @"";
    NSArray *documentsPathArr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *cache = [documentsPathArr firstObject];
    if (filePathName && filePathName.length>0) {
        path = [NSString stringWithFormat:@"%@/%@.plist",cache,filePathName];
    }else {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        NSString *pathName = [defaults valueForKey:DEFAULT_STORE_PATH_KEY];
        if (pathName) {
            path = [NSString stringWithFormat:@"%@/%@.plist",cache,pathName];
        }else {
            [defaults setObject:DEFAULT_STORE_PATH_NAME forKey:DEFAULT_STORE_PATH_KEY];
            path = [NSString stringWithFormat:@"%@/%@.plist",cache,DEFAULT_STORE_PATH_NAME];
        }
    }
    return path;
}
@end
