//
//  QukanResetPwdTwoVC.h
//  Topic
//
//  Created by leo on 2019/9/9.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanResetPwdTwoVC : UIViewController

@property(nonatomic, copy) NSString   * str_phone;
@property(nonatomic, copy) NSString   * str_yzCode;


@property(nonatomic, copy) void(^modifySuccessBlock)(void);
@end

NS_ASSUME_NONNULL_END
