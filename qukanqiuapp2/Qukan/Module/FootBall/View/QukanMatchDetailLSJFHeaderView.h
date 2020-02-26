//
//  QukanMatchDetailLSJFHeaderView.h
//  Qukan
//
//  Created by leo on 2020/1/1.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QukanMatchDetailHistoryModel;
NS_ASSUME_NONNULL_BEGIN

@interface QukanMatchDetailLSJFHeaderView : UIView

- (void)fullHeaderWithJFLSData:(NSMutableArray<QukanMatchDetailHistoryModel *> *)arr_lsjf;


@end

NS_ASSUME_NONNULL_END
