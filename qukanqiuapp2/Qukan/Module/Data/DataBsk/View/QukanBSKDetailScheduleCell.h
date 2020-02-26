//
//  QukanBSKDetailScheduleCell.h
//  Qukan
//
//  Created by blank on 2019/12/26.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QukanBSKDataTeamDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface QukanBSKDetailScheduleCell : UITableViewCell
@property (nonatomic, strong)NSString *teamId;
@property (nonatomic, strong)QukanSelectScheduleTeamModel *model;
@end

NS_ASSUME_NONNULL_END
