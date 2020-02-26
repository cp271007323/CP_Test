//
//  QukanGetHostTool.h
//  Qukan
//
//  Created by leo on 2019/9/18.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanGetHostTool : NSObject

+ (instancetype)sharedQukanGetHostTool;


// 是否正在请求
@property(nonatomic, assign) BOOL   isQueryData;
// 请求失败的队列
@property(nonatomic, strong) NSMutableArray *arr_failPostList;

- (BOOL )hasValidHost;

- (NSString *)locationHost;

- (void)getValideApiWithCompletBlock:(void (^)(NSString * validHost))completBlock;

@end

NS_ASSUME_NONNULL_END
