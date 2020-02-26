//
//  QukanBasketDetailDataCell.h
//  Qukan
//
//  Created by leo on 2020/1/3.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QukanBasketDetailDataModel;
NS_ASSUME_NONNULL_BEGIN

@interface QukanBasketDetailDataCell : UITableViewCell


- (void)fullCellWitModel:(QukanBasketDetailDataModel *)model andType:(NSInteger)type;

@end

NS_ASSUME_NONNULL_END
