//
//  QukanPopView.h
//  Qukan
//
//  Created by Kody on 2019/8/8.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QukanHomeModels.h"

@class QukanHomeModels;
NS_ASSUME_NONNULL_BEGIN

@interface QukanPopView : UIView


- (instancetype)initWithFrame:(CGRect)frame WithModel:(QukanHomeModels *)model;//1为登录 2为分享  place 1 为列表 2 为详情

@end

NS_ASSUME_NONNULL_END
