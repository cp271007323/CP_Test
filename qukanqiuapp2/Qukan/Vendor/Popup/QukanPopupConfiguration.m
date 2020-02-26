//
//  QukanPopupConfiguration.m
//  QukanPopupExample
//
//  Created by zhuxiaohui on 2016/6/28.
//  Copyright © 2016年 it7090.com. All rights reserved.
//  代码地址:https://github.com/CoderZhuXH/QukanPopup

#import "QukanPopupConfiguration.h"

#pragma mark - 公共
@implementation QukanPopupConfiguration

@end

#pragma mark - 图片广告相关
@implementation XHLaunchImageLoadConfiguration

+(XHLaunchImageLoadConfiguration *)defaultConfiguration{
    //配置广告数据
    XHLaunchImageLoadConfiguration *configuration = [XHLaunchImageLoadConfiguration new];
    //广告停留时间
    configuration.duration = 5;
    //广告frame
    configuration.frame = [UIScreen mainScreen].bounds;
    //设置GIF动图是否只循环播放一次(仅对动图设置有效)
    configuration.GIFImageCycleOnce = NO;
    //缓存机制
    configuration.imageOption = QukanPopupImageDefault;
    //图片填充模式
    configuration.contentMode = UIViewContentModeScaleToFill;
    //广告显示完成动画
    configuration.showFinishAnimate =ShowFinishAnimateFadein;
     //显示完成动画时间
    configuration.showFinishAnimateTime = showFinishAnimateTimeDefault;
    //跳过按钮类型
    configuration.skipButtonType = SkipTypeTimeText;
    //后台返回时,是否显示广告
    configuration.showEnterForeground = NO;
    return configuration;
}

@end

