//
//  QukanChatMemberCell.h
//  Qukan
//
//  Created by Mac on 2020/2/22.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanChatMemberCell : UITableViewCell

/// 线距离左边的间距
- (void)lineForLeftSpace:(CGFloat)space;

+ (NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
