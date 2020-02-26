//
//  QukanPersonalCenterHeaderView.h
//  Qukan
//
//  Created by Kody on 2019/8/13.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QukanUserModel;
NS_ASSUME_NONNULL_BEGIN

@interface QukanPersonalCenterHeaderView : UIView


@property(nonatomic, copy) void (^topViewDidSele)(NSInteger tag);
@property(nonatomic, copy) void (^midViewDidSele)(NSInteger tag);
@property(nonatomic, copy) void (^bottomViewDidSele)(NSInteger tag);
/**
 用户佩戴的徽章图片
 */
@property(nonatomic, strong) UIButton     *BadgeBtn;


- (void)freshUserHeaderTopView;

- (void)freshUserHeaderMidViewWithArr:(NSArray *)arr;

@end

NS_ASSUME_NONNULL_END
