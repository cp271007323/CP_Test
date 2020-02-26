//
//  QukanCacheManager.m
//  Qukan
//
//  Created by pfc on 2019/7/17.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

//#import <YYCache.h>

#import "QukanNewsChannelModel.h"
#import "QukanNewsModel.h"

static NSString * const kQukanCahceName = @"topicCacheName";

@interface QukanCacheManager ()

@property(nonatomic, strong, readwrite) YYCache *cache;

@end

@implementation QukanCacheManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static QukanCacheManager *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
        instance.cache = [[YYCache alloc] initWithName:kQukanCahceName];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}

#pragma mark ===================== 足球联赛数据缓存 ==================================

//- (void)writeCacheFTAnalysisDatas:(NSMutableArray<NSMutableArray*> *)datas{
//    [self.cache setObject:datas forKey:@"ftAnalysisArea"];
//}
//
//- (NSMutableArray<NSMutableArray *> *)fetechFTAnalysisDataForArea{
//    id datas = [self.cache objectForKey:@"ftAnalysisArea"];
//    return datas;
//}

- (void)writeCacheFTAnalysisDatas:(NSArray<QukanLeagueInfoModel*> *)datas{
    [self.cache setObject:datas forKey:@"ftAnalysisAllAreaModelList"];
}

- (NSArray<QukanLeagueInfoModel *> *)fetechFTAnalysisDataForArea{
    id datas = [self.cache objectForKey:@"ftAnalysisAllAreaModelList"];
    return datas;
}

#pragma mark ===================== 新闻频道缓存 ================================== 

- (void)QukancacheChanelItems:(NSArray<QukanNewsChannelModel *> *)channels {
    [self.cache setObject:channels forKey:@"channels"]; 
}

- (NSArray<QukanNewsChannelModel *> *)QukangetChannelItems {
    id datas = [self.cache objectForKey:@"channels"];
//    if (!datas) {
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"channels" ofType:@"json"];
//        NSData *data = [NSData dataWithContentsOfFile:path];
//
//        NSArray *channels = [[NSArray modelArrayWithClass:[QukanNewsChannelModel class] json:[data jsonValueDecoded]] sortedArrayUsingComparator:^NSComparisonResult(QukanNewsChannelModel *  _Nonnull obj1, QukanNewsChannelModel *  _Nonnull obj2) {
//            return obj1.sort > obj2.sort;
//        }];
//        return channels;
//    }
    
    return datas;
}

- (void)QukancacheEnableChanelItems:(NSArray<QukanNewsChannelModel *> *)channels {
    [self.cache setObject:channels forKey:@"enable_channels"];
}

- (NSArray<QukanNewsChannelModel *> *)QukangetEnableChannelItems {
    id datas = [self.cache objectForKey:@"enable_channels"];
    return datas;
}

- (void)QukancacheDisableChanelItems:(NSArray<QukanNewsChannelModel *> *)channels {
    [self.cache setObject:channels forKey:@"disable_channels"];
}

- (NSArray<QukanNewsChannelModel *> *)QukangetDisableChannelItems {
    id datas = [self.cache objectForKey:@"disable_channels"];
    return datas;
}

#pragma mark ===================== 消息 ==================================

///* 消息 */
//- (void)QukancacheMessageDataWithDatas:(NSArray *)messages {
//    NSString *key = @"Qukan_message";
//}
- (NSArray *)QukangetCacheMessages {
    NSArray *array = [NSArray array];
    array = @[@"1",@"2"];
    return array;
}

#pragma mark ===================== 新闻数据缓存 ==================================

- (void)QukancacheNewsListDataWithDatas:(NSArray<QukanNewsModel *> *)news ChannelId:(NSInteger)channelId {
    NSString *key = [NSString stringWithFormat:@"newsListCacheKey_channelId_%ld", channelId];
    [self.cache setObject:news forKey:key];
}

- (NSArray<QukanNewsModel *> *)QukangetCacheNewsWithChannelId:(NSInteger)channelId {
    NSString *key = [NSString stringWithFormat:@"newsListCacheKey_channelId_%ld", channelId];
    id datas = [self.cache objectForKey:key];
    
    return datas;
}


#pragma mark ===================== Ad ==================================

- (void)QukancacheAdStartListDataWithDatas:(NSArray<QukanHomeModels *> *)ads {
    NSString *key = @"Qukan_startAds";
    [self.cache setObject:ads forKey:key];
}

- (NSArray<QukanHomeModels *> *)QukangetCacheAds {
    NSString *key = @"Qukan_startAds";
    id datas = [self.cache objectForKey:key];
    
    return datas;
}


#pragma mark ===================== Xuan ==================================

- (void)QukancacheXuanDataWithDatas:(NSArray<QukanXuanModel *> *)apps {
    NSString *key = @"xuan";
    [self.cache setObject:apps forKey:key];
}

- (NSArray<QukanXuanModel *> *)QukangetCacheApps {
    NSString *key = @"xuan";
    id datas = [self.cache objectForKey:key];
    
    return datas;
}

#pragma mark ===================== Take ==================================

- (void)QukancacheTakeWithData:(NSArray *)data {
    
}

//- (NSArray *)QukangetCacheData {
//    NSArray *data = [NSArray array];
//    return data;
//}

#pragma mark ===================== sTstatus ==================================

- (void)QukancacheStStatus:(QukanPersonModel *)stStatus {
    NSString *key = @"stStatus";
    [self.cache setObject:stStatus forKey:key];
}

- (QukanPersonModel *)QukangetStStatus {
    NSString *key = @"stStatus";
    id datas = [self.cache objectForKey:key];
    return datas;
}

#pragma mark ===================== 搜索历史数据 ==================================
- (void)QukanCacheSearchHistory:(NSArray<NSString *> *)datas {
    NSString *key = @"searchHistory";
    [self.cache setObject:datas forKey:key];
}
- (NSArray<NSString *> *)QukanFetechSearchHistory {
    NSString *key = @"searchHistory";
    id datas = [self.cache objectForKey:key];
    return datas;
}
- (void)QukanClearSearchHistory {
    NSString *key = @"searchHistory";
    [self.cache removeObjectForKey:key];
}
@end
