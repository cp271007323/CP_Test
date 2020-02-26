//
//  QukanMessageTableViewCell.h
//  Qukan
//
//  Created by Kody on 2019/8/14.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QukanMessageModel;
NS_ASSUME_NONNULL_BEGIN

@interface QukanMessageTableViewCell : UITableViewCell

@property(nonatomic, strong) UIImageView      *headerImageView;
@property(nonatomic, strong) UILabel     *typeLabel;
@property(nonatomic, strong) UILabel     *contentLabel;
@property(nonatomic, strong) UILabel     *timeLabel;
@property(nonatomic, strong) UILabel     *unreadLabel;
@property(nonatomic, strong) UIView    * view_redPoint;

- (void)Qukan_SetMessageWith:(QukanMessageModel *__nullable)model WithType:(NSInteger)type;

@end

NS_ASSUME_NONNULL_END
