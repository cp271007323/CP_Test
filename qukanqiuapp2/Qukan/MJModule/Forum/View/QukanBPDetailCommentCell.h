//
//  QukanBPDetailCommentCell.h
//  Qukan
//
//  Created by leo on 2019/10/4.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>


@class QukanBPCommentsModel;
@class QukanBPDetailCommentCell;
NS_ASSUME_NONNULL_BEGIN

@protocol QukanBPDetailCommentCellDelegate <NSObject>

- (void)QukanBPDetailCommentCellBtnClickType:(NSInteger)type selfCell:(QukanBPDetailCommentCell *)cell;

@end



@interface QukanBPDetailCommentCell : UITableViewCell


@property(nonatomic, weak) id<QukanBPDetailCommentCellDelegate>   delegate;

// 点赞按钮
@property (weak, nonatomic) IBOutlet UIButton *btn_zan;

/**赋值*/
- (void)fullCellWithModel:(QukanBPCommentsModel *)model;


@end

NS_ASSUME_NONNULL_END
