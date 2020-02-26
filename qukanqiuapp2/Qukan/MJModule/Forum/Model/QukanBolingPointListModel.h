//
//  QukanBolingPointListModel.h
//  Qukan
//
//  Created by leo on 2019/10/3.
//  Copyright © 2019 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QukanBolingPointListModel : NSObject<NSCoding>

@property(nonatomic, strong) NSArray <NSString *>   *images;

/**表示收藏*/
@property(nonatomic, assign) NSInteger    is_like;
/**评论数量*/
@property(nonatomic, assign)NSInteger  comment_count;
/**创建时间*/
@property(nonatomic, copy) NSString    * create_time;
/**唯一标识*/
@property(nonatomic, assign) NSInteger    Id;


/**内容*/
@property(nonatomic, copy) NSString   * content;
/**模块id*/
@property(nonatomic, copy) NSString   * module_id;
/**状态*/
@property(nonatomic, copy) NSString   * status;
/**显示时间*/
@property(nonatomic, copy) NSString   * time;
/**标题*/
@property(nonatomic, copy) NSString   * title;
/**是否关注*/
@property(nonatomic, assign) NSInteger   user_follow;

/**用户头像*/
@property(nonatomic, copy) NSString   * user_icon;
/**用户id*/
@property(nonatomic, assign) NSInteger   user_id;
/**用户名*/
@property(nonatomic, copy) NSString   * username;

/**点赞数*/
@property(nonatomic, assign) NSInteger    like_count;



#pragma mark ===================== QukanFilterObjct ==================================
@property(nonatomic, assign) NSInteger filterUserId;

@property(nonatomic, assign) NSInteger filterId;

@property(nonatomic, copy) NSString *filterName;


@end

NS_ASSUME_NONNULL_END
