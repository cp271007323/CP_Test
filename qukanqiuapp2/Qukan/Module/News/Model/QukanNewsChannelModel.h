//
//  QukanNewsChannelModel.h
//  Qukan
//
//  Created by pfc on 2019/7/17.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanNewsChannelModel : NSObject<NSCoding>

@property (nonatomic , copy) NSString              * remark;
@property (nonatomic , copy) NSString              * channelType;
@property(nonatomic, assign) NSInteger               channelId;
@property (nonatomic , assign) NSInteger             cid;
@property (nonatomic , assign) NSInteger             sort;
@property (nonatomic , copy) NSString              * channelName;

@property (nonatomic , copy) NSString              * createTime;

@end

NS_ASSUME_NONNULL_END
