//
//  QukanMatchDataRefreshManager.h
//  Qukan
//
//  Created by leo on 2019/10/11.
//  Copyright © 2019 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QukanMatchInfoContentModel;
NS_ASSUME_NONNULL_BEGIN

@interface QukanMatchDataRefreshManager : NSObject


// 获取单例
+ (instancetype)sharedQukanMatchDataRefreshManager;

/**添加需要刷新的数组*/
- (void)addNeedRefreshData:(QukanMatchInfoContentModel *)nowMatchModel andType:(NSInteger)type;

/**刷新列表数据或重新请求数据时 把本地存储的正在打的比赛也同时去除*/
- (void)listRemoveAllData:(NSArray< QukanMatchInfoContentModel *> *)nowMatchList andType:(NSInteger)type;

@end

NS_ASSUME_NONNULL_END
