//
//  QukanPersonModel.h
//  Qukan
//
//  Created by Jeff on 2020/1/14.
//  Copyright © 2020 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanPersonModel : NSObject<NSCoding>

@property (nonatomic, copy)NSString *pageNum;//提现
@property (nonatomic, copy)NSString *pageSize;//红包
@property (nonatomic, copy)NSString *page;//金额
@property (nonatomic, copy)NSString *duration;//积分
@property (nonatomic, copy)NSString *email;//兑换
@property (nonatomic, copy)NSString *countText;//到账
@property (nonatomic, copy)NSString *takeNum;//零钱
@property (nonatomic, copy)NSString *takecount;//账户
@property (nonatomic, copy)NSString *counts;//付款
@property (nonatomic, copy)NSString *caseNum;//任务
@property (nonatomic, copy)NSString *weekDay;//奖励
@property (nonatomic, copy)NSString *weeks;//好评
@property (nonatomic, copy)NSString *day;//交流
@property (nonatomic, copy)NSString *dayNum;//成就
@property (nonatomic, copy)NSString *preNum;//火爆
@property (nonatomic, copy)NSString *numberDay;//支付
@property (nonatomic, copy)NSString *name;//微信
@property (nonatomic, copy)NSString *otherName;//余额
@property (nonatomic, copy)NSString *secName;//排名
@property (nonatomic, copy)NSString *age;//领取
@property (nonatomic, copy)NSString *ageNum;//推广
@property (nonatomic, copy)NSString *talk;//明细
@property (nonatomic, copy)NSString *emails;//作弊
@property (nonatomic, copy)NSString *phone;//审核
@property (nonatomic, copy)NSString *dark;//元
@property (nonatomic, copy)NSString *trees;//邀请
@property (nonatomic, copy)NSString *oriName;//钱包
@property (nonatomic, copy)NSString *preProtey;//现金

@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *title1;
@property(nonatomic, copy) NSString *names;

@end

NS_ASSUME_NONNULL_END
