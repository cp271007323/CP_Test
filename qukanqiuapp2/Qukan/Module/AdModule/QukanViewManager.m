//
//  QukanViewManager.m
//  Qukan
//
//  Created by Kody on 2019/8/13.
//  Copyright © 2019 Ningbo Suda. All rights reserved.
//


#import "QukanPopup.h"
#import <HBDNavigationBar/HBDNavigationController.h>
#import "QukanHomeModels.h"
#import "QukanGViewController.h"
#import "QukanApiManager+info.h"
#import "QukanPopView.h"

@interface QukanViewManager ()

@property(nonatomic, strong) NSArray   *datas;
@property(nonatomic, strong) NSArray   *source;

@end

@implementation QukanViewManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static QukanViewManager *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}


- (void)setup {
    //设置你工程的启动页使用的是:LaunchImage 还是 LaunchScreen.storyboard(不设置默认:LaunchImage)
    [QukanPopup setLaunchSourceType:SourceTypeLaunchScreen];
    // 设置数据请求等待时间
    [QukanPopup setWaitDataDuration:3];
    
    NSArray *ads = [kCacheManager QukangetCacheAds];
    if (ads.count) {
        [self adStartWithData:ads];
    }
    self.source = ads;
    
    [self Qukan_newsChannelHomePage];

}

- (void)QukanInfoWithArray:(NSArray *)ads {
    @weakify(self)
    [[[kApiManager QukanInfoWithType:14] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        NSArray *datas = (NSArray *)x;
        if (!datas.count) {
            [kCacheManager QukancacheAdStartListDataWithDatas:self.datas];
            return;
        }
        self.datas = [NSArray modelArrayWithClass:[QukanHomeModels class] json:datas];
        if (!ads.count) {
            [self adStartWithData:self.datas];
        }
        //缓存图片或者更新缓存图片
        [kCacheManager QukancacheAdStartListDataWithDatas:self.datas];
    } error:^(NSError * _Nullable error) {
        [kCacheManager QukancacheAdStartListDataWithDatas:self.datas];
    }];
}


- (void)Qukan_newsChannelHomePage {
    @weakify(self)
    [[[kApiManager QukanInfoWithType:15] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self dataSourceWith:x];
        [self QukanInfoWithArray:self.source];
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        [self QukanInfoWithArray:self.source];
    }];
}

- (void)dataSourceWith:(id)respone {
    NSArray *datas = (NSArray *)respone;
    if (!datas.count) {return;}
    int rac = arc4random() % datas.count;
    NSDictionary *dict = datas[rac];
    QukanHomeModels *model = [QukanHomeModels modelWithDictionary:dict];
    [self setPopupViewWithModel:model];
}

- (void)setPopupViewWithModel:(QukanHomeModels *)model {
    QukanPopView *popUpView = [[QukanPopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) WithModel:model];
    popUpView.center = kKeyWindow.center;
}

- (void)adStartWithData:(NSArray *)datas {
    int rac = arc4random() % datas.count;
    QukanHomeModels *model = datas[rac];
    XHLaunchImageLoadConfiguration *imageAdconfiguration = [XHLaunchImageLoadConfiguration new];
    imageAdconfiguration.duration = 3;
    imageAdconfiguration.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    imageAdconfiguration.imageNameOrURLString = model.image;//model.content
    imageAdconfiguration.GIFImageCycleOnce = NO;
    imageAdconfiguration.imageOption = QukanPopupImageDefault;
    imageAdconfiguration.contentMode = UIViewContentModeScaleAspectFill;
    imageAdconfiguration.openModel = model;
    imageAdconfiguration.showFinishAnimate = ShowFinishAnimateLite;
    imageAdconfiguration.showFinishAnimateTime = 1.0;
    imageAdconfiguration.skipButtonType = SkipTypeTimeText;
    imageAdconfiguration.showEnterForeground = NO;
    
    [QukanPopup imageWithImageConfiguration:imageAdconfiguration delegate:self];
}

-(void)xhLaunchAd:(QukanPopup *)launchAd clickAndOpenModel:(id)openModel clickPoint:(CGPoint)clickPoint{
    if(openModel==nil) return;
    QukanHomeModels *adModel = openModel;
    if ([adModel.jump_type intValue] == QukanViewJumpType_In) {//内部
        QukanGViewController *vc = [[QukanGViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.url = adModel.v_url;
        UITabBarController *tabBarController = (UITabBarController *)kKeyWindow.rootViewController;
        if (tabBarController.selectedIndex < tabBarController.viewControllers.count) {
            HBDNavigationController *pushNavVc = (HBDNavigationController *)tabBarController.viewControllers[tabBarController.selectedIndex];
            [pushNavVc pushViewController:vc animated:YES];
        } else {
            vc.isPresentPush = YES;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            [UIApplication.sharedApplication.delegate.window.rootViewController presentViewController:nav animated:YES completion:nil];
        }
        [kNotificationCenter postNotificationName:Qukan_adDidCilck object:nil];
    } else if ([adModel.jump_type intValue] == QukanViewJumpType_Out) {//外部
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:adModel.v_url]];
    } else if ([adModel.jump_type intValue] == QukanViewJumpType_AppIn ) {
        
    } else if ([adModel.jump_type intValue] == QukanViewJumpType_Other ) {
        QukanGViewController *vc = [[QukanGViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        NSString *url = [NSString stringWithFormat:@"%@?adType=%@&bunleId=%@&appKey=%@",adModel.v_url,adModel.type,Qukan_AppBundleId,Qukan_OpeninstallKey];
        vc.url = url;
        UITabBarController *tabBarController = (UITabBarController *)kKeyWindow.rootViewController;
        if (tabBarController.selectedIndex < tabBarController.viewControllers.count) {
            HBDNavigationController *pushNavVc = (HBDNavigationController *)tabBarController.viewControllers[tabBarController.selectedIndex];
            [pushNavVc pushViewController:vc animated:YES];
        } else {
            vc.isPresentPush = YES;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            [UIApplication.sharedApplication.delegate.window.rootViewController presentViewController:nav animated:YES completion:nil];
        }
        [kNotificationCenter postNotificationName:Qukan_adDidCilck object:nil];
    }
}


-(void)batchDownloadImageAndCache{
    [QukanPopup downLoadImageAndCacheWithURLArray:self.datas completed:^(NSArray * _Nonnull completedArray) {
    }];
}

//- (void)takeWithType:(NSInteger)type {
//    QukanHomeModels *model = self.datas.count ? self.datas.firstObject : nil;
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.v_url]];
//}


@end
