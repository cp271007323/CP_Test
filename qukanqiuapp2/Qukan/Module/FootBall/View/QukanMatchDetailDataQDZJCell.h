//
//  QukanMatchDetailDataQDZJCell.h
//  Qukan
//
//  Created by leo on 2019/12/30.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QukanMatchDetailHistoryModel;
@class QukanBasketDetailHisFightData;

NS_ASSUME_NONNULL_BEGIN

@interface QukanMatchDetailDataQDZJCell : UITableViewCell

- (void)fullCellWithModel:(QukanMatchDetailHistoryModel *)model andIndex:(NSInteger)index homeName:(NSString *)homeName;


- (void)fullCellWithBasketModel:(QukanBasketDetailHisFightData *)model andIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
