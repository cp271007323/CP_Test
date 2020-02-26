//
//  QukanTool.m
//  Qukan
//
//  Created by mac on 2018/8/12.
//  Copyright © 2018 Ningbo Suda. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import "QukanYBArchiveUtilHeader.h"
#import "QukanMatchInfoModel.h"
#import "QukanXuanModel.h"
#import "QukanHomeModels.h"
#import "QukanGViewController.h"
#import "QukanRedCardGoalTipsView.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "QukanApiManager+Competition.h"

@implementation QukanSeversTimeModel

@end


@implementation QukanTool

+ (void)Qukan_setIQKeyboardManager {
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    keyboardManager.enable = YES;
    keyboardManager.shouldResignOnTouchOutside = YES;
    keyboardManager.shouldShowToolbarPlaceholder = YES;
    keyboardManager.placeholderFont = [UIFont systemFontOfSize:12];
    keyboardManager.keyboardDistanceFromTextField = 10.0f;
    keyboardManager.toolbarDoneBarButtonItemText = @"完成";
}

+ (UIImage *)Qukan_createImageWithColor:(UIColor *)color {
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
+ (UIImage *)Qukan_imageFromString:(NSString *)string attributes:(NSDictionary *)attributes size:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [string drawInRect:CGRectMake(0, 0, size.width, size.height) withAttributes:attributes];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (NSString *)Qukan_getWeekDay:(NSString*)currentStr {
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate*date =[dateFormat dateFromString:currentStr];
    NSArray*weekdays = [NSArray arrayWithObjects: [NSNull null], @"日",@"一",@"二",@"三",@"四",@"五",@"六",nil];
    NSCalendar*calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone*timeZone = [[NSTimeZone alloc]initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:date];
    return [weekdays objectAtIndex:theComponents.weekday];
}

+ (NSString *)Qukan_getDateDictKeyWithDay:(NSInteger)day {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *todayDateStr = [dateFormatter stringFromDate:[NSDate date]];
    NSString *dataDictKey = [NSString stringWithFormat:@"%@+%ld", todayDateStr, day];
    return dataDictKey;
}

+ (void)Qukan_initLocalData {
     // 设置是否处于提示
    [kUserDefaults setBool:NO forKey:@"voiceIsPlay"];
    
    NSString *goalTipsVoice = [[NSUserDefaults standardUserDefaults] objectForKey:Qukan_GoalTips_Voice_Key];
    if (goalTipsVoice.length==0) {
        //进球提示
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:Qukan_GoalTips_Voice_Key];
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:Qukan_GoalTips_Shock_Key];
        //红牌提示
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:Qukan_RedkaTips_Voice_Key];
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:Qukan_RedkaTips_Shock_Key];
        //提示范围
        [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:Qukan_RangeTips_Shock_Key];
        //是否显示排名
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:Qukan_IsShow_Ranking_Key];
        //是否显示红牌
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:Qukan_IsShow_RedAndYellowka_Key];
    }
}


+ (UIViewController *)Qukan_topViewController {
    UIViewController *resultVC;
    resultVC = [QukanTool Qukan_topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [QukanTool Qukan_topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}
+ (UIViewController *)Qukan_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [QukanTool Qukan_topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [QukanTool Qukan_topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}
+ (CGSize)Qukan_sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
+ (void)Qukan_setFollowWithModel:(QukanMatchInfoContentModel *)model {
    NSArray *followArray = [QukanYBArchiveUtil getObjectsForFlag:@"关注列表" withFilePathName:Qukan_Follow_File_Name_Key];
    NSMutableArray *contentArray = [NSMutableArray array];
    
    if (model.isFollow) {
        if (followArray.count==0) {
            [contentArray addObject:model];
        } else {
            for (QukanMatchInfoContentModel *obj in followArray) {
                if (model.match_id==obj.match_id) {
                    return;
                }
            }
            [contentArray addObjectsFromArray:followArray];
            [contentArray insertObject:model atIndex:0];
        }
        [QukanYBArchiveUtil saveObjects:contentArray forFlag:@"关注列表" withFilePathName:Qukan_Follow_File_Name_Key];
    } else {
        [contentArray addObjectsFromArray:followArray];
        for (QukanMatchInfoContentModel *obj in contentArray) {
            if (obj.match_id==model.match_id) {
                [contentArray removeObject:obj];
                break;
            }
        }
        [QukanYBArchiveUtil saveObjects:contentArray forFlag:@"关注列表" withFilePathName:Qukan_Follow_File_Name_Key];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:Qukan_Follow_NotificationName object:nil];
}
//+ (NSArray *)Qukan_updateFollowWithData:(NSMutableArray *)dataArray {
//    NSMutableArray *contentArray = [dataArray copy];
//    NSArray *followArray = [QukanYBArchiveUtil getObjectsForFlag:@"关注列表" withFilePathName:Qukan_Follow_File_Name_Key];
//    for (QukanMatchInfoModel *model in contentArray) {
//        for (QukanMatchInfoContentModel *model2 in model.dataArray) {
//            model2.isFollow = NO;
//        }
//    }
//    
//    for (QukanMatchInfoContentModel *model in followArray) {
//        for (QukanMatchInfoModel *model2 in contentArray) {
//            for (QukanMatchInfoContentModel *model3 in model2.dataArray) {
//                if (model.match_id==model3.match_id) {
//                    model3.isFollow = YES;
//                }
//            }
//        }
//    }
//    return contentArray;
//}

+ (void)Qukan_requestWithRedkaTipsAndGoalTips {
    [QukanNetworkTool Qukan_GET:@"v3/bf-zq-match/real-time-data" parameters:nil success:^(NSDictionary *response) {
        if ([response[@"status"] integerValue]==200) {
            NSArray *data = (NSArray *)response[@"data"];
//            NSString *rangeTipsShock = [[NSUserDefaults standardUserDefaults] objectForKey:Qukan_RangeTips_Shock_Key];
            NSMutableArray *dataArray = [NSMutableArray array];
//            if ([rangeTipsShock isEqualToString:@"1"]) {
                [dataArray addObjectsFromArray:data];
//            } else {
//                NSArray *followArray = [YBArchiveUtil getObjectsForFlag:@"关注列表" withFilePathName:Qukan_Follow_File_Name_Key];
//                for (QukanMatchInfoContentModel *model in followArray) {
//                    for (NSDictionary *dict in data) {
//                        NSInteger match_id = [dict[@"match_id"] integerValue];
//                        if (model.match_id==match_id) {
//                            [dataArray addObject:dict];
//                        }
//                    }
//                }
//            }
            [[NSNotificationCenter defaultCenter] postNotificationName:Qukan_GoalAndRedka_NotificationName object:nil userInfo:@{@"Content":dataArray}];
            
        }
    } failure:^(NSError *error) {}];
}

+ (void)Qukan_showRedkaTipsAndGoalTipsWithArray:(NSArray *)tipsArray withArray:(NSArray *)originalArray view:(UIView *)view type:(NSInteger)type {
    
    if ([kUserDefaults boolForKey:@"voiceIsPlay"]) return;
    [kUserDefaults setBool:YES forKey:@"voiceIsPlay"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [kUserDefaults setBool:NO forKey:@"voiceIsPlay"];
    });
    
    if (tipsArray.count==0) { return; }
    NSString *RangeTips_Shock = [[NSUserDefaults standardUserDefaults] objectForKey:Qukan_RangeTips_Shock_Key];
    if ([RangeTips_Shock isEqualToString:@"3"]) { return; }
    
    NSMutableArray *followArray = [NSMutableArray array];
    if ([RangeTips_Shock isEqualToString:@"2"]) {
        if (type == 1 || type == 5) {return;} // 1 即时 5 热门  0 关注
        for (QukanMatchInfoContentModel *model in originalArray) {
            for (NSDictionary *dict in tipsArray) {
                QukanMatchInfoContentModel *model2 = dict[@"Model"];
                if (model.match_id==model2.match_id) {
                    [followArray addObject:dict];
                }
            }
        }
    } else {
        [followArray addObjectsFromArray:tipsArray];
    }
    
    BOOL isGoalTips = NO; BOOL isRedkaTips = NO;
    for (NSInteger i=0; i<followArray.count; i++) {
        NSDictionary *dict = followArray[i];
        QukanMatchInfoContentModel *model = dict[@"Model"];
        isGoalTips = [dict[@"GoalTips"] boolValue];
        isRedkaTips = [dict[@"RedTips"] boolValue];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(i*0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [QukanTool Qukan_showViewWithModel:model view:view row:i isGoalTips:isGoalTips];
        });
        if (i==4) { break; }
    }
    
    NSString *goalTipsVoice = [[NSUserDefaults standardUserDefaults] objectForKey:Qukan_GoalTips_Voice_Key];
    NSString *goalTipsShock = [[NSUserDefaults standardUserDefaults] objectForKey:Qukan_GoalTips_Shock_Key];
    NSString *redkaTipsVoice = [[NSUserDefaults standardUserDefaults] objectForKey:Qukan_RedkaTips_Voice_Key];
    NSString *redkaTipsShock = [[NSUserDefaults standardUserDefaults] objectForKey:Qukan_RedkaTips_Shock_Key];
    
    BOOL isPlayVoice = NO;
    BOOL isPlayShock = NO;
    if (isRedkaTips) {
        if ([redkaTipsVoice isEqualToString:@"1"]) {
            isPlayVoice = YES;
        }
        if ([redkaTipsShock isEqualToString:@"1"]) {
            isPlayShock = YES;
        }
    }
    if (isGoalTips) {
        if ([goalTipsVoice isEqualToString:@"1"]) {
            isPlayVoice = YES;
        }
        if ([goalTipsShock isEqualToString:@"1"]) {
            isPlayShock = YES;
        }
    }
    
    //播放声音
    if (isPlayVoice) {
        NSURL *fileUrl = [NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"Qukan_GoalTips" ofType:@"wav"]];
        SystemSoundID soundID = 0;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
        AudioServicesPlaySystemSound(soundID);
    }
    //震动
    if (isPlayShock) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
}


+ (void)Qukan_showViewWithModel:(QukanMatchInfoContentModel *)model view:(UIView *)view row:(NSInteger)row isGoalTips:(BOOL)isGoalTips {
    QukanRedCardGoalTipsView *v = [QukanRedCardGoalTipsView Qukan_initWithXib];
    [v Qukan_setData:model isGoalTips:isGoalTips];
    //    [view addSubview:v];
    UIWindow *window = [[UIApplication sharedApplication] delegate].window;
    [window addSubview:v];
    [window bringSubviewToFront:v];
    
    [v mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(window).mas_offset(20.0);
        make.right.equalTo(window).mas_offset(-20.0);
        make.height.mas_equalTo(60.0);
        make.bottom.mas_equalTo(window.mas_bottom).mas_offset(-row*65.0-(isIPhoneXSeries()?105.0:69.0));
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3 animations:^{
            v.alpha = 0.0;
        } completion:^(BOOL finished) {
            [v removeFromSuperview];
        }];
    });
}

+ (int)Qukan_xuan:(NSString *)val {
    __block int a = 0;
    NSArray *xuans = [kCacheManager QukangetCacheApps];
    [xuans enumerateObjectsUsingBlock:^(QukanXuanModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.val isEqualToString:val]) {
            a = obj.textId;
        }
    }];
    return a;
}


// UIInterfaceOrientationPortrait 竖屏
+ (void)Qukan_interfaceOrientation:(UIInterfaceOrientation)orientation
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector  = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = orientation;
        // 从2开始是因为0 1 两个参数已经被selector和target占用
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

+ (void)Qukan_getUpdateTimeWithBolck:(void (^)(QukanSeversTimeModel * timeModel))timeBlock {
    [[kApiManager Qukan_getDateTime] subscribeNext:^(id  _Nullable x) {
        if ([x isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = x;
            QukanSeversTimeModel *model = [QukanSeversTimeModel modelWithDictionary:dic];
            timeBlock(model);
        }
    }];
}

+ (void)Qukan_JumpWithModel:(QukanHomeModels *)model WithController:(UINavigationController *)nav {
    if ([model.jump_type intValue] == QukanViewJumpType_In) {//内部
        QukanGViewController *vc = [[QukanGViewController alloc] init];
        vc.url = model.v_url;
        vc.hidesBottomBarWhenPushed = YES;
        [nav pushViewController:vc animated:YES];
    } else if ([model.jump_type intValue] == QukanViewJumpType_Out) {//外部
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.v_url]];
    } else if ([model.jump_type intValue] == QukanViewJumpType_AppIn) {
        
    } else if ([model.jump_type intValue] == QukanViewJumpType_Other) {
        QukanGViewController *vc = [[QukanGViewController alloc] init];
        NSString *url = [NSString stringWithFormat:@"%@?adType=%@&bunleId=%@&appKey=%@",model.v_url,model.type,Qukan_AppBundleId,Qukan_OpeninstallKey];
        vc.url = url;
        vc.hidesBottomBarWhenPushed = YES;
        [nav pushViewController:vc animated:YES];
    }
}

+ (NSURL *)Qukan_getImageStr:(NSString *)numerStr {
    NSString *basieUrl = FormatString(@"http://api2.jinribifenjiekou.com/%@", kGetImageType(22));
    NSURL *imgUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@.png",basieUrl,numerStr]];
    return imgUrl;
}

@end
