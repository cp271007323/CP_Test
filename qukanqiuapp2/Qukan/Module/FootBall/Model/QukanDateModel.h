#import <Foundation/Foundation.h>
@interface QukanDateModel : NSObject
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, assign) NSInteger dateType;
@property (nonatomic, copy) NSString *week;

@end
