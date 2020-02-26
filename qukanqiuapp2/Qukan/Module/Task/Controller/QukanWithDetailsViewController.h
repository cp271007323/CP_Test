//
//  Qukan
//
//  Created by hello on 2019/8/22.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QukanListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface QukanWithDetailsViewController : UITableViewController

@property (assign, nonatomic)  NSInteger index;

@property (strong, nonatomic)  QukanListModel *model;

@property (strong, nonatomic)  NSArray *arrModel;
@end

NS_ASSUME_NONNULL_END
