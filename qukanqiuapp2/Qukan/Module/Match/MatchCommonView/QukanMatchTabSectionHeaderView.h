//
//  QukanMatchTabSectionHeaderView.h
//  Qukan
//
//  Created by leo on 2019/12/26.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanMatchTabSectionHeaderView : UITableViewHeaderFooterView

@property(nonatomic, strong) UIColor *view_bg_color;
@property(nonatomic, strong) UIColor *view_WhirtBg_color;

/**同主客*/
@property(nonatomic, copy) void (^sameTeamBlock)(BOOL isSelect);
/**同赛事*/
@property(nonatomic, copy) void (^sameMatchBlock)(BOOL isSelect);

/**多的*/
@property(nonatomic, copy) void (^moreBlock)(void);
/**少的*/
@property(nonatomic, copy) void (^lessBlock)(void);




// 没有赛事按钮
- (void)fullHeaderWithTitle:(NSString *)titleStr;

// 带赛事按钮
- (void)fullShowBtnHeaderWithTitle:(NSString *)titleStr sameMatch:(BOOL)sameMatch sameTeam:(BOOL)sameTeam type:(NSInteger)type andMaxCount:(NSInteger)maxCount;
@end

NS_ASSUME_NONNULL_END
