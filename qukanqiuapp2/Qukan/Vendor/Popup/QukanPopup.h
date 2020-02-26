//
//  QukanPopup.h
//  QukanPopupExample
//
//  Created by zhuxiaohui on 2016/6/13.
//  Copyright © 2016年 it7090.com. All rights reserved.
//  代码地址:https://github.com/CoderZhuXH/QukanPopup

//  版本:3.9.11
//  发布:2020.01.14

//  如果你在使用过程中出现bug,请及时以下面任意一种方式联系我，我会及时修复bug并帮您解决问题。
//  QQ交流群:537476189
//  Email:it7090@163.com
//  新浪微博:朱晓辉Allen
//  GitHub:https://github.com/CoderZhuXH
//  简书:https://www.jianshu.com/u/acf1a1f12e0f
//  掘金:https://juejin.im/user/59b50d3cf265da066d331a06

//  使用说明:https://github.com/CoderZhuXH/QukanPopup/blob/master/README.md

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "QukanPopupConfiguration.h"
#import "QukanPopupConst.h"
#import "XHLaunchImageView.h"

NS_ASSUME_NONNULL_BEGIN
@class QukanPopup;
@protocol QukanPopupDelegate <NSObject>
@optional

/**
广告点击回调

@param lanPopup lanPopup
@param openModel 打开页面参数(此参数即你配置广告数据设置的configuration.openModel)
@param clickPoint 点击位置
@param return  YES移除广告,NO不移除
*/
- (BOOL)QukanPopup:(QukanPopup *)lanPopup clickAtOpenModel:(id)openModel clickPoint:(CGPoint)clickPoint;

/**
 跳过按钮点击回调(注意:自定义跳过按钮不会走此回调)

 @param lanPopup lanPopup
 @param skipButton 跳过按钮
 */
- (void)QukanPopup:(QukanPopup *)lanPopup clickSkipButton:(UIButton *)skipButton;

/**
 *  图片本地读取/或下载完成回调
 *
 *  @param lanPopup  QukanPopup
 *  @param image 读取/下载的image
 *  @param imageData 读取/下载的imageData
 */
-(void)QukanPopup:(QukanPopup *)lanPopup imageDownLoadFinish:(UIImage *)image imageData:(NSData *)imageData;

/**
 *  video本地读取/或下载完成回调
 *
 *  @param lanPopup QukanPopup
 *  @param pathURL  本地保存路径
 */
-(void)QukanPopup:(QukanPopup *)lanPopup videoDownLoadFinish:(NSURL *)pathURL;

/**
 视频下载进度回调

 @param lanPopup QukanPopup
 @param progress 下载进度
 @param total    总大小
 @param current  当前已下载大小
 */
-(void)QukanPopup:(QukanPopup *)lanPopup videoDownLoadProgress:(float)progress total:(unsigned long long)total current:(unsigned long long)current;

/**
 *  倒计时回调
 *
 *  @param lanPopup QukanPopup
 *  @param duration 倒计时时间
 */
-(void)QukanPopup:(QukanPopup *)lanPopup customSkipView:(UIView *)customSkipView duration:(NSInteger)duration;

/**
  广告显示完成

 @param lanPopup QukanPopup
 */
-(void)JiuAilaunchShowFinish:(QukanPopup *)lanPopup;

/**
 如果你想用SDWebImage等框架加载网络广告图片,请实现此代理,注意:实现此方法后,图片缓存将不受QukanPopup管理

 @param lanPopup          QukanPopup
 @param lanuchPageImageView lanuchPageImageView
 @param url               图片url
 */
-(void)QukanPopup:(QukanPopup *)lanPopup lanuchPageImageView:(UIImageView *)lanuchPageImageView URL:(NSURL *)url;


#pragma mark - 过期-QukanPopupDelegate
- (void)QukanPopup:(QukanPopup *)lanPopup clickAndOpenModel:(id)openModel clickPoint:(CGPoint)clickPoint QukanPopupDeprecated("请使用QukanPopup:clickAtOpenModel:clickPoint:");
- (void)QukanPopup:(QukanPopup *)lanPopup clickAndOpenURLString:(NSString *)openURLString QukanPopupDeprecated("请使用QukanPopup:clickAtOpenModel:clickPoint:");
- (void)QukanPopup:(QukanPopup *)lanPopup clickAndOpenURLString:(NSString *)openURLString clickPoint:(CGPoint)clickPoint QukanPopupDeprecated("请使用QukanPopup:clickAtOpenModel:clickPoint:");
-(void)QukanPopup:(QukanPopup *)lanPopup imageDownLoadFinish:(UIImage *)image QukanPopupDeprecated("请使用QukanPopup:imageDownLoadFinish:imageData:");
-(void)xhLaunchShowFinish:(QukanPopup *)lanPopup QukanPopupDeprecated("请使用JiuAilaunchShowFinish:");

@end

@interface QukanPopup : NSObject

@property(nonatomic,assign) id<QukanPopupDelegate> delegate;

/**
 设置你工程的启动页使用的是LaunchImage还是LaunchScreen(default:SourceTypeLaunchImage)
 注意:请在设置等待数据及配置广告数据前调用此方法
 @param sourceType sourceType
 */
+(void)setLaunchSourceType:(SourceType)sourceType;

/**
 *  设置等待数据源时间(建议值:2)
 *
 *  @param waitDataDuration waitDataDuration
 */
+(void)setWaitDataDuration:(NSInteger )waitDataDuration;

/**
 *  图片开屏广告数据配置
 *
 *  @param imageAdconfiguration 数据配置
 *
 *  @return QukanPopup
 */
+(QukanPopup *)imageWithImageConfiguration:(XHLaunchImageLoadConfiguration *)imageAdconfiguration;

/**
 *  图片开屏广告数据配置
 *
 *  @param imageAdconfiguration 数据配置
 *  @param delegate             delegate
 *
 *  @return QukanPopup
 */
+(QukanPopup *)imageWithImageConfiguration:(XHLaunchImageLoadConfiguration *)imageAdconfiguration delegate:(nullable id)delegate;


#pragma mark -批量下载并缓存
/**
 *  批量下载并缓存image(异步) - 已缓存的image不会再次下载缓存
 *
 *  @param urlArray image URL Array
 */
+(void)downLoadImageAndCacheWithURLArray:(NSArray <NSURL *> * )urlArray;

/**
 批量下载并缓存image,并回调结果(异步)- 已缓存的image不会再次下载缓存

 @param urlArray image URL Array
 @param completedBlock 回调结果为一个字典数组,url:图片的url字符串,result:0表示该图片下载缓存失败,1表示该图片下载并缓存完成或本地缓存中已有该图片
 */
+(void)downLoadImageAndCacheWithURLArray:(NSArray <NSURL *> * )urlArray completed:(nullable QukanPopupBatchDownLoadAndCacheCompletedBlock)completedBlock;


#pragma mark - Action

/**
 手动移除广告

 @param animated 是否需要动画
 */
+(void)removeAndAnimated:(BOOL)animated;

#pragma mark - 是否已缓存
/**
 *  是否已缓存在该图片
 *
 *  @param url image url
 *
 *  @return BOOL
 */
+(BOOL)checkImageInCacheWithURL:(NSURL *)url;

/**
 *  是否已缓存该视频
 *
 *  @param url video url
 *
 *  @return BOOL
 */
+(BOOL)checkVideoInCacheWithURL:(NSURL *)url;

#pragma mark - 获取缓存url
/**
 从缓存中获取上一次的ImageURLString(QukanPopup 会默认缓存imageURLString)
 
 @return imageUrlString
 */
+(NSString *)cacheImageURLString;

/**
 从缓存中获取上一次的videoURLString(QukanPopup 会默认缓存VideoURLString)
 
 @return videoUrlString
 */
+(NSString *)cacheVideoURLString;

#pragma mark - 缓存/清理相关
/**
 *  清除QukanPopup本地所有缓存(异步)
 */
+(void)clearDiskCache;

/**
 清除指定Url的图片本地缓存(异步)

 @param imageUrlArray 需要清除缓存的图片Url数组
 */
+(void)clearDiskCacheWithImageUrlArray:(NSArray<NSURL *> *)imageUrlArray;

/**
 清除指定Url除外的图片本地缓存(异步)
 
 @param exceptImageUrlArray 此url数组的图片缓存将被保留
 */
+(void)clearDiskCacheExceptImageUrlArray:(NSArray<NSURL *> *)exceptImageUrlArray;

/**
 *  获取XHLaunch本地缓存大小(M)
 */
+(float)diskCacheSize;

/**
 *  缓存路径
 */
+(NSString *)JiuAilaunchCachePath;

#pragma mark - 过期
+(void)skipAction QukanPopupDeprecated("请使用removeAndAnimated:");
+(void)setLaunchImagesSource:(LaunchImagesSource)launchImagesSource QukanPopupDeprecated("请使用setLaunchSourceType:");

@end
NS_ASSUME_NONNULL_END
