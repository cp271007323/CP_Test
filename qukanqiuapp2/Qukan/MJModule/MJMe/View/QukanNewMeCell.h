//
//  QukanNewMeCell.h
//  Qukan
//
//  Created by mac on 2018/11/18.
//  Copyright © 2018 Ningbo Suda. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanNewMeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImagView;

@property (weak, nonatomic) IBOutlet UILabel *lab_unReadNum;
@property (weak, nonatomic) IBOutlet UIView *view_redPoint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_left;
- (void)setArrow;
@end

NS_ASSUME_NONNULL_END
