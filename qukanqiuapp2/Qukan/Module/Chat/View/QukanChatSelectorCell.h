//
//  QukanChatSelectorCell.h
//  Qukan
//
//  Created by Mac on 2020/2/24.
//  Copyright © 2020 mac. All rights reserved.
//

#import "QukanChatMemberCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface QukanChatSelectorCell : QukanChatMemberCell

@property (nonatomic , strong) UIButton *selectorBtn;

+ (NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
