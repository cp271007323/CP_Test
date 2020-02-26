#import <UIKit/UIKit.h>
@interface QukanScreenSelectedView : UIView
@property (nonatomic, copy) void(^Qukan_selectedBlick)(NSInteger index);
@property (nonatomic, weak) IBOutlet UILabel *matchCountLabel;

@property(nonatomic, assign) BOOL selectAll;
@end
