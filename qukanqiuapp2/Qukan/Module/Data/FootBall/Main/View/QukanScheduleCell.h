//
//  QukanScheduleCell.h
//  Qukan
//
//  Created by Charlie on 2019/12/25.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QukanFTMatchScheduleModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QukanScheduleCell : UITableViewCell
- (void)setModel:(QukanFTMatchScheduleModel*)model;
@end

NS_ASSUME_NONNULL_END
