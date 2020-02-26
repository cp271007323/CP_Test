//
//  QukanJiShiViewController.h
//  Qukan
//
//  Created by hello on 2019/9/10.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JXCategoryView/JXCategoryListContainerView.h>
NS_ASSUME_NONNULL_BEGIN

@interface QukanJiShiViewController : UIViewController<JXCategoryListContentViewDelegate>

/**选中的ids*/
@property (nonatomic, copy) NSString *Qukan_leagueIds;
/** 赛事赛选类型， 1 全部 2 热门 */
@property(nonatomic,  assign) NSInteger  int_xType;

// 用于跳转的导航栏
@property(nonatomic, weak) UINavigationController *navController;


/**
 把筛选id数据存在vc中

 @param leagueIds 选中的id
 */
- (void)resetLegueidsWithLegueids:(NSString *)legueids;

@end

NS_ASSUME_NONNULL_END
