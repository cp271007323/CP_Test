//
//  QukanTextMessageCell.h
//  Cell
//
//  Created by pfc on 2019/8/15.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "QukanMessageBaseTableViewCell.h"
#import <YYLabel.h>

@interface QukanTextMessageCell : QukanMessageBaseTableViewCell

//@property(nonatomic, strong) UIFont *textFont;

// 内容
@property (nonatomic, strong) YYLabel *contentLab;

@end
