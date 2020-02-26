//
//  QukanMatchOnlyOneImgCellTableViewCell.h
//  Qukan
//
//  Created by leo on 2019/9/2.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanMatchOnlyOneImgCellTableViewCell : UITableViewCell

@property(nonatomic, strong) UIImageView   * img_main;
@property(nonatomic, strong) UIView   * view_top;
@property(nonatomic, strong) UIView   * view_bottom;

@property(nonatomic, strong) UIView   * view_topBall;
@property(nonatomic, strong) UIView   * view_bottomBall;

- (void)fullCellWithState:(NSString *)state;

@end

NS_ASSUME_NONNULL_END
