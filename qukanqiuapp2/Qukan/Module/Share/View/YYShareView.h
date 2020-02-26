 
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YYShareViewItemType) {
    YYShareViewItemWeibo = 0,       // 新浪微博
    YYShareViewItemWeChat = 1,      // 微信
    YYShareViewItemPengYouQuan = 2, // 朋友圈
    YYShareViewItemQQ = 4,          // QQ
    YYShareViewItemQzone = 5,       // QQ控件
    YYShareViewItemCopyLink,        // 复制链接
    YYShareViewItemSystem,          // 系统分享
    YYShareViewItemOther            // 其他
};
 
@protocol YYShareViewDelegate <NSObject>

@required
- (void)didSelectShareBtnWithType:(YYShareViewItemType)itemType;

@end

@interface YYShareView : UIView

- (instancetype)initWithFrame:(CGRect)frame clickblock:(void (^)(YYShareViewItemType type))shareTypeblock;

@property (nonatomic, weak) id<YYShareViewDelegate> delegate;

/** 显示视图*/
- (void)show;

/** 关闭视图*/
- (void)dismiss;

@end
