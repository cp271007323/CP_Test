//
//  QukanBasketPlayerDataTableViewCell.h
//  Qukan
//
//  Created by Kody on 2020/1/2.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QukanBasketBallMatchDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QukanBasketPlayerDataTableViewCell : UITableViewCell

@property(nonatomic, copy) void (^playerCilckBlock)(NSInteger flag);

- (void)setHomePlayerModel:(QukanHomeAndGuestPlayerListModel *)homePlayerModel guestPlayerModel:(QukanHomeAndGuestPlayerListModel *)guestPlayerModel indexPathRow:(NSInteger)indexPathRow midTitle:(NSString *)midTitle;

@end

NS_ASSUME_NONNULL_END
