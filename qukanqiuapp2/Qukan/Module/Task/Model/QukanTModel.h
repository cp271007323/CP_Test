//
//  QukanTModel.h
//  Qukan
//
//  Created by Jeff on 2019/11/27.
//  Copyright © 2019 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class QukanActionModel;

@interface QukanTModel : NSObject

@property(nonatomic, copy) NSString    *code;//任务编码
@property(nonatomic, copy) NSString    *name;//任务名称
@property(nonatomic, copy) NSString    *progress;//任务已达标进度
@property(nonatomic, copy) NSString    *descr;//任务描述
//@property(nonatomic, copy) NSString    *type1;//新手任务
@property(nonatomic, copy) NSString    *createdDate;//创建时间

@property(nonatomic, assign) NSInteger qualifiedNumber;//任务达标数量
@property(nonatomic, assign) NSInteger status;//状态 1待，2已
@property(nonatomic, assign) NSInteger pageNumber;//
//@property(nonatomic, assign) NSInteger type2;//
@property(nonatomic, assign) NSInteger parentId;//同伴id
@property(nonatomic, assign) NSInteger tId;//任务id
//@property(nonatomic, assign) NSInteger rank;//排名
@property(nonatomic, strong) NSArray <QukanActionModel *>   *configList;
@property(nonatomic, assign) long      tRecordId;//id,奖励时的参数

@end

NS_ASSUME_NONNULL_END
