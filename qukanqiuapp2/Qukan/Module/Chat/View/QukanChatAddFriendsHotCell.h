//
//  QukanChatAddFriendsHotCell.h
//  Qukan
//
//  Created by Mac on 2020/2/22.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanChatAddFriendsHotCell : UITableViewCell

@property (nonatomic , strong) NSArray<NSString *> *ids;

+ (NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
