//
//  QukanApiManager+News.h
//  Qukan
//
//  Created by pfc on 2019/7/17.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import "QukanApiManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface QukanApiManager (News)

/* 获取频道id */
- (RACSignal *)QukanacquireNewsChannels;

/* 获取新闻列表数据 */
- (RACSignal *)QukanacquireNewsListWithLeagueId:(NSInteger)leagueId Page:(NSInteger)page pageSize:(NSInteger)pageSize;

/* 获取新闻更新阅读 */
- (RACSignal *)QukannewsReadNumWithNewsId:(NSString *)newsId;

/* 获取新闻评论数 */
- (RACSignal *)QukancommentSearchWithsourceId:(NSInteger)sourceId addsourceType:(NSInteger)sourceType addSortType:(NSInteger)sortType addcurrent:(NSInteger)current addsize:(NSInteger)size;

/* 获取新闻轮播图 */
- (RACSignal *)QukannewsBannerData:(NSInteger)channelId;

/* 添加评论 */
- (RACSignal *)QukancommentAddWithsourceId:(NSInteger)sourceId addsourceType:(NSInteger)sourceType addCommentContent:(NSString *)commentContent;

/* 点赞与取消点赞 */
- (RACSignal *)QukancommentSwitchWithCommentId:(NSInteger)commentId addType:(NSInteger)type;

/* 获取总点赞数 */
- (RACSignal *)QukancommentSearchCountWithSourceId:(NSInteger)sourceId addSourceType:(NSInteger)sourceType;

/* 新闻点赞 */
- (RACSignal *)QukannewsSwitchLikeWithNewsId:(NSInteger)newsId addType:(NSInteger)type;

///* 动态获取分享地址 */
//- (RACSignal *)QukanParmGetSig;

/* 根据关键字搜索新闻 */
- (RACSignal *)QukanSearchWithKeyword:(NSString *)keyword current:(NSInteger)current;

/* 搜索历史 */
- (RACSignal *)QukanSearchHot;

@end

NS_ASSUME_NONNULL_END
