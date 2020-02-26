//
//  QukanNSDate+Time.m
//  UUCityManager
//
//  Created by huanghe on 11/13/16.
//
//

#import "QukanNSDate+Time.h"
#import "QukanNSDate+Relation.h"
#import "QukanNSDate+Extensions.h"

@implementation NSDate (Time)
//15558864328
//15558890702
/// 计算超时或剩余时间
+ (NSString *)overOrRemindTime:(long) time {
    long aTime = labs(time);
    aTime = aTime / 1000;
    long day = aTime / (24*3600);
    long hour = aTime / 3600 - day * 24;
    long minutes = aTime % 3600 / 60;
    
    return [NSString stringWithFormat:@"%ld天%ld时%ld分", day, hour, minutes];
}

+ (NSString*) stringFromFomate:(NSDate*) date formate:(NSString*)formate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formate];
    NSString *str = [formatter stringFromDate:date];
    return str;
}

+ (NSDate *) dateFromFomate:(NSString *)datestring formate:(NSString*)formate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formate];
    NSDate *date = [formatter dateFromString:datestring];
    return date;
}

- (NSString *)chatTimeInfo
{
    if ([self isToday]) {       // 今天
        return self.formatHM;
    }
    else if ([self isYesterday]) {      // 昨天
        return [NSString stringWithFormat:@"昨天 %@", self.formatHM];
    }
    else if ([self isThisWeek]){        // 本周
        return [NSString stringWithFormat:@"%@ %@", self.formatWeekday, self.formatHM];
    }else if ([self isLastWeek] && [self weekday] > [[NSDate date] weekday]) {
        return [NSString stringWithFormat:@"%@ %@", self.formatWeekday, self.formatHM];
    }
    else {
        return [NSString stringWithFormat:@"%@ %@", self.formatYMD, self.formatHM];
    }
}

- (NSString *)conversaionTimeInfo
{
    if ([self isToday]) {       // 今天
        return self.formatHM;
    }
    else if ([self isYesterday]) {      // 昨天
        return @"昨天";
    }
    else if ([self isThisWeek]){        // 本周
        return self.formatWeekday;
    }else if ([self isLastWeek] && [self weekday] > [[NSDate date] weekday]) {
        return self.formatWeekday;
    }
    else {
        return [self formatYMDWithSeparate:@"/"];
    }
}

- (NSString *)chatFileTimeInfo
{
    if ([self isThisWeek]) {
        return @"本周";
    }
    else if ([self isThisMonth]) {
        return @"这个月";
    }
    else {
        return [NSString stringWithFormat:@"%ld年%ld月", (long)self.year, (long)self.month];
    }
}

@end
