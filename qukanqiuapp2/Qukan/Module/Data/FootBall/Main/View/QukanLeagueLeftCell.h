//
//  QukanLeagueLeftCell.h
//  Qukan
//
//  Created by leo on 2019/10/30.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "QukanLeagueInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HighLightLabel : UILabel

@end


@interface QukanLeagueLeftCell : UITableViewCell

@property(nonatomic, strong) HighLightLabel   * lab_teamName;

- (void)fullCellWithModel:(QukanLeagueInfoModel *)model;

@end

NS_ASSUME_NONNULL_END
