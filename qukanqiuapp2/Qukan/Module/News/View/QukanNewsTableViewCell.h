//
//  QukanNewsTableViewCell.h
//  Qukan
//
//  //  Created by pfc on 2019/7/16.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYLabel.h>
#import "QukanNewsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QukanNewsTableViewCell : UITableViewCell
@property(nonatomic,copy) void(^cellAction)(NSInteger actionType);

- (void)setDataWithModel:(QukanNewsModel *)model;

- (void)showComment;
- (void)highLightKeyword:(NSString *)keyword;
@end

NS_ASSUME_NONNULL_END
