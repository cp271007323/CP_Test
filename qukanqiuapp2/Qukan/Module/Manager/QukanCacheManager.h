//
//  QukanCacheManager.h
//  Qukan
//
//  Created by pfc on 2019/7/17.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYCache.h>
#import "QukanPersonModel.h"
@class QukanNewsChannelModel, QukanNewsModel,QukanHomeModels,QukanXuanModel,QukanLeagueInfoModel;

NS_ASSUME_NONNULL_BEGIN

#define kCacheManager [QukanCacheManager sharedInstance]
#define kStStatus [kCacheManager QukangetStStatus]
@interface QukanCacheManager : NSObject

+ (instancetype)sharedInstance;

@property(nonatomic, strong, readonly) YYCache *cache;
@property(nonatomic, copy,readonly) NSString *Quaknmessage;

#pragma mark ===================== 新闻频道缓存 ==================================

- (void)QukancacheChanelItems:(NSArray<QukanNewsChannelModel *> *)channels;
- (NSArray<QukanNewsChannelModel *> *)QukangetChannelItems;

- (void)QukancacheEnableChanelItems:(NSArray<QukanNewsChannelModel *> *)channels;
- (NSArray<QukanNewsChannelModel *> *)QukangetEnableChannelItems;

- (void)QukancacheDisableChanelItems:(NSArray<QukanNewsChannelModel *> *)channels;
- (NSArray<QukanNewsChannelModel *> *)QukangetDisableChannelItems;

#pragma mark ===================== 消息 ==================================

/* 消息 */
//- (void)QukancacheMessageDataWithDatas:(NSArray *)messages;
- (NSArray *)QukangetCacheMessages;

#pragma mark ===================== 新闻数据缓存 ==================================

/* 缓存相应频道的新闻数据 */
- (void)QukancacheNewsListDataWithDatas:(NSArray<QukanNewsModel *> *)news ChannelId:(NSInteger)channelId;
- (NSArray<QukanNewsModel *> *)QukangetCacheNewsWithChannelId:(NSInteger)channelId;


/* 缓存开屏ad */
- (void)QukancacheAdStartListDataWithDatas:(NSArray<QukanHomeModels *> *)ads;
- (NSArray<QukanHomeModels *> *)QukangetCacheAds;


/* 版块 */
- (void)QukancacheXuanDataWithDatas:(NSArray<QukanXuanModel *> *)apps;
- (NSArray<QukanXuanModel *> *)QukangetCacheApps;

/* Take */
- (void)QukancacheTakeWithData:(NSArray *)data;
//- (NSArray *)QukangetCacheData;

/* StStatus */
- (void)QukancacheStStatus:(QukanPersonModel *)stStatus;
- (QukanPersonModel*)QukangetStStatus;


#pragma mark ===================== 足球数据 ==================================
- (void)writeCacheFTAnalysisDatas:(NSArray<QukanLeagueInfoModel*> *)datas;
- (NSArray<QukanLeagueInfoModel *> *)fetechFTAnalysisDataForArea;

#pragma mark ===================== 搜索历史数据 ==================================
- (void)QukanCacheSearchHistory:(NSArray<NSString *> *)datas;
- (NSArray<NSString *> *)QukanFetechSearchHistory;
- (void)QukanClearSearchHistory;
@end

NS_ASSUME_NONNULL_END
