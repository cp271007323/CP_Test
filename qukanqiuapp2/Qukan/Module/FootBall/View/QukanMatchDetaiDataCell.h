//
//  QukanMatchDetaiJSTJCell.h
//  Qukan
//
//  Created by leo on 2019/12/30.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QukanMatchDetailJSTJModel;
NS_ASSUME_NONNULL_BEGIN

@interface QukanMatchDetaiDataCell : UITableViewCell

/**队名lab*/
@property(nonatomic, strong) UILabel   * lab_homeName;
// 技术统计
- (void)fullCellWithJSTJData:(QukanMatchDetailJSTJModel *)model;

@end

NS_ASSUME_NONNULL_END
