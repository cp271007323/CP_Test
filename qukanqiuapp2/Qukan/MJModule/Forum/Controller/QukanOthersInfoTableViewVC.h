//
//  OthersInfoTableViewVC.h
//  Haokan
//
//  Created by Charlie on 2019/10/15.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class QukanBolingPointListModel;

@interface QukanOthersInfoTableViewVC : UITableViewController

-(instancetype)initWithModel:(QukanBolingPointListModel*)model;

@end

NS_ASSUME_NONNULL_END
