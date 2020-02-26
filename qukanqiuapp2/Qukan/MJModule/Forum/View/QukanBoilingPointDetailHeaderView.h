//
//  QukanBoilingPointDetailHeaderView.h
//  Qukan
//
//  Created by mac on 2018/11/13.
//  Copyright © 2018 Ningbo Suda. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanBoilingPointDetailHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIView *view_content;

- (void)setData:(id)model;
@end

NS_ASSUME_NONNULL_END
