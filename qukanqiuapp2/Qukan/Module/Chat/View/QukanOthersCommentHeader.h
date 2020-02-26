//
//  HaokanOthersCommentHeader.h
//  Haokan
//
//  Created by Charlie on 2019/10/15.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class QukanBolingPointListModel;

@interface QukanOthersCommentHeader : UIView

- (instancetype)initWithFrame:(CGRect)frame andModel:(QukanBolingPointListModel*)model;
- (void)updateUI;

@property(nonatomic, copy) void (^subscribeBtnClick)(QukanBolingPointListModel* nodel);
@property(nonatomic, copy) void (^chatBtnClick)(QukanBolingPointListModel* model);
@property(nonatomic, copy) void (^blockBtnClick)(QukanBolingPointListModel* model);

@end

NS_ASSUME_NONNULL_END
