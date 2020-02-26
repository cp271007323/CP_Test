//
//  QukanUIMacro.h
//  DaiXiongTV
//
//  Created by pfc on 2019/6/11.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//

#ifndef QukanUIMacro_h
#define QukanUIMacro_h

#pragma mark - 系统距离

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

///缩放比例
#define SCALING_RATIO(UISize) (UISize)*([[UIScreen mainScreen] bounds].size.width)/375.0f//全局比例尺

///状态栏高度
#define kStatusBarHeight     [UIApplication sharedApplication].statusBarFrame.size.height
///获取导航栏的高
#define rectOfNavigationbar self.navigationController.navigationBar.frame.size.height//获取导航栏的高
///导航栏加状态栏高度
#define kTopBarHeight (kStatusBarHeight + rectOfNavigationbar)
///底部栏加安全区域高度
#define kBottomBarHeight         (isIPhoneXSeries() ? (49.f+34.f) : 49.f)
///底部安全距离
#define kSafeAreaBottomHeight   (isIPhoneXSeries() ? 34.f : 0.f)

#pragma mark - 项目通用颜色

// 主题色
#define kThemeColor HEXColor(0xF7B500)
#define kThemeColor_Alpha(a)       [UIColor colorWithRed:0/255.0 green:125/255.0 blue:101/255.0 alpha:a]

// 主体内容字体黑色
#define kCommonTextColor HEXColor(0x000000)

// 纯白色
#define kCommonWhiteColor HEXColor(0xFFFFFF)

// 纯黑色
#define kCommonBlackColor [UIColor blackColor]

// 灰色字体
#define kTextGrayColor HEXColor(0x999999)

// 灰色背景
#define kCommentBackgroudColor HEXColor(0xf5f5f5)

// 深灰色
#define kCommonDarkGrayColor HEXColor(0x333333)
// 视图控制器视图颜色
#define kViewControllerBackgroundColor kCommentBackgroudColor
// 列表背景颜色
#define kTableViewCommonBackgroudColor HEXColor(0xE9E9E9)

#define kSecondTableViewBackgroudColor HEXColor(0xf1f1f1)

// 列表cell主题内容字体颜色
#define kTableCellCommonTextColor kCommonTextColor

#pragma mark ===================== rgb与16进制颜色生成 ==================================

///随机颜色
#define kRandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]

#define RGB(r, g, b)            [UIColor colorWithRed:r/255.0 green:g/255. blue:b/255. alpha:1.]
#define RGBA(r, g, b, a)        [UIColor colorWithRed:r/255. green:g/255. blue:b/255. alpha:a/1.]
#define RGBSAMECOLOR(x) [UIColor colorWithRed:(x)/255.0 green:(x)/255.0 blue:(x)/255.0 alpha:1]

///十六进制颜色
#define HEXColor(hex)           [UIColor colorWithRed:((hex & 0xFF0000) >> 16)/255.0 green:((hex & 0xFF00) >> 8)/255.0 blue:((hex & 0xFF))/255.0 alpha:1.0]
#define COLOR_HEX(hexValue, al)  [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:al]

#pragma mark ===================== 通用加载框宏定义 ==================================

#define KHideHUD [self.view hideLoading];
#define KShowHUD [self.view showLoading];
#define kShowTip(tip) [self.view showTip:tip];

#define kApplyShadowForView(view, radius) view.layer.masksToBounds = NO; \
view.layer.shadowOffset = CGSizeMake(0, 1.5); \
view.layer.shadowRadius = radius; \
view.layer.shadowOpacity = 0.4; \
view.layer.shadowColor = [UIColor lightGrayColor].CGColor; 

#pragma mark - 字体
#define kSystemFont(font)       [UIFont systemFontOfSize:font]
#define kFont10 [UIFont fontWithName:@"PingFangSC-Regular" size:10]
#define kFont11 [UIFont fontWithName:@"PingFangSC-Regular" size:11]
#define kFont12 [UIFont fontWithName:@"PingFangSC-Regular" size:12]
#define kFont13 [UIFont fontWithName:@"PingFangSC-Regular" size:13]
#define kFont14 [UIFont fontWithName:@"PingFangSC-Regular" size:14]
#define kFont15 [UIFont fontWithName:@"PingFangSC-Regular" size:15]
#define kFont16 [UIFont fontWithName:@"PingFangSC-Regular" size:16]
#define kFont17 [UIFont fontWithName:@"PingFangSC-Regular" size:17]
#define kFont18 [UIFont fontWithName:@"PingFangSC-Regular" size:18]

#pragma mark - 图片
#define kImageNamed(name)       [UIImage imageNamed:name]


static CGFloat const kAptationUIScreen=375.f;
//以iphone8为基准的比例
CG_INLINE CGFloat kRatioScreen(){
    return kScreenWidth/kAptationUIScreen;
}
//以iphone8为基准等比例缩放
CG_INLINE CGFloat kScaleScreen(CGFloat value){
    return value*kRatioScreen();
}

//cell 里面装播放控件的view的tag值
#define kPlayerInCellContainerViewTag  1433423

#pragma mark ===================== 设备判断 ==================================

/* iOS设备 */
#define kDevice_Is_iPhone4s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6PlusBigMode ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen]currentMode].size) : NO)

#define kDevice_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define kDevice_udid [[UIDevice currentDevice].identifierForVendor UUIDString]

//适配参数
#define screenScales (kDevice_Is_iPhone6Plus ?1.12:(kDevice_Is_iPhone6?1.0:(iPhone6PlusBigMode ?1.01:0.85)))//以6为基准图

#define Qukan_SizeRatio               [UIScreen mainScreen].bounds.size.width/375.0

/**
 是否是iPhoneX系列（X/XS/XR/XS Max)
 
 @return YES 是该系列 NO 不是该系列
 */
static inline BOOL isIPhoneXSeries() {
    BOOL iPhoneXSeries = NO;
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return iPhoneXSeries;
    }
    
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            iPhoneXSeries = YES;
        }
    }
    
    return iPhoneXSeries;
}

#endif /* QukanUIMacro_h */
