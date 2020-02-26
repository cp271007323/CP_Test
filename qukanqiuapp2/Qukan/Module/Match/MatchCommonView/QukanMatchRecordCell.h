//
//  QukanMatchDetaiJSTJCell.h
//  Qukan
//
//  Created by leo on 2019/12/30.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QukanMatchDetailHistoryModel;
@class QukanBasketDetailHisFightData;
NS_ASSUME_NONNULL_BEGIN

@interface QukanMatchRecordCell : UITableViewCell

/**队名lab*/
@property(nonatomic, strong) UILabel   * lab_homeName;
@property(nonatomic, strong) NSString *homeName;

// 球队历史交锋数据
- (void)fullCellWithJFLSData:(NSMutableArray<QukanMatchDetailHistoryModel *> *)arr_lsjf;
// 近期战绩
- (void)fullCellWithQDZJData:(NSMutableArray<QukanMatchDetailHistoryModel *> *)arr_jqzj;

// 蓝球球队历史交锋数据
- (void)fullCellWithBasketJFLSData:(NSMutableArray <QukanBasketDetailHisFightData *> *)arr_basketLsjf;
// 蓝球球队近期战绩
- (void)fullCellWithBasketQDZJData:(NSMutableArray <QukanBasketDetailHisFightData *> *)arr_basketQdzj;

@end

NS_ASSUME_NONNULL_END
