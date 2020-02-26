//
//  QukanTool.h
//  Qukan
//
//  Created by mac on 2018/8/12.
//  Copyright © 2018 Ningbo Suda. All rights reserved.
//

#import <Foundation/Foundation.h>

//敏感图片获取 （获取方式通过链接拼接）
typedef NS_ENUM(NSInteger, QukanImageNumber) {
    QukanImageNumber_HB              = 1,//红包
    QukanImageNumber_HBDX           = 2,//红包大虾
    QukanImageNumber_ZHG           = 3,//指挥官
    QukanImageNumber_FKFS           = 4,//疯狂粉丝
    QukanImageNumber_MRHB            = 5,//每日红包
    QukanImageNumber_CCML           = 6,//初出茅庐
    QukanImageNumber_JF                  = 7,//积分
    QukanImageNumber_RWDR            = 8,//任务达人
    QukanImageNumber_HZ                = 9,//好评盒子
    QukanImageNumber_HPPL              = 10,//好评评论
    QukanImageNumber_HBDX_1          = 21,//红包大虾未点亮
    QukanImageNumber_HBDX_2        = 22,//红包大虾大图
    QukanImageNumber_HBDX_3     = 23,//红包大虾头像
    QukanImageNumber_ZHG_1          = 31,//指挥官未点亮
    QukanImageNumber_ZHG_2        = 32,//指挥官大图
    QukanImageNumber_ZHG_3     = 33,//指挥官头像
    QukanImageNumber_PLDR       = 34,//评论达人
    QukanImageNumber_PLDR_1      = 35,//评论达人未点亮
    QukanImageNumber_PLDR_2    = 36,//评论达人大图
    QukanImageNumber_PLDR_3    = 37,//评论达人头像
    QukanImageNumber_FKFS_1          = 41,//疯狂粉丝未点亮
    QukanImageNumber_FKFS_2        = 42,//疯狂粉丝大图
    QukanImageNumber_FKFS_3     = 43,//疯狂粉丝头像
    QukanImageNumber_MRJF           = 51,//每日积分
    QukanImageNumber_DHSB           = 52,//兑换失败
    QukanImageNumber_DHBJ                = 53,//兑换背景
    QukanImageNumber_DH                  = 54,//兑换
    QukanImageNumber_CCML_1          = 61,//初出茅庐未点亮
    QukanImageNumber_CCML_2        = 62,//初出茅庐大图
    QukanImageNumber_CCML_3     = 63,//初出茅庐头像
    QukanImageNumber_JFDH                = 71,//积分兑换
    QukanImageNumber_JFDH_D                = 72,//积分兑换默认图
    QukanImageNumber_HBDH         = 73,//红包
    QukanImageNumber_HBDH_D = 74,//红包兑换默认图
    QukanImageNumber_DHCG      = 75,//兑换成功
    QukanImageNumber_RWDR_1           = 81,//任务达人未点亮
    QukanImageNumber_RWDR_2         = 82,//任务达人大图
    QukanImageNumber_RWDR_3    = 83,//任务达人头像
    QukanImageNumber_banner              = 91,//好评banner
};


@class QukanHomeModels;
@interface QukanSeversTimeModel : NSObject

@property(nonatomic, copy) NSString *week;

@property(nonatomic, copy) NSString *today;

@property(nonatomic, copy) NSString *dateTime;

@property(nonatomic, copy) NSString *hms;

@property(nonatomic, copy) NSString *ymd;

@end

@interface QukanTool : NSObject
+ (void)Qukan_setIQKeyboardManager;
+ (UIImage *)Qukan_createImageWithColor:(UIColor *)color;
+ (UIImage *)Qukan_imageFromString:(NSString *)string attributes:(NSDictionary *)attributes size:(CGSize)size;
+ (NSString *)Qukan_getWeekDay:(NSString*)currentStr;
+ (NSString *)Qukan_getDateDictKeyWithDay:(NSInteger)day;
+ (void)Qukan_initLocalData;
+ (UIViewController *)Qukan_topViewController;
+ (CGSize)Qukan_sizeWithText:(NSString *)text
                             font:(UIFont *)font
                          maxSize:(CGSize)maxSize;

+ (void)Qukan_setFollowWithModel:(id)model;
//+ (NSArray *)Qukan_updateFollowWithData:(NSMutableArray *)dataArray;

+ (void)Qukan_requestWithRedkaTipsAndGoalTips;


+ (void)Qukan_showRedkaTipsAndGoalTipsWithArray:(NSArray *)tipsArray withArray:(NSArray *)originalArray view:(UIView *)view type:(NSInteger)type;

+ (void)Qukan_showViewWithModel:(id)model
                                view:(UIView *)view
                                 row:(NSInteger)row
                          isGoalTips:(BOOL)isGoalTips;

+ (int)Qukan_xuan:(NSString *)val;


// UIInterfaceOrientation
+ (void)Qukan_interfaceOrientation:(UIInterfaceOrientation)orientation;

+ (void)Qukan_getUpdateTimeWithBolck:(void (^)(QukanSeversTimeModel * timeModel))timeBlock;
+ (void)Qukan_JumpWithModel:(QukanHomeModels *)model WithController:(UINavigationController *)nav;
+ (NSURL *)Qukan_getImageStr:(NSString *)numerStr;

@end


