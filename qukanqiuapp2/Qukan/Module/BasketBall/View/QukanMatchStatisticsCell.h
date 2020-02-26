//
//  QukanMatchStatisticsCell.h
//  Qukan
//
//  Created by leo on 2019/9/4.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QukanBasketBallMatchDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface QukanMatchStatisticsCell : UITableViewCell

- (void)fullCellWithData:(QukanBasketBallMatchDetailModel *)detailModel;

@end

NS_ASSUME_NONNULL_END
