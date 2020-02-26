//
//  QukanThemChildListVC.h
//  Qukan
//
//  Created by leo on 2019/10/5.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanThemChildListVC : UIViewController <JXPagerViewListViewDelegate>

/**控制器的父视图导航控制器  用于跳转*/
@property(nonatomic, strong) UINavigationController   * nav_superVC;

// 请求的主id
@property(nonatomic, assign) NSInteger   id_main;
// 请求的type
@property(nonatomic, assign) NSInteger   type_main;



@end

NS_ASSUME_NONNULL_END
