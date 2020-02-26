//
//  QukanBSKDataScheduleModel.m
//  Qukan
//
//  Created by blank on 2019/12/29.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QukanBSKDataScheduleModel.h"

@implementation QukanBSKDataScheduleModel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (NSString *)getMatchNode {
    NSString *node = @"";
    switch (self.status.integerValue) {
        case 1:
            node = @"第一节";
            break;
        case 2:
            node = @"第二节";
            break;
        case 3:
            node = @"第三节";
            break;
        case 4:
            node = @"第四节";
            break;
        case 5:
            node = @"加时赛";
            break;
        case 6:
            node = @"加时赛";
            break;
        case 7:
            node = @"加时赛";
            break;
        case 50:
            node = @"中场休息";
            break;
        default:
            break;
    }
    
    return node;
}

- (NSString*)weekDayStr:(NSString*)format{
    
    NSString *weekDayStr = nil;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    if(format.length>=10) {
        NSString *nowString = [format substringToIndex:10];
        NSArray *array = [nowString componentsSeparatedByString:@"-"];
        if(array.count==0) {
            array = [nowString componentsSeparatedByString:@"/"];
        }
        
        if(array.count>=3) {
            NSInteger year = [[array objectAtIndex:0] integerValue];
            NSInteger month = [[array objectAtIndex:1] integerValue];
            NSInteger day = [[array objectAtIndex:2] integerValue];
            [comps setYear:year];
            [comps setMonth:month];
            [comps setDay:day];
        }
    }
    //日历
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //获取传入date
    NSDate *_date = [gregorian dateFromComponents:comps];
    
    NSDateComponents *weekdayComponents = [gregorian components:NSCalendarUnitWeekday fromDate:_date];
    NSInteger week = [weekdayComponents weekday];
    switch(week) {
        case 1:
            weekDayStr =@"星期日";
            break;
        case 2:
            weekDayStr =@"星期一";
            break;
        case 3:
            weekDayStr =@"星期二";
            break;
        case 4:
            weekDayStr =@"星期三";
            break;
        case 5:
            weekDayStr =@"星期四";
            break;
        case 6:
            weekDayStr =@"星期五";
            break;
        case 7:
            weekDayStr =@"星期六";
            break;
        default:
            weekDayStr =@"";
            break;
    }
    return weekDayStr;
}
@end
