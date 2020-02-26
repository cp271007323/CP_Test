//
//  QukanBoilingPointTableView1Cell.h
//  Qukan
//
//  Created by mac on 2018/11/11.
//  Copyright © 2018 Ningbo Suda. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanBoilingPointTableView1Cell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIButton *followButton;
//@property (nonatomic, weak) IBOutlet UIImageView *headerImageView;
@property (nonatomic, weak) IBOutlet UILabel *contentLabel;
@property (nonatomic, weak) IBOutlet UILabel *otherLabel;

@property (nonatomic, copy) void(^followBlock)(int tag);

- (void)setData:(id)model;
@end

NS_ASSUME_NONNULL_END
