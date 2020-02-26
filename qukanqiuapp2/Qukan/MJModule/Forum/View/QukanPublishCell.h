//
//  QukanPublishCell.h
//  Qukan
//
//  Created by mac on 2018/10/10.
//  Copyright © 2018 Ningbo Suda. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanPublishCell : UICollectionViewCell
@property (nonatomic, weak) IBOutlet UIImageView *contentImageView;
@property (nonatomic, weak) IBOutlet UIImageView *deleteImageView;
@property (nonatomic, weak) IBOutlet UIButton *deleteButton;

@property (nonatomic, copy) void(^deleteDidBlock)(void);
@end

NS_ASSUME_NONNULL_END
