//
//  QukanMatchDetailDataJSTJCell.h
//  Qukan
//
//  Created by leo on 2019/12/30.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QukanMatchDetailJSTJModel;
NS_ASSUME_NONNULL_BEGIN

@interface QukanMatchDetailDataJSTJCell : UITableViewCell


- (void)fullCellWithData:(QukanMatchDetailJSTJModel *)model andIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
