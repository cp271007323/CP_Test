//
//  QukanGViewController.h
//  Qukan
//
//  Created by Kody on 2019/8/9.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/// 广告
@interface QukanGViewController : UIViewController

@property(nonatomic, copy) NSString *url;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, assign) BOOL   isPresentPush;

@end

NS_ASSUME_NONNULL_END
