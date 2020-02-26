//
//  QukanChangeTableViewCell.h
//  Qukan
//
//  Created by Kody on 2019/8/14.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QukanScreenModel;
NS_ASSUME_NONNULL_BEGIN

@interface QukanChangeTableViewCell : UITableViewCell

- (void)Qukan_SetScreenWith:(QukanScreenModel *__nullable)model;

@end

NS_ASSUME_NONNULL_END
