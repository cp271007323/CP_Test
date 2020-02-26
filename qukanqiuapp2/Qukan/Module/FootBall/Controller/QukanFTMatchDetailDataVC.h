//
//  QukanFTMatchDetailDataVC.h
//  Qukan
//
//  Created by leo on 2019/12/30.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>


@class QukanMatchInfoContentModel;
NS_ASSUME_NONNULL_BEGIN

@interface QukanFTMatchDetailDataVC : UIViewController<JXPagerViewListViewDelegate>

// 比赛主模型
@property (nonatomic, strong) QukanMatchInfoContentModel *model_main;

@end

NS_ASSUME_NONNULL_END
