//
//  QukanBasketLineupCollectionViewCell.h
//  Qukan
//
//  Created by Kody on 2020/1/2.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QukanBasketBallMatchDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QukanBasketLineupCollectionViewCell : UICollectionViewCell

- (void)setDataWithModel:(QukanBasketBallMatchDetailModel *)model withIndex:(NSInteger)index;
- (void)setDataWithModel:(QukanHomeAndGuestPlayerListModel *)model withSection:(NSInteger)section withIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
