//
//  QukanBSKDetailPlayerCell.h
//  Qukan
//
//  Created by blank on 2019/12/26.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QukanBSKDataTeamDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface QukanBSKDetailPlayerCell : UITableViewCell
@property (nonatomic, strong)QukanPlayerList *model;
- (void)setRightLabsHidden:(BOOL)hidden;
@end

NS_ASSUME_NONNULL_END
