//
//  CPPrompt.h
//  测试
//
//  Created by lk03 on 2017/7/21.
//  Copyright © 2017年 chenp. All rights reserved.
//


/*
 
 //配置属性
 CPPromptBoxOption *option = [CPPromptBoxOption promptBoxOptionWithClipView:sender];
 
 //初始化
 CPPromptBoxView *PromptBoxView = [CPPromptBoxView promptBoxViewWithOption:option];
 
 //添加数据
 [PromptBoxView addTitles:@[@"nihao",@"ceshi"] images:nil didSelector:^(NSIndexPath *indexPath) {
 //点击回调
 NSLog(@"%@",indexPath);
 
 } cancleSelector:^{
 //取消回调
 NSLog(@">>>>>>");
 
 }];
 
 //显示
 [PromptBoxView showPrompt];
 
 */

#ifndef CPPrompt_h
#define CPPrompt_h

//点击回调
typedef void(^CPPromptBoxClipBlock)(NSIndexPath *indexPath);
//取消回调
typedef void(^CPPromptBoxCancleBlock)();

#import <UIKit/UIKit.h>
#import "CPPromptBoxOption.h"
#import "CPPromptBoxView.h"
#import "CPPromptBox.h"


#define CPPBScreenWidth               [UIScreen mainScreen].bounds.size.width
#define CPPBScreenHeight              [UIScreen mainScreen].bounds.size.height
#define CPPBHeight                    45 //cell默认高度
#define CPPBAnimation_appear          @[@0,@1.2,@1]
#define CPPBAnimation_disappear       @[@1,@1.2,@0]
#define CPPBImage(x)                  [UIImage imageNamed:(x)]



#endif /* CPPrompt_h */
