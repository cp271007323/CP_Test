//
//  QukanTeamBasicModel.h
//  Qukan
//
//  Created by Charlie on 2020/1/4.
//  Copyright © 2020 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/*
 "area": "维也纳",

 addr    string    地址
 b    string    繁体名
 capacity    int    球场容量
 e    string    英文名
 flag    string    队标
 found    string    球队成立日期
 g    string    简体名
 gym    string    球场
 master    string    主教练
 
 */


@interface QukanTeamBasicModel : NSObject

@property(nonatomic,copy) NSString* area;
@property(nonatomic,copy) NSString* addr;
@property(nonatomic,copy) NSString* b;
@property(nonatomic,copy) NSString* e;
@property(nonatomic,copy) NSString* flag;
@property(nonatomic,copy) NSString* found;

@property(nonatomic,strong) NSString* g;
@property(nonatomic,strong) NSString* gym;
@property(nonatomic,strong) NSString* master;
@end

NS_ASSUME_NONNULL_END
