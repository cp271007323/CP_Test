//
//  QukanBattleReportVideoTableViewCell.h
//  Qukan
//
//  Created by Kody on 2019/12/26.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QukanNewsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QukanBattleReportVideoTableViewCell : UITableViewCell

@property(nonatomic, copy) void (^playBtnCilckBlock)(QukanNewsModel *model);

- (void)setDataWithModel:(QukanNewsModel *)model;

- (void)showMaskView;

- (void)hideMaskView;

- (void)setNormalMode;

@end

NS_ASSUME_NONNULL_END
