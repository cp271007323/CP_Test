//
//  QukanBPCommentsModel.h
//  Qukan
//
//  Created by leo on 2019/10/3.
//  Copyright © 2019 mac. All rights reserved.
//

#import <Foundation/Foundation.h>


#pragma mark ===================== 评论的详情model ==================================

@interface QukanBPCommentsContentModel : NSObject
// 时间
@property (nonatomic, copy) NSString *comment_time;
// data
@property (nonatomic, copy) NSString *data;
// 唯一标识
@property (nonatomic, assign) NSInteger Id;
// 点赞数量
@property (nonatomic, assign) NSInteger like_count;
// 是否点赞
@property (nonatomic, assign) NSInteger is_like;
// mid
@property (nonatomic, assign) NSInteger m_id;
// 用户头像
@property (nonatomic, copy) NSString *user_icon;
// 用户id
@property (nonatomic, assign) NSInteger user_id;
// 用户名称
@property (nonatomic, copy) NSString *user_name;

@end

#pragma mark ===================== 点赞的用户模型 ==================================
@interface QukanBPCommentsGreatsModel : NSObject

@property (nonatomic, assign) NSInteger comment_id;

@property (nonatomic, assign) NSInteger user_id;

@property (nonatomic, copy) NSString *user_name;

@end


#pragma mark ===================== 评论模型 ==================================
@interface QukanBPCommentsModel : NSObject <NSCoding>
// 评论详情
@property(nonatomic, strong) QukanBPCommentsContentModel   * content;

@property(nonatomic, strong) NSArray<QukanBPCommentsGreatsModel *>  *greats;
// 所有回复- 现在目前没做此功能
@property(nonatomic, strong) NSArray  *replys;


#pragma mark ===================== QukanFilterObjct ==================================
@property(nonatomic, assign) NSInteger filterUserId;

@property(nonatomic, assign) NSInteger filterId;

@property(nonatomic, copy) NSString *filterName;
@end


