//
//  QukanBolingPointListCell.h
//  Qukan
//
//  Created by leo on 2019/10/3.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>


@class QukanBolingPointListModel;
@class QukanBolingPointListCell;


@protocol QukanBolingPointListCellDelegate <NSObject>

- (void)QukanBolingPointListCellBtnClick:(NSInteger)type andCell:(QukanBolingPointListCell *_Nullable)cell;

@end

NS_ASSUME_NONNULL_BEGIN

@interface QukanBolingPointListCell : UITableViewCell

@property(nonatomic, strong) UIViewController   * vc_parent;

// 点赞按钮
@property (weak, nonatomic) IBOutlet UIButton *btn_zan;

// 收藏按钮
@property (weak, nonatomic) IBOutlet UIButton *btn_like;

@property(nonatomic, weak) id<QukanBolingPointListCellDelegate>   delegate;

- (void)fullCellWithModel:(QukanBolingPointListModel *)model;

- (void)hideReportBtn:(BOOL)hide;

@end

NS_ASSUME_NONNULL_END
