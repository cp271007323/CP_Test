//
//  QukanPersonChangeViewController.h
//  Qukan
//
//  Created by Kody on 2019/8/15.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class QukanScreenModel;
@interface QukanPersonChangeViewController : UIViewController
/**成功回调*/
@property (copy, nonatomic)  void(^CodeClickBlock)(BOOL code);
/**回调任务*/
@property (copy, nonatomic)  void(^RenWuClickBlock)(BOOL isLogin);

@property(nonatomic, strong) NSArray <QukanScreenModel *>       *datas;//数据源
//- (void)dataSourceWith:(id)response;
@end

NS_ASSUME_NONNULL_END
