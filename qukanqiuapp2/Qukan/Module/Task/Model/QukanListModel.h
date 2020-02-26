//
//  QukanListModel.h
//  Qukan
//
//  Created by Jeff on 2019/11/27.
//  Copyright © 2019 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanListModel : NSObject

@property (copy, nonatomic)  NSString *amount;
/**失败更新时间*/
@property (copy, nonatomic)  NSString *updateDate;
/**时间*/
@property (copy, nonatomic)  NSString *createdDate;
/**错误编码*/
@property (copy, nonatomic)  NSString *errorCode;
/**错误信息*/
@property (copy, nonatomic)  NSString *error;
/**完成时间*/
@property (copy, nonatomic)  NSString *checkDate;
/**完成时间*/
@property (copy, nonatomic)  NSString *doneDate;

@property (copy, nonatomic)  NSString *status;
/**描述*/
@property (copy, nonatomic)  NSString *descr;

@end

NS_ASSUME_NONNULL_END
