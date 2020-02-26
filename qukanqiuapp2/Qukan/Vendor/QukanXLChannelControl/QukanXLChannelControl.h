//
//  QukanXLChannelControl.h
//  QukanXLChannelControlDemo
//
//  Created by MengXianLiang on 2017/3/3.
//  Copyright © 2017年 MengXianLiang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^XLChannelBlock)(NSArray *enabledTitles,NSArray *disabledTitles);

@interface QukanXLChannelControl : NSObject

+ (QukanXLChannelControl*)shareControl;

@property (nonatomic, copy) XLChannelBlock block;

- (void)showChannelViewWithEnabledTitles:(NSArray*)enabledTitles disabledTitles:(NSArray*)disabledTitles finish:(XLChannelBlock)block;

@end
