//
//  QukanDailyHeaderCenterCell.h
//  Qukan
//
//  Created by leo on 2020/1/7.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QukanActionModel;
@class QukanDailyHeaderCenterCell;


@protocol QukanDailyHeaderCenterCellDelegate <NSObject>
- (void)QukanDailyHeaderCenterCellQukanLinqu_btnClick:(QukanDailyHeaderCenterCell *_Nullable)cell;

@end

NS_ASSUME_NONNULL_BEGIN

@interface QukanDailyHeaderCenterCell : UICollectionViewCell

/***/
@property(nonatomic, strong) UIImageView   * QukanArrow_img;

/***/
@property(nonatomic, weak) id<QukanDailyHeaderCenterCellDelegate>   delegate;

- (void)fullCellWithModel:(QukanActionModel *)model;
@end

NS_ASSUME_NONNULL_END
