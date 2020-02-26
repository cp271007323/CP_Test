//
//  QukanBolingPointDetailVC.h
//  Qukan
//
//  Created by leo on 2019/10/3.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QukanBolingPointListModel;

NS_ASSUME_NONNULL_BEGIN

@interface QukanBolingPointDetailVC : UIViewController

// 详情界面主模型
@property(nonatomic, strong) QukanBolingPointListModel   *model_main;

@property(nonatomic, copy) void(^modelInfoChange)(void);

@end

NS_ASSUME_NONNULL_END
