//
//  QukanApiManager+Boiling.h
//  Qukan
//
//  Created by Kody on 2019/6/24.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanApiManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface QukanApiManager (Boiling)

/** 查询话题列表 */
- (RACSignal *)QukanLabel;

/**  用户关注话题 、取消 */
- (RACSignal *)QukanusersLikeWithModuleId:(NSNumber *)moduleId addOperation:(NSString *)operation;

/**  查询话题（热门和最新）帖子列表 */
- (RACSignal *)QukanListWithModuleId:(NSNumber *)Id addType:(NSNumber *)type addPageNo:(NSNumber *)pageNo addCountPerPage:(NSString *)countPerPage;

/** 查询热帖（推荐和动态）列表 */
- (RACSignal *)QukanDynamicsWithType:(NSString *)type addPage_no:(NSNumber *)page_no addPage_size:(NSString *)page_size;

/** 用户删帖 */
//- (RACSignal *)QukanpostsDelPostWithId:(NSNumber *)Id;

/** 发表评论 */
- (RACSignal *)QukancommentsWithId:(NSInteger)Id addType:(NSString *)type addComment_content:(NSString *)text addReplyId:(NSNumber *_Nullable)replyId;

/** 发帖 */
- (RACSignal *)QukanpostsWithContent:(NSString *)content addModuleId:(NSString *)moduleId addImageUrl:(NSString *)imageUrl;

/** 帖子点赞及取消点赞 */
- (RACSignal *)QukanClickPraiseWithId:(NSNumber *)Id addFlag:(NSString *)flag;

/** 关注 */
- (RACSignal *)QukanusersFollowWithToUserId:(NSNumber *)Id addOperation:(NSString *)operation;

/** 点赞及取消赞 */
- (RACSignal *)QukancommentsLikeWithMid:(NSInteger)mid addInfoId:(NSInteger)infoid addFlag:(NSString *)flag;

/** 获取评论 */
- (RACSignal *)QukankanGetDynamicsListUserId:(NSInteger)Id pageIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
