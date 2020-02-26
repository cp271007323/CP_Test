//
//  QukanXLChannelHeaderView.h
//  QukanXLChannelControlDemo
//
//  Created by MengXianLiang on 2017/3/3.
//  Copyright © 2017年 MengXianLiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QukanXLChannelHeader : UICollectionReusableView

@property (copy,nonatomic) NSString *title;

@property (copy,nonatomic) NSString *subTitle;

@property(nonatomic, strong) UIButton *completeButton;

@property(nonatomic, copy) void(^completeButton_didSeleBlock)(void);

@end
