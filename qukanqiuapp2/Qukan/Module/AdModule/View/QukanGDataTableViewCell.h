//
//  QukanGDataTableViewCell.h
//  Qukan
//
//  Created by Kody on 2019/8/8.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QukanHomeModels;
NS_ASSUME_NONNULL_BEGIN

/// 广告cell
@interface QukanGDataTableViewCell : UITableViewCell

- (void)Qukan_SetNewsGDataWith:(QukanHomeModels *__nullable)model;

@end

NS_ASSUME_NONNULL_END
