//
//  QukanChatListCell.h
//  Qukan
//
//  Created by Mac on 2020/2/22.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanChatListCell : UITableViewCell

@property (nonatomic , strong) UIImageView *headImageView;

@property (nonatomic , strong) UILabel *nameLab;

@property (nonatomic , strong) UILabel *contentLab;

@property (nonatomic , strong) UILabel *timeLab;

@property (nonatomic , strong) UILabel *roundLab;

+ (NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
