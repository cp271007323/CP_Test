//
//  QukanDailyHedaerBottomCell.h
//  Qukan
//
//  Created by leo on 2020/1/7.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QukanActionModel;
@class QukanDailyHedaerBottomCell;

@protocol QukanDailyHedaerBottomCellDelegate <NSObject>

- (void)QukanDailyHedaerBottomCellQukanLinqu_btnClick:(QukanDailyHedaerBottomCell *)cell;

@end


NS_ASSUME_NONNULL_BEGIN

@interface QukanDailyHedaerBottomCell : UICollectionViewCell

/***/
@property(nonatomic, strong) UIImageView   * QukanArrow_img;

/**<#说明#>*/
@property(nonatomic, weak) id<QukanDailyHedaerBottomCellDelegate>   delegate;

- (void)fullCellWithModel:(QukanActionModel *)model;

@end

NS_ASSUME_NONNULL_END
