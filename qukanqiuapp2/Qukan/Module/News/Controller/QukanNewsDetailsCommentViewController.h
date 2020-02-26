//
//  QukanNewsDetailsCommentViewController.h
//  Qukan
//
//  Created by Kody on 2019/7/20.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QukanNewsModel;
NS_ASSUME_NONNULL_BEGIN

@interface QukanNewsDetailsCommentViewController : UIViewController

@property(nonatomic, weak) QukanNewsModel *videoNews;
@property (nonatomic, copy) void(^commentVcBlock)(void);

@end

NS_ASSUME_NONNULL_END
