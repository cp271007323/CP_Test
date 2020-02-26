//
//  QukanMessageDetailCell.h
//  Qukan
//
//  Created by leo on 2019/11/17.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QukanMessageModel;
NS_ASSUME_NONNULL_BEGIN

@interface QukanMessageDetailCell : UITableViewCell

@property(nonatomic, strong) UIImageView      *headerImageView;

@property(nonatomic, strong) UILabel     *contentLabel;

@property(nonatomic, strong) UILabel     *timeLabel;

@property(nonatomic, strong) UILabel     *unreadLabel;

@property(nonatomic, strong) UIView   * view_line;


- (void)fullcellWithModel:(QukanMessageModel *__nullable)model;

@end

NS_ASSUME_NONNULL_END
