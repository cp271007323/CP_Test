//
//  QukanAnalysisHeaderTableViewCell.h
//  Qukan
//
//  Created by Kody on 2019/12/28.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QukanMatchInfoModel.h"
#import "QukanBasketBallMatchDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QukanAnalysisHeaderTableViewCell : UITableViewCell

//足球
- (void)setFootDataWithModel:(QukanMatchInfoContentModel *)model;

//篮球
- (void)setBasketDataWithModel:(QukanBasketBallMatchDetailModel *)model;

@end

NS_ASSUME_NONNULL_END
