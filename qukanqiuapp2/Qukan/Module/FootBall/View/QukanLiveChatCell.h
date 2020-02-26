//
//  QukanLiveChatCell.h
//  Qukan
//
//  Created by leo on 2019/12/29.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface QukanLiveChatCell : UITableViewCell


- (void)fullCellWithMessage:(NIMMessage *)message isBasket:(BOOL)isBasket;

@end

NS_ASSUME_NONNULL_END
