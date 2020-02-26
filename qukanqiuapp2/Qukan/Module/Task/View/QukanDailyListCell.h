//
//  QukanDailyListCell.h
//  Qukan
//
//  Created by leo on 2020/1/7.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QukanTModel;
@class QukanDailyListCell;
@protocol QukanDailyListCellDelegate <NSObject>

- (void)QukanDailyListCellQukanNoLinqu_btnClick:(QukanDailyListCell *_Nullable)cell;

- (void)QukanDailyListCellQukanNoComplet_btnClick:(QukanDailyListCell *_Nullable)cell;

@end

NS_ASSUME_NONNULL_BEGIN

@interface QukanDailyListCell : UITableViewCell

/**cell代理*/
@property(nonatomic, weak) id<QukanDailyListCellDelegate>    delegate;

- (void)fullCellWithModel:(QukanTModel *)model;

@end

NS_ASSUME_NONNULL_END
