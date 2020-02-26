//
//  QukanCommonWebViewController.h
//  Qukan
//
//  Created by pfc on 2019/7/19.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface QukanCommonWebViewController : UIViewController

@property(nonatomic, copy) NSString *url;
@property(nonatomic, assign) BOOL isPresentPush;

@end

NS_ASSUME_NONNULL_END
