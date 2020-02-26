//
//  QukanShowStatisticsCell.h
//  Qukan
//
//  Created by leo on 2019/9/4.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QukanBasketBallMatchDetailModel.h"
#define QukanShowStatisticsListCellHeight 31
 
NS_ASSUME_NONNULL_BEGIN

@interface QukanShowStatisticsCell : UITableViewCell
@property (nonatomic, strong)QukanBasketBallMatchDetailModel *detailModel;
@end

NS_ASSUME_NONNULL_END
