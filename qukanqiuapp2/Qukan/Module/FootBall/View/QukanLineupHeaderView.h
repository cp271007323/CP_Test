#import <UIKit/UIKit.h>
@interface QukanLineupHeaderView : UIView
/**<#说明#>*/
@property(nonatomic, copy) NSString   * str_homeName;
/**<#说明#>*/
@property(nonatomic, copy) NSString   * str_awayName;

- (void)Qukan_setData:(NSDictionary *)dict;
@end
