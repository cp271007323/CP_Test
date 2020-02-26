//
//  QukanShowDtaCell.h
//  Qukan
//
//  Created by leo on 2019/9/4.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QukanBasketBallMatchDetailModel.h"

#define PlayerDtaCellHeight 80

NS_ASSUME_NONNULL_BEGIN

@interface QukanShowDtaCell : UITableViewCell

@property(nonatomic, copy) void (^playerCilckBlock)(QukanHomeAndGuestPlayerListModel *model);

- (void)setHomePlayers:(NSArray<QukanHomeAndGuestPlayerListModel *> * _Nonnull)homePlayers guestPlayers:(NSArray<QukanHomeAndGuestPlayerListModel *> * _Nonnull)guestPlayers;
@end

NS_ASSUME_NONNULL_END
