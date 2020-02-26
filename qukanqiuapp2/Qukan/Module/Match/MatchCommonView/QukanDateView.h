#import <UIKit/UIKit.h>
@interface QukanDateView : UIView
@property (nonatomic, copy) void(^Qukan_didSelectItemBlock)(NSInteger dateType);
@property (nonatomic, copy) NSString *Qukan_tomorrow;
@property (nonatomic, assign) NSInteger Qukan_tomorrowDateType;
@property (nonatomic, copy) NSString *Qukan_yesterday;
@property (nonatomic, assign) NSInteger Qukan_yesterdayDateType;
- (BOOL)Qukan_setFirstSevenDaysData;
- (BOOL)Qukan_setNextSevenDaysData;
//- (BOOL)Qukan_setFirstSevenDaysDataWithSeversTime:(NSString *)seversTime;
@end
