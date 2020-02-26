//
//  QukanBasketScreeningViewController.h
//  Qukan
//
//  Created by leo on 2019/9/12.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanBasketScreeningViewController : UIViewController


/**进入时的下标 1-即时， 2-赛程， 3-赛果*/
@property(nonatomic,assign)NSInteger Qukan_type;
/**所有选中联赛的id  用于传输数据*/
@property(nonatomic,copy)  NSString *Qukan_leagueIds;
/**选中的日期  筛选赛程和赛果时需要*/
@property(nonatomic,assign)NSInteger Qukan_fixDays;
/**看不懂用来干嘛*/
@property(nonatomic,assign)BOOL Qukan_all;
/**成功回调  返回所选的ids  和选中的下标  1 全部 2 热门 */
@property (nonatomic, copy)void(^selectCompletBlock)(NSString *ids, NSInteger type, NSInteger chooseType);

@end

NS_ASSUME_NONNULL_END
