//
//  QukanBasketIineupViewController.h
//  Qukan
//
//  Created by Kody on 2020/1/2.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface QukanBasketIineupViewController : UIViewController <JXPagerViewListViewDelegate>

@property(nonatomic, copy) NSString   *matchId;
@property(nonatomic, strong) UINavigationController *navgiation_vc;

@end

NS_ASSUME_NONNULL_END
