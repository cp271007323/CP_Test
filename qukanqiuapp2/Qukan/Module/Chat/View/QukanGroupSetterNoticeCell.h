//
//  QukanGroupSetterNoticeCell.h
//  Qukan
//
//  Created by Mac on 2020/2/24.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanGroupSetterNoticeCell : UITableViewCell

/// 替换对应的模型，并重写settter方法
@property (nonatomic , strong) NSString *model;

+ (NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
