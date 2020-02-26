//
//  QukanStrokeAnalysisTableViewCell.h
//  Qukan
//
//  Created by Kody on 2019/12/27.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QukanBasketBallMatchDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QukanStrokeAnalysisTableViewCell : UITableViewCell

//篮球的属性
@property (nonatomic, strong)NSArray <QukanHomeAndGuestPlayerListModel *> *guestList;
@property (nonatomic, strong)NSArray <QukanHomeAndGuestPlayerListModel *> *homeList;
@property(nonatomic, strong) NSArray <NSString *> *titles;

- (void)setFootDataWithArray:(NSArray *)array;
- (void)setBasketDataWithIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
