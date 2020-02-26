//
//  QukanAllMemberCell.h
//  Qukan
//
//  Created by Mac on 2020/2/23.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllMembersView.h"

NS_ASSUME_NONNULL_BEGIN

@interface QukanAllMemberCell : UITableViewCell

@property (nonatomic , strong) AllMembersView *allMemberView;

/// 群成员数据
@property (nonatomic , strong) NSArray<NSString *> *members;

+ (NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
