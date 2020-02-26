//
//  QukanImageMessageCell.h
//  Cell
//
//  Created by pfc on 2019/8/15.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "QukanMessageBaseTableViewCell.h"

@interface QukanImageMessageCell : QukanMessageBaseTableViewCell

@property (nonatomic, strong) UIImageView *imgView;
@property(nonatomic, strong) UIActivityIndicatorView *progressView;

@end
