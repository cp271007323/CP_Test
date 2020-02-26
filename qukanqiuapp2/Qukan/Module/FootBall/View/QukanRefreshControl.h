//
//  QukanRefreshControl.h
//  Qukan
//
//  Created by pfc on 2019/7/9.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanRefreshControl : UIView

@property(nonatomic, copy, nullable) void (^beginRefreshBlock)(void);
@property(nonatomic, copy, nullable) void (^endRefreshBlock)(void);

- (instancetype)initWithFrame:(CGRect)frame
          relevanceScrollView:(UIScrollView *)scrollView;

- (void)endAnimation;

@end

NS_ASSUME_NONNULL_END
