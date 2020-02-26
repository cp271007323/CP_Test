//
//  QukanShareView.h
//  Qukan
//
//  Created by Kody on 2019/7/19.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
// 自定义分享的view
@interface QukanShareView : UIView

@property (nonatomic, copy) void (^shareTypeblock)(NSInteger type);//分享


@end

NS_ASSUME_NONNULL_END

