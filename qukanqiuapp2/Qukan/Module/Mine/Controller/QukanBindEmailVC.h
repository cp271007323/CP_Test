//
//  QukanBindEmailVC.h
//  Topic
//
//  Created by leo on 2019/9/9.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanBindEmailVC : UIViewController


@property(nonatomic, copy) void(^bindEmialSuccessBlock)(void);

@end

NS_ASSUME_NONNULL_END
