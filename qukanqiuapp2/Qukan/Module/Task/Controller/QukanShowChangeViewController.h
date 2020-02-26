//
//  QukanShowChangeViewController.h
//  Qukan
//
//  Created by Jeff on 2019/11/27.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanShowChangeViewController : UIViewController

@property (copy, nonatomic)  void(^PopClickBlock)(NSInteger code);

@end

NS_ASSUME_NONNULL_END
