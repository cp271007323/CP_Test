#import <Foundation/Foundation.h>
@interface QukanScreenTableModel : NSObject
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, copy) NSString *gbShort;
@property (nonatomic, copy) NSString *leagueId;
@property (nonatomic, assign) NSInteger matchCount;
- (instancetype)initQukan_WithDict:(NSDictionary *)dict;
@end
