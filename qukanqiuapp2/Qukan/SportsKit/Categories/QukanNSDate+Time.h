//
//  QukanNSDate+Time.h
//  UUCityManager
//
//  Created by huanghe on 11/13/16.
//
//

#import <Foundation/Foundation.h>

#define kTimeFormart @"yyyy-MM-dd"
#define kTimeDetail_Format @"yyyy-MM-dd HH:mm:ss"

@interface NSDate (Time)

+ (NSString *)overOrRemindTime:(long) time;

+ (NSString*)stringFromFomate:(NSDate*) date formate:(NSString*)formate;

+ (NSDate *)dateFromFomate:(NSString *)datestring formate:(NSString*)formate;

- (NSString *)chatTimeInfo;
- (NSString *)conversaionTimeInfo;

@end
