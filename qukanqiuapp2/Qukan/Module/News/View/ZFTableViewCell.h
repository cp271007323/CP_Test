//
//  ZFTableViewCell.h
//  ZFPlayer
//
//  Created by 紫枫 on 2018/4/3.
//  Copyright © 2018年 紫枫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFTableViewCellLayout.h"
#import "QukanNewsModel.h"

@protocol ZFTableViewCellDelegate <NSObject>

- (void)zf_playTheVideoAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface ZFTableViewCell : UITableViewCell

@property (nonatomic, strong) ZFTableViewCellLayout *layout;

@property (nonatomic, copy) void(^playCallback)(void);

- (void)setDataWithModel:(QukanNewsModel *)model;

- (void)setDelegate:(id<ZFTableViewCellDelegate>)delegate withIndexPath:(NSIndexPath *)indexPath;

- (void)showMaskView;

- (void)hideMaskView;

- (void)setNormalMode;

- (void)hidePlayBtn;

- (void)hideBottomButtons;

- (void)highLightKeyword:(NSString *)keyword;

@end
