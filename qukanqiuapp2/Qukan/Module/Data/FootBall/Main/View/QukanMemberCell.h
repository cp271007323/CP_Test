//
//  QukanMemberCell.h
//  Qukan
//
//  Created by Charlie on 2019/12/25.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QukanFTPlayerGoalModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface QukanMemberCell : UITableViewCell
@property (strong, nonatomic) UILabel *label_1;
@property (strong, nonatomic) UIImageView *avatarImgV;
@property (strong, nonatomic) UILabel *label_2;
@property (strong, nonatomic) UILabel *label_3;
@property (strong, nonatomic) UILabel *label_4;
- (void)setModel:(QukanFTPlayerGoalModel*)model;
@end

NS_ASSUME_NONNULL_END
