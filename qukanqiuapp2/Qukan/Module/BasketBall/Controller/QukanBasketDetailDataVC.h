//
//  QukanBasketDetailDataVC.h
//  Qukan
//
//  Created by leo on 2020/1/3.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>


@class QukanBasketBallMatchModel;
NS_ASSUME_NONNULL_BEGIN

@interface QukanBasketDetailDataVC : UIViewController<JXPagerViewListViewDelegate>


/**主模型*/
@property(nonatomic, copy) NSString    *QukanMainMatchId_str;

@end

NS_ASSUME_NONNULL_END
