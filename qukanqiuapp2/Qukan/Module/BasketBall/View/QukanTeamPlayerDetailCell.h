//
//  QukanTeamPlayerDetailCell.h
//  Qukan
//
//  Created by leo on 2019/9/4.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QukanBasketBallMatchDetailModel.h"
#define QukanTeamPlayerDetailListCellHeight 30
NS_ASSUME_NONNULL_BEGIN

@interface QukanTeamPlayerDetailCell : UITableViewCell
@property (nonatomic, strong)NSString *teamName;
- (void)setHomePlayers:(NSArray<QukanHomeAndGuestPlayerListModel *> * _Nonnull)homePlayers;
- (void)setGuestPlayers:(NSArray<QukanHomeAndGuestPlayerListModel *> * _Nonnull)guestPlayers;
@end

NS_ASSUME_NONNULL_END
