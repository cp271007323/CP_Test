//
//  QukanGDataTableViewCell.h
//  Qukan
//
//  Created by Kody on 2019/8/8.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QukanHomeModels.h"

NS_ASSUME_NONNULL_BEGIN

@interface QukanHotGTableViewCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *_Nullable)reuseIdentifier;
- (void)Qukan_setDataWith:(QukanHomeModels  *)model;

@end

NS_ASSUME_NONNULL_END
